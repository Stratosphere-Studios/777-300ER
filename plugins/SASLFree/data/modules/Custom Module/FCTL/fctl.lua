--[[
*****************************************************************************************
* Script Name: fctl
* Author Name: @bruh
* Script Description: Code for flight controls.
*****************************************************************************************
--]]

addSearchPath(moduleDirectory .. "/Custom Module/")

include("misc_tools.lua")

--getting all of the xplane datarefs

fctl_ovrd = globalPropertyf("sim/operation/override/override_control_surfaces") --for overriding default xp11 flight controls
outbd_ail_L = globalPropertyfae("sim/flightmodel2/wing/aileron1_deg", 1) --make separate datarefs for inboard and outboard ailerons
outbd_ail_R = globalPropertyfae("sim/flightmodel2/wing/aileron2_deg", 1)
spoilers_L = globalPropertyfae("sim/flightmodel2/wing/spoiler1_deg", 1)
spoilers_R = globalPropertyfae("sim/flightmodel2/wing/spoiler2_deg", 1)
flaps = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 1)
elevator = globalPropertyfae("sim/flightmodel2/wing/elevator1_deg",1)
rudder = globalPropertyfae("sim/flightmodel2/wing/rudder1_deg", 1)
yoke_roll_ratio = globalPropertyf("sim/cockpit2/controls/yoke_roll_ratio")
yoke_pitch_ratio = globalPropertyf("sim/cockpit2/controls/yoke_pitch_ratio")
yoke_heading_ratio = globalPropertyf("sim/cockpit2/controls/yoke_heading_ratio")
tas = globalPropertyf("sim/flightmodel/position/true_airspeed") --true airspeed in meters per second. Needed for accurate drooping

--creating our own datarefs

hyd_load = createGlobalPropertyfa("Strato/777/hydraulics/load", {0, 0, 0, 0, 0, 0, 0})
hyd_load_total = createGlobalPropertyf("Strato/777/hydraulics/load_total", 0)
flap_tgt = createGlobalPropertyf("Strato/777/flaps/tgt", 0)
flap_load_relief = createGlobalPropertyi("Strato/777/flaps/load_relief", 0) --set to 1 when load relief system is operating

set(fctl_ovrd, 1)

function UpdateLoad()
	local l = 0
	for i=1,7 do
		hyd_load = globalPropertyfae("Strato/777/hydraulics/load", i)
		l = l + get(hyd_load)
	end
	set(hyd_load_total, l)
end

function GetMaxHydPress() --since some things are driven by all 3 hydraulic systems, we need to know the maximum pressure
	local pressure_L = globalPropertyiae("Strato/777/hydraulics/press", 1)
	local pressure_C = globalPropertyiae("Strato/777/hydraulics/press", 2)
	local pressure_R = globalPropertyiae("Strato/777/hydraulics/press", 3)
	return math.max(get(pressure_L), get(pressure_C), get(pressure_R))
end

function GetAilRatio(ratio) --Aileron ratio gets smaller with hydraulic pressure. This is needed for morer precise simulation when the pressure is low.
	local max_press = GetMaxHydPress()
	if max_press <= 500 then
		return 0
	elseif max_press >= 2500 then
		return ratio
	else
		return ratio * (max_press - 500) / 2000
	end
end

function GetAilNeutral(side, ratio)
	if get(tas) < 25.7 and GetMaxHydPress() < 2500 then
		return side * (-(ratio * get(tas) / 51.4) + 18 - ratio / 2)
	else
		return 0
	end
end

function GetAilResponseTime() --aileron response time based on pressure
	local pressure = GetMaxHydPress()
	if pressure > 2000 then
		return pressure * 7 / 3340
	else
		return 1
	end
end

function GetAilTarget(side, yoke_cmd)
	local ail_ratio = GetAilRatio(36)
	local ail_neutral = GetAilNeutral(side, ail_ratio)
	local h_load = globalPropertyfae("Strato/777/hydraulics/load", 3)
	if side == 1 then
		h_load = globalPropertyfae("Strato/777/hydraulics/load", 4)
	end
	if ail_ratio > 0 then
		set(h_load, math.abs((ail_ratio / 2) * yoke_cmd) * (0.3 / ail_ratio))
	else
		set(h_load, 0)
	end
	return ail_neutral + (ail_ratio / 2) * yoke_cmd
end

