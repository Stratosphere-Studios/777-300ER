--[[
*****************************************************************************************
* Script Name: Electrical System
* Author Name: nathroxer
* Script Description: script for electrical system and gen logic with manipulators
*****************************************************************************************
--]]

--replace create_command
function deferred_command(name,desc,realFunc)
	return replace_command(name,realFunc)
end

--replace create_dataref
function deferred_dataref(name,nilType,callFunction)
   if callFunction~=nil then
      print("WARN:" .. name .. " is trying to wrap a function to a dataref -> use xlua")
   end
   return find_dataref(name)
end

--*************************************************************************************--
--**                             FIND X-PLANE DATAREFS                               **--
--*************************************************************************************--

simDR_time_elapsed                             = find_dataref("sim/time/total_running_time_sec")
simDR_startup_running                           = find_dataref("sim/operation/prefs/startup_running")
simDR_battery                                   = find_dataref("sim/cockpit2/electrical/battery_on")
simDR_gpu_on                                    = find_dataref("sim/cockpit/electrical/gpu_on")
simDR_apu_gen_on                                = find_dataref("sim/cockpit2/electrical/APU_generator_on")
simDR_apu_N1_percent                            = find_dataref("sim/cockpit2/electrical/APU_N1_percent")
simDR_generator_on                              = find_dataref("sim/cockpit2/electrical/generator_on")
simDR_N2_percent_indicators                     = find_dataref("sim/cockpit2/engine/indicators/N2_percent")
simDR_generator_1_failed                        = find_dataref("sim/operation/failures/rel_genera0")
simDR_generator_2_failed                        = find_dataref("sim/operation/failures/rel_genera1")
simDR_generator_3_failed                        = find_dataref("sim/operation/failures/rel_genera2")
simDR_generator_4_failed                        = find_dataref("sim/operation/failures/rel_genera3")
simDR_apu_failed                                = find_dataref("sim/operation/failures/rel_apu")
simDR_apu_switch_status                         = find_dataref("sim/cockpit/engine/APU_switch")
simDR_apu_status                                = find_dataref("sim/cockpit/engine/APU_running")
simDR_bus_volts                                 = find_dataref("sim/cockpit2/electrical/bus_volts") --ITS WRITABLE :D
simDR_gpu_volts                                 = find_dataref("sim/cockpit2/electrical/GPU_generator_volts")
simDR_eng_oil_pressure_low                      = find_dataref("sim/cockpit2/annunciators/oil_pressure_low")
simDR_battery_voltage                           = find_dataref("sim/cockpit2/electrical/battery_voltage_actual_volts")
simDR_battery_amps                              = find_dataref("sim/cockpit2/electrical/battery_amps")

B777DR_hydraulic_primary_pumps                  = find_dataref("Strato/777/hydraulics/pump/primary/fault")
B777DR_hydraulic_demand_fault                   = find_dataref("Strato/777/hydraulics/pump/demand/fault")



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

B777DR_left_main_bus_volts                     = deferred_dataref("Strato/777/cockpit/elec/left_main_bus_volts", "number")
B777DR_left_xfr_bus_volts                      = deferred_dataref("Strato/777/cockpit/elec/left_xfr_bus_volts", "number")
B777DR_right_main_bus_volts                    = deferred_dataref("Strato/777/cockpit/elec/right_main_bus_volts", "number")
B777DR_right_xfr_bus_volts                     = deferred_dataref("Strato/777/cockpit/elec/right_xfr_bus_volts", "number")

B777DR_ovhd_elec_button_pos                     = deferred_dataref("Strato/777/cockpit/ovhd/elec/position", "array[14]")
B777DR_ovhd_elec_button_target                  = deferred_dataref("Strato/777/cockpit/ovhd/elec/target", "array[14]")

B777DR_ovhd_apu_switch_pos                      = deferred_dataref("Strato/777/cockpit/ovhd/elec/apu/position", "number")
B777DR_ovhd_apu_switch_target                   = deferred_dataref("Strato/777/cockpit/ovhd/elec/apu/target", "number")

B777DR_ext_pwr_primary_switch_mode              = deferred_dataref("Strato/777/cockpit/elec/ext_pwr_primary_switch_mode", "number")
B777DR_ext_pwr_secondary_switch_mode            = deferred_dataref("Strato/777/cockpit/elec/ext_pwr_secondary_switch_mode", "number")

B777DR_left_backup_gen_on                     = deferred_dataref("Strato/777/cockpit/elec/left_backup_gen_on", "number")
B777DR_right_backup_gen_on                    = deferred_dataref("Strato/777/cockpit/elec/right_backup_gen_on", "number")

--annunciators


B777DR_annun_pos                                = deferred_dataref("Strato/777/cockpit/annunciator/pos", "number")
B777DR_annun_target                             = deferred_dataref("Strato/777/cockpit/annunciator/target", "number")
B777DR_annun_mode                               = deferred_dataref("Strato/777/cockpit/annunciator/test_mode", "number")

