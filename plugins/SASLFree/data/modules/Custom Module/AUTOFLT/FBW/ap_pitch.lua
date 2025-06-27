--[[
*****************************************************************************************
* Script Name: ap_pitch
* Author Name: discord/bruh4096#4512(Tim G.)
* Script Description: Code for autopilot pitch modes
*****************************************************************************************
--]]

include("constants.lua")

pitch_kp = createGlobalPropertyf("Strato/777/pitch_dbg/kp", 0.00037)
pitch_ki = createGlobalPropertyf("Strato/777/pitch_dbg/ki", -1)
pitch_kd = createGlobalPropertyf("Strato/777/pitch_dbg/kd", 0.0013)
pitch_et = createGlobalPropertyf("Strato/777/pitch_dbg/et", 0)
pitch_resp = createGlobalPropertyf("Strato/777/pitch_dbg/resp", 1/20)
ias_pred_sec = createGlobalPropertyf("Strato/777/pitch_dbg/ias_pred_sec", 8)
ias_pred_kt = createGlobalPropertyf("Strato/777/pitch_dbg/ias_pred_kt", 0)
vs_cmd = createGlobalPropertyf("Strato/777/pitch_dbg/vscmd", 0)
alt_cmd = createGlobalPropertyf("Strato/777/pitch_dbg/altcmd", 0)
--vs_tgt = createGlobalPropertyf("Strato/777/pitch_dbg/vs_tgt", 0)
tgt_ias = globalPropertyf("sim/cockpit2/autopilot/airspeed_dial_kts")
ap_pitch_eng = createGlobalPropertyi("Strato/777/pitch_dbg/eng", 0)

yoke_pitch = globalPropertyfae("Strato/777/autopilot/yoke_cmd", 2)

tgt_fpa = createGlobalPropertyf("Strato/777/mcp/tgt_fpa", 0)
vs_fpa = createGlobalPropertyi("Strato/777/mcp/vs_fpa", 0)

pitch_fltdir_pilot = createGlobalPropertyi("Strato/777/pfd/pitch_fltdir_pilot", 0)
pitch_fltdir_copilot = createGlobalPropertyi("Strato/777/pfd/pitch_fltdir_copilot", 0)

flt_dir_pilot = globalPropertyi("Strato/777/mcp/flt_dir_pilot")
flt_dir_copilot = globalPropertyi("Strato/777/mcp/flt_dir_copilot")

vshold_eng = createGlobalPropertyi("Strato/777/mcp/vshold", 0)
flch_eng = globalPropertyi("Strato/777/mcp/flch")
alt_hold_eng = createGlobalPropertyi("Strato/777/mcp/althold", 0)
curr_vert_mode = globalPropertyi("Strato/777/fma/active_vert_mode")
alt_acq = globalPropertyi("Strato/777/fma/alt_acq")

mcp_alt_val = globalPropertyf("sim/cockpit/autopilot/altitude")


vs_pred_sec = createGlobalPropertyf("Strato/777/pitch_dbg/vs_pred_sec", 8)
vs_pred_fpm = createGlobalPropertyf("Strato/777/pitch_dbg/vs_pred_fpm", 0)
k_ias = createGlobalPropertyf("Strato/777/pitch_dbg/k_ias", -2)
k_spoil = createGlobalPropertyf("Strato/777/pitch_dbg/k_spoil", 0.06)

pitch_pilot = globalPropertyf("sim/cockpit/gyros/the_ind_ahars_pilot_deg")
pitch_copilot = globalPropertyf("sim/cockpit/gyros/the_ind_ahars_copilot_deg")
-- Here we have a IAS acceleration feedback.
cas_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
cas_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_copilot")

pitch_tgt = createGlobalPropertyf("Strato/777/autopilot/pitch_tgt_deg", 0)
ap_pitch_on = createGlobalPropertyi("Strato/777/autopilot/ap_pitch_on", 0)

vs_tgt = globalPropertyf("sim/cockpit2/autopilot/vvi_dial_fpm")
ap_engaged = globalPropertyi("Strato/777/mcp/ap_on")

