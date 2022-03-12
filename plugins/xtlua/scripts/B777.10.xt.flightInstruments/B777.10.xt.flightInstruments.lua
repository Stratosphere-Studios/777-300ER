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

--*************************************************************************************--
--**                              FIND X-PLANE DATAREFS                              **--
--*************************************************************************************--

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

B777DR_ovhd_aft_button_target          = find_dataref("Strato/777/cockpit/ovhd/aft/buttons/target")



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
B777DR_pfd_mtrs_capt                   = deferred_dataref("Strato/777/displays/mtrs_capt", "number")

B777DR_eicas_mode                      = deferred_dataref("Strato/777/displays/eicas_mode", "number") -- what pages the lower eicas is on

B777DR_displayed_com1_act_khz          = deferred_dataref("Strato/777/displays/com1_act_khz", "number") -- COM1 Radio Active Display
B777DR_displayed_com1_stby_khz         = deferred_dataref("Strato/777/displays/com1_stby_khz", "number") -- COM1 Radio Standby Display

B777DR_displayed_com2_act_khz          = deferred_dataref("Strato/777/displays/com2_act_khz", "number") -- COM2 Radio Active Display
B777DR_displayed_com2_stby_khz         = deferred_dataref("Strato/777/displays/com2_stby_khz", "number") -- COM2 Radio Standby Display

B777DR_vs_capt_indicator               = deferred_dataref("Strato/777/displays/vvi_capt", "number")
B777DR_ias_capt_indicator              = deferred_dataref("Strato/777/displays/ias_capt", "number")

B777DR_adiru_aligned                   = deferred_dataref("Strato/777/fltInst/adiru_aligned", "number")
B777DR_adiru_align_time_remaining      = deferred_dataref("Strato/777/fltInst_adiru_align_time_remaining", "number")

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
	if phase == 0 then
		B777DR_hdg_mode = 1 - B777DR_hdg_mode
	end
end

function B777_efis_lEicas_eng_switch_CMDhandler(phase, duration)
	if phase == 0 then
		setEicasPage(4)
	end
end

function B777_efis_lEicas_stat_switch_CMDhandler(phase, duration)
	if phase == 0 then
		setEicasPage(9)
	end
end

function B777_efis_lEicas_elec_switch_CMDhandler(phase, duration)
	if phase == 0 then
		setEicasPage(3)
	end
end

function B777_efis_lEicas_hyd_switch_CMDhandler(phase, duration)
	if phase == 0 then
		setEicasPage(8)
	end
end

function B777_efis_lEicas_fuel_switch_CMDhandler(phase, duration)
	if phase == 0 then
		setEicasPage(6)
	end
end

function B777_efis_lEicas_air_switch_CMDhandler(phase, duration)
	if phase == 0 then
		setEicasPage(1)
	end
end

function B777_efis_lEicas_door_switch_CMDhandler(phase, duration)
	if phase == 0 then
		setEicasPage(2)
	end
end

function B777_efis_lEicas_gear_switch_CMDhandler(phase, duration)
	if phase == 0 then
		setEicasPage(7)
	end
end

function B777_efis_lEicas_fctl_switch_CMDhandler(phase, duration)
	if phase == 0 then
		setEicasPage(5)
	end
end

function B777_efis_lEicas_eng_switch_CMDhandler(phase, duration)
	if phase == 0 then
		setEicasPage(4)
	end
end

function B777_efis_lEicas_cam_switch_CMDhandler(phase, duration)
	if phase == 0 then
		setEicasPage(10)
	end
end

function setEicasPage(id)
	if B777DR_eicas_mode == id then
		B777DR_eicas_mode = 0
	else
		B777DR_eicas_mode = id
	end
end

function B777_fltInst_adiru_switch_CMDhandler(phase, duration)
	if phase == 0 then
		if B777DR_ovhd_aft_button_target[1] == 1 then
			B777DR_ovhd_aft_button_target[1] = 0
			B777DR_adiru_aligned = 0
			B777DR_adiru_align_time_remaining = 0
		elseif B777DR_ovhd_aft_button_target[1] == 0 then
			B777DR_ovhd_aft_button_target[1] = 1
			B777DR_adiru_align_time_remaining = 5 + (math.abs(simDR_latitude) / (90/11)) -- set irs alignment time
			run_after_time(B777_align_irs, B777DR_adiru_align_time_remaining * 60)
		end
	end
end

function B777_align_irs()
	B777DR_adiru_aligned = 1
	B777DR_adiru_align_time_remaining = 0
	print("adiru aligned")
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
--**                                      CODE                                       **--
--*************************************************************************************--

--Clocks

--*************************************************************************************--
--**                                  EVENT CALLBACKS                                **--
--*************************************************************************************--

function aircraft_load()
	print("flightIinstruments loaded")
end

--function aircraft_unload()

function flight_start()
	B777DR_eicas_mode = 4
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

	print("adiru alignment time: "..B777DR_adiru_align_time_remaining)

	if simDR_groundSpeed >= 1 and B777DR_adiru_align_time_remaining > 0 then
		stop_timer(B777_align_irs)
		B777DR_adiru_align_time_remaining = 0
		print("adiru motion; stopped aligning")
	end

end

--function after_replay()