--[[
*****************************************************************************************
* Script Name: eicas
* Author Name: @bruh
* Script Description: Code for flybywire pid
*****************************************************************************************
--]]

include("misc_tools.lua")

--Getting handles to sim datarefs

--Cockpit controls
yoke_pitch_ratio = globalPropertyf("sim/cockpit2/controls/yoke_pitch_ratio")
yoke_roll_ratio = globalPropertyf("sim/cockpit2/controls/yoke_roll_ratio")
yoke_heading_ratio = globalPropertyf("sim/cockpit2/controls/yoke_heading_ratio")
stab_trim = globalPropertyf("sim/cockpit2/controls/elevator_trim")
throttle_pos = globalPropertyf("sim/cockpit2/engine/actuators/throttle_ratio_all")
ths_degrees = globalPropertyf("sim/flightmodel2/controls/stabilizer_deflection_degrees")
--Control surfaces
flaps = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 1)
--Engine datarefs
thrust_engn_L = globalPropertyfae("sim/flightmodel/engine/POINT_thrust", 1)
thrust_engn_R = globalPropertyfae("sim/flightmodel/engine/POINT_thrust", 2)
--Indicators
vspeed = globalPropertyf("sim/flightmodel/position/vh_ind_fpm")
altitude_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/altitude_ft_pilot")
altitude_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/altitude_ft_copilot")
altitude_stdby = globalPropertyf("sim/cockpit2/gauges/indicators/altitude_ft_stby")
ra_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")
ra_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_copilot")
cas_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
pitch_pilot = globalPropertyf("sim/cockpit/gyros/the_ind_ahars_pilot_deg")
roll_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/roll_AHARS_deg_pilot")
cas_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_copilot")
pitch_copilot = globalPropertyf("sim/cockpit/gyros/the_ind_ahars_copilot_deg")
roll_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/roll_AHARS_deg_copilot")
--Gear positions
nw_actual = globalPropertyfae("sim/aircraft/parts/acf_gear_deploy", 1)
mlg_actual_R = globalPropertyfae("sim/aircraft/parts/acf_gear_deploy", 2)
mlg_actual_L = globalPropertyfae("sim/aircraft/parts/acf_gear_deploy", 3)
--Operation
f_time = globalPropertyf("sim/operation/misc/frame_rate_period")
on_ground = globalPropertyi("sim/flightmodel/failures/onground_any")
c_time = globalPropertyf("Strato/777/time/current")

--Own datarefs
max_allowable = globalPropertyi("Strato/777/fctl/vmax")
stall_speed = globalPropertyi("Strato/777/fctl/vstall")
manuever_speed = globalPropertyi("Strato/777/fctl/vmanuever")
sys_C_press = globalPropertyfae("Strato/777/hydraulics/press", 2)
sys_R_press = globalPropertyfae("Strato/777/hydraulics/press", 3)
stab_cutout_C = globalPropertyi("Strato/777/fctl/stab_cutout_C")
stab_cutout_R = globalPropertyi("Strato/777/fctl/stab_cutout_R")
fbw_p_e = createGlobalPropertyi("Strato/777/fctl/pitch_engage", 0)
flap_tgt = globalPropertyf("Strato/777/flaps/tgt")

--Creating our own
pfc_overbank = createGlobalPropertyi("Strato/777/fctl/pfc/overbank", 0)
pfc_roll_command = createGlobalPropertyf("Strato/777/fctl/pfc/roll", 0)
pfc_elevator_command = createGlobalPropertyf("Strato/777/fctl/pfc/elevator", 0)
pfc_rudder_command = createGlobalPropertyf("Strato/777/fctl/pfc/rudder", 0)
fbw_trim_speed = createGlobalPropertyf("Strato/777/fctl/trs", 210)
fbw_pitch_dref = createGlobalPropertyf("Strato/777/fctl/pitch", 0)
fbw_roll_dref = createGlobalPropertyf("Strato/777/fctl/roll", 0)
fbw_ail_ratio = createGlobalPropertyf("Strato/777/fctl/ail_ratio", 0)
fbw_flprn_ratio_l = createGlobalPropertyf("Strato/777/fctl/flprn_ratio_l", 0)
fbw_flprn_ratio_u = createGlobalPropertyf("Strato/777/fctl/flprn_ratio_u", 0)
t_fac = createGlobalPropertyf("Strato/777/fctl/t_factor", 0)
p_last = createGlobalPropertyf("Strato/777/fctl/p_last", 0)

