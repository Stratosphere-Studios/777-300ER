--[[
*****************************************************************************************
* Script Name: pfc_logic
* Author Name: @bruh
* Script Description: Code for pfc logic
*****************************************************************************************
--]]

include("misc_tools.lua")
include("fbw_test_drefs.lua")
include("fbw_controllers.lua")
include("ap_roll.lua")
include("ap_pitch.lua")

--Switches
pitch_trim_A = globalPropertyi("Strato/777/cockpit/switches/strim_A")
pitch_trim_B = globalPropertyi("Strato/777/cockpit/switches/strim_B")
pitch_trim_altn = globalPropertyi("Strato/777/cockpit/switches/strim_altn")
ap_disc_bar = globalPropertyi("Strato/777/mcp/ap_disc_bar")

fbw_iasln = globalProperty("Strato/777/fctl/iasln_table")
ace_fail = globalProperty("Strato/777/failures/fctl/ace")
pfc_disc = globalPropertyi("Strato/777/fctl/pfc/disc")
--Autopilot
ap_disc = globalPropertyi("Strato/777/autopilot/disc")
--Data bus
pfc_calc = globalPropertyi("Strato/777/fctl/databus/calc")
pfc_pilot_input = globalProperty("Strato/777/fctl/databus/pilot_input")
pfc_maneuver_speeds = globalProperty("Strato/777/fctl/databus/maneuver_speeds")
pfc_ra = globalPropertyf("Strato/777/fctl/databus/rad_alt")
pfc_alt_baro = globalPropertyf("Strato/777/fctl/databus/alt_baro")
pfc_cas = globalPropertyf("Strato/777/fctl/databus/cas")
pfc_flt_axes = globalProperty("Strato/777/fctl/databus/flt_axes") --pitch, roll, yaw
pfc_slip = globalPropertyf("Strato/777/fctl/databus/slip")
pfc_thrust = globalProperty("Strato/777/fctl/databus/thrust")
pfc_flaps = globalPropertyf("Strato/777/fctl/databus/flaps")
pfc_mass = globalPropertyf("Strato/777/fctl/databus/mass_total")
pfc_ths_current = globalPropertyf("Strato/777/fctl/databus/ths_current")
pfc_stab_trim_operative = globalPropertyi("Strato/777/fctl/databus/stab_trim_op")
--Pfc output
fbw_mode = globalProperty("Strato/777/fctl/pfc/mode")
pfc_overbank = globalPropertyi("Strato/777/fctl/pfc/overbank")
pfc_roll_command = globalPropertyf("Strato/777/fctl/pfc/roll")
pfc_elevator_command = globalPropertyf("Strato/777/fctl/pfc/elevator")
pfc_rudder_command = globalPropertyf("Strato/777/fctl/pfc/rudder")
pfc_stab_trim_cmd = globalPropertyf("Strato/777/fctl/pfc/stab_trim")
fbw_self_test = globalPropertyi("Strato/777/fctl/pfc/selftest")
fbw_trim_speed = globalPropertyf("Strato/777/fctl/trs")

--position
yaw_rate_accel = globalPropertyf("sim/flightmodel/position/R_dot")

--Operation
f_time = globalPropertyf("sim/operation/misc/frame_rate_period")
c_time = globalPropertyf("Strato/777/time/current")

--Failures
fbw_secondary_fail = globalPropertyi("Strato/777/failures/fctl/secondary")
fbw_direct_fail = globalPropertyi("Strato/777/failures/fctl/direct")

pid_d_maintain = {4.1, 0.01}
d_int = {2.8, 2.9, 2.9, 3.1, 3.1, 3.9, 3.5, 3.3, 3.3}
pid_trs_maintain = {-0.19, -0.023, 0}
pid_gust_supr = {0.12, 0.03, 0}
pid_coefficients_rudder = {0.38, 0.08, 0}
flap_settings = {0, 1, 9, 15, 20, 25, 30}
--Fly by wire pitch gains
linear_corrections = {0.075, 0.095, 0.135, 0.19, 0.21, 0.225, 0.225}
--Zero pitch speeds per total mass in kg / 10000
no_pitch_speeds = 
{
	{21, 252, 240, 208, 156, 135, 133, 133},
	{22, 257, 244, 212, 160, 138, 136, 136},
	{24, 264, 253, 219, 165, 145, 141, 140},
	{26, 273, 261, 227, 172, 151, 148, 145},
	{28, 281, 269, 234, 180, 157, 153, 151},
	{30, 287, 276, 241, 187, 162, 158, 156},
	{32, 293, 284, 248, 193, 168, 164, 162},
	{34, 300, 290, 255, 199, 173, 169, 167},
	{35, 305, 294, 262, 202, 175, 172, 169}
}

