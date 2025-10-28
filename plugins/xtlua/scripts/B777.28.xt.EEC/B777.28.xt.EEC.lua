--[[
*****************************************************************************************
* Script Name: Electronic Engine Control (EEC) Logic
* Author Name: nathroxer
* Script Description: this script contains the logic for engine ignition and control
*****************************************************************************************
--]]

-- Replace create_command function
function deferred_command(name, desc, realFunc)
    return replace_command(name, realFunc)
end

-- Replace create_dataref function
function deferred_dataref(name, nilType, callFunction)
    if callFunction ~= nil then
        print("WARN: " .. name .. " is trying to wrap a function to a dataref -> use xlua")
    end
    return find_dataref(name)
end




--*************************************************************************************--
--**                             FIND X-PLANE DATAREFS                               **--
--*************************************************************************************--

simDR_egt_override                              = find_dataref("sim/operation/override/override_itt_egt")

simDR_startup_running                           = find_dataref("sim/operation/prefs/startup_running")
simDR_N2_percent_indicators                     = find_dataref("sim/cockpit2/engine/indicators/N2_percent")
simDR_N2                                        = find_dataref("sim/flightmodel/engine/ENGN_N2_")
simDR_apu_bleed                                 = find_dataref("sim/cockpit2/bleedair/actuators/apu_bleed")
simDR_EPR_percent_indicators                    = find_dataref("sim/flightmodel/engine/ENGN_EPR")
simDR_egt                                       = find_dataref("sim/flightmodel2/engines/EGT_deg_cel")
simDR_bleed_avail_left                          = find_dataref("sim/cockpit2/bleedair/indicators/bleed_available_left")
simDR_bleed_avail_right                         = find_dataref("sim/cockpit2/bleedair/indicators/bleed_available_right")

simDR_ignition                                  = find_dataref("sim/cockpit2/engine/actuators/ignition_key")
simDR_bus_volts                                 = find_dataref("sim/cockpit2/electrical/bus_volts") --ITS WRITABLE :D
simDR_fuel_cutoff                               = find_dataref("sim/cockpit2/engine/actuators/mixture_ratio")
simDR_engine_igniter_on                         = find_dataref("sim/cockpit2/engine/actuators/igniter_on")
simDR_ff                                        = find_dataref("sim/cockpit2/engine/indicators/fuel_flow_kg_sec") -- fuel flow in kg/s
simDR_OAT                                       = find_dataref("sim/cockpit2/temperature/outside_air_temp_degc") --OAT in Celsius
simDR_N1_bug                                    = find_dataref("sim/cockpit2/engine/actuators/N1_target_bug")
simDR_total_tank_fuel_quantity_kg               = find_dataref("sim/flightmodel/weight/m_fuel_total")
simDR_altitude                                  = find_dataref("sim/cockpit2/gauges/indicators/altitude_ft_pilot") --in feet
simDR_sim_time                                  = find_dataref("sim/time/total_running_time_sec")

B777DR_annun_mode                               = find_dataref("Strato/777/cockpit/annunciator/test_mode")
B777DR_eng_flag_test                            = find_dataref("Strato/777/cockpit/fuel/eng_flag")

simDR_engine_igniter_on                         = find_dataref("sim/cockpit2/engine/actuators/igniter_on")
B777DR_fuel_cutoff_switch_pos                   = find_dataref("Strato/777/cockpit/ovhd/fuel/cutoff_switch_position") --0 = L, 1 = R
simDR_fuel_cutoff                              = find_dataref("sim/cockpit2/engine/actuators/mixture_ratio")
B777DR_fuel_flow_indicated                      = deferred_dataref("Strato/777/cockpit/engines/fuel_flow_indicated", "array[2]")

simCMD_igniter_on_1         = find_command("sim/igniters/igniter_contin_on_1")
simCMD_igniter_on_2         = find_command("sim/igniters/igniter_contin_on_2")

simCMD_igniter_off_1        = find_command("sim/igniters/igniter_contin_off_1")
simCMD_igniter_off_2        = find_command("sim/igniters/igniter_contin_off_2")

simCMD_starter_on_1         = find_command("sim/starters/engage_starter_1")
simCMD_starter_on_2         = find_command("sim/starters/engage_starter_2")

simCMD_starter_off_1        = find_command("sim/starters/shut_down_1")
simCMD_starter_off_2        = find_command("sim/starters/shut_down_2")

--*************************************************************************************--
--**                          FUEL SYSTEM LOGIC AND FUNCTIONS                        **--
--*************************************************************************************--

--*************************************************************************************--
--**                           FLIGHT LOOP CALLBACK                                  **--
--*************************************************************************************--



--*************************************************************************************--
--**                            REGISTER FLIGHT LOOP                                 **--
--*************************************************************************************--



--*************************************************************************************--
--**                            ADD DEFERRED COMMANDS                                 **--
--*************************************************************************************--

----- ANIMATION UTILITY -----------------------------------------------------------------
function B777_animate(target, variable, speed)
    if math.abs(target - variable) < 0.1 then return target end
    variable = variable + ((target - variable) * (speed * SIM_PERIOD))
    return variable
end

