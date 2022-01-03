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

local B777_avg_gear_pos = 1
local B777_eag_claw_sync = 1
local B777_eag_target = 0


--*************************************************************************************--
--**                              FIND X-PLANE DATAREFS                              **--
--*************************************************************************************--

simDR_ldg_gear_pos                        = find_dataref("sim/aircraft/parts/acf_gear_deploy")
simDR_eag_claw_pos                        = find_dataref("sim/flightmodel2/gear/eagle_claw_angle_deg")
simDR_onGround                            = find_dataref('sim/flightmodel/failures/onground_any')


--*************************************************************************************--
--**                             CUSTOM DATAREF HANDLERS                             **--
--*************************************************************************************--



--*************************************************************************************--
--**                              CREATE CUSTOM DATAREFS                             **--
--*************************************************************************************--

B777DR_custom_eagle_claw                = deferred_dataref("Strato/777/custom_eagle_claw", "array[3]")

--*************************************************************************************--
--**                             X-PLANE COMMAND HANDLERS                            **--
--*************************************************************************************--



--*************************************************************************************--
--**                                 X-PLANE COMMANDS                                **--
--*************************************************************************************--

simCMD_ldg_gear_up                      = find_command("sim/flight_controls/landing_gear_up")
simCMD_ldg_gear_down                    = find_command("sim/flight_controls/landing_gear_down")
simCMD_reverser_toggle_1                = find_command("sim/engines/thrust_reverse_toggle_1")
simCMD_reverser_toggle_2                = find_command("sim/engines/thrust_reverse_toggle_2")

--*************************************************************************************--
--**                             CUSTOM COMMAND HANDLERS                             **--
--*************************************************************************************--

----- ANIMATION UTILITY -----------------------------------------------------------------
function B777_set_animation_position(current_value, target, min, max, speed)

   local fps_factor = math.min(1.0, speed * SIM_PERIOD)

   if target >= (max - 0.001) and current_value >= (max - 0.01) then
      return max
   elseif target <= (min + 0.001) and current_value <= (min + 0.01) then
      return min
   else
      return current_value + ((target - current_value) * fps_factor)
   end

end

----- LANDING GEAR ----------------------------------------------------------------------

function eagClawSync()
   B777_eag_claw_sync = 1
end

function gearUp()
   simCMD_ldg_gear_up:once()
end

function eagClawUp()
   B777_eag_target = 19             -- raise eagle claw
   run_after_time(eagClawSync, 4)   -- synchronise custom eagle claw and default
end

function sim_landing_gear_toggle_CMDhandler(phase, duration)   -- runs when landing gear toggled
   if phase == 0 then
      if B777_avg_gear_pos > 0.9 then                 -- if gear down
         B777_eag_claw_sync = 0                       -- desyncronise custom and default eagle claw datarefs
         B777_eag_target = 0                          -- bring custom eagle claw to pointing up position
         run_after_time(gearUp, 4)                    -- gear up once eagle claw neutral

      elseif B777_avg_gear_pos < 0.1 then             -- if gear up
         B777_eag_claw_sync = 0                       -- desyncronise custom and default eagle claw datarefs
         simCMD_ldg_gear_down:once()                  -- bring gear down
         run_after_time(eagClawUp, 20)                -- put custom eagle claw in the "pointing up" position once gear down
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
   B777_avg_gear_pos = (simDR_ldg_gear_pos[1] + simDR_ldg_gear_pos[2]) / 2

   if B777_eag_claw_sync == 1 then
      B777DR_custom_eagle_claw[1] = simDR_eag_claw_pos[1]
      B777DR_custom_eagle_claw[2] = simDR_eag_claw_pos[2]
   end

   if B777_avg_gear_pos < 0.9 then
      B777_eag_claw_sync = 0
      B777DR_custom_eagle_claw = 0
   end

   if B777_eag_claw_sync == 0 then
      B777DR_custom_eagle_claw[1] = B777_set_animation_position(B777DR_custom_eagle_claw[1], B777_eag_target, 0, 19, 0.5)
      B777DR_custom_eagle_claw[2] = B777_set_animation_position(B777DR_custom_eagle_claw[2], B777_eag_target, 0, 19, 0.5)
   end

end

--function after_replay()