thrust_corrections = 
{
	{21, 17.2},
	{22, 16.4},
	{24, 15},
	{26, 13.6},
	{28, 12.6},
	{30, 11.5},
	{32, 10.7},
	{34, 10.4},
	{35, 9.8}
}

--Other globals
ra_last = 0
gnd2air = false
air2gnd = false
flare_aoa_change = 0
k_fbw_pitch = 0
k_fbw_flare = 0
flprn_ratio_degrade = 0 --This is to increase stiffness of the yoke
man_pitch = 0
aoa_last = 0
pitch_input_last = 0
pitch_release_time = -2
pitch_time_no_delta = -2
p_delta_last = 0
roll_input_last = 0
heading_input_last = 0
fbw_roll_past = 0
fbw_yaw_past = 0
fbw_elevator_past = 0 --This is for stab trim
fbw_pitch = 0
stab_trim_engage = 0
tac_input_last = 0
--Pid globals
d_error_last = 0
ail_error_last = 0
e_error_last = 0
trs_error_last = 0
r_error_last = 0
d_error_total = 0
ail_error_total = 0
e_error_total = 0
trs_error_total = 0
r_error_total = 0
--Yaw damper
yaw_def_max = 8
bank_prot_active = false


trs_pid = PID:new{kp = -0.19, ki = -0.023, kd = 0, errtotal = 0, errlast = 0, lim_out = 25,  lim_et = 1000}
p_delta_pid = PID:new{kp = 4.1, ki = 0, kd = 0.01, errtotal = 0, errlast = 0, lim_out = 33,  lim_et = 100}
roll_maintain_pid = PID:new{kp = 0.013, ki = 0.0006, kd = 0, errtotal = 0, errlast = 0, lim_out = 1,  lim_et = 100}
gust_supr_pid = PID:new{kp = 0.4, ki = 0.1, kd = 0.2, errtotal = 0, errlast = 0, lim_out = 5,  lim_et = 10}
yaw_damp_pid = PID:new{kp = -0.8, ki = -0.2, kd = -0.15, errtotal = 0, errlast = 0, lim_out = 6,  lim_et = 50}


function GetGearStatus()
	local avg_gear_pos = (get(nw_actual) + get(mlg_actual_L) + get(mlg_actual_R)) / 3
	if avg_gear_pos <= 0.3 then
		return 0
	end
	return 1
end

function GetMassIndex(T, mass)
	local idx = 0
	for i = 1,tlen(T) do
		idx = i
		if T[i][1] >= mass then
			break
		end
	end
	if idx == 1 then
		idx = idx + 1
	end
	return idx
end

function GetPitchCorrection(mass, m_idx, thrust, trim_speed)
	local flap_idx = lim(getGreaterThan(flap_settings, get(pfc_flaps)), 8, 1)
	local r1 = (no_pitch_speeds[m_idx][2 + flap_idx - 1] - no_pitch_speeds[m_idx-1][2 + flap_idx - 1]) / (no_pitch_speeds[m_idx][1] - no_pitch_speeds[m_idx-1][1])
	local r2 = (thrust_corrections[m_idx][2] - thrust_corrections[m_idx-1][2]) / (thrust_corrections[m_idx][1] - thrust_corrections[m_idx-1][1])
	local speed = (mass - no_pitch_speeds[m_idx-1][1]) * r1 + no_pitch_speeds[m_idx-1][2 + flap_idx - 1]
	set(calc_sp, speed)
	local thrust_coeff = (mass - thrust_corrections[m_idx-1][1]) * r2 + thrust_corrections[m_idx-1][2]
	--local ias_correction_linear = linear_corrections[flap_idx] * (speed - trim_speed)
	local ias_correction_linear = get(fbw_iasln, flap_idx) * (speed - trim_speed)
	local thrust_correction = thrust_coeff * thrust
	return ias_correction_linear + thrust_correction
end

