--[[
*****************************************************************************************
* Script Name: flightInstruments
* Author Name: remenkemi (crazytimtimtim)
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

B777CMD_rudder_trim_knob_l           = deferred_command("Strato/777/button_switch/rud_trim_l", "Rudder Trim Left", B777_rudder_trim_l_CMDhandler)
B777CMD_rudder_trim_knob_r           = deferred_command("Strato/777/button_switch/rud_trim_r", "Rudder Trim Right", B777_rudder_trim_r_CMDhandler)

B777CMD_fltInst_adiru_switch         = deferred_command("Strato/777/button_switch/fltInst/adiru_switch", "ADIRU Switch", B777_fltInst_adiru_switch_CMDhandler)
B777CMD_fltInst_adiru_align_now      = deferred_command("Strato/777/adiru_align_now", "Align ADIRU Instantly", B777_fltInst_adiru_align_now_CMDhandler)

B777CMD_ap_alt_up                    = deferred_command("Strato/777/autopilot/alt_up", "Autopilot Altitude Up", B777_alt_up_CMDhandler)
B777CMD_ap_alt_dn                    = deferred_command("Strato/777/autopilot/alt_dn", "Autopilot Altitude Down", B777_alt_dn_CMDhandler)
B777CMD_minimums_up                  = deferred_command("Strato/777/minimums_up_capt", "Captain Minimums Up", B777_minimums_up_capt_CMDhandler)
B777CMD_minimums_dn                  = deferred_command("Strato/777/minimums_dn_capt", "Captain Minimums Down", B777_minimums_dn_capt_CMDhandler)
B777CMD_minimums_up_fo               = deferred_command("Strato/777/minimums_up_fo", "F/O Minimums Up", B777_minimums_up_fo_CMDhandler)
B777CMD_minimums_dn_fo               = deferred_command("Strato/777/minimums_dn_fo", "F/O Minimums Down", B777_minimums_dn_fo_CMDhandler)
B777CMD_minimums_rst                 = deferred_command("Strato/777/minimums_rst_capt", "Captain Minimums Reset", B777_minimums_rst_capt_CMDhandler)
B777CMD_minimums_rst_fo              = deferred_command("Strato/777/minimums_rst_fo", "F/O Minimums Reset", B777_minimums_rst_fo_CMDhandler)
B777CMD_minimums_rst_fmc             = deferred_command("Strato/777/minimums_rst_capt_fmc", "Captain Minimums Reset (FMC)", B777_minimums_rst_capt_fmc_CMDhandler)
B777CMD_minimums_rst_fo_fmc          = deferred_command("Strato/777/minimums_rst_fo_fmc", "F/O Minimums Reset (FMC)", B777_minimums_rst_fo_fmc_CMDhandler)
B777CMD_efis_mtrs_capt               = deferred_command("Strato/777/efis_mtrs_capt", "Captain EFIS Meters Button", B777_efis_mtrs_capt_CMDhandler)
B777CMD_efis_mtrs_fo                 = deferred_command("Strato/777/efis_mtrs_fo", "F/O EFIS Meters Button", B777_efis_mtrs_fo_CMDhandler)

B777CMD_efis_lEicas_eng              = deferred_command("Strato/777/button_switch/efis/lEicas/eng", "Lower Eicas ENG Page", B777_efis_lEicas_eng_switch_CMDhandler)
B777CMD_efis_lEicas_stat             = deferred_command("Strato/777/button_switch/efis/lEicas/stat", "Lower Eicas STAT Page", B777_efis_lEicas_stat_switch_CMDhandler)
B777CMD_efis_lEicas_elec             = deferred_command("Strato/777/button_switch/efis/lEicas/elec", "Lower Eicas ELEC Page", B777_efis_lEicas_elec_switch_CMDhandler)
B777CMD_efis_lEicas_hyd              = deferred_command("Strato/777/button_switch/efis/lEicas/hyd", "Lower Eicas HYD Page", B777_efis_lEicas_hyd_switch_CMDhandler)
B777CMD_efis_lEicas_fuel             = deferred_command("Strato/777/button_switch/efis/lEicas/fuel", "Lower Eicas FUEL Page", B777_efis_lEicas_fuel_switch_CMDhandler)
B777CMD_efis_lEicas_air              = deferred_command("Strato/777/button_switch/efis/lEicas/air", "Lower Eicas AIR Page", B777_efis_lEicas_air_switch_CMDhandler)
B777CMD_efis_lEicas_door             = deferred_command("Strato/777/button_switch/efis/lEicas/door", "Lower Eicas DOOR Page", B777_efis_lEicas_door_switch_CMDhandler)
B777CMD_efis_lEicas_gear             = deferred_command("Strato/777/button_switch/efis/lEicas/gear", "Lower Eicas GEAR Page", B777_efis_lEicas_gear_switch_CMDhandler)
B777CMD_efis_lEicas_fctl             = deferred_command("Strato/777/button_switch/efis/lEicas/fctl", "Lower Eicas FCTL Page", B777_efis_lEicas_fctl_switch_CMDhandler)
--B777CMD_efis_lEicas_cam              = deferred_command("Strato/777/button_switch/efis/lEicas/cam", "Lower Eicas CAM Page", B777_efis_lEicas_cam_switch_CMDhandler)
B777CMD_efis_lEicas_chkl             = deferred_command("Strato/777/button_switch/efis/lEicas/chkl", "Lower Eicas CHKL Page", B777_efis_lEicas_chkl_switch_CMDhandler)
B777CMD_efis_lEicas_rcl              = deferred_command("Strato/777/button_switch/efis/lEicas/rcl", "Lower Eicas RECALL Button", B777_efis_lEicas_rcl_switch_CMDhandler)

B777CMD_efis_wxr_button              = deferred_command("Strato/777/button_switch/efis/wxr", "Captain ND Weather Radar Button", B777_efis_wxr_switch_CMDhandler)
B777CMD_efis_sta_button              = deferred_command("Strato/777/button_switch/efis/sta", "Captain ND STA Button", B777_efis_sta_switch_CMDhandler)
B777CMD_efis_wpt_button              = deferred_command("Strato/777/button_switch/efis/wpt", "Captain ND Waypoint Button", B777_efis_wpt_switch_CMDhandler)
B777CMD_efis_arpt_button             = deferred_command("Strato/777/button_switch/efis/arpt", "Captain ND Airport Button", B777_efis_arpt_switch_CMDhandler)
B777CMD_efis_terr_button             = deferred_command("Strato/777/button_switch/efis/terr", "Captain ND Terrain Button", B777_efis_terr_switch_CMDhandler)
B777CMD_efis_tfc_button              = deferred_command("Strato/777/button_switch/efis/tfc", "Captain ND Traffic Button", B777_efis_tfc_switch_CMDhandler)

B777CMD_efis_wxr_fo_button           = deferred_command("Strato/777/button_switch/efis/wxr_fo", "F/O ND Weather Radar Button", B777_efis_wxr_fo_switch_CMDhandler)
B777CMD_efis_sta_fo_button           = deferred_command("Strato/777/button_switch/efis/sta_fo", "F/O ND STA Button", B777_efis_sta_fo_switch_CMDhandler)
B777CMD_efis_wpt_fo_button           = deferred_command("Strato/777/button_switch/efis/wpt_fo", "F/O ND Waypoint Button", B777_efis_wpt_fo_switch_CMDhandler)
B777CMD_efis_arpt_fo_button          = deferred_command("Strato/777/button_switch/efis/arpt_fo", "F/O ND Airport Button", B777_efis_arpt_fo_switch_CMDhandler)
B777CMD_efis_terr_fo_button          = deferred_command("Strato/777/button_switch/efis/terr_fo", "F/O ND Terrain Button", B777_efis_terr_fo_switch_CMDhandler)
B777CMD_efis_tfc_fo_button           = deferred_command("Strato/777/button_switch/efis/tfc_fo", "F/O ND Traffic Button", B777_efis_tfc_fo_switch_CMDhandler)

B777CMD_efis_sta_fmc                 = deferred_command("Strato/777/button_switch/efis/sta_fmc", "Captain ND STA Button (FMC)", B777_efis_sta_fmc_CMDhandler)
B777CMD_efis_sta_fo_fmc              = deferred_command("Strato/777/button_switch/efis/sta_fo_fmc", "F/O ND STA Button (FMC) ", B777_efis_sta_fo_fmc_CMDhandler)

B777CMD_hdg_up                       = deferred_command("Strato/777/hdg_up", "Autpilot Heading Up", B777_hdg_up_cmdHandler)
B777CMD_hdg_dn                       = deferred_command("Strato/777/hdg_dn", "Autpilot Heading Down", B777_hdg_dn_cmdHandler)
B777CMD_spd_up                       = deferred_command("Strato/777/spd_up", "Autpilot Speed Up", B777_spd_up_cmdHandler)
B777CMD_spd_dn                       = deferred_command("Strato/777/spd_dn", "Autopilot Speed Down", B777_spd_dn_cmdHandler)

B777CMD_altm_baro_up                 = deferred_command("Strato/777/altm_baro_up_capt", "Captain Altimeter Setting Up", B777_altm_baro_up_capt_CMDhandler)
B777CMD_altm_baro_dn                 = deferred_command("Strato/777/altm_baro_dn_capt", "Captain Altimeter Setting Down", B777_altm_baro_dn_capt_CMDhandler)
B777CMD_altm_baro_up_fo              = deferred_command("Strato/777/altm_baro_up_fo", "F/O Altimeter Setting Up", B777_altm_baro_up_fo_CMDhandler)
B777CMD_altm_baro_dn_fo              = deferred_command("Strato/777/altm_baro_dn_fo", "F/O Altimeter Setting Down", B777_altm_baro_dn_fo_CMDhandler)
B777CMD_altm_baro_rst                = deferred_command("Strato/777/altm_baro_rst_capt", "Captain Altimeter Setting Reset", B777_altm_baro_rst_capt_CMDhandler)
B777CMD_altm_baro_rst_fo             = deferred_command("Strato/777/altm_baro_rst_fo", "F/O Altimeter Setting Reset", B777_altm_baro_rst_fo_CMDhandler)

B777CMD_fmsL_brt_up                  = deferred_command("Strato/777/fmsL_brt_up", "FMS L Brightness Up", B777_fmsL_brt_up_cmdHandler)
B777CMD_fmsL_brt_dn                  = deferred_command("Strato/777/fmsL_brt_dn", "FMS L Brightness Down", B777_fmsL_brt_dn_cmdHandler)
B777CMD_fmsC_brt_up                  = deferred_command("Strato/777/fmsC_brt_up", "FMS C Brightness Up", B777_fmsC_brt_up_cmdHandler)
B777CMD_fmsC_brt_dn                  = deferred_command("Strato/777/fmsC_brt_dn", "FMS C Brightness Down", B777_fmsC_brt_dn_cmdHandler)
B777CMD_fmsR_brt_up                  = deferred_command("Strato/777/fmsR_brt_up", "FMS R Brightness Up", B777_fmsR_brt_up_cmdHandler)
B777CMD_fmsR_brt_dn                  = deferred_command("Strato/777/fmsR_brt_dn", "FMS R Brightness Down", B777_fmsR_brt_dn_cmdHandler)

--*************************************************************************************--
--**                              CREATE CUSTOM DATAREFS                             **--
--*************************************************************************************--
B777DR_rudder_trim_total               = deferred_dataref("Strato/777/rudder_trim_total", "number")
B777DR_rudder_trim_total_abs           = deferred_dataref("Strato/777/rudder_trim_total_abs", "number")
B777DR_cdu_eicas_ctl_any               = deferred_dataref("Strato/777/cdu_eicas_ctl_any", "number")
B777DR_nd_mode_selector                = deferred_dataref("Strato/777/fltInst/nd_mode_selector", "array[2]")
B777DR_fuel_lbs                        = deferred_dataref("Strato/777/displays/fuel_lbs", "array[3]")
B777DR_fuel_lbs_total                  = deferred_dataref("Strato/777/displays/fuel_lbs_total", "number")
B777DR_alt_mtrs                        = deferred_dataref("Strato/777/displays/alt_mtrs", "array[2]")
B777DR_autopilot_alt_mtrs              = deferred_dataref("Strato/777/displays/autopilot_alt_mtrs", "number")
B777DR_eicas_mode                      = deferred_dataref("Strato/777/displays/eicas_mode", "number") -- what page the lower eicas is on

B777DR_displayed_com1_act_khz          = deferred_dataref("Strato/777/displays/com1_act_khz", "number") -- COM1 Radio Active Display
B777DR_displayed_com1_stby_khz         = deferred_dataref("Strato/777/displays/com1_stby_khz", "number") -- COM1 Radio Standby Display
B777DR_displayed_com2_act_khz          = deferred_dataref("Strato/777/displays/com2_act_khz", "number") -- COM2 Radio Active Display
B777DR_displayed_com2_stby_khz         = deferred_dataref("Strato/777/displays/com2_stby_khz", "number") -- COM2 Radio Standby Display

B777DR_vs_indicator                    = deferred_dataref("Strato/777/displays/vvi", "array[2]")
B777DR_ias_indicator                   = deferred_dataref("Strato/777/displays/ias", "array[2]")

B777DR_adiru_status                    = deferred_dataref("Strato/777/fltInst/adiru/status", "number") -- 0 = off, 1 = aligning 2 = aligned
B777DR_adiru_time_remaining_min        = deferred_dataref("Strato/777/fltInst/adiru/time_remaining_min", "number")
B777DR_adiru_time_remaining_sec        = deferred_dataref("Strato/777/fltInst/adiru/time_remaining_sec", "number")
B777DR_temp_adiru_is_aligning          = deferred_dataref("Strato/777/temp/fltInst/adiru/aligning", "number")

B777DR_airspeed_bug_diff               = deferred_dataref("Strato/777/airspeed_bug_diff", "array[2]")
B777DR_displayed_aoa                   = deferred_dataref("Strato/777/displayed_aoa", "array[2]")
B777DR_displayed_ra                    = deferred_dataref("Strato/777/displayed_ra", "array[2]")
B777DR_outlined_RA                     = deferred_dataref("Strato/777/outlined_RA", "array[2]")
B777DR_alt_is_fast_ovrd                = deferred_dataref("Strato/777/alt_step_knob_target", "number")
B777DR_displayed_alt                   = deferred_dataref("Strato/777/displays/displayed_alt", "array[2]")
B777DR_alt_bug_diff                    = deferred_dataref("Strato/777/displays/alt_bug_diff", "array[2]")
B777DR_baro_mode                       = deferred_dataref("Strato/777/baro_mode", "array[2]")
B777DR_baro_mode_knob                  = deferred_dataref("Strato/777/baro_mode_knob", "array[2]")
B777DR_minimums_mode                   = deferred_dataref("Strato/777/minimums_mode", "array[2]")
B777DR_minimums_diff                   = deferred_dataref("Strato/777/minimums_diff", "array[2]")
B777DR_minimums_visible                = deferred_dataref("Strato/777/minimums_visible", "array[2]")
B777DR_minimums_mda                    = deferred_dataref("Strato/777/minimums_mda", "array[2]")
B777DR_minimums_dh                     = deferred_dataref("Strato/777/minimums_dh", "array[2]")
B777DR_amber_minimums                  = deferred_dataref("Strato/777/amber_minimums", "array[2]")
B777DR_minimums_mode_knob_anim         = deferred_dataref("Strato/777/minimums_mode_knob_pos", "array[2]")
B777DR_baro_mode_knob_anim             = deferred_dataref("Strato/777/baro_mode_knob_pos", "array[2]")
B777DR_heading_bug_diff                = deferred_dataref("Strato/777/heading_bug_diff", "array[2]")
B777DR_hyd_press_low_any               = deferred_dataref("Strato/777/displays/hyd_press_low_any", "number")
B777DR_hyd_ace_fail_any                = deferred_dataref("Strato/777/displays/ace_fail_any", "number")
B777DR_stall_tape_diff                 = deferred_dataref("Strato/777/stall_tape_diff", "array[2]")
B777DR_ovspd_tape_diff                 = deferred_dataref("Strato/777/ovspd_tape_diff", "array[2]")
B777DR_trimref_tape_diff               = deferred_dataref("Strato/777/trimref_ovspd_diff", "array[2]")
B777DR_vman_tape_min_diff              = deferred_dataref("Strato/777/vmlo_tape_diff", "array[2]")
B777DR_spd_flash                       = deferred_dataref("Strato/777/displays/ias_flash", "array[2]")
B777DR_spd_outline                     = deferred_dataref("Strato/777/displays/ias_outline", "array[2]")
B777DR_show_spd_trend_pos              = deferred_dataref("Strato/777/show_spd_trend_pos", "array[2]")
B777DR_show_spd_trend_neg              = deferred_dataref("Strato/777/show_spd_trend_neg", "array[2]")
B777DR_spd_amber                       = deferred_dataref("Strato/777/displays/ias_amber", "array[2]")
B777D_altimiter_std                    = deferred_dataref("Strato/777/displays/alt_std", "array[2]")
B777DR_efis_vor_adf                    = deferred_dataref("Strato/777/efis/vor_adf", "array[4]") -- captain L, captain R, fo L, fo R
B777DR_cdu_efis_ctl                    = deferred_dataref("Strato/777/cdu_efis_ctl", "array[2]")
B777DR_cdu_eicas_ctl                   = deferred_dataref("Strato/777/cdu_eicas_ctl", "array[3]")
B777DR_cdu_brt                         = deferred_dataref("Strato/777/cdu_brt", "array[3]")
B777DR_show_cdu_brt                    = deferred_dataref("Strato/777/show_cdu_brt", "array[3]")
B777DR_cdu_brt_dir                     = deferred_dataref("Strato/777/cdu_brt_dir", "array[3]")

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
B777DR_txt_MACH_GS_PFD                 = deferred_dataref("Strato/777/displays/txt/MACH_GS_PFD", "string")

B777DR_acf_is_freighter                = deferred_dataref("Strato/777/acf_is_freighter", "number")
B777DR_lbs_kgs                         = deferred_dataref("Strato/777/lbs_kgs", "number")
B777DR_trs_bug_enabled                 = deferred_dataref("Strato/777/displays/trs_bug_enabled", "number")
B777DR_aoa_enabled                     = deferred_dataref("Strato/777/displays/pfd_aoa_enabled", "number")
B777DR_smart_knobs                     = deferred_dataref("Strato/777/smart_knobs", "number")
B777DR_pfd_mach_gs                     = deferred_dataref("Strato/777/pfd_mach_gs", "number")

B777DR_kill_pax_interior               = deferred_dataref("Strato/777/misc/kill_pax_interior", "number")
B777DR_kill_pax                        = deferred_dataref("Strato/777/misc/kill_pax", "number")
B777DR_kill_cargo_interior             = deferred_dataref("Strato/777/misc/kill_cargo_interior", "number")
B777DR_kill_cargo                      = deferred_dataref("Strato/777/misc/kill_cargo", "number")
B777DR_efis_button_positions           = deferred_dataref("Strato/777/cockpit/efis/buttons/position", "array[35]")
B777DR_efis_button_target              = deferred_dataref("Strato/777/cockpit/efis/buttons/target", "array[35]")

B777DR_pfd_mtrs                        = deferred_dataref("Strato/777/displays/mtrs", "array[2]")
B777DR_nd_sta                          = deferred_dataref("Strato/777/EFIS/sta", "array[2]")

B777DR_map_zoom_knob                   = deferred_dataref("Strato/777/map_zoom_knob", "array[2]")
B777DR_mins_mode_knob                  = deferred_dataref("Strato/777/mins_mode_knob", "array[2]")
B777DR_rudder_trim_pos                 = deferred_dataref("Strato/777/cockpit/rudder_trim_knob_pos", "number")