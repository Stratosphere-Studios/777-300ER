--[[
*****************************************************************************************
* Script Name: flightInstruments
* Author Name: Crazytimtimtim
* Script Description: Inis script for cockpit instruments
*****************************************************************************************
--]]

--replace create_command
function deferred_command(name,desc,nilFunc)
	c = XLuaCreateCommand(name,desc)
	--print("Deferred command: "..name)
	--XLuaReplaceCommand(c,null_command)
	return nil --make_command_obj(c)
end

--replace create_dataref
function deferred_dataref(name,type,notifier)
	--print("Deffereed dataref: "..name)
	dref=XLuaCreateDataRef(name, type,"yes",notifier)
	return wrap_dref_any(dref,type)
end

--*************************************************************************************--
--**                             CREATE CUSTOM COMMANDS                               **--
--*************************************************************************************--

B777CMD_mcp_MAGtrk                   = deferred_command("Strato/B777/button_switch/mcp/MAGtrk", "Switch between true and magnetic heading", B777_mcp_magTRK_CMDhandler)

B777CMD_fltInst_adiru_switch         = deferred_command("Strato/B777/button_switch/fltInst/adiru_switch", "ADIRU Switch", B777_fltInst_adiru_switch_CMDhandler)

B777CMD_fltInst_adiru_align_now      = deferred_command("Strato/B777/adiru_align_now", "Align ADIRU Instantly", B777_fltInst_adiru_align_now_CMDhandler)

--*************************************************************************************--
--**                              CREATE CUSTOM DATAREFS                             **--
--*************************************************************************************--

B777DR_total_fuel_lbs                  = deferred_dataref("Strato/777/displays/total_fuel_lbs", "number")
B777DR_r_fuel_lbs                      = deferred_dataref("Strato/777/displays/r_fuel_lbs", "number")
B777DR_l_fuel_lbs                      = deferred_dataref("Strato/777/displays/l_fuel_lbs", "number")

B777DR_displayed_hdg                   = deferred_dataref("Strato/777/displays/hdg", "number") -- what the MCP heading display actually shows
B777DR_hdg_mode                        = deferred_dataref("Strato/777/displays/hdg_mode", "number")
B777DR_alt_mtrs_capt                   = deferred_dataref("Strato/777/displays/alt_mtrs_capt", "number")
B777DR_autopilot_alt_mtrs_capt         = deferred_dataref("Strato/777/displays/autopilot_alt_mtrs", "number")

B777DR_eicas_mode                      = deferred_dataref("Strato/777/displays/eicas_mode", "number") -- what pages the lower eicas is on

B777DR_displayed_com1_act_khz          = deferred_dataref("Strato/777/displays/com1_act_khz", "number") -- COM1 Radio Active Display
B777DR_displayed_com1_stby_khz         = deferred_dataref("Strato/777/displays/com1_stby_khz", "number") -- COM1 Radio Standby Display

B777DR_displayed_com2_act_khz          = deferred_dataref("Strato/777/displays/com2_act_khz", "number") -- COM2 Radio Active Display
B777DR_displayed_com2_stby_khz         = deferred_dataref("Strato/777/displays/com2_stby_khz", "number") -- COM2 Radio Standby Display

B777DR_vs_capt_indicator               = deferred_dataref("Strato/777/displays/vvi_capt", "number")
B777DR_ias_capt_indicator              = deferred_dataref("Strato/777/displays/ias_capt", "number")

B777DR_adiru_status                    = deferred_dataref("Strato/777/fltInst/adiru/status", "number") -- 0 = off, 1 = aligning 2 = aligned
B777DR_adiru_time_remaining_min        = deferred_dataref("Strato/777/fltInst/adiru/time_remaining_min", "number")
B777DR_adiru_time_remaining_sec        = deferred_dataref("Strato/777/fltInst/adiru/time_remaining_sec", "number")
B777DR_temp_adiru_is_aligning          = deferred_dataref("Strato/777/temp/fltInst/adiru/aligning", "number")

B777DR_airspeed_bug_diff               = deferred_dataref("Strato/777/airspeed_bug_diff", "number")
B777DR_displayed_aoa                   = deferred_dataref("Strato/777/displayed_aoa", "number")
B777DR_outlined_RA                     = deferred_dataref("Strato/777/outlined_RA", "number")

B777DR_txt_TIME_TO_ALIGN               = deferred_dataref("Strato/777/displays/txt/TIME_TO_ALIGN", "string")
B777DR_txt_GS                          = deferred_dataref("Strato/777/displays/txt/GS", "string")
B777DR_txt_ddd                         = deferred_dataref("Strato/777/displays/txt/---", "string")
B777DR_txt_INSTANT_ADIRU_ALIGN         = deferred_dataref("Strato/777/displays/txt/INSTANT_ADIRU_ALIGN", "string")