function UpdatePFCElevatorCommand(pitch_input_last, pitch_last, k_pitch, k_flare, flare_pitch_change)
	local avg_ra = get(pfc_ra)
	if avg_ra > 5 then
		local avg_cas = get(pfc_cas)
		local avg_pitch = get(pfc_flt_axes, 1)
		local p_delta = get(pfc_pilot_input, 3) - pitch_input_last
		local abs_p_delta = math.abs(get(pfc_pilot_input, 3)) - math.abs(pitch_input_last)
		local pitch_input_last = get(pfc_pilot_input, 3)
		if avg_ra >= 100 and ra_last < 100 then
			gnd2air = true
			air2gnd = false
			flare_pitch_change = 0
		elseif avg_ra < 200 and ra_last >= 200 then
			gnd2air = false
			air2gnd = true
			flare_pitch_change = (-2 - avg_pitch) / 4
		else
			gnd2air = false
			air2gnd = false
		end
		--Since PIDs will react to configuration change in the same manner as to a change in speed,
		--there will be some constant error left out that they won't be able to reduce, thus we 
		--need to calculate how much we need to adjust the pitch that we use in calculations
		--to eliminate this error
		local tmp_mass = get(pfc_mass) / 10000
		local m_i = GetMassIndex(no_pitch_speeds, tmp_mass)
		local thrust_fac_L = (get(pfc_thrust, 1) - 16000) / 334000
		local thrust_fac_R = (get(pfc_thrust, 2) - 16000) / 334000
		local thrust_fac_total = (thrust_fac_L + thrust_fac_R) / 2
		fbw_pitch = GetPitchCorrection(tmp_mass, m_i, thrust_fac_total, get(fbw_trim_speed))

		local ap_pitch_is_on = ap_pitch_engaged and get(ap_engaged) == 1

		if avg_ra > 100 then
			if not air2gnd and not gnd2air then
				if math.abs(get(pfc_pilot_input, 3)) >= 0.4 and abs_p_delta >= 0 then
					k_pitch = 1 - math.abs(get(pfc_pilot_input, 3)) + 0.4
				else
					k_pitch = EvenChange(k_pitch, 1, 0.001)
				end
			end
			set(roll_maint, k_pitch)
			--Transition from ground to air law
			if gnd2air and k_pitch < 1 then
				k_pitch = EvenChange(k_pitch, 1, 0.001)
			elseif gnd2air and k_pitch >= 1 then
				gnd2air = false
			end
			--Limit trs
			if get(fbw_trim_speed) == 0 then
				set(fbw_trim_speed, avg_cas)
			else
				local tmp = lim(get(fbw_trim_speed), get(pfc_maneuver_speeds, 1), get(pfc_maneuver_speeds, 2))
				set(fbw_trim_speed, tmp)
			end

			if not ap_pitch_is_on then
				--Calculating the pitch angle
				trs_pid:update{tgt = round(get(fbw_trim_speed)), curr = avg_cas}
				fbw_pitch = fbw_pitch + trs_pid.output

				--pitch_ovrd dataref is for testing ONLY!

				if get(pitch_ovrd) == 0 then
					fbw_pitch = fbw_pitch + trs_pid.output
				else
					fbw_pitch = 0
				end
			end
		else
			if air2gnd and avg_ra < ra_last and k_flare < 1 then
				k_flare = EvenChange(k_flare, 1, 0.005)
				k_pitch = 1 - k_flare
			elseif air2gnd and avg_ra >= ra_last and k_flare > 0 then
				k_flare = EvenChange(k_flare, 0, 0.005)
			elseif air2gnd and (avg_ra >= ra_last and k_flare <= 0) 
				or (avg_ra < ra_last and k_flare >= 1) then
				air2gnd = false
			end
		end
		
		local commanded_pitch = 0
		local ap_pitch_cmd = getAutopilotPitchCmd()
		local tmp_int = d_int[m_i] + ((d_int[m_i] - d_int[m_i-1]) * (tmp_mass - 
				no_pitch_speeds[m_i-1][1])) / (no_pitch_speeds[m_i][1] - no_pitch_speeds[m_i-1][1])
		local k_fbw = 0.15
		if not ap_pitch_is_on then
			k_fbw = 0.05
			if math.abs(get(pfc_pilot_input, 3)) > 0.08 then
				local k_man = 3.7 + 2 * math.abs(get(pfc_pilot_input, 3))
				commanded_pitch = get(pfc_pilot_input, 3) * k_man
			end
		else
			fbw_pitch = ap_pitch_cmd
			air2gnd = false
			gnd2air = false
			k_flare = 0
			k_pitch = 1
		end
		set(fbw_pitch_cmd, fbw_pitch)
		--Maintain a certain pitch speed
		local fbw_delta = (fbw_pitch - avg_pitch) * k_fbw
		local curr_delta = (avg_pitch - pitch_last) * (1 / get(f_time))
		p_delta_pid:update{tgt = fbw_delta * k_pitch 
							+ flare_pitch_change * k_flare
							 + commanded_pitch, 
							curr = curr_delta, ki = tmp_int}
		set(pitch_delta, curr_delta)
		local elevator_cmd_last = get(pfc_elevator_command)
		set(pfc_elevator_command,elevator_cmd_last + (p_delta_pid.output - 
			elevator_cmd_last) * 0.04)
		pitch_last = avg_pitch
		fbw_elevator_past = get(pfc_elevator_command)
		p_delta_last = p_delta
		ra_last = avg_ra
	else
		set(fbw_trim_speed, 0)
		set(pfc_elevator_command, 27 * get(pfc_pilot_input, 3))
		k_pitch = 0
	end
	return {pitch_input_last, pitch_last, k_pitch, k_flare, flare_pitch_change}
