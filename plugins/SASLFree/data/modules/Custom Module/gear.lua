--[[
*****************************************************************************************
* Script Name: gear
* Author Name: @bruh
* Script Description: Code for landing gear and brakes
*****************************************************************************************
--]]

include("misc_tools.lua")

--X plane datarefs
--Cockpit controls
throttle_pos = globalPropertyf("sim/cockpit2/engine/actuators/throttle_ratio_all")
yoke_heading_ratio = globalPropertyf("sim/cockpit2/controls/yoke_heading_ratio")
gear_handle = globalPropertyi("sim/cockpit2/controls/gear_handle_down")
--Indicators
ra_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")
ra_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_copilot")
--Brakes
Xplane_park_brake = globalPropertyf("sim/flightmodel/controls/parkbrake")
R_wheel_brake = globalPropertyf("sim/cockpit2/controls/right_brake_ratio")
toe_brakes_R = globalPropertyfae("sim/joystick/joy_mapped_axis_value", 8)
L_wheel_brake = globalPropertyf("sim/cockpit2/controls/left_brake_ratio")
toe_brakes_L = globalPropertyfae("sim/joystick/joy_mapped_axis_value", 7)
--Speeds, temperatures, etc
oat = globalPropertyf("sim/cockpit2/temperature/outside_air_temp_degc")
ground_speed = globalPropertyf("sim/flightmodel/position/groundspeed")
tas = globalPropertyf("sim/flightmodel/position/true_airspeed")
--Gear tire speeds
nw_speed = globalPropertyfae("sim/flightmodel2/gear/tire_rotation_speed_rad_sec", 1)
rmw_speed = globalPropertyfae("sim/flightmodel2/gear/tire_rotation_speed_rad_sec", 2)
lmw_speed = globalPropertyfae("sim/flightmodel2/gear/tire_rotation_speed_rad_sec", 3)
--Gear positions
nw_actual = globalPropertyfae("sim/aircraft/parts/acf_gear_deploy", 1)
mlg_actual_R = globalPropertyfae("sim/aircraft/parts/acf_gear_deploy", 2)
mlg_actual_L = globalPropertyfae("sim/aircraft/parts/acf_gear_deploy", 3)
--Eagle claw
--custom_eag_claw = createGlobalPropertyfa("Strato/777/custom_eagle_claw", {0, 0, 0})
sim_eag_R = globalPropertyfae("sim/flightmodel2/gear/eagle_claw_angle_deg", 2)
custom_eag_R = globalPropertyfae("Strato/777/custom_eagle_claw", 2)
sim_eag_L = globalPropertyfae("sim/flightmodel2/gear/eagle_claw_angle_deg", 3)
custom_eag_L = globalPropertyfae("Strato/777/custom_eagle_claw", 3)
--Tire skid speeds, failures
tire_skid_speed_L = globalPropertyfae("sim/flightmodel2/gear/tire_skid_speed_mtr_sec", 2)
L_tire_fail = globalPropertyi("sim/operation/failures/rel_tire3")
tire_skid_speed_R = globalPropertyfae("sim/flightmodel2/gear/tire_skid_speed_mtr_sec", 3)
R_tire_fail = globalPropertyi("sim/operation/failures/rel_tire2")
--Steering
nw_strg = globalPropertyfae("sim/flightmodel/parts/tire_steer_cmd", 1)
r_w_strg = globalPropertyfae("sim/flightmodel/parts/tire_steer_cmd", 2)
l_w_strg = globalPropertyfae("sim/flightmodel/parts/tire_steer_cmd", 3)
--Ground collision
nw_onground = globalPropertyiae("sim/flightmodel2/gear/on_ground", 1)
rmw_onground = globalPropertyiae("sim/flightmodel2/gear/on_ground", 2)
lmw_onground = globalPropertyiae("sim/flightmodel2/gear/on_ground", 3)
on_ground = globalPropertyi("sim/flightmodel/failures/onground_any")
--Position
t_phi = globalPropertyf("sim/flightmodel/position/true_phi") --bank angle
t_theta = globalPropertyf("sim/flightmodel/position/true_theta") --pitch
--Flight controls
rudder = globalPropertyfae("sim/flightmodel2/wing/rudder1_deg", 1)
--Operation
brk_ovrd = globalProperty("sim/operation/override/override_gearbrake")
steer_ovrd = globalPropertyi("sim/operation/override/override_wheel_steer")
f_time = globalPropertyf("sim/operation/misc/frame_rate_period")
gear_ovrd = globalPropertyi("sim/operation/failures/rel_gear_act")
--Own datarefs
sys_C_press = globalPropertyfae("Strato/777/hydraulics/press", 2)
sys_R_press = globalPropertyfae("Strato/777/hydraulics/press", 3)
c_time = globalPropertyf("Strato/777/time/current")
gear_load = globalPropertyfae("Strato/777/hydraulics/load", 9)
altn_gear = globalPropertyi("Strato/777/gear/altn_extnsn")
normal_gear = globalPropertyi("Strato/777/gear/norm_extnsn")
act_press = globalPropertyi("Strato/777/gear/actuator_press")