B777DR_annun_elec_battery_off                   = deferred_dataref("Strato/777/cockpit/annunciator/elec/battery_off", "number")
B777DR_annun_elec_ext_pwr_primary_avail         = deferred_dataref("Strato/777/cockpit/annunciator/elec/ext_pwr_primary_avail", "number")
B777DR_annun_elec_ext_pwr_primary_on            = deferred_dataref("Strato/777/cockpit/annunciator/elec/ext_pwr_primary_on", "number")
B777DR_annun_elec_ext_pwr_secondary_avail       = deferred_dataref("Strato/777/cockpit/annunciator/elec/ext_pwr_secondary_avail", "number")
B777DR_annun_elec_ext_pwr_secondary_on          = deferred_dataref("Strato/777/cockpit/annunciator/elec/ext_pwr_secondary_on", "number")
B777DR_annun_elec_apu_gen_off                   = deferred_dataref("Strato/777/cockpit/annunciator/elec/apu_gen_off", "number")
B777DR_annun_elec_apu_failed                    = deferred_dataref("Strato/777/cockpit/annunciator/elec/apu_fail", "number")

B777DR_annun_elec_gen_ctrl_off                  = deferred_dataref("Strato/777/cockpit/annunciator/elec/gen_ctrl_off", "array[2]")
B777DR_annun_elec_gen_drive                     = deferred_dataref("Strato/777/cockpit/annunciator/elec/gen_drive_off", "array[4]")

B777DR_annun_elec_bus_tie_off                   = deferred_dataref("Strato/777/cockpit/annunciator/elec/bus_tie_off", "array[2]")
B777DR_annun_cabin_util_off                     = deferred_dataref("Strato/777/cockpit/annunciator/elec/cabin_util", "array[2]")

B777DR_GPU                                      = deferred_dataref("Strato/777/cockpit/elec/gpu_on", "number")

B777DR_load_shed                                = deferred_dataref("Strato/777/cockpit/elec/load_shed", "number")

B777DR_bus_tie_test                             = deferred_dataref("Strato/777/cockpit/elec/tie_test", "array[2]")
B777DR_left_AC_proximity                        = deferred_dataref("Strato/777/cockpit/elec/left_AC/tie_test", "array[3]")
B777DR_right_AC_proximity                       = deferred_dataref("Strato/777/cockpit/elec/right_AC/tie_test", "array[4]")
B777DR_AC_status                                = deferred_dataref("Strato/777/cockpit/elec/AC_status", "array[5]")
B777DR_primary_ext_pwr_on                       = deferred_dataref("Strato/777/cockpit/elec/primary_ext_pwr_on", "number")
B777DR_secondary_ext_pwr_on                     = deferred_dataref("Strato/777/cockpit/elec/secondary_ext_pwr_on", "number")

B777DR_apu_gen_dir                              = deferred_dataref("Strato/777/cockpit/elec/apu_gen_direction", "number") --1 for right 0 for left
B777DR_sec_ext_pwr_dir                          = deferred_dataref("Strato/777/cockpit/elec/sec_ext_pwr_direction", "number") --1 for right 0 for left

B777DR_bus_tie_left_open                        = deferred_dataref("Strato/777/cockpit/elec/bus_tie_left_open", "number")
B777DR_bus_tie_right_open                       = deferred_dataref("Strato/777/cockpit/elec/bus_tie_right_open", "number")
B777DR_elec_flow_sharing                        = deferred_dataref("Strato/777/cockpit/elec/flow_sharing", "number")

B777DR_left_TBB                                 = deferred_dataref("Strato/777/cockpit/elec/left_TBB", "number")
B777DR_right_TBB                                = deferred_dataref("Strato/777/cockpit/elec/right_TBB", "number")

B777DR_right_util_avail                         = deferred_dataref("Strato/777/cockpit/elec/right_util_avail", "number")
B777DR_left_util_avail                          = deferred_dataref("Strato/777/cockpit/elec/left_util_avail", "number")
B777DR_batt_charging_status                     = deferred_dataref("Strato/777/cockpit/elec/batt_charging_status", "number") -- 0 = not charging, 1 = charging, 2 = charged
B777DR_apu_batt_charging_status                 = deferred_dataref("Strato/777/cockpit/elec/apu_batt_charging_status", "number") -- 0 = not charging, 1 = charging, 2 = charged

-- MISC

B777DR_autoland_status                          = deferred_dataref("Strato/777/cockpit/autoland/status", "number") -- 0 = off, 2 = active
B777DR_batt_amps_indicated                      = deferred_dataref("Strato/777/cockpit/elec/battery_amps_indicated", "array[2]") -- Indicated battery amps


function B777_battery()
    if B777DR_ovhd_elec_button_pos[0] > 0.95 then
        simDR_battery[0] = 1
    else
        simDR_battery[0] = 0
    end

    if simDR_battery[0] == 1 and simDR_battery_amps[0] > 0 then
        B777DR_batt_charging_status = 1
    else
        B777DR_batt_charging_status = 0
    end

    if simDR_battery[1] == 1 and simDR_battery_amps[1] > 0 then
        B777DR_apu_batt_charging_status = 1
    else
        B777DR_apu_batt_charging_status = 0
    end

end

