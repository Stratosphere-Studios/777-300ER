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

-- Bleed Air

B777DR_bleed_valves = deferred_dataref("Strato/777/air/bleed_valves", "array[3]") -- eng 1, 2, apu
B777DR_isolation_valves = deferred_dataref("Strato/777/air/isolation_valves", "array[3]") -- L, C, R
B777DR_trim_air_valves = deferred_dataref("Strato/777/air/trim_air_valves", "array[3]") -- L, R, cockpit?
B777DR_pack_valves = deferred_dataref("Strato/777/air/pack_valves", "array[2]") -- L, R
B777DR_engine_anti_ice_valves = deferred_dataref("Strato/777/air/engine_anti_ice_valves", "array[2]") -- L, R; Is this necessary?
B777DR_wing_anti_ice_valves = deferred_dataref("Strato/777/air/wing_anti_ice_valves", "array[2]") -- L, R; is this necessary?

B777CMD_engL_vlv = deferred_command("Strato/777/air/eng_bleed_L", "Left Engine Bleed Valve")
B777CMD_engR_vlv = deferred_command("Strato/777/air/eng_bleed_R", "Right Engine Bleed Valve")
B777CMD_apu_vlv = deferred_command("Strato/777/air/apu_bleed", "APU Bleed Valve")

-- hyd pumps

B777DR_duct_press = deferred_dataref("Strato/777/air/duct_press", "array[2]") -- L, R

-- Air Conditioning

B777DR_zone_temps_target = deferred_dataref("Strato/777/air/zone_temps_target", "array[10]") -- cockpit, 6 zones, aft and bulkhead
B777DR_zone_temps_actual = deferred_dataref("Strato/777/air/zone_temps_actual", "array[10]")  -- cockpit, 6 zones, aft and bulkhead
B777DR_cockpit_trim_air = deferred_dataref("Strato/777/air/cdaockpit_trim_air", "number")
B777DR_pack_valve = deferred_dataref("Strato/777/air/pack_valve", "array[2]") -- L, R

-- Pressurization

B777DR_outflow_valve_pos = deferred_dataref("Strato/777/air/outflow_valve_pos", "array[2]") -- foreward, aft
B777DR_landing_alt_val = deferred_dataref("Strato/777/air/landing_alt_val", "number")
B777DR_landing_alt_man = deferred_dataref("Strato/777/air/landing_alt_man", "number") -- 0 = auto, 1 = manual
-- switch will be command, go up to 500 after certain duration

B777DR_outflow_valve_auto = deferred_dataref("Strato/777/air/ouyflow_valve_auto", "array[2]")
B777CMD_outflow_valve_open_fwd = deferred_command("Strato/777/air/outflow_fwd_open", "Forward Outflow Valve Open (Manual Mode)", outflow_fwd_open_CMDhandler)
B777CMD_outflow_valve_close_fwd = deferred_command("Strato/777/air/outflow_fwd_close", "Forward Outflow Valve Close (Manual Mode)", outflow_fwd_close_CMDhandler)
B777CMD_outflow_valve_open_aft = deferred_command("Strato/777/air/outflow_aft_open", "Aft Outflow Valve Open (Manual Mode)", outflow_aft_open_CMDhandler)
B777CMD_outflow_valve_close_aft = deferred_command("Strato/777/air/outflow_aft_close", "Aft Outflow Valve Close (Manual Mode)", outflow_aft_close_CMDhandler)
B777CMD_outflow_toggle = deferred_command("Strato/777/air/outflow_valve_sw")

-- how will i do temp control switches?
    -- command up/down only, rest from CODE
    -- mode 1, cmds will go up/down in auto
    -- mode 2, cmds will move to either extreme in manual
    -- put another manip in the middle and switch mode by clicking switch.


airSystemClass = {
    producers = {}, -- unnecessary?
    consumers = {},
    pressure = 0,
    setProducer = function(name, state)
        self.producers[name].state = state
    end,
    setConsumer = function(name, state)
        self.consumers[name].state = state
    end
}


producers = {
    engine1 = {0, 40}, -- depends on throttle, up to 60 or 70
    engine2 = {0, 60},
    apu = {0, 25} -- boosts for engine start
}

local consumers = {
    packL = {
        consumption = 6,
        state = 0,
        switch_state = 0;
        sourceListener = function(src) end,
        switchListener = function() end
    },
    packR = {
        consumption = 6,
        state = 0,
        switch_state = 0;
        sourceListener = function(src) end,
        switchListener = function() end
    },
    trimL = {
        consumption = 1,
        state = 0,
        switch_state = 0;
        sourceListener = function(src) end,
        switchListener = function() end
    },
    trimR= {
        consumption = 1,
        state = 0,
        switch_state = 0;
        sourceListener = function(src) end,
        switchListener = function() end
    },
    waiL = {
        consumption = 3,
        state = 0,
        switch_state = 0;
        sourceListener = function(src) end,
        switchListener = function() end
    },
    waiR = {
        consumption = 3,
        state = 0,
        switch_state = 0;
        sourceListener = function(src) end,
        switchListener = function() end
    },
    eng1Starter = {
        consumption = 7,
        state = 0,
        switch_state = 0;
        sourceListener = function(src) end,
        switchListener = function() end
    }, -- not sure, engines seem to boost 
    eng2Starter = {
        consumption = 11,
        state = 0,
        switch_state = 0;
        sourceListener = function(src) end,
        switchListener = function() end
    },
    apuStarter = {
        consumption = 6,
        state = 0,
        switch_state = 0;
        sourceListener = function(src) end,
        switchListener = function() end
    },
    demandPumpL = {
        consumption = 4,
        state = 0,
        switch_state = 0;
        sourceListener = function(src) end,
        switchListener = function() end
    },
    demandPumpR = {
        consumption = 4,
        state = 0,
        switch_state = 0;
        sourceListener = function(src) end,
        switchListener = function() end
    }
}

-- no need for producer table?

-- with no load or source, pressure drops 10 psi in 25 sec
-- pressure doesn't average, just spreads?????

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

--function after_physics()

--function after_replay()

--[[ rough idea:
have tables of all connected devices

isolation switches move devices to new tables


]]



-- maybe there is a better way, if i only have the sys 1 2 3 4 and iso valve drs, then 