lock_ovrd = createGlobalPropertyi("Strato/777/gear/lock_ovrd", 0)
man_brakes_L = createGlobalPropertyf("Strato/777/gear/manual_braking_L", 0)
truck_L_brake_temp = createGlobalPropertyfa("Strato/777/gear/truck_L_temp", {0, 0, 0})
truck_L_max = createGlobalPropertyf("Strato/777/gear/truck_L_max", 0)
truck_L_psi = createGlobalPropertyfa("Strato/777/gear/truck_L_psi", {0, 0, 0, 0, 0, 0}) --psi for each pair of tires
man_brakes_R = createGlobalPropertyf("Strato/777/gear/manual_braking_R", 0)
truck_R_brake_temp = createGlobalPropertyfa("Strato/777/gear/truck_R_temp", {0, 0, 0})
truck_R_max = createGlobalPropertyf("Strato/777/gear/truck_R_max", 0)
truck_R_psi = createGlobalPropertyfa("Strato/777/gear/truck_R_psi", {0, 0, 0, 0, 0, 0}) --psi for each pair of tires
park_brake = createGlobalPropertyi("Strato/777/gear/park_brake", 0)
man_keyboard = createGlobalPropertyi("Strato/777/gear/man_keyboard", 0) --1 if user is braking using keyboard
brake_acc = createGlobalPropertyf("Strato/777/gear/brake_acc", 3000)
acc_press_tgt = createGlobalPropertyf("Strato/777/gear/brake_acc_tgt", 3000)
brake_acc_in_use = createGlobalPropertyi("Strato/777/gear/brake_acc_in_use", 0)
lock_factor = createGlobalPropertyia("Strato/777/gear/lock_f", {1, 1, 1})
doors = createGlobalPropertyfa("Strato/777/gear/doors", {0, 0, 0, 0})
brake_load = createGlobalPropertyfa("Strato/777/gear/brake_load", {0, 0})
acc_load_current = createGlobalPropertyf("Strato/777/gear/acc_load_current", 0)
acc_load_past = createGlobalPropertyf("Strato/777/gear/acc_load_past", 0)

--Finding simulaor commands
toggle_regular = sasl.findCommand("sim/flight_controls/brakes_toggle_regular")
hold_regular = sasl.findCommand("sim/flight_controls/brakes_regular")
toggle_max = sasl.findCommand("sim/flight_controls/brakes_toggle_max")
gear_down = sasl.findCommand("sim/flight_controls/landing_gear_down")
gear_up = sasl.findCommand("sim/flight_controls/landing_gear_up")
gear_toggle = sasl.findCommand("sim/flight_controls/landing_gear_toggle")

mlg_target = 1
nose_gear_target = 1
ldg_extend = 0
mlg_locked = 1
nose_gear_locked = 1
altn_used = 0
actuator_press = {0, 0}

eag_claw_sync = 1
eag_claw_target = {0, 0}

pressures_L = {203, 210, 219, 204, 200, 216}
L_fuse_plugs_melt = {0, 0, 0}
pressures_R = {213, 204, 215, 201, 205, 219}
R_fuse_plugs_melt = {0, 0, 0}
L_brake_tgt = 0
R_brake_tgt = 0
tmp = {0, 0} --time when we just started using brakes
tmp_ovht_L = {0, 0, 0}
tmp_ovht_R = {0, 0, 0}
on_time = {0, 0} --brake on time
truck_brake_temp_L = {0, 0, 0}
truck_brake_temp_R = {0, 0, 0}
TBRS_active_L = 1 --Taxi brake release system target brake index
TBRS_active_R = 1
TBRS_landing_decel = false
gs_past = 0
brake_L_temp = 0
L_brake_past = 0
brake_R_temp = 0
R_brake_past = 0
temp_v = 0

set(steer_ovrd, 1)
set(brk_ovrd, 1)