pt = createGlobalPropertyf("Strato/777/test/kp", -0.16)
it = createGlobalPropertyf("Strato/777/test/ip", -0.09)
dt = createGlobalPropertyf("Strato/777/test/dp", -0.01)
correction = createGlobalPropertyf("Strato/777/test/correction", -1.2)
flap_c = createGlobalPropertyf("Strato/777/test/flap_correction", 0)
err_reset = createGlobalPropertyi("Strato/777/test/err_reset", 0)

-- -1.7, 3.4, -3
-- -1.1 -0.5
-- 2.6, 2.9, 0.1
pid_pitch_maintain = {0.4, 1.45, 0.1}
pid_trs_maintain = {-0.16, -0.09, -0.01}
pid_gust_supr = {0.3, 0.23, 0.13}
pid_coefficients_rudder = {0.43, 0.24, 0}
--Fly by wire pitch gains
flap_corrections = {-1.2, -1.4, -4.55, -11.95, -15.8, -15.8, -16.1}
flap_settings = {0, 1, 5, 15, 20, 25, 30}

flprn_ratio_degrade = 0 --This is to increase stiffness of the yoke
pitch_last = 0
pitch_input_last = 0
pitch_release_time = -2
pitch_time_no_delta = -2
p_delta_last = 0
roll_input_last = 0
heading_input_last = 0
fbw_roll_past = 0
fbw_elevator_past = 0
fbw_pitch_engage = 0
fbw_pitch = 0
stab_trim_engage = 0
ail_error_last = 0
e_error_last = 0
trs_error_last = 0
r_error_last = 0
ail_error_total = 0
e_error_total = 0
trs_error_total = 0
r_error_total = 0

--t_ratio = 0.779, 5.56 kias

function GetGearStatus()
	local avg_gear_pos = (get(nw_actual) + get(mlg_actual_L) + get(mlg_actual_R)) / 3
	if avg_gear_pos <= 0.3 then
		return 0
	end
	return 1
end

function limitTRS()
	if get(fbw_trim_speed) > get(max_allowable) then
		set(fbw_trim_speed, get(max_allowable))
	elseif get(fbw_trim_speed) < get(manuever_speed) then
		set(fbw_trim_speed, get(manuever_speed))
	end
end

function UpdateFBWAilRatio()
	--Speeds and altitudes for aileron lockout
	lockout_speeds = {280, 240, 240, 166}
	red_authority_speeds = {270, 230, 230, 152}
	lockout_alts = {11500, 19500, 26500, 43000}
	red_authority_alts = {9000, 17500, 25000, 43000}
	local avg_alt = (get(altitude_pilot) + get(altitude_copilot) + get(altitude_stdby)) / 3
	local avg_cas = (get(cas_pilot) + get(cas_copilot)) / 2
	local tmp_idx_1 = 0 --limit after which we start decreasing aileron ratio
	local tmp_idx_2 = 0 --limit after which we start blocking
	--find below which altitude we are from the pre defined alts for max and min limits
	for i=4,1,-1 do
		if avg_alt < red_authority_alts[i] then
			tmp_idx_1 = i
		elseif avg_alt == red_authority_alts[i] then
			tmp_idx_1 = i
			break
		else
			break
		end
	end
	for i=4,1,-1 do
		if avg_alt < lockout_alts[i] then
			tmp_idx_2 = i
		elseif avg_alt == lockout_alts[i] then
			tmp_idx_2 = i
			break
		else
			break
		end
	end
	--Calculate the speed limits for given config
	local speed_lim_min = 0
	local speed_lim_max = 0
	if tmp_idx_1 > 1 then
		speed_lim_min = red_authority_speeds[tmp_idx_1 - 1] + (red_authority_speeds[tmp_idx_1] - red_authority_speeds[tmp_idx_1 - 1]) * (avg_alt - red_authority_alts[tmp_idx_1 - 1]) / (red_authority_alts[tmp_idx_1] - red_authority_alts[tmp_idx_1 - 1])
	else
		speed_lim_min = red_authority_speeds[1]
	end
	if tmp_idx_2 > 1 then
		speed_lim_max = lockout_speeds[tmp_idx_2 - 1] + (lockout_speeds[tmp_idx_2] - lockout_speeds[tmp_idx_2 - 1]) * (avg_alt - lockout_alts[tmp_idx_2 - 1]) / (lockout_alts[tmp_idx_2] - lockout_alts[tmp_idx_2 - 1])
	else
		speed_lim_max = lockout_speeds[1]
	end
	if avg_cas <= speed_lim_min then
		set(fbw_ail_ratio, 36)
	elseif avg_cas > speed_lim_min and avg_cas < speed_lim_max then
		set(fbw_ail_ratio, 36 * (1 - ((avg_cas - speed_lim_min) / (speed_lim_max - speed_lim_min))))
	else
		set(fbw_ail_ratio, 0)
	end
