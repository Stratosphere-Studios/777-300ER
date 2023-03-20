--[[
*****************************************************************************************
* Script Name: misc
* Author Name: remenkemi (crazytimtimtim)
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

--[[local B777_eag_claw_sync = 1
local B777_eag_target = 0]]
local avg_gear_pos;
local avg_gear_door_pos;
--*************************************************************************************--
--**                              FIND X-PLANE DATAREFS                              **--
--*************************************************************************************--

simDR_ldg_gear_pos                        = find_dataref("sim/aircraft/parts/acf_gear_deploy")
B777DR_gear_door_pos                      = find_dataref("Strato/777/gear/doors")
--[[simDR_eag_claw_pos                        = find_dataref("sim/flightmodel2/gear/eagle_claw_angle_deg")
simDR_whichOnGround                       = find_dataref("sim/flightmodel2/gear/on_ground")
simDR_gear_handle                         = find_dataref("sim/cockpit2/controls/gear_handle_down")]]

simDR_spoiler_handle                      = find_dataref("sim/cockpit2/controls/speedbrake_ratio")
simDR_trottle_pos                         = find_dataref("sim/cockpit2/engine/actuators/throttle_jet_rev_ratio_all")
simDR_onground                            = find_dataref("sim/flightmodel/failures/onground_any")

--simDR_camera_fov                          = find_dataref("sim/cockpit2/camera/camera_field_of_view")

simDR_N1                                  = find_dataref("sim/flightmodel2/engines/N1_percent")
simDR_oil_pressure_psi                    = find_dataref("sim/flightmodel/engine/ENGN_oil_press_psi")
simDR_oil_press_fail_0                    = find_dataref("sim/operation/failures/rel_oilp_ind_0")
simDR_oil_press_fail_1                    = find_dataref("sim/operation/failures/rel_oilp_ind_1")

--[[simDR_reverser_0_fail                     = find_dataref("sim/operation/failures/rel_revers0")
simDR_reverser_1_fail                     = find_dataref("sim/operation/failures/rel_revers1")]]

--*************************************************************************************--
--**                             CUSTOM DATAREF HANDLERS                             **--
--*************************************************************************************--



--*************************************************************************************--
--**                              CREATE CUSTOM DATAREFS                             **--
--*************************************************************************************--

B777DR_custom_eagle_claw                = deferred_dataref("Strato/777/custom_eagle_claw", "array[3]")
B777DR_dome_light                       = deferred_dataref("Strato/777/cockpit/cockpit_dome_light", "number")
B777DR_ldg_gear_kill                    = deferred_dataref("Strato/777/kill_gear", "number")

B777DR_oil_press_psi                    = deferred_dataref("Strato/777/oil_press_psi", "array[2]")

--*************************************************************************************--
--**                             X-PLANE COMMAND HANDLERS                            **--
--*************************************************************************************--

--[[function sim_landing_gear_up(phase, duration)         
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
]]

function sim_avionics_off() end

--*************************************************************************************--
--**                                 X-PLANE COMMANDS                                **--
--*************************************************************************************--

--[[simCMD_landing_gear_toggle              = replace_command("sim/flight_controls/landing_gear_toggle", sim_landing_gear_toggle_CMDhandler)
simCMD_ldg_gear_up                      = replace_command("sim/flight_controls/landing_gear_up", sim_landing_gear_up)
simCMD_ldg_gear_down                    = replace_command("sim/flight_controls/landing_gear_down", sim_landing_gear_down)]]
simCMD_avionics_off                     = replace_command("sim/systems/avionics_off", sim_avionics_off)

simCMD_avionics_on                      = find_command("sim/systems/avionics_on")

--*************************************************************************************--
--**                             CUSTOM COMMAND HANDLERS                             **--
--*************************************************************************************--

--[[--- LANDING GEAR ----------

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
end]]

--*************************************************************************************--
--**                             CREATE CUSTOM COMMANDS                               **--
--*************************************************************************************--


--*************************************************************************************--
--**                                      CODE                                       **--
--*************************************************************************************--

----- ANIMATION UTILITY -----------------------------------------------------------------
function B777_animate(target, variable, speed)
   if math.abs(target - variable) < 0.1 then return target end
   variable = variable + ((target - variable) * (speed * SIM_PERIOD))
   return variable
end

----- TERNARY CONDITIONAL ---------------------------------------------------------------
function B777_ternary(condition, ifTrue, ifFalse)
   if condition then return ifTrue else return ifFalse end
end

----- RESCALE ---------------------------------------------------------------------------
function B777_rescale(in1, out1, in2, out2, x)

   if x < in1 then return out1 end
   if x > in2 then return out2 end
   return out1 + (out2 - out1) * (x - in1) / (in2 - in1)

end

function gear()
   avg_gear_pos = (simDR_ldg_gear_pos[1] + simDR_ldg_gear_pos[2]) / 2
   avg_gear_door_pos = (B777DR_gear_door_pos[1] + B777DR_gear_door_pos[2]) / 2
   if avg_gear_pos == 0 and avg_gear_door_pos == 0 then
      B777DR_ldg_gear_kill = 1
   else
      B777DR_ldg_gear_kill = 0
   end
end

--*************************************************************************************--
--**                                  EVENT CALLBACKS                                **--
--*************************************************************************************--

function aircraft_load()
   print("misc loaded")
end

--function aircraft_unload()

function flight_start()
   --ssimDR_camera_fov = 40
   simCMD_avionics_on:once()
end

function flight_crash()
   print("Bruh, why did you crash? Noob. Learn to fly.")
end

--function before_physics()

function after_physics()
   print("This window helps the developers find and fix bugs. Feel free to minimize it, but closing it will cause X-Plane to crash!!! This is not a bug or error. Just minimize this window and everything will be ok. IF YOU HAVE ANY ISSUES, PLEASE CHECK THE README BEFORE ASKING THE DEVELOPERS!!!")
   gear()

   if simDR_oil_press_fail_0 ~= 6 then
      B777DR_oil_press_psi[0] = -0.0027*(simDR_N1[0]*simDR_N1[0]) + 0.6464*simDR_N1[0] + 30
   else
      B777DR_oil_press_psi[0] = B777_animate(0, B777DR_oil_press_psi[0], 1)
   end

   if simDR_oil_press_fail_1 ~= 6 then
      B777DR_oil_press_psi[1] = -0.0027*(simDR_N1[1]*simDR_N1[1]) + 0.6464*simDR_N1[1] + 30
   else
      B777DR_oil_press_psi[1] = B777_animate(0, B777DR_oil_press_psi[1], 1)
   end
end

--function after_replay()