function UpdateManualBraking()
	if get(man_keyboard) == 0 then --if user is not using keyboard shortcuts to brake, update brakes using values from toe brakes
		set(man_brakes_L, get(toe_brakes_L))
		set(man_brakes_R, get(toe_brakes_R))
	end
end

function UpdateBrakeOnTime()
	if get(L_wheel_brake) > 0 then
		on_time[1] = get(c_time) - tmp[1]
	end
	if get(R_wheel_brake) > 0 then
		on_time[2] = get(c_time) - tmp[2]
	end
end

function UpdateTruckBrakes() --updates current TBRS brake index
	if get(ground_speed) ~= gs_past then
		if get(ground_speed) >= 23.15 and (get(man_brakes_L) > 0 or get(man_brakes_R) > 0) and TBRS_landing_decel == false then
			TBRS_landing_decel = true
		elseif get(ground_speed) < 23.15 and get(man_brakes_L) == 0 and get(man_brakes_R) == 0 and TBRS_landing_decel == true then
			TBRS_landing_decel = false
		end
		gs_past = get(ground_speed)
	end
	if get(throttle_pos) < 0.6 and get(ground_speed) < 23.15 and get(ground_speed) > 0.08 and get(sys_R_press) > 100 and TBRS_landing_decel == false then --TBRS goes to work only if these apply
		if TBRS_active_L == 4 then
			TBRS_active_L = 1
		end
		if L_brake_past > 0 and get(L_wheel_brake) == 0 then
			if TBRS_active_L < 3 then
				TBRS_active_L = TBRS_active_L + 1
			else
				TBRS_active_L = 1
			end
		end
		L_brake_past = get(L_wheel_brake)
		if TBRS_active_R == 4 then
			TBRS_active_R = 1
		end
		if R_brake_past > 0 and get(R_wheel_brake) == 0 then
			if TBRS_active_R < 3 then
				TBRS_active_R = TBRS_active_R + 1
			else
				TBRS_active_R = 1
			end
		end
		R_brake_past = get(R_wheel_brake)
	else
		TBRS_active_L = 4
		TBRS_active_R = 4
	end
end

function UpdateBrakeTemperatures(delay)
	if get(c_time) >= temp_v + delay then
		--initial formula was BDTm = (0.527 * q * Sqrt (t)) / Sqrt(p*c*k) + Tamb where 
		--q is the heat flux (watts/m^2)
		--p is the density of the brake disc (kg/m^3)
		--c is the brake disc specific heat capacity (J/kg/K)
		--k is the brake disc thermal conductivity (W/(m*K))
		--However, I modified it so that it reflects change in heat generated when there is more friction and cooling
		local L_cooler = bool2num(-1 == GetWindVector()) --defines if this side has more airflow
		local L_deployed = bool2num(1 == get(mlg_actual_L))
		local R_cooler  = bool2num(1 == GetWindVector())
		local R_deployed = bool2num(1 == get(mlg_actual_R))
		--Calculating gain in temperature because of braking here
		local p1 = 0.527 * 10000 * get(ground_speed) * (get(ground_speed) / get(tas))
		local p2 = math.sqrt(1450 * 2020 * 5.28)
		local L_temp_no_askid = 0
		local R_temp_no_askid = 0
		if get(brake_acc_in_use) == 1 then
			L_temp_no_askid = (p1 * math.sqrt(on_time[1]) * get(man_brakes_L) * 0.25) / p2
			R_temp_no_askid = (p1 * math.sqrt(on_time[2]) * get(man_brakes_R) * 0.25) / p2
		end
		local L_temp = (p1 * math.sqrt(on_time[1]) * get(L_wheel_brake) * 0.25) / p2
		local R_temp = (p1 * math.sqrt(on_time[2]) * get(R_wheel_brake) * 0.25) / p2
		--Cooling would be slower when parking brake is on
		local L_cooling_coeff = 0.008 - 0.002 * (get(park_brake) - L_cooler * 2)
		local R_cooling_coeff = 0.008 - 0.002 * (get(park_brake) - R_cooler * 2)
		--This is where all the cooling is simulated
		local cool_L = (get(oat) - brake_L_temp) * (1 - get(L_wheel_brake)) * get(f_time) * L_cooling_coeff * (get(tas) - (get(oat) - brake_L_temp) * 0.002) * 0.2 * L_deployed
		local cool_R = (get(oat) - brake_R_temp) * (1 - get(R_wheel_brake)) * get(f_time) * R_cooling_coeff * (get(tas) - (get(oat) - brake_R_temp) * 0.002) * 0.2 * R_deployed
		local L_tgt_temp = L_temp + cool_L 
		local R_tgt_temp = R_temp + cool_R
		brake_L_temp = brake_L_temp + L_tgt_temp
		brake_R_temp = brake_R_temp + R_tgt_temp
		--Update temperatures for each truck
		for i=1,3 do 
			if TBRS_active_L == 4 or i == TBRS_active_L then
				if truck_brake_temp_L[i] <= 545 and truck_brake_temp_L[i] + L_tgt_temp > 545 then
					tmp_ovht_L[i] = get(c_time)
				end
				if get(brake_acc_in_use) == 0 or i < 3 then
					truck_brake_temp_L[i] = truck_brake_temp_L[i] + L_tgt_temp --If all of the weels can brake, make all temperatures rise
				else
					truck_brake_temp_L[i] = truck_brake_temp_L[i] + L_temp_no_askid + cool_L
				end
			else
				local L_wheel_temp = (get(oat) - get(truck_brake_temp_L[i])) * get(f_time) * L_cooling_coeff * get(tas) * 0.2 * L_deployed --cool the brakes that aren't working
				truck_brake_temp_L[i] = truck_brake_temp_L[i] + L_wheel_temp
			end
			if TBRS_active_R == 4 or i == TBRS_active_R then
				if truck_brake_temp_R[i] <= 545 and truck_brake_temp_R[i] + R_tgt_temp > 545 then
					tmp_ovht_R[i] = get(c_time)
				end
				if get(brake_acc_in_use) == 0 or i < 3 then
					truck_brake_temp_R[i] = truck_brake_temp_R[i] + R_tgt_temp --If all of the weels can brake, make all temperatures rise
				else
					truck_brake_temp_R[i] = truck_brake_temp_R[i] + R_temp_no_askid + cool_R
				end
			else
				local R_wheel_temp = (get(oat) - get(truck_brake_temp_R[i])) * get(f_time) * R_cooling_coeff * get(tas) * 0.2 * R_deployed
				truck_brake_temp_R[i] = truck_brake_temp_R[i] + R_wheel_temp
			end
		end
		temp_v = get(c_time)
	end
