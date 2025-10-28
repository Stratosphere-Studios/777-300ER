--[[
*****************************************************************************************
* Script Name: Fuel System
* Author Name: nathroxer
* Script Description: script for fuel system and pump logic with manipulators
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

simDR_time_elapsed                             = find_dataref("sim/time/total_flight_time_sec")
simDR_fuel_pump_psi                            = find_dataref("sim/cockpit2/fuel/tank_pump_pressure_psi")
simDR_fuel_pump_on                             = find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on")
simDR_startup_running                          = find_dataref("sim/operation/prefs/startup_running")
simDR_apu_N1_percent                           = find_dataref("sim/cockpit2/electrical/APU_N1_percent")
simDR_tank_fuel_quantity_kg                    = find_dataref("sim/cockpit2/fuel/fuel_quantity")
simDR_bus_volts                                = find_dataref("sim/cockpit2/electrical/bus_volts")
simDR_fuel_cutoff                              = find_dataref("sim/cockpit2/engine/actuators/mixture_ratio")
simDR_battery                                  = find_dataref("sim/cockpit2/electrical/battery_on")
simDR_eng_fuel_flow_kg_sec                     = find_dataref("sim/flightmodel/engine/ENGN_FF_")
simDR_fuel_tank_weight_kg                      = find_dataref("sim/flightmodel/weight/m_fuel")
simDR_override_fuel_system                     = find_dataref("sim/operation/override/override_fuel_system")
simDR_left_tank_quantity_kg                    = find_dataref("sim/flightmodel/weight/m_fuel1")
simDR_center_tank_quantity_kg                  = find_dataref("sim/flightmodel/weight/m_fuel2")
simDR_right_tank_quantity_kg                   = find_dataref("sim/flightmodel/weight/m_fuel3")
simDR_before_mix                               = find_dataref("sim/flightmodel2/engines/has_fuel_flow_before_mixture")
simDR_N2_percent_indicators                    = find_dataref("sim/cockpit2/engine/indicators/N2_percent")
simDR_apu_gen_on                               = find_dataref("sim/cockpit2/electrical/APU_generator_on")
simDR_apu_bleed_on                             = find_dataref("sim/cockpit2/bleedair/actuators/apu_bleed")
simDR_fuel_temp                                = find_dataref("sim/cockpit2/fuel/fuel_temp_at_fuel_tank")

B777DR_ovhd_elec_button_pos                    = find_dataref("Strato/777/cockpit/ovhd/elec/position")
B777DR_left_main_bus_volts                     = find_dataref("Strato/777/cockpit/elec/left_main_bus_volts")
B777DR_left_xfr_bus_volts                      = find_dataref("Strato/777/cockpit/elec/left_xfr_bus_volts")
B777DR_right_main_bus_volts                    = find_dataref("Strato/777/cockpit/elec/right_main_bus_volts")
B777DR_right_xfr_bus_volts                     = find_dataref("Strato/777/cockpit/elec/right_xfr_bus_volts")
B777DR_load_shed                               = find_dataref("Strato/777/cockpit/elec/load_shed")
B777DR_annun_pos                               = find_dataref("Strato/777/cockpit/annunciator/pos")
B777DR_annun_mode                              = find_dataref("Strato/777/cockpit/annunciator/test_mode")
B777DR_ovhd_apu_switch_pos                     = find_dataref("Strato/777/cockpit/ovhd/elec/apu/position")
B777DR_EEC_status                              = find_dataref("Strato/777/cockpit/ovhd/eec/status")


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

---CODE IN THIS FILE IS IN KILOGRAMS

--create datarefs


B777DR_spar_valve                               = deferred_dataref("Strato/777/cockpit/fuel/spar_valve_open", "array[2]") --0 = L, 1 = R

B777DR_ovhd_fuel_button_pos                     = deferred_dataref("Strato/777/cockpit/ovhd/fuel/position", "array[11]")
B777DR_ovhd_fuel_button_target                  = deferred_dataref("Strato/777/cockpit/ovhd/fuel/target", "array[11]")
B777DR_fuel_cutoff_switch_target                = deferred_dataref("Strato/777/cockpit/ovhd/fuel/cutoff_switch_target", "array[2]") --0 = L, 1 = R
B777DR_fuel_cutoff_switch_pos                   = deferred_dataref("Strato/777/cockpit/ovhd/fuel/cutoff_switch_position", "array[2]") --0 = L, 1 = R
B777DR_fuel_pump_powered                        = deferred_dataref("Strato/777/cockpit/fuel/pump/powered", "array[6]") --0 = L fwd, 1 = L aft, 2 = CTR L, 3 = CTR R, 4 = R aft, 5 = R fwd

--fuel pump pressure
B777DR_fuel_pump_pressure                       = deferred_dataref("Strato/777/cockpit/fuel/pump/pressure", "array[6]")

B777DR_ovhd_fuel_jett_select                    = deferred_dataref("Strato/777/cockpit/ovhd/fuel/jettison/selector/position", "number")

--annunciators
B777DR_annun_fuel_low_press                     = deferred_dataref("Strato/777/cockpit/annunciator/fuel/low_press", "array[6]")

B777DR_pump_test                                = deferred_dataref("Strato/777/cockpit/fuel/pump_test", "array[6]")

B777DR_eng_flag_test                            = deferred_dataref("Strato/777/cockpit/fuel/eng_flag", "array[12]")

--synoptic

B777DR_pump_avail                              = deferred_dataref("Strato/777/cockpit/fuel/pump/avail", "array[6]") --0 = L fwd, 1 = L aft, 2 = CTR L, 3 = CTR R, 4 = R aft, 5 = R fwd
B777DR_pump_supply                             = deferred_dataref("Strato/777/cockpit/fuel/pump/supply", "array[6]") --0 = L fwd, 1 = L aft, 2 = CTR L, 3 = CTR R, 4 = R aft, 5 = R fwd
B777DR_pump_failure                            = deferred_dataref("Strato/777/cockpit/fuel/pump/failure", "array[6]") --0 = L fwd, 1 = L aft, 2 = CTR L, 3 = CTR R, 4 = R aft, 5 = R fwd 
B777DR_crossfeed_dir                           = deferred_dataref("Strato/777/cockpit/fuel/crossfeed/dir", "array[2]") --0 = no crossfeed, 1 = norm, 2 = T, 3 = down, 4 = up
B777DR_crossfeed_active                        = deferred_dataref("Strato/777/cockpit/fuel/crossfeed/active", "number") --0 = no crossfeed, 1 = fwd, 2 = aft
B777DR_crossfeed_open                          = deferred_dataref("Strato/777/cockpit/fuel/crossfeed/open", "array[2]") --0 = no crossfeed, 1 = fwd, 2 = aft
B777DR_apu_active                              = deferred_dataref("Strato/777/cockpit/fuel/apu/active", "number") --0 = APU on, 1 = APU off APU SYNOPTIC EXTENSION
B777DR_apu_synoptic                            = deferred_dataref("Strato/777/cockpit/fuel/apu/synoptic", "number") --0 = APU off, 1 = APU on FUEL FLOW TO APU
B777DR_min_fuel_temp                           = deferred_dataref("Strato/777/cockpit/fuel/min_temp", "number") --minimum fuel temperature for APU operation
B777DR_fuel_temp                               = deferred_dataref("Strato/777/cockpit/fuel/temp", "number") --fuel temperature
--*************************************************************************************--



function B777_fuel_flow()

    for i = 0, 2 do
        if (B777DR_ovhd_fuel_button_pos[i] > 0.95 and B777DR_left_main_bus_volts > 20) or simDR_time_elapsed < 2 then
            fuel_pumps[i+1].powered = 1
        elseif (B777DR_ovhd_fuel_button_pos[i] < 0.05 or B777DR_left_main_bus_volts <= 20) then
            fuel_pumps[i+1].powered = 0
        end
    end

    for i = 3, 5 do
        if (B777DR_ovhd_fuel_button_pos[i] > 0.95 and B777DR_right_main_bus_volts > 20) or simDR_time_elapsed < 2  then
            fuel_pumps[i+1].powered = 1
        elseif (B777DR_ovhd_fuel_button_pos[i] < 0.05 or B777DR_right_main_bus_volts <= 20) then
            fuel_pumps[i+1].powered = 0
        end
    end

    for i = 1, 6 do
        if fuel_pumps[i].powered == 1 then
            B777DR_fuel_pump_powered[i-1] = 1
        else
            B777DR_fuel_pump_powered[i-1] = 0
        end
    end


    local left_avail = 0
    local right_avail = 0

    for i = 1, 3 do
        if fuel_tanks[i].eng_1 == 1 then
            left_avail = 1
            break
        end
    end

    for i = 1, 3 do
        if fuel_tanks[i].eng_2 == 1 then
            right_avail = 1
            break
        end
    end

    if simDR_fuel_tank_weight_kg[0] <= 550 and left_avail == 0 then
        simDR_before_mix[0] = 0
    else
        simDR_before_mix[0] = 1
    end

    if simDR_fuel_tank_weight_kg[2] <= 550 and right_avail == 0 then
        simDR_before_mix[1] = 0
    else
        simDR_before_mix[1] = 1
    end

    local dt = SIM_PERIOD

    local apu_flow = 0.015 * simDR_apu_gen_on + 0.05 * simDR_apu_bleed_on + 0.025

    local left_flow = fuel_tanks[1].eng_1 * simDR_eng_fuel_flow_kg_sec[0] + fuel_tanks[1].eng_2 * simDR_eng_fuel_flow_kg_sec[1] + fuel_tanks[1].apu * apu_flow
    local center_flow  = fuel_tanks[2].eng_1 * simDR_eng_fuel_flow_kg_sec[0] + fuel_tanks[2].eng_2 * simDR_eng_fuel_flow_kg_sec[1] + fuel_tanks[2].apu * apu_flow
    local right_flow = fuel_tanks[3].eng_1 * simDR_eng_fuel_flow_kg_sec[0] + fuel_tanks[3].eng_2 * simDR_eng_fuel_flow_kg_sec[1] + fuel_tanks[3].apu * apu_flow

    fuel_tanks[1].quantity = math.max(0, (fuel_tanks[1].quantity - (left_flow - 0.4 * scavenge[1].powered) * dt))

    fuel_tanks[2].quantity = math.max(0, (fuel_tanks[2].quantity - (center_flow +  0.4 * (scavenge[1].powered + scavenge[2].powered)) * dt))

    fuel_tanks[3].quantity = math.max(0, (fuel_tanks[3].quantity - (right_flow - 0.4 * scavenge[2].powered) * dt))

    simDR_fuel_tank_weight_kg[0] = fuel_tanks[1].quantity
    simDR_fuel_tank_weight_kg[1] = fuel_tanks[2].quantity
    simDR_fuel_tank_weight_kg[2] = fuel_tanks[3].quantity

    for i = 0, 1 do
        if simDR_fuel_cutoff[i] > 0 and simDR_before_mix[i] == 1 then
            B777DR_spar_valve[i] = 1
        else
            B777DR_spar_valve[i] = 0
        end
    end

end

function B777_pump_pressure()

    local left_press = 45
    local ctr_press = 8.5 * math.log(fuel_tanks[2].quantity + 50) - 34.2
    local right_press = 45

    for i = 0,1 do
        B777DR_fuel_pump_pressure[i] = left_press
    end

    for i = 2,3 do
        if simDR_fuel_tank_weight_kg[1] > 20000 then
            B777DR_fuel_pump_pressure[i] = 50
        elseif simDR_fuel_tank_weight_kg[1] == 0 then
            B777DR_fuel_pump_pressure[i] = 0
        else
            B777DR_fuel_pump_pressure[i] = ctr_press
        end
    end

    for i = 4,5 do
        B777DR_fuel_pump_pressure[i] = right_press
    end

end

function B777_crossfeed()

    if B777DR_left_main_bus_volts > 108 then
        
        if B777DR_ovhd_fuel_button_pos[6] > 0.95 and B777DR_left_main_bus_volts > 20 then --crossfeed fwd
            crossfeed[1].powered = 1
        elseif B777DR_ovhd_fuel_button_pos[6] < 0.05 or B777DR_left_main_bus_volts <= 20  then
            crossfeed[1].powered = 0
        end

        if B777DR_ovhd_fuel_button_pos[7] > 0.95 and B777DR_left_main_bus_volts > 20 then --crossfeed aft
            crossfeed[2].powered = 1
        elseif B777DR_ovhd_fuel_button_pos[7] < 0.05 or B777DR_left_main_bus_volts <= 20 then
            crossfeed[2].powered = 0
        end

    else
        crossfeed[1].powered = 0
        crossfeed[2].powered = 0
    end

    crossfeed_avail = math.min(crossfeed[1].powered + crossfeed[2].powered, 1)

    left_tank_power = math.min(fuel_pumps[1].powered + fuel_pumps[2].powered, 1)
    center_left_tank_power = fuel_pumps[3].powered
    center_right_tank_power = fuel_pumps[4].powered
    right_tank_power = math.min(fuel_pumps[5].powered + fuel_pumps[6].powered, 1)

    --CROSSFEEDS

    if crossfeed_avail == 1 then
        for i = 3, 4 do
            left_priority_order[i].crossfeed = 1
            right_priority_order[i].crossfeed = 1
        end
    else
        for i = 3, 4 do
            left_priority_order[i].crossfeed = 0
            right_priority_order[i].crossfeed = 0
        end
    end

    ---DEBUG THE FOLLOWING

    for i = 1, 3 do --reset
        fuel_tanks[i].eng_1 = 0
        fuel_tanks[i].eng_2 = 0
    end

    for i = 1, 2 do --reset
        center_pumps[i].eng_1 = 0
        center_pumps[i].eng_2 = 0
    end

    if simDR_N2_percent_indicators[0] > 45 and simDR_fuel_cutoff[0] > 0 then
        if left_priority_order[1].crossfeed == 1 and center_left_tank_power == 1 and simDR_fuel_tank_weight_kg[1] > 1500 then
            fuel_tanks[2].eng_1 = 1
            center_pumps[1].eng_1 = 1
        elseif left_priority_order[2].crossfeed == 1 and left_tank_power == 1 and simDR_fuel_tank_weight_kg[0] > 1500 then
            fuel_tanks[1].eng_1 = 1 
        elseif left_priority_order[3].crossfeed == 1 and center_right_tank_power == 1 and simDR_fuel_tank_weight_kg[1] > 1500 then
            fuel_tanks[2].eng_1 = 1
            center_pumps[2].eng_1 = 1
        elseif left_priority_order[4].crossfeed == 1 and right_tank_power == 1 and simDR_fuel_tank_weight_kg[2] > 1500 then
            fuel_tanks[3].eng_1 = 1
        else    
            for i = 1, 3 do --reset
                fuel_tanks[i].eng_1 = 0
            end
        end
    end

    if simDR_N2_percent_indicators[1] > 45 and simDR_fuel_cutoff[1] > 0 then
        if left_priority_order[1].crossfeed == 1 and center_right_tank_power == 1 and simDR_fuel_tank_weight_kg[1] > 1500 then
            fuel_tanks[2].eng_2 = 1
            center_pumps[2].eng_2 = 1
        elseif left_priority_order[2].crossfeed == 1 and right_tank_power == 1 and simDR_fuel_tank_weight_kg[2] > 1500 then
            fuel_tanks[3].eng_2 = 1
        elseif left_priority_order[3].crossfeed == 1 and center_left_tank_power == 1 and simDR_fuel_tank_weight_kg[1] > 1500 then
            fuel_tanks[2].eng_2 = 1
            center_pumps[1].eng_2 = 1
        elseif left_priority_order[4].crossfeed == 1 and left_tank_power == 1 and simDR_fuel_tank_weight_kg[0] > 1500 then
            fuel_tanks[1].eng_2 = 1
        else    
            for i = 1, 3 do --reset
                fuel_tanks[i].eng_2 = 0
            end
        end
    end

    if simDR_fuel_tank_weight_kg[1] <= 1500 and (B777DR_ovhd_fuel_button_pos[2] < 0.05 and B777DR_left_main_bus_volts > 20) then
        scavenge[1].powered = 1
    else
        scavenge[1].powered = 0
    end

    if simDR_fuel_tank_weight_kg[1] <= 1500 and (B777DR_ovhd_fuel_button_pos[3] < 0.05 and B777DR_left_main_bus_volts > 20) then
        scavenge[2].powered = 1
    else
        scavenge[2].powered = 0
    end

end

function B777_apu()

    for i = 1, 3 do --reset
        fuel_tanks[i].apu = 0
    end

    for i = 1, 2 do --reset
        center_pumps[i].apu = 0
    end

    if B777DR_ovhd_apu_switch_pos > 0.95 or simDR_apu_N1_percent > 95 then
        B777DR_apu_active = 1
    else
        B777DR_apu_active = 0
    end

    if B777DR_apu_synoptic == 1 then

        if left_priority_order[1].crossfeed == 1 and center_left_tank_power == 1 and simDR_fuel_tank_weight_kg[1] > 1500 then
            fuel_tanks[2].apu = 1
            center_pumps[1].apu = 1
        elseif left_priority_order[2].crossfeed == 1 and left_tank_power == 1 and simDR_fuel_tank_weight_kg[0] > 1500 then
            fuel_tanks[1].apu = 1
        elseif left_priority_order[3].crossfeed == 1 and center_right_tank_power == 1 and simDR_fuel_tank_weight_kg[1] > 1500 then
            fuel_tanks[2].apu = 1
            center_pumps[2].apu = 1
        elseif left_priority_order[4].crossfeed == 1 and right_tank_power == 1 and simDR_fuel_tank_weight_kg[2] > 1500 then
            fuel_tanks[3].apu = 1
        else    
            for i = 1, 3 do --reset
                fuel_tanks[i].apu = 0
            end
        end
    end

    for i = 1, 3 do

        apu_source = 0

        if fuel_tanks[i].apu == 1 then
            apu_source = 1
            break
        end
    end

    if (apu_source == 0 or (apu_source == 1 and fuel_tanks[2].powered == 1)) and simDR_apu_N1_percent > 95 and B777DR_left_main_bus_volts > 108 then
        fuel_tanks[1].apu = 1
    end

end

function B777_annunciators()

    if simDR_bus_volts[0] > 18 then
        if (B777DR_ovhd_fuel_button_pos[0] > 0.95 and B777DR_annun_mode == 0) or  (fuel_tanks[1].apu == 1 and B777DR_apu_synoptic == 1) then
            B777DR_annun_fuel_low_press[0] = 0
        elseif (B777DR_ovhd_fuel_button_pos[0] < 0.05 or B777DR_annun_mode == 1) and (fuel_tanks[1].apu == 0 or B777DR_apu_synoptic == 0) then
            B777DR_annun_fuel_low_press[0] = 1
        end

        if B777DR_ovhd_fuel_button_pos[1] < 0.05 or B777DR_annun_mode == 1 then
            B777DR_annun_fuel_low_press[1] = 1
        else
            B777DR_annun_fuel_low_press[1] = 0
        end

        for i = 2, 3 do
            if (B777DR_ovhd_fuel_button_pos[i] > 0.95 and simDR_fuel_tank_weight_kg[1] <= 1500) or B777DR_annun_mode == 1 then
                B777DR_annun_fuel_low_press[i] = 1
            else
                B777DR_annun_fuel_low_press[i] = 0
            end
        end

        for i = 4, 5 do
            if B777DR_ovhd_fuel_button_pos[i] < 0.05 or B777DR_annun_mode == 1 then
                B777DR_annun_fuel_low_press[i] = 1
            else
                B777DR_annun_fuel_low_press[i] = 0
            end
        end
    else
        for i = 0, 5 do
            B777DR_annun_fuel_low_press[i] = 0
        end
    end
end

function B777_synoptics()

    if fuel_pumps[1].powered == 1 or (fuel_tanks[1].apu == 1 and B777DR_apu_synoptic == 1) then
        B777DR_pump_avail[0] = 1
    else
        B777DR_pump_avail[0] = 0
    end


    for i = 1, 5 do
        if fuel_pumps[i+1].powered == 1 then
            B777DR_pump_avail[i] = 1
        else
            B777DR_pump_avail[i] = 0
        end
    end

    local in_use = {0,0,0}

    for i = 1, 3 do
        if fuel_tanks[i].eng_1 == 1 or fuel_tanks[i].eng_2 == 1 or (fuel_tanks[i].apu == 1 and B777DR_apu_synoptic == 1) then
            in_use[i] = 1
        else
            in_use[i] = 0
        end
    end

    local ctr_in_use = {0,0}

    for i = 1, 2 do
        if center_pumps[i].eng_1 == 1 or center_pumps[i].eng_2 == 1 or (center_pumps[i].apu == 1 and B777DR_apu_synoptic == 1) then
            ctr_in_use[i] = 1
        else
            ctr_in_use[i] = 0
        end
    end

    if (in_use[1] == 1 and fuel_pumps[1].powered == 1) or (fuel_tanks[1].apu == 1 and B777DR_apu_synoptic == 1) then
        B777DR_pump_supply[0] = 1
    else
        B777DR_pump_supply[0] = 0
    end

    if in_use[1] == 1 and fuel_pumps[2].powered == 1 then
        B777DR_pump_supply[1] = 1
    else
        B777DR_pump_supply[1] = 0
    end

    if ctr_in_use[1] == 1 and fuel_pumps[3].powered == 1 then
        B777DR_pump_supply[2] = 1
    else
        B777DR_pump_supply[2] = 0
    end

    if ctr_in_use[2] == 1 and fuel_pumps[4].powered == 1 then
        B777DR_pump_supply[3] = 1
    else
        B777DR_pump_supply[3] = 0
    end

    if in_use[3] == 1 and fuel_pumps[5].powered == 1 then
        B777DR_pump_supply[4] = 1
    else
        B777DR_pump_supply[4] = 0
    end

    if in_use[3] == 1 and fuel_pumps[6].powered == 1 then
        B777DR_pump_supply[5] = 1
    else
        B777DR_pump_supply[5] = 0
    end

    local left_fuel_avail = 0
    local right_fuel_avail = 0
    local left_fuel_dest = (B777DR_apu_synoptic == 1) or simDR_N2_percent_indicators[0] > 45
    local right_fuel_dest = simDR_N2_percent_indicators[1] > 45

    if in_use[1] == 1 or ctr_in_use[1] == 1 then
        left_fuel_avail = 1
    else
        left_fuel_avail = 0
    end





    if in_use[3] == 1 or ctr_in_use[2] == 1 then
        right_fuel_avail = 1
    else
        right_fuel_avail = 0
    end

    B777DR_crossfeed_active = 0

    local function update_crossfeed()
        if crossfeed[1].powered == 1 then
            B777DR_crossfeed_active = 1
        elseif crossfeed[2].powered == 1 then
            B777DR_crossfeed_active = 2
        else
            B777DR_crossfeed_active = 0
        end
    end
    
    if crossfeed_avail == 1 then
        if left_fuel_dest and left_fuel_avail == 0 and right_fuel_avail == 1 then
            update_crossfeed()
        elseif right_fuel_dest and right_fuel_avail == 0 and left_fuel_avail == 1 then
            update_crossfeed()
        end
    end

    if B777DR_crossfeed_active > 0 and left_fuel_dest and left_fuel_avail == 1 then
        B777DR_crossfeed_dir[0] = 2
    elseif B777DR_crossfeed_active == 0 and left_fuel_dest and left_fuel_avail == 1 then
        B777DR_crossfeed_dir[0] = 1
    elseif B777DR_crossfeed_active > 0 and left_fuel_dest and left_fuel_avail == 0 then
        B777DR_crossfeed_dir[0] = 4
    elseif B777DR_crossfeed_active > 0 and left_fuel_avail == 1 and not left_fuel_dest then
        B777DR_crossfeed_dir[0] = 3
    else
        B777DR_crossfeed_dir[0] = 0
    end

    if B777DR_crossfeed_active > 0 and right_fuel_dest and right_fuel_avail == 1 then
        B777DR_crossfeed_dir[1] = 2
    elseif B777DR_crossfeed_active == 0 and right_fuel_dest and right_fuel_avail == 1 then
        B777DR_crossfeed_dir[1] = 1
    elseif B777DR_crossfeed_active > 0 and right_fuel_dest and right_fuel_avail == 0 then
        B777DR_crossfeed_dir[1] = 4
    elseif B777DR_crossfeed_active > 0 and right_fuel_avail == 1 and not right_fuel_dest then
        B777DR_crossfeed_dir[1] = 3
    else
        B777DR_crossfeed_dir[1] = 0
    end

    if simDR_apu_N1_percent > 95 and B777DR_apu_active == 1 then
        B777DR_apu_synoptic = 1
    elseif B777DR_ovhd_apu_switch_pos <= 95 or B777DR_apu_active == 0 then
        B777DR_apu_synoptic = 0
    end

    if crossfeed[1].powered == 1 then
        B777DR_crossfeed_open[0] = 1
    else
        B777DR_crossfeed_open[0] = 0
    end

    if crossfeed[2].powered == 1 then
        B777DR_crossfeed_open[1] = 1
    else
        B777DR_crossfeed_open[1] = 0
    end

    for i = 0, 2 do
        local pump1_idx = i * 2
        local pump2_idx = i * 2 + 1

        if simDR_tank_fuel_quantity_kg[i] <= 1500 then
            if fuel_pumps[pump1_idx + 1].powered == 1 then
                B777DR_pump_failure[pump1_idx] = 1
            else
                B777DR_pump_failure[pump1_idx] = 0
            end

            if fuel_pumps[pump2_idx + 1].powered == 1 then
                B777DR_pump_failure[pump2_idx] = 1
            else
                B777DR_pump_failure[pump2_idx] = 0
            end
        else
            B777DR_pump_failure[pump1_idx] = 0
            B777DR_pump_failure[pump2_idx] = 0
        end
    end

    B777DR_min_fuel_temp = 37
    B777DR_fuel_temp = math.abs(simDR_fuel_temp[0])

end

function aircraft_load()

    simDR_override_fuel_system = 1

end

function flight_start()

    fuel_tanks = {

        {quantity = simDR_fuel_tank_weight_kg[0], eng_1 = 0, eng_2 = 0, apu = 0, proximity = 1},
        {quantity = simDR_fuel_tank_weight_kg[1], eng_1 = 0, eng_2 = 0, apu = 0, proximity = 3},
        {quantity = simDR_fuel_tank_weight_kg[2], eng_1 = 0, eng_2 = 0, apu = 0, proximity = 2}

    }

    center_pumps = { --this is for synoptic surposes
        {eng_1 = 0, eng_2 = 0, apu = 0,}, 
        {eng_1 = 0, eng_2 = 0, apu = 0,},

    }


    fuel_pumps = {
        {powered = 0}, 
        {powered = 0},
        {powered = 0},
        {powered = 0},
        {powered = 0},
        {powered = 0}
    }

    left_tank_power = 0
    center_left_tank_power = 0
    center_right_tank_power = 0
    right_tank_power = 0

    left_priority_order = {
        {tank_index = 2, pump_power = center_left_tank_power, crossfeed = 1},
        {tank_index = 1, pump_power = left_tank_power, crossfeed = 1},
        {tank_index = 2, pump_power = center_right_tank_power, crossfeed = 0},
        {tank_index = 3, pump_power = right_tank_power, crossfeed = 0},
    }

    right_priority_order = {
        {tank_index = 2, pump_power = center_right_tank_power, crossfeed = 1},
        {tank_index = 3, pump_power = right_tank_power, crossfeed = 1},
        {tank_index = 2, pump_power = center_left_tank_power, crossfeed = 0},
        {tank_index = 1, pump_power = left_tank_power, crossfeed = 0},
    }

    crossfeed = {
        {powered = 0}, 
        {powered = 0}
    }
    
    scavenge = {
        {powered = 0}, 
        {powered = 0}
    }

    before_mix = {0,0}
    apu_source = 0

    if simDR_startup_running == 1 then
        for i = 0, 5 do
            B777DR_ovhd_fuel_button_target[i] = 1
        end

        for i = 0, 1 do
            B777DR_fuel_cutoff_switch_target[i] = 1
        end
    else
        for i = 0, 5 do
            B777DR_ovhd_fuel_button_target[i] = 0
        end

        for i = 0, 1 do
            B777DR_fuel_cutoff_switch_target[i] = 0
        end
    end

end

function after_physics()

    B777DR_ovhd_fuel_button_pos[0] = B777_animate(B777DR_ovhd_fuel_button_target[0], B777DR_ovhd_fuel_button_pos[0], 15)--L fwd
    B777DR_ovhd_fuel_button_pos[1] = B777_animate(B777DR_ovhd_fuel_button_target[1], B777DR_ovhd_fuel_button_pos[1], 15)--L aft
    B777DR_ovhd_fuel_button_pos[2] = B777_animate(B777DR_ovhd_fuel_button_target[2], B777DR_ovhd_fuel_button_pos[2], 15)--CTR L
    B777DR_ovhd_fuel_button_pos[3] = B777_animate(B777DR_ovhd_fuel_button_target[3], B777DR_ovhd_fuel_button_pos[3], 15)--CTR R
    B777DR_ovhd_fuel_button_pos[4] = B777_animate(B777DR_ovhd_fuel_button_target[4], B777DR_ovhd_fuel_button_pos[4], 15)--R aft
    B777DR_ovhd_fuel_button_pos[5] = B777_animate(B777DR_ovhd_fuel_button_target[5], B777DR_ovhd_fuel_button_pos[5], 15)--R fwd
    B777DR_ovhd_fuel_button_pos[6] = B777_animate(B777DR_ovhd_fuel_button_target[6], B777DR_ovhd_fuel_button_pos[6], 15)--crossfeed fwd
    B777DR_ovhd_fuel_button_pos[7] = B777_animate(B777DR_ovhd_fuel_button_target[7], B777DR_ovhd_fuel_button_pos[7], 15)--crossfeed aft
    B777DR_ovhd_fuel_button_pos[8] = B777_animate(B777DR_ovhd_fuel_button_target[8], B777DR_ovhd_fuel_button_pos[8], 15)--jett arm
    B777DR_ovhd_fuel_button_pos[9] = B777_animate(B777DR_ovhd_fuel_button_target[9], B777DR_ovhd_fuel_button_pos[9], 15)--L nozzle
    B777DR_ovhd_fuel_button_pos[10] = B777_animate(B777DR_ovhd_fuel_button_target[10], B777DR_ovhd_fuel_button_pos[10], 15)--R nozzle

    B777DR_fuel_cutoff_switch_pos[0] = B777_animate(B777DR_fuel_cutoff_switch_target[0], B777DR_fuel_cutoff_switch_pos[0], 15)--L
    B777DR_fuel_cutoff_switch_pos[1] = B777_animate(B777DR_fuel_cutoff_switch_target[1], B777DR_fuel_cutoff_switch_pos[1], 15)--R

    B777_fuel_flow()
    B777_crossfeed()
    B777_apu()
    B777_annunciators()
    B777_synoptics()

end
