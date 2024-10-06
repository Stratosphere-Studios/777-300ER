--[[
*****************************************************************************************
* Script Name: EFB
* Author Name: remenkemi 
* Script Description: Electronic Flight Bag Code
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

dofile("json/json.lua")

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

local pages = {
   {name = "loadingScreen", parent = 1, type = 0},
   {name = "homeScreen", parent = 2, type = 1},
   {name = "passengers", parent = 2, type = 1}
}

--*************************************************************************************--
--**                              FIND X-PLANE DATAREFS                              **--
--*************************************************************************************--



--*************************************************************************************--
--**                              FIND CUSTOM DATAREFS                               **--
--*************************************************************************************--

avitabEnabled                          = find_dataref("avitab/panel_enabled") -- or 'avitab/panel_powered'
B777DR_simconfig_data                  = find_dataref("Strato/777/simconfig")
B777DR_newsimconfig_data               = find_dataref("Strato/777/newsimconfig")
testNum                                = find_dataref("testNum")
B777DR_oldsimconfig_data               = find_dataref("Strato/777/oldsimconfig_data")

B777DR_acf_is_freighter                = find_dataref("Strato/777/acf_is_freighter")
B777DR_lbs_kgs                         = find_dataref("Strato/777/lbs_kgs")
B777DR_trs_bug_enabled                 = find_dataref("Strato/777/displays/trs_bug_enabled")
B777DR_aoa_enabled                     = find_dataref("Strato/777/displays/pfd_aoa_enabled")
B777DR_smart_knobs                     = find_dataref("Strato/777/smart_knobs")
B777DR_pfd_mach_gs                     = find_dataref("Strato/777/pfd_mach_gs")
B777DR_realistic_prk_brk               = find_dataref("Strato/777/gear/park_brake_realistic")

--*************************************************************************************--
--**                             CUSTOM DATAREF HANDLERS                             **--
--*************************************************************************************--



--*************************************************************************************--
--**                              CREATE CUSTOM DATAREFS                             **--
--*************************************************************************************--

B777DR_efb_page                        = deferred_dataref("Strato/777/displays/efb_page", "number")
B777DR_efb_page_type                   = deferred_dataref("Strato/777/displays/efb_page_type", "number")
B777DR_maint_covers                    = deferred_dataref("Strato/777/maint/covers", "array[3]")
B777DR_maint_doors                     = deferred_dataref("Strato/777/maint/doors", "array[6]")
--B777DR_efb_keypad                      = deferred_dataref("Strato/777/displays/efb_keypad", "number")
--B777DR_efb_keypad_scratchpad           = deferred_dataref("Strato/777/displays/efb_keypad_scratchpad", "string")

--*************************************************************************************--
--**                             X-PLANE COMMAND HANDLERS                            **--
--*************************************************************************************--


--*************************************************************************************--
--**                                 X-PLANE COMMANDS                                **--
--*************************************************************************************--


--*************************************************************************************--
--**                                      CODE                                       **--
--*************************************************************************************--
local temp = {}
function efb_boot()
   B777DR_efb_page = 2
end

--Simulator Config
simConfigData = {}

function getSimConfig(p1, p2)
   if simConfigData[p1] then
      if simConfigData[p1][p2] then
         return simConfigData[p1][p2]
      end
   end
   print("ERROR: Attempt to get invalid simconfig value in EFB")
   return "fail"
end

function setSimConfig(p1, p2, value)
   if simConfigData[p1] then
      if simConfigData[p1][p2] then
         simConfigData[p1][p2] = value
         B777DR_simconfig_data = json.encode(simConfigData["values"])
         B777DR_newsimconfig_data = 1
         return "success"
      end
   end
   print("ERROR: Attempt to set invalid simconfig value in EFB.")
   return "fail"
end

function doCMD(cmd)
   local var = find_command(cmd)
   var:once()
end

function setDref(dref, value)
   local var = find_dataref(dref)
   var = value
end

--*************************************************************************************--
--**                             CUSTOM COMMAND HANDLERS                             **--
--*************************************************************************************--

function efb_L1_CMDhandler(phase, duration)
   if phase == 0 and B777DR_efb_page > 1 then
      if B777DR_efb_page == 2  then B777DR_efb_page = 3 end
   end
end

function efb_L2_CMDhandler(phase, duration)
   if phase == 0 and B777DR_efb_page > 1 then
      
   end
end

function efb_LC1_CMDhandler(phase, duration)
   if phase == 0 and B777DR_efb_page > 1 then
      
   end
end

function efb_LC2_CMDhandler(phase, duration)
   if phase == 0 and B777DR_efb_page > 1 then
      
   end
end

function efb_RC1_CMDhandler(phase, duration)
   if phase == 0 and B777DR_efb_page > 1 then
      
   end
end

function efb_RC2_CMDhandler(phase, duration)
   if phase == 0 and B777DR_efb_page > 1 then
      
   end
end

function efb_R1_CMDhandler(phase, duration)
   if phase == 0 and B777DR_efb_page > 1 then
      
   end
end

function efb_R2_CMDhandler(phase, duration)
   if phase == 0 and B777DR_efb_page > 1 then
      
   end
end

function efb_home_CMDhandler(phase, duration)
   if phase == 0 and B777DR_efb_page > 1 then
      B777DR_efb_page = 2
   end
end

function efb_back_CMDhandler(phase, duration)
   if phase == 0 and B777DR_efb_page > 1 then
      B777DR_efb_page = pages[B777DR_efb_page].parent
   end
end

function efb_pwr_CMDhandler(phase, duration)
   if phase == 0 and B777DR_efb_page > 1 then
      if B777DR_efb_page > 0 then
         B777DR_efb_page = 0
      else
         B777DR_efb_page = 1
         run_after_time(efb_boot, 3)
      end
   end
end

function weight_mode_toggle_CMDHandler(phase, duration)
	if phase == 0 then
		setSimConfig("PLANE", "weight_display_units", getSimConfig("PLANE", "weight_display_units") == "LBS" and "KGS" or "LBS")
		B777DR_lbs_kgs = getSimConfig("PLANE", "weight_display_units") == "LBS" and 1 or 0;
	end
end
function prkBrk_mode_toggle_CMDHandler(phase, duration)
   if phase == 0 then
		setSimConfig("PLANE", "real_park_brake", 1 - getSimConfig("PLANE", "real_park_brake"))
		B777DR_realistic_prk_brk = getSimConfig("PLANE", "real_park_brake")
	end
end
function smartKnobs_toggle_CMDHandler(phase, duration)
	if phase == 0 then
		setSimConfig("PLANE", "smart_knobs", 1 - getSimConfig("PLANE", "smart_knobs"))
		B777DR_smart_knobs = getSimConfig("PLANE", "smart_knobs")
	end
end
function gsInd_toggle_CMDHandler(phase, duration)
	if phase == 0 then
		setSimConfig("PLANE", "gs_mach_indicator", 1 - getSimConfig("PLANE", "gs_mach_indicator"))
		B777DR_pfd_mach_gs = getSimConfig("PLANE", "gs_mach_indicator")
	end
end
function trsInd_toggle_CMDHandler(phase, duration)
	if phase == 0 then
		setSimConfig("PLANE", "trs_bug", 1 - getSimConfig("PLANE", "trs_bug"))
		B777DR_trs_bug_enabled = getSimConfig("PLANE", "trs_bug")
	end
end
function aoaInd_toggle_CMDHandler(phase, duration)
	if phase == 0 then
		setSimConfig("PLANE", "aoa_indicator", 1 - getSimConfig("PLANE", "aoa_indicator"))
		B777DR_aoa_enabled = getSimConfig("PLANE", "aoa_indicator")
	end
end
function acfType_toggle_CMDHandler(phase, duration)
	if phase == 0 then
		setSimConfig("PLANE", "aircraft_type", 1 - getSimConfig("PLANE", "aircraft_type"))
		B777DR_acf_is_freighter = getSimConfig("PLANE", "aircraft_type")
	end
end

--*************************************************************************************--
--**                             CREATE CUSTOM COMMANDS                               **--
--*************************************************************************************--

B777CMD_efb_L1                         = deferred_command("Strato/777/efb_L1", "EFB Top Left Button", efb_L1_CMDhandler)
B777CMD_efb_L2                         = deferred_command("Strato/777/efb_L2", "EFB Bottom Left Button", efb_L2_CMDhandler)
B777CMD_efb_LC1                        = deferred_command("Strato/777/efb_LC1", "EFB Top Left-Center Button", efb_LC1_CMDhandler)
B777CMD_efb_LC2                        = deferred_command("Strato/777/efb_LC2", "EFB Bottom Left-Center Button", efb_LC2_CMDhandler)
B777CMD_efb_RC1                        = deferred_command("Strato/777/efb_RC1", "EFB Top Right-Center Button", efb_RC1_CMDhandler)
B777CMD_efb_RC2                        = deferred_command("Strato/777/efb_RC2", "EFB Bottom Right-Center Button", efb_RC2_CMDhandler)
B777CMD_efb_R1                         = deferred_command("Strato/777/efb_R1", "EFB Top Right Button", efb_R1_CMDhandler)
B777CMD_efb_R2                         = deferred_command("Strato/777/efb_R2", "EFB Bottom Right Button", efb_R2_CMDhandler)

B777CMD_efb_home                       = deferred_command("Strato/777/efb_home", "EFB Home Button", efb_home_CMDhandler)
B777CMD_efb_pwr                        = deferred_command("Strato/777/efb_pwr", "EFB Power Button", efb_pwr_CMDhandler)
B777CMD_efb_back                       = deferred_command("Strato/777/efb_back", "EFB Back Button", efb_back_CMDhandler)

B777CMD_toggle_weight_mode             = deferred_command("Strato/777/options/weight_mode_toggle", "Toggle Weight Mode", weight_mode_toggle_CMDHandler)
B777CMD_toggle_prkBrk_mode             = deferred_command("Strato/777/options/prkBrk_mode_toggle", "Toggle Parking Brake Mode", prkBrk_mode_toggle_CMDHandler)
B777CMD_toggle_smartKnobs              = deferred_command("Strato/777/options/smartKnobs_toggle", "Toggle Smart Knobs", smartKnobs_toggle_CMDHandler)
B777CMD_toggle_gsInd                   = deferred_command("Strato/777/options/gsInd_mode_toggle", "Toggle GS/MACH Indicator", gsInd_toggle_CMDHandler)
B777CMD_toggle_trsInd                  = deferred_command("Strato/777/options/trsInd_toggle", "Toggle TRS Indicator", trsInd_toggle_CMDHandler)
B777CMD_toggle_aoaInd                  = deferred_command("Strato/777/options/aoaInd_toggle", "Toggle AOA Indicator", aoaInd_toggle_CMDHandler)
B777CMD_toggle_acfType                 = deferred_command("Strato/777/options/acfType_toggle", "Toggle Aircraft Type", acfType_toggle_CMDHandler)

--*************************************************************************************--
--**                                  EVENT CALLBACKS                                **--
--*************************************************************************************--

--function aircraft_load()

--function aircraft_unload()

function flight_start()
   avitabEnabled = 1 -- change to 0 once ui made
   B777DR_efb_page = 1
   run_after_time(efb_boot, 3)
end

--function flight_crash()

--function livery_load()

--function before_physics()

function after_physics()
   local temp1, temp2 = B777DR_newsimconfig_data, B777DR_simconfig_data -- keep data fresh
   if B777DR_newsimconfig_data == 1 and B777DR_simconfig_data:len() > 2 then
      simConfigData = json.decode(B777DR_simconfig_data)
   end

   if B777DR_efb_page == 0 or B777DR_efb_page == 1000 then -- off, or avitab
      B777DR_efb_page_type = 0
   else
      B777DR_efb_page_type = pages[B777DR_efb_page].type
   end
end

--function after_replay()