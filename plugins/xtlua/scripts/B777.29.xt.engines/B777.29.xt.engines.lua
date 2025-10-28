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

simDR_engines_override                          = find_dataref("sim/operation/override/override_engines")
simDR_egt_override                              = find_dataref("sim/operation/override/override_itt_egt")

simDR_startup_running                           = find_dataref("sim/operation/prefs/startup_running")
simDR_starter_making_torque                     = find_dataref("sim/flightmodel2/engines/starter_making_torque")

simDR_N2_fltmodel                               = find_dataref("sim/flightmodel/engine/ENGN_N2_")
simDR_N2                                        = find_dataref("sim/cockpit2/engine/indicators/N2_percent")
simDR_N1                                        = find_dataref("sim/flightmodel2/engines/N1_percent")
simDR_egt                                       = find_dataref("sim/flightmodel2/engines/EGT_deg_cel")
simDR_OAT                                       = find_dataref("sim/cockpit2/temperature/outside_air_temp_degc") --OAT in Celsius
simDR_ff                                        = find_dataref("sim/cockpit2/engine/indicators/fuel_flow_kg_sec") -- fuel flow in kg/s

simDR_fnrml_prop                                = find_dataref("sim/flightmodel/forces/fnrml_prop")
simDR_faxil_prop                                = find_dataref("sim/flightmodel/forces/faxil_prop")
simDR_fside_prop                                = find_dataref("sim/flightmodel/forces/fside_prop")
simDR_L_prop                                    = find_dataref("sim/flightmodel/forces/L_prop_")
simDR_M_prop                                    = find_dataref("sim/flightmodel/forces/M_prop_")
simDR_N_prop                                    = find_dataref("sim/flightmodel/forces/N_prop_")

simDR_fuel_cutoff                               = find_dataref("sim/cockpit2/engine/actuators/mixture_ratio")
simDR_engine_igniter_on                         = find_dataref("sim/cockpit2/engine/actuators/igniter_on")
simDR_sim_time                                  = find_dataref("sim/time/total_running_time_sec")



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

B777DR_N1                                       = deferred_dataref("Strato/777/engines/N1", "array[2]")

---synoptic

B777DR_fuel_flow_indicated                      = deferred_dataref("Strato/777/cockpit/engines/fuel_flow_indicated", "array[2]")


----- ANIMATION UTILITY -----------------------------------------------------------------
function B777_animate(target, variable, speed)
    if math.abs(target - variable) < 0.1 then return target end
    variable = variable + ((target - variable) * (speed * SIM_PERIOD))
    return variable
end

--------------------------------------------------------------------------------


--*************************************************************************************--

function B777_synoptic()
    for i = 0,1 do
        B777DR_fuel_flow_indicated[i] = math.max((simDR_ff[i] * 7.93), simDR_fuel_cutoff[i] * 0.5)
    end
end

function B777_egt_calculation()

    local fuel_flow = {0,0}

    for i = 0,1 do
        fuel_flow[i+1] = B777DR_fuel_flow_indicated[i]
    end

    if fuel_flow[1] <= 0.5 and fuel_flow[1] > 0.2 then
        if simDR_engine_igniter_on[0] == 1 then
            n2_calc_1  = (simDR_N2[0])/4 + simDR_OAT
        else
            n2_calc_1 = 0
        end
        B777_egt[1] = math.max((667 * fuel_flow[1]-133), (simDR_N2[0])/4 + simDR_OAT)
    elseif fuel_flow[1] > 0.5 and fuel_flow[1] <= 0.9 then
        local egt_calc_1 = math.max((50*fuel_flow[1]-20),0)
        B777_egt[1] = 90 * math.sqrt(egt_calc_1)
    elseif fuel_flow[1] > 0.9 and fuel_flow[1] <= 1.4 then
        B777_egt[1] = 200*fuel_flow[1] + 270
    elseif fuel_flow[1] > 1.4 then
        B777_egt[1] = 12 * fuel_flow[1]+533.2
    else
        B777_egt[1] = (simDR_N2[0])/4 + simDR_OAT
    end

    B777_egt[1] = math.min(B777_egt[1], 865)
    simDR_egt[0] = B777_egt[1]

    if fuel_flow[2] <= 0.5 and fuel_flow[2] > 0.2 then
        if simDR_engine_igniter_on[1] == 1 then
            n2_calc_2  = (simDR_N2[1])/4 + simDR_OAT
        else
            n2_calc_2 = 0
        end
        B777_egt[2] = math.max((667 * fuel_flow[2]-133), (simDR_N2[1])/4 + simDR_OAT)
    elseif fuel_flow[2] > 0.5 and fuel_flow[2] <= 0.9 then
        local egt_calc_2 = math.max((50*fuel_flow[2]-20),0)
        B777_egt[2] = 90 * math.sqrt(egt_calc_2)
    elseif fuel_flow[2] > 0.9 and fuel_flow[2] <= 1.4 then
        B777_egt[2] = 200*fuel_flow[2] + 270
    elseif fuel_flow[2] > 1.4 then
        B777_egt[2] = 12 * fuel_flow[2]+533.2
    else
        B777_egt[2] = (simDR_N2[1])/4 + simDR_OAT
    end

    B777_egt[2] = math.min(B777_egt[2], 865)
    simDR_egt[1] = B777_egt[2]

end

function B777_n1_calculation()
    for i = 0,1 do
        if simDR_N2[i] <= 20 then
            B777DR_N1[i] = 0
        elseif simDR_N2[i] > 20 and simDR_N2[i] <= 26 then
            B777DR_N1[i] = -1 * (math.sqrt(math.max(25-simDR_N2[i], 0)))/1.225 + 2
        elseif simDR_N2[i] > 26 and simDR_N2[i] <= 30 then
            B777DR_N1[i] = 0.866 * math.sqrt(math.max(simDR_N2[i]-26, 0)) + 2
        elseif simDR_N2[i] > 30 and simDR_N2[i] <= 72 then
            B777DR_N1[i] = ((simDR_N2[i])^2)/241.12
        elseif simDR_N2[i] > 72 then
            B777DR_N1[i] = simDR_N1[i]
        end
    end
end

function aircraft_load()
    simDR_egt_override = 1
end

function flight_start()
    B777_egt = {0,0}

end

function before_physics()


end


function after_physics()

    B777_synoptic()
    B777_egt_calculation()
    B777_n1_calculation()
end