-- Sim sensor datarefs
alt_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/altitude_ft_pilot")
alt_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/altitude_ft_copilot")
vs_pilot_fpm = globalPropertyf("sim/cockpit2/gauges/indicators/vvi_fpm_pilot")
vs_copilot_fpm = globalPropertyf("sim/cockpit2/gauges/indicators/vvi_fpm_copilot")
gs_dref = globalPropertyf("sim/cockpit2/gauges/indicators/ground_speed_kt")

--Spoilers:
spoiler_L1_act = globalPropertyfae("sim/flightmodel2/wing/spoiler1_deg", 3) --#4
spoiler_L2_act = globalPropertyfae("sim/flightmodel2/wing/spoiler2_deg", 3)
spoiler_R1_act = globalPropertyfae("sim/flightmodel2/wing/spoiler1_deg", 4) --#11
spoiler_R2_act = globalPropertyfae("sim/flightmodel2/wing/spoiler2_deg", 4)
spoiler_6_act = globalPropertyfae("sim/flightmodel2/wing/speedbrake1_deg", 1)
spoiler_7_act = globalPropertyfae("sim/flightmodel2/wing/speedbrake2_deg", 1)
spoiler_8_act = globalPropertyfae("sim/flightmodel2/wing/speedbrake2_deg", 2)
spoiler_9_act = globalPropertyfae("sim/flightmodel2/wing/speedbrake1_deg", 2)

--Mass
pfc_mass = globalPropertyf("Strato/777/fctl/databus/mass_total")
--Alerts:
alt_alert = globalPropertyi("Strato/777/autopilot/alt_alert")

vshold_pid = PID:new{kp = 0, ki = 0, kd = 0, errtotal = 0, errlast = 0, lim_out = 1,  lim_et = 100}
flch_pid = PID:new{kp = 0, ki = 0, kd = 0, errtotal = 0, errlast = 0, lim_out = 1,  lim_et = 100}

ap_pitch_engaged = false
vshold_pitch_deg = 0

VSHOLD_PITCH_MAX_DEG = 20
VSHOLD_PITCH_MIN_DEG = -10
FLC_CLB_PITCH_MIN_DEG = 5

ALT_HOLD_ALT_REACH_SEC = 10
ALT_HOLD_DECEL = 10
ALT_HOLD_CAPTURE_ALT_FT = 150
ALT_HOLD_VS_CMD_MAX_FPM = 2600
ALT_HOLD_VS_ENTRY_MAX_FPM = 1000
ALT_HOLD_ALT_MRGN_FT = 350
ALT_ACQ_ALT_PENALTY_FT = 250 -- Alt penalty per 1000 fpm

vs_last_ft = 0
ias_last = 0
gs_last = 0

alt_hold_alt_tgt = 0
alt_hold_alt_blacklist = 0  -- This is to prevent re-engagement after forced disengage
vs_hold_vs_tgt = 0
alt_intcpt_margin_ft = 0

alt_hold_alt_acq = false
mcp_alt_acq = false
mcp_alt_tgt_set = false

VS_HOLD_KP = 0.00037
VS_HOLD_KD = 0.0013
FLC_CLB_KP = -0.04
FLC_CLB_KD = -0.74
FLC_DES_KP = -0.02
FLC_DES_KD = -0.37

flap_corr_pitch_deg = {0, -1, -0.5, -0.4, -0.3, -0.3, -0.24}
vert_mode = VERT_MODE_OFF

function getIASCorrection()
    if get(f_time) ~= 0 then
        local ias_avg_kts = (get(cas_pilot) + get(cas_pilot)) / 2
        local ias_accel = (ias_avg_kts - ias_last) / get(f_time)

        ias_last = ias_avg_kts

        return ias_accel * get(k_ias)
    else
        return 0
    end
end