function B777_bus_tie()

    if B777DR_ovhd_elec_button_pos[12] == 1 and simDR_battery[0] == 1 then
        bus_tie[1].powered = 1
        B777DR_bus_tie_test[0] = bus_tie[1].powered -- test PASSED
    else
        bus_tie[1].powered = 0
        B777DR_bus_tie_test[0] = bus_tie[1].powered
    end

    if B777DR_ovhd_elec_button_pos[13] == 1 and simDR_battery[0] == 1 then
        bus_tie[2].powered = 1
        B777DR_bus_tie_test[1] = bus_tie[2].powered -- test PASSED
    else
        bus_tie[2].powered = 0
        B777DR_bus_tie_test[1] = bus_tie[2].powered
    end

    for i = 1, 3 do
        if left_AC_proximity[i].name == "apu_gen" or left_AC_proximity[i].name == "ext_sec" then --should technically be working
            if bus_tie[1].powered == 1 then --working
                left_AC_proximity[i].proximity = true 
            else
                left_AC_proximity[i].proximity = false
            end
        end
    end

    for i = 1, 4 do
        if right_AC_proximity[i].name == "apu_gen" or right_AC_proximity[i].name == "ext_sec" then --should technically be working
            if bus_tie[2].powered == 1 then --working
                right_AC_proximity[i].proximity = true
            else
                right_AC_proximity[i].proximity = false
            end
        end
    end

    if simDR_generator_on[0] == 1 then
        left_AC_proximity[1].avail = true
    else
        left_AC_proximity[1].avail = false
    end

    if simDR_generator_on[1] == 1 then
        right_AC_proximity[1].avail = true
    else
        right_AC_proximity[1].avail = false
    end

    if simDR_apu_N1_percent >= 95 and B777DR_ovhd_elec_button_pos[3] > 0.95 then
        left_AC_proximity[2].avail = true
        right_AC_proximity[2].avail = true
        
    else
        left_AC_proximity[2].avail = false
        right_AC_proximity[2].avail = false
    end

    local ext_pwr_present = (B777DR_GPU == 1)

    if B777DR_ext_pwr_primary_switch_mode == 1 and ext_pwr_present then --change to actual power supply
        right_AC_proximity[3].avail = true
    else
        right_AC_proximity[3].avail = false
    end

    if B777DR_ext_pwr_secondary_switch_mode == 1 and ext_pwr_present then --change to actual power supply
        left_AC_proximity[3].avail = true
        right_AC_proximity[4].avail = true
    else
        left_AC_proximity[3].avail = false
        right_AC_proximity[4].avail = false
    end

    for i = 1, 3 do
        left_AC_proximity[i].taken = false
    end

    for i = 1, 4 do
        right_AC_proximity[i].taken = false
    end

    --AI TESTING

    -- Reset all sources to not taken
    for i = 1, 3 do
        left_AC_proximity[i].taken = false
    end
    for i = 1, 4 do
        right_AC_proximity[i].taken = false
    end

    -- Pre-check: APU and EXT SEC mutual exclusion
    local apu_avail = false
    local ext_sec_avail = false
    for i = 1, 3 do
        if left_AC_proximity[i].name == "apu_gen" and left_AC_proximity[i].avail and left_AC_proximity[i].proximity then
            apu_avail = true
        end
        if left_AC_proximity[i].name == "ext_sec" and left_AC_proximity[i].avail and left_AC_proximity[i].proximity then
            ext_sec_avail = true
        end
    end

    -- EXT SEC is inhibited if APU is online
    if apu_avail and ext_sec_avail then
        for i = 1, 3 do
            if left_AC_proximity[i].name == "ext_sec" then
                left_AC_proximity[i].avail = false
            end
        end
        for i = 1, 4 do
            if right_AC_proximity[i].name == "ext_sec" then
                right_AC_proximity[i].avail = false
            end
        end
    end

    -- LEFT BUS PRIORITY: left_idg > apu_gen > ext_sec > right_idg
    local left_order = {"left_idg", "apu_gen", "ext_sec", "right_idg"}
    local left_taken = false
    for o = 1, 4 do
        local source_name = left_order[o]
        for i = 1, 3 do
            if left_AC_proximity[i].name == source_name and left_AC_proximity[i].avail and left_AC_proximity[i].proximity then
                left_AC_proximity[i].taken = true
                left_taken = true
                break
            end
        end
        if left_taken then break end
    end

    -- RIGHT BUS PRIORITY: right_idg > ext_prim > ext_sec > apu_gen > left_idg
    local right_order = {"right_idg", "ext_prim", "ext_sec", "apu_gen", "left_idg"}
    local right_taken = false
    for o = 1, 5 do
        local source_name = right_order[o]
        for i = 1, 4 do
            if right_AC_proximity[i].name == source_name and right_AC_proximity[i].avail and right_AC_proximity[i].proximity then
                right_AC_proximity[i].taken = true
                right_taken = true
                break
            end
        end
        if right_taken then break end
    end

    -- THE FOLLOWING CODE SETS VOLTAGES

    -- LEFT MAIN BUS
    if left_taken then
        B777DR_left_main_bus_volts = 115
    elseif bus_tie[1].powered == 1 and bus_tie[2].powered == 1 and right_taken then
        B777DR_left_main_bus_volts = 115
    else
        B777DR_left_main_bus_volts = 0
    end

    -- RIGHT MAIN BUS
    if right_taken then
        B777DR_right_main_bus_volts = 115
    elseif bus_tie[1].powered == 1 and bus_tie[2].powered == 1 and left_taken then
        -- Left side has IDG and bus tie is closed, so power can flow to right
        B777DR_right_main_bus_volts = 115
    else
        B777DR_right_main_bus_volts = 0
    end

    -- TRANSFER BUSES FOLLOW MAIN BUS VOLTAGES
    B777DR_left_xfr_bus_volts = B777DR_left_main_bus_volts
    B777DR_right_xfr_bus_volts = B777DR_right_main_bus_volts





    B777DR_left_AC_proximity[0] = left_AC_proximity[1].taken and 1 or 0 --TESTING
    B777DR_left_AC_proximity[1] = left_AC_proximity[2].taken and 1 or 0
    B777DR_left_AC_proximity[2] = left_AC_proximity[3].taken and 1 or 0 ---TESTING VARIABLES

    B777DR_right_AC_proximity[0] = right_AC_proximity[1].taken and 1 or 0 --TESTING
    B777DR_right_AC_proximity[1] = right_AC_proximity[2].taken and 1 or 0
    B777DR_right_AC_proximity[2] = right_AC_proximity[3].taken and 1 or 0
    B777DR_right_AC_proximity[3] = right_AC_proximity[4].taken and 1 or 0 ---TESTING VARIABLES
 

    AC_sources_taken_total = 0

    AC_source_list[1].status = simDR_generator_on[1]
    AC_source_list[2].status = simDR_generator_on[0]

    if simDR_generator_on[1] == 1 then
        AC_sources_taken_total = AC_sources_taken_total + 1
    end

    if simDR_generator_on[0] == 1 then
        AC_sources_taken_total = AC_sources_taken_total + 1
    end

    -- Track each side separately
    local left_sources_taken = (simDR_generator_on[0] == 1) and 1 or 0
    local right_sources_taken = (simDR_generator_on[1] == 1) and 1 or 0

    for i = 3, 5 do
        local source = AC_source_list[i]
        local is_available = 0
    
        if i == 3 then
            is_available = (simDR_apu_N1_percent >= 95 and B777DR_ovhd_elec_button_pos[3] > 0.95) and 1 or 0
        elseif i == 4 then
            is_available = (B777DR_GPU == 1 and B777DR_ext_pwr_primary_switch_mode == 1) and 1 or 0
        elseif i == 5 then
            is_available = (B777DR_GPU == 1 and B777DR_ext_pwr_secondary_switch_mode == 1) and 1 or 0
        end
    
        local left_taken = false
        local right_taken = false
    
        for j = 1, 3 do
            if left_AC_proximity[j].name == source.name and left_AC_proximity[j].taken then
                left_taken = true

                
                break
            end
        end
    
        for j = 1, 4 do
            if right_AC_proximity[j].name == source.name and right_AC_proximity[j].taken then
                right_taken = true
                break
            end
        end
    
        if is_available == 1 then
            local assigned = false
    
            if left_taken and left_sources_taken < 1 then
                source.status = 1
                left_sources_taken = left_sources_taken + 1
                assigned = true
            end
            
            if right_taken and right_sources_taken < 1 then
                source.status = 1
                right_sources_taken = right_sources_taken + 1
                assigned = true
            end
            
            if is_available == 1 and not assigned then
                source.status = 0
            end
            
        else
            source.status = 0
        end

    end

    AC_sources_taken_total = left_sources_taken + right_sources_taken

    -- Load shedding logic

    local left_bus_powered = false
    local right_bus_powered = false

    local left_source = nil
    local right_source = nil

    -- Find which source powers left bus
    for i = 1, 3 do
        if left_AC_proximity[i].taken then
            left_bus_powered = true
            left_source = left_AC_proximity[i].name
            break
        end
    end

    -- Find which source powers right bus
    for i = 1, 4 do
        if right_AC_proximity[i].taken then
            right_bus_powered = true
            right_source = right_AC_proximity[i].name
            break
        end
    end

    if left_bus_powered and right_bus_powered then
        if left_source == right_source then
            B777DR_load_shed = 1  -- Load shed on: both buses powered by same source
        else
            B777DR_load_shed = 0  -- Load shed off: buses powered by different sources
        end
    else
        B777DR_load_shed = 1  -- Load shed on: one or both buses unpowered
    end



    B777DR_AC_status[0] = AC_source_list[1].status
    B777DR_AC_status[1] = AC_source_list[2].status
    B777DR_AC_status[2] = AC_source_list[3].status
    B777DR_AC_status[3] = AC_source_list[4].status
    B777DR_AC_status[4] = AC_source_list[5].status

    --EVERYTHING BELOW THIS SECTION IS FOR SYNOPTICS


    ---EVERYTHING BELOW THIS NEEDS DEBUGGING

    if B777DR_left_xfr_bus_volts > 30 and B777DR_left_main_bus_volts > 30 then --THIS IS FOR SIMPLICITY (BACKUP GENS ARENT SIMULATED)
        B777DR_left_TBB = 1
    else
        B777DR_left_TBB = 0
    end

    if B777DR_right_xfr_bus_volts > 30 and B777DR_right_main_bus_volts > 30 and B777DR_autoland_status == 0 then --THIS IS FOR SIMPLICITY (BACKUP GENS ARE PARTLY SIMULATED)
        B777DR_right_TBB = 1
    else
        B777DR_right_TBB = 0
    end

    ---end debugging here

    ---add datarefs for bus ties

    local left_bus_tie_count = 0
    B777DR_apu_gen_dir = 2 -- APU GEN NOT AVAILABLE
    B777DR_sec_ext_pwr_dir = 2 -- APU GEN NOT AVAILABLE

    local right_bus_tie_count = 0

    for i = 2, 4 do
        if right_AC_proximity[i].taken == true and right_AC_proximity[i].name ~= "ext_prim" then
            right_bus_tie_count = right_bus_tie_count + 1 ---DOESNT SPECIFY WHICH BUS IT IS POWERING
            if right_AC_proximity[i].name == "apu_gen" and bus_tie[2].powered == 1 then
                B777DR_apu_gen_dir = 1 -- APU GEN RIGHT
            end
            if right_AC_proximity[i].name == "ext_sec" and bus_tie[2].powered == 1 then
                B777DR_sec_ext_pwr_dir = 1 -- SEC EXT PWR RIGHT
            end
        end
    end

    if right_bus_tie_count > 0 then
        B777DR_bus_tie_right_open = 0 -- BUS TIE CLOSED
    else
        B777DR_bus_tie_right_open = 1 -- BUS TIE OPEN
    end

    for i = 2, 3 do
        if left_AC_proximity[i].taken == true then
            left_bus_tie_count = left_bus_tie_count + 1

            if left_AC_proximity[i].name == "apu_gen" and bus_tie[1].powered == 1 then
                B777DR_apu_gen_dir = 0 -- APU GEN LEFT
            end
            if left_AC_proximity[i].name == "ext_sec" and bus_tie[1].powered == 1 then
                B777DR_sec_ext_pwr_dir = 0 -- SEC EXT PWR LEFT
            end
        end
    end

    if B777DR_apu_gen_dir == 1 or B777DR_sec_ext_pwr_dir == 1 or B777DR_elec_flow_sharing == 1 then
        B777DR_bus_tie_right_open = 0
    else
        B777DR_bus_tie_right_open = 1
    end

    if B777DR_apu_gen_dir == 0 or B777DR_sec_ext_pwr_dir == 0 or B777DR_elec_flow_sharing == 1 then
        B777DR_bus_tie_left_open = 0
    else
        B777DR_bus_tie_left_open = 1
    end

    if B777DR_load_shed == 1 and AC_sources_taken_total > 0 and bus_tie[1].powered == 1 and bus_tie[2].powered == 1 then
        B777DR_elec_flow_sharing = 1 -- LOAD SHED ON
    else
        B777DR_elec_flow_sharing = 0 -- LOAD SHED OFF
    end

    if B777DR_left_main_bus_volts <= 30 or B777DR_load_shed == 1 or (B777DR_ovhd_elec_button_pos[10] < 0.05 or B777DR_ovhd_elec_button_pos[11] < 0.05) then
        B777DR_left_util_avail = 0
    else
        B777DR_left_util_avail = 1
    end

    if B777DR_right_main_bus_volts <= 30 or B777DR_load_shed == 1 or (B777DR_ovhd_elec_button_pos[10] < 0.05 or B777DR_ovhd_elec_button_pos[11] < 0.05) then
        B777DR_right_util_avail = 0
    else
        B777DR_right_util_avail = 1
    end