end

function UpdateFlprnRatio()
	set(fbw_flprn_ratio_l, 40 * (1 - 0.4 * flprn_ratio_degrade))
	set(fbw_flprn_ratio_u, 18 * (1 - 0.4 * flprn_ratio_degrade))
end

function UpdatePFCElevatorCommand()
	if get(err_reset) == 1 then
		trs_error_total = 0
		trs_error_last = 0
		set(err_reset, 0)
	end
	local avg_cas = (get(cas_pilot) + get(cas_copilot)) / 2
	local avg_pitch = (get(pitch_pilot) + get(pitch_copilot)) / 2
	local avg_alt_baro = (get(altitude_pilot) + get(altitude_stdby) + get(altitude_copilot)) / 3
	local avg_ra = (get(ra_pilot) + get(ra_copilot)) / 2
	local p_delta = get(yoke_pitch_ratio) - pitch_input_last
	pitch_input_last = get(yoke_pitch_ratio)
	if fbw_pitch_engage == 0 and math.abs(p_delta) <= 0.07 and math.abs(get(yoke_pitch_ratio)) < 0.1 then
		pitch_release_time = get(c_time)
	end
	if math.abs(get(yoke_pitch_ratio)) < 0.1 and get(on_ground) == 0 and math.abs(p_delta) <= 0.07 then
		fbw_pitch_engage = 1
		if avg_ra > 200 and pitch_release_time + 3 < get(c_time) then
			--Since PIDs will react to configuration change in the same manner as to a change in speed,
			--there will be some constant error left out that they won't be able to reduce, thus we 
			--need to calculate how much we need to adjust the pitch that we use in calculations
			--to eliminate this error
			local flap_correction = 0
			for i=1,7 do
				if flap_settings[i] >= get(flaps) then
					flap_correction = flap_corrections[i]
					break
				end
			end
			local thrust_fac_L = (get(thrust_engn_L) - 24000) / 426000
			local thrust_fac_R = (get(thrust_engn_R) - 24000) / 426000
			local thrust_fac_total = (thrust_fac_L + thrust_fac_R) / 2
			local ias_correction_linear = 0.0718 * (280 - get(fbw_trim_speed))
			local thrust_coeff = 17.17
			if flap_correction == flap_corrections[-1] then
				thrust_coeff = 16.74
			end
			local thrust_correction = thrust_coeff * thrust_fac_total
			local gear_correction = -1.2 * GetGearStatus()
			--Calculating the pitch angle
			local tmp_pitch = PID_Compute(get(pt), get(it), get(dt), round(get(fbw_trim_speed)), avg_cas, trs_error_total, trs_error_last, 1000, 25)
			--local tmp_pitch = PID_Compute(pid_trs_maintain[1], pid_trs_maintain[2], pid_trs_maintain[3], round(get(fbw_trim_speed)), avg_cas, trs_error_total, trs_error_last, 100, 25)
			fbw_pitch = tmp_pitch[1]
			trs_error_total = tmp_pitch[2]
			trs_error_last = tmp_pitch[3]
			fbw_pitch = fbw_pitch + ias_correction_linear + thrust_correction + gear_correction + flap_correction
			--Limiting pitch because we don't want to subject the plane to extreme G-loads
			if fbw_pitch < -10 then
				fbw_pitch = -10
			elseif fbw_pitch > 25 then
				fbw_pitch = 25
			end
			set(fbw_pitch_dref, fbw_pitch)
			set(p_last, 0)
		else
			fbw_pitch = pitch_last
			set(p_last, 1)
		end
		--Calculating elevator output to maintain pitch
		local tmp = PID_Compute(pid_pitch_maintain[1], pid_pitch_maintain[2], pid_pitch_maintain[3], fbw_pitch, avg_pitch, e_error_total, e_error_last, 100, 20)
		set(pfc_elevator_command, tmp[1])
		e_error_total = tmp[2]
		e_error_last = tmp[3]
	else
		fbw_pitch_engage = 0
		set(pfc_elevator_command, get(yoke_pitch_ratio) * 20)
		pitch_last = avg_pitch
	end
	set(fbw_p_e, fbw_pitch_engage)
	fbw_elevator_past = get(pfc_elevator_command)
	p_delta_last = p_delta
end

