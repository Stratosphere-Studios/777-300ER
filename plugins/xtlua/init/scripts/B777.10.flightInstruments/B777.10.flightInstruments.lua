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
	--print("Deferreed dataref: "..name)
	dref=XLuaCreateDataRef(name, type,"yes",notifier)
	return wrap_dref_any(dref,type)
end

--*************************************************************************************--
--**                             CREATE CUSTOM COMMANDS                               **--
--*************************************************************************************--

B777CMD_fltInst_adiru_switch         = deferred_command("Strato/B777/button_switch/fltInst/adiru_switch", "ADIRU Switch", B777_fltInst_adiru_switch_CMDhandler)

B777CMD_fltInst_adiru_align_now      = deferred_command("Strato/B777/adiru_align_now", "Align ADIRU Instantly", B777_fltInst_adiru_align_now_CMDhandler)

B777CMD_ap_alt_up                    = deferred_command("Strato/B777/autopilot/alt_up", "Autopilot Altitude Up", B777_alt_up_CMDhandler)
B777CMD_ap_alt_dn                    = deferred_command("Strato/B777/autopilot/alt_dn", "Autopilot Altitude Down", B777_alt_dn_CMDhandler)

B777CMD_minimums_up                  = deferred_command("Strato/B777/minimums_up_capt", "Captain Minimums Up", B777_minimums_up_capt_CMDhandler)
B777CMD_minimums_dn                  = deferred_command("Strato/B777/minimums_dn_capt", "Captain Minimums Down", B777_minimums_dn_capt_CMDhandler)
B777CMD_minimums_rst                 = deferred_command("Strato/B777/minimums_rst_capt", "Captain Minimums Reset", B777_minimums_rst_capt_CMDhandler)

--*************************************************************************************--
--**                              CREATE CUSTOM DATAREFS                             **--
--*************************************************************************************--

