--[[
*****************************************************************************************
* Script Name: flightInstruments
* Author Name: Crazytimtimtim
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

local B777_ft_to_mtrs = 0.3048
local B777_adiru_time_remaining_min = 0

local press_counter = 0
local knob_is_fast = 0

local minimumsFlashCount = 0
local iasFlashCount = 1

local kgs_to_lbs = 2.204623

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
simDR_vs_capt                          = find_dataref("sim/cockpit2/gauges/indicators/vvi_fpm_pilot")
simDR_ias_capt                         = find_dataref("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
simDR_latitude                         = find_dataref("sim/flightmodel/position/latitude")
simDR_groundSpeed                      = find_dataref("sim/flightmodel/position/groundspeed")
simDR_bus_voltage                      = find_dataref("sim/cockpit2/electrical/bus_volts")
simDR_ap_airspeed                      = find_dataref("sim/cockpit/autopilot/airspeed")
simDR_alt_ft_capt                      = find_dataref("sim/cockpit2/gauges/indicators/altitude_ft_pilot")
simDR_autopilot_alt                    = find_dataref("sim/cockpit/autopilot/altitude")
simDR_aoa                              = find_dataref("sim/flightmodel2/misc/AoA_angle_degrees")
simDR_radio_alt_capt                   = find_dataref("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")
simDR_onGround                         = find_dataref("sim/flightmodel/failures/onground_any")
simDR_vertical_speed                   = find_dataref("sim/cockpit2/gauges/indicators/vvi_fpm_pilot")
simDR_hdg_bug                          = find_dataref("sim/cockpit/autopilot/heading_mag")
simDR_hdg                              = find_dataref("sim/cockpit2/gauges/indicators/heading_AHARS_deg_mag_pilot")
simDR_map_mode                         = find_dataref("sim/cockpit/switches/EFIS_map_submode")
simDR_ias_trend                        = find_dataref("sim/cockpit2/gauges/indicators/airspeed_acceleration_kts_sec_pilot")
simDR_airspeed_mach                    = find_dataref("sim/flightmodel/misc/machno")


--*************************************************************************************--
--**                              FIND CUSTOM DATAREFS                               **--
--*************************************************************************************--
B777DR_hyd_press                       = find_dataref("Strato/777/hydraulics/press")
B777DR_ovhd_aft_button_target          = find_dataref("Strato/777/cockpit/ovhd/aft/buttons/target")
B777DR_vstall                          = find_dataref("Strato/777/fctl/vstall")
B777DR_vmax                            = find_dataref("Strato/777/fctl/vmax")
B777DR_trimref                         = find_dataref("Strato/777/fctl/trs")
B777DR_vman_min                        = find_dataref("Strato/777/fctl/vmanuever")

--*************************************************************************************--
--**                             CUSTOM DATAREF HANDLERS                             **--
--*************************************************************************************--

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

--*************************************************************************************--
--**                             X-PLANE COMMAND HANDLERS                            **--
--*************************************************************************************--
--[[
lasttime = time
time = simtime
if time - lasttime < x then
	fast
end
]]
--*************************************************************************************--
--**                                 X-PLANE COMMANDS                                **--
--*************************************************************************************--
simCMD_dh_dn_capt                     = find_command("sim/instruments/dh_ref_down")
simCMD_dh_up_capt                     = find_command("sim/instruments/dh_ref_up")
simCMD_mda_up_capt                    = find_command("sim/instruments/mda_ref_up")
simCMD_mda_dn_capt                    = find_command("sim/instruments/mda_ref_down")

--*************************************************************************************--
--**                             CUSTOM COMMAND HANDLERS                             **--
--*************************************************************************************--

function B777_fltInst_adiru_switch_CMDhandler(phase, duration)
	if phase == 0 then
		if B777DR_ovhd_aft_button_target[1] == 1 then
			B777DR_ovhd_aft_button_target[1] = 0												-- move button to off
			if simDR_ias_capt <= 30 then run_after_time(B777_adiru_off, 2) end					-- turn adiru off
		elseif B777DR_ovhd_aft_button_target[1] == 0 then
			B777DR_ovhd_aft_button_target[1] = 1												-- move button to on
			if simDR_groundSpeed < 1 then
				B777_adiru_time_remaining_min = 60 * (5 + math.abs(simDR_latitude) / 8.182)	-- set adiru alignment time to 5 + (distance from equator / 8.182)
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
--[[
function B777_alt_up_CMDhandler(phase, duration)
	if phase == 0 then
		simDR_autopilot_alt = math.min(simDR_autopilot_alt + (100 * alt_is_fast), 50000)
		alt_press_counter = alt_press_counter + 1
		if (not is_timer_scheduled(checkAltSpd)) then run_after_time(checkAltSpd, 0.2) end
	elseif phase == 2 then
		simDR_autopilot_alt = simDR_autopilot_alt + 1000
	end
end
]]

function B777_alt_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B777DR_alt_is_fast_ovrd == 0 then
			simDR_autopilot_alt = smartKnobUp(100, 1000, 50000, simDR_autopilot_alt)
		else
			simDR_autopilot_alt = smartKnobUp(1000, 1000, 50000, simDR_autopilot_alt)
		end
	end
end

function B777_alt_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B777DR_alt_is_fast_ovrd == 0 then
			simDR_autopilot_alt = smartKnobDn(100, 1000, 0, simDR_autopilot_alt)
		else
			simDR_autopilot_alt = smartKnobDn(1000, 1000, 0, simDR_autopilot_alt)
		end
	end
end

function B777_minimums_dn_capt_CMDhandler(phase, duration)
	if phase == 0  then
		if B777DR_minimums_mode == 0 then
			B777DR_minimums_dh = smartKnobDn(1, 10, 0, B777DR_minimums_dh)
		else
			B777DR_minimums_mda = smartKnobDn(1, 10, -1000, B777DR_minimums_mda)
		end
		B777DR_minimums_visible = 1
	end
end

function B777_minimums_up_capt_CMDhandler(phase, duration)
	if phase == 0  then
		if B777DR_minimums_mode == 0 then
			B777DR_minimums_dh = smartKnobUp(1, 10, 1000, B777DR_minimums_dh)
		else
			B777DR_minimums_mda = smartKnobUp(1, 10, 15000, B777DR_minimums_mda)
		end
		B777DR_minimums_visible = 1
	end
end

function B777_minimums_rst_capt_CMDhandler(phase, duration)
	if phase == 0 then
		B777DR_minimums_visible = 0
		B777DR_amber_minimums = 0
	end
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
--[[B777CMD_hdg_up                       = deferred_command("Strato/777/hdg_up", "Autpilot Heading Up", B777_hdg_up_cmdHandler)
B777CMD_hdg_dn                       = deferred_command("Strato/777/hdg_dn", "Autpilot Heading Down", B777_hdg_dn_cmdHandler)
B777CMD_spd_up                       = deferred_command("Strato/777/spd_up", "Autpilot Speed Up", B777_spd_up_cmdHandler)
B777CMD_spd_dn                       = deferred_command("Strato/777/spd_dn", "Autopilot Speed Down", B777_spd_dn_cmdHandler)]]

function B777_hdg_up_cmdHandler(phase, duration)
	if phase == 1 then
		simDR_hdg_bug = smartKnobUp(1, 10, 361, simDR_hdg_bug)
	end
end

function B777_hdg_dn_cmdHandler(phase, duration)
	if phase == 1 then
		simDR_hdg_bug = smartKnobUp(1, 10, -1, simDR_hdg_bug)
	end
end

function B777_spd_up_cmdHandler(phase, duration)
	if phase == 1 then
		simDR_ap_airspeed = smartKnobUp(1, 10, 400, simDR_ap_airspeed)
	end
end

function B777_spd_dn_cmdHandler(phase, duration)
	if phase == 1 then
		simDR_ap_airspeed = smartKnobUp(1, 10, 0, simDR_ap_airspeed)
	end
end

--*************************************************************************************--
--**                                      CODE                                       **--
--*************************************************************************************--

--- Clocks ----------

--- ADIRU ----------
function countdown()
	if B777DR_adiru_status == 1  then
		if B777_adiru_time_remaining_min > 1 then
			B777_adiru_time_remaining_min = B777_adiru_time_remaining_min - 1
			run_after_time(countdown2, 1)
		else
			B777_align_adiru()
		end
	end
end

function countdown2()
	B777_adiru_time_remaining_min = B777_adiru_time_remaining_min - 1
	run_after_time(countdown, 1)
end

function B777_adiru_off()
	B777DR_adiru_status = 0
	B777_adiru_time_remaining_min = 0
end

function B777_align_adiru()
	B777DR_adiru_status = 2
	B777_adiru_time_remaining_min = 0
end

function disableRAOutline()
	B777DR_outlined_RA = 0
end

---MINIMUMS----------

function minimums_flash_on()
	if minimumsFlashCount < 6 then
		minimumsFlashCount = minimumsFlashCount + 1
		run_after_time(minimums_flash_off, 0.5)
	else
		minimumsFlashCount = 0
		B777DR_minimums_visible = 1
	end
end

function minimums_flash_off()
	B777DR_minimums_visible = 0
	run_after_time(minimums_flash_on, 0.5)
end

function minimums()
	if B777DR_minimums_mode == 0 then
		B777DR_minimums_diff = B777DR_minimums_dh - simDR_radio_alt_capt
	else
		B777DR_minimums_diff = B777DR_minimums_mda - B777DR_displayed_alt
	end

	if simDR_vertical_speed < 0 then
		if B777DR_minimums_diff < 0 and B777DR_minimums_diff > -2 and B777DR_minimums_visible == 1 then
			minimums_flash_off()
			B777DR_amber_minimums = 1
		end
	end

	if B777DR_minimums_diff > 0 or simDR_onGround == 1 then
		B777DR_amber_minimums = 0
	end
end

---MISC----------

function setAnimations()
	B777DR_minimums_mode_knob_anim = B777_animate(B777DR_minimums_mode, B777DR_minimums_mode_knob_anim, 15)
	B777DR_baro_mode_knob_anim = B777_animate(B777DR_baro_mode, B777DR_baro_mode_knob_anim, 15)
end

function setDispAlt()
	if simDR_alt_ft_capt <= -1000 then
		B777DR_displayed_alt = -1000
	elseif simDR_alt_ft_capt >= 47000 then
		B777DR_displayed_alt = 47000
	else
		B777DR_displayed_alt = simDR_alt_ft_capt
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
	B777DR_txt_SMART_MCP_KNOBS      = "SMART MCP KNOBS"
end

function getHeadingDifference(desireddirection,current_heading)
	diff = current_heading - desireddirection
	if diff >  180 then diff = diff - 360 end
	if diff < -180 then diff = diff + 360 end
	return diff
end

function setDiffs()
	B777DR_stall_tape_diff = B777DR_vstall - B777DR_ias_capt_indicator
	B777DR_ovspd_tape_diff = B777DR_vmax - B777DR_ias_capt_indicator
	B777DR_airspeed_bug_diff = simDR_ap_airspeed - B777DR_ias_capt_indicator
	B777DR_alt_bug_diff = simDR_autopilot_alt - B777DR_displayed_alt
	B777DR_heading_bug_diff = getHeadingDifference(simDR_hdg_bug, simDR_hdg)
	B777DR_trimref_tape_diff = B777DR_trimref - B777DR_ias_capt_indicator
	B777DR_vman_tape_min_diff = B777DR_vman_min - B777DR_ias_capt_indicator
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
	if press_counter >= 3 then
		knob_is_fast = 1
		print("knob is fast")
	else
		knob_is_fast = 0
		print("knob is slow")
	end
	press_counter = 0
end

----- ANIMATION UTILITY -----------------------------------------------------------------
function B777_animate(target, variable, speed)
	if math.abs(target - variable) < 0.1 then return target end
	variable = variable + ((target - variable) * (speed * SIM_PERIOD))
	return variable
end

--- MINIMUM MANEUVERING SPEED -----------
function vManeuverMin()
	if simDR_onGround == 0 and simDR_ias_trend < 0 and B777DR_ias_capt_indicator < B777DR_vman_min and B777DR_ias_capt_indicator > B777DR_vman_min -2 then
		iasFlash()
		B777DR_amber_minimums = 1
	end

	if simDR_onGround == 1 or B777DR_ias_capt_indicator > B777DR_vman_min then
		B777DR_amber_minimums = 0
		iasFlashCount = 0
	end
end

function iasFlash()
	B777DR_spd_flash = 1 - B777DR_spd_flash
	iasFlashCount = iasFlashCount + 1
	if iasFlashCount < 10 then
		if not (is_timer_scheduled(iasFlash2) or is_timer_scheduled(iasFlash)) then
			run_after_time(iasFlash2, 0.5)
		end
	else
		B777DR_spd_flash = 1
	end
end

function iasFlash2()
	B777DR_spd_flash = 1 - B777DR_spd_flash
	run_after_time(iasFlash, 0.5)
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

function resetSpdOutline()
	B777DR_spd_outline = 0
end

function checkForSpdOutline()
	if simDR_airspeed_mach >= 0.4 and simDR_airspeed_mach <= 0.401 then
		if not is_timer_scheduled(resetSpdOutline) then
			B777DR_spd_outline = 1
			run_after_time(resetSpdOutline, 10)
		end
	end
end

--*************************************************************************************--
--**                                  EVENT CALLBACKS                                **--
--*************************************************************************************--1

function aircraft_load()
	print("flightIinstruments loaded")
end

--function aircraft_unload()

function flight_start()
	B777DR_eicas_mode = 4

	if simDR_startup_running == 1 then
		B777_align_adiru()
	end

	setTXT()
	B777DR_lbs_kgs = 1
	B777DR_aoa_enabled = 1
	B777DR_trs_bug_enabled = 1
	B777DR_smart_knobs = 1
end

--function flight_crash()

--function before_physics()

function after_physics()
	B777DR_displayed_com1_act_khz = simDR_com1_act_khz / 1000
	B777DR_displayed_com1_stby_khz = simDR_com1_stby_khz / 1000

	B777DR_displayed_com2_act_khz = simDR_com2_act_khz / 1000
	B777DR_displayed_com2_stby_khz = simDR_com2_stby_khz / 1000

	if simDR_vs_capt > 6000 then
		B777DR_vs_capt_indicator = 6000
	elseif simDR_vs_capt < -6000 then
		B777DR_vs_capt_indicator = -6000
	else
		B777DR_vs_capt_indicator = simDR_vs_capt
	end

	if simDR_ias_capt < 30 then
		B777DR_ias_capt_indicator = 30
	elseif simDR_ias_capt > 490 then
		B777DR_ias_capt_indicator = 490
	else
		B777DR_ias_capt_indicator = simDR_ias_capt
	end

	if (simDR_groundSpeed >= 1 or (simDR_bus_voltage[0] == 0 and simDR_bus_voltage[1] == 0)) and B777DR_adiru_status == 1 then
		stop_timer(B777_align_adiru)
		B777_adiru_off()
	end

	B777DR_adiru_time_remaining_min = string.format("%2.0f", math.floor(B777_adiru_time_remaining_min / 60)) -- %0.2f
	B777DR_adiru_time_remaining_sec = math.floor(B777_adiru_time_remaining_min / 60 % 1 * 60)

	if B777DR_adiru_status == 1 then B777DR_temp_adiru_is_aligning = 1 else B777DR_temp_adiru_is_aligning = 0 end

--	print("time remaining min/sec: "..tonumber(B777DR_adiru_time_remaining_min.."."..B777DR_adiru_time_remaining_sec))

	B777DR_autopilot_alt_mtrs_capt = simDR_autopilot_alt * B777_ft_to_mtrs

	if simDR_onGround == 1 then
		B777DR_displayed_aoa = 0
	else
		B777DR_displayed_aoa = simDR_aoa
	end

	if simDR_onGround == 0 and simDR_radio_alt_capt <= 2500 and simDR_radio_alt_capt >= 2490 and simDR_vs_capt < 0 then
		if not is_timer_scheduled(disableRAOutline) then
			B777DR_outlined_RA = 1
			run_after_time(disableRAOutline, 10)
		end
	end

	if B777DR_nd_mode_selector < 3 then
		simDR_map_mode = B777DR_nd_mode_selector
	else
		simDR_map_mode = 4
	end

	setDispAlt()
	setAnimations()
	minimums()
	setDiffs()
	vManeuverMin()
	weightConv()
	checkForSpdOutline()

	if B777DR_hyd_press[0] < 1200 or B777DR_hyd_press[1] < 1200 or B777DR_hyd_press[2] < 1200 then
		B777DR_hyd_press_low_any = 1
	else
		B777DR_hyd_press_low_any = 0
	end

	if B777DR_acf_is_freighter == 0 then
		B777DR_acf_is_pax = 1
		B777DR_txt_PAX_FREIGHT = "PAX"
	else
		B777DR_acf_is_pax = 0
		B777DR_txt_PAX_FREIGHT = "FREIGHT"
	end

	if B777DR_alt_is_fast_ovrd == 1 then
		alt_is_fast = 10
	end

end



--function after_replay()