--------------------------------------------------------------------------------


--create datarefs

B777DR_ovhd_eec_button_pos                     = deferred_dataref("Strato/777/cockpit/ovhd/eec/position", "array[3]")
B777DR_ovhd_eec_button_target                  = deferred_dataref("Strato/777/cockpit/ovhd/eec/target", "array[3]")

B777DR_ovhd_ign_switch_pos                     = deferred_dataref("Strato/777/cockpit/ovhd/ignition/position", "array[2]")
B777DR_ovhd_ign_switch_target                  = deferred_dataref("Strato/777/cockpit/ovhd/ignition/target", "array[2]")
B777DR_EEC_status                              = deferred_dataref("Strato/777/cockpit/ovhd/eec/status", "array[2]")

--annunciators

B777DR_annun_autostart_off                     = deferred_dataref("Strato/777/cockpit/annunciator/eec/autostart_off", "number")
B777DR_annun_eec_altn                          = deferred_dataref("Strato/777/cockpit/annunciator/eec/eec_altn", "array[2]")


--*************************************************************************************--



function B777_ignition()

    local ignition_status = {0,0}

    if (B777DR_ovhd_ign_switch_pos[0] < 0.05 and simDR_N2_percent_indicators[0] < 54 and simDR_sim_time > 5) or (simDR_sim_time < 20 and simDR_startup_running == 1) then --packs
        ignition_status[1] = 1
    else
        ignition_status[1] = 0
    end

    if (B777DR_ovhd_ign_switch_pos[1] < 0.05 and simDR_N2_percent_indicators[1] < 54 and simDR_sim_time > 5) or (simDR_sim_time < 20 and simDR_startup_running == 1) then --packs
        ignition_status[2] = 1
    else
        ignition_status[2] = 0
    end

    if ignition_status[1] == 1 then
        simCMD_starter_on_1:start()
        simCMD_igniter_on_1:start()
    else
        simCMD_starter_on_1:stop()
        simCMD_starter_off_1:once()
        simCMD_igniter_on_1:stop()
        simCMD_starter_off_1:once()
    end

    if ignition_status[2] == 1 then
        simCMD_starter_on_2:start()
        simCMD_igniter_on_2:start()
    else
        simCMD_starter_on_2:stop()
        simCMD_starter_off_2:once()
        simCMD_igniter_on_2:stop()
        simCMD_starter_off_2:once()
    end

    if (simDR_N2_percent_indicators[0] > 55 and simDR_fuel_cutoff[0] > 0) and ign_1_flag == false then
        B777CMD_ign_1_sel_up:once()
    end

    if (simDR_N2_percent_indicators[1] > 55 and simDR_fuel_cutoff[1] > 0) and ign_2_flag == false then
        B777CMD_ign_2_sel_up:once()
    end

    for i = 0, 1 do
        local N2_factor = math.min(simDR_N2_percent_indicators[i] / 50, 1)
        
        local EPR_factor = math.max(simDR_EPR_percent_indicators[i] - 0.9, 0) * 2
        EPR_factor = math.min(EPR_factor, 1)
        
        simDR_fuel_cutoff[i] = (0.3 + 0.7 * N2_factor) * (0.5 + 0.5 * EPR_factor) * B777DR_fuel_cutoff_switch_pos[i]
    end
    
    



    B777DR_eng_flag_test[0] = ignition_status[1]
    B777DR_eng_flag_test[1] = ignition_status[2]

end

function B777_thrust_lim()

    if flex_temp ~= nil and simDR_OAT < flex_temp then
        sel_temp = flex_temp
    else
        sel_temp = simDR_OAT
    end

    if simDR_OAT > 32 then
        to_temp_factor = 0.03 * (sel_temp - 32)
    else
        to_temp_factor = 0
    end

    to_thrust_lim[4].factor = 1.09 - to_temp_factor
    to_thrust_lim[5].factor = 1.05 - to_temp_factor
    to_thrust_lim[6].factor = 1.0 - to_temp_factor

    for i = 1, 6 do
        if to_thrust_lim[i].sel == 1 then
            thrust_lim[1].factor = to_thrust_lim[i].factor
            break
        end
    end

    --CLB

    for i = 1, 3 do
        if clb_thrust_lim[i].sel == 1 then
            thrust_lim[2].factor = clb_thrust_lim[i].factor
            break
        end
    end

    --CRZ

    --DEBUG


    local tow = zfw + simDR_total_tank_fuel_quantity_kg
    local alt_factor = (sel_alt - 20000) / (20000)
    local weight_factor = (tow - zfw) / (351534 - zfw)

    thrust_lim[3].factor = 45 + (10 * weight_factor) - (5 * alt_factor)

    --N1 bug

    simDR_N1_bug[0] = thrust_lim[1].factor * 100
    simDR_N1_bug[1] = thrust_lim[1].factor * 100

    --Active stage

end