end

function B777_ext_pwr()

    if simDR_gpu_volts > 100 then
        B777DR_GPU = 1
    else
        B777DR_GPU = 0
    end

    if B777DR_annun_mode == 1 and annun_pwr == 1 then
        B777DR_annun_elec_ext_pwr_primary_avail = 1
        B777DR_annun_elec_ext_pwr_primary_on = 1
        B777DR_annun_elec_ext_pwr_secondary_avail = 1
        B777DR_annun_elec_ext_pwr_secondary_on = 1
    else

        if B777DR_GPU == 1 then
            if (simDR_generator_on[0] == 1 or simDR_generator_on[1] == 1) then
                B777DR_ext_pwr_primary_switch_mode = 0
                B777DR_ext_pwr_secondary_switch_mode = 0
            end
            if B777DR_ext_pwr_primary_switch_mode == 0 then
                B777DR_annun_elec_ext_pwr_primary_avail = 1
                B777DR_annun_elec_ext_pwr_primary_on = 0
            else
                B777DR_annun_elec_ext_pwr_primary_avail = 0
                B777DR_annun_elec_ext_pwr_primary_on = 1
            end

            if  B777DR_ext_pwr_secondary_switch_mode == 0 then
                B777DR_annun_elec_ext_pwr_secondary_avail = 1
                B777DR_annun_elec_ext_pwr_secondary_on = 0
            else
                B777DR_annun_elec_ext_pwr_secondary_avail = 0
                B777DR_annun_elec_ext_pwr_secondary_on = 1
            end
        else
            B777DR_annun_elec_ext_pwr_primary_avail = 0
            B777DR_annun_elec_ext_pwr_primary_on = 0
            B777DR_annun_elec_ext_pwr_secondary_avail = 0
            B777DR_annun_elec_ext_pwr_secondary_on = 0

            B777DR_ext_pwr_primary_switch_mode = 0
            B777DR_ext_pwr_secondary_switch_mode = 0
        end
    end

    if AC_source_list[4].status == 1 then
        B777DR_primary_ext_pwr_on = 1
    else
        B777DR_primary_ext_pwr_on = 0
    end

    if AC_source_list[5].status == 1 then
        B777DR_secondary_ext_pwr_on = 1
    else
        B777DR_secondary_ext_pwr_on = 0
    end

    if B777DR_primary_ext_pwr_on == 1 or B777DR_secondary_ext_pwr_on == 1 then
        simDR_gpu_on = 1
    else
        simDR_gpu_on = 0
    end


