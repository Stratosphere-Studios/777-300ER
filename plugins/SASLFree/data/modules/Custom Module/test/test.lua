defineProperty("airspeed",globalPropertyf("sim/flightmodel/position/indicated_airspeed"))
defineProperty("flaps",globalPropertyf("sim/flightmodel2/wing/flap1_deg",0))

function update()
    if get(airspeed) < 160 then 
    set(flaps, 30)
    logInfo("flaps set")
    end
end