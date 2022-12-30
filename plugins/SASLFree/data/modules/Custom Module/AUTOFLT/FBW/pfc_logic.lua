--[[
*****************************************************************************************
* Script Name: pfc_logic
* Author Name: @bruh
* Script Description: Code for pfc logic
*****************************************************************************************
--]]

include("misc_tools.lua")
include("fbw_test_drefs.lua")

fbw_iasln = globalProperty("Strato/777/fctl/iasln_table")
ace_fail = globalProperty("Strato/777/failures/fctl/ace")
pfc_disc = globalPropertyi("Strato/777/fctl/pfc/disc")
--Data bus
pfc_calc = globalPropertyi("Strato/777/fctl/databus/calc")
pfc_pilot_input = globalProperty("Strato/777/fctl/databus/pilot_input")
pfc_maneuver_speeds = globalProperty("Strato/777/fctl/databus/maneuver_speeds")
pfc_ra = globalPropertyf("Strato/777/fctl/databus/rad_alt")
pfc_alt_baro = globalPropertyf("Strato/777/fctl/databus/alt_baro")
pfc_cas = globalPropertyf("Strato/777/fctl/databus/cas")
pfc_flt_axes = globalProperty("Strato/777/fctl/databus/flt_axes") --pitch, roll
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

--Operation
f_time = globalPropertyf("sim/operation/misc/frame_rate_period")
c_time = globalPropertyf("Strato/777/time/current")

pid_d_maintain = {4.1, 0.01}
d_int = {2.8, 2.9, 2.9, 3.1, 3.1, 3.9, 3.5, 3.3, 3.3}
pid_trs_maintain = {-0.19, -0.023, 0}
pid_gust_supr = {0.12, 0.03, 0}
pid_coefficients_rudder = {0.38, 0.08, 0}
flap_settings = {0, 1, 5, 15, 20, 25, 30}
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
ace_fail_past = 0
pfc_disc_past = 0
flprn_ratio_degrade = 0 --This is to increase stiffness of the yoke
man_pitch = 0
pitch_last = 0
pitch_input_last = 0
pitch_release_time = -2
pitch_time_no_delta = -2
p_delta_last = 0
roll_input_last = 0
heading_input_last = 0
fbw_roll_past = 0
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

function UpdatePFCElevatorCommand()
	local avg_ra = get(pfc_ra)
	if avg_ra > 5 then
		local avg_cas = get(pfc_cas)
		local avg_pitch = get(pfc_flt_axes, 1)
		local p_delta = get(pfc_pilot_input, 3) - pitch_input_last
		pitch_input_last = get(pfc_pilot_input, 3)
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
		if avg_ra > 100 then
			--Limit trs
			if get(fbw_trim_speed) == 0 then
				set(fbw_trim_speed, avg_cas)
			else
				local tmp = lim(get(fbw_trim_speed), get(pfc_maneuver_speeds, 1), get(pfc_maneuver_speeds, 2))
				set(fbw_trim_speed, tmp)
			end
			--Calculating the pitch angle
			local tmp_pitch = PID_Compute(pid_trs_maintain[1], pid_trs_maintain[2], pid_trs_maintain[3], round(get(fbw_trim_speed)), avg_cas, trs_error_total, trs_error_last, 1000, 25)
			--local tmp_pitch = PID_Compute(get(pt), get(it), get(dt), round(get(fbw_trim_speed)), avg_cas, trs_error_total, trs_error_last, 1000, 25)
			set(errtotal, tmp_pitch[2])
            fbw_pitch = fbw_pitch + tmp_pitch[1]
			if get(pitch_ovrd) == 0 then
				fbw_pitch = fbw_pitch + tmp_pitch[1]
			else
				fbw_pitch = 0
			end
			trs_error_total = tmp_pitch[2]
			trs_error_last = tmp_pitch[3]
		end
		set(fbw_pitch_cmd, fbw_pitch)
		if get(f_time) ~= 0 then
			local commanded_pitch = 0
			local tmp_int = d_int[m_i] + ((d_int[m_i] - d_int[m_i-1]) * (tmp_mass - no_pitch_speeds[m_i-1][1])) / (no_pitch_speeds[m_i][1] - no_pitch_speeds[m_i-1][1])
			if math.abs(get(pfc_pilot_input, 3)) > 0.08 then
				commanded_pitch = get(pfc_pilot_input, 3) * 5.7
			end
			--Maintain a certain pitch rate
			local fbw_delta = (fbw_pitch - avg_pitch) * 0.3
			local curr_delta = (avg_pitch - pitch_last) * (1 / get(f_time))
			local tmp = PID_Compute(pid_d_maintain[1], tmp_int, pid_d_maintain[2], fbw_delta + commanded_pitch, curr_delta, d_error_total, d_error_last, 100, 33)
			--local tmp = PID_Compute(get(pt), get(it), get(dt), get(delta_maintain), curr_delta, d_error_total, d_error_last, 100, 20)
			set(pitch_delta, curr_delta)
			set(pfc_elevator_command, tmp[1])
			d_error_total = tmp[2]
			d_error_last = tmp[3]
			pitch_last = avg_pitch
		end
		fbw_elevator_past = get(pfc_elevator_command)
		p_delta_last = p_delta
	else
		set(fbw_trim_speed, 0)
		set(pfc_elevator_command, 20 * get(pfc_pilot_input, 3))
	end
