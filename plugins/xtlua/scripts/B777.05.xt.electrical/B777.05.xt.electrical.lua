--[[
*****************************************************************************************
* Script Name: Electrical
* Author Name: @crazytimtimtim
* Script Description: Code for Electrical systems
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
--**                              FIND X-PLANE DATAREFS                              **--
--*************************************************************************************--

simDR_onGround                            = find_dataref("sim/flightmodel/failures/onground_any")
simDR_groundSpeed                         = find_dataref("sim/flightmodel/position/groundspeed")
simDR_enginesRunning                      = find_dataref("sim/flightmodel/engine/ENGN_running")
simDR_gpuConnected                        = find_dataref("sim/cockpit/electrical/gpu_on")

B777DR_ovhd_ctr_button_target             = find_dataref("Strato/777/cockpit/ovhd/ctr/buttons/target")

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
--**                                 X-PLANE COMMANDS                                **--
--*************************************************************************************--

simCMD_ovhd_gpu_on                      = find_command("sim/electrical/GPU_on")
simCMD_ovhd_gpu_off                     = find_command("sim/electrical/GPU_off")

--*************************************************************************************--
--**                             CUSTOM COMMAND HANDLERS                             **--
--*************************************************************************************--

function B777_ovhd_c_ext_pwr_switch_CMDhandler(phase, duration)
   if phase == 0 then
      B777DR_ovhd_ctr_button_target[7] = 1
      if simDR_gpuConnected == 0 and simDR_groundSpeed < 5 and simDR_onGround == 1 and simDR_enginesRunning[0] == 0 and simDR_enginesRunning[1] == 0 then
         simCMD_ovhd_gpu_on:once()
      elseif simDR_gpuConnected == 1 then
         simCMD_ovhd_gpu_off:once()
      end
   elseif phase == 2 then
      B777DR_ovhd_ctr_button_target[7] = 0
   end
end

--*************************************************************************************--
--**                             CREATE CUSTOM COMMANDS                               **--
--*************************************************************************************--

B777CMD_ovhd_c_ext_pwr_button             = deferred_command("Strato/B777/button_switch/ovhd_c/ext_pwr", "External Power Switch", B777_ovhd_c_ext_pwr_switch_CMDhandler)

--*************************************************************************************--
--**                                      CODE                                       **--
--*************************************************************************************--



--*************************************************************************************--
--**                                  EVENT CALLBACKS                                **--
--*************************************************************************************--

function aircraft_load()
   print("electrical loaded")
end

--function aircraft_unload()

--function flight_start()

--function flight_crash()

--function before_physics()

function after_physics()
   if simDR_gpuConnected == 1 and (simDR_groundSpeed > 1 or simDR_onGround ~= 1 or simDR_enginesRunning[0] ~= 0 or simDR_enginesRunning[0] ~= 0) then
      simCMD_ovhd_gpu_off:once()
   end
end

--function after_replay()
