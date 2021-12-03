--[[
*****************************************************************************************
* Script Name: fmc
* Author Name: @nathroxer001
* Script Description: Code for fms
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
  
  --*************************************************************************************--s
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
  
 
  --*************************************************************************************--
  --**                             CUSTOM DATAREF HANDLERS                             **--
  --*************************************************************************************--
  
  
  
  --*************************************************************************************--
  --**                              CREATE CUSTOM DATAREFS                             **--
  --*************************************************************************************--
  
  local fmc_1_1 = deferred_dataref("Strato/B777/cockpit/fmc_1_1", "string")
  local fmc_1_2 = deferred_dataref("Strato/B777/cockpit/fmc_1_2", "string")
  local fmc_1_3 = deferred_dataref("Strato/B777/cockpit/fmc_1_3", "string")
  local fmc_1_4 = deferred_dataref("Strato/B777/cockpit/fmc_1_4", "string")
  local fmc_1_5 = deferred_dataref("Strato/B777/cockpit/fmc_1_5", "string")
  local fmc_1_6 = deferred_dataref("Strato/B777/cockpit/fmc_1_6", "string")
  local fmc_1_7 = deferred_dataref("Strato/B777/cockpit/fmc_1_7", "string")
  local fmc_1_8 = deferred_dataref("Strato/B777/cockpit/fmc_1_8", "string")
  local fmc_1_9 = deferred_dataref("Strato/B777/cockpit/fmc_1_9", "string")
  local fmc_1_10 = deferred_dataref("Strato/B777/cockpit/fmc_1_10", "string")
  local fmc_1_11 = deferred_dataref("Strato/B777/cockpit/fmc_1_11", "string")
  local fmc_1_12 = deferred_dataref("Strato/B777/cockpit/fmc_1_12", "string")
  local fmc_1_13 = deferred_dataref("Strato/B777/cockpit/fmc_1_13", "string")
  local fmc_1_14 = deferred_dataref("Strato/B777/cockpit/fmc_1_14", "string")
  local fmc_2_1 = deferred_dataref("Strato/B777/cockpit/fmc_2_1", "string")
  local fmc_2_2 = deferred_dataref("Strato/B777/cockpit/fmc_2_2", "string")
  local fmc_2_3 = deferred_dataref("Strato/B777/cockpit/fmc_2_3", "string")
  local fmc_2_4 = deferred_dataref("Strato/B777/cockpit/fmc_2_4", "string")
  local fmc_2_5 = deferred_dataref("Strato/B777/cockpit/fmc_2_5", "string")
  local fmc_2_6 = deferred_dataref("Strato/B777/cockpit/fmc_2_6", "string")
  local fmc_2_7 = deferred_dataref("Strato/B777/cockpit/fmc_2_7", "string")
  local fmc_2_8 = deferred_dataref("Strato/B777/cockpit/fmc_2_8", "string")
  local fmc_2_9 = deferred_dataref("Strato/B777/cockpit/fmc_2_9", "string")
  local fmc_2_10 = deferred_dataref("Strato/B777/cockpit/fmc_2_10", "string")
  local fmc_2_11 = deferred_dataref("Strato/B777/cockpit/fmc_2_11", "string")
  local fmc_2_12 = deferred_dataref("Strato/B777/cockpit/fmc_2_12", "string")
  local fmc_2_13 = deferred_dataref("Strato/B777/cockpit/fmc_2_13", "string")
  local fmc_2_14 = deferred_dataref("Strato/B777/cockpit/fmc_2_14", "string")
  local fmc_2_1 = deferred_dataref("Strato/B777/cockpit/fmc_3_1", "string")
  local fmc_3_2 = deferred_dataref("Strato/B777/cockpit/fmc_3_2", "string")
  local fmc_3_3 = deferred_dataref("Strato/B777/cockpit/fmc_3_3", "string")
  local fmc_3_4 = deferred_dataref("Strato/B777/cockpit/fmc_3_4", "string")
  local fmc_3_5 = deferred_dataref("Strato/B777/cockpit/fmc_3_5", "string")
  local fmc_3_6 = deferred_dataref("Strato/B777/cockpit/fmc_3_6", "string")
  local fmc_3_7 = deferred_dataref("Strato/B777/cockpit/fmc_3_7", "string")
  local fmc_3_8 = deferred_dataref("Strato/B777/cockpit/fmc_3_8", "string")
  local fmc_3_9 = deferred_dataref("Strato/B777/cockpit/fmc_3_9", "string")
  local fmc_3_10 = deferred_dataref("Strato/B777/cockpit/fmc_3_10", "string")
  local fmc_3_11 = deferred_dataref("Strato/B777/cockpit/fmc_3_11", "string")
  local fmc_3_12 = deferred_dataref("Strato/B777/cockpit/fmc_3_12", "string")
  local fmc_3_13 = deferred_dataref("Strato/B777/cockpit/fmc_3_13", "string")
  local fmc_3_14 = deferred_dataref("Strato/B777/cockpit/fmc_3_14", "string")

  --*************************************************************************************--
  --**                             X-PLANE COMMAND HANDLERS                            **--
  --*************************************************************************************--
  
  
  
  --*************************************************************************************--
  --**                                 X-PLANE COMMANDS                                **--
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
  
  
  
  --*************************************************************************************--
  --**                                  EVENT CALLBACKS                                **--
  --*************************************************************************************--