function getSpoilerCorrection()
    local sp_avg = (get(spoiler_L1_act) + get(spoiler_L2_act) + 
        get(spoiler_R1_act) + get(spoiler_R2_act) + get(spoiler_6_act) + 
        get(spoiler_7_act) + get(spoiler_8_act) + get(spoiler_9_act)) / 8
    return sp_avg * get(k_spoil)
end

function getPitchCorrectionAP()
    local flap_idx = lim(getGreaterThan(FLAP_STGS, get(pfc_flaps)), 8, 1)
    return getSpoilerCorrection() + flap_corr_pitch_deg[flap_idx]*get(pfc_flaps)
end

function getAltIntcAlt(vs_avg_fpm)
    local vs_avg = math.abs(vs_avg_fpm)
    local alt_intcpt_mrgn_ft = ALT_HOLD_ALT_MRGN_FT
    local lim_vspeed = ALT_HOLD_VS_ENTRY_MAX_FPM
    if vs_avg > lim_vspeed then
        alt_intcpt_mrgn_ft = alt_intcpt_mrgn_ft + (vs_avg - lim_vspeed) * (ALT_ACQ_ALT_PENALTY_FT/lim_vspeed)
    end

    return alt_intcpt_mrgn_ft
end

function getAutopilotVSHoldCmd(pitch_cmd_prev, vs_cmd_fpm)
    if get(f_time) ~= 0 then
        local vs_avg_fpm = (get(vs_pilot_fpm) + get(vs_copilot_fpm)) / 2
        local ias_avg_kts = (get(cas_pilot) + get(cas_pilot)) / 2
        local avg_pitch_deg = (get(pitch_pilot) + get(pitch_copilot)) / 2


        local vs_accel = (vs_avg_fpm - vs_last_ft) / get(f_time)
        local ias_accel = (ias_avg_kts - ias_last) / get(f_time)

        local vs_pred = vs_avg_fpm + vs_accel * get(vs_pred_sec)
        set(vs_pred_fpm, vs_pred)

        local tgt_kp = 0.0005
        if round(get(pfc_flaps)) >= 5 and round(get(pfc_flaps)) <= 20 then
            tgt_kp = 0.001
        elseif round(get(pfc_flaps)) > 20 then
            tgt_kp = 0.002
        end

        --vshold_pid:update{kp=tgt_kp, tgt=vs_cmd_fpm, curr=vs_pred}
        --set(pitch_et, vshold_pid.errtotal)
        local vs_err = vs_cmd_fpm - vs_pred
        local vshold_out = lim(vs_err * VS_HOLD_KP - vs_accel * VS_HOLD_KD, 6, -6)

        local tgt_cmd = pitch_cmd_prev+ (vshold_out * get(f_time))

        local vshold_cmd = lim(tgt_cmd, VSHOLD_PITCH_MAX_DEG, VSHOLD_PITCH_MIN_DEG)
        set(pitch_et, vshold_cmd)
        vs_last_ft = vs_avg_fpm
        ias_last = ias_avg_kts
        return vshold_cmd 
    end

    return pitch_cmd_prev
end

function getAutopilotFlcCmd(pitch_cmd_prev)
    if get(f_time) ~= 0 then
        local ias_avg_kts = (get(cas_pilot) + get(cas_pilot)) / 2
        local vs_avg_fpm = (get(vs_pilot_fpm) + get(vs_copilot_fpm)) / 2
        local avg_pitch_deg = (get(pitch_pilot) + get(pitch_copilot)) / 2
        local curr_gs = get(gs_dref)

        local gs_accel = (curr_gs - gs_last) / get(f_time)

        local ias_err = get(tgt_ias) - ias_avg_kts
        
        local tgt_kp = FLC_CLB_KP
        local tgt_kd = FLC_CLB_KD
        local pitch_max = VSHOLD_PITCH_MAX_DEG
        local pitch_min = FLC_CLB_PITCH_MIN_DEG
        if vert_mode == VERT_MODE_FLC_DES then
            tgt_kp = FLC_DES_KP
            tgt_kd = FLC_DES_KD
            pitch_max = FLC_CLB_PITCH_MIN_DEG
            pitch_min = VSHOLD_PITCH_MIN_DEG
        end
        local flc_out = tgt_kp * ias_err - tgt_kd * (gs_accel - (vs_avg_fpm / 16000))
        local tgt_cmd = pitch_cmd_prev+flc_out * get(f_time)

        local flch_cmd = lim(tgt_cmd, pitch_max, pitch_min)
        ias_last = ias_avg_kts
        return flch_cmd 
    end
    return pitch_cmd_prev