end

function B777_apu()

    if B777DR_ovhd_apu_switch_pos > 1.95 then
        simDR_apu_switch_status = 2
    elseif B777DR_ovhd_apu_switch_pos < 0.05 then
        simDR_apu_switch_status = 0
    end

    if  AC_source_list[3].status == 1 then
        simDR_apu_gen_on = 1
    else
        simDR_apu_gen_on = 0
    end

    if simDR_apu_switch_status > 0.25 then
        simDR_battery[1] = 1
    else
        simDR_battery[1] = 0
    end

end

function B777_idg_gen()-----------------------------------------------------------------

    if B777DR_ovhd_elec_button_pos[4] < 0.05 and B777DR_ovhd_elec_button_pos[5] > 0.95 and simDR_N2_percent_indicators[0] > 60 then
        simDR_generator_on[0] = 1
    else
        simDR_generator_on[0] = 0
    end

    if B777DR_ovhd_elec_button_pos[6] < 0.05 and B777DR_ovhd_elec_button_pos[7] > 0.95 and simDR_N2_percent_indicators[1] > 60 then
        simDR_generator_on[1] = 1
    else
        simDR_generator_on[1] = 0
    end



end

function B777_annunciators()

    if simDR_bus_volts[0] > 18 then
        annun_pwr = 1  -- powered
    else
        annun_pwr = 0  -- not powered
    end

    if B777DR_annun_pos < 0.05 then
        B777DR_annun_mode = 1
    else
        B777DR_annun_mode = 0
    end

    local apu_self_test_active = simDR_apu_N1_percent > 0 and simDR_apu_N1_percent < 7
    local apu_real_fault = simDR_apu_failed == 1 or B777DR_annun_mode == 1
    local start_status = simDR_apu_switch_status == 1 or simDR_apu_switch_status == 2

    if simDR_battery[0] == 1 and start_status and (apu_real_fault or apu_self_test_active) then
        B777DR_annun_elec_apu_failed = 1
    else
        B777DR_annun_elec_apu_failed = 0
    end

    if annun_pwr == 1 then

        if B777DR_ovhd_elec_button_pos[0] < 0.05 or B777DR_annun_mode == 1 then
            B777DR_annun_elec_battery_off = 1
        else
            B777DR_annun_elec_battery_off = 0
        end

        if B777DR_ovhd_elec_button_pos[3] < 0.05 or B777DR_annun_mode == 1 then
            B777DR_annun_elec_apu_gen_off = 1
        else
            B777DR_annun_elec_apu_gen_off = 0
        end


        for i = 0, 1 do
            if B777DR_ovhd_elec_button_pos[i + 10] < 0.05 or B777DR_annun_mode == 1 then
                B777DR_annun_cabin_util_off[i] = 1
            else
                B777DR_annun_cabin_util_off[i] = 0
            end
        end

        for i = 0, 1 do
            if B777DR_ovhd_elec_button_pos[i + 12] < 0.05 or B777DR_annun_mode == 1 then
                B777DR_annun_elec_bus_tie_off[i] = 1
            else
                B777DR_annun_elec_bus_tie_off[i] = 0
            end
        end

        for i = 0, 1 do
            if B777DR_ovhd_elec_button_pos[i + 8] < 0.05 or B777DR_annun_mode == 1 or simDR_eng_oil_pressure_low[i] == 1 then
                B777DR_annun_elec_gen_drive[i + 2] = 1
            else
                B777DR_annun_elec_gen_drive[i + 2] = 0
            end
        end

        
    else
        B777DR_annun_elec_battery_off = 0
        B777DR_annun_elec_apu_gen_off = 0

        for i = 0, 1 do
            B777DR_annun_cabin_util_off[i] = 0
        end

        for i = 0, 1 do
            B777DR_annun_elec_bus_tie_off[i] = 0
        end

        for i = 2, 3 do
            B777DR_annun_elec_gen_drive[i] = 0
        end

    end


    if simDR_battery[0] == 1 then

        for i = 0, 1 do
            if B777DR_ovhd_elec_button_pos[5 + (i * 2)] > 0.95 and B777DR_ovhd_elec_button_pos[4 + (i * 2)] < 0.05 and simDR_N2_percent_indicators[i] >= 60 and B777DR_annun_mode == 0 then
                B777DR_annun_elec_gen_ctrl_off[i] = 0
                B777DR_annun_elec_gen_drive[i] = 0
            else
                B777DR_annun_elec_gen_ctrl_off[i] = 1
                B777DR_annun_elec_gen_drive[i] = 1
            end
        end

    else

        for i = 0, 1 do
            B777DR_annun_elec_gen_ctrl_off[i] = 0
            B777DR_annun_elec_gen_drive[i] = 0
        end

    end

