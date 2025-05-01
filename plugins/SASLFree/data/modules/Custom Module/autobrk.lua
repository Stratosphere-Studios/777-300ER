--[[
*****************************************************************************************
* Script Name: auto_thr
* Author Name: discord/bruh4096#4512(Tim G.)
* Script Description: Code for autobrake
*****************************************************************************************
--]]

include("misc_tools.lua")
include("constants.lua")

brk_kp = createGlobalPropertyf("Strato/777/autobrk_dbg/kp", -0.0012)
brk_ki = createGlobalPropertyf("Strato/777/autobrk_dbg/ki", 0.000)
brk_kd = createGlobalPropertyf("Strato/777/autobrk_dbg/kd", 0.0002)
brk_act = createGlobalPropertyf("Strato/777/autobrk_dbg/out", 0)
brk_err = createGlobalPropertyf("Strato/777/autobrk_dbg/err", 0)
brk_wt = createGlobalPropertyf("Strato/777/autobrk_dbg/brk_wt", 0)
abrk_tgt_decel = createGlobalPropertyf("Strato/777/autobrk_dbg/tgt", 0)
autobrk_mode = globalPropertyi("Strato/777/gear/autobrake_mode")
autobrk_act = globalPropertyf("Strato/777/gear/autobrk_cmd")
autobrk_apply = globalPropertyi("Strato/777/gear/autobrk_apply")
autobrk_inop = globalPropertyi("Strato/777/gear/autobrk_inop")
autobrk_fail = globalPropertyi("Strato/777/failures/gear/autobrake")
man_brakes_L = globalPropertyf("Strato/777/gear/manual_braking_L")
man_brakes_R = globalPropertyf("Strato/777/gear/manual_braking_R")
gear_lever = globalPropertyi("Strato/777/cockpit/switches/gear_tgt")
spoiler_handle = globalPropertyf("Strato/777/cockpit/switches/sb_handle")
sys_C_press = globalPropertyfae("Strato/777/hydraulics/press", 2)
c_time = globalPropertyf("Strato/777/time/current")

--Sim datarefs
throttle_pos = globalPropertyf("sim/cockpit2/engine/actuators/throttle_jet_rev_ratio_all")
rmw_onground = globalPropertyiae("sim/flightmodel2/gear/on_ground", 2)
lmw_onground = globalPropertyiae("sim/flightmodel2/gear/on_ground", 3)
t_theta = globalPropertyf("sim/flightmodel/position/true_theta") --pitch
ground_speed_mps = globalPropertyf("sim/flightmodel/position/groundspeed")
f_time = globalPropertyf("sim/operation/misc/frame_rate_period")

abrk_err_last = 0
abrk_tgt_cr = 0
abrk_decel_kt_sec = {-2, -2.9, -3.6, -4.4, -5, -6}

abrk_mode_cr = ABRK_MD_DISARM
abrk_mode_pr = ABRK_MD_DISARM

abrk_sw_pos_last = ABRK_MD_OFF
abrk_time = ABRK_MD_OFF
abrk_sw_pos_cr = ABRK_MD_OFF

gs_last_kts = 0
brk_apply = 0
brk_wait = 0
abrk_fail = 0
sp_last = 0

function resetAutoBrk()
    abrk_err_last = 0
    abrk_tgt_cr = 0
    brk_apply = 0
end

function updateAutoBrkTgt(gs_decel_kts, tgt_decel_kts, f_time)
    if f_time == 0 then
        return 0
    end
    local err_kt = tgt_decel_kts-gs_decel_kts
    local delta = err_kt * get(brk_kp) + (err_kt-abrk_err_last) * get(brk_kd) / f_time
    abrk_tgt_cr = abrk_tgt_cr + delta
    abrk_err_last = err_kt
    abrk_tgt_cr = math.max(0, abrk_tgt_cr)
    abrk_tgt_cr = math.min(1, abrk_tgt_cr)
    set(brk_err, err_kt)
    set(abrk_tgt_decel, tgt_decel_kts)
end

function getDecelCmd(pitch_deg)
    if brk_apply == 0 or brk_wait == 1 then
        return 0
    end
    if abrk_mode_cr <= ABRK_MD_DISARM and abrk_mode_cr ~= ABRK_MD_RTO then
        return 0
    end
    if pitch_deg > 1 and abrk_mode_cr == ABRK_MD_MAX then
        return abrk_decel_kt_sec[ABRK_MD_4]
    end
    if abrk_mode_cr == ABRK_MD_RTO then
        return abrk_decel_kt_sec[6]
    end
    return abrk_decel_kt_sec[abrk_mode_cr]