end

function UpdateTirePsi()
	local n_tires_popped_L = 0 --number of tires that have fuse plugs melted on the left
	local n_tires_popped_R = 0 --number of tires that have fuse plugs melted on the right
	for i=1,3 do
		local psi_L = globalPropertyfae("Strato/777/gear/truck_L_psi", i)
		local psi_LL = globalPropertyfae("Strato/777/gear/truck_L_psi", i + 3)
		local psi_R = globalPropertyfae("Strato/777/gear/truck_R_psi", i)
		local psi_RR = globalPropertyfae("Strato/777/gear/truck_R_psi", i + 3)
		if truck_brake_temp_L[i] < 545 or get(c_time) < tmp_ovht_L[i] + 120 - ((truck_brake_temp_L[i] * 120) / 1090) and L_fuse_plugs_melt[i] == 0 then
			local press_L = pressures_L[i] + ((truck_brake_temp_L[i] - get(oat)) * 0.18 + 3.2) * 0.02 --Tire pressure under normal circumstances 
			local press_LL = pressures_L[i + 3] + ((truck_brake_temp_L[i] - get(oat)) * 0.18 + 3.2) * 0.02
			set(psi_L, press_L)
			set(psi_LL, press_LL)
		else --fuse plugs melt at above approximately 545 degC
			L_fuse_plugs_melt[i] = 1
			local tgt_L = get(psi_L) - get(psi_L) * 0.02
			local tgt_LL = get(psi_LL) - get(psi_LL) * 0.02
			set(psi_L, tgt_L)
			set(psi_LL, tgt_LL)
			pressures_L[i] = tgt_L
			pressures_L[i + 3] = tgt_LL
		end
		if pressures_L[1] < 10 and pressures_L[3] < 10 and pressures_L[6] < 10 then
			set(L_tire_fail, 6)
		end
		if (truck_brake_temp_R[i] < 545 or get(c_time) < tmp_ovht_R[i] + 60 - truck_brake_temp_R[i] * 60 / 1090) and R_fuse_plugs_melt[i] == 0 then
			local press_R = pressures_R[i] + ((truck_brake_temp_R[i] - get(oat)) * 0.18 + 3.2) * 0.02
			local press_RR = pressures_R[i + 3] + ((truck_brake_temp_R[i] - get(oat)) * 0.18 + 3.2) * 0.02
			set(psi_R, press_R)
			set(psi_RR, press_RR)
		else --fuse plugs melt at above approximately 545 degC
			R_fuse_plugs_melt[i] = 1
			local tgt_R = get(psi_R) - get(psi_R) * 0.02
			local tgt_RR = get(psi_RR) - get(psi_RR) * 0.02
			set(psi_R, tgt_R)
			set(psi_RR, tgt_RR)
			pressures_R[i] = tgt_R
			pressures_R[i + 3] = tgt_RR
		end
		if pressures_R[1] < 10 and pressures_R[3] < 10 and pressures_R[6] < 10 then
			set(R_tire_fail, 6)
		end
	end
