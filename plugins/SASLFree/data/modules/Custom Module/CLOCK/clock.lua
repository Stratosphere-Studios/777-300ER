--[[
*****************************************************************************************
* Script Name: fuel
* Author Name: nathroxer
* Script Description: Fuel logic
*****************************************************************************************
--]]

---fuel system

defineProperty("Tank_L", globalPropertyf("sim/flightmodel/weight/m_fuel1"))
defineProperty("Tank_CTR", globalPropertyf("sim/flightmodel/weight/m_fuel2"))
defineProperty("Tank_R", globalPropertyf("sim/flightmodel/weight/m_fuel3"))

Crossfeed_1 = createGlobalPropertyf("Crossfeed_1", 0)
Crossfeed_2 = createGlobalPropertyf("Crossfeed_2", 0)

function Updatecrossfeed()
if get(Crossfeed_2) == 1 or get(Crossfeed_1) == 1 then
    get(Tank_L)
    if get(Tank_L) > get(Tank_R) then
    set(Tank_L) = (get(Tank_L)) + 0.5
    Tank_R = Tank_R - 0.5
    elseif Tank_L < Tank_R then
    Tank_L = Tank_L - 0.5
    Tank_R = Tank_R + 0.5
    end
end
end


function update()
    Updatecrossfeed()
end