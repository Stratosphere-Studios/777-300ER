--[[
*****************************************************************************************
* Script Name: flightInstruments
* Author Name: Crazytimtimtim
* Script Description: Code for cockpit instruments
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

local B777_kgs_to_lbs = 2.2046226218
local B777_ft_to_mtrs = 0.3048
local B777_adiru_time_remaining_min = 0

--*************************************************************************************--
--**                              FIND X-PLANE DATAREFS                              **--
--*************************************************************************************--

simDR_startup_running                  = find_dataref("sim/operation/prefs/startup_running")

simDR_magHDG                           = find_dataref("sim/cockpit/autopilot/heading_mag")
simDR_trueHDG                          = find_dataref("sim/cockpit/autopilot/heading")

simDR_com1_stby_khz                    = find_dataref("sim/cockpit2/radios/actuators/com1_standby_frequency_khz")
simDR_com1_act_khz                     = find_dataref("sim/cockpit2/radios/actuators/com1_frequency_khz")

simDR_com2_stby_khz                    = find_dataref("sim/cockpit2/radios/actuators/com2_standby_frequency_khz")
simDR_com2_act_khz                     = find_dataref("sim/cockpit2/radios/actuators/com2_frequency_khz")

simDR_total_fuel_kgs                   = find_dataref("sim/flightmodel/weight/m_fuel_total")
simDR_r_fuel_kgs                       = find_dataref("sim/cockpit2/fuel/fuel_level_indicated_right")
simDR_l_fuel_kgs                       = find_dataref("sim/cockpit2/fuel/fuel_level_indicated_left")

simDR_vs_capt                          = find_dataref("sim/cockpit2/gauges/indicators/vvi_fpm_pilot")
simDR_ias_capt                         = find_dataref("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
simDR_latitude                         = find_dataref("sim/flightmodel/position/latitude")
simDR_groundSpeed                      = find_dataref("sim/flightmodel/position/groundspeed")

simDR_bus_voltage                      = find_dataref("sim/cockpit2/electrical/bus_volts")

simDR_ap_airspeed                      = find_dataref("sim/cockpit/autopilot/airspeed")

simDR_alt_ft_capt                      = find_dataref("sim/cockpit2/gauges/indicators/altitude_ft_pilot")
simDR_autopilot_alt                    = find_dataref("sim/cockpit/autopilot/altitude")

B777DR_ovhd_aft_button_target          = find_dataref("Strato/777/cockpit/ovhd/aft/buttons/target")

simDR_aoa                             = find_dataref("sim/flightmodel2/misc/AoA_angle_degrees")
simDR_radio_alt_capt                  = find_dataref("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")
simDR_onGround                        = find_dataref("sim/flightmodel/failures/onground_any")
--*************************************************************************************--
--**                             CUSTOM DATAREF HANDLERS                             **--
--*************************************************************************************--



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

-- Temporary datarefs for display text until custom textures are made
B777DR_txt_TIME_TO_ALIGN               = deferred_dataref("Strato/777/displays/txt/TIME_TO_ALIGN", "string")
B777DR_txt_GS                          = deferred_dataref("Strato/777/displays/txt/GS", "string")
B777DR_txt_ddd                         = deferred_dataref("Strato/777/displays/txt/---", "string")
B777DR_txt_INSTANT_ADIRU_ALIGN         = deferred_dataref("Strato/777/displays/txt/INSTANT_ADIRU_ALIGN", "string")

--*************************************************************************************--
--**                             X-PLANE COMMAND HANDLERS                            **--
--*************************************************************************************--



--*************************************************************************************--
--**                                 X-PLANE COMMANDS                                **--
--*************************************************************************************--



--*************************************************************************************--
--**                             CUSTOM COMMAND HANDLERS                             **--
--*************************************************************************************--

function B777_mcp_magTRK_CMDhandler(phase, duration)
	if phase == 0 then B777DR_hdg_mode = 1 - B777DR_hdg_mode end
end



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

--*************************************************************************************--
--**                             CREATE CUSTOM COMMANDS                               **--
--*************************************************************************************--

B777CMD_mcp_MAGtrk                   = deferred_command("Strato/B777/button_switch/mcp/MAGtrk", "Switch between true and magnetic heading", B777_mcp_magTRK_CMDhandler)

B777CMD_fltInst_adiru_switch         = deferred_command("Strato/B777/button_switch/fltInst/adiru_switch", "ADIRU Switch", B777_fltInst_adiru_switch_CMDhandler)

B777CMD_fltInst_adiru_align_now      = deferred_command("Strato/B777/adiru_align_now", "Align ADIRU Instantly", B777_fltInst_adiru_align_now_CMDhandler)

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

--*************************************************************************************--
--**                                  EVENT CALLBACKS                                **--
--*************************************************************************************--

function aircraft_load()
	print("flightIinstruments loaded")
end

--function aircraft_unload()

function flight_start()
	B777DR_eicas_mode = 4

	if simDR_startup_running == 1 then
		B777_align_adiru()
	end

	B777DR_txt_GS                  = "GS"
	B777DR_txt_TIME_TO_ALIGN       = "TIME TO ALIGN"
	B777DR_txt_ddd                 = "---"
	B777DR_txt_INSTANT_ADIRU_ALIGN = "INSTANT ADIRU ALIGN"
end

--function flight_crash()

--function before_physics()

function after_physics()
	if B777DR_hdg_mode == 0 then
		B777DR_displayed_hdg = simDR_magHDG
	elseif B777DR_hdg_mode == 1 then
		B777DR_displayed_hdg = simDR_trueHDG
	end

	B777DR_displayed_com1_act_khz = simDR_com1_act_khz / 1000
	B777DR_displayed_com1_stby_khz = simDR_com1_stby_khz / 1000

	B777DR_displayed_com2_act_khz = simDR_com2_act_khz / 1000
	B777DR_displayed_com2_stby_khz = simDR_com2_stby_khz / 1000

	B777DR_total_fuel_lbs = simDR_total_fuel_kgs * B777_kgs_to_lbs
	B777DR_r_fuel_lbs = simDR_r_fuel_kgs * B777_kgs_to_lbs
	B777DR_l_fuel_lbs = simDR_l_fuel_kgs * B777_kgs_to_lbs

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

	B777DR_airspeed_bug_diff = simDR_ap_airspeed - B777DR_ias_capt_indicator
	B777DR_alt_mtrs_capt = simDR_alt_ft_capt * B777_ft_to_mtrs
	B777DR_autopilot_alt_mtrs_capt = simDR_autopilot_alt * B777_ft_to_mtrs

	if simDR_onGround == 1 then
		B777DR_displayed_aoa = 0
	else
		B777DR_displayed_aoa = simDR_aoa
	end

	if simDR_onGround == 0 then
		if simDR_radio_alt_capt <= 2500 and simDR_radio_alt_capt >= 2490 and simDR_vs_capt < 0 then
			B777DR_outlined_RA = 1
			if not is_timer_scheduled(disableRAOutline) then run_after_time(disableRAOutline, 10) end
		end
	end
end

--function after_replay()