end

function UpdateBrakeAcc()
	local use = 0 --use of brake accumulator
	if get(sys_C_press) < 200 and get(sys_R_press) < 200 then
		use = 1
		local delta = (get(acc_load_current) - get(acc_load_past)) / 2
		local discharge = 400 * delta 
		if delta > 0 and get(acc_press_tgt) - discharge >= 0 then
			set(acc_press_tgt, get(acc_press_tgt) - discharge)
		end
		set(acc_load_past, get(acc_load_current))
	elseif get(sys_R_press) > get(brake_acc) then --brke accumulator charging
		set(acc_press_tgt, get(sys_R_press))
	end
	if math.abs(get(acc_press_tgt) - get(brake_acc)) < 1 and math.abs(get(acc_press_tgt) - get(brake_acc)) > 0 then --updating current accumulator pressure
		set(brake_acc, get(acc_press_tgt))
	elseif math.abs(get(acc_press_tgt) - get(brake_acc)) > 1 then
		set(brake_acc, get(brake_acc) + (get(acc_press_tgt) - get(brake_acc)) * 0.8 * get(f_time))
	end
	set(brake_acc_in_use, use)
end

function ApplyBrakingWithAntiSkid(tgt_L, tgt_R)
	local effect_L = 1
	local load_total = 0
	if get(sys_C_press) < 1500 and get(sys_R_press) < 1500 and get(brake_acc) < 1500 then
		effect_L = math.max(get(sys_C_press), get(sys_R_press), get(brake_acc)) / 1500
	end
	local effect_R = effect_L
	if TBRS_active_L ~= 4 then
		effect_L = effect_L * 0.3
	end
	local skid_ratio_L = 0 --Custom skid ratio. Xplane's are sus
	if get(ground_speed) > 0 then
		skid_ratio_L = get(tire_skid_speed_L) / get(ground_speed)
	end
	if skid_ratio_L * 2 * bool2num(skid_ratio_L > 0.15) < tgt_L then --We don't want to apply negative braking, so check if we exceed the limit
		local tgt = tgt_L - skid_ratio_L * 2 * bool2num(skid_ratio_L > 0.15)
		if effect_L * tgt > 0 and get(L_wheel_brake) == 0 then --Update time when we started using the brake
			tmp[1] = get(c_time)
		end
		set(L_wheel_brake, get(L_wheel_brake) + (effect_L * tgt - get(L_wheel_brake)) * 0.1)
		if get(brake_acc_in_use) == 0 then --set load to pedal setting when accumulator is in use to get more realistic consumption
			load_total = tgt
		end
	else
		set(L_wheel_brake, 0)
	end
	if TBRS_active_R ~= 4 then
		effect_R = effect_R * 0.3
	end
	local skid_ratio_R = 0
	if get(ground_speed) > 0 then
		skid_ratio_R = get(tire_skid_speed_R) / get(ground_speed)
	end
	if skid_ratio_R * 2 * bool2num(skid_ratio_R > 0.15) < tgt_R then
		local tgt = tgt_L - skid_ratio_R * 2 * bool2num(skid_ratio_R > 0.15)
		if effect_R * tgt > 0 and get(R_wheel_brake) == 0 then
			tmp[2] = get(c_time)
		end
		set(R_wheel_brake, get(R_wheel_brake) + (effect_R * tgt - get(R_wheel_brake)) * 0.1)
		if get(brake_acc_in_use) == 0 then
			load_total = load_total + tgt
		end
	else
		set(R_wheel_brake, 0)
	end
	if get(brake_acc_in_use) == 1 then
		load_total = get(tgt_L) + get(tgt_R)
	end
	if get(sys_R_press) > 100 then --Updating load
		local h_load = globalPropertyfae("Strato/777/gear/brake_load", 2)
		set(h_load, load_total)
	elseif get(sys_R_press) < 100 and get(sys_C_press) > 100 then
		local h_load = globalPropertyfae("Strato/777/gear/brake_load", 1)
		set(h_load, load_total)
	else
		set(acc_load_current, load_total)
	end
