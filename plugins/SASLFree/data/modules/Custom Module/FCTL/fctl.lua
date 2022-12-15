--[[
*****************************************************************************************
* Script Name: fctl
* Author Name: @bruh
* Script Description: Code for flight controls.
*****************************************************************************************
--]]

addSearchPath(moduleDirectory .. "/Custom Module/")

include("misc_tools.lua")

--Finding sim datarefs

--Cockpit controls
speedbrake_handle = globalPropertyf("sim/cockpit2/controls/speedbrake_ratio")
yoke_roll_ratio = globalPropertyf("sim/cockpit2/controls/yoke_roll_ratio")
yoke_pitch_ratio = globalPropertyf("sim/cockpit2/controls/yoke_pitch_ratio")
yoke_heading_ratio = globalPropertyf("sim/cockpit2/controls/yoke_heading_ratio")
throttle_pos = globalPropertyf("sim/cockpit2/engine/actuators/throttle_jet_rev_ratio_all")
--Indicators
ra_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")
ra_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_copilot")
altitude_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/altitude_ft_pilot")
altitude_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/altitude_ft_copilot")
altitude_stdby = globalPropertyf("sim/cockpit2/gauges/indicators/altitude_ft_stby")
tas_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/true_airspeed_kts_pilot")
cas_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
tas_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/true_airspeed_kts_copilot")
cas_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_copilot")
--Weather and position
ac_heading = globalPropertyf("sim/flightmodel/position/magpsi")
wind_dir = globalPropertyf("sim/weather/wind_direction_degt")
wind_speed = globalPropertyf("sim/weather/wind_speed_kt") --this is in meters per second
tas = globalPropertyf("sim/flightmodel/position/true_airspeed") --true airspeed in meters per second. Needed for accurate drooping
--Flight controls
outbd_ail_L = globalPropertyfae("sim/flightmodel2/wing/aileron2_deg", 5)
inbd_ail_L = globalPropertyfae("sim/flightmodel2/wing/aileron1_deg", 1)
outbd_ail_R = globalPropertyfae("sim/flightmodel2/wing/aileron2_deg", 6)
inbd_ail_R = globalPropertyfae("sim/flightmodel2/wing/aileron1_deg", 2)
spoiler_L1 = globalPropertyfae("sim/flightmodel2/wing/spoiler1_deg", 3)
spoiler_L2 = globalPropertyfae("sim/flightmodel2/wing/spoiler2_deg", 3)
spoiler_R1 = globalPropertyfae("sim/flightmodel2/wing/spoiler1_deg", 4)
spoiler_R2 = globalPropertyfae("sim/flightmodel2/wing/spoiler2_deg", 4)
flaps = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 3)
inbd_flap_L = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 1)
inbd_flap_R = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 2)
outbd_flap_L = globalPropertyfae("sim/flightmodel2/wing/flap2_deg", 3)
outbd_flap_R = globalPropertyfae("sim/flightmodel2/wing/flap2_deg", 4)
slat_1 = globalPropertyf("sim/flightmodel2/controls/slat1_deploy_ratio")
slat_2 = globalPropertyf("sim/flightmodel2/controls/slat2_deploy_ratio")
elevator_L = globalPropertyfae("sim/flightmodel2/wing/elevator1_deg",1)
elevator_R = globalPropertyfae("sim/flightmodel2/wing/elevator1_deg",7)
upper_rudder = globalPropertyfae("sim/flightmodel2/wing/rudder1_deg", 12)
bottom_rudder = globalPropertyfae("sim/flightmodel2/wing/rudder2_deg", 12)
--Reversers
L_reverser_deployed = globalPropertyiae("sim/cockpit2/annunciators/reverser_on", 1)
L_reverser_fail = globalPropertyi("sim/operation/failures/rel_revers0")
R_reverser_deployed = globalPropertyiae("sim/cockpit2/annunciators/reverser_on", 2)
R_reverser_fail = globalPropertyi("sim/operation/failures/rel_revers1")
--Operation
f_time = globalPropertyf("sim/operation/misc/frame_rate_period")
on_ground = globalPropertyi("sim/flightmodel/failures/onground_any")

