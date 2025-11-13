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

dofile("../../../libs/utils.lua")

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

--Bleed Air (General)
B777DR_bleed_valves_status = deferred_dataref("Strato/777/air/bleed_valves_status", "array[3]") -- eng 1, 2, apu
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


local producers = {
    engine1 = {switchState = 0, state = 1, prod = 40}, -- depends on throttle, up to 60 or 70
    engine2 = {switchState = 0, state = 1, prod = 60},
    apu = {switchState = 0, state = 0, prod = 25} -- boosts for engine start
}

B777CMD_btn_engL = deferred_command("Strato/777/air/eng_L_sw", "Left Engine Bleed Switch", B777_engL_bleed_cmdHandler)
B777CMD_btn_apu = deferred_command("Strato/777/air/apu_sw", "APU Bleed Switch", B777_apu_bleed_cmdHandler)
B777CMD_btn_engR = deferred_command("Strato/777/air/eng_R_sw", "Right Engine Bleed Switch", B777_engR_bleed_cmdHandler)
B777DR_bleed_valves_sw_pos = deferred_dataref("Strato/777/air/bleed_valves_sw_pos", "array[3]") -- L, C, R

function B777_engL_bleed_cmdHandler(phase, duration)
    if phase == 0 then
        
    end
end
B777DR_air_hyd_pump_state = find_dataref("Strato/777/hydraulics/pump/primary/actual")

-- B777DR_landing_alt_man = deferred_dataref("Strato/777/air/landing_alt_man", "number") -- 0 = auto, 1 = manual -- switch will be command, go up to 500 after certain duration
-- B777DR_outflow_valve_auto_sw = deferred_dataref("Strato/777/air/outflow_valve_auto", "array[2]")
-- B777CMD_outflow_valve_open_fwd = deferred_command("Strato/777/air/outflow_fwd_open", "Forward Outflow Valve Open (Manual Mode)", outflow_fwd_open_CMDhandler)
-- B777CMD_outflow_valve_close_fwd = deferred_command("Strato/777/air/outflow_fwd_close", "Forward Outflow Valve Close (Manual Mode)", outflow_fwd_close_CMDhandler)
-- B777CMD_outflow_valve_open_aft = deferred_command("Strato/777/air/outflow_aft_open", "Aft Outflow Valve Open (Manual Mode)", outflow_aft_open_CMDhandler)
-- B777CMD_outflow_valve_close_aft = deferred_command("Strato/777/air/outflow_aft_close", "Aft Outflow Valve Close (Manual Mode)", outflow_aft_close_CMDhandler)
-- B777CMD_landing_alt_up = deferred_command("Strato/777/air/landing_alt_up", "Landing Altitude Up")
-- B777CMD_landing_alt_dn = deferred_command("Strato/777/air/landing_alt_dn", "Landing Altitude Down")



local iso_sw_status = {0, 0, 0}

B777DR_iso_valves_sw_pos = deferred_dataref("Strato/777/air/isolation_valves_sw_pos", "array[3]") -- L, C, R
DR_iso_vlv_stat = deferred_dataref("Strato/777/air/isolation_valves_status", "array[3]") -- L, C, R

function B777_isoL_cmdHandler(phase, duration)
    if phase == 0 then
        iso_sw_status[1] = 1 - iso_sw_status[1]
        run_after_time(function() DR_iso_vlv_stat[0] = DR_iso_vlv_stat[0] >= 1 and 0 or 1; announceSourceUpdate() end, 2)
    end
end

function B777_isoC_cmdHandler(phase, duration)
    if phase == 0 then
        iso_sw_status[2] = 1 - iso_sw_status[2]
        run_after_time(function() DR_iso_vlv_stat[1] = DR_iso_vlv_stat[1] >= 1 and 0 or 1; announceSourceUpdate() end, 2)
    end
end