function GetRudderRatio()
	ratio = GetAilRatio(54)
	if IsAcConnected() == 1 then
		tas_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/true_airspeed_kts_pilot")
		tas_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/true_airspeed_kts_copilot")
		if math.abs(get(tas_pilot) - get(tas_copilot)) < 15 then --If airspeed provided by the sensors is reliable, modify ratio based on the formula
			if get(tas_pilot) > 135 and get(tas_pilot) >= 269 then
				return ratio - (get(tas_pilot) - 135) * (36 / 115)
			elseif get(tas_pilot) > 269 then
				return 12
			end
		else
			if get(flaps) <= 1 then --If rudder ratio changer is in the degraded mode, there are only 2 ratios: 1.0 with flaps extended, 0.5 with flaps retracted
				return ratio * 0.5
			end
		end
	end
	return ratio
end

function GetSpoilerTarget(side, yoke_cmd) --behavior for spoilers
	local actual = 0
	local h_load = globalPropertyfae("Strato/777/hydraulics/load", 1)
	if side == -1 then
		actual = get(spoilers_L)
	else
		actual = get(spoilers_R)
		h_load = globalPropertyfae("Strato/777/hydraulics/load", 2)
	end
	local handle_pos = globalPropertyf("sim/cockpit2/controls/speedbrake_ratio")
	local true_airspeed = get(tas)
	local max_press = GetMaxHydPress()
	local neutral = 0
	if get(handle_pos) > 0 and max_press >= 570 then
		neutral = get(handle_pos) * 20
	elseif max_press < 570 then
		if true_airspeed >= 61 then
			neutral = 0
		elseif true_airspeed < 51 and true_airspeed >= 41 then --this is for transition when the airflow becomes fast enough to move spoilers
			neutral = actual * math.abs(61 - true_airspeed) / 20
		else
			neutral = actual
		end
	end
	if yoke_cmd * side > 0.4 and max_press >= 570 and true_airspeed < 430 then --when deflecting ailerons is not enough, deflect spoilers
		local tgt = neutral + ((yoke_cmd * side - 0.4) / 0.6) * (20 - neutral)
		set(h_load, math.abs(tgt - neutral) * 0.0075)
		return tgt
	else
		if max_press > 100 then
			set(h_load, math.abs(actual - neutral) * 0.0075)
		else
			set(h_load, 0)
		end
		return neutral
	end
end

function GetSpoilerResponseTime() --Spoiler response time that is influenced by hydraulic pressure
	local pressure = GetMaxHydPress()
	local speed = get(tas)
	if pressure > 2000 and speed < 149 then
		return pressure * 7 / 3340
	elseif pressure >= 570 and pressure <= 2000 then
		return pressure * 2 / 3340
	else
		return 1
	end
end

function SetFlapTarget()
	flap_settings = {0, 1, 5, 15, 20, 25, 30}
	detents = {0, 0.17, 0.33, 0.5, 0.67, 0.83, 1}
	tas_limits = {-1, 136, 126, 118, 115, 102, 93} --limits in meters per second for load relief system
	local sys_C_press = globalPropertyiae("Strato/777/hydraulics/press", 2)
	local h_load = globalPropertyfae("Strato/777/hydraulics/load", 5)
	if get(sys_C_press) >= 1000 then
		local handle_pos = globalPropertyf("sim/cockpit2/controls/flap_ratio")
		local flap_pos = get(flaps)
		local index = indexOf(detents, get(handle_pos), 1)
		if index ~= nil then
			if get(tas) > tas_limits[index] and tas_limits[index] ~= -1 then --load relief system only triggers with flaps 15 or below
				if get(flap_load_relief) ~= 1 then
					set(flap_load_relief, 1)
				end
				if get(flap_pos) > 5 then
					for i = index,3,-1 do
						if tas_limits[i] > get(tas) or i == 3 then --load relief retraction is limited to flap 5 idk why but the fcom says it
							set(flap_tgt, flap_settings[i])
							break
						end
					end
				end
			else
				if get(flap_load_relief) ~= 0 then
					set(flap_load_relief, 0)
				end
				set(flap_tgt, flap_settings[index])
			end
		else
			set(flap_tgt, get(flaps))
		end
	else
		set(flap_tgt, get(flaps))
	end
	if get(flap_tgt) ~= get(flaps) then --update load dataref
		set(h_load, 0.2)
	else
		set(h_load, 0)
	end
end

function GetFlapResponseTime() --Flap response time that is influenced by hydraulic pressure
	flap_settings = {0, 1, 5, 15, 20, 25, 30}
	local target = get(flap_tgt)
	local actual = get(flaps)
	local sys_C_press = globalPropertyiae("Strato/777/hydraulics/press", 2)
	if target ~= actual then
		if math.abs(target-actual) < 0.1 then
			return 30
		else
			return 1 * (get(sys_C_press) / 3340) / math.abs(target - actual)
		end
	else
		return 1
	end