end

function updateWait(gnd_l, gnd_r, thr_pos)
    if (gnd_l == 1 or gnd_r == 1) and 
    (abrk_mode_pr == ABRK_MD_DISARM or abrk_mode_pr == ABRK_MD_OFF)
    and abrk_mode_cr ~= ABRK_MD_DISARM and abrk_mode_cr ~= ABRK_MD_OFF then
        brk_wait = 1
        return
    end

    if gnd_l == 0 and gnd_r == 0 then
        brk_wait = 0
    elseif thr_pos < ABRK_THR_DISARM_MIN and gs_last_kts > ABRK_RTO_LIM_KTS 
    and abrk_mode_cr == ABRK_MD_RTO then
        brk_wait = 0
    end
end

function updateFail()
    if get(autobrk_fail) == 1 or get(sys_C_press) < ABRK_SYS_C_MIN_PSI then
        abrk_fail = 1
    else
        abrk_fail = 0
    end
end

function updateMode(gnd_l, gnd_r, gear_lvr, abrk_pos, thr_pos)
    updateFail()
    if abrk_mode_cr == ABRK_MD_OFF and abrk_pos == abrk_mode_cr then
        return
    end
    
    if abrk_fail == 1 and abrk_pos ~= ABRK_MD_OFF then
        abrk_mode_cr = ABRK_MD_DISARM
        return
    end
    updateWait(gnd_l, gnd_r, thr_pos)
    abrk_mode_pr = abrk_mode_cr
    if gear_lvr == 0 and (abrk_mode_cr > ABRK_MD_DISARM or abrk_mode_cr == ABRK_MD_RTO) then
        abrk_mode_cr = ABRK_MD_OFF
        return
    end
    if brk_wait == 0 and brk_apply == 1 and 
    ((get(man_brakes_L)+get(man_brakes_R)) / 2 > 0.1 or thr_pos > ABRK_THR_DISARM_MIN
    or get(spoiler_handle) < SB_THRESH and sp_last >= SB_THRESH) then
        abrk_mode_cr = ABRK_MD_DISARM
        return
    end
    abrk_mode_cr = math.min(abrk_pos, ABRK_MD_MAX)
    if abrk_mode_cr ~= ABRK_MD_DISARM and abrk_mode_cr ~= ABRK_MD_OFF 
    and gnd_l == 1 and gnd_r == 1 and brk_wait == 0 then
        brk_apply = 1
    else
        brk_apply = 0
    end
end

function updateAutoBrk(gs_decel_kts, f_time)
    updateMode(get(lmw_onground), get(rmw_onground), get(gear_lever), abrk_sw_pos_cr, get(throttle_pos))
    if abrk_mode_cr > ABRK_MD_DISARM or abrk_mode_cr == ABRK_MD_RTO then
        if brk_apply == 1 then
            local cmd = getDecelCmd(get(t_theta))
            updateAutoBrkTgt(gs_decel_kts, cmd, f_time)
        else
            abrk_tgt_cr = 0
        end
    else
        resetAutoBrk()
    end
end


function update()
    if get(c_time) > abrk_time+ABRK_SW_DELAY_SEC then
        abrk_sw_pos_cr = abrk_sw_pos_last
    end

    if get(autobrk_mode) ~= abrk_sw_pos_last then
        abrk_time = get(c_time)
        abrk_sw_pos_last = get(autobrk_mode)
    end

    local gs_kts = get(ground_speed_mps) * MPS_TO_KTS
    local f_t_sec = get(f_time)
    if f_t_sec ~= 0 then
        local gs_acc = (gs_kts-gs_last_kts)/f_t_sec
        updateAutoBrk(gs_acc, f_t_sec)
    end
    set(autobrk_apply, brk_apply)
    set(autobrk_act, abrk_tgt_cr)
    set(brk_act, abrk_tgt_cr)
    set(brk_wt, brk_wait)
    if abrk_sw_pos_cr ~= abrk_mode_cr then
        set(autobrk_mode, abrk_mode_cr)
        abrk_sw_pos_last = abrk_mode_cr
    end
    gs_last_kts = gs_kts
    sp_last = get(spoiler_handle)
end
