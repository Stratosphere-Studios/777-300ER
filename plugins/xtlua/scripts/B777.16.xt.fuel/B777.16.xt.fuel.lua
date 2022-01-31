--[[
*****************************************************************************************
* Script Name: fuel
* Author Name: nathroxer001
* Script Description: fuel system code
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
 
target_pos_fuel_pumps = {0}

 
 --*************************************************************************************--
 --**                              FIND X-PLANE DATAREFS                              **--
 --*************************************************************************************--
 
 
 
 --*************************************************************************************--
 --**                             CUSTOM DATAREF HANDLERS                             **--
 --*************************************************************************************--
 
 
 
 --*************************************************************************************--
 --**                              CREATE CUSTOM DATAREFS                             **--
 --*************************************************************************************--
 
 B777DR_fuel_pumps_fwd_l               = deferred_dataref("Strato/777/cockpit/fuel/fwd_l", "number")
 B777DR_fuel_pumps_aft_l               = deferred_dataref("Strato/777/cockpit/fuel/aft_l", "boolean")
 B777DR_fuel_pumps_fwd_r               = deferred_dataref("Strato/777/cockpit/fuel/fwd_r", "boolean")
 B777DR_fuel_pumps_aft_r               = deferred_dataref("Strato/777/cockpit/fuel/aft_r", "boolean")
 B777DR_fuel_pumps_ctr_l               = deferred_dataref("Strato/777/cockpit/fuel/ctr_l", "boolean")
 B777DR_fuel_pumps_ctr_r               = deferred_dataref("Strato/777/cockpit/fuel/ctr_r", "boolean")
 B777DR_fuel_pumps_cross_fwd           = deferred_dataref("Strato/777/cockpit/fuel/cross_fwd", "boolean")
 B777DR_fuel_pumps_cross_aft           = deferred_dataref("Strato/777/cockpit/fuel/cross_aft", "boolean")


 --*************************************************************************************--
 --**                             X-PLANE COMMAND HANDLERS                            **--
 --*************************************************************************************--
 
 
 
 --*************************************************************************************--
 --**                                 X-PLANE COMMANDS                                **--
 --*************************************************************************************--
 
 
 
 --*************************************************************************************--
 --**                             CUSTOM COMMAND HANDLERS                             **--
 --*************************************************************************************--
 

 function B777_fuel_pumps_fwd_l_CMD_handler(phase, duration)
   if phase == 0 then
      target_pos_fuel_pumps[1] = 1 - target_pos_fuel_pumps[1]
   end
end

function animate_fuel_pump_fwd_1()
   B777DR_fuel_pumps_fwd_l = func_animate_slowly(target_pos_fuel_pumps[1], B777DR_fuel_pumps_fwd_l, 0.2)
end

 --*************************************************************************************--
 --**                             CREATE CUSTOM COMMANDS                               **--
 --*************************************************************************************--

 B777CMD_fuel_pumps_fwd_l               = deferred_command("Strato/777/cockpit/fuel/fwd_l", "fuel_fwd_1", B777_fuel_pumps_fwd_l_CMD_handler)
 B777CMD_fuel_pumps_aft_l               = deferred_command("Strato/777/cockpit/fuel/aft_l", "boolean")
 B777CMD_fuel_pumps_fwd_r               = deferred_command("Strato/777/cockpit/fuel/fwd_r", "boolean")
 B777CMD_fuel_pumps_aft_r               = deferred_command("Strato/777/cockpit/fuel/aft_r", "boolean")
 B777CMD_fuel_pumps_ctr_l               = deferred_command("Strato/777/cockpit/fuel/ctr_l", "boolean")
 B777DR_fuel_pumps_ctr_r                = deferred_command("Strato/777/cockpit/fuel/ctr_r", "boolean")
 B777DR_fuel_pumps_cross_fwd            = deferred_command("Strato/777/cockpit/fuel/cross_fwd", "boolean")
 B777DR_fuel_pumps_cross_aft            = deferred_command("Strato/777/cockpit/fuel/cross_aft", "boolean")

 --*************************************************************************************--
 --**                                      CODE                                       **--
 --*************************************************************************************--
 
 function func_animate_slowly(reference_value, animated_VALUE, anim_speed)
   if math.abs(reference_value - animated_VALUE) < 0.1 then return reference_value end
   animated_VALUE = animated_VALUE + ((reference_value - animated_VALUE) * (anim_speed * SIM_PERIOD))
   return animated_VALUE
end

function animate_fuel_pump_fwd_1()
   B777DR_fuel_pumps_fwd_l = func_animate_slowly(target_pos_fuel_pumps[1], B777DR_fuel_pumps_fwd_l, 0.2)
end
 
 --*************************************************************************************--
 --**                                  EVENT CALLBACKS                                **--
 --*************************************************************************************--
 
 --function aircraft_load()
 
 --function aircraft_unload()
 
 --function flight_start()
 
 --function flight_crash()
 
 --function before_physics()
 
 --function after_physics()
function after_physics()
   animate_fuel_pump_fwd_1()
end
 --function after_replay()
 