end

function getAutopilotVSHoldCmdFull()
    vshold_pitch_deg = getAutopilotVSHoldCmd(vshold_pitch_deg, vs_hold_vs_tgt) 
    return vshold_pitch_deg
end

function getAutopilotFlcCmdFull()
    vshold_pitch_deg = getAutopilotFlcCmd(vshold_pitch_deg)
    return vshold_pitch_deg + getIASCorrection()
end

function getAutopilotAltHoldCmd()
    local alt_avg_ft = (get(alt_pilot) + get(alt_copilot)) / 2
    local vs_avg_fpm = (get(vs_pilot_fpm) + get(vs_copilot_fpm)) / 2
    local alt_err = alt_hold_alt_tgt - alt_avg_ft
    vs_hold_vs_tgt = (alt_err - vs_avg_fpm / 4) * 2.6
    if math.abs(alt_err) > 200 then
        set(alt_alert, 1)  --EICAS ALTITUDE ALERT
    else
        set(alt_alert, 0)
    end
    if math.abs(vs_hold_vs_tgt) > ALT_HOLD_VS_CMD_MAX_FPM then
        set(alt_hold_eng, 0)
        alt_hold_alt_blacklist = alt_hold_alt_tgt
        vert_mode = VERT_MODE_VSHOLD
        vs_hold_vs_tgt = get(vs_tgt)
    else
        alt_hold_alt_blacklist = 0
    end
    return getAutopilotVSHoldCmdFull()
end

