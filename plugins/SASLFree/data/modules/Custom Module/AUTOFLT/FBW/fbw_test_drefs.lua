--[[
*****************************************************************************************
* Script Name: fbw_test_drefs
* Author Name: discord/bruh4096#4512(Tim G.)
* Script Description: Datarefs that are used FOR CALIBRATION ONLY. 
                      Include this in the pfc logic for testing
*****************************************************************************************
--]]

dr_kp = createGlobalPropertyf("Strato/777/test/kp", -0.8)
dr_ki = createGlobalPropertyf("Strato/777/test/ki", -0.2)
dr_kd = createGlobalPropertyf("Strato/777/test/kd", 0)
lp_alpha = createGlobalPropertyf("Strato/777/test/lp_alpha", 1)
r_delta_curr = createGlobalPropertyf("Strato/777/test/rdc", 0)
roll_maint = createGlobalPropertyf("Strato/777/test/rm", 0)
fbw_r_past = createGlobalPropertyf("Strato/777/test/fbw_r_past", 0)
fbw_pitch_cmd = createGlobalPropertyf("Strato/777/test/fbw_pitch_cmd", 0)
pitch_ovrd = createGlobalPropertyf("Strato/777/test/povrd", 0) --NEVER LEAVE THIS AT 1
dr_errtotal = createGlobalPropertyf("Strato/777/test/etotal", 0)
iasln = createGlobalPropertyf("Strato/777/test/iasln", 0)
yaw_resp = createGlobalPropertyf("Strato/777/test/ky", 2)
thrust_c = createGlobalPropertyf("Strato/777/test/thrust_c", 17)
pitch_delta = createGlobalPropertyf("Strato/777/test/p_delta", 0)
yaw_delta = createGlobalPropertyf("Strato/777/test/y_delta", 0)
pitch_delta_maintain = createGlobalPropertyf("Strato/777/test/p_deltam", 0)
yaw_delta_maintain = createGlobalPropertyf("Strato/777/test/y_deltam", 0)
correction = createGlobalPropertyf("Strato/777/test/correction", 0)
flap_c = createGlobalPropertyf("Strato/777/test/flap_correction", 0)
err_reset = createGlobalPropertyi("Strato/777/test/err_reset", 0)
calc_sp = createGlobalPropertyf("Strato/777/test/calc_sp", 0)
t_fac = createGlobalPropertyf("Strato/777/test/t_factor", 0)
k1 = createGlobalPropertyf("Strato/777/test/k1", 0.004)
k2 = createGlobalPropertyf("Strato/777/test/k2", 0.47)