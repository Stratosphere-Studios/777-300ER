--[[
*****************************************************************************************
* Script Name: auto_thr
* Author Name: discord/bruh4096#4512(Tim G.)
* Script Description: Code for autothrottle
*****************************************************************************************
--]]

addSearchPath(moduleDirectory .. "/Custom Module/AUTOFLT/FBW")

include("fbw_controllers.lua")
include("misc_tools.lua")
include("constants.lua")


tgt_ias = globalPropertyf("sim/cockpit2/autopilot/airspeed_dial_kts")
--autothr_arm = globalPropertyi("Strato/777/mcp/at_arm")
autothr_arm_l = globalPropertyi("Strato/777/mcp/autothr_arm_l")
autothr_arm_r = globalPropertyi("Strato/777/mcp/autothr_arm_r")
spd_hold = globalPropertyi("Strato/777/mcp/spd_hold")
toga = globalPropertyi("Strato/777/mcp/toga")
at_disc = globalPropertyi("Strato/777/mcp/at_disc")
n1_lim = createGlobalPropertyf("Strato/777/autothr/n1_lim", 95)
throt_res_rt = createGlobalPropertyf("Strato/777/autothr/throt_res_rt", 0.95)
ap_engaged = globalPropertyi("Strato/777/mcp/ap_on")

--Flight directors:
flt_dir_pilot = globalPropertyi("Strato/777/mcp/flt_dir_pilot")
flt_dir_copilot = globalPropertyi("Strato/777/mcp/flt_dir_copilot")

mcp_alt_val = globalPropertyf("sim/cockpit/autopilot/altitude")

thr_kp = createGlobalPropertyf("Strato/777/autothr_dbg/kp", 0.000045)
thr_ki = createGlobalPropertyf("Strato/777/autothr_dbg/ki", 0.000)
thr_kd = createGlobalPropertyf("Strato/777/autothr_dbg/kd", 0.00058)
thr_et = createGlobalPropertyf("Strato/777/autothr_dbg/et", 0)
thr_cmd = createGlobalPropertyf("Strato/777/autothr_dbg/cmd", 0)
thr_resp = createGlobalPropertyf("Strato/777/autothr_dbg/resp", 0.04)
pred_ias_kt = createGlobalPropertyf("Strato/777/autothr_dbg/pred_ias_kt", 0)
pred_ias_sec = createGlobalPropertyf("Strato/777/autothr_dbg/pred_ias_sec", 10)

autothr_mode_dr = globalPropertyi("Strato/777/fma/at_mode")
curr_vert_mode = globalPropertyi("Strato/777/fma/active_vert_mode")
alt_acq = globalPropertyi("Strato/777/fma/alt_acq")

throttle_cmd = globalPropertyf("sim/cockpit2/engine/actuators/throttle_ratio_all")
throttle_cmd_l = globalPropertyfae("sim/cockpit2/engine/actuators/throttle_jet_rev_ratio", 1)
throttle_cmd_r = globalPropertyfae("sim/cockpit2/engine/actuators/throttle_jet_rev_ratio", 2)
L_reverser_deployed = globalPropertyiae("sim/cockpit2/annunciators/reverser_on", 1)
R_reverser_deployed = globalPropertyiae("sim/cockpit2/annunciators/reverser_on", 2)

ra_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")
ra_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_copilot")
cas_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
cas_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_copilot")
gs_dref = globalPropertyf("sim/cockpit2/gauges/indicators/ground_speed_kt")

--Critical speeds:
max_allowable = globalPropertyi("Strato/777/fctl/vmax")
stall_speed = globalPropertyi("Strato/777/fctl/vstall")

-- We use pitch here to limit idle thrust
pitch_pilot = globalPropertyf("sim/cockpit/gyros/the_ind_ahars_pilot_deg")
pitch_copilot = globalPropertyf("sim/cockpit/gyros/the_ind_ahars_copilot_deg")
alt_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/altitude_ft_pilot")
alt_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/altitude_ft_copilot")
ra_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")
ra_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_copilot")

vs_pilot_fpm = globalPropertyf("sim/cockpit2/gauges/indicators/vvi_fpm_pilot")
vs_copilot_fpm = globalPropertyf("sim/cockpit2/gauges/indicators/vvi_fpm_copilot")

engn_L_n1 = globalPropertyfae("sim/flightmodel/engine/ENGN_N1_", 1)
engn_R_n1 = globalPropertyfae("sim/flightmodel/engine/ENGN_N1_", 2)

f_time = globalPropertyf("sim/operation/misc/frame_rate_period")

AT_KP = 0.000045
AT_KD = 0.00058

ias_last = {0, 0}
gs_last = {0, 0}
ra_last = 0
PITCH_MAX = 15
PITCH_MIN = 0
THR_SERVO_RESPONSE = 0.002
AT_FLARE_ENTRY_FT = 100
THR_MAX_N1_DEV = 4

at_flare_begin_ft = 0
spd_flc_start_kts = 0


curr_at_mode = AT_MODE_OFF
at_engaged = false
flc_thr_ratio = 1
mcp_alt_last = 0
thr_joy_last = 0

