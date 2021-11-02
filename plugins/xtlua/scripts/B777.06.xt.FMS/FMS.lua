--[[
*****************************************************************************************
* Script Name: Electrical
* Author Name: @nathroxer001
* Script Description: Code for fms
*****************************************************************************************
--]]

function aircraft_load()
    print("fltInstruments loaded")
  end

simDR_battery = find_dataref("sim/flightmodel2/electrical/battery")
if simDR_battery == 1 then
    simDR_flaps = find_dataref("sim/flightmodel2/wing/flap1_deg")
    simDR_flaps = 30
end