end

function UpdateLdgTarget()
	if get(altn_gear) == 1 then
		--Unlock gear for alternate extension
		mlg_locked = 0 
		nose_gear_locked = 0
		mlg_target = 1
		nose_gear_target = 1
		altn_used = 1
	else
		if get(rmw_onground) == 0 and get(lmw_onground) == 0 and altn_used == 0 then
			if get(sys_C_press) > 1000 then
				--Allow landing gear to operate normally when pressure is ok
				mlg_target = get(normal_gear)
				nose_gear_target = get(normal_gear)
			else
				if mlg_locked == 0 then
					mlg_target = 1
				end
				if nose_gear_locked == 0 then
					nose_gear_target = 1
				end
			end
		end
	end
	if get(altn_gear) == 0 and get(normal_gear) == 1 then
		altn_used = 0
	end
end

function UpdateBrakeTgt()
	if get(rmw_onground) == 1 then
		R_brake_tgt = get(man_brakes_R)
	elseif get(rmw_onground) == 0 and mlg_target == 0 then --Slowing the wheels down before landing gear is retracted
		if get(rmw_speed) / 6.28 > 0.5 then
			R_brake_tgt = 0.5
		else
			R_brake_tgt = 0
		end
	end
	if get(lmw_onground) == 1 then
		L_brake_tgt = get(man_brakes_L)
	elseif get(lmw_onground) == 0 and mlg_target == 0 then
		if get(lmw_speed) / 6.28 > 0.5 then
			L_brake_tgt = 0.5
		else
			L_brake_tgt = 0
		end
	end
end

function UpdateGearStrg(r_time)
	local h_load = globalPropertyfae("Strato/777/hydraulics/load", 8) 
	local nw_ratio = 70
	local w_tgt = 0 --steering target for the main wheels
	local l_all = 0 --total load created by steering 0.1 max
	if Round(get(nw_speed), 2) / 6.28 >= 3 then --converting radians to rotations per second
		nw_ratio = 13
	else
		local rotations = Round(get(nw_speed), 2) / 6.28
		nw_ratio = 70 - 57 * (rotations / 3)
	end
	if get(sys_C_press) > 200 then
		local nw_tgt = 0
		if get(nw_onground) == 1 then --steering happens only on ground to prevent tire skidding
			nw_tgt = nw_ratio * get(yoke_heading_ratio)
		end
		set(nw_strg, get(nw_strg) + (nw_tgt - get(nw_strg)) * r_time * get(f_time))
		l_all = 0.05 * math.abs(get(yoke_heading_ratio))
		if math.abs(get(nw_strg)) > 13 then
			local steer_dir = 1 --steering vector for the main wheels
			if get(nw_strg) < 0 then
				steer_dir = -1
			end
			w_tgt = steer_dir * (steer_dir * Round(get(yoke_heading_ratio), 3) - 0.185) / 0.815 * 14
		end
	else --if there's not enough pressure, gear steering is done by natural forces
		if get(ground_speed) > 0.1 and math.abs(get(nw_strg)) < 50 then
			local tgt = 0
			if get(tas) > 60 then
				tgt = (get(rudder) / 27.5) * 20
			end
			set(nw_strg, get(nw_strg) + (tgt - get(nw_strg)) * 0.4 * get(f_time))
		end
	end
	l_all = l_all + 0.05 * (w_tgt / 14) --updating load
	set(h_load, l_all)
	set(r_w_strg, get(r_w_strg) + (w_tgt - get(r_w_strg)) * r_time * get(f_time))
	set(l_w_strg, get(l_w_strg) + (w_tgt - get(l_w_strg)) * r_time * get(f_time))
end

