--[[
*****************************************************************************************
* Script Name: ap_roll
* Author Name: discord/bruh4096#4512(Tim G.)
* Script Description: Code for autopilot roll modes
*****************************************************************************************
--]]

roll_kp = createGlobalPropertyf("Strato/777/roll_dbg/kp", 0)
roll_ki = createGlobalPropertyf("Strato/777/roll_dbg/ki", 0)
roll_kd = createGlobalPropertyf("Strato/777/roll_dbg/kd", 0)
roll_et = createGlobalPropertyf("Strato/777/roll_dbg/et", 0)
roll_spd = createGlobalPropertyf("Strato/777/roll_dbg/roll_spd", 0)
ap_roll_eng = createGlobalPropertyi("Strato/777/roll_dbg/eng", 0)
roll_tgt = createGlobalPropertyf("Strato/777/autopilot/roll_tgt_deg", 0)
hdg_sel_eng = createGlobalPropertyi("Strato/777/mcp/hdg_sel_eng", 0)
hdg_hold_eng = createGlobalPropertyi("Strato/777/mcp/hdg_hold_eng", 0)
hdg_to_trk = createGlobalPropertyi("Strato/777/mcp/hdg_to_trk", 0)

curr_roll_mode = globalPropertyi("Strato/777/fma/active_roll_mode")

roll_fltdir_pilot = createGlobalPropertyi("Strato/777/pfd/roll_fltdir_pilot", 0)
roll_fltdir_copilot = createGlobalPropertyi("Strato/777/pfd/roll_fltdir_copilot", 0)

flt_dir_pilot = globalPropertyi("Strato/777/mcp/flt_dir_pilot")
flt_dir_copilot = globalPropertyi("Strato/777/mcp/flt_dir_copilot")

ap_engaged = globalPropertyi("Strato/777/mcp/ap_on", 0)
ap_roll_on = createGlobalPropertyi("Strato/777/autopilot/ap_roll_on", 0)


roll_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/roll_AHARS_deg_pilot")
roll_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/roll_AHARS_deg_copilot")
track_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/ground_track_mag_copilot")
track_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/ground_track_mag_copilot")
mag_heading_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/heading_AHARS_deg_mag_copilot")
mag_heading_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/heading_AHARS_deg_mag_copilot")
mcp_heading = globalPropertyf("sim/cockpit/autopilot/heading_mag")
cas_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
cas_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_copilot")

roll_cmd_pid = PID:new{kp = 0.09, ki = 0, kd = 0.015, errtotal = 0, errlast = 0, lim_out = 1,  lim_et = 100}
lat_cmd_pid = PID:new{kp = 1, ki = 0, kd = 0.5, errtotal = 0, errlast = 0, lim_out = 15,  lim_et = 100}

hdg_hold_to_select = false
ap_roll_engaged = false
hdg_hold_val = -1
roll_last = 0

curr_lat_mode = LAT_MODE_OFF

function getCurrLatInput()
    local hdg_avg = (get(mag_heading_pilot) + get(mag_heading_copilot)) / 2
    local trk_avg = (get(track_pilot) + get(track_copilot)) / 2
    local curr_lat = hdg_avg
    if get(hdg_to_trk) == 1 then
        curr_lat = trk_avg
    end

    return curr_lat
end

function getAutoBankLimit(ias)
    if ias > 210 then
        return 15
    elseif ias <= 210 and ias >= 180 then
        return 15 + (210 - ias) * 10 / 30
    else
        return 25
    end
end

function getAutoPilotRollMaintainCmd(roll_maint)
    local avg_roll = (get(roll_pilot) + get(roll_copilot)) / 2
    local roll_dir_tgt = roll_maint - avg_roll
    set(roll_tgt, get(roll_tgt) + (roll_dir_tgt - get(roll_tgt)) * 0.2 * get(f_time))
    
    roll_cmd_pid:update{tgt=roll_maint, curr=avg_roll}

    if get(f_time) ~= 0 then
        set(roll_spd, (avg_roll - roll_last) / get(f_time))
    end
    roll_last = avg_roll
    
    return roll_cmd_pid.output