function UpdateRudderCommand()
	local avg_roll = (get(roll_pilot) + get(roll_copilot)) / 2
	local avg_cas = (get(cas_pilot) + get(cas_copilot)) / 2
	local r_delta = get(yoke_roll_ratio) - roll_input_last
	local h_delta = get(yoke_heading_ratio) - heading_input_last
	roll_input_last = get(yoke_roll_ratio)
	heading_input_last = get(yoke_heading_ratio)
	local bank_correction_rudder = false
	local bank_correction_ail = false
	if r_delta ~= 0 then
		fbw_roll_past = avg_roll
	end
	--Engage bank angle protection if bank is higher than 30 degrees
	if fbw_roll_past > 30 then
		fbw_roll_past = 30
	elseif fbw_roll_past < -30 then
		fbw_roll_past = -30
	end
	if math.abs(avg_roll) > 35 then
		bank_correction_rudder = true
		set(pfc_overbank, 1)
		if math.abs(get(yoke_roll_ratio)) < 0.9 then
			bank_correction_ail = true
			flprn_ratio_degrade = 0
		else
			flprn_ratio_degrade = 1
		end
	else
		set(pfc_overbank, 0)
		flprn_ratio_degrade = 0
	end
	set(fbw_roll_dref, fbw_roll_past)
	--Aileron logic
	if r_delta <= 0.1 and math.abs(get(yoke_roll_ratio)) < 0.2 and get(on_ground) == 0 or bank_correction_ail == true then
		local tmp = PID_Compute(pid_gust_supr[1], pid_gust_supr[2], pid_gust_supr[3], fbw_roll_past, avg_roll, ail_error_total, ail_error_last, 200, 18)
		--local tmp = PID_Compute(get(pt), get(it), get(dt), fbw_roll_past, avg_roll, ail_error_total, ail_error_last, 200, 18)
		set(pfc_roll_command, tmp[1])
		ail_error_total = tmp[2]
		ail_error_last = tmp[3]
	else
		set(pfc_roll_command, get(yoke_roll_ratio) * 18)
	end
	--Rudder logic
	if math.abs(get(yoke_heading_ratio)) <= 0.14 and get(on_ground) == 0 and h_delta <= 0.07 or bank_correction_rudder == true then
		local tmp = PID_Compute(pid_coefficients_rudder[1], pid_coefficients_rudder[2], pid_coefficients_rudder[3], fbw_roll_past, avg_roll, r_error_total, r_error_last, 200, 27)
		set(pfc_rudder_command, tmp[1])
		r_error_total = tmp[2]
		r_error_last = tmp[3]
	else
		local ail_component = 0
		if get(on_ground) == 0 and avg_cas <= 210 then
			ail_component = get(yoke_roll_ratio) --Tie rudder to ailerons below 210 kias 
		end
		local tgt = (get(yoke_heading_ratio) - ail_component) * 8
		if tgt > 8 then
			tgt = 8
		elseif tgt < -8 then
			tgt = -8
		end
		set(pfc_rudder_command, tgt)
	end
end

function UpdateStabTrim()
	local delta_limit = 0.4
	local pitch_limit = 6
	if fbw_pitch_engage == 1 then
		delta_limit = 0.33
		pitch_limit = 0.3
	end
	if (get(sys_C_press) * (1 - get(stab_cutout_C)) > 900 or get(sys_R_press) * (1 - get(stab_cutout_R)) > 900) and get(on_ground) == 0 then
		if math.abs(fbw_elevator_past - get(pfc_elevator_command)) < delta_limit and math.abs(get(pfc_elevator_command)) > pitch_limit then
			if stab_trim_engage == 0 then
				pitch_time_no_delta = get(c_time)
				stab_trim_engage = 1
			end
			if stab_trim_engage == 1 and pitch_time_no_delta + 2 < get(c_time) then
				local s_ = 0.0002
				if get(flap_tgt) > 5 then
					s_ = 0.0001
				end
				local step = (-bool2num(get(pfc_elevator_command) < 0) + bool2num(get(pfc_elevator_command) >= 0)) * s_ * get(f_time) / 0.0166
				if math.abs(get(stab_trim) + step) < 1 then
					set(stab_trim, get(stab_trim) + step)
				end
			end
		else
			stab_trim_engage = 0
		end
	else
		stab_trim_engage = 0
	end
end

function update()
	limitTRS()
	set(ths_degrees, get(stab_trim) * -11)
	UpdateFBWAilRatio()
	UpdateFlprnRatio()
	UpdatePFCElevatorCommand()
	UpdateRudderCommand()
	UpdateStabTrim()
end