function getThrottleIdleAltitudeFt(vs_entry)
    local curr_vs = lim(vs_entry, 0, -1500)
    local vs_calc = -1500 - curr_vs
    return 50 + (vs_calc / 1500) * 30
end

function getThrottleN1HoldCmd(rt_sd)  -- Just holds the n1 at n1_lim
    local avg_n1 = get(engn_L_n1)
    if rt_sd == 1 then
        avg_n1 = get(engn_R_n1)
    end
    local n1_err = get(n1_lim) - avg_n1
    return AT_KP * n1_err
end

function setThrottleCmd(cmd, rt_sd)
    if get(autothr_arm_l) == 1 and rt_sd == 0 then
        set(throttle_cmd_l, cmd)
    elseif get(autothr_arm_r) == 1 and rt_sd == 1 then
        set(throttle_cmd_r, cmd)
    end
end

function getThrottleCmd(rt_sd)
    local cr_throt_cmd = get(throttle_cmd_l)
    if rt_sd == 1 then
        cr_throt_cmd = get(throttle_cmd_r)
    end
    return cr_throt_cmd
end

function setThrottleIASHoldCmd(ias_tgt_kts, thr_ratio, rt_sd)
    at_engaged = true
    if get(f_time) ~= 0 then
        local avg_ias = (get(cas_pilot) + get(cas_copilot)) / 2
        local avg_pitch = (get(pitch_pilot) + get(pitch_copilot)) / 2
        local avg_vs = (get(vs_pilot_fpm) + get(vs_copilot_fpm)) / 2
        local avg_n1 = get(engn_L_n1)
        if rt_sd == 1 then
            avg_n1 = get(engn_R_n1)
        end
        local cr_throt_cmd = getThrottleCmd(rt_sd)

        local curr_gs = get(gs_dref)

        avg_pitch = lim(avg_pitch, PITCH_MAX, PITCH_MIN)
        local min_idle = 0.04 * avg_pitch

        local ias_accel = (avg_ias - ias_last[rt_sd+1]) / get(f_time)
        local gs_accel = (curr_gs - gs_last[rt_sd+1]) / get(f_time)

        local ias_err = ias_tgt_kts - avg_ias
        local at_out = AT_KP * ias_err - AT_KD * (gs_accel - (avg_vs / 16000))
        set(thr_cmd, at_out)
        local autothr_cmd = lim(cr_throt_cmd+at_out, thr_ratio, min_idle)
        if autothr_cmd > cr_throt_cmd and 
            (math.abs(avg_n1 - get(n1_lim)) <= THR_MAX_N1_DEV or avg_n1 > get(n1_lim)) then
            local n1_hold_cmd = getThrottleN1HoldCmd(rt_sd)
            autothr_cmd = lim(cr_throt_cmd+n1_hold_cmd, thr_ratio, min_idle)
        end
        local thr_lvr_cmd = EvenChange(cr_throt_cmd, autothr_cmd, THR_SERVO_RESPONSE)
        if math.abs(cr_throt_cmd-min_idle) < 0.001 and curr_at_mode == AT_MODE_FLC_RETARD then
            curr_at_mode = AT_MODE_HOLD
        end
        setThrottleCmd(thr_lvr_cmd, rt_sd)
        ias_last[rt_sd+1] = avg_ias
        gs_last[rt_sd+1] = curr_gs
    end
end

function setThrottleRetardCmd(rt_sd)
    local cr_throt_cmd = getThrottleCmd(rt_sd)
    local thr_lvr_cmd = EvenChange(cr_throt_cmd, 0, THR_SERVO_RESPONSE)
    setThrottleCmd(thr_lvr_cmd, rt_sd)
end

function setThrottleRefCmd(rt_sd)
    local cr_throt_cmd = getThrottleCmd(rt_sd)
    local n1_hold_cmd = getThrottleN1HoldCmd(rt_sd)
    local autothr_cmd = lim(cr_throt_cmd+n1_hold_cmd, 1, 0)
    local thr_lvr_cmd = EvenChange(cr_throt_cmd, autothr_cmd, THR_SERVO_RESPONSE)
    setThrottleCmd(thr_lvr_cmd, rt_sd)
end

function setThrottleFlcRatio()
    local avg_alt = (get(alt_pilot) + get(alt_copilot)) / 2
    local alt_err = mcp_alt_last - avg_alt
    flc_thr_ratio = lim(alt_err/4000, 1, 0.85)
end

function setThrottleFlcCmd(v_mode, rt_sd)
    if v_mode == VERT_MODE_FLC_CLB then
        local tgt_spd_kts = math.max(get(tgt_ias)+35, spd_flc_start_kts+35)
        setThrottleIASHoldCmd(tgt_spd_kts, flc_thr_ratio, rt_sd)
    else
        local tgt_spd_kts = math.min(get(tgt_ias)-12, spd_flc_start_kts-12)
        --local throt_prev = get(throttle_cmd)
        setThrottleIASHoldCmd(tgt_spd_kts, 1, rt_sd)
    end
end