function B777_isoR_cmdHandler(phase, duration)
    if phase == 0 then
        iso_sw_status[3] = 1 - iso_sw_status[3]
        run_after_time(function() DR_iso_vlv_stat[2] = DR_iso_vlv_stat[2] >= 1 and 0 or 1; announceSourceUpdate() end, 2)
    end
end

-- how will i do temp control switches?
    -- command up/down only, rest from CODE
    -- mode 1, cmds will go up/down in auto
    -- mode 2, cmds will move to either extreme in manual
    -- put another manip in the middle and switch mode by clicking switch.

----- consumer class-----

--NOTE: If consumption changes in real time, will need to add a "running" var and update actConsumption in flight loop

function rightSourceListener(self)
    if self.valveState == 1 and -- do i want air?
    (producers.engine2.state == 1 -- right engine
    or (producers.apu.state == 1 and DR_iso_vlv_stat[1] == 1 and DR_iso_vlv_stat[2] == 1) -- apu and left iso
    or (producers.engine1.state == 1 and DR_iso_vlv_stat[0] == 1 and DR_iso_vlv_stat[1] == 1 and DR_iso_vlv_stat[2] == 1)) then -- right engine and all isos
    -- replace the whole thing with just duct press?
        --run_after_time(function() self.actConsumption = self.consumption end, 1)
        self.flow = true
    else
        --run_after_time(function() self.actConsumption = 0 end, 1)
        self.flow = false
    end
end

function leftSourceListener(self)
    if self.valveState == 1 and -- do i want air?
    (producers.engine1.state == 1 -- left engine
    or (producers.apu.state == 1 and DR_iso_vlv_stat[0] == 1) -- apu and left iso
    or (producers.engine2.state == 1 and DR_iso_vlv_stat[0] == 1 and DR_iso_vlv_stat[1] == 1 and DR_iso_vlv_stat[2] == 1)) then -- right engine and all isos
    -- replace the whole thing with just duct press?
        --run_after_time(function() self.actConsumption = self.consumption end, 1)
        self.flow = true
    else
        --run_after_time(function() self.actConsumption = 0 end, 1)
        self.flow = false
    end
end

local Consumer = {
    consumption = 0, -- how much it should be taking (can change)
    actConsumption = 0, -- how much it's actually taking. should follow consumption var unless it's off
    flow = false,
    switchState = 0,
    valveState = 0, -- 0 = closed, 1 = open
    openDelay = 0,
    closeDelay = 0,
    switchListener = function(self, phase)
        if phase == 0 then
            if self.switchState == 0 then
                self.switchState = 1
            else
                self.switchState = 0
                run_after_time(function()
                    self.valveState = 0
                    self:sourceListener()
                    end,
                self.closeDelay)
            end
        end
    end,
    sourceListener = function() end, -- this is whether there is actual flow.
    autoManager = function() end -- this opens/closes valves when in auto mode
}
function Consumer:new(cons, opendelay, closedelay, sourcelistener, automanager)
    local t = {consumption = cons, openDelay = opendelay, closeDelay = closedelay, sourceListener = sourcelistener, autoManager = automanager}
    setmetatable(t, self)
    self.__index = self
    return t
end

local packL = Consumer:new(6, 5, 45, leftSourceListener,
function(self)
    if self.switchState == 1 and self.valveState == 0 then
        run_after_time(function() self.valveState = 1; self:sourceListener() end, self.openDelay)
    end
end)

local packR = Consumer:new(6, 5, 45, rightSourceListener,
function(self)
    if self.switchState == 1 and self.valveState == 0 then
        run_after_time(function() self.valveState = 1; self:sourceListener() end, self.openDelay)
    end
end)

local trimL = Consumer:new(1, 3, 2, leftSourceListener,
function (self)
    if self.switchState == 1 then
        if self.valveState == 0 and packL.valveState == 1 then
            run_after_time(function() self.valveState = 1; self:sourceListener() end, self.openDelay)
        elseif self.valveState == 1 and packL.valveState == 0 then
            run_after_time(function() self.valveState = 0; self:sourceListener() end, self.closeDelay)
        end
    end
end)