end

function B777_battery_indications()
    for i = 0, 1 do
        if simDR_battery_amps[i] < 1.6 and simDR_battery_amps[i] > -1.6 then
            B777DR_batt_amps_indicated[i] = 0 
        else
            if simDR_battery_amps[i] >= 1.6 then
                B777DR_batt_amps_indicated[i] = math.floor(simDR_battery_amps[i])
            end
    
            if simDR_battery_amps[i] <= -1.6 then
                B777DR_batt_amps_indicated[i] = math.ceil(simDR_battery_amps[i])
            end
        end
    end
end

function B777_ext_pwr_primary_cmdHandler(phase, duration)
    if phase == 0 then
        B777DR_ovhd_elec_button_target[2] = 1
        if B777DR_GPU == 1 and (simDR_generator_on[0] == 0 or simDR_generator_on[1] == 0) then
            B777DR_ext_pwr_primary_switch_mode = 1 - B777DR_ext_pwr_primary_switch_mode
        else
            B777DR_ext_pwr_primary_switch_mode = 0
        end
    elseif phase == 2 then
        B777DR_ovhd_elec_button_target[2] = 0
    end
end

function B777_ext_pwr_secondary_cmdHandler(phase, duration)
    if phase == 0 then
        B777DR_ovhd_elec_button_target[1] = 1
        if B777DR_GPU == 1 and (simDR_generator_on[0] == 0 or simDR_generator_on[1] == 0) then
            B777DR_ext_pwr_secondary_switch_mode = 1 - B777DR_ext_pwr_secondary_switch_mode
        else
            B777DR_ext_pwr_secondary_switch_mode = 0
        end
    elseif phase == 2 then
        B777DR_ovhd_elec_button_target[1] = 0
    end