--function GetGVector()
--	
--end
--
--function UpdateGearPos()
--	--local sys_C_press = globalPropertyfae("Strato/777/hydraulics/press", 2)
--	for i=2,3 do
--		local lock = globalPropertyfae("Strato/777/gear/lock_f", i)
--		local act_press = globalPropertyiae("Strato/777/gear/actuator_press", i)
--		local tgt_d = globalPropertyfae("Strato/777/gear/tgt", i)
--		local side = -1
--		local p_factor = 0 --pressure factor
--		if get(sys_C_press) < 500 then
--			p_factor = 1
--		end
--		if i == 3 then
--			side = 1
--		end
--		local gear_actual = globalPropertyfae("sim/aircraft/parts/acf_gear_deploy", i)
--		--print((get(gear_handle) - get(gear_actual)) * 0.008 * (1 - p_factor))
--		local tgt = get(gear_actual) + (1 - get(gear_actual)) * 0.001 * p_factor + (get(gear_handle) - get(gear_actual)) * 0.008 * (1 - p_factor)
--		local phi = get(t_phi) * side
--		if phi >= 0 and phi < 90 then
--			tgt = get(gear_actual) + (1 - phi * get(lock) / 90 - get(gear_actual)) * get(f_time) * 0.5 * p_factor + (get(gear_handle) - get(gear_actual)) * 0.008 * (1 - p_factor)
--		--elseif phi > 90 then
--		--	tgt = get(gear_actual) + (0.3 - get(gear_actual)) * 0.1 * get(lock)
--		end
--		set(tgt_d, tgt)
--		set(gear_actual, tgt)
--	end
--end

function UpdateActuatorPress()
	--Retracting gear only if wheels are stationary
	if get(lmw_speed) / 6.28 < 0.5 and get(rmw_speed) / 6.28 < 0.5 and (get(mlg_actual_R) ~= mlg_target or get(nw_actual) ~= nose_gear_target) then
		--Unlocking gear to allow movement
		mlg_locked = 0
		nose_gear_locked = 0
		if mlg_target == 0 and get(sys_C_press) >= 1000 then
			--Gear retraction
			eag_claw_target[1] = 0
			eag_claw_target[2] = 0
			eag_claw_sync = 0
			if get(mlg_actual_R) > 0.8 and get(custom_eag_L) == 0 and get(custom_eag_R) == 0 then
				actuator_press[2] = 1000 + (get(sys_C_press) - 1000) * 0.5
			else
				actuator_press[2] = get(sys_C_press)
			end
		elseif mlg_target == 1 then
			--Gear extension
			ldg_extend = 1
			if get(sys_C_press) >= 200 and get(altn_gear) == 0 then
				actuator_press[2] = 200
			else
				actuator_press[2] = 0
			end
		end
		if nose_gear_target == 0 and get(sys_C_press) >= 700 then
			actuator_press[1] = 700 + (get(sys_C_press) - 700) * 0.8
		elseif nose_gear_target == 1 then
			ldg_extend = 1
			if get(sys_C_press) >= 100 and get(altn_gear) == 0 then
				actuator_press[1] = 100
			else
				actuator_press[1] = 0
			end
		end
	else
		--setting up eagle claw for target
		eag_claw_target[1] = get(sim_eag_R) * mlg_target
		eag_claw_target[2] = get(sim_eag_L) * mlg_target
		if ldg_extend == 1 and get(custom_eag_L) == eag_claw_target[1] and get(custom_eag_R) == eag_claw_target[2] then
			eag_claw_sync = 1
			ldg_extend = 0
		end
		--Locking gear
		actuator_press[1] = 0
		actuator_press[2] = 0
		nose_gear_locked = 1
		mlg_locked = 1
	end
	set(gear_load, 0.3 * (actuator_press[2] / 3000))
	set(act_press, actuator_press[2])
end

function MoveGear()
	local mlg_step = 0
	local nose_gear_step = 0
	--Updating main landing gear retraction speed
	if actuator_press[2] >= 1000 then
		mlg_step = 0.0009 * (actuator_press[2] - 1000) / 2000 * -1
	else
		mlg_step = 0.0011 * (1000 - actuator_press[2]) / 1000
	end
	--Updating nose landing gear retraction speed
	if actuator_press[1] >= 500 then
		nose_gear_step = 0.001 * (actuator_press[2] - 500) / 2100 * -1
	else
		nose_gear_step = 0.0012 * (500 - actuator_press[2]) / 500
	end
	--Limiting nose landing gear deployment
	if get(nw_actual) + nose_gear_step >= 1 then
		set(nw_actual, 1)
	elseif get(nw_actual) + nose_gear_step <= 0 then
		set(nw_actual, 0)
	else
		set(nw_actual, get(nw_actual) + nose_gear_step * (1 - nose_gear_locked) * get(f_time) / 0.0166)
	end
	--Limiting main landing gear deployment
	if get(mlg_actual_R) + mlg_step >= 1 then
		set(mlg_actual_R, 1)
		set(mlg_actual_L, 1)
	elseif get(mlg_actual_R) + mlg_step <= 0 then
		set(mlg_actual_R, 0)
		set(mlg_actual_L, 0)
	else
		set(mlg_actual_R, get(mlg_actual_R) + mlg_step * (1 - mlg_locked) * get(f_time) / 0.0166)
		set(mlg_actual_L, get(mlg_actual_L) + mlg_step * (1 - mlg_locked) * get(f_time) / 0.0166)
	end
