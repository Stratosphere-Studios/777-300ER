--[[
*****************************************************************************************
* Script Name: fbw_main
* Author Name: @bruh
* Script Description: All datarefs created for fbw go here
*****************************************************************************************
--]]

--Creating our own datarefs
--PFC datarefs
--data bus
pfc_calc = createGlobalPropertyi("Strato/777/fctl/databus/calc", 0) --whether or not PFCs should do calculations
pfc_pilot_input = createGlobalPropertyfa("Strato/777/fctl/databus/pilot_input", {0, 0, 0}) --roll, yaw, pitch
pfc_ra = createGlobalPropertyf("Strato/777/fctl/databus/rad_alt", 0)
pfc_alt_baro = createGlobalPropertyf("Strato/777/fctl/databus/alt_baro", 0)
pfc_cas = createGlobalPropertyf("Strato/777/fctl/databus/cas", 0)
pfc_flt_axes = createGlobalPropertyfa("Strato/777/fctl/databus/flt_axes", {0, 0, 0}) --pitch, roll, yaw
pfc_slip = createGlobalPropertyf("Strato/777/fctl/databus/slip", 0)
pfc_thrust = createGlobalPropertyfa("Strato/777/fctl/databus/thrust", {0, 0})
pfc_mass = createGlobalPropertyf("Strato/777/fctl/databus/mass_total", 0)
pfc_ths_current = createGlobalPropertyf("Strato/777/fctl/databus/ths_current", 0)
pfc_stab_trim_operative = createGlobalPropertyi("Strato/777/fctl/databus/stab_trim_op", 1)
pfc_stab_trim_cmd = createGlobalPropertyf("Strato/777/fctl/pfc/stab_trim", 0)
pfc_flaps = createGlobalPropertyf("Strato/777/fctl/databus/flaps", 0)
--Other
pfc_maneuver_speeds = createGlobalPropertyfa("Strato/777/fctl/databus/maneuver_speeds", {0, 0})
fbw_mode = createGlobalPropertyi("Strato/777/fctl/pfc/mode", 1)
pfc_disc = createGlobalPropertyi("Strato/777/fctl/pfc/disc", 0)
pfc_disc_light = createGlobalPropertyi("Strato/777/cockpit/lights/pfc_disc", 0)
tac_engage = createGlobalPropertyi("Strato/777/fctl/ace/tac_eng", 1)
tac_fail = createGlobalPropertyi("Strato/777/fctl/ace/tac_fail", 0)
pfc_overbank = createGlobalPropertyi("Strato/777/fctl/pfc/overbank", 0)
pfc_roll_command = createGlobalPropertyf("Strato/777/fctl/pfc/roll", 0)
pfc_elevator_command = createGlobalPropertyf("Strato/777/fctl/pfc/elevator", 0)
pfc_rudder_command = createGlobalPropertyf("Strato/777/fctl/pfc/rudder", 0)
fbw_self_test = createGlobalPropertyi("Strato/777/fctl/pfc/selftest", 0)
--ACE datarefs
ace_fail = createGlobalPropertyia("Strato/777/failures/fctl/ace", {0, 0, 0, 0}) --L1, L2, C, R
ace_aileron = createGlobalPropertyfa("Strato/777/fctl/ace/ailrn_cmd", {0, 0})
ace_flaperon = createGlobalPropertyfa("Strato/777/fctl/ace/flprn_cmd", {0, 0})
ace_spoiler = createGlobalPropertyfa("Strato/777/fctl/ace/spoiler_cmd", {0, 0, 0, 0})
ace_elevator = createGlobalPropertyfa("Strato/777/fctl/ace/elevator_cmd", {0, 0})
ace_rudder = createGlobalPropertyf("Strato/777/fctl/ace/rudder_cmd", 0)
ace_aileron_fail_L = createGlobalPropertyi("Strato/777/fctl/ace/ailrn_fail_L", 0)
ace_aileron_fail_R = createGlobalPropertyi("Strato/777/fctl/ace/ailrn_fail_R", 0)
ace_flaperon_fail_L = createGlobalPropertyi("Strato/777/fctl/ace/flprn_fail_L", 0)
ace_flaperon_fail_R = createGlobalPropertyi("Strato/777/fctl/ace/flprn_fail_R", 0)
ace_spoiler_fail_17 = createGlobalPropertyi("Strato/777/fctl/ace/ace_spoiler_fail_17", 0)
ace_spoiler_fail_2 = createGlobalPropertyi("Strato/777/fctl/ace/ace_spoiler_fail_2", 0)
ace_spoiler_fail_36 = createGlobalPropertyi("Strato/777/fctl/ace/ace_spoiler_fail_36", 0)
ace_spoiler_fail_4 = createGlobalPropertyi("Strato/777/fctl/ace/ace_spoiler_fail_4", 0)
ace_spoiler_fail_5 = createGlobalPropertyi("Strato/777/fctl/ace/ace_spoiler_fail_5", 0)
ace_elevator_fail_L = createGlobalPropertyi("Strato/777/fctl/ace/elevator_fail_L", 0)
ace_elevator_fail_R = createGlobalPropertyi("Strato/777/fctl/ace/elevator_fail_R", 0)
ace_rudder_fail = createGlobalPropertyi("Strato/777/fctl/ace/rudder_fail", 0)
--PCU modes
pcu_aileron = createGlobalPropertyia("Strato/777/fctl/pcu/ail", {0, 0})
pcu_flaperon = createGlobalPropertyia("Strato/777/fctl/pcu/flprn", {0, 0})
pcu_elevator = createGlobalPropertyia("Strato/777/fctl/pcu/elev", {0, 0})
pcu_rudder = createGlobalPropertyi("Strato/777/fctl/pcu/rudder", 0)
pcu_sp = createGlobalPropertyia("Strato/777/fctl/pcu/sp", {0, 0, 0, 0})
--General fbw datarefs
fbw_trim_speed = createGlobalPropertyf("Strato/777/fctl/trs", 0)
fbw_pitch_dref = createGlobalPropertyf("Strato/777/fctl/pitch", 0)
fbw_iasln = createGlobalPropertyfa("Strato/777/fctl/iasln_table", {0.084, 0.093, 0.112, 0.08, 0.16, 0.176, 0.19})
fbw_roll_dref = createGlobalPropertyf("Strato/777/fctl/roll", 0)
fbw_ail_ratio = createGlobalPropertyf("Strato/777/fctl/ail_ratio", 0)
fbw_flprn_ratio_l = createGlobalPropertyf("Strato/777/fctl/flprn_ratio_l", 0)
fbw_flprn_ratio_u = createGlobalPropertyf("Strato/777/fctl/flprn_ratio_u", 0)
p_last = createGlobalPropertyf("Strato/777/fctl/p_last", 0)