end

function UpdateRollCommand()
    local avg_roll = get(pfc_flt_axes, 2)
	local avg_cas = get(pfc_cas)
	local r_delta = get(pfc_pilot_input, 1) - roll_input_last
	local h_delta = get(pfc_pilot_input, 2) - heading_input_last
	roll_input_last = get(pfc_pilot_input, 1)
	heading_input_last = get(pfc_pilot_input, 2)
	local bank_correction_rudder = false
	local bank_correction_ail = false
	local ail_component = 0 --For rudder to cw cross tie
	if r_delta ~= 0 then
		fbw_roll_past = avg_roll
		--r_error_total = 0
	end
	if get(fbw_mode) == 1 then
		--Engage bank angle protection if bank is higher than 30 degrees
		if fbw_roll_past > 30 then
			fbw_roll_past = 30
		elseif fbw_roll_past < -30 then
			fbw_roll_past = -30
		end
		if math.abs(avg_roll) > 35 then
			bank_correction_rudder = true
			set(pfc_overbank, 1)
			if math.abs(get(pfc_pilot_input, 1)) < 0.9 then
				bank_correction_ail = true
			end
		else
			set(pfc_overbank, 0)
		end
		--set(fbw_roll_dref, fbw_roll_past)
		--Aileron logic
    	local ail_engage_nml = r_delta <= 0.1 and math.abs(get(pfc_pilot_input, 1)) < 0.2
		if (ail_engage_nml or bank_correction_ail == true) then
			local tmp = PID_Compute(pid_gust_supr[1], pid_gust_supr[2], pid_gust_supr[3], fbw_roll_past, avg_roll, ail_error_total, ail_error_last, 600, 18)
			--local tmp = PID_Compute(get(pt), get(it), get(dt), fbw_roll_past, avg_roll, ail_error_total, ail_error_last, 600, 18)
			set(pfc_roll_command, tmp[1])
			ail_error_total = tmp[2]
			ail_error_last = tmp[3]
		else
			set(pfc_roll_command, get(pfc_pilot_input, 1) * 18)
		end
		--Rudder logic
		if avg_cas <= 210 and get(fbw_mode) == 1 and math.abs(get(pfc_pilot_input, 1)) > 0.4 then
			ail_component = get(pfc_pilot_input, 1) --Tie rudder to ailerons below 210 kias 
		end
	end
	--Rudder logic
    local rud_engage_nml = math.abs(get(pfc_pilot_input, 2)) <= 0.14 and h_delta <= 0.07
	if (rud_engage_nml or bank_correction_rudder == true) then
		local tmp = PID_Compute(pid_coefficients_rudder[1], pid_coefficients_rudder[2], pid_coefficients_rudder[3], fbw_roll_past, avg_roll, r_error_total, r_error_last, 600, 27)
		--local tmp = PID_Compute(get(pt), get(it), get(dt), fbw_roll_past, avg_roll, r_error_total, r_error_last, 300, 27)
		--set(fbw_r_past, fbw_roll_past)
		set(pfc_rudder_command, tmp[1] + ail_component * 8)
		r_error_total = tmp[2]
		r_error_last = tmp[3]
	else
		tgt = get(pfc_pilot_input, 2) * 27 + ail_component * 8
		tgt = lim(tgt, 27, -27)
		set(pfc_rudder_command, tgt)
	end
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
				if get(pfc_flaps) > 5 then
					s_ = 0.0001
				end
				local step = (-bool2num(get(pfc_elevator_command) < 0) + bool2num(get(pfc_elevator_command) >= 0)) * s_ * Round(get(f_time), 4) / 0.0166
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
	if get(pfc_disc) == 1 and pfc_disc_past == 0 then
		set(fbw_mode, 3)
	else
		local n_ace_fail = 0
		for i=1,4 do
			if get(ace_fail, i) == 1 then
				n_ace_fail = n_ace_fail + 1
			end
		end
		if n_ace_fail ~= ace_fail_past or pfc_disc_past ~= get(pfc_disc) then
			if n_ace_fail == 3 then
				set(fbw_mode, 2)
			elseif n_ace_fail == 4 then
				set(fbw_mode, 3)
			else
				set(fbw_mode, 1)
			end
			ace_fail_past = n_ace_fail
		end
	end
	pfc_disc_past = get(pfc_disc)
end

function update()
	UpdateMode()
	if get(pfc_calc) == 1 then
		if get(fbw_mode) == 1 then
			UpdatePFCElevatorCommand()
			UpdateStabTrim()
		end
		UpdateRollCommand()
	end
end