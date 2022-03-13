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

B777CMD_efis_lEicas_eng              = deferred_command("Strato/B777/button_switch/efis/lEicas/eng", "Lower Eicas ENG Page", B777_efis_lEicas_eng_switch_CMDhandler)
B777CMD_efis_lEicas_stat             = deferred_command("Strato/B777/button_switch/efis/lEicas/stat", "Lower Eicas STAT Page", B777_efis_lEicas_stat_switch_CMDhandler)
B777CMD_efis_lEicas_elec             = deferred_command("Strato/B777/button_switch/efis/lEicas/elec", "Lower Eicas ELEC Page", B777_efis_lEicas_elec_switch_CMDhandler)
B777CMD_efis_lEicas_hyd              = deferred_command("Strato/B777/button_switch/efis/lEicas/hyd", "Lower Eicas HYD Page", B777_efis_lEicas_hyd_switch_CMDhandler)
B777CMD_efis_lEicas_fuel             = deferred_command("Strato/B777/button_switch/efis/lEicas/fuel", "Lower Eicas FUEL Page", B777_efis_lEicas_fuel_switch_CMDhandler)
B777CMD_efis_lEicas_air              = deferred_command("Strato/B777/button_switch/efis/lEicas/air", "Lower Eicas AIR Page", B777_efis_lEicas_air_switch_CMDhandler)
B777CMD_efis_lEicas_door             = deferred_command("Strato/B777/button_switch/efis/lEicas/door", "Lower Eicas DOOR Page", B777_efis_lEicas_door_switch_CMDhandler)
B777CMD_efis_lEicas_gear             = deferred_command("Strato/B777/button_switch/efis/lEicas/gear", "Lower Eicas GEAR Page", B777_efis_lEicas_gear_switch_CMDhandler)
B777CMD_efis_lEicas_fctl             = deferred_command("Strato/B777/button_switch/efis/lEicas/fctl", "Lower Eicas FCTL Page", B777_efis_lEicas_fctl_switch_CMDhandler)
B777CMD_efis_lEicas_cam              = deferred_command("Strato/B777/button_switch/efis/lEicas/cam", "Lower Eicas CAM Page", B777_efis_lEicas_cam_switch_CMDhandler)

B777CMD_fltInst_adiru_switch         = deferred_command("Strato/B777/button_switch/fltInst/adiru_switch", "ADIRU Switch", B777_fltInst_adiru_switch_CMDhandler)

--*************************************************************************************--
--**                              CREATE CUSTOM DATAREFS                             **--
--*************************************************************************************--

B777DR_total_fuel_lbs                  = deferred_dataref("Strato/777/displays/total_fuel_lbs", "number")
B777DR_r_fuel_lbs                      = deferred_dataref("Strato/777/displays/r_fuel_lbs", "number")
B777DR_l_fuel_lbs                      = deferred_dataref("Strato/777/displays/l_fuel_lbs", "number")

B777DR_displayed_hdg                   = deferred_dataref("Strato/777/displays/hdg", "number") -- what the MCP heading display actually shows
B777DR_hdg_mode                        = deferred_dataref("Strato/777/displays/hdg_mode", "number")
B777DR_pfd_mtrs_capt                   = deferred_dataref("Strato/777/displays/mtrs_capt", "number")

B777DR_eicas_mode                      = deferred_dataref("Strato/777/displays/eicas_mode", "number") -- what pages the lower eicas is on

B777DR_displayed_com1_act_khz          = deferred_dataref("Strato/777/displays/com1_act_khz", "number") -- COM1 Radio Active Display
B777DR_displayed_com1_stby_khz         = deferred_dataref("Strato/777/displays/com1_stby_khz", "number") -- COM1 Radio Standby Display

B777DR_displayed_com2_act_khz          = deferred_dataref("Strato/777/displays/com2_act_khz", "number") -- COM2 Radio Active Display
B777DR_displayed_com2_stby_khz         = deferred_dataref("Strato/777/displays/com2_stby_khz", "number") -- COM2 Radio Standby Display

B777DR_vs_capt_indicator               = deferred_dataref("Strato/777/displays/vvi_capt", "number")
B777DR_ias_capt_indicator              = deferred_dataref("Strato/777/displays/ias_capt", "number")

B777DR_adiru_aligned                   = deferred_dataref("Strato/777/fltInst/adiru_aligned", "number")
B777DR_adiru_align_time_remaining_sec  = deferred_dataref("Strato/777/fltInst_adiru_align_time_remaining_sec", "number")