function B777_annunciators()

    if simDR_bus_volts[0] > 18 then

        for i = 0, 1 do

            if B777DR_ovhd_eec_button_pos[i] > 0.95 then
                B777DR_annun_eec_altn[i] = 1
            else
                B777DR_annun_eec_altn[i] = 0
            end

        end

        if B777DR_ovhd_eec_button_pos[2] < 0.05 or B777DR_annun_mode == 1 then
            B777DR_annun_autostart_off = 1
        else
            B777DR_annun_autostart_off = 0
        end

    else
        for i = 0, 1 do
            B777DR_annun_eec_altn[i] = 0
        end

        B777DR_annun_autostart_off = 0
    end

end


function B777_ign_1_up_cmdHandler(phase, duration)
    if phase == 0 or phase == 1 then
        B777DR_ovhd_ign_switch_target[0] = math.min(B777DR_ovhd_ign_switch_target[0]+1, 1)
    end
end

function B777_ign_1_down_cmdHandler(phase, duration)
    if phase == 0 or phase == 1 then
        B777DR_ovhd_ign_switch_target[0] = math.max(B777DR_ovhd_ign_switch_target[0]-1, 0)
        ign_1_flag = true
    else
        ign_1_flag = false
    end
    if phase == 2 then
        if simDR_N2_percent_indicators[0] > 50 and simDR_fuel_cutoff[0] > 0 then
            B777DR_ovhd_ign_switch_target[0] = 1
        end
    end
end

function B777_ign_2_up_cmdHandler(phase, duration)
    if phase == 0 or phase == 1 then
        B777DR_ovhd_ign_switch_target[1] = math.min(B777DR_ovhd_ign_switch_target[1]+1, 1)
    end
end

function B777_ign_2_down_cmdHandler(phase, duration)
    if phase == 0 or phase == 1 then
        B777DR_ovhd_ign_switch_target[1] = math.max(B777DR_ovhd_ign_switch_target[1]-1, 0)
        ign_2_flag = true
    else
        ign_2_flag = false
    end
    if phase == 2 then
        if simDR_N2_percent_indicators[1] > 50 and simDR_fuel_cutoff[1] > 0 then
            B777DR_ovhd_ign_switch_target[1] = 1
        end
    end
end

B777CMD_ign_1_sel_up                              = deferred_command("Strato/777/cockpit/ovhd/ign_1/sel_up", "apu switch up", B777_ign_1_up_cmdHandler)
B777CMD_ign_1_sel_down                            = deferred_command("Strato/777/cockpit/ovhd/ign_1/sel_down", "apu switch down", B777_ign_1_down_cmdHandler)
B777CMD_ign_2_sel_up                              = deferred_command("Strato/777/cockpit/ovhd/ign_2/sel_up", "apu switch up", B777_ign_2_up_cmdHandler)
B777CMD_ign_2_sel_down                            = deferred_command("Strato/777/cockpit/ovhd/ign_2/sel_down", "apu switch down", B777_ign_2_down_cmdHandler)


function aircraft_load()
end

function flight_start()


    ign_1_flag = false
    ign_2_flag = false

    if simDR_startup_running == 1 then ---4 and 6
        B777DR_ovhd_eec_button_target[2] = 1
        for i = 0, 1 do
            B777DR_ovhd_ign_switch_target[i] = 0
        end
    else
        B777DR_ovhd_eec_button_target[2] = 0
        for i = 0, 1 do
            B777DR_ovhd_ign_switch_target[i] = 1
        end
    end

    to_temp_factor = 0
    flex_temp = nil
    sel_temp = simDR_OAT
    sel_alt = 30000 --FL (this is a placeholder, it will be set by the FMS)
    thrust_red_alt = 1500
    zfw = 0 --this will be set by the FMS

    thrust_lim = {
        {stage = "TO", sel = 1, factor = 1.09},
        {stage = "CLB", sel = 0, factor = 0.97},
        {stage = "CRZ", sel = 0, factor = 0.5},
        {stage = "GA", sel = 0, factor = 1.09},
    }

    to_thrust_lim = {
        {stage = "TO", sel = 1, factor = 1.09},
        {stage = "TO_1", sel = 0, factor = 1.05},
        {stage = "TO_2", sel = 0, factor = 1.0},
        {stage = "D_TO", sel = 0, factor = 1.09},
        {stage = "D_TO_1", sel = 0, factor = 1.05},
        {stage = "D_TO_2", sel = 0, factor = 1.0},
    }

    clb_thrust_lim = {
        {stage = "CLB", sel = 0, factor = 0.97},
        {stage = "CLB_1", sel = 0, factor = 0.95},
        {stage = "CLB_2", sel = 1, factor = 0.93},
    }


end



function after_physics()

    simDR_N2[0] = 30
    
    for i = 0, 8 do 
        print("test value" .. i .. "     " .. B777DR_eng_flag_test[i])
    end

    for i = 0, 2 do
        B777DR_ovhd_eec_button_pos[i] = B777_animate(B777DR_ovhd_eec_button_target[i], B777DR_ovhd_eec_button_pos[i], 15)
    end

    for i = 0, 1 do
        B777DR_ovhd_ign_switch_pos[i] = B777_animate(B777DR_ovhd_ign_switch_target[i], B777DR_ovhd_ign_switch_pos[i], 15)
    end

    B777_ignition()
    B777_thrust_lim()
    B777_annunciators()


end