end

function B777_apu_up_cmdHandler(phase, duration)
    if phase == 0 then
        B777DR_ovhd_apu_switch_target = math.min(B777DR_ovhd_apu_switch_target+1, 2)
    end
    if phase == 2 then
        if B777DR_ovhd_apu_switch_target == 2 then
            B777DR_ovhd_apu_switch_target = 1
        end
    end
end

function B777_apu_down_cmdHandler(phase, duration)
    if phase == 0 then
        B777DR_ovhd_apu_switch_target = math.max(B777DR_ovhd_apu_switch_target-1, 0)
        if B777DR_ovhd_apu_switch_target == 0 then
            B777_apu_start = 0
        end
    end
end

function B777_annun_up_cmdHandler(phase, duration)
    if phase == 0 then
        B777DR_annun_target = math.max(B777DR_annun_target - 1, 0)
    end
end

function B777_annun_down_cmdHandler(phase, duration)
    if phase == 0 then
        B777DR_annun_target = math.min(B777DR_annun_target + 1, 2)
    end
end

--init COMMANDS
B777CMD_ext_pwr_primary                         = deferred_command("Strato/777/cockpit/ovhd/elec/ext_pwr_primary", "external power primary", B777_ext_pwr_primary_cmdHandler)
B777CMD_ext_pwr_secondary                       = deferred_command("Strato/777/cockpit/ovhd/elec/ext_pwr_secondary", "external power secondary", B777_ext_pwr_secondary_cmdHandler)
B777CMD_apu_sel_up                              = deferred_command("Strato/777/cockpit/ovhd/apu/sel_up", "apu switch up", B777_apu_up_cmdHandler)
B777CMD_apu_sel_down                            = deferred_command("Strato/777/cockpit/ovhd/apu/sel_down", "apu switch down", B777_apu_down_cmdHandler)

B777CMD_annun_sel_up                            = deferred_command("Strato/777/cockpit/ovhd/annun/sel_up", "annunciator switch up", B777_annun_up_cmdHandler)
B777CMD_annun_sel_down                          = deferred_command("Strato/777/cockpit/ovhd/annun/sel_down", "annunciator down", B777_annun_down_cmdHandler)

function flight_start()

    AC_source_list = {
        {name = "right_idg", status = simDR_generator_on[1]}, ---status is the "do the bus ties say it should be on" state
        {name = "left_idg", status = simDR_generator_on[0]},
        {name = "apu_gen", status = 0},
        {name = "ext_prim", status = 0},
        {name = "ext_sec", status = 0},
    }
    
    left_AC_proximity = {
        {name = "left_idg", proximity = true, avail = false, taken = false}, ---proximity is the "is it connected" state, avail is the "producing power" state
        {name = "apu_gen", proximity = false, avail = false, taken = false},
        {name = "ext_sec", proximity = false, avail = false, taken = false},
    }
    
    right_AC_proximity = {
        {name = "right_idg", proximity = true, avail = false, taken = false}, ---taken represents if it is in use
        {name = "apu_gen", proximity = false, avail = false, taken = false},
        {name = "ext_prim", proximity = true, avail = false, taken = false},
        {name = "ext_sec", proximity = false, avail = false, taken = false},
    } 
    
    bus_tie = { 
        {name = "left_bus_tie", powered = 0, state = 0}, ---do not modify STATE REFERS TO WHETHER THE TIE IS OPEN OR CLOSED AFTER BEING POWERED
        {name = "right_bus_tie", powered = 0, state = 0} ---do not modify
    }

    AC_sources_taken_total = 0

    simDR_bus_volts[0] = 0
    simDR_bus_volts[1] = 0
    simDR_bus_volts[2] = 0
    simDR_bus_volts[3] = 0
    simDR_bus_volts[4] = 0
    simDR_bus_volts[5] = 0

    if simDR_startup_running == 1 then ---4 and 6

        B777DR_ovhd_elec_button_target[0] = 1

		for i = 3, 13 do
            if i ~= 4 and i ~= 6 then
                B777DR_ovhd_elec_button_target[i] = 1
            else
                B777DR_ovhd_elec_button_target[i] = 0
            end
        end

	else
        
        B777DR_ovhd_elec_button_target[0] = 0

        for i = 3, 13 do
            B777DR_ovhd_elec_button_target[i] = 0
        end

    end


    B777DR_left_main_bus_volts = 115
    B777DR_right_main_bus_volts = 115
    B777DR_left_xfr_bus_volts = 115
    B777DR_right_xfr_bus_volts = 115
    annun_pwr = 0
    B777DR_annun_pos = 1
	B777DR_annun_target = 1
    B777DR_annun_mode = 0
    B777DR_load_shed = 0
    B777DR_autoland_status = 0
