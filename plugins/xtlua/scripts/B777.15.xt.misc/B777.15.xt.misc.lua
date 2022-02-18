--[[
*****************************************************************************************
* Script Name: misc
* Author Name: Crazytimtimtim
* Script Description: Misc system code for systems that don't have enough for their own module.
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

local B777_eag_claw_sync = 1
local B777_eag_target = 0


--*************************************************************************************--
--**                              FIND X-PLANE DATAREFS                              **--
--*************************************************************************************--

simDR_ldg_gear_pos                        = find_dataref("sim/aircraft/parts/acf_gear_deploy")
simDR_eag_claw_pos                        = find_dataref("sim/flightmodel2/gear/eagle_claw_angle_deg")
simDR_onGround                            = find_dataref("sim/flightmodel/failures/onground_any")
simDR_gear_handle                         = find_dataref("sim/cockpit2/controls/gear_handle_down")

--replace the up, down, and toggle. make toggle run replaced up and down (new gear up/down tilt gear)

--*************************************************************************************--
--**                             CUSTOM DATAREF HANDLERS                             **--
--*************************************************************************************--



--*************************************************************************************--
--**                              CREATE CUSTOM DATAREFS                             **--
--*************************************************************************************--

B777DR_custom_eagle_claw                = deferred_dataref("Strato/777/custom_eagle_claw", "array[3]")
B777DR_cockpit_panel_lights             = deferred_dataref("Strato/777/cockpit/cockpit_panel_lights", "array[6]")
B777DR_dome_light                       = deferred_dataref("Strato/777/cockpit/cockpit_dome_light", "number")
B777DR_ldg_gear_kill                    = deferred_dataref("Strato/777/kill_gear", "number")
B777DR_avg_gear_pos                     = deferred_dataref("Strato/777/avg_main_gear_pos", "number")

--*************************************************************************************--
--**                             X-PLANE COMMAND HANDLERS                            **--
--*************************************************************************************--



--*************************************************************************************--
--**                                 X-PLANE COMMANDS                                **--
--*************************************************************************************--

simCMD_reverser_toggle_1                = find_command("sim/engines/thrust_reverse_toggle_1")
simCMD_reverser_toggle_2                = find_command("sim/engines/thrust_reverse_toggle_2")

--*************************************************************************************--
--**                             CUSTOM COMMAND HANDLERS                             **--
--*************************************************************************************--

----- ANIMATION UTILITY -----------------------------------------------------------------
function B777_animate(target, variable, speed)
   if math.abs(target - variable) < 0.1 then return target end
   variable = variable + ((target - variable) * (speed * SIM_PERIOD))
   return variable
end

----- LANDING GEAR ----------------------------------------------------------------------

function eagClawSync()
   B777_eag_claw_sync = 1
end

function gearUp()
   simDR_gear_handle = 0
end

function eagClawUp()
   B777_eag_target = 19             -- raise eagle claw
   if not is_timer_scheduled(eagClawSync) then
      run_after_time(eagClawSync, 4)   -- synchronise custom eagle claw and default
   end
end

function sim_landing_gear_up(phase, duration)         
   B777_eag_claw_sync = 0                       -- desyncronise custom and default eagle claw datarefs
   B777_eag_target = 0                          -- bring custom eagle claw to pointing up position
   if not is_timer_scheduled(gearUp) then
      run_after_time(gearUp, 4)                    -- gear up once eagle claw neutral
   end
end

function sim_landing_gear_down(phase, duration)
   B777_eag_claw_sync = 0                       -- desyncronise custom and default eagle claw datarefs
   simDR_gear_handle = 1                        -- bring gear down
   if not is_timer_scheduled(eagClawUp) then
      run_after_time(eagClawUp, 20)                -- put custom eagle claw in the "pointing up" position once gear down
   end
end

function sim_landing_gear_toggle_CMDhandler(phase, duration)   -- runs when landing gear toggled
   if phase == 0 then
      if simDR_gear_handle == 1 then                 -- if gear down
         simCMD_ldg_gear_up:once()
      elseif simDR_gear_handle == 0 then             -- if gear up
         simCMD_ldg_gear_down:once()
      end
   end
end

----- THRUST REVERSERS -------------------------------------------------------------------

function sim_reverser_toggle_CMDhandler(phase, duration)
   if phase == 0 then
      if simDR_onGround == 1 then
         simCMD_reverser_toggle_1:once()
         simCMD_reverser_toggle_2:once()
      end
   end
end

--*************************************************************************************--
--**                             CREATE CUSTOM COMMANDS                               **--
--*************************************************************************************--

simCMD_landing_gear_toggle = replace_command("sim/flight_controls/landing_gear_toggle", sim_landing_gear_toggle_CMDhandler)
simCMD_reverser_toggle = replace_command("sim/engines/thrust_reverse_toggle", sim_reverser_toggle_CMDhandler)

simCMD_ldg_gear_up                      = replace_command("sim/flight_controls/landing_gear_up", sim_landing_gear_up)
simCMD_ldg_gear_down                    = replace_command("sim/flight_controls/landing_gear_down", sim_landing_gear_down)

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
   B777DR_avg_gear_pos = (simDR_ldg_gear_pos[1] + simDR_ldg_gear_pos[2]) / 2

   if B777_eag_claw_sync == 1 then
      B777DR_custom_eagle_claw[1] = simDR_eag_claw_pos[1]
      B777DR_custom_eagle_claw[2] = simDR_eag_claw_pos[2]
   end

   if B777DR_avg_gear_pos < 0.9 then
      B777_eag_claw_sync = 0
      B777DR_custom_eagle_claw = 0
   end

   if B777_eag_claw_sync == 0 then
      B777DR_custom_eagle_claw[1] = B777_animate(B777_eag_target, B777DR_custom_eagle_claw[1], 0.9)
      B777DR_custom_eagle_claw[2] = B777_animate(B777_eag_target, B777DR_custom_eagle_claw[1], 0.9)
   end

   if B777DR_avg_gear_pos == 0 then
      B777DR_ldg_gear_kill = 1
   else
      B777DR_ldg_gear_kill = 0
   end

end

--function after_replay()