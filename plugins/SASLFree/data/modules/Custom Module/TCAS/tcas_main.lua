--[[
*****************************************************************************************
* Script Name: tcas_main
* Author Name: @bruh
* Script Description: Main code for the TCAS system
*****************************************************************************************
--]]

addSearchPath(moduleDirectory .. "/Custom Module/")

include("misc_tools.lua")
include("constants.lua")

--Find sim datarefs

sim_ra_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")
sim_ra_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_copilot")

--Find own datarefs

time_elapsed_sec = globalPropertyf("Strato/777/time/current")

--Create our own datarefs

tcas_mode_switch = createGlobalPropertyi("Strato/777/cockpit/switches/tcas_mode", 0)
tcas_test_switch = createGlobalPropertyi("Strato/777/cockpit/switches/tcas_test", 0)
tcas_mode_actual = createGlobalPropertyi("Strato/777/TCAS/mode", 0)

tcas_mode = 0
tcas_mode_past = 0
mode_time = 0
mode_set_delay = 1.5

tcas_sw_modes = {
    [TCAS_SW_STDBY] = TCAS_OFF,
    [TCAS_SW_ALT_OFF] = TCAS_OFF,
    [TCAS_SW_ALT_ON] = TCAS_OFF,
    [TCAS_SW_TA_ONLY] = TCAS_TA_ONLY,
}

function UpdateMode(mode_table)
    local curr_ra_alt_ft = round((get(sim_ra_pilot) + get(sim_ra_copilot)) / 2)
    local mode_out = 0
    if get(tcas_test_switch) == 0 then
        if get(tcas_mode_switch) == TCAS_SW_TA_RA then
            if curr_ra_alt_ft <= 1000 then
                mode_out = TCAS_TA_ONLY
            elseif curr_ra_alt_ft > 1000 then
                mode_out = TCAS_TA_RA
            end
        else
            mode_out = mode_table[get(tcas_mode_switch)]
        end
    else
        mode_out = TCAS_TEST
    end
    return mode_out
end

function update()
    tcas_mode = UpdateMode(tcas_sw_modes)
    if tcas_mode_past ~= tcas_mode then
        mode_time = get(time_elapsed_sec)
        tcas_mode_past = tcas_mode
    end
    if get(time_elapsed_sec) >= mode_time + mode_set_delay then
        set(tcas_mode_actual, tcas_mode)
    end
end