end

function UpdateRollYawCommand(roll_input_last, heading_input_last, fbw_roll_past)
    local avg_roll = get(pfc_flt_axes, 2)
	local avg_cas = get(pfc_cas)
	local r_delta = get(pfc_pilot_input, 1) - roll_input_last
	local h_delta = get(pfc_pilot_input, 2) - heading_input_last
	local roll_input_last = get(pfc_pilot_input, 1)
	local heading_input_last = get(pfc_pilot_input, 2)
	local ail_component = 0 --For rudder to cw cross tie
	if get(fbw_mode) == 1 then
		--Engage bank angle protection if bank is higher than 30 degrees
		if fbw_roll_past > 35 then
			fbw_roll_past = 30
		elseif fbw_roll_past < -35 then
			fbw_roll_past = -30
		end
		if math.abs(avg_roll) > 35 and get(ap_disc_bar) == 0 then
			bank_prot_active = true
			set(pfc_overbank, 1)
		else
			if math.abs(avg_roll) <= 30 or get(ap_disc_bar) == 1 then
				bank_prot_active = false
			end
			set(pfc_overbank, 0)
		end

		local ap_roll_cmd = getAutopilotRollCmd()

		if ap_roll_engaged and get(ap_engaged) == 1 then
			set(pfc_roll_command, get(pfc_roll_command) + (ap_roll_cmd - 
				get(pfc_roll_command)) * 0.7 * get(f_time))
		else
			set(pfc_roll_command, get(pfc_pilot_input, 1))
		end
		
		--Rudder logic
		if avg_cas <= 210 and get(fbw_mode) == 1 and math.abs(get(pfc_pilot_input, 1)) > 0.4 then
			local sign_term = bool2num(get(pfc_pilot_input, 1) > 0) - bool2num(get(pfc_pilot_input, 1) < 0)
			ail_component = sign_term * (math.abs(get(pfc_pilot_input, 1) - 0.4)) / 0.8 --Tie rudder to ailerons below 210 kias 
		end
	end
	--Rudder logic
    local rud_engage_nml = math.abs(get(pfc_pilot_input, 2)) <= 0.14 and h_delta <= 0.07
	local rud_out = get(pfc_pilot_input, 2) * 27
	if not bank_prot_active then
		rud_out = rud_out + ail_component * 8
		if ail_component < 2 then
			--[[local supr_out = 0
			if Round(math.abs(get(pfc_pilot_input, 1)), 2) <= 0.07 and get(fbw_mode) == 1 then
				gust_supr_pid:update{tgt = ((avg_roll - fbw_roll_past) * 0.6), curr = avg_roll - fbw_roll_past}
				supr_out = gust_supr_pid.output
				set(errtotal, gust_supr_pid.errtotal)
			end
			local sign_term = bool2num(avg_roll > 0) - bool2num(avg_roll < 0)
			local yaw_term = 0.011 * avg_roll^2 * sign_term
			local tgt_yaw = lim((yaw_term - get(pfc_flt_axes, 3)) * 0.17 + supr_out, yaw_def_max, -yaw_def_max) + ail_component * 8]]--
			yaw_damp_pid:update{tgt=0, curr=get(yaw_rate_accel)}
			set(dr_errtotal, yaw_damp_pid.errtotal)
			
			local tgt_yaw = yaw_damp_pid.output
			rud_out = rud_out + tgt_yaw * 0.7 * get(f_time)
		end
	else
		roll_maintain_pid:update{tgt = avg_roll * 0.55,  curr = fbw_roll_past - avg_roll}
		rud_out = rud_out - roll_maintain_pid.output * 27
	end
	rud_out = lim(rud_out, 27, -27)
	set(pfc_rudder_command, rud_out / 27)
	local fbw_roll_past = avg_roll
	return {roll_input_last, heading_input_last, fbw_roll_past}