function updateMode(v_mode)
    local avg_ra = (get(ra_pilot) + get(ra_copilot)) / 2
    local avg_ias = (get(cas_pilot) + get(cas_copilot)) / 2
    local arm_sts = get(autothr_arm_l)+get(autothr_arm_r)

    if get(L_reverser_deployed) == 1 or get(R_reverser_deployed) == 1 or 
        get(at_disc) == 1 or arm_sts == 0 then
        curr_at_mode = AT_MODE_OFF
        set(spd_hold, 0)
        set(toga, 0)
        ra_last = avg_ra
        return
    end

    if arm_sts ~= 0 and (avg_ias < get(stall_speed) or avg_ias > get(max_allowable)) then
        if curr_at_mode == AT_MODE_OFF and avg_ra > 200 then
            set(spd_hold, 1)
            return
        end
    end

    local flt_dir_off = get(flt_dir_pilot) == 1 and get(flt_dir_copilot) == 1

    if (v_mode < VERT_MODE_FLC_CLB or get(alt_acq) == 1 or 
        (get(ap_engaged) == 0 and flt_dir_off)) and 
        (curr_at_mode >= AT_MODE_FLC_RETARD or (curr_at_mode == AT_MODE_HOLD 
        and get(ap_engaged) == 1)) then
        set(spd_hold, 1)
    end
    if avg_ias <= 50 and arm_sts ~= 0 and get(toga) == 1 and 
        curr_at_mode ~= AT_MODE_HOLD then
        curr_at_mode = AT_MODE_THR_REF
        at_engaged = false
    elseif avg_ias > 80 and curr_at_mode == AT_MODE_THR_REF then
        curr_at_mode = AT_MODE_HOLD
        at_engaged = false
    elseif (avg_ra > 400 or at_engaged) and v_mode >= VERT_MODE_FLC_CLB and 
        get(alt_acq) == 0 then
        if v_mode == VERT_MODE_FLC_CLB then
            if curr_at_mode ~= AT_MODE_FLC_REF then
                spd_flc_start_kts = ias_last[1]
            end
            curr_at_mode = AT_MODE_FLC_REF
        else
            if curr_at_mode ~= AT_MODE_FLC_RETARD and curr_at_mode ~= AT_MODE_HOLD then
                spd_flc_start_kts = ias_last[1]
            end
            if curr_at_mode ~= AT_MODE_HOLD then
                curr_at_mode = AT_MODE_FLC_RETARD
            end
        end
        set(spd_hold, 0)
    elseif arm_sts ~= 0 and get(spd_hold) == 1 then
        if (avg_ra > 400 and (curr_at_mode == AT_MODE_HOLD or 
            curr_at_mode == AT_MODE_OFF)) or at_engaged then 
            local vs_avg_fpm = (get(vs_pilot_fpm) + get(vs_copilot_fpm)) / 2
            if avg_ra < AT_FLARE_ENTRY_FT and ra_last > AT_FLARE_ENTRY_FT 
                and vs_avg_fpm < 0 then
                at_flare_begin_ft = getThrottleIdleAltitudeFt(vs_avg_fpm)
                curr_at_mode = AT_MODE_IAS_HOLD
            elseif avg_ra < at_flare_begin_ft and ra_last > at_flare_begin_ft then
                curr_at_mode = AT_MODE_RETARD
            elseif curr_at_mode ~= AT_MODE_RETARD then
                curr_at_mode = AT_MODE_IAS_HOLD
            end
        end
    elseif get(spd_hold) == 0 and curr_at_mode == AT_MODE_IAS_HOLD then
        curr_at_mode = AT_MODE_OFF
        at_engaged = false
    elseif arm_sts == 0 then
        curr_at_mode = AT_MODE_OFF
        at_engaged = false
    end
    ra_last = avg_ra
end


function update()
    local v_mode = get(curr_vert_mode)
    local mcp_alt = get(mcp_alt_val)
    if mcp_alt ~= mcp_alt_last then
        mcp_alt_last = mcp_alt
        setThrottleFlcRatio()
    end
    updateMode(v_mode)
    if curr_at_mode ~= AT_MODE_IAS_HOLD then
        ias_last[1] = (get(cas_pilot) + get(cas_copilot)) / 2
        ias_last[2] = (get(cas_pilot) + get(cas_copilot)) / 2
        gs_last[1] = get(gs_dref)
        gs_last[2] = get(gs_dref)
    end
    if curr_at_mode == AT_MODE_IAS_HOLD then
        setThrottleIASHoldCmd(get(tgt_ias), 1, 0)
        setThrottleIASHoldCmd(get(tgt_ias), 1, 1)
    elseif curr_at_mode == AT_MODE_RETARD then
        setThrottleRetardCmd(0)
        setThrottleRetardCmd(1)
    elseif curr_at_mode == AT_MODE_THR_REF then
        setThrottleRefCmd(0)
        setThrottleRefCmd(1)
    elseif curr_at_mode >= AT_MODE_FLC_RETARD then
        setThrottleFlcCmd(v_mode, 0)
        setThrottleFlcCmd(v_mode, 1)
    end
    set(autothr_mode_dr, curr_at_mode)
end