local trimR = Consumer:new(1, 3, 2, rightSourceListener,
function (self)
    if self.switchState == 1 then
        if self.valveState == 0 and packR.valveState == 1 then
            run_after_time(function() self.valveState = 1; self:sourceListener() end, self.openDelay)
        elseif self.valveState == 1 and packR.valveState == 0 then
            run_after_time(function() self.valveState = 0; self:sourceListener() end, self.closeDelay)
        end
    end
end)

local waiL = Consumer:new(3, 0, 0)
local waiR = Consumer:new(3, 0, 0)
local eng1Starter = Consumer:new(7, 3, 3)
local eng2Starter = Consumer:new(11, 3, 3)
local apuStarter = Consumer:new(3, 0, 0)
local demandPumpR = Consumer:new(4, 0, 0)
local demandPumpL = Consumer:new(4, 0, 0)

B777CMD_btn_isoL = deferred_command("Strato/777/air/isln_L_sw", "Left Isolation Valve Switch", B777_isoL_cmdHandler)
B777CMD_btn_isoC = deferred_command("Strato/777/air/isln_C_sw", "Center Isolation Valve Switch", B777_isoC_cmdHandler)
B777CMD_btn_isoR = deferred_command("Strato/777/air/isln_R_sw", "Right Isolation Valve Switch", B777_isoR_cmdHandler)

B777CMD_btn_packR = deferred_command("Strato/777/air/pack_R_sw", "Right Pack Valve Switch", function(p,d)packR:switchListener(p)end)
B777CMD_btn_packL = deferred_command("Strato/777/air/pack_L_sw", "Left Pack Valve Switch", function(p,d)packL:switchListener(p)end)
B777CMD_btn_trimL = deferred_command("Strato/777/air/trim_L_sw", "Left Trim Valve Switch", function(p,d)trimL:switchListener(p)end)
B777CMD_btn_trimR = deferred_command("Strato/777/air/trim_R_sw", "Right Trim Valve Switch", function(p,d)trimR:switchListener(p)end)

function updateConsumption()
    packL.consumption = packL.flow and packL.actConsumption or 0
    packR.consumption = packR.flow and packR.actConsumption or 0
    trimL.consumption = trimL.flow and trimL.actConsumption or 0
    trimR.consumption = trimR.flow and trimR.actConsumption or 0
end

function autoManager()
    packL:autoManager()
    packR:autoManager()
    trimL:autoManager()
    trimR:autoManager()
end

function announceSourceUpdate() -- called any time a producer or isolation valve is changed
    packL:sourceListener()
    packR:sourceListener()
    trimL:sourceListener()
    trimR:sourceListener()
    --[[waiL:sourceListener()
    waiR:sourceListener()
    eng1Starter:sourceListener()
    eng2Starter:sourceListener()
    apuStarter:sourceListener()
    demandPumpR:sourceListener()
    demandPumpL:sourceListener()]]
end