end

function UpdateStabTrim()
	local delta_limit = 0.33
	local pitch_limit = 0.3
	if get(pfc_stab_trim_operative) == 1 then
		if math.abs(fbw_elevator_past - get(pfc_elevator_command)) < delta_limit and math.abs(get(pfc_elevator_command)) > pitch_limit then
			if stab_trim_engage == 0 then
				pitch_time_no_delta = get(c_time)
				stab_trim_engage = 1
			end
			if stab_trim_engage == 1 and pitch_time_no_delta + 2 < get(c_time) then
				local s_ = 0.0002
				if get(pfc_flaps) > 4 then
					s_ = 0.00045
				end
				local step = (-bool2num(get(pfc_elevator_command) < 0) + bool2num(get(pfc_elevator_command) >= 0)) * s_
				if math.abs(get(pfc_ths_current) + step) < 1 then
					set(pfc_stab_trim_cmd, get(pfc_ths_current) + step)
				end
			end
		else
			stab_trim_engage = 0
		end
	else
		stab_trim_engage = 0
	end
end

function UpdateMode()
	if get(fbw_secondary_fail) == 1 or get(fbw_direct_fail) == 1 then
		if get(fbw_secondary_fail) == 1 then
			set(fbw_mode, 2)
		end
		if get(fbw_direct_fail) == 1 then
			set(fbw_mode, 3)
		end
	else
		if get(pfc_disc) == 1 then
			set(fbw_mode, 3)
		else
			local n_ace_fail = 0
			for i=1,4 do
				if get(ace_fail, i) == 1 then
					n_ace_fail = n_ace_fail + 1
				end
			end
			if n_ace_fail == 3 then
				set(fbw_mode, 2)
			elseif n_ace_fail == 4 then
				set(fbw_mode, 3)
			else
				set(fbw_mode, 1)
			end
		end
	end
end

function update()
	UpdateMode()
	if get(pfc_calc) == 1 and get(f_time) ~= 0 then
		if get(fbw_mode) == 1 then
			if ((get(pitch_trim_A) ~= 0 and get(pitch_trim_B) ~= 0) or 
				get(pitch_trim_altn) ~= 0)
				and get(ap_engaged) == 1 then
				local avg_spd = (get(cas_pilot) + get(cas_copilot)) / 2
				set(fbw_trim_speed, avg_spd)
				set(ap_engaged, 0)
				set(ap_disc, 1)
			end

			local tmp = UpdatePFCElevatorCommand(pitch_input_last, aoa_last, 
												k_fbw_pitch, k_fbw_flare, flare_aoa_change)
			pitch_input_last = tmp[1]
			aoa_last = tmp[2]
			k_fbw_pitch = tmp[3]
			k_fbw_flare = tmp[4]
			flare_aoa_change = tmp[5]
			UpdateStabTrim()

			if get(ap_engaged) == 1 then
				set(ap_disc, 0)
			end
		elseif get(ap_engaged) == 1 then
			set(ap_engaged, 0)
			set(ap_disc, 1)
		end
		local tmp = UpdateRollYawCommand(roll_input_last, heading_input_last, fbw_roll_past)
		roll_input_last = tmp[1]
		heading_input_last = tmp[2]
		fbw_roll_past = tmp[3]
	end
	local ap_roll_cmd = getAutopilotRollCmd()
	local ap_pitch_cmd = getAutopilotPitchCmd()
end