end

function getAutopilotHdgTrkSelCmd(hdg_tgt)
    local hdg_mcp = hdg_tgt
    local curr_lat = getCurrLatInput()

    if math.abs(curr_lat - hdg_mcp) > 180 then
        if hdg_mcp > curr_lat then
            curr_lat = curr_lat + 360
        else
            hdg_mcp = hdg_mcp + 360
        end
    end

    local tgt_ki = 0.2
    if math.abs(curr_lat - hdg_tgt) > 3 then
        tgt_ki = 3
    end

    local avg_ias = (get(cas_pilot) + get(cas_copilot)) / 2
    local bank_limit = getAutoBankLimit(avg_ias)

    lat_cmd_pid:update{ki=tgt_ki, tgt=hdg_mcp, curr=curr_lat, lim_out=bank_limit}
    set(roll_et, lat_cmd_pid.errtotal)
    
    return getAutoPilotRollMaintainCmd(lat_cmd_pid.output)
end

function getAutopilotHdgTrkHoldCmd()
    local avg_roll = (get(roll_pilot) + get(roll_copilot)) / 2
    if math.abs(avg_roll) >= 5 then
        hdg_hold_to_select = true
        return getAutoPilotRollMaintainCmd(0)
    else
        if hdg_hold_to_select or hdg_hold_val == -1 then
            local curr_lat = round(getCurrLatInput())
            set(mcp_heading, curr_lat)
            hdg_hold_to_select = false
            hdg_hold_val = curr_lat
        end
        return getAutopilotHdgTrkSelCmd(hdg_hold_val)
    end
end

function updateRollMode()
    if get(hdg_sel_eng) == 1 and (curr_lat_mode == LAT_MODE_TRK_HOLD or 
        curr_lat_mode == LAT_MODE_HDG_HOLD) then
        set(hdg_hold_eng, 0)
    elseif get(hdg_hold_eng) == 1 and (curr_lat_mode == LAT_MODE_TRK_SEL or 
        curr_lat_mode == LAT_MODE_HDG_SEL) then
        set(hdg_sel_eng, 0)
    end
    if get(hdg_sel_eng) == 1 then
        if get(hdg_to_trk) == 1 then
            curr_lat_mode = LAT_MODE_TRK_SEL
        else
            curr_lat_mode = LAT_MODE_HDG_SEL
        end
    elseif get(hdg_hold_eng) == 1 then
        if get(hdg_to_trk) == 1 then
            curr_lat_mode = LAT_MODE_TRK_HOLD
        else
            curr_lat_mode = LAT_MODE_HDG_HOLD
        end
    else
        curr_lat_mode = LAT_MODE_OFF
    end
    set(curr_roll_mode, curr_lat_mode)
end

function updateRollFltDir() -- Updates roll flight directors
    if ap_roll_engaged and get(flt_dir_pilot) == 1 then
        set(roll_fltdir_pilot, 1)
    else
        set(roll_fltdir_pilot, 0)
    end

    if ap_roll_engaged and get(flt_dir_copilot) == 1 then
        set(roll_fltdir_copilot, 1)
    else
        set(roll_fltdir_copilot, 0)
    end
end

function getAutopilotRollCmd()
    updateRollFltDir()
    updateRollMode()
    if curr_lat_mode == LAT_MODE_HDG_SEL or curr_lat_mode == LAT_MODE_TRK_SEL then
        hdg_hold_val = -1
        hdg_hold_to_select = false
        ap_roll_engaged = true
        set(ap_roll_on, 1)
        return getAutopilotHdgTrkSelCmd(get(mcp_heading))
    elseif curr_lat_mode == LAT_MODE_HDG_HOLD or curr_lat_mode == LAT_MODE_TRK_HOLD then
        ap_roll_engaged = true
        set(ap_roll_on, 1)
        return getAutopilotHdgTrkHoldCmd()
    else
        set(ap_roll_on, 0)
        ap_roll_engaged = false
        hdg_hold_val = -1
        hdg_hold_to_select = false
        return 0
    end
end