function updateMode()
    local alt_avg_ft = (get(alt_pilot) + get(alt_copilot)) / 2
    local vs_avg_fpm = (get(vs_pilot_fpm) + get(vs_copilot_fpm)) / 2
    
    if math.abs(get(mcp_alt_val) - alt_avg_ft) > ALT_HOLD_CAPTURE_ALT_FT and
        get(alt_hold_eng) == 1 and (get(vshold_eng) == 1 or get(flch_eng) == 1) 
        and vert_mode == VERT_MODE_ALTHOLD then
        set(alt_hold_eng, 0)
        alt_hold_alt_acq = false
        mcp_alt_acq = false
    end
    
    local alt_err = get(mcp_alt_val) - alt_avg_ft
    local alt_tgt_err = alt_hold_alt_tgt - alt_avg_ft

    if not mcp_alt_acq then
        local tmp_margin = getAltIntcAlt(vs_avg_fpm)

        if not alt_hold_alt_acq and (vert_mode == VERT_MODE_VSHOLD or 
            vert_mode >= VERT_MODE_FLC_CLB) and math.abs(alt_err) <= tmp_margin then
            mcp_alt_acq = true
            alt_intcpt_margin_ft = tmp_margin
        end
    else
        if ((get(flch_eng) == 1 and vert_mode == VERT_MODE_VSHOLD) or 
            (get(vshold_eng) == 1 and vert_mode >= VERT_MODE_FLC_CLB)) and 
            math.abs(alt_err) <= alt_intcpt_margin_ft then
            mcp_alt_acq = false
        end
    end

    if mcp_alt_acq then
        if not mcp_alt_tgt_set then
            alt_hold_alt_tgt = get(mcp_alt_val)
            mcp_alt_tgt_set = true
        end
        alt_tgt_err = alt_hold_alt_tgt - alt_avg_ft
        if alt_tgt_err > 0 and alt_tgt_err <= alt_intcpt_margin_ft and 
            vs_hold_vs_tgt >= 0 and vert_mode < VERT_MODE_FLC_CLB then
            vs_hold_vs_tgt = lim(vs_hold_vs_tgt, 300, 100)
        elseif alt_tgt_err < 0 and alt_tgt_err >= -alt_intcpt_margin_ft and 
            vs_hold_vs_tgt <= 0 and vert_mode < VERT_MODE_FLC_CLB then
            vs_hold_vs_tgt = lim(vs_hold_vs_tgt, -100, -300)
        elseif vert_mode == VERT_MODE_FLC_CLB then
            vs_hold_vs_tgt = 300
        elseif vert_mode == VERT_MODE_FLC_DES then
            vs_hold_vs_tgt = -300
        else
            mcp_alt_acq = false
            mcp_alt_tgt_set = false
        end
    elseif vert_mode ~= VERT_MODE_ALTHOLD then
        alt_hold_alt_tgt = 0
    end
    if get(alt_hold_eng) == 1 and get(mcp_alt_val) ~= alt_hold_alt_blacklist then
        if mcp_alt_acq then
            mcp_alt_acq = false
            mcp_alt_tgt_set = false
            alt_hold_alt_acq = false
            vert_mode = VERT_MODE_ALTHOLD
            set(vs_tgt, 0)
        else
            if math.abs(get(mcp_alt_val) - alt_avg_ft) > ALT_HOLD_CAPTURE_ALT_FT and 
                vert_mode ~= VERT_MODE_ALTHOLD then
                vs_hold_vs_tgt = 0
                vert_mode = VERT_MODE_VSHOLD
                alt_hold_alt_acq = true
                mcp_alt_acq = false
                mcp_alt_tgt_set = false
                set(flch_eng, 0)
            elseif math.abs(get(mcp_alt_val) - alt_avg_ft) <= ALT_HOLD_CAPTURE_ALT_FT and 
                vert_mode ~= VERT_MODE_ALTHOLD then
                vert_mode = VERT_MODE_ALTHOLD
                mcp_alt_acq = false
                mcp_alt_tgt_set = false
                set(vs_tgt, 0)
                set(vshold_eng, 0)
                set(flch_eng, 0)
                alt_hold_alt_tgt = get(mcp_alt_val)
            end
            if alt_hold_alt_acq and vs_avg_fpm < 200 then
                alt_hold_alt_acq = false
                mcp_alt_acq = false
                mcp_alt_tgt_set = false
                vert_mode = VERT_MODE_ALTHOLD
                alt_hold_alt_tgt = alt_avg_ft
                set(vs_tgt, 0)
                set(vshold_eng, 0)
                set(flch_eng, 0)
            end
        end
    elseif get(vshold_eng) == 1 then
        if get(flch_eng) == 1 and vert_mode == VERT_MODE_VSHOLD then
            set(vshold_eng, 0)
        else
            if get(flch_eng) == 1 then
                set(flch_eng, 0)
                set(vs_tgt, vs_avg_fpm)
            end
            if math.abs(alt_tgt_err) <= ALT_HOLD_CAPTURE_ALT_FT and mcp_alt_acq
                and get(mcp_alt_val) ~= alt_hold_alt_blacklist then
                set(alt_hold_eng, 1)
                set(vshold_eng, 0)
            elseif (not mcp_alt_acq) or get(mcp_alt_val) == alt_hold_alt_blacklist then
                vs_hold_vs_tgt = get(vs_tgt)
            end
        end
        vert_mode = VERT_MODE_VSHOLD
    elseif get(flch_eng) == 1 then
        if alt_err > 0 then
            vert_mode = VERT_MODE_FLC_CLB
        else
            vert_mode = VERT_MODE_FLC_DES
        end
        if math.abs(alt_tgt_err) <= ALT_HOLD_CAPTURE_ALT_FT and mcp_alt_acq then
            set(alt_hold_eng, 1)
            set(flch_eng, 0)
        end
    else
        vert_mode = VERT_MODE_OFF
    end
    if vert_mode ~= VERT_MODE_OFF then
        set(ap_pitch_on, 1)
    else
        set(ap_pitch_on, 0)
    end
    set(alt_cmd, alt_hold_alt_tgt)
    set(vs_cmd, vs_hold_vs_tgt)