----- calculate duct pressure -----
function calcPressure()
    --TODO: with no load or source, pressure drops 10 psi in 25 sec
    -- pressure doesn't average, just spreads?????

    local available = {0, 0}
    local consumption = {0, 0}

    -- calculate total available
    if DR_iso_vlv_stat[0] == 1 and DR_iso_vlv_stat[2] == 1 and DR_iso_vlv_stat[1] == 1 then -- all open
        available[1] = producers.apu.prod + producers.engine1.prod + producers.engine2.prod -- total
        available[2] = available[1]
    else
        if DR_iso_vlv_stat[0] == 0 then -- left closed (between eng1 and apu)
            available[1] = producers.engine1.prod -- only engine
        else -- left open (eng1 not isolated from apu)
            available[1] = producers.engine1.prod + producers.apu.prod -- engine and apu
        end

        if DR_iso_vlv_stat[2] == 0 or DR_iso_vlv_stat[1] == 0 then -- center or right closed (between eng2 and apu)
            available[2] = producers.engine2.prod
        else -- eng2 not isolated from apu
            available[2] = producers.engine2.prod + producers.apu.prod
        end
    end

    -- calculate consumption
    consumption[1] = packL.actConsumption + trimL.actConsumption + waiL.actConsumption + eng1Starter.actConsumption -- l side
    consumption[2] = packR.actConsumption + trimR.actConsumption + waiR.actConsumption + eng2Starter.actConsumption -- r side
    if DR_iso_vlv_stat[0] == 1 and DR_iso_vlv_stat[2] == 0 then -- left valve open and right closed
        consumption[1] = consumption[1] + demandPumpL.actConsumption + apuStarter.actConsumption -- add left demand pump and apu starter to left side
        if DR_iso_vlv_stat[1] == 1 then -- if c valve open, also add right demand pump
            consumption[1] = consumption[1] + demandPumpR.actConsumption
        end
    end

    if DR_iso_vlv_stat[2] == 1 and DR_iso_vlv_stat[0] == 0 then -- right open and left closed
        consumption[2] = consumption[2] + demandPumpR.actConsumption -- add right demand pump to right side
        if DR_iso_vlv_stat[1] == 1 then -- if c also open, add left demand pump and apu starter
            consumption[2] = consumption[2] + demandPumpL.actConsumption + apuStarter.actConsumption
        end
    end

    if DR_iso_vlv_stat[2] == 1 and DR_iso_vlv_stat[0] == 1 and DR_iso_vlv_stat[1] == 1 then -- if everything open add everthing together
        consumption[1] = consumption[1] + consumption[2] + demandPumpL.actConsumption + apuStarter.actConsumption + demandPumpR.actConsumption
        consumption[2] = consumption[1]
    end

    return utils.lim(utils.round(available[1]-consumption[1]), 60, 0), utils.lim(utils.round(available[2]-consumption[2]), 60, 0)
end

function switchAnimations()
    B777DR_iso_valves_sw_pos[0] = utils.animate(iso_sw_status[1], B777DR_iso_valves_sw_pos[0], 10)
    B777DR_iso_valves_sw_pos[1] = utils.animate(iso_sw_status[2], B777DR_iso_valves_sw_pos[1], 10)
    B777DR_iso_valves_sw_pos[2] = utils.animate(iso_sw_status[3], B777DR_iso_valves_sw_pos[2], 10)
    B777DR_pack_trim_sw_pos[0] = utils.animate(packL.switchState, B777DR_pack_trim_sw_pos[0], 20)
    B777DR_pack_trim_sw_pos[1] = utils.animate(trimL.switchState, B777DR_pack_trim_sw_pos[1], 20)
    B777DR_pack_trim_sw_pos[2] = utils.animate( trimR.switchState, B777DR_pack_trim_sw_pos[2], 20)
    B777DR_pack_trim_sw_pos[3] = utils.animate(packR.switchState, B777DR_pack_trim_sw_pos[3], 20)
end


function setDisplayDRs()
    B777DR_trim_air_valves_status[0] = trimL.flow and 2 or trimL.valveState
    B777DR_trim_air_valves_status[1] = trimR.flow and 2 or trimR.valveState
    B777DR_pack_valves_status[0] = packL.flow and 2 or packL.valveState
    B777DR_pack_valves_status[1] = packR.flow and 2 or packR.valveState
end

--*************************************************************************************--
--**                                  EVENT CALLBACKS                                **--
--*************************************************************************************--

--function aircraft_load()

--function aircraft_unload()

function flight_start()
    --run_at_interval(autoManager, 1)
end

--function flight_crash()

--function livery_load()

--function before_physics()

function after_physics()
    B777DR_duct_press[0], B777DR_duct_press[1]  = calcPressure()

    autoManager()
    updateConsumption()
    switchAnimations()
    setDisplayDRs()
end

--function after_replay()