pfc_roll_command = globalPropertyf("Strato/777/fctl/pfc/roll")
pfc_elevator_command = globalPropertyf("Strato/777/fctl/pfc/elevator")
pfc_rudder_command = globalPropertyf("Strato/777/fctl/pfc/rudder")
fbw_ail_ratio = globalPropertyf("Strato/777/fctl/ail_ratio")
fbw_flprn_ratio_l = globalPropertyf("Strato/777/fctl/flprn_ratio_l")
fbw_flprn_ratio_u = globalPropertyf("Strato/777/fctl/flprn_ratio_u")

--creating our own datarefs

--pcu modes: 
--0 - bypass
--1 - normal for flaperons, blocking for elevators
--2 - normal for elevators

pcu_mode_flprn = createGlobalPropertyia("Strato/777/fctl/flprn/pcu_mode", {0, 0})
pcu_mode_elevator = createGlobalPropertyia("Strato/777/fctl/elevator/pcu_mode", {0, 0})

--load indexation:
--1, 2 - spoilers
--3, 4 - ailerons
--5 - elevators
--6 - rudder
--7 - flaps
--8 - gear steering
--9 - gear deployment/retraction
--10, 11 - left and right reversers respectively

hyd_load = createGlobalPropertyfa("Strato/777/hydraulics/load", {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
flap_tgt = globalPropertyf("Strato/777/flaps/tgt")
flap_load_relief = createGlobalPropertyi("Strato/777/flaps/load_relief", 0) --set to 1 when load relief system is operating

flap_settings = {0, 1, 5, 15, 20, 25, 30}
ace_smooth = false

function GetClosestFlapSetting()
	local tmp = 1
	for i=1,7 do
		tmp = tmp + 1
		if flap_settings[i] >= get(flaps) then
			return i
		end
	end
	return tmp
end

function UpdateFlprnPCUMode(num, hyd_sys)
	local mode = globalPropertyiae("Strato/777/fctl/flprn/pcu_mode", num)
	local press = {0, 0}
	for i=1,tlen(hyd_sys) do
		local h_press = globalPropertyiae("Strato/777/hydraulics/press", hyd_sys[i])
		press[i] = get(h_press)
	end
	local press = math.max(unpack(press))
	if press >= 200 and IsAcConnected() == 1 then
		local flt_phase = GetFltState()
		if flt_phase == 1 and get(tas) < 51.4 then --set bypass mode until 100 ktas on takeoff
			set(mode, 0)
		else
			set(mode, 1)
		end
	else
		set(mode, 0)
	end
end

function UpdateElevatorPCUMode(num, hyd_sys, el_pos)
	local mode = globalPropertyiae("Strato/777/fctl/elevator/pcu_mode", num)
	local press = {0, 0}
	for i=1,tlen(hyd_sys) do
		local h_press = globalPropertyiae("Strato/777/hydraulics/press", hyd_sys[i])
		press[i] = get(h_press)
	end
	local press = math.max(unpack(press))
	if press < 1000 then
		if math.abs(el_pos) <= 2 then --blocking mode activates when elevator is withing 2 degrees of neutral
			set(mode, 1)
		else
			set(mode, 0)
		end
	else
		set(mode, 2)
	end
end

function GetMaxHydPress() --since some things are driven by all 3 hydraulic systems, we need to know the maximum pressure
	local pressure_L = globalPropertyiae("Strato/777/hydraulics/press", 1)
	local pressure_C = globalPropertyiae("Strato/777/hydraulics/press", 2)
	local pressure_R = globalPropertyiae("Strato/777/hydraulics/press", 3)
	return math.max(get(pressure_L), get(pressure_C), get(pressure_R))
end

function UpdateReversers()
	local pressure_L = globalPropertyiae("Strato/777/hydraulics/press", 1)
	local h_load_L = globalPropertyfae("Strato/777/hydraulics/load", 10)
	local pressure_R = globalPropertyiae("Strato/777/hydraulics/press", 3)
	local h_load_R = globalPropertyfae("Strato/777/hydraulics/load", 11)
	set(L_reverser_fail, 6 * bool2num(get(pressure_L) < 300 or get(on_ground) == 0))
	set(h_load_L, 0.2 * bool2num(get(pressure_L) > 300) * get(L_reverser_deployed))
	set(R_reverser_fail, 6 * bool2num(get(pressure_R) < 300 or get(on_ground) == 0))
	set(h_load_R, 0.2 * bool2num(get(pressure_R) > 300) * get(R_reverser_deployed))
end

--Ailerons

function GetAilRatio(ratio, hyd_sys, hyd_press, pcu_mode, down_cmd, v_dir) --Aileron ratio gets smaller with hydraulic pressure. This is needed for morer precise simulation when the pressure is low.
	if pcu_mode == 1 then
		local press = {0, 0}
		if hyd_sys[1] == 4 then
			press[1] = GetMaxHydPress()
		else
			for i=1,tlen(hyd_sys) do
				local h_press = globalPropertyiae("Strato/777/hydraulics/press", hyd_sys[i])
				press[i] = get(h_press)
			end
		end
		local max_press = math.max(unpack(press))
		if max_press <= hyd_press * 0.2 then
			return 0
		elseif max_press >= hyd_press then --v_dir is needed if we want to obtain 2 separate ratios for 1 surface
			return ratio + down_cmd * v_dir --down_cmd is how much the flybywire changed neutral. Used on flaperons and ailerons
		else
			return (ratio + down_cmd * v_dir) * max_press / hyd_press
		end
	end
	return 0
end

function GetDownCmd(pcu_mode, f_type) --Change of neutral by flybywire
	ail_neutral = {0, 0, -5, -5, -5, 0, 0}
	flprn_neutral = {0, 0, -5, -14, -16, -29, -29}
	if get(speedbrake_handle) <= 0 and pcu_mode == 1 and get(flaps) > 0 then
		local closest = lim(GetClosestFlapSetting(), 1, 7)
		local closest_2 = lim(closest - 1, 1, 7)
		local val_nml = (get(flaps) - flap_settings[closest_2]) / (flap_settings[closest] - flap_settings[closest_2])
		if f_type == 1 then
			return -1 * (ail_neutral[closest_2] + (ail_neutral[closest] - ail_neutral[closest_2]) * val_nml)
		else
			return -1 * (flprn_neutral[closest_2] + (flprn_neutral[closest] - flprn_neutral[closest_2]) * val_nml)
		end
	end
	return 0
end

function GetAilNeutral(side, ratio, hyd_sys, pcu_mode, f_type, down_cmd)
	local press = {0, 0}
	if hyd_sys[1] == 4 then
		press[1] = GetMaxHydPress()
	else
		for i=1,tlen(hyd_sys) do
			local h_press = globalPropertyiae("Strato/777/hydraulics/press", hyd_sys[i])
			press[i] = get(h_press)
		end
	end
	if get(tas) < 25.7 and math.max(unpack(press)) * pcu_mode < 2500 then
		if f_type == 2 then
			return (-(ratio * get(tas) / 51.4) + 40 - ratio) --drooping for flaperons
		end
	else
		return down_cmd
	end
	return 0
end

function GetAilResponseTime(hyd_sys, pcu_mode) --aileron response time based on pressure
	if pcu_mode == 1 then
		local press = {0, 0}
		if hyd_sys[1] == 4 then
			press[1] = GetMaxHydPress()
		else
			for i=1,tlen(hyd_sys) do
				local h_press = globalPropertyiae("Strato/777/hydraulics/press", hyd_sys[i])
				press[i] = get(h_press)
			end
		end
		local pressure = math.max(unpack(press))
		if pressure > 2000 then
			return pressure * 2 / 3340
		end
	end
	return 0.8
end

function GetAilTarget(side, yoke_cmd, t, hyd_sys, pcu_mode, f_type)
	local ail_neutral = 0
	local ail_ratio = 0
	local ail_ratio_lower = 0
	local ail_ratio_upper = 0
	local s_idx = 3
	if side == 1 then
		s_idx = 4
	end
	local dn_cmd = GetDownCmd(pcu_mode, f_type)
	if t == 1 then
		--obtaining aileron characterristics
		ail_ratio_lower = GetAilRatio(get(fbw_ail_ratio) / 2, hyd_sys, 2500, pcu_mode, dn_cmd, -1)
		ail_ratio_upper = GetAilRatio(get(fbw_ail_ratio) / 2, hyd_sys, 2500, pcu_mode, dn_cmd, 1)
		ail_neutral = GetAilNeutral(side, ail_ratio, hyd_sys, pcu_mode, f_type, dn_cmd)
	else
		--obtaining flaperon characterristics
		ail_ratio_upper = GetAilRatio(get(fbw_flprn_ratio_u), hyd_sys, 2500, pcu_mode, dn_cmd, 1)
		ail_ratio_lower = GetAilRatio(get(fbw_flprn_ratio_l), hyd_sys, 2500, pcu_mode, dn_cmd, -1)
		ail_neutral = GetAilNeutral(side, ail_ratio_lower, hyd_sys, pcu_mode, f_type, dn_cmd)
	end
	--Updating load
	local h_load = globalPropertyfae("Strato/777/hydraulics/load", s_idx)
	if ail_ratio > 0 then
		set(h_load, math.abs(ail_ratio * yoke_cmd * 0.3) / (ail_ratio * 2))
	else
		set(h_load, 0)
	end
	--Outputting target
	if yoke_cmd * side < 0 then
		return ail_neutral + ail_ratio_upper * yoke_cmd * side
	else
		return ail_neutral + ail_ratio_lower * yoke_cmd * side
	end
end

--Spoilers

function GetSpoilerTarget(side, yoke_cmd) --behavior for spoilers
	local actual = 0
	local h_load = globalPropertyfae("Strato/777/hydraulics/load", 1)
	if side == -1 then
		actual = get(spoiler_L1)
	else
		actual = get(spoiler_R1)
		h_load = globalPropertyfae("Strato/777/hydraulics/load", 2)
	end
	local true_airspeed = get(tas)
	local max_press = GetMaxHydPress()
	local neutral = 0
	if get(speedbrake_handle) > 0 and max_press >= 570 then
		neutral = get(speedbrake_handle) * 20
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
		set(h_load, tgt * 0.0075)
		return tgt
	else
		if max_press > 100 then
			set(h_load, actual * 0.0075)
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

--Flaps

function SetFlapTarget()
	detents = {0, 0.17, 0.33, 0.5, 0.67, 0.83, 1}
	tas_limits = {-1, 136, 126, 118, 115, 102, 93} --limits in meters per second for load relief system
	local sys_C_press = globalPropertyiae("Strato/777/hydraulics/press", 2)
	local h_load = globalPropertyfae("Strato/777/hydraulics/load", 7)
	if get(sys_C_press) >= 1000 then
		local handle_pos = globalPropertyf("sim/cockpit2/controls/flap_ratio")
		local flap_pos = get(flaps)
		local index = indexOf(detents, get(handle_pos), 1)
		if index ~= nil then
			if get(tas) > tas_limits[index] and get(handle_pos) >= 0.5 or (get(handle_pos) > 0 and flap_pos == 0 and get(tas) > 140 and (get(altitude_pilot) >= 20000 or get(altitude_copilot) >= 20000 or get(altitude_stdby) >= 20000)) then --load relief system only triggers with flaps 15 or below
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

function GetFlapCurrent()
	flap_times = {0.4, 1.4, 8, 4.8, 1.9, 3.17}
	local target = get(flap_tgt)
	local actual = get(flaps)
	local closest = lim(GetClosestFlapSetting(), 7, 2)
	local step = flap_times[closest - 1] * 0.004
	if math.abs(target - actual) <= step then
		return target
	else
		return actual + step * (-bool2num(target < actual) + bool2num(target > actual)) * get(f_time) / 0.0166
	end
end

--Elevator

function GetElevatorTarget(hyd_sys, yoke_cmd, pcu_mode)
	local h_load = globalPropertyfae("Strato/777/hydraulics/load", 5)
	local elevator_ratio = GetAilRatio(40, hyd_sys, 1000, 1, 0, 0)
	--Update load
	if elevator_ratio > 0 then
		set(h_load, math.abs((elevator_ratio * yoke_cmd * 0.3) / (elevator_ratio * 2)))
	else
		set(h_load, 0)
	end
	if pcu_mode == 1 then
		return 0
	elseif pcu_mode == 0 then
		if get(tas) < 25.7 then
			return (-(elevator_ratio * get(tas) / 51.4) + 20 - (elevator_ratio / 2) * yoke_cmd) --elevator drooping
		else
			return 0
		end
	end
	return (elevator_ratio / 2) * yoke_cmd * -1
end

--Rudder

function GetRudderRatio()
	ratio = GetAilRatio(54, {4}, 2000, 1, 0, 0)
	if IsAcConnected() == 1 then
		if math.abs(get(tas_pilot) - get(tas_copilot)) < 15 then --If airspeed provided by the sensors is reliable, modify ratio based on the formula
			if get(tas_pilot) > 135 and get(tas_pilot) <= 269 then
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

function GetRudderNeutral(ratio)
	local max_press = GetMaxHydPress()
	--Wind strength defines how much of an effect wind has on rudder
	local strength = 1 - math.abs((math.abs(get(ac_heading) - get(wind_dir)) % 180) - 90) / 90
	local reqd_press = 3000 * get(wind_speed) * 0.01 * strength -- pressure required to be able to fully counter act wind
	if max_press < reqd_press then
		local swing_dir = GetWindVector()
		local swing_def = swing_dir * (27.5 - ratio) * ((reqd_press - max_press) / reqd_press)
		return swing_def
	end
	return 0
end

function GetRudderResponseTime()
	local max_press = GetMaxHydPress()
	local wind_mag = get(wind_speed)
	local strength = 1 - math.abs((math.abs(get(ac_heading) - get(wind_dir)) % 180) - 90) / 90
	local reqd_press = 3000 * get(wind_speed) * 0.01 * strength
	if max_press < reqd_press then
		return wind_mag * 0.00194 * ((reqd_press - max_press) / reqd_press) + max_press / 3000
	end
	return 1
end

function GetRudderTarget(yoke_cmd)
	local h_load = globalPropertyfae("Strato/777/hydraulics/load", 6)
	local rud_ratio = GetRudderRatio()
	local rud_neutral = GetRudderNeutral(rud_ratio)
	if rud_ratio > 0 then
		set(h_load, (math.abs(yoke_cmd) / 1) * 0.3)
	else
		set(h_load, 0)
	end
	return -(rud_ratio / 2) * yoke_cmd + rud_neutral
end

--these functions set a bunch of datarefs for flight controls to the same value. I guess this is needed because of something in plane maker

function UpdateElevator(value, side)
	if side == -1 then
		for i=1,6 do
			local elev = globalPropertyfae("sim/flightmodel2/wing/elevator1_deg", i)
			set(elev, value)
		end
	else
		for i=7,12 do
			local elev = globalPropertyfae("sim/flightmodel2/wing/elevator1_deg", i)
			set(elev, value)
		end
	end
end

function UpdateOutbdAileron(value, side)
	local ail = globalPropertyfae("sim/flightmodel2/wing/aileron1_deg", 1)
	for i=1,4 do
		if side == -1 then
			ail = globalPropertyfae("sim/flightmodel2/wing/aileron1_deg", i)
		else
			ail = globalPropertyfae("sim/flightmodel2/wing/aileron2_deg", i)
		end
		if i % 2 ~= 0 then
			set(ail, value)
		else
			set(ail, -value)
		end
	end
end

function UpdateInbdAileron(value, side)
	local ail = globalPropertyfae("sim/flightmodel2/wing/aileron1_deg", 5)
	for i=5,12 do
		if side == -1 then
			ail = globalPropertyfae("sim/flightmodel2/wing/aileron1_deg", i)
		else
			ail = globalPropertyfae("sim/flightmodel2/wing/aileron2_deg", i)
		end
		if i % 2 ~= 0 then
			set(ail, value)
		else
			set(ail, -value)
		end
	end
end

function UpdateRudder(value)
	set(upper_rudder, value)
	set(bottom_rudder, value)
end

function UpdateSpoilers(value, side)
	if side == -1 then
		set(spoiler_L1, value)
		set(spoiler_L2, value)
	else
		set(spoiler_R1, value)
		set(spoiler_R2, value)
	end
end

function UpdateSlats()
	local flap_target = get(flap_tgt)
	local flap_actual = get(flaps)
	if flap_actual < 1 then
		set(slat_1, flap_actual / 2)
		set(slat_2, flap_actual / 2)
	elseif flap_actual >= 1 and flap_actual <= 20 then
		set(slat_1, 0.5)
		set(slat_2, 0.5)
	elseif flap_actual > 20 and flap_actual < 25 then
		set(slat_1, 0.5 + (flap_actual - 20) * 0.1)
		set(slat_2, 0.5 + (flap_actual - 20) * 0.1)
	elseif flap_actual >= 25 then
		set(slat_1, 1)
		set(slat_2, 1)
	else
		set(slat_1, 0)
		set(slat_2, 0)
	end
end

function UpdateFlaps(value)
	set(flaps, value)
	set(inbd_flap_L, value)
	set(outbd_flap_L, value)
	set(inbd_flap_R, value)
	set(outbd_flap_R, value)
end

function update()
	UpdateReversers()
	--Update PCU modes
	UpdateFlprnPCUMode(1, {1, 3})
	UpdateFlprnPCUMode(2, {2, 3})
	UpdateElevatorPCUMode(1, {1, 2}, get(elevator_L))
	UpdateElevatorPCUMode(2, {1, 3}, get(elevator_R))
	local L_flprn_pcu_mode = globalPropertyiae("Strato/777/fctl/flprn/pcu_mode", 1)
	local R_flprn_pcu_mode = globalPropertyiae("Strato/777/fctl/flprn/pcu_mode", 2)
	local L_elevator_pcu_mode = globalPropertyiae("Strato/777/fctl/elevator/pcu_mode", 1)
	local R_elevator_pcu_mode = globalPropertyiae("Strato/777/fctl/elevator/pcu_mode", 2)
	--Obtaining target positions for all of the flight controls
	local L_elevator_target = GetElevatorTarget({1, 2}, get(pfc_elevator_command) / 20, get(L_elevator_pcu_mode))
	local R_elevator_target = GetElevatorTarget({1, 3}, get(pfc_elevator_command) / 20, get(R_elevator_pcu_mode))
	local L_outbd_ail_target = GetAilTarget(1, get(pfc_roll_command) / 18, 1, {1, 2}, 1, 1)
	local L_inbd_ail_target = GetAilTarget(1, get(pfc_roll_command) / 18, 2, {1, 3}, get(L_flprn_pcu_mode), 2)
	local R_outbd_ail_target = GetAilTarget(-1, get(pfc_roll_command) / 18, 1, {1, 2}, 1, 1)
	local R_inbd_ail_target = GetAilTarget(-1, get(pfc_roll_command) / 18, 2, {2, 3}, get(R_flprn_pcu_mode), 2)
	local L_spoiler_target = GetSpoilerTarget(-1, get(yoke_roll_ratio))
	local R_spoiler_target = GetSpoilerTarget(1, get(yoke_roll_ratio))
	local rud_target = GetRudderTarget(get(pfc_rudder_command) / 27)
	SetFlapTarget()
	--Obtaining response times for all of the flight controls
	local outbd_ail_response_time = GetAilResponseTime({1, 2}, 1)
	local L_inbd_ail_response_time = GetAilResponseTime({1, 3}, get(L_flprn_pcu_mode))
	local R_inbd_ail_response_time = GetAilResponseTime({2, 3}, get(R_flprn_pcu_mode))
	local L_elevator_response_time = GetAilResponseTime({1, 2}, 1)
	local R_elevator_response_time = GetAilResponseTime({1, 3}, 1)
	local spoiler_response_time = GetSpoilerResponseTime()
	local rud_time = GetRudderResponseTime()
	--Move flight controls in sim
	EvenAnim(outbd_ail_L, L_outbd_ail_target, 0.3)
	EvenAnim(inbd_ail_L, L_inbd_ail_target, 0.3)
	EvenAnim(outbd_ail_R, R_outbd_ail_target, 0.3)
	EvenAnim(inbd_ail_R, R_inbd_ail_target, 0.3)
	UpdateRudder(get(upper_rudder)+(rud_target - get(upper_rudder))*get(f_time)*rud_time)
	UpdateSpoilers(get(spoiler_L1)+(L_spoiler_target - get(spoiler_L1))*get(f_time)*spoiler_response_time, -1)
	UpdateSpoilers(get(spoiler_R1)+(R_spoiler_target - get(spoiler_R1))*get(f_time)*spoiler_response_time, 1)
	UpdateFlaps(GetFlapCurrent())
	UpdateSlats()
	UpdateElevator(get(elevator_L)+(L_elevator_target - get(elevator_L)) * get(f_time) * L_elevator_response_time, -1)
	UpdateElevator(get(elevator_R)+(R_elevator_target - get(elevator_R)) * get(f_time) * R_elevator_response_time, 1)
end

function onAirportLoaded()
	if get(ra_pilot) > 100 or get(ra_copilot) > 100 then
		UpdateFlaps(15)
		set(flap_tgt, 15)
		UpdateSlats()
	end
end

onAirportLoaded()
