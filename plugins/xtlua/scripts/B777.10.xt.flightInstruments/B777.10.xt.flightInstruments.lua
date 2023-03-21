--[[
*****************************************************************************************
* Script Name: flightInstruments
* Author Name: remenkemi (crazytimtimtim)
* Script Description: Code for cockpit instruments
Plan:
dataref for pilot and copilot inboard knob
knob sets display anim
combine with buttons up top
adjust brightness accordingly

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
--[[
B777DR_inboard_disp_sel_target_capt    = deferred_dataref("Strato/777/inboard_disp_sel_target_capt", "number")
B777DR_inboard_disp_sel_target_fo      = deferred_dataref("Strato/777/inboard_disp_sel_target_fo", "number")
B777DR_inboard_disp_sel_pos_capt       = deferred_dataref("Strato/777/inboard_disp_sel_pos_capt", "number")
B777DR_inboard_disp_sel_pos_fo         = deferred_dataref("Strato/777/inboard_disp_sel_pos_fo", "number")
B777DR_display_pos                     = deferred_dataref("Strato/777/display_pos", "array[5]")
B777DR_mfd_pos                         = deferred_dataref("Strato/777/mfd_pos", "array[3]")
B77CMD_mfd_ctr                         = deferred_command("Strato/777/mfd_ctr", "Set Lower DU to MFD", mfd_ctr_cmdHandler)
B777CMD_mfd_l                          = deferred_command("Strato/777/mfd_l", "Set Left Inboard DU to MFD", mfd_l_cmdHandler)
B777CMD_mfd_r                          = deferred_command("Strato/777/mfd_r", "Set Right Inboard DU to MFD", mfd_r_cmdHandler)]]

--[[if simDR_window_heat1 == 0 then
		window_heat1_target = 0
	elseif simDR_window_heat1 == 1 then
		if simDR_window_heat1_fail ~= 6 then
			if simDR_bus1_volts > 10 or simDR_bus2_volts > 10 then
				if simDR_gear_on_ground == 1 then
					window_heat1_target = 8
				elseif simDR_gear_on_ground == 0 then
					window_heat1_target = 13
				end
			elseif simDR_bus1_volts < 10 and simDR_bus2_volts < 10 then
				window_heat1_target = 0
			end
		elseif simDR_window_heat1_fail == 6 then
			window_heat1_target = 0
		end
	end

-- f/o window

	if simDR_window_heat2 == 0 then
		window_heat2_target = 0
	elseif simDR_window_heat2 == 1 then
		if simDR_window_heat2_fail ~= 6 then
			if simDR_bus1_volts > 10 or simDR_bus2_volts > 10 then
				if simDR_gear_on_ground == 1 then
					window_heat2_target = 8
				elseif simDR_gear_on_ground == 0 then
					window_heat2_target = 13
				end
			elseif simDR_bus1_volts < 10 and simDR_bus2_volts < 10 then
				window_heat2_target = 0
			end
		elseif simDR_window_heat2_fail == 6 then
			window_heat2_target = 0
		end
	end

-- left side windows

	if simDR_window_heat3 == 0 then
		window_heat3_target = 0
	elseif simDR_window_heat3 == 1 then
		if simDR_window_heat3_fail ~= 6 then
			if simDR_bus1_volts > 10 or simDR_bus2_volts > 10 then
				window_heat3_target = 8
			elseif simDR_bus1_volts < 10 and simDR_bus2_volts < 10 then
				window_heat3_target = 0
			end
		elseif simDR_window_heat3_fail == 6 then
			window_heat3_target = 0
		end
	end

-- right side windows

	if simDR_window_heat4 == 0 then
		window_heat4_target = 0
	elseif simDR_window_heat4 == 1 then
		if simDR_window_heat4_fail ~= 6 then
			if simDR_bus1_volts > 10 or simDR_bus2_volts > 10 then
				window_heat4_target = 8
			elseif simDR_bus1_volts < 10 and simDR_bus2_volts < 10 then
				window_heat4_target = 0
			end
		elseif simDR_window_heat4_fail == 6 then
			window_heat4_target = 0
		end
	end

	A333_window1_temp = A333_set_animation_position(A333_window1_temp, window_heat1_target, 0, 13, 0.04)
	A333_window2_temp = A333_set_animation_position(A333_window2_temp, window_heat2_target, 0, 13, 0.04)
	A333_window3_temp = A333_set_animation_position(A333_window3_temp, window_heat3_target, 0, 8, 0.06)
	A333_window4_temp = A333_set_animation_position(A333_window4_temp, window_heat4_target, 0, 8, 0.06)
	

	
	]]

--B777DR_bank_limit_knob_anim            = deferred_dataref("Strato/777/bank_limit_knob_pos", "number")
--window heat 110f
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

local kgs_to_lbs = 2.204623
local hpa_to_inhg = 33.863892
local ft_to_mtrs = 0.3048
local kts_to_mach = 0.001512
local INHG_PER_QNH = 0.029530

local adiru_time_remaining_min = 0

local press_counter = 0
local knob_is_fast = 0

local minimumsFlashCount = {0,0}
local iasFlashCount = {0,0}
local minsFlashed = {false, false}
local iasFlashed = {false, false}

local rudderTrimTarget = 1
--*************************************************************************************--
--**                              FIND X-PLANE DATAREFS                              **--
--*************************************************************************************--
simDR_autopilot_alt                    = find_dataref("sim/cockpit2/autopilot/altitude_dial_ft")
simDR_startup_running                  = find_dataref("sim/operation/prefs/startup_running")
simDR_com1_stby_khz                    = find_dataref("sim/cockpit2/radios/actuators/com1_standby_frequency_khz")
simDR_com1_act_khz                     = find_dataref("sim/cockpit2/radios/actuators/com1_frequency_khz")
simDR_com2_stby_khz                    = find_dataref("sim/cockpit2/radios/actuators/com2_standby_frequency_khz")
simDR_com2_act_khz                     = find_dataref("sim/cockpit2/radios/actuators/com2_frequency_khz")
simDR_fuel_kgs                         = find_dataref("sim/cockpit2/fuel/fuel_quantity")
simDR_vs                               = {find_dataref("sim/cockpit2/gauges/indicators/vvi_fpm_pilot"), find_dataref("sim/cockpit2/gauges/indicators/vvi_fpm_copilot")}
simDR_ias                              = {find_dataref("sim/cockpit2/gauges/indicators/airspeed_kts_pilot"), find_dataref("sim/cockpit2/gauges/indicators/airspeed_kts_copilot")}
simDR_latitude                         = find_dataref("sim/flightmodel/position/latitude")
simDR_groundSpeed                      = find_dataref("sim/cockpit2/gauges/indicators/ground_speed_kt")
simDR_bus_voltage                      = find_dataref("sim/cockpit2/electrical/bus_volts")
simDR_ap_airspeed                      = find_dataref("sim/cockpit/autopilot/airspeed")
simDR_alt_ft                           = {find_dataref("sim/cockpit2/gauges/indicators/altitude_ft_pilot"), find_dataref("sim/cockpit2/gauges/indicators/altitude_ft_copilot")}
simDR_autopilot_alt                    = find_dataref("sim/cockpit/autopilot/altitude")
simDR_aoa                              = {find_dataref("sim/cockpit2/gauges/indicators/AoA_pilot"), find_dataref("sim/cockpit2/gauges/indicators/AoA_copilot")}
simDR_radio_alt                        = {find_dataref("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot"), find_dataref("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_copilot")}
simDR_onGround                         = find_dataref("sim/flightmodel/failures/onground_any")
simDR_vertical_speed                   = {find_dataref("sim/cockpit2/gauges/indicators/vvi_fpm_pilot"), find_dataref("sim/cockpit2/gauges/indicators/vvi_fpm_copilot")}
simDR_hdg_bug                          = find_dataref("sim/cockpit/autopilot/heading_mag")
simDR_hdg                              = {find_dataref("sim/cockpit2/gauges/indicators/heading_AHARS_deg_mag_pilot"), find_dataref("sim/cockpit2/gauges/indicators/heading_AHARS_deg_mag_copilot")}
simDR_airspeed_mach                    = {find_dataref("sim/cockpit2/gauges/indicators/mach_pilot"), find_dataref("sim/cockpit2/gauges/indicators/mach_copilot")}
simDR_efis_vor                         = {find_dataref("sim/cockpit2/EFIS/EFIS_vor_on"), find_dataref("sim/cockpit2/EFIS/EFIS_vor_on_copilot")}
simDR_efis_ndb                         = {find_dataref("sim/cockpit2/EFIS/EFIS_ndb_on"), find_dataref("sim/cockpit2/EFIS/EFIS_ndb_on_copilot")}
simDR_spd_trend                        = {find_dataref("sim/cockpit2/gauges/indicators/airspeed_acceleration_kts_sec_pilot"), find_dataref("sim/cockpit2/gauges/indicators/airspeed_acceleration_kts_sec_copilot")}
simDR_altimiter_setting                = {find_dataref("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot"), find_dataref("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot")}
simDR_airspeed_is_mach                 = find_dataref("sim/cockpit/autopilot/airspeed_is_mach")
simDR_instrument_brt                   = find_dataref("sim/cockpit2/switches/instrument_brightness_ratio")
simDR_map_hsi                          = {find_dataref("sim/cockpit2/EFIS/map_mode_is_HSI"), find_dataref("sim/cockpit2/EFIS/map_mode_is_HSI_copilot")}
simDR_map_mode                         = {find_dataref("sim/cockpit2/EFIS/map_mode"), find_dataref("sim/cockpit2/EFIS/map_mode_copilot")}
simDR_map_range                        = {find_dataref("sim/cockpit2/EFIS/map_range"), find_dataref("sim/cockpit2/EFIS/map_range_copilot")}
simDR_map_steps                        = find_dataref("sim/cockpit2/EFIS/map_range_steps")
--*************************************************************************************--
--**                              FIND CUSTOM DATAREFS                               **--
--*************************************************************************************--
B777DR_hyd_press                       = find_dataref("Strato/777/hydraulics/press")
B777DR_ovhd_aft_button_target          = find_dataref("Strato/777/cockpit/ovhd/aft/buttons/target")
B777DR_vstall                          = find_dataref("Strato/777/fctl/vstall")
B777DR_vmax                            = find_dataref("Strato/777/fctl/vmax")
B777DR_trimref                         = find_dataref("Strato/777/fctl/trs")
B777DR_vman_min                        = find_dataref("Strato/777/fctl/vmanuever")
B777DR_cockpit_door_target             = find_dataref("Strato/cockpit/door_target")
B777DR_ace_fail                        = find_dataref("Strato/777/failures/fctl/ace")

B777DR_unlocked                        = find_dataref("Strato/777/readme_unlocked")
B777DR_cockpit_door_pos                = find_dataref("Strato/777/cockpit_door_pos")
B777R_rudder_trim_man                  = find_dataref("Strato/777/fctl/ace/rud_trim_man")
B777R_rudder_trim_auto                 = find_dataref("Strato/777/fctl/ace/rud_trim_auto")
--*************************************************************************************--
--**                             CUSTOM DATAREF HANDLERS                             **--
--*************************************************************************************--

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
--*************************************************************************************--
--**                             X-PLANE COMMAND HANDLERS                            **--
--*************************************************************************************--

--*************************************************************************************--
--**                                 X-PLANE COMMANDS                                **--
--*************************************************************************************--

---EFIS----------
simCMD_efis_wxr                          = find_command("sim/instruments/EFIS_wxr")
simCMD_efis_tfc                          = find_command("sim/instruments/EFIS_tcas")
simCMD_efis_fix                          = find_command("sim/instruments/EFIS_fix")
simCMD_efis_vor                          = find_command("sim/instruments/EFIS_vor")
simCMD_efis_ndb                          = find_command("sim/instruments/EFIS_ndb")
simCMD_efis_apt                          = find_command("sim/instruments/EFIS_apt")
simCMD_efis_terr                         = find_command("sim/instruments/EFIS_terr")

simCMD_efis_fo_wxr                       = find_command("sim/instruments/EFIS_copilot_wxr")
simCMD_efis_fo_tfc                       = find_command("sim/instruments/EFIS_copilot_tcas")
simCMD_efis_fo_fix                       = find_command("sim/instruments/EFIS_copilot_fix")
simCMD_efis_fo_vor                       = find_command("sim/instruments/EFIS_copilot_vor")
simCMD_efis_fo_ndb                       = find_command("sim/instruments/EFIS_copilot_ndb")
simCMD_efis_fo_apt                       = find_command("sim/instruments/EFIS_copilot_apt")
simCMD_efis_fo_terr                      = find_command("sim/instruments/EFIS_copilot_terr")

simCMD_rudder_trim_l                     = find_command("sim/flight_controls/rudder_trim_left")
simCMD_rudder_trim_r                     = find_command("sim/flight_controls/rudder_trim_right")

B777CMD_efis_rcl                         = find_command("Strato/777/commands/glareshield/recall")
--*************************************************************************************--
--**                             CUSTOM COMMAND HANDLERS                             **--
--*************************************************************************************--
---EFIS----------

function B777_efis_lEicas_rcl_switch_CMDhandler(phase, duration)
	if B777DR_cdu_eicas_ctl_any == 0 then
		if phase == 0 then
			B777DR_efis_button_target[32] = 1
			B777CMD_efis_rcl:once()
		elseif phase == 2 then
			B777DR_efis_button_target[32] = 0
		end
	end
end

function B777_efis_lEicas_eng_switch_CMDhandler(phase, duration)
	if B777DR_cdu_eicas_ctl_any == 0 then
		if phase == 0 then
			setEicasPage(4)
			B777DR_efis_button_target[21] = 1
		elseif phase == 2 then
			B777DR_efis_button_target[21] = 0
		end
	end
end

function B777_efis_lEicas_stat_switch_CMDhandler(phase, duration)
	if B777DR_cdu_eicas_ctl_any == 0 then
		if phase == 0 then
			setEicasPage(9)
			B777DR_efis_button_target[22] = 1
		elseif phase == 2 then
			B777DR_efis_button_target[22] = 0
		end
	end
end

function B777_efis_lEicas_elec_switch_CMDhandler(phase, duration)
	if B777DR_cdu_eicas_ctl_any == 0 then
		if phase == 0 then
			setEicasPage(3)
			B777DR_efis_button_target[23] = 1
		elseif phase == 2 then
			B777DR_efis_button_target[23] = 0
		end
	end
end

function B777_efis_lEicas_hyd_switch_CMDhandler(phase, duration)
	if B777DR_cdu_eicas_ctl_any == 0 then
		if phase == 0 then
			setEicasPage(8)
			B777DR_efis_button_target[24] = 1
		elseif phase == 2 then
			B777DR_efis_button_target[24] = 0
		end
	end
end

function B777_efis_lEicas_fuel_switch_CMDhandler(phase, duration)
	if B777DR_cdu_eicas_ctl_any == 0 then
		if phase == 0 then
			setEicasPage(6)
			B777DR_efis_button_target[25] = 1
		elseif phase == 2 then
			B777DR_efis_button_target[25] = 0
		end
	end
end

function B777_efis_lEicas_air_switch_CMDhandler(phase, duration)
	if B777DR_cdu_eicas_ctl_any == 0 then
		if phase == 0 then
			setEicasPage(1)
			B777DR_efis_button_target[26] = 1
		elseif phase == 2 then
			B777DR_efis_button_target[26] = 0
		end
	end
end

function B777_efis_lEicas_door_switch_CMDhandler(phase, duration)
	if B777DR_cdu_eicas_ctl_any == 0 then
		if phase == 0 then
			setEicasPage(2)
			B777DR_efis_button_target[27] = 1
		elseif phase == 2 then
			B777DR_efis_button_target[27] = 0
		end
	end
end

function B777_efis_lEicas_gear_switch_CMDhandler(phase, duration)
	if B777DR_cdu_eicas_ctl_any == 0 then
		if phase == 0 then
			setEicasPage(7)
			B777DR_efis_button_target[28] = 1
		elseif phase == 2 then
			B777DR_efis_button_target[28] = 0
		end
	end
end

function B777_efis_lEicas_fctl_switch_CMDhandler(phase, duration)
	if B777DR_cdu_eicas_ctl_any == 0 then
		if phase == 0 then
			setEicasPage(5)
			B777DR_efis_button_target[29] = 1
		elseif phase == 2 then
			B777DR_efis_button_target[29] = 0
		end
	end
end

function B777_efis_lEicas_chkl_switch_CMDhandler(phase, duration)
	if B777DR_cdu_eicas_ctl_any == 0 then
		if phase == 0 then
			setEicasPage(10)
			B777DR_efis_button_target[31] = 1
		elseif phase == 2 then
			B777DR_efis_button_target[31] = 0
		end
	end
end

--[[function B777_efis_lEicas_cam_switch_CMDhandler(phase, duration)
	if B777DR_cdu_eicas_ctl_any == 0 then
		if phase == 0 then
			setEicasPage(11)
			B777DR_efis_button_target[30] = 1
		elseif phase == 2 then
			B777DR_efis_button_target[30] = 0
		end
	end
end]]

function B777_efis_wxr_switch_CMDhandler(phase, duration)
	if phase == 0 then
		B777DR_efis_button_target[1] = 1
		if B777DR_cdu_efis_ctl[0] == 0 then
			simCMD_efis_wxr:once()
		end
	elseif phase == 2 then
		B777DR_efis_button_target[1] = 0
	end
end

function B777_efis_sta_switch_CMDhandler(phase, duration)
	if phase == 0 then
		B777DR_efis_button_target[2] = 1
			if B777DR_cdu_efis_ctl[0] == 0 then
				B777DR_nd_sta[0] = 1 - B777DR_nd_sta[0]
			end
	elseif phase == 2 then
		B777DR_efis_button_target[2] = 0
	end
end

function B777_efis_sta_fmc_CMDhandler(phase, duration)
	if phase == 0 then
		B777DR_nd_sta[0] = 1 - B777DR_nd_sta[0]
	end
end

function B777_efis_wpt_switch_CMDhandler(phase, duration)
	if phase == 0 then
		B777DR_efis_button_target[3] = 1
			if B777DR_cdu_efis_ctl[0] == 0 then
				simCMD_efis_fix:once()
			end
	elseif phase == 2 then
		B777DR_efis_button_target[3] = 0
	end
end

function B777_efis_tfc_switch_CMDhandler(phase, duration)
	if phase == 0 then
		B777DR_efis_button_target[4] = 1
			if B777DR_cdu_efis_ctl[0] == 0 then
				simCMD_efis_tfc:once()
			end
	elseif phase == 2 then
		B777DR_efis_button_target[4] = 0
	end
end

function B777_efis_arpt_switch_CMDhandler(phase, duration)
	if phase == 0 then
		B777DR_efis_button_target[6] = 1
			if B777DR_cdu_efis_ctl[0] == 0 then
				simCMD_efis_apt:once()
			end
	elseif phase == 2 then
		B777DR_efis_button_target[6] = 0
	end
end

function B777_efis_terr_switch_CMDhandler(phase, duration)
	if phase == 0 then
		B777DR_efis_button_target[7] = 1
			if B777DR_cdu_efis_ctl[0] == 0 then
				simCMD_efis_terr:once()
			end
	elseif phase == 2 then
		B777DR_efis_button_target[7] = 0
	end
end

function B777_efis_wxr_fo_switch_CMDhandler(phase, duration)
	if phase == 0 then
		B777DR_efis_button_target[10] = 1
		if B777DR_cdu_efis_ctl[1] == 0 then
			simCMD_efis_fo_wxr:once()
		end
	elseif phase == 2 then
		B777DR_efis_button_target[10] = 0
	end
end

function B777_efis_sta_fo_switch_CMDhandler(phase, duration)
	if phase == 0 then
		B777DR_efis_button_target[11] = 1
		if B777DR_cdu_efis_ctl[1] == 0 then
			B777DR_nd_sta[1] = 1 - B777DR_nd_sta[1]
		end
	elseif phase == 2 then
		B777DR_efis_button_target[11] = 0
	end
end

function B777_efis_sta_fo_fmc_CMDhandler(phase, duration)
	if phase == 0 then
		B777DR_nd_sta[1] = 1 - B777DR_nd_sta[1]
	end
end

function B777_efis_wpt_fo_switch_CMDhandler(phase, duration)
	if phase == 0 then
		B777DR_efis_button_target[12] = 1
			if B777DR_cdu_efis_ctl[1] == 0 then
				simCMD_efis_fo_fix:once()
			end
	elseif phase == 2 then
		B777DR_efis_button_target[12] = 0
	end
end

function B777_efis_tfc_fo_switch_CMDhandler(phase, duration)
	if phase == 0 then
		B777DR_efis_button_target[13] = 1
			if B777DR_cdu_efis_ctl[1] == 0 then
				simCMD_efis_fo_tfc:once()
			end
	elseif phase == 2 then
		B777DR_efis_button_target[13] = 0
	end
end

function B777_efis_arpt_fo_switch_CMDhandler(phase, duration)
	if phase == 0 then
		B777DR_efis_button_target[13] = 1
			if B777DR_cdu_efis_ctl[1] == 0 then
				simCMD_efis_fo_apt:once()
			end
	elseif phase == 2 then
		B777DR_efis_button_target[13] = 0
	end
end

function B777_efis_terr_fo_switch_CMDhandler(phase, duration)
	if phase == 0 then
		B777DR_efis_button_target[13] = 1
			if B777DR_cdu_efis_ctl[1] == 0 then
				simCMD_efis_fo_terr:once()
			end
	elseif phase == 2 then
		B777DR_efis_button_target[13] = 0
	end
end

function B777_fltInst_adiru_switch_CMDhandler(phase, duration)
	if phase == 0 then
		if B777DR_ovhd_aft_button_target[1] == 1 then
			B777DR_ovhd_aft_button_target[1] = 0												-- move button to off
			if simDR_ias[1] <= 30 then run_after_time(B777_adiru_off, 2) end					-- turn adiru off
		elseif B777DR_ovhd_aft_button_target[1] == 0 then
			B777DR_ovhd_aft_button_target[1] = 1												-- move button to on
			if simDR_groundSpeed < 1 then
				adiru_time_remaining_min = 60 * (5 + math.abs(simDR_latitude) / 8.182)	-- set adiru alignment time to 5 + (distance from equator / 8.182)
				B777DR_adiru_status = 1
				countdown()
			end
		end
	end
end

function B777_fltInst_adiru_align_now_CMDhandler(phase, duration)
	if phase == 0 then
		B777DR_ovhd_aft_button_target[1] = 1
		B777_align_adiru()
	end
end

function B777_alt_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B777DR_alt_is_fast_ovrd == 0 then
			simDR_autopilot_alt = smartKnobUp(100, 1000, 50000, simDR_autopilot_alt)
		else
			simDR_autopilot_alt = simDR_autopilot_alt + 1000
		end
	end
end

function B777_alt_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B777DR_alt_is_fast_ovrd == 0 then
			simDR_autopilot_alt = smartKnobDn(100, 1000, 0, simDR_autopilot_alt)
		else
			simDR_autopilot_alt = simDR_autopilot_alt - 1000
		end
	end
end

function B777_minimums_dn_capt_CMDhandler(phase, duration)
	if phase == 0 and B777DR_cdu_efis_ctl[0] == 0 then
		if B777DR_minimums_mode[0] == 0 then
			B777DR_minimums_dh[0] = smartKnobDn(1, 10, 0, B777DR_minimums_dh[0])
		else
			B777DR_minimums_mda[0] = smartKnobDn(1, 10, -1000, B777DR_minimums_mda[0])
		end
		B777DR_minimums_visible[0] = 1
	end
end

function B777_minimums_up_capt_CMDhandler(phase, duration)
	if phase == 0 and B777DR_cdu_efis_ctl[0] == 0 then
		if B777DR_minimums_mode[0] == 0 then
			B777DR_minimums_dh[0] = smartKnobUp(1, 10, 1000, B777DR_minimums_dh[0])
		else
			B777DR_minimums_mda[0] = smartKnobUp(1, 10, 15000, B777DR_minimums_mda[0])
		end
		B777DR_minimums_visible[0] = 1
	end
end

function B777_minimums_dn_fo_CMDhandler(phase, duration)
	if phase == 0 and B777DR_cdu_efis_ctl[1] == 0 then
		if B777DR_minimums_mode[1] == 0 then
			B777DR_minimums_dh[1] = smartKnobDn(1, 10, 0, B777DR_minimums_dh[1])
		else
			B777DR_minimums_mda[1] = smartKnobDn(1, 10, -1000, B777DR_minimums_mda[1])
		end
		B777DR_minimums_visible[1] = 1
	end
end

function B777_minimums_up_fo_CMDhandler(phase, duration)
	if phase == 0 and B777DR_cdu_efis_ctl[1] == 0 then
		if B777DR_minimums_mode[1] == 0 then
			B777DR_minimums_dh[1] = smartKnobUp(1, 10, 1000, B777DR_minimums_dh[1])
		else
			B777DR_minimums_mda[1] = smartKnobUp(1, 10, 15000, B777DR_minimums_mda[1])
		end
		B777DR_minimums_visible[1] = 1
	end
end

function B777_minimums_rst_capt_CMDhandler(phase, duration)
	if phase == 0 and B777DR_cdu_efis_ctl[0] == 0 then
		stop_timer("minimums_flash_on_capt")
		stop_timer("minimums_flash_off_capt")
		B777DR_minimums_visible[0] = 0
		B777DR_amber_minimums[0] = 0
		minsFlashed[1] = false
		minimumsFlashCount[1] = 0
	end
end

function B777_minimums_rst_fo_CMDhandler(phase, duration)
	if phase == 0 and B777DR_cdu_efis_ctl[1] == 0 then
		stop_timer("minimums_flash_on_fo")
		stop_timer("minimums_flash_off_fo")
		B777DR_minimums_visible[1] = 0
		B777DR_amber_minimums[1] = 0
		minsFlashed[2] = false
		minimumsFlashCount[2] = 0
	end
end

function B777_minimums_rst_capt_fmc_CMDhandler(phase, duration)
	if phase == 0 then
		stop_timer("minimums_flash_on_capt")
		stop_timer("minimums_flash_off_capt")
		B777DR_minimums_visible[0] = 0
		B777DR_amber_minimums[0] = 0
		minsFlashed[1] = false
		minimumsFlashCount[1] = 0
	end
end

function B777_minimums_rst_fo_fmc_CMDhandler(phase, duration)
	if phase == 0 then
		stop_timer("minimums_flash_on_fo")
		stop_timer("minimums_flash_off_fo")
		B777DR_minimums_visible[1] = 0
		B777DR_amber_minimums[1] = 0
		minsFlashed[2] = false
		minimumsFlashCount[2] = 0
	end
end

function B777_efis_mtrs_capt_CMDhandler(phase, duration)
	if phase == 0 then
		if B777DR_cdu_efis_ctl[0] == 0 then
			B777DR_pfd_mtrs[0] = 1 - B777DR_pfd_mtrs[0]
		end
		B777DR_efis_button_target[8] = 1
	elseif phase == 2 then
		B777DR_efis_button_target[8] = 0
	end
end

function B777_efis_mtrs_fo_CMDhandler(phase, duration)
	if phase == 0 then
		if B777DR_cdu_efis_ctl[1] == 0 then
			B777DR_pfd_mtrs[1] = 1 - B777DR_pfd_mtrs[1]
		end
		B777DR_efis_button_target[9] = 1
	elseif phase == 2 then
		B777DR_efis_button_target[9] = 0
	end
end

function B777_hdg_up_cmdHandler(phase, duration)
	if phase == 0 then
		simDR_hdg_bug = smartKnobUp(1, 10, 361, simDR_hdg_bug)
	end
end

function B777_hdg_dn_cmdHandler(phase, duration)
	if phase == 0 then
		simDR_hdg_bug = smartKnobDn(1, 10, -1, simDR_hdg_bug)
	end
end

function B777_spd_up_cmdHandler(phase, duration)
	if phase == 0 then
		if simDR_airspeed_is_mach == 0 then
			simDR_ap_airspeed = smartKnobUp(1, 10, 399, simDR_ap_airspeed)
		else
			simDR_ap_airspeed = smartKnobUp(0.01, 0.1, 0.95, simDR_ap_airspeed)
		end
	end
end

function B777_spd_dn_cmdHandler(phase, duration)
	if phase == 0 then
		if simDR_airspeed_is_mach == 0 then
			simDR_ap_airspeed = smartKnobDn(1, 10, 100, simDR_ap_airspeed)
		else
			simDR_ap_airspeed = smartKnobDn(0.01, 0.1, 0.4, simDR_ap_airspeed)
		end
	end
end

function cduBrtIncr()
	for i = 0, 3 do
		if B777DR_show_cdu_brt[i] == 1 then
			B777DR_cdu_brt[i] = math.min(B777DR_cdu_brt[i] + 1, 23)
		end
	end
end

function cduBrtDecr()
	for i = 0, 3 do
		if B777DR_show_cdu_brt[i] == 1 then
			B777DR_cdu_brt[i] = math.max(B777DR_cdu_brt[i] - 1, 0)
		end
	end
end

function cduHideBrt()
	for i = 0, 3 do
		B777DR_show_cdu_brt[i] = 0
	end
end

function B777_fmsL_brt_up_cmdHandler(phase, duration)
	if phase == 0 then
		stop_timer(cduHideBrt)
		B777DR_show_cdu_brt[0] = 1
		B777DR_cdu_brt[0] = math.min(B777DR_cdu_brt[0] + 1, 23)
		B777DR_cdu_brt_dir[0] = 1
	elseif phase == 1 then
		if duration >= 0.5 and not is_timer_scheduled(cduBrtIncr) then
			run_after_time(cduBrtIncr, 0.5)
		end
	else
		run_after_time(cduHideBrt, 2)
		stop_timer(cduBrtIncr)
	end
end

function B777_fmsC_brt_up_cmdHandler(phase, duration)
	if phase == 0 then
		stop_timer(cduHideBrt)
		B777DR_show_cdu_brt[1] = 1
		B777DR_cdu_brt[1] = math.min(B777DR_cdu_brt[1] + 1, 23)
		B777DR_cdu_brt_dir[1] = 1
	elseif phase == 1 then
		if duration >= 0.5 and not is_timer_scheduled(cduBrtIncr) then
			run_after_time(cduBrtIncr, 0.5)
		end
	else
		run_after_time(cduHideBrt, 2)
		stop_timer(cduBrtIncr)
	end
end

function B777_fmsR_brt_up_cmdHandler(phase, duration)
	if phase == 0 then
		stop_timer(cduHideBrt)
		B777DR_show_cdu_brt[2] = 1
		B777DR_cdu_brt[2] = math.min(B777DR_cdu_brt[2] + 1, 23)
		B777DR_cdu_brt_dir[2] = 1
	elseif phase == 1 then
		if duration >= 0.5 and not is_timer_scheduled(cduBrtIncr) then
			run_after_time(cduBrtIncr, 0.5)
		end
	else
		run_after_time(cduHideBrt, 2)
		stop_timer(cduBrtIncr)
	end
end

function B777_fmsL_brt_dn_cmdHandler(phase, duration)
	if phase == 0 then
		stop_timer(cduHideBrt)
		B777DR_show_cdu_brt[0] = 1
		B777DR_cdu_brt[0] = math.max(B777DR_cdu_brt[0] - 1, 0)
		B777DR_cdu_brt_dir[0] = -1
	elseif phase == 1 then
		if duration >= 0.5 and not is_timer_scheduled(cduBrtDecr) then
			run_after_time(cduBrtDecr, 0.5)
		end
	else
		run_after_time(cduHideBrt, 2)
		stop_timer(cduBrtDecr)
	end
end

function B777_fmsC_brt_dn_cmdHandler(phase, duration)
	if phase == 0 then
		stop_timer(cduHideBrt)
		B777DR_show_cdu_brt[1] = 1
		B777DR_cdu_brt[1] = math.max(B777DR_cdu_brt[1] - 1, 0)
		B777DR_cdu_brt_dir[1] = -1
	elseif phase == 1 then
		if duration >= 0.5 and not is_timer_scheduled(cduBrtDecr) then
			run_after_time(cduBrtDecr, 0.5)
		end
	else
		run_after_time(cduHideBrt, 2)
		stop_timer(cduBrtDecr)
	end
end

function B777_fmsR_brt_dn_cmdHandler(phase, duration)
	if phase == 0 then
		stop_timer(cduHideBrt)
		B777DR_show_cdu_brt[2] = 1
		B777DR_cdu_brt[2] = math.max(B777DR_cdu_brt[2] - 1, 0)
		B777DR_cdu_brt_dir[2] = -1
	elseif phase == 1 then
		if duration >= 0.5 and not is_timer_scheduled(cduBrtDecr) then
			run_after_time(cduBrtDecr, 0.5)
		end
	else
		run_after_time(cduHideBrt, 2)
		stop_timer(cduBrtDecr)
	end
end

function B777_altm_baro_up_capt_CMDhandler(phase, duration)
	if phase == 0 and B777DR_cdu_efis_ctl[0] == 0 then
		if B777DR_baro_mode[0] == 0 then
			simDR_altimiter_setting[1] = smartKnobUp(0.01, 0.02, 31, simDR_altimiter_setting[1])
		else
			simDR_altimiter_setting[1] = smartKnobUp(INHG_PER_QNH, INHG_PER_QNH * 2, 31, simDR_altimiter_setting[1])
		end
	end
end

function B777_altm_baro_dn_capt_CMDhandler(phase, duration)
	if phase == 0 and B777DR_cdu_efis_ctl[0] == 0 then
		if B777DR_baro_mode[0] == 0 then
			simDR_altimiter_setting[1] = smartKnobDn(0.01, 0.02, 29, simDR_altimiter_setting[1])
		else
			simDR_altimiter_setting[1] = smartKnobDn(INHG_PER_QNH, INHG_PER_QNH * 2, 29, simDR_altimiter_setting[1])
		end
	end
end

function B777_altm_baro_up_fo_CMDhandler(phase, duration)
	if phase == 0 and B777DR_cdu_efis_ctl[1] == 0 then
		if B777DR_baro_mode[1] == 0 then
			simDR_altimiter_setting[2] = smartKnobUp(0.01, 0.02, 31, simDR_altimiter_setting[2])
		else
			simDR_altimiter_setting[2] = smartKnobUp(INHG_PER_QNH, INHG_PER_QNH * 2, 31, simDR_altimiter_setting[2])
		end
	end
end

function B777_altm_baro_dn_fo_CMDhandler(phase, duration)
	if phase == 0 and B777DR_cdu_efis_ctl[1] == 0 then
		if B777DR_baro_mode[1] == 0 then
			simDR_altimiter_setting[2] = smartKnobDn(0.01, 0.02, 29, simDR_altimiter_setting[2])
		else
			simDR_altimiter_setting[2] = smartKnobFn(INHG_PER_QNH, INHG_PER_QNH * 2, 29, simDR_altimiter_setting[2])
		end
	end
end

function B777_altm_baro_rst_capt_CMDhandler(phase, duration)
	if phase == 0 and B777DR_cdu_efis_ctl[0] == 0 then
		simDR_altimiter_setting[1] = 29.92
	end
end

function B777_altm_baro_rst_fo_CMDhandler(phase, duration)
	if phase == 0 and B777DR_cdu_efis_ctl[1] == 0 then
		simDR_altimiter_setting[2] = 29.92
	end
end

function B777_rudder_trim_l_CMDhandler(phase, duration)
	--[[if phase ~= 2 then
		rudderTrimTarget = 0
		simCMD_rudder_trim_l:once()
	else
		rudderTrimTarget = 1
	end]]
	if phase == 0 then
		rudderTrimTarget = 0
		simCMD_rudder_trim_l:start()
	elseif phase == 2 then
		rudderTrimTarget = 1
		simCMD_rudder_trim_l:stop()
	end
end

function B777_rudder_trim_r_CMDhandler(phase, duration)
	--[[if phase ~= 2 then
		rudderTrimTarget = 2
		simCMD_rudder_trim_r:once()
	else
		rudderTrimTarget = 1
	end]]
	if phase == 0 then
		rudderTrimTarget = 2
		simCMD_rudder_trim_r:start()
	elseif phase == 2 then
		rudderTrimTarget = 1
		simCMD_rudder_trim_r:stop()
	end
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
--**                                      CODE                                       **--
--*************************************************************************************--

--- Clocks ----------

--- ADIRU ----------
function countdown()
	if B777DR_adiru_status == 1 then
		if adiru_time_remaining_min > 1 then
			adiru_time_remaining_min = adiru_time_remaining_min - 1
			run_after_time(countdown2, 1)
		else
			B777_align_adiru()
		end
	end
end

function countdown2()
	adiru_time_remaining_min = adiru_time_remaining_min - 1
	run_after_time(countdown, 1)
end

function B777_adiru_off()
	B777DR_adiru_status = 0
	adiru_time_remaining_min = 0
end

function B777_align_adiru()
	B777DR_adiru_status = 2
	adiru_time_remaining_min = 0
end

---MINIMUMS----------

function minimums_flash_on_capt()
	if minimumsFlashCount[1] < 5 then
		minimumsFlashCount[1] = minimumsFlashCount[1] + 1
		B777DR_minimums_visible[0] = 1
		run_after_time(minimums_flash_off_capt, 0.3)
	else
		B777DR_minimums_visible[0] = 1
		minimumsFlashCount[1] = 0
		minsFlashed[1] = true
	end
end

function minimums_flash_off_capt()
	B777DR_minimums_visible[0] = 0
	run_after_time(minimums_flash_on_capt, 0.3)
end

function minimums_flash_on_fo()
	if minimumsFlashCount[2] < 5 then
		minimumsFlashCount[2] = minimumsFlashCount[2] + 1
		B777DR_minimums_visible[1] = 1
		run_after_time(minimums_flash_off_fo, 0.3)
	else
		B777DR_minimums_visible[1] = 1
		minimumsFlashCount[2] = 0
		minsFlashed[2] = true
	end
end

function minimums_flash_off_fo()
	B777DR_minimums_visible[1] = 0
	run_after_time(minimums_flash_on_fo, 0.3)
end

function minimums()
	for i = 0, 1 do
		if B777DR_minimums_mode[i] == 0 then
			B777DR_minimums_diff[i] = B777DR_minimums_dh[i] - simDR_radio_alt[i+1]
		else
			B777DR_minimums_diff[i] = B777DR_minimums_mda[i] - B777DR_displayed_alt[i]
		end

		if B777DR_minimums_diff[i] > 0 and B777DR_minimums_visible[i] == 1 and simDR_vertical_speed[i+1] < 0 and minimumsFlashCount[i+1] == 0 and not minsFlashed[i+1] then
			B777DR_amber_minimums[i] = 1
			if i == 0 then
				minimums_flash_off_capt()
			else
				minimums_flash_off_fo()
			end
		end

		if (B777DR_minimums_diff[i] < 0 or simDR_onGround == 1) and minsFlashed[i+1] then
			if i == 0 then
				stop_timer("minimums_flash_on_capt")
				stop_timer("minimums_flash_off_capt")
			else
				stop_timer("minimums_flash_on_fo")
				stop_timer("minimums_flash_off_fo")
			end
			B777DR_minimums_visible[i] = 1
			B777DR_amber_minimums[i] = 0
			minimumsFlashCount[i+1] = 0
			minsFlashed[i+1] = false
		end
	end
end

---MISC----------

function setAnimations()
	for i = 0, 1 do
		B777DR_minimums_mode_knob_anim[i] = B777_animate(B777DR_minimums_mode[i], B777DR_minimums_mode_knob_anim[i], 15)
		B777DR_baro_mode_knob_anim[i] = B777_animate(B777DR_baro_mode_knob[i], B777DR_baro_mode_knob_anim[i], 15)
	end
	B777DR_rudder_trim_pos = B777_animate(rudderTrimTarget, B777DR_rudder_trim_pos, 15)
end

function setDispAlt()
	for i = 0, 1 do
		if simDR_alt_ft[i+1] <= -1000 then
			B777DR_displayed_alt[i] = -1000
		elseif simDR_alt_ft[i+1] >= 47000 then
			B777DR_displayed_alt[i] = 47000
		else
			B777DR_displayed_alt[i] = simDR_alt_ft[i+1]
		end
	end
end

function setTXT()
	B777DR_txt_GS                  = "GS"
	B777DR_txt_TAS                 = "TAS"
	B777DR_txt_TIME_TO_ALIGN       = "TIME TO ALIGN"
	B777DR_txt_ddd                 = "---"
	B777DR_txt_INSTANT_ADIRU_ALIGN = "INSTANT ADIRU ALIGN"
	B777DR_txt_REALISTIC_PRK_BRK   = "REALISTIC PARK BRAKE"
	B777DR_txt_PASSENGER_FREIGHTER = "PASSENGER/FREIGHTER"
	B777DR_txt_LBS_KGS             = "POUNDS/KILOGRAMS"
	B777DR_txt_SHOW_TRS_BUG_ON_PFD = "SHOW TRS BUG ON PFD"
	B777DR_txt_PFD_AOA_INDICATOR   = "PFD AOA INDICATOR"
	B777DR_txt_SMART_MCP_KNOBS     = "SMART MCP KNOBS"
	B777DR_txt_MACH_GS_PFD         = "MACH AND GS ON PFD"
end

function getHeadingDifference(desireddirection,current_heading)
	diff = current_heading - desireddirection
	if diff >  180 then diff = diff - 360 end
	if diff < -180 then diff = diff + 360 end
	return diff
end

function setDiffs()
	for i = 0, 1 do
		B777DR_stall_tape_diff[i] = B777DR_vstall - B777DR_ias_indicator[i]
		B777DR_ovspd_tape_diff[i] = B777DR_vmax - B777DR_ias_indicator[i]
		B777DR_airspeed_bug_diff[i] = simDR_ap_airspeed - B777DR_ias_indicator[i]
		B777DR_alt_bug_diff[i] = simDR_autopilot_alt - B777DR_displayed_alt[i]
		B777DR_heading_bug_diff[i] = getHeadingDifference(simDR_hdg_bug, simDR_hdg[i+1])
		B777DR_trimref_tape_diff[i] = B777DR_trimref - B777DR_ias_indicator[i]
		B777DR_vman_tape_min_diff[i] = B777DR_vman_min - B777DR_ias_indicator[i]
	end
end

--- SMART KNOBS----------
function smartKnobUp(slow, fast, max, dataref)
	press_counter = press_counter + 1
	if not is_timer_scheduled(checkKnobSpd) then run_after_time(checkKnobSpd, 0.1) end
	if B777DR_smart_knobs == 1 and knob_is_fast == 1 then
		return math.min(dataref + fast, max)
	else
		return math.min(dataref + slow, max)
	end
end

function smartKnobDn(slow, fast, min, dataref)
	press_counter = press_counter + 1
	if not is_timer_scheduled(checkKnobSpd) then run_after_time(checkKnobSpd, 0.1) end
	if B777DR_smart_knobs == 1 and knob_is_fast == 1 then
		return math.max(dataref - fast, min)
	else
		return math.max(dataref - slow, min)
	end
end

function checkKnobSpd()
	if press_counter >= 4 then
		knob_is_fast = 1
		print("knob is fast")
	else
		knob_is_fast = 0
		print("knob is slow")
	end
	press_counter = 0
end

function spdTrend()
	for i = 0, 1 do
		if simDR_ias[i+1] > 30 and simDR_spd_trend[i+1] >= 0.4 then
			B777DR_show_spd_trend_pos[i] = 1
			B777DR_show_spd_trend_neg[i] = 0
		elseif simDR_ias[i+1] > 30 and simDR_spd_trend[i+1] <= -0.4 then
			B777DR_show_spd_trend_pos[i] = 0
			B777DR_show_spd_trend_neg[i] = 1
		else
			B777DR_show_spd_trend_pos[i] = 0
			B777DR_show_spd_trend_neg[i] = 0
		end
	end
end

function altimiter()
	for i = 0, 1 do
		if simDR_altimiter_setting[i+1] < 29.925 and simDR_altimiter_setting[i+1] > 29.915 then
			B777D_altimiter_std[i] = 1
		else
			B777D_altimiter_std[i] = 0
		end
	end
end

----- ANIMATION UTILITY -----------------------------------------------------------------
function B777_animate(target, variable, speed)
	if math.abs(target - variable) < 0.1 then return target end
	variable = variable + ((target - variable) * (speed * SIM_PERIOD))
	return variable
end

function dispIncrmt(input, increment)
	local inptMod = input % increment
	return input - (inptMod) + increment * roundNearest(inptMod / increment)
end

function roundNearest(x)
	return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end


function iasFlashCapt()
	if iasFlashCount[1] < 10 then
		iasFlashCount[1] = iasFlashCount[1] + 1
		B777DR_spd_flash[0] = 1
		run_after_time(iasFlashCapt2, 0.2)
	else
		B777DR_spd_flash[0] = 1
		iasFlashCount[1] = 0
		iasFlashed[1] = true
	end
end

function iasFlashCapt2()
	B777DR_spd_flash[0] = 0
	run_after_time(iasFlashCapt, 0.2)
end

function iasFlashFo()
	if iasFlashCount[2] < 10 then
		iasFlashCount[2] = iasFlashCount[2] + 1
		B777DR_spd_flash[1] = 1
		run_after_time(iasFlashFo2, 0.2)
	else
		B777DR_spd_flash[1] = 1
		iasFlashCount[2] = 0
		iasFlashed[2] = true
	end
end

function iasFlashFo2()
	B777DR_spd_flash[1] = 0
	run_after_time(iasFlashFo, 0.2)
end

--- MINIMUM MANEUVERING SPEED -----------
function vManeuverMin()
	for i = 0, 1 do
		if simDR_onGround == 0 and simDR_spd_trend[i+1] <= 0.4 and B777DR_vman_tape_min_diff[i] > 0 and iasFlashCount[i+1] == 0 and not iasFlashed[i+1] then
			B777DR_spd_amber[i] = 1
			if i == 0 then
				iasFlashCapt()
			else
				iasFlashFo()
			end
		end

		if simDR_onGround == 1 or B777DR_vman_tape_min_diff[i] < 0 then
			if i == 0 then
				stop_timer("iasFlashCapt")
				stop_timer("iasFlashCapt2")
			else
				stop_timer("iasFlashFo")
				stop_timer("iasFlashFo2")
			end
			B777DR_spd_flash[i] = 0
			iasFlashCount[i+1] = 0
			B777DR_spd_amber[i] = 0
			iasFlashed[i+1] = false
		end
	end
end

--- WEIGHT CONVERSIONS ----------
function weightConv()
	if B777DR_lbs_kgs == 1 then
		B777DR_fuel_lbs_total = (simDR_fuel_kgs[0] + simDR_fuel_kgs[1] + simDR_fuel_kgs[2]) * kgs_to_lbs
		for i = 0, 2 do
			B777DR_fuel_lbs[i] = simDR_fuel_kgs[i] * kgs_to_lbs
		end
		B777DR_lbs_kgs_status = "LBS"
	else
		B777DR_fuel_lbs_total = simDR_fuel_kgs[0] + simDR_fuel_kgs[1] + simDR_fuel_kgs[2]
		for i = 0, 2 do
			B777DR_fuel_lbs[i] = simDR_fuel_kgs[i]
		end
		B777DR_lbs_kgs_status = "KGS"
	end
end

function resetSpdOutlineCapt()
	B777DR_spd_outline[0] = 0
end

function checkForSpdOutlineCapt()
	if simDR_airspeed_mach[1] >= 0.4 and simDR_airspeed_mach[1] <= 0.401 then
		if not is_timer_scheduled(resetSpdOutlineCapt) then
			B777DR_spd_outline[0] = 1
			run_after_time(resetSpdOutlineCapt, 10)
		end
	end
end

function resetSpdOutlineFo()
	B777DR_spd_outline[1] = 0
end

function checkForSpdOutlineFo()
	if simDR_airspeed_mach[2] >= 0.4 and simDR_airspeed_mach[2] <= 0.401 then
		if not is_timer_scheduled(resetSpdOutlineFo) then
			B777DR_spd_outline[1] = 1
			run_after_time(resetSpdOutlineFo, 10)
		end
	end
end

function disableRAOutlineCapt()
	B777DR_outlined_RA[0] = 0
end

function checkForRaOutlineCapt()
	if simDR_onGround == 0 and simDR_radio_alt[1] <= 2500 and simDR_radio_alt[1] >= 2495 and simDR_vs[1] < 0 then
		if not is_timer_scheduled(disableRAOutlineCapt) then
			B777DR_outlined_RA[0] = 1
			run_after_time(disableRAOutlineCapt, 10)
		end
	end
end

function disableRAOutlineFo()
	B777DR_outlined_RA[1] = 0
end

function checkForRaOutlineFo()
	if simDR_onGround == 0 and simDR_radio_alt[2] <= 2500 and simDR_radio_alt[2] >= 2495 and simDR_vs[2] < 0 then
		if not is_timer_scheduled(disableRAOutlineFo) then
			B777DR_outlined_RA[1] = 1
			run_after_time(disableRAOutlineFo, 10)
		end
	end
end

function setDispRA()
	for i = 0, 1 do
		if simDR_radio_alt[i+1] > 100 then
			B777DR_displayed_ra[i] = dispIncrmt(simDR_radio_alt[i+1], 20)
		else
			B777DR_displayed_ra[i] = dispIncrmt(simDR_radio_alt[i+1], 2)
		end
	end
end

function setDispAOA()
	for i = 0, 1 do
		if B777DR_ias_indicator[i] < 80 then
			B777DR_displayed_aoa[i] = 0
		else
			B777DR_displayed_aoa[i] = dispIncrmt(simDR_aoa[i+1], 0.2)
		end
	end
end

function setDispVS()
	for i = 0, 1 do
		if simDR_vs[i+1] > 6000 then
			B777DR_vs_indicator[i] = 6000
		elseif simDR_vs[i+1] < -6000 then
			B777DR_vs_indicator[i] = -6000
		else
			B777DR_vs_indicator[i] = simDR_vs[i+1]
		end
	end
end

function setDispSPD()
	for i = 0, 1 do
		if simDR_ias[i+1] < 30 then
			B777DR_ias_indicator[i] = 30
		elseif simDR_ias[i+1] > 490 then
			B777DR_ias_indicator[i] = 490
		else
			B777DR_ias_indicator[i] = simDR_ias[i+1]
		end
	end
end

function setEicasPage(id)
	print(id)
	if B777DR_eicas_mode == id then
		B777DR_eicas_mode = 0
	else
		B777DR_eicas_mode = id
	end
end

function efis()
	--[[for i = 0, 13 do
		B777DR_efis_button_positions[i] = B777_animate(B777DR_efis_button_target[i], B777DR_efis_button_positions[i], 20)
	end
	B777DR_efis_button_positions[14] = B777_animate(B777DR_efis_vor_adf[0], B777DR_efis_button_positions[14], 20)
	B777DR_efis_button_positions[15] = B777_animate(B777DR_efis_vor_adf[1], B777DR_efis_button_positions[15], 20)
	B777DR_efis_button_positions[16] = B777_animate(B777DR_efis_vor_adf[2], B777DR_efis_button_positions[16], 20)
	B777DR_efis_button_positions[17] = B777_animate(B777DR_efis_vor_adf[3], B777DR_efis_button_positions[17], 20)]]

	for i = 0, 13 do
		B777DR_efis_button_positions[i] = B777DR_efis_button_target[i]
	end
	B777DR_efis_button_positions[14] = B777DR_efis_vor_adf[0]
	B777DR_efis_button_positions[15] = B777DR_efis_vor_adf[1]
	B777DR_efis_button_positions[16] = B777DR_efis_vor_adf[2]
	B777DR_efis_button_positions[17] = B777DR_efis_vor_adf[3]

	if B777DR_cdu_eicas_ctl[0] == 1 or B777DR_cdu_eicas_ctl[1] == 1 or B777DR_cdu_eicas_ctl[2] == 1 then
		B777DR_cdu_eicas_ctl_any = 1
	else
		B777DR_cdu_eicas_ctl_any = 0
	end

	for i = 0, 1 do
		if B777DR_cdu_efis_ctl[i] == 0 then
			if B777DR_nd_mode_selector[i] >= 2 then
				simDR_map_mode[i+1] = B777DR_nd_mode_selector[i] + 1
			else
				simDR_map_mode[i+1] = B777DR_nd_mode_selector[i]
			end

			simDR_map_range[i+1] = B777DR_map_zoom_knob[i]
			B777DR_minimums_mode[i] = B777DR_mins_mode_knob[i]
			B777DR_baro_mode[i] = B777DR_baro_mode_knob[i]
			simDR_efis_vor[i+1], simDR_efis_ndb[i+1] = B777DR_nd_sta[i], B777DR_nd_sta[i]
		end
	end

	for i = 21, 32 do
		B777DR_efis_button_positions[i] = B777DR_efis_button_target[i]
	end
end

function setMapSteps()
	simDR_map_steps[0] = 10
	simDR_map_steps[1] = 20
	simDR_map_steps[2] = 40
	simDR_map_steps[3] = 80
	simDR_map_steps[4] = 160
	simDR_map_steps[5] = 320
	simDR_map_steps[6] = 640
end

--*************************************************************************************--
--**                                  EVENT CALLBACKS                                **--
--*************************************************************************************--1

function aircraft_load()
	B777DR_eicas_mode = 4

	if simDR_startup_running == 1 then
		B777_align_adiru()
	end

	setTXT()
	B777DR_lbs_kgs = 1
	B777DR_aoa_enabled = 1
	B777DR_trs_bug_enabled = 1
	B777DR_smart_knobs = 1
	B777DR_pfd_mach_gs = 1
	B777CMD_efis_mtrs_capt:once()
	B777DR_minimums_dh[0] = 200
	B777DR_minimums_mda[0] = 400
	B777DR_minimums_dh[1] = 200
	B777DR_minimums_mda[1] = 400
	setMapSteps()

	for i = 0, 3 do
		B777DR_cdu_brt[i] = 23
	end
	print("flightIinstruments loaded")
end

--function aircraft_unload()

--function flight_start()

--function flight_crash()

--function livery_load()

--function before_physics()

function after_physics()
	B777DR_displayed_com1_act_khz = simDR_com1_act_khz / 1000
	B777DR_displayed_com1_stby_khz = simDR_com1_stby_khz / 1000

	B777DR_displayed_com2_act_khz = simDR_com2_act_khz / 1000
	B777DR_displayed_com2_stby_khz = simDR_com2_stby_khz / 1000

	if (simDR_groundSpeed >= 1 or (simDR_bus_voltage[0] == 0 and simDR_bus_voltage[1] == 0)) and B777DR_adiru_status == 1 then
		stop_timer(B777_align_adiru)
		B777_adiru_off()
	end

	B777DR_adiru_time_remaining_min = string.format("%2.0f", math.floor(adiru_time_remaining_min / 60)) -- %0.2f
	B777DR_adiru_time_remaining_sec = math.floor(adiru_time_remaining_min / 60 % 1 * 60)

	if B777DR_adiru_status == 1 then B777DR_temp_adiru_is_aligning = 1 else B777DR_temp_adiru_is_aligning = 0 end

--	print("time remaining min/sec: "..tonumber(B777DR_adiru_time_remaining_min.."."..B777DR_adiru_time_remaining_sec))

	B777DR_autopilot_alt_mtrs = simDR_autopilot_alt * ft_to_mtrs

	setDispAlt()
	setAnimations()
	minimums()
	setDiffs()
	vManeuverMin()
	weightConv()
	checkForSpdOutlineCapt()
	checkForSpdOutlineFo()
	setDispRA()
	setDispAOA()
	checkForRaOutlineCapt()
	checkForRaOutlineFo()
	setDispVS()
	setDispSPD()
	spdTrend()
	altimiter()
	efis()

	if B777DR_hyd_press[0] < 1200 or B777DR_hyd_press[1] < 1200 or B777DR_hyd_press[2] < 1200 then
		B777DR_hyd_press_low_any = 1
	else
		B777DR_hyd_press_low_any = 0
	end

	if B777DR_acf_is_freighter == 0 then
		B777DR_txt_PAX_FREIGHT = "PAX"
	else
		B777DR_txt_PAX_FREIGHT = "FREIGHT"
	end

	if B777DR_alt_is_fast_ovrd == 1 then
		alt_is_fast = 10
	end

	if B777DR_acf_is_freighter == 1 then
		B777DR_kill_pax = 1
		B777DR_kill_pax_interior = 1
		B777DR_kill_cargo = 0
		if B777DR_cockpit_door_pos > 0 then
			B777DR_kill_cargo_interior = 0
		else
			B777DR_kill_cargo_interior = 1
		end
	else
		B777DR_kill_cargo = 1
		B777DR_kill_cargo_interior = 1
		B777DR_kill_pax = 0
		if B777DR_cockpit_door_pos > 0 then
			B777DR_kill_pax_interior = 0
		else
			B777DR_kill_pax_interior = 1
		end
	end

	if B777DR_ace_fail[0] == 1 or B777DR_ace_fail[1] == 1 or B777DR_ace_fail[2] == 1 or B777DR_ace_fail[3] == 1 then
		B777DR_hyd_ace_fail_any = 1
	else
		B777DR_hyd_ace_fail_any = 0
	end


	if simDR_airspeed_is_mach == 0 then
		simDR_ap_airspeed = math.min(simDR_ap_airspeed, 399)
		simDR_ap_airspeed = math.max(simDR_ap_airspeed, 100)
	else
		simDR_ap_airspeed = math.min(simDR_ap_airspeed, 0.95)
		simDR_ap_airspeed = math.max(simDR_ap_airspeed, 0.4)
	end

	simDR_instrument_brt[6] = B777DR_cdu_brt[0] / 23
	simDR_instrument_brt[7] = B777DR_cdu_brt[1] / 23
	simDR_instrument_brt[8] = B777DR_cdu_brt[2] / 23

	B777DR_rudder_trim_total = B777R_rudder_trim_man + B777R_rudder_trim_auto
	B777DR_rudder_trim_total_abs = math.abs(B777DR_rudder_trim_total)
end

--function after_replay()