end

function after_physics()
    --[[
    print(simDR_generator_on[0], simDR_generator_on[1], simDR_apu_gen_on, B777DR_ext_pwr_primary_switch_mode, B777DR_ext_pwr_secondary_switch_mode)
    print("load shed              " .. B777DR_load_shed)
    print("bus tie switches              " .. B777DR_bus_tie_test[0], B777DR_bus_tie_test[1])
    print("left taken              " .. B777DR_left_AC_proximity[0], B777DR_left_AC_proximity[1], B777DR_left_AC_proximity[2])
    print("right taken              " .. B777DR_right_AC_proximity[0], B777DR_right_AC_proximity[1], B777DR_right_AC_proximity[2], B777DR_right_AC_proximity[3])
    print("total AC                 " .. B777DR_AC_status[0], B777DR_AC_status[1], B777DR_AC_status[2], B777DR_AC_status[3], B777DR_AC_status[4])
    print("right idg gen status " .. simDR_generator_on[1], "left idg gen status " .. simDR_generator_on[0], "apu gen status " .. simDR_apu_gen_on, "ext pwr primary status " .. B777DR_primary_ext_pwr_on , "ext pwr secondary status " .. B777DR_secondary_ext_pwr_on)

    ]]--

    B777DR_ovhd_elec_button_pos[0] = B777_animate(B777DR_ovhd_elec_button_target[0], B777DR_ovhd_elec_button_pos[0], 15)---battery
    B777DR_ovhd_elec_button_pos[3] = B777_animate(B777DR_ovhd_elec_button_target[3], B777DR_ovhd_elec_button_pos[3], 15)---apu gen


    B777DR_ovhd_elec_button_pos[4] = B777_animate(B777DR_ovhd_elec_button_target[4], B777DR_ovhd_elec_button_pos[4], 15)---IDG 1 DISC
    B777DR_ovhd_elec_button_pos[5] = B777_animate(B777DR_ovhd_elec_button_target[5], B777DR_ovhd_elec_button_pos[5], 15)---IDG 1 gen ctrl
    B777DR_ovhd_elec_button_pos[6] = B777_animate(B777DR_ovhd_elec_button_target[6], B777DR_ovhd_elec_button_pos[6], 15)---IDG 2 DISC
    B777DR_ovhd_elec_button_pos[7] = B777_animate(B777DR_ovhd_elec_button_target[7], B777DR_ovhd_elec_button_pos[7], 15)---IDG 2 gen ctrl
    B777DR_ovhd_elec_button_pos[8] = B777_animate(B777DR_ovhd_elec_button_target[8], B777DR_ovhd_elec_button_pos[8], 15)---backup IDG 1
    B777DR_ovhd_elec_button_pos[9] = B777_animate(B777DR_ovhd_elec_button_target[9], B777DR_ovhd_elec_button_pos[9], 15)---backup IDG 2

    B777DR_ovhd_elec_button_pos[10] = B777_animate(B777DR_ovhd_elec_button_target[10], B777DR_ovhd_elec_button_pos[10], 15)---ife/pass seats
    B777DR_ovhd_elec_button_pos[11] = B777_animate(B777DR_ovhd_elec_button_target[11], B777DR_ovhd_elec_button_pos[11], 15)---cabin/util

    B777DR_ovhd_elec_button_pos[12] = B777_animate(B777DR_ovhd_elec_button_target[12], B777DR_ovhd_elec_button_pos[12], 15)---Bus tie 1
    B777DR_ovhd_elec_button_pos[13] = B777_animate(B777DR_ovhd_elec_button_target[13], B777DR_ovhd_elec_button_pos[13], 15)---Bus tie 2

    B777DR_ovhd_apu_switch_pos = B777_animate(B777DR_ovhd_apu_switch_target, B777DR_ovhd_apu_switch_pos, 15)---apu

    B777DR_ovhd_elec_button_pos[1] = B777_animate(B777DR_ovhd_elec_button_target[1], B777DR_ovhd_elec_button_pos[1], 15)---ext pwr 1
    B777DR_ovhd_elec_button_pos[2] = B777_animate(B777DR_ovhd_elec_button_target[2], B777DR_ovhd_elec_button_pos[2], 15)---ext pwr 2

    B777DR_annun_pos = B777_animate(B777DR_annun_target, B777DR_annun_pos, 15)---annunciators


    B777_idg_gen()            -- sets simDR_generator_on[], affects left_AC
    B777_battery()            -- powers everything
    B777_ext_pwr()            -- enables EXT PWR, required for bus logic
    B777_bus_tie()            -- builds AC tables, must follow the above
    B777_apu()                -- uses ctr_AC from bus_tie()
    B777_annunciators()
    B777_battery_indications()
    
end
