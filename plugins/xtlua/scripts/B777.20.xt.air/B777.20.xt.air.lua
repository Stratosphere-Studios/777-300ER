--[[
*****************************************************************************************
* Script Name: Air
* Author Name: remenkemi 
* Script Description: Pneumatic and pressurization-related systems
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

dofile("utils.lua")

--*************************************************************************************--
--**                             XTLUA GLOBAL VARIABLES                              **--
--*************************************************************************************--

--[[
SIM_PERIOD - this contains the duration of the current frame in seconds (so it is alway a
fraction).  Use this to normalize rates,  e.g. to add 3 units of fuel per second in a
per-frame callback you’d do fuel = fuel + 3 * SIM_PERIOD.

IN_REPLAY - evaluates to 0 if replay is off, 1 if replay mode is on
--]]

--*************************************************************************************--
--**                                CREATE VARIABLES                                 **--
--*************************************************************************************--



--*************************************************************************************--
--**                             FIND X-PLANE DATAREFS                               **--
--*************************************************************************************--



--*************************************************************************************--
--**                              FIND CUSTOM DATAREFS                               **--
--*************************************************************************************--



--*************************************************************************************--
--**                             CUSTOM DATAREF HANDLERS                             **--
--*************************************************************************************--



--*************************************************************************************--
--**                              CREATE CUSTOM DATAREFS                             **--
--*************************************************************************************--



--*************************************************************************************--
--**                             X-PLANE COMMAND HANDLERS                            **--
--*************************************************************************************--



--*************************************************************************************--
--**                             REPLACE X-PLANE COMMANDS                            **--
--*************************************************************************************--



--*************************************************************************************--
--**                             CUSTOM COMMAND HANDLERS                             **--
--*************************************************************************************--



--*************************************************************************************--
--**                             CREATE CUSTOM COMMANDS                               **--
--*************************************************************************************--



--*************************************************************************************--
--**                                      CODE                                       **--
--*************************************************************************************--

-- Bleed Air (General)
B777DR_bleed_valves_status = deferred_dataref("Strato/777/air/bleed_valves_status", "array[3]") -- eng 1, 2, apu
B777DR_isolation_valves_status = deferred_dataref("Strato/777/air/isolation_valves_status", "array[3]") -- L, C, R
-- ^ these are for the synopticm 1 for open and 2 for flow. off vs auto will just be vars (switch pos animated off of)

--hyd

--B777DR_synoptic_flow = deferred_dataref("Strato/777/air/synoptic_flow", "number[21]")
--B777DR_synoptic_open = deferred_dataref("Strato/777/air/synoptic_open", "number[12]")


-- Anti Ice
B777DR_engine_anti_ice_valves_status = deferred_dataref("Strato/777/air/engine_anti_ice_valves_status", "array[2]") -- L, R; Is this necessary?
B777DR_wing_anti_ice_valves_status = deferred_dataref("Strato/777/air/wing_anti_ice_valves_status", "array[2]") -- L, R; is this necessary?

-- Hydraulic Pumps
B777DR_duct_press = deferred_dataref("Strato/777/air/duct_press", "array[2]") -- L, R

-- Starters
B777DR_starter_valve_status = deferred_dataref("Strato/777/air/starter_valve_status", "array[3]") -- L, R, APU

-- Air Conditioning
B777DR_zone_temps_status = deferred_dataref("Strato/777/air/zone_temps_status", "array[9]")  -- cockpit, 6 zones, aft, bulkhead, fwd
B777DR_trim_air_valves_status = deferred_dataref("Strato/777/air/trim_air_valves_status", "array[3]") -- L, R, cockpit?
B777DR_pack_valves_status = deferred_dataref("Strato/777/air/pack_valves_status", "array[2]") -- L, R
B777DR_equip_cooling_status = deferred_dataref("Strato/777/air/equip_cooling_status", "number") -- not sure if necessary, maybe just switch needed
B777DR_recirc_fan_status = deferred_dataref("Strato/777/air/recirc_fan_status", "number") -- not sure if necessary, maybe just switch needed

B777DR_zone_temps_target = deferred_dataref("Strato/777/air/zone_temps_target", "array[10]") -- cockpit, 6 zones, aft, bulkhead, fwd, master

-- Pressurization
B777DR_outflow_valve_pos_status = deferred_dataref("Strato/777/air/outflow_valve_pos_status", "array[2]") -- foreward, aft
B777DR_landing_alt_val = deferred_dataref("Strato/777/air/landing_alt_val", "number")


B777DR_pack_trim_sw_pos = deferred_dataref("Strato/777/air/pack_trim_sw_pos", "array[4]")


-- how will i do temp control switches?
    -- command up/down only, rest from CODE
    -- mode 1, cmds will go up/down in auto
    -- mode 2, cmds will move to either extreme in manual
    -- put another manip in the middle and switch mode by clicking switch.


local producers = {
    engine1 = {switchState = 0, state = 0, prod = 40}, -- depends on throttle, up to 60 or 70
    engine2 = {switchState = 0, state = 0, prod = 60},
    apu = {switchState = 0, state = 0, prod = 25} -- boosts for engine start
}

B777DR_air_hyd_pump_state = find_dataref("Strato/777/hydraulics/pump/primary/actual")

-- B777DR_landing_alt_man = deferred_dataref("Strato/777/air/landing_alt_man", "number") -- 0 = auto, 1 = manual -- switch will be command, go up to 500 after certain duration
-- B777DR_outflow_valve_auto_sw = deferred_dataref("Strato/777/air/outflow_valve_auto", "array[2]")
-- B777CMD_outflow_valve_open_fwd = deferred_command("Strato/777/air/outflow_fwd_open", "Forward Outflow Valve Open (Manual Mode)", outflow_fwd_open_CMDhandler)
-- B777CMD_outflow_valve_close_fwd = deferred_command("Strato/777/air/outflow_fwd_close", "Forward Outflow Valve Close (Manual Mode)", outflow_fwd_close_CMDhandler)
-- B777CMD_outflow_valve_open_aft = deferred_command("Strato/777/air/outflow_aft_open", "Aft Outflow Valve Open (Manual Mode)", outflow_aft_open_CMDhandler)
-- B777CMD_outflow_valve_close_aft = deferred_command("Strato/777/air/outflow_aft_close", "Aft Outflow Valve Close (Manual Mode)", outflow_aft_close_CMDhandler)
-- B777CMD_landing_alt_up = deferred_command("Strato/777/air/landing_alt_up", "Landing Altitude Up")
-- B777CMD_landing_alt_dn = deferred_command("Strato/777/air/landing_alt_dn", "Landing Altitude Down")


-- B777CMD_btn_isoL = deferred_command("Strato/777/air/isln_L_sw", "Left Isolation Valve Switch")
-- B777CMD_btn_isoC = deferred_command("Strato/777/air/isln_C_sw", "Center Isolation Valve Switch")
-- B777CMD_btn_isoR = deferred_command("Strato/777/air/isln_R_sw", "Right Isolation Valve Switch")
-- B777CMD_btn_engL = deferred_command("Strato/777/air/eng_L_sw", "Left Engine Bleed Switch")
-- B777CMD_btn_apu = deferred_command("Strato/777/air/apu_sw", "APU Bleed Switch")
-- B777CMD_btn_engR = deferred_command("Strato/777/air/eng_R_sw", "Right Engine Bleed Switch")


-- change button state
-- set animation drops
-- trigger events to happen afte run_after_time

-- CMD!

-- how?

--[[
1. call method inside each object
2. method toggles switch state, which is animated in flight loop
3. method calls another func after time, which decides what to do now


use real objs btw

]]

-- ik this code is messy, i'm using it to learn lua oop

function announceSourceUpdate()
    packL:sourceListener()
    packR:sourceListener()
    trimL:sourceListener()
    trimR:sourceListener()
    waiL:sourceListener()
    waiR:sourceListener()
    eng1Starter:sourceListener()
    eng2Starter:sourceListener()
    apuStarter:sourceListener()
    demandPumpR:sourceListener()
    demandPumpL:sourceListener()
end

-- consumer class
local Consumer = {
    consumption = 6,
    state = 0,
    switchState = 0,
    switchListener = function(self, phase)
        if phase == 0 then
            self.state = self.state == 0 and 1 or 0
            self.switchState = 1 - self.switchState
            announceSourceUpdate()
            --run_after_time(switchAction, 1)
        end
    end,
    sourceBoolExp = false, -- when instantiated, a boolean expression will be passed that will determine whether the device has air
    sourceListener = function(self, sourceBoolExp)
        if self.state == 1 and sourceBoolExp then
            self.state = 2
        elseif self.state == 2 and not sourceBoolExp then
            self.state = 1
        end
    end
}

function Consumer:new(cons, swAction, sources)
    local t = {consumption = cons, switchAction = swAction, sourceBoolExp = sources}
    setmetatable(t, self)
    self.__index = self
    return t
end

local packL = Consumer:new(6, function(self) print("sigma") end)
local packR = Consumer:new(6, function(self) print("sigma") end)
local trimL = Consumer:new(1, function(self) print("sigma") end)
local trimR = Consumer:new(1, function(self) print("sigma") end)
local waiL = Consumer:new(3, function(self) print("sigma") end)
local waiR = Consumer:new(3, function(self) print("sigma") end)
local eng1Starter = Consumer:new(7, function(self) print("sigma") end)
local eng2Starter = Consumer:new(11, function(self) print("sigma") end)
local apuStarter = Consumer:new(3, function(self) print("sigma") end)
local demandPumpR = Consumer:new(4, function(self) print("sigma") end)
local demandPumpL = Consumer:new(4, function(self) print("sigma") end)

--[[
local consumerList = { -- this is for notifying all consumers. maybe there is a way I can make a static method that does this or something idk
    packL = packL,
    packR = packR,
    trimL = trimL,
    trimR = trimR,
    waiL = waiL,
    waiR = waiR,
    eng1Starter = eng1Starter,
    eng2Starter = eng2Starter,
    apuStarter = apuStarter,
    demandPumpR = demandPumpR,
    demandPumpL = demandPumpL
}]]

local isoL = 0
local isoR = 0
local isoC = 0

B777CMD_btn_packL = deferred_command("Strato/777/air/pack_L_sw", "Left Pack Valve Switch", function(p,d)packL:switchListener(p)end)
B777CMD_btn_packR = deferred_command("Strato/777/air/pack_R_sw", "Right Pack Valve Switch", function(p,d)packR:switchListener(p)end)
B777CMD_btn_trimL = deferred_command("Strato/777/air/trim_L_sw", "Left Trim Valve Switch", function(p,d)trimL:switchListener(p)end)
B777CMD_btn_trimR = deferred_command("Strato/777/air/trim_R_sw", "Right Trim Valve Switch", function(p,d)trimR:switchListener(p)end)

function calcPressure()
    --TODO: with no load or source, pressure drops 10 psi in 25 sec
    -- pressure doesn't average, just spreads?????

    local available = {0, 0}
    local consumption = {0, 0}

    -- calculate total available
    if isoL == 1 and isoR == 1 and isoC == 1 then -- all open
        available[1] = producers.apu.prod + producers.engine1.prod + producers.engine2.prod -- total
        available[2] = available[1]
    else
        if isoL == 0 then -- left closed (between eng1 and apu)
            available[1] = producers.engine1.prod -- only engine
        else -- left open (eng1 not isolated from apu)
            available[1] = producers.engine1.prod + producers.apu.prod -- engine and apu
        end

        if isoR == 0 or isoC == 0 then -- center or right closed (between eng2 and apu)
            available[2] = producers.engine2.prod
        else -- eng2 not isolated from apu
            available[2] = producers.engine2.prod + producers.apu.prod
        end
    end

    -- calculate consumption
    consumption[1] = packL.consumption + trimL.consumption + waiL.consumption + eng1Starter.consumption
    consumption[2] = packR.consumption + trimR.consumption + waiR.consumption + eng2Starter.consumption
    if isoL == 1 and isoR == 0 then
        consumption[1] = consumption[1] + demandPumpL.consumption + apuStarter.consumption
        if isoC == 1 then
            consumption[1] = consumption[1] + demandPumpR.consumption
        end
    end

    if isoR == 1 and isoL == 0 then
        consumption[2] = consumption[1] + demandPumpR.consumption
        if isoC == 1 then
            consumption[2] = consumption[2] + demandPumpL.consumption + apuStarter.consumption
        end
    end

    if isoR == 1 and isoL == 1 and isoC == 1 then
        consumption[1] = consumption[1] + consumption[2] + demandPumpL.consumption + apuStarter.consumption + demandPumpR.consumption
        consumption[2] = consumption[1]
    end

    return {math.max(utils.round(available[1]-consumption[1]), 0), math.max(utils.round(available[2]-consumption[2]), 0)}
end


function openIsoValve(valve) end
function closeIsoValve(valve) end

   --[[ function isoValves()
        if valve == "L" then
            if leftSys.pressure < ctr
            leftSys.pressure == ;
        elseif valve == "c" then]]
        
    
            
--*************************************************************************************--
--**                                  EVENT CALLBACKS                                **--
--*************************************************************************************--

--function aircraft_load()

--function aircraft_unload()

--function flight_start()

--function flight_crash()

--function livery_load()

--function before_physics()

function after_physics()
    -- print("after physics pog")
    local press = calcPressure()
    -- print("press: {"..press[1]..", "..press[2].."}")
    B777DR_duct_press[0] = press[1]
    B777DR_duct_press[1] = press[2]

    B777DR_pack_trim_sw_pos[0] = utils.animate(packL.switchState, B777DR_pack_trim_sw_pos[0], 20)
    B777DR_pack_trim_sw_pos[1] = utils.animate(packR.switchState, B777DR_pack_trim_sw_pos[1], 20)
    B777DR_pack_trim_sw_pos[2] = utils.animate(trimL.switchState, B777DR_pack_trim_sw_pos[2], 20)
    B777DR_pack_trim_sw_pos[3] = utils.animate(trimR.switchState, B777DR_pack_trim_sw_pos[3], 20)
end

--function after_replay()

--[[ rough idea:
have tables of all connected devices

isolation switches move devices to new tables


]]



-- maybe there is a better way, if i only have the sys 1 2 3 4 and iso valve drs, then 