end

function UpdateDRefs()
	set(truck_L_max, math.max(unpack(truck_brake_temp_L)))
	set(truck_R_max, math.max(unpack(truck_brake_temp_R)))
	for i=1,3 do
		local truck_t_L = globalPropertyfae("Strato/777/gear/truck_L_temp", i)
		local truck_t_R = globalPropertyfae("Strato/777/gear/truck_R_temp", i)
		set(truck_t_L, truck_brake_temp_L[i])
		set(truck_t_R, truck_brake_temp_R[i])
	end
	set(custom_eag_L, eag_claw_target[1] * eag_claw_sync + (get(custom_eag_L) + (eag_claw_target[1] - get(custom_eag_L)) * get(f_time) * 0.9) * (1 - eag_claw_sync))
	set(custom_eag_R, eag_claw_target[1] * eag_claw_sync + (get(custom_eag_R) + (eag_claw_target[2] - get(custom_eag_R)) * get(f_time) * 0.9) * (1 - eag_claw_sync))
end

--Command handlers

function BrakeHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(man_brakes_L, 1 - get(man_brakes_L))
		set(man_brakes_R, 1 - get(man_brakes_R))
	end
end

function BrakeHoldHandler(phase)
	if phase == SASL_COMMAND_CONTINUE then
		set(man_brakes_L, 1)
		set(man_brakes_R, 1)
	elseif phase == SASL_COMMAND_END then
		set(man_brakes_L, 0)
		set(man_brakes_R, 0)
	end
end

function ParkBrakeHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		if get(man_brakes_L) == 1 and get(man_brakes_R) == 1 then
			set(park_brake, 1 - get(park_brake))
			if get(park_brake) == 0 then
				set(man_brakes_L, 0)
				set(man_brakes_R, 0)
			end
		end
	end
end

function GearUp(phase)
	if phase == SASL_COMMAND_BEGIN then
		if get(on_ground) == 1 then
			if get(lock_ovrd) == 1 and get(normal_gear) == 1 then
				set(normal_gear, 0)
			end
		else
			set(normal_gear, 0)
		end
	end
end

function ToggleGear(phase)
	if phase == SASL_COMMAND_BEGIN then
		if get(on_ground) == 1 and get(normal_gear) == 1 then
			if get(lock_ovrd) == 1 then
				set(normal_gear, 0)
			end
		else
			set(normal_gear, 1 - get(normal_gear))
		end
	end
end

--Registering own command handlers

sasl.registerCommandHandler(toggle_regular, 1, BrakeHandler)
sasl.registerCommandHandler(hold_regular, 1, BrakeHoldHandler)
sasl.registerCommandHandler(toggle_max, 1, ParkBrakeHandler)
sasl.registerCommandHandler(gear_up, 0, GearUp)
sasl.registerCommandHandler(gear_toggle, 0, ToggleGear)

function onAirportLoaded()
	temp_v = get(c_time)
	brake_L_temp = get(oat)
	brake_R_temp = get(oat)
	for i=1,3 do
		truck_brake_temp_L[i] = get(oat)
		truck_brake_temp_R[i] = get(oat)
	end
	if get(ra_pilot) < 5 or get(ra_copilot) < 5 then
		set(park_brake, 1)
	end
end

onAirportLoaded() --This is to make sure that everything is set if sasl has been rebooted

function update()
	set(gear_ovrd, 6)
	UpdateLdgTarget()
	UpdateBrakeTgt()
	UpdateActuatorPress()
	MoveGear()
	UpdateTruckBrakes()
	set(Xplane_park_brake, get(park_brake))
	ApplyBrakingWithAntiSkid(L_brake_tgt, R_brake_tgt)
	UpdateBrakeAcc()
	UpdateBrakeOnTime()
	UpdateBrakeTemperatures(0.5)
	UpdateTirePsi()
	UpdateDRefs()
	UpdateGearStrg(0.8)
end