end

function updateVsFpa()
    local curr_gs = get(gs_dref)
    local gs_fpm = (curr_gs * 6076.12) / 60
    local vs_avg_fpm = (get(vs_pilot_fpm) + get(vs_copilot_fpm)) / 2

    if get(vs_fpa) == 1 then
        local fpa_rad = math.rad(get(tgt_fpa))
        set(vs_tgt, math.tan(fpa_rad) * gs_fpm)
    else
        if gs_fpm == 0 then
            set(tgt_fpa, 0)
        else
            local fpa_rad = math.atan(get(vs_tgt)/gs_fpm)
            set(tgt_fpa, math.deg(fpa_rad))
        end
    end
end

function updatePitchFltDirCmd(pitch_cmd_deg)
    if vert_mode ~= VERT_MODE_OFF then
        local avg_pitch_deg = (get(pitch_pilot) + get(pitch_copilot)) / 2
        local flt_dir_cmd = lim(pitch_cmd_deg - avg_pitch_deg, 20, -20)
        set(yoke_pitch, flt_dir_cmd/20)
        set(pitch_tgt, flt_dir_cmd)
    else
        set(yoke_pitch, 0)
        set(pitch_tgt, 0)
    end
end

function updatePitchFltDir() -- Updates pitch flight directors
    if ap_pitch_engaged and get(flt_dir_pilot) == 1 then
        set(pitch_fltdir_pilot, 1)
    else
        set(pitch_fltdir_pilot, 0)
    end

    if ap_pitch_engaged and get(flt_dir_copilot) == 1 then
        set(pitch_fltdir_copilot, 1)
    else
        set(pitch_fltdir_copilot, 0)
    end
end

function clearPitchMode()
    vert_mode = VERT_MODE_OFF
    mcp_alt_acq = false
    alt_hold_alt_acq = false
    set(ap_pitch_on, 0)
    set(vshold_eng, 0)
    set(flch_eng, 0)
    set(alt_hold_eng, 0)
end

function getAutopilotPitchCmd()
    updateVsFpa()
    local auto_level = get(ap_engaged) + get(flt_dir_pilot) + get(flt_dir_copilot)
    if auto_level == 0 then
        clearPitchMode()
    else
        updateMode()
    end
    
    local pitch_cmd_deg = 0
    if vert_mode ~= VERT_MODE_ALTHOLD then
        set(alt_alert, 0)
    end
    if vert_mode ~= VERT_MODE_OFF then
        set(ap_pitch_on, 1)
        ap_pitch_engaged = true
        if vert_mode == VERT_MODE_VSHOLD or mcp_alt_acq then
            pitch_cmd_deg = getAutopilotVSHoldCmdFull()
        elseif vert_mode == VERT_MODE_ALTHOLD then
            pitch_cmd_deg = getAutopilotAltHoldCmd()
        else
            pitch_cmd_deg = getAutopilotFlcCmdFull()
        end
    else
        set(ap_pitch_on, 0)
        vshold_pitch_deg = (get(pitch_pilot) + get(pitch_copilot)) / 2
        pitch_cmd_deg = vshold_pitch_deg
        ap_pitch_engaged = false
        vs_last_ft = (get(vs_pilot_fpm) + get(vs_copilot_fpm)) / 2
        ias_last = (get(cas_pilot) + get(cas_pilot)) / 2
    end
    pitch_cmd_deg = getPitchCorrectionAP() + pitch_cmd_deg
    gs_last = get(gs_dref)

    if vert_mode == VERT_MODE_VSHOLD and get(vs_fpa) == 1 then
        set(curr_vert_mode, VERT_MODE_FPAHOLD)
    else
        set(curr_vert_mode, vert_mode)
    end
    
    set(alt_acq, bool2num(mcp_alt_acq))
    updatePitchFltDirCmd(pitch_cmd_deg)
    updatePitchFltDir()
    return pitch_cmd_deg
end
