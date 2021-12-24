--[[
*****************************************************************************************
* Script Name: misc
* Author Name: Crazytimtimtim
* Script Description: Misc system code for systems that don't have enough for their own module.
*****************************************************************************************
-- CLOSE HERE!

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
-- CLOSE HERE!

--*************************************************************************************--
--**                                CREATE VARIABLES                                 **--
--*************************************************************************************--

local B777_avg_gear_pos = 1
local B777_eagle_claw_sync = 1

--*************************************************************************************--
--**                              FIND X-PLANE DATAREFS                              **--
--*************************************************************************************--

simDR_ldg_gear_pos                        = find_dataref("sim/aircraft/parts/acf_gear_deploy")
simDR_eag_claw_pos                        = find_dataref("sim/flightmodel2/gear/eagle_claw_angle_deg")

--*************************************************************************************--
--**                             CUSTOM DATAREF HANDLERS                             **--
--*************************************************************************************--



--*************************************************************************************--
--**                              CREATE CUSTOM DATAREFS                             **--
--*************************************************************************************--

B777DR_custom_eagle_claw                = deferred_dataref("Strato/777/custom_eagle_claw", "number")

--*************************************************************************************--
--**                             X-PLANE COMMAND HANDLERS                            **--
--*************************************************************************************--



--*************************************************************************************--
--**                                 X-PLANE COMMANDS                                **--
--*************************************************************************************--

simCMD_ldg_gear_up                      = find_command("sim/flight_controls/landing_gear_up")
simCMD_ldg_gear_down                    = find_command("sim/flight_controls/landing_gear_down")

--*************************************************************************************--
--**                             CUSTOM COMMAND HANDLERS                             **--
--*************************************************************************************--

function simCMD_ldg_gear_toggle(phase, duration)   -- runs when landing gear toggled

   if B777_avg_gear_pos > 0.9 then  `              -- if gear down
      B777_eagle_claw_sync = 0                     -- desyncronise custom and default eagle claw datarefs
      B777DR_custom_eagle_claw = 0 -- animate down -- return custom eagle claw to neutral
      run_after_time(gearUp, eagClawTime)          -- gear up once eagle claw neutral

   elseif B777_avg_gear_pos <0.1 then              -- if gear down
      simCMD_ldg_gear_down:once()                  -- bring gear down
      run_after_time(eagClawUp, 20)                -- put custom eagle claw in te "pointing up" position once gear down
   end

end

function gearUp()
   simCMD_ldg_gear_up:once()
end

function eagClawSync()
   B777_eagle_claw_sync = 1
end

function eagClawUp()
   B777DR_custom_eagle_claw = 19 -- animate up  -- bring custom eagle claw to pointing up position
   run_after_time(eagClawSync, eagClawUpTime)   -- synchronise custom eagle claw and default
end

--*************************************************************************************--
--**                             CREATE CUSTOM COMMANDS                               **--
--*************************************************************************************--

simCMD_ldg_gear_toggle                    = replace_command("sim/flight_controls/landing_gear_toggle", sim_ldg_gear_toggle_CMDhandler)

--*************************************************************************************--
--**                                      CODE                                       **--
--*************************************************************************************--



--*************************************************************************************--
--**                                  EVENT CALLBACKS                                **--
--*************************************************************************************--

--function aircraft_load()

--function aircraft_unload()

--function flight_start()

--function flight_crash()

--function before_physics()

function after_physics()
   B777_avg_gear_pos = (simDR_ldg_gear_pos[0] + simDR_ldg_gear_pos[1]) / 2

   if B777_eagle_claw_sync == 1 then
      B777DR_custom_eagle_claw = simDR_eag_claw_pos[-- default eag claw]
   end

   if B777_avg_gear_pos < 0.1 then
      B777_eagle_claw_sync = 0
      B777DR_custom_eagle_claw = 0
   end
end

--function after_replay()
]]