end

function GetElevatorTarget(yoke_cmd)
	local h_load = globalPropertyfae("Strato/777/hydraulics/load", 6)
	local elevator_ratio = GetAilRatio(40)
	if elevator_ratio > 0 then
		set(h_load, math.abs((elevator_ratio / 2) * yoke_cmd * (0.3 / elevator_ratio)))
	else
		set(h_load, 0)
	end
	return (elevator_ratio / 2) * yoke_cmd * -1
end

function GetRudderTarget(yoke_cmd)
	local h_load = globalPropertyfae("Strato/777/hydraulics/load", 7)
	local rud_ratio = GetRudderRatio()
	if rud_ratio > 0 then
		set(h_load, math.abs((rud_ratio / 2) * yoke_cmd) * (0.3 / rud_ratio))
	else
		set(h_load, 0)
	end
	return (rud_ratio / 2) * yoke_cmd
end

--these functions set a bunch of datarefs for flight controls to the same value. I guess this is needed because of something in plane maker

function UpdateElevator(value)
	for i=1,10 do
		local elev = globalPropertyfae("sim/flightmodel2/wing/elevator1_deg", i)
		set(elev, value)
	end
end

function UpdateAileron(value, side, f_type)
	local ail = globalPropertyfae("sim/flightmodel2/wing/aileron1_deg", 1)
	for i=1,12 do
		if side == -1 then
			if f_type == 2 then
				ail = globalPropertyfae("sim/flightmodel2/wing/rudder1_deg", i)
			else
				ail = globalPropertyfae("sim/flightmodel2/wing/aileron1_deg", i)
			end
		else
			if f_type == 2 then
				ail = globalPropertyfae("sim/flightmodel2/wing/rudder1_deg", i)
			else
				ail = globalPropertyfae("sim/flightmodel2/wing/aileron2_deg", i)
			end
		end
		if i % 2 ~= 0 then
			set(ail, value)
		else
			set(ail, -value)
		end
	end
end

function UpdateSpoilers(value, side)
	for i=1,10 do
		if i % 2 == 1 then
			if side == -1 then
				local spoiler = globalPropertyfae("sim/flightmodel2/wing/spoiler1_deg", i)
				set(spoiler, value)
			else
				local spoiler = globalPropertyfae("sim/flightmodel2/wing/spoiler2_deg", i)
				set(spoiler, value)
			end
		end
	end
end

function UpdateFlaps(value)
	for i=1,10 do
		local flap = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", i)
		set(flap, value)
	end
end

function update()
	UpdateLoad()
	local f_time = globalPropertyf("sim/operation/misc/frame_rate_period")
	local rud_ratio = GetRudderRatio()
	local elevator_target = GetElevatorTarget(get(yoke_pitch_ratio))
	local L_ail_target = GetAilTarget(-1, get(yoke_roll_ratio))
	local R_ail_target = GetAilTarget(1, get(yoke_roll_ratio))
	local L_spoiler_target = GetSpoilerTarget(-1, get(yoke_roll_ratio))
	local R_spoiler_target = GetSpoilerTarget(1, get(yoke_roll_ratio))
	local rud_target = GetRudderTarget(get(yoke_heading_ratio))
	local ail_response_time = GetAilResponseTime()
	local spoiler_response_time = GetSpoilerResponseTime()
	SetFlapTarget()
	local flap_time = GetFlapResponseTime()
	UpdateAileron(get(outbd_ail_L)+(L_ail_target - get(outbd_ail_L))*get(f_time)*ail_response_time, -1, 1) --these ginormous formulas are for smooth transitions
	UpdateAileron(get(outbd_ail_R)+(R_ail_target - get(outbd_ail_R))*get(f_time)*ail_response_time, 1, 1)
	UpdateAileron(get(rudder)+(rud_target - get(rudder))*get(f_time)*ail_response_time, 1, 2)
	UpdateSpoilers(get(spoilers_L)+(L_spoiler_target - get(spoilers_L))*get(f_time)*spoiler_response_time, -1)
	UpdateSpoilers(get(spoilers_R)+(R_spoiler_target - get(spoilers_R))*get(f_time)*spoiler_response_time, 1)
	UpdateFlaps(get(flaps)+(get(flap_tgt) - get(flaps)) * get(f_time) * flap_time)
	UpdateElevator(get(elevator)+(elevator_target - get(elevator)) * get(f_time) * ail_response_time)
end