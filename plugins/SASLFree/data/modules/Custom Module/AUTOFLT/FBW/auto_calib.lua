--[[
*****************************************************************************************
* Script Name: fbw_main
* Author Name: discord/bruh4096#4512(Tim G.)
* Script Description: Code for auto calibration of the fly by wire C*U control law.
*****************************************************************************************
--]]

include("misc_tools.lua")

pfc_cas = globalPropertyf("Strato/777/fctl/databus/cas")
flaps = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 1)
fbw_trim_speed = globalPropertyf("Strato/777/fctl/trs")
pfc_maneuver_speeds = globalProperty("Strato/777/fctl/databus/maneuver_speeds")
errtotal = globalPropertyf("Strato/777/test/etotal", 0)
fbw_iasln = globalProperty("Strato/777/fctl/iasln_table")

f_time = globalPropertyf("sim/operation/misc/frame_rate_period")
c_time = globalPropertyf("Strato/777/time/current")
calib_init = createGlobalPropertyi("Strato/777/test/calib_init", 0)
err_delta = createGlobalPropertyf("Strato/777/test/err_delta", 0)

flap_settings = {0, 1, 5, 15, 20, 25, 30}
base_coefficients = {0.084, 0.093, 0.169, 0.3, 0.21, 0.225, 0.225}

left = 0
right = 120

curr_coeff = 0
err_last = 0
tmp_time = 0
time_threshold = 3
err_threshold = 270
delta_threshold = 0.0005
correction_dir = 1
flap_idx_init = 1
dir_undefined = true
c_set = false

function SetCorrection(left, right, dir, idx)
    local correction = ((right + left) / 2) * 0.001
    set(fbw_iasln, base_coefficients[idx] + dir * correction, idx)
    c_set = true
end

function StopCalib()
    set(calib_init, 0)
    dir_undefined = true
    c_set = false
    curr_coeff = 0
    err_last = 0
    tmp_time = 0
    print("Calibration done")
end

function update()
    local c_err = get(fbw_trim_speed) - get(pfc_cas)
    local curr_delta = math.abs(c_err - err_last)
    local flap_idx = lim(getGreaterThan(flap_settings, get(flaps)), 8, 1)
    set(err_delta, curr_delta)
    if get(calib_init) == 1 then
        if curr_delta > delta_threshold then
            tmp_time = get(c_time)
            c_set = false
        else
            if get(c_time) > tmp_time + time_threshold and not c_set and math.abs(get(errtotal)) >= err_threshold and math.abs(c_err) >= 0.1 then
                if dir_undefined then
                    if get(errtotal) > 0 then
                        correction_dir = -1
                    end
                    flap_idx_init = flap_idx
                    dir_undefined = false
                    SetCorrection(left, right, correction_dir, flap_idx_init)
                else
                    if right - left > 1 and flap_idx_init == flap_idx then
                        local tmp = (right + left) / 2
                        if get(errtotal) > 0 then
                            right = tmp
                        else
                            left = tmp
                        end
                        SetCorrection(left, right, correction_dir, flap_idx_init)
                    else
                        StopCalib()
                    end
                end
            elseif (get(c_time) > tmp_time + time_threshold and math.abs(get(errtotal)) < err_threshold and math.abs(c_err) < 0.1) then
                StopCalib()
            end
        end
    end
    err_last = get(fbw_trim_speed) - get(pfc_cas)
end