B777DR_nd_mode_selector                = deferred_dataref("Strato/777/fltInst/nd_mode_selector", "number")
B777DR_fuel_lbs                        = deferred_dataref("Strato/777/displays/fuel_lbs", "array[3]")
B777DR_fuel_lbs_total                  = deferred_dataref("Strato/777/displays/fuel_lbs_total", "number")
B777DR_alt_mtrs_capt                   = deferred_dataref("Strato/777/displays/alt_mtrs_capt", "number")
B777DR_autopilot_alt_mtrs_capt         = deferred_dataref("Strato/777/displays/autopilot_alt_mtrs", "number")
B777DR_eicas_mode                      = deferred_dataref("Strato/777/displays/eicas_mode", "number") -- what page the lower eicas is on

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
B777DR_displayed_ra                    = deferred_dataref("Strato/777/displayed_ra", "number")
B777DR_outlined_RA                     = deferred_dataref("Strato/777/outlined_RA", "number")
B777DR_alt_is_fast_ovrd                = deferred_dataref("Strato/777/alt_step_knob_target", "number")
B777DR_displayed_alt                   = deferred_dataref("Strato/777/displays/displayed_alt", "number")
B777DR_alt_bug_diff                    = deferred_dataref("Strato/777/displays/alt_bug_diff", "number")
B777DR_baro_mode                       = deferred_dataref("Strato/777/baro_mode", "number")
B777DR_minimums_mode                   = deferred_dataref("Strato/777/minimums_mode", "number")
B777DR_minimums_diff                   = deferred_dataref("Strato/777/minimums_diff", "number")
B777DR_minimums_visible                = deferred_dataref("Strato/777/minimums_visible", "number")
B777DR_minimums_mda                    = deferred_dataref("Strato/777/minimums_mda", "number")
B777DR_minimums_dh                     = deferred_dataref("Strato/777/minimums_dh", "number")
B777DR_amber_minimums                  = deferred_dataref("Strato/777/amber_minimums", "number")
B777DR_minimums_mode_knob_anim         = deferred_dataref("Strato/777/minimums_mode_knob_pos", "number")
B777DR_baro_mode_knob_anim             = deferred_dataref("Strato/777/baro_mode_knob_pos", "number")
B777DR_heading_bug_diff                = deferred_dataref("Strato/777/heading_bug_diff", "number")
B777DR_hyd_press_low_any               = deferred_dataref("Strato/777/displays/hyd_press_low_any", "number")
B777DR_stall_tape_diff                 = deferred_dataref("Strato/777/stall_tape_diff", "number")
B777DR_ovspd_tape_diff                 = deferred_dataref("Strato/777/ovspd_tape_diff", "number")
B777DR_trimref_tape_diff               = deferred_dataref("Strato/777/trimref_ovspd_diff", "number")
B777DR_vman_tape_min_diff              = deferred_dataref("Strato/777/vmlo_tape_diff", "number")
--sim/cockpit2/autopilot/autothrottle_arm set to 0
-- Temporary datarefs for display text until custom textures are made
B777DR_txt_TIME_TO_ALIGN               = deferred_dataref("Strato/777/displays/txt/TIME_TO_ALIGN", "string")
B777DR_txt_GS                          = deferred_dataref("Strato/777/displays/txt/GS", "string")
B777DR_txt_TAS                         = deferred_dataref("Strato/777/displays/txt/TAS", "string")
B777DR_txt_ddd                         = deferred_dataref("Strato/777/displays/txt/---", "string")
B777DR_txt_INSTANT_ADIRU_ALIGN         = deferred_dataref("Strato/777/displays/txt/INSTANT_ADIRU_ALIGN", "string")
B777DR_txt_H                           = deferred_dataref("Strato/777/displays/txt/H", "string")
B777DR_txt_REALISTIC_PRK_BRK           = deferred_dataref("Strato/777/displays/txt/REALISTIC_PRK_BRK", "string")
B777DR_txt_PASSENGER_FREIGHTER         = deferred_dataref("Strato/777/displays/txt/PASSENGER_FREIGHTER", "string")
B777DR_txt_PAX_FREIGHT                 = deferred_dataref("Strato/777/displays/txt/PAX_FREIGHT", "string")
B777DR_txt_LBS_KGS                     = deferred_dataref("Strato/777/displays/txt/LBS_KGS", "string")
B777DR_lbs_kgs_status                  = deferred_dataref("Strato/777/displays/txt/lbs_kgs_status", "string")
B777DR_txt_SHOW_TRS_BUG_ON_PFD         = deferred_dataref("Strato/777/displays/txt/SHOW_TRS_BUG_ON_PFD", "string")
B777DR_txt_PFD_AOA_INDICATOR           = deferred_dataref("Strato/777/displays/txt/PFD_AOA_INDICATOR", "string")
B777DR_txt_SMART_MCP_KNOBS             = deferred_dataref("Strato/777/displays/txt/SMART_MCP_KNOBS", "string")

B777DR_acf_is_freighter                = deferred_dataref("Strato/777/acf_is_freighter", "number")
B777DR_acf_is_pax                      = deferred_dataref("Strato/777/acf_is_pax", "number")
B777DR_lbs_kgs                         = deferred_dataref("Strato/777/lbs_kgs", "number")
B777DR_trs_bug_enabled                 = deferred_dataref("Strato/777/displays/trs_bug_enabled", "number")
B777DR_aoa_enabled                     = deferred_dataref("Strato/777/displays/pfd_aoa_enabled", "number")
B777DR_spd_flash                       = deferred_dataref("Strato/777/displays/ias_flash", "number")
B777DR_spd_amber                       = deferred_dataref("Strato/777/displays/ias_amber", "number")
B777DR_spd_outline                     = deferred_dataref("Strato/777/displays/ias_outline", "number")
B777DR_smart_knobs                     = deferred_dataref("Strato/777/smart_knobs", "number")

B777DR_kill_pax_interior               = deferred_dataref("Strato/777/misc/kill_pax_interior", "number")
B777DR_kill_pax                        = deferred_dataref("Strato/777/misc/kill_pax", "number")
B777DR_kill_cargo_interior             = deferred_dataref("Strato/777/misc/kill_cargo_interior", "number")
B777DR_kill_cargo                      = deferred_dataref("Strato/777/misc/kill_cargo", "number")