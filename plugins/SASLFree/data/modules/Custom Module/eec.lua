--[[
*****************************************************************************************
* Script Name: eec
* Author Name: discord/bruh4096#4512(Tim G.)
* Script Description: Code for, guess what, eec!
*****************************************************************************************
--]]

include("misc_tools.lua")

--Getting handles to sim datarefs

--Engines
engn_1_throttle_act = globalProperty("sim/flightmodel/engine/ENGN_thro_use[0]")
engn_2_throttle_act = globalProperty("sim/flightmodel/engine/ENGN_thro_use[1]")
engn_1_throttle = globalProperty("sim/flightmodel/engine/ENGN_thro[0]")
engn_2_throttle = globalProperty("sim/flightmodel/engine/ENGN_thro[1]")
L_reverser_deployed = globalPropertyiae("sim/cockpit2/annunciators/reverser_on", 1)
R_reverser_deployed = globalPropertyiae("sim/cockpit2/annunciators/reverser_on", 2)
engn_n1 = globalPropertyfa("sim/flightmodel/engine/ENGN_N1_")
engn_n2 = globalPropertyfa("sim/flightmodel/engine/ENGN_N2_")
--Flight controls
flaps = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 1)
--Operation
f_time = globalPropertyf("sim/operation/misc/frame_rate_period")
on_ground = globalPropertyi("sim/flightmodel/failures/onground_any")

--Own datarefs
--Hydraulics
demand_c1 = globalProperty("Strato/777/hydraulics/pump/demand/state[0]")
demand_c2 = globalProperty("Strato/777/hydraulics/pump/demand/state[1]")

n1_errtotal_eng1 = 0
n1_errlast_eng1 = 0

function update()
    local idle = 0
    if get(on_ground) == 0 and Round(get(flaps), 2) >= 25 or (Round(get(flaps), 2) > 0 and get(demand_c1) * get(demand_c2) == 0) then
        idle = 0.1
    end
    local tgt_engn_1 = idle + get(engn_1_throttle) * (1 - idle - 0.55 * get(L_reverser_deployed))
    local tgt_engn_2 = idle + get(engn_2_throttle) * (1 - idle - 0.55 * get(R_reverser_deployed))
    set(engn_1_throttle_act, get(engn_1_throttle_act) + (tgt_engn_1 - get(engn_1_throttle_act)) * get(f_time) * 0.4)
    set(engn_2_throttle_act, get(engn_2_throttle_act) + (tgt_engn_2 - get(engn_2_throttle_act)) * get(f_time) * 0.4)
end