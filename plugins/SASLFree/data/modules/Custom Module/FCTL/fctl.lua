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
flap_handle = globalPropertyf("sim/cockpit2/controls/flap_ratio")
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
flaps = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 2)
inbd_flap_L = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 1)
inbd_flap_R = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 2)
outbd_flap_L = globalPropertyfae("sim/flightmodel2/wing/flap2_deg", 3)
outbd_flap_R = globalPropertyfae("sim/flightmodel2/wing/flap2_deg", 4)
slat_1 = globalPropertyf("sim/flightmodel2/controls/slat1_deploy_ratio")
slat_2 = globalPropertyf("sim/flightmodel2/controls/slat2_deploy_ratio")
elevator_L = globalPropertyfae("sim/flightmodel2/wing/elevator1_deg",9)
elevator_R = globalPropertyfae("sim/flightmodel2/wing/elevator1_deg",10)
upper_rudder = globalPropertyfae("sim/flightmodel2/wing/rudder1_deg", 12)
bottom_rudder = globalPropertyfae("sim/flightmodel2/wing/rudder2_deg", 12)
--Reversers
L_reverser_deployed = globalPropertyiae("sim/cockpit2/annunciators/reverser_on", 1)
L_reverser_fail = globalPropertyi("sim/operation/failures/rel_revers0")
R_reverser_deployed = globalPropertyiae("sim/cockpit2/annunciators/reverser_on", 2)
R_reverser_fail = globalPropertyi("sim/operation/failures/rel_revers1")
--Operation
f_time = globalPropertyf("sim/operation/misc/frame_rate_period")
c_time = globalPropertyf("Strato/777/time/current")
on_ground = globalPropertyi("sim/flightmodel/failures/onground_any")

pfc_roll_command = globalPropertyf("Strato/777/fctl/pfc/roll")
pfc_elevator_command = globalPropertyf("Strato/777/fctl/pfc/elevator")
pfc_rudder_command = globalPropertyf("Strato/777/fctl/pfc/rudder")
fbw_ail_ratio = globalPropertyf("Strato/777/fctl/ail_ratio")
fbw_flprn_ratio_l = globalPropertyf("Strato/777/fctl/flprn_ratio_l")
fbw_flprn_ratio_u = globalPropertyf("Strato/777/fctl/flprn_ratio_u")

ace_aileron = globalProperty("Strato/777/fctl/ace/ailrn_cmd")
ace_flaperon = globalProperty("Strato/777/fctl/ace/flprn_cmd")
ace_spoiler = globalProperty("Strato/777/fctl/ace/spoiler_cmd")
ace_elevator = globalProperty("Strato/777/fctl/ace/elevator_cmd")
ace_rudder = globalPropertyf("Strato/777/fctl/ace/rudder_cmd")

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
flap_handle_used = createGlobalPropertyf("Strato/777/flaps/handle_used", 0)

flap_settings = {0, 1, 5, 15, 20, 25, 30}

Control_surface = {mass = 0, area = 0, ratio1 = 18, ratio2 = 18, mode = 1}

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

function GetSurfaceResponseTime(hyd_sys, type) --aileron response time based on pressure
	--types:
	--1 - aileron/flaperon
	--2 - elevator
	local resp_times_max = {0.4, 2}
	local resp_times_min = {0.08, 0.3}
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
	local tmp = pressure * resp_times_max[type] / 3340
	if tmp >= resp_times_min[type] then
		return tmp
	end
	return resp_times_min[type]
end

--Spoilers

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
	cas_limits = {-1, 265, 245, 230, 225, 200, 180} --limits in meters per second for load relief system
	local sys_C_press = globalPropertyiae("Strato/777/hydraulics/press", 2)
	local h_load = globalPropertyfae("Strato/777/hydraulics/load", 7)
	if get(sys_C_press) >= 1000 then
		local flap_pos = get(flaps)
		local index = indexOf(detents, get(flap_handle), 1)
		local avg_cas = (get(cas_pilot) + get(cas_copilot)) / 2
		if index ~= nil then
			if avg_cas > cas_limits[index] and get(flap_handle) >= 0.5 or (get(flap_handle) > 0 and flap_pos == 0 and avg_cas > 140 and (get(altitude_pilot) >= 20000 or get(altitude_copilot) >= 20000 or get(altitude_stdby) >= 20000)) then --load relief system only triggers with flaps 15 or below
				if get(flap_load_relief) ~= 1 then
					set(flap_load_relief, 1)
				end
				if get(flap_pos) > 5 then
					for i = index,3,-1 do
						if cas_limits[i] > avg_cas or i == 3 then --load relief retraction is limited to flap 5 idk why but the fcom says it
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

--Rudder

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

--these functions set a bunch of datarefs for flight controls to the same value. I guess this is needed because of something in plane maker
function UpdateRudder(value)
	set(upper_rudder, value)
	set(bottom_rudder, value)
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
	--set(flaps, value)
	set(inbd_flap_L, value)
	set(outbd_flap_L, value)
	set(inbd_flap_R, value)
	set(outbd_flap_R, value)
end

function update()
	UpdateReversers()
	--Update PCU modes
	SetFlapTarget()
	--Obtaining response times for all of the flight controls
	local outbd_ail_response_time = GetSurfaceResponseTime({1, 2}, 1)
	local L_inbd_ail_response_time = GetSurfaceResponseTime({1, 3}, 1)
	local R_inbd_ail_response_time = GetSurfaceResponseTime({2, 3}, 1)
	local L_elevator_response_time = GetSurfaceResponseTime({1, 2}, 2)
	local R_elevator_response_time = GetSurfaceResponseTime({1, 3}, 2)
	local spoiler_response_time = GetSpoilerResponseTime()
	local rud_time = GetRudderResponseTime()
	--Move flight controls in sim
	EvenAnim(outbd_ail_L, get(ace_aileron, 1), outbd_ail_response_time)
	EvenAnim(inbd_ail_L, get(ace_flaperon, 1), L_inbd_ail_response_time)
	EvenAnim(outbd_ail_R, get(ace_aileron, 2), outbd_ail_response_time)
	EvenAnim(inbd_ail_R, get(ace_flaperon, 2), R_inbd_ail_response_time)
	UpdateRudder(get(upper_rudder)+(get(ace_rudder) - get(upper_rudder))*get(f_time)*rud_time)
	set(spoiler_L1, get(spoiler_L1)+(get(ace_spoiler, 1) - get(spoiler_L1))*get(f_time)*spoiler_response_time)
	set(spoiler_L2, get(spoiler_L2)+(get(ace_spoiler, 2) - get(spoiler_L2))*get(f_time)*spoiler_response_time)
	set(spoiler_R1, get(spoiler_R1)+(get(ace_spoiler, 3) - get(spoiler_R1))*get(f_time)*spoiler_response_time)
	set(spoiler_R2, get(spoiler_R2)+(get(ace_spoiler, 4) - get(spoiler_R2))*get(f_time)*spoiler_response_time)
	UpdateFlaps(GetFlapCurrent())
	UpdateSlats()
	set(elevator_L, get(elevator_L)+(get(ace_elevator, 1) - get(elevator_L)) * get(f_time) * L_elevator_response_time)
	set(elevator_R, get(elevator_R)+(get(ace_elevator, 2) - get(elevator_R)) * get(f_time) * R_elevator_response_time)
end

function onAirportLoaded()
	if get(ra_pilot) > 100 or get(ra_copilot) > 100 then
		UpdateFlaps(5)
		set(flap_tgt, 5)
		UpdateSlats()
	end
end

onAirportLoaded()
