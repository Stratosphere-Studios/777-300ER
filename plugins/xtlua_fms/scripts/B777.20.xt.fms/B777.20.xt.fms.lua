--[[
*****************************************************************************************
*        COPYRIGHT � 2020 Mark Parker/mSparks CC-BY-NC4
*     Converted from Sparky744 to Stratosphere 777 by remenkemi (crazytimtimtim)
*****************************************************************************************
]]

function deferred_command(name,desc,realFunc)
	return replace_command(name,realFunc)
end

--replace deferred_dataref
function deferred_dataref(name,nilType,callFunction)
	if callFunction~=nil then
		print("WARN:" .. name .. " is trying to wrap a function to a dataref -> use xlua")
    end
    return find_dataref(name)
end

B777DR_cdu_efis_ctl         = find_dataref("Strato/777/cdu_efis_ctl")
B777DR_cdu_eicas_ctl        = find_dataref("Strato/777/cdu_eicas_ctl")
vor_adf = {0, 0}
simDR_vor_adf = {find_dataref("sim/cockpit2/EFIS/EFIS_1_selection_pilot"), find_dataref("sim/cockpit2/EFIS/EFIS_2_selection_pilot"), find_dataref("sim/cockpit2/EFIS/EFIS_1_selection_copilot"), find_dataref("sim/cockpit2/EFIS/EFIS_2_selection_copilot")}
B777DR_efis_vor_adf                    = find_dataref("Strato/777/efis/vor_adf")
B777DR_baro_mode                       = find_dataref("Strato/777/baro_mode")
B777DR_minimums_mda                    = find_dataref("Strato/777/minimums_mda")
B777DR_minimums_dh                     = find_dataref("Strato/777/minimums_dh")
simDR_nd_mode                          = {find_dataref("sim/cockpit2/EFIS/map_mode"), find_dataref("sim/cockpit2/EFIS/map_mode_copilot")}
simDR_nd_range                         = {find_dataref("sim/cockpit2/EFIS/map_range_nm"), find_dataref("sim/cockpit2/EFIS/map_range_nm_copilot")}
B777DR_minimums_mode                   = find_dataref("Strato/777/minimums_mode")
simDR_altimiter_setting                = {find_dataref("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot"), find_dataref("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot")}
B777DR_readme_code                     = find_dataref("Strato/777/readme_code")
B777DR_minimums_visible                = find_dataref("Strato/777/minimums_visible")

simDRTime=find_dataref("sim/time/total_running_time_sec")
simDR_onGround=find_dataref("sim/flightmodel/failures/onground_any")

B777DR_acfType                      = find_dataref("Strato/B777/acfType")
B777DR_payload_weight               = find_dataref("sim/flightmodel/weight/m_fixed")
simDR_acf_m_jettison  	            = find_dataref("sim/aircraft/weight/acf_m_jettison")
simDR_m_jettison  		            = find_dataref("sim/flightmodel/weight/m_jettison")
B777DR_CAS_advisory_status          = find_dataref("Strato/B777/CAS/advisory_status") -- no 
B777DR_ap_vnav_system               = find_dataref("Strato/B777/autopilot/vnav_system")
B777DR_ap_vnav_pause                = find_dataref("Strato/B777/autopilot/vnav_pause")
simDR_nav1Freq                      = find_dataref("sim/cockpit/radios/nav1_freq_hz")
simDR_nav2Freq                      = find_dataref("sim/cockpit/radios/nav2_freq_hz")
B777DR_iru_status                   = find_dataref("Strato/B777/flt_mgmt/iru/status")
B777DR_iru_mode_sel_pos             = find_dataref("Strato/B777/flt_mgmt/iru/mode_sel_dial_pos")

B777DR_rtp_C_off                    = find_dataref("Strato/B777/comm/rtp_C/off_status") -- no 
B777DR_pfd_mode_capt                = find_dataref("Strato/B777/pfd/capt/irs")
B777DR_pfd_mode_fo                  = find_dataref("Strato/B777/pfd/fo/irs")
B777DR_irs_src_fo	                = find_dataref("Strato/B777/flt_inst/irs_src/fo/sel_dial_pos")
B777DR_irs_src_capt	                = find_dataref("Strato/B777/flt_inst/irs_src/capt/sel_dial_pos")
B777DR_ap_fpa                       = find_dataref("Strato/B777/autopilot/navadata/fpa")
B777DR_ap_vb                        = find_dataref("Strato/B777/autopilot/navadata/vb")
simDR_autopilot_vs_fpm              = find_dataref("sim/cockpit2/autopilot/vvi_dial_fpm")
B777DR_fmc_notifications            = deferred_dataref("Strato/B777/fms/notification","array[53]")
B777DR_airspeed_Vref                = find_dataref("Strato/B777/airspeed/Vref")
B777DR_airspeed_VrefFlap            = find_dataref("Strato/B777/airspeed/VrefFlap")
B777DR_altimter_ft_adjusted         = find_dataref("Strato/B777/altimeter/ft_adjusted")
B777BR_eod_index                    = find_dataref("Strato/B777/autopilot/dist/eod_index")
B777DR_TAS_pilot                    = find_dataref("Strato/B777/nd/TAS_pilot") -- no*
B777DR_engine_used_fuel             = find_dataref("Strato/B777/fuel/totaliser")
simDR_autopilot_airspeed_is_mac     = find_dataref("sim/cockpit2/autopilot/airspeed_is_mach")
simDR_autopilot_airspeed_kts_mach   = find_dataref("sim/cockpit2/autopilot/airspeed_dial_kts_mach")
simDR_autopilot_airspeed_kts   	    = find_dataref("sim/cockpit2/autopilot/airspeed_dial_kts")
B777DR_elec_ext_pwr1_available      = find_dataref("Strato/B777/electrical/ext_pwr1_avail")
B777DR_eicas_rcl                    = find_dataref("Strato/777/eicas/rcl")
B777DR_eicas_mode                   = find_dataref("Strato/777/displays/eicas_mode")
simDR_map_hsi                       = {find_dataref("sim/cockpit2/EFIS/map_mode_is_HSI"), find_dataref("sim/cockpit2/EFIS/map_mode_is_HSI_copilot")}

simDR_efis_terr                        = find_dataref("sim/cockpit2/EFIS/EFIS_terrain_on")
simDR_efis_tfc                         = find_dataref("sim/cockpit2/EFIS/EFIS_tcas_on")
simDR_efis_arpt                        = find_dataref("sim/cockpit2/EFIS/EFIS_airport_on")
simDR_efis_fix                         = find_dataref("sim/cockpit2/EFIS/EFIS_fix_on")
simDR_efis_wxr_fo                      = find_dataref("sim/cockpit2/EFIS/EFIS_weather_on_copilot")
simDR_efis_terr_fo                     = find_dataref("sim/cockpit2/EFIS/EFIS_terrain_on_copilot")
simDR_efis_tfc_fo                      = find_dataref("sim/cockpit2/EFIS/EFIS_tcas_on_copilot")
simDR_efis_arpt_fo                     = find_dataref("sim/cockpit2/EFIS/EFIS_airport_on_copilot")
simDR_efis_fix_fo                      = find_dataref("sim/cockpit2/EFIS/EFIS_fix_on_copilot")
B777DR_nd_sta                          = find_dataref("Strato/777/EFIS/sta")
B777DR_pfd_mtrs                        = find_dataref("Strato/777/displays/mtrs")

--Workaround for stack overflow in init.lua namespace_read

function replace_char(pos, str, r)
    return str:sub(1, pos-1) .. r .. str:sub(pos+1)
end

function hasChild(parent,childKey)
	if parent == nil then return false end
	local keyFuncs = rawget(parent,'values')
	if keyFuncs == nil then return false end
	local keyFunc = rawget(keyFuncs,childKey)
	if keyFunc == nil then return false end
	return true
end

function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function round(x)
	return x>=0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

function cleanFMSLine(line)
    local retval = line:gsub("☐","*")
    retval = retval:gsub("°","`")
    return retval
end

function getHeadingDifference(desireddirection,current_heading)
	error = current_heading - desireddirection
	if (error >  180) then error = error- 360 end
	if (error < -180) then error = error+ 360 end
	return error
end

function getHeadingDifferenceM(desireddirection,current_heading)
	error = current_heading - desireddirection
	if (error >  180) then error = error - 360 end
	if (error < -180) then error = error + 360 end
	if error < 0 then error = error * -1 end
	return error
end

function getDistance(lat1,lon1,lat2,lon2)
	alat = math.rad(lat1)
	alon = math.rad(lon1)
	blat = math.rad(lat2)
	blon = math.rad(lon2)
	av = math.sin(alat)*math.sin(blat) + math.cos(alat)*math.cos(blat)*math.cos(blon-alon)
	if av > 1 then av = 1 end
	retVal = math.acos(av) * 3440
	--print(lat1.." "..lon1.." "..lat2.." "..lon2)
	--print("Distance = "..retVal) 
	return retVal
end

function toDMS(value,isLat)
	local degrees = math.abs(value)
	local minutes = (value-math.floor(value))*60
	local seconds = minutes - math.floor(minutes)
	local prefix="E"
	if isLat then
		prefix = value > 0 and "N" or "S"
	else
		prefix = value > 0 and "E" or "W"
	end
	local retVal = isLat and string.format(prefix.."%02d`%02d.%1d", degrees, minutes, seconds * 10) or string.format(prefix.."%03d`%02d.%1d", degrees, minutes, seconds * 10)
	return retVal
end

dofile("json/json.lua")
hh=find_dataref("sim/cockpit2/clock_timer/zulu_time_hours")
mm=find_dataref("sim/cockpit2/clock_timer/zulu_time_minutes")
ss=find_dataref("sim/cockpit2/clock_timer/zulu_time_seconds")
simDR_bus_volts                     = find_dataref("sim/cockpit2/electrical/bus_volts")
simDR_startup_running               = find_dataref("sim/operation/prefs/startup_running")

simDR_instrument_brightness_switch  = find_dataref("sim/cockpit2/switches/instrument_brightness_ratio")
simDR_instrument_brightness_ratio   = find_dataref("sim/cockpit2/electrical/instrument_brightness_ratio_manual")

simDR_radio_nav_freq_Mhz            = find_dataref("sim/cockpit2/radios/actuators/nav_frequency_Mhz")
simDR_radio_nav_freq_khz            = find_dataref("sim/cockpit2/radios/actuators/nav_frequency_khz")
simDR_radio_nav_freq_hz             = find_dataref("sim/cockpit2/radios/actuators/nav_frequency_hz")

simDR_radio_nav_course_deg          = find_dataref("sim/cockpit2/radios/actuators/nav_course_deg_mag_pilot")
simDR_radio_nav_obs_deg             = find_dataref("sim/cockpit2/radios/actuators/nav_obs_deg_mag_pilot")
simDR_radio_nav1_obs_deg            = find_dataref("sim/cockpit/radios/nav1_obs_degt")
simDR_radio_nav2_obs_deg            = find_dataref("sim/cockpit/radios/nav2_obs_degt")
simDR_radio_nav_horizontal          = find_dataref("sim/cockpit2/radios/indicators/nav_display_horizontal")
simDR_radio_nav_hasDME              = find_dataref("sim/cockpit2/radios/indicators/nav_has_dme")
simDR_radio_nav_radial		        = find_dataref("sim/cockpit2/radios/indicators/nav_bearing_deg_mag")
simDR_radio_nav01_ID                = find_dataref("sim/cockpit2/radios/indicators/nav1_nav_id")
simDR_radio_nav02_ID                = find_dataref("sim/cockpit2/radios/indicators/nav2_nav_id")
simDR_radio_nav03_ID                = find_dataref("sim/cockpit2/radios/indicators/nav3_nav_id")
simDR_radio_nav04_ID                = find_dataref("sim/cockpit2/radios/indicators/nav4_nav_id")

simDR_radio_adf1_freq_hz            = find_dataref("sim/cockpit2/radios/actuators/adf1_frequency_hz")
simDR_radio_adf2_freq_hz            = find_dataref("sim/cockpit2/radios/actuators/adf2_frequency_hz")

simDR_fueL_tank_weight_total_kg     = find_dataref("sim/flightmodel/weight/m_fuel_total")

navAidsJSON                         = find_dataref("xtlua/navaids")
fmsJSON                             = find_dataref("xtlua/fms")

B777DR_fms1_display_mode            = find_dataref("Strato/B777/fms1/display_mode")

B777DR_init_fmsL_CD                 = find_dataref("Strato/B777/fmsL/init_CD")
ilsData                             = deferred_dataref("Strato/B777/radio/ilsData", "string")
acars                               = deferred_dataref("Strato/B777/comm/acars","number")  
toderate                            = deferred_dataref("Strato/B777/engine/derate/TO","number") 
clbderate                           = deferred_dataref("Strato/B777/engine/derate/CLB","number")
B777DR_radioModes                   = deferred_dataref("Strato/B777/radio/tuningmodes", "string")
B777DR_FMSdata                      = deferred_dataref("Strato/B777/fms/data", "string")
B777DR_ap_vnav_state                = find_dataref("Strato/B777/autopilot/vnav_state")
simDR_autopilot_vs_status           = find_dataref("sim/cockpit2/autopilot/vvi_status")
B777BR_totalDistance                = find_dataref("Strato/B777/autopilot/dist/remaining_distance")
B777BR_nextDistanceInFeet           = find_dataref("Strato/B777/autopilot/dist/next_distance_feet")
B777BR_cruiseAlt                    = find_dataref("Strato/B777/autopilot/dist/cruise_alt")
B777BR_tod                          = find_dataref("Strato/B777/autopilot/dist/top_of_descent")
B777DR__gear_chocked                = find_dataref("Strato/B777/gear/chocked")
B777DR_fuel_preselect               = find_dataref("Strato/B777/fuel/preselect")
B777DR_refuel		                = find_dataref("Strato/B777/fuel/refuel")
B777DR_fuel_add		                = find_dataref("Strato/B777/fuel/add_fuel" )

B777DR_efis_min_ref_alt_capt_sel_dial_pos       = find_dataref("Strato/B777/efis/min_ref_alt/capt/sel_dial_pos")
B777DR_efis_ref_alt_capt_set_dial_pos           = find_dataref("Strato/B777/efis/ref_alt/capt/set_dial_pos")
B777DR_efis_dh_reset_capt_switch_pos            = find_dataref("Strato/B777/efis/dh_reset/capt/switch_pos")
B777DR_efis_baro_ref_capt_sel_dial_pos          = find_dataref("Strato/B777/efis/baro_ref/capt/sel_dial_pos")
B777DR_efis_baro_std_capt_switch_pos            = find_dataref("Strato/B777/efis/baro_std/capt/switch_pos")
B777DR_efis_baro_capt_set_dial_pos              = find_dataref("Strato/B777/efis/baro/capt/set_dial_pos")
B777DR_efis_baro_capt_preselect                 = find_dataref("Strato/B777/efis/baro/capt/preselect")
B777DR_efis_baro_alt_ref_capt                   = find_dataref("Strato/B777/efis/baro_ref/capt")

B777DR_efis_min_ref_alt_fo_sel_dial_pos         = find_dataref("Strato/B777/efis/min_ref_alt/fo/sel_dial_pos")
B777DR_efis_ref_alt_fo_set_dial_pos             = find_dataref("Strato/B777/efis/ref_alt/fo/set_dial_pos")
B777DR_efis_dh_reset_fo_switch_pos              = find_dataref("Strato/B777/efis/dh_reset/fo/switch_pos")
B777DR_efis_baro_ref_fo_sel_dial_pos            = find_dataref("Strato/B777/efis/baro_ref/fo/sel_dial_pos")
B777DR_efis_baro_std_fo_switch_pos              = find_dataref("Strato/B777/efis/baro_std/fo/switch_pos")
B777DR_efis_baro_fo_set_dial_pos                = find_dataref("Strato/B777/efis/baro/fo/set_dial_pos")
B777DR_efis_baro_fo_preselect                   = find_dataref("Strato/B777/efis/baro/fo/preselect")
B777DR_efis_baro_alt_ref_fo                     = find_dataref("Strato/B777/efis/baro_ref/fo")

simDR_radio_alt_DH_capt             = find_dataref("sim/cockpit2/gauges/actuators/radio_altimeter_bug_ft_pilot")
simDR_radio_alt_DH_fo               = find_dataref("sim/cockpit2/gauges/actuators/radio_altimeter_bug_ft_copilot")

simDR_altimeter_baro_inHg           = find_dataref("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot")
simDR_altimeter_baro_inHg_fo        = find_dataref("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot")

--Marauder28
--Used in ND DISPLAY
simDR_latitude				= find_dataref("sim/flightmodel/position/latitude")
simDR_longitude				= find_dataref("sim/flightmodel/position/longitude")
simDR_navID					= find_dataref("sim/cockpit2/radios/indicators/gps_nav_id")
simDR_range_dial_capt		= find_dataref("Strato/B777/nd/range/capt/sel_dial_pos") -- no*
simDR_range_dial_fo			= find_dataref("Strato/B777/nd/range/fo/sel_dial_pos") -- no*
simDR_nd_mode_dial_capt		= find_dataref("Strato/B777/nd/mode/capt/sel_dial_pos")
simDR_nd_mode_dial_fo       = find_dataref("Strato/B777/nd/mode/fo/sel_dial_pos")
simDR_nd_center_dial_capt   = find_dataref("Strato/B777/nd/map_center/capt")
simDR_nd_center_dial_fo	    = find_dataref("Strato/B777/nd/map_center/fo")
simDR_EFIS_map_mode         = find_dataref("sim/cockpit2/EFIS/map_mode")
simDR_EFIS_map_range        = find_dataref("sim/cockpit2/EFIS/map_range")

simDR_groundspeed			= find_dataref("sim/flightmodel2/position/groundspeed")
simDR_ias_pilot				= find_dataref("Strato/777/displays/ias_capt")
simDR_wind_degrees			= find_dataref("sim/cockpit2/gauges/indicators/wind_heading_deg_mag")
simDR_wind_speed			= find_dataref("sim/cockpit2/gauges/indicators/wind_speed_kts")
simDR_mach_pilot			= find_dataref("sim/cockpit2/gauges/indicators/mach_pilot")
simDR_mach_copilot			= find_dataref("sim/cockpit2/gauges/indicators/mach_copilot")
simDR_total_air_temp		= find_dataref("sim/cockpit2/temperature/outside_air_LE_temp_degc")
simDR_air_temp              = find_dataref("sim/cockpit2/temperature/outside_air_temp_degc")
simDR_aircraft_hdg		 	= find_dataref("sim/cockpit2/gauges/indicators/heading_AHARS_deg_mag_pilot")

simDR_cgZ_ref_point			= find_dataref("sim/aircraft/weight/acf_cgZ_original")
simDR_cgz_ref_to_default	= find_dataref("sim/flightmodel/misc/cgz_ref_to_default")
simDR_empty_weight			= find_dataref("sim/aircraft/weight/acf_m_empty")
simDR_fuel_qty				= find_dataref("sim/flightmodel/weight/m_fuel")
simDR_cg_adjust				= find_dataref("sim/flightmodel/misc/cgz_ref_to_default")
simDR_livery_path			= find_dataref("sim/aircraft/view/acf_livery_path")
simDR_onground				= find_dataref("sim/flightmodel/failures/onground_any")
simDR_payload_weight		= find_dataref("sim/flightmodel/weight/m_fixed")
simDR_fuel_totalizer_kg		= find_dataref("sim/cockpit2/fuel/fuel_totalizer_init_kg")
--Marauder28


--*************************************************************************************--
--** 				        CREATE READ-WRITE CUSTOM DATAREFS                        **--
--*************************************************************************************--
B777DR_fmc_notifications        = deferred_dataref("Strato/B777/fms/notification","array[53]")
--Marauder28
-- Holds all SimConfig options
B777DR_simconfig_data       = find_dataref("Strato/777/simconfig")
B777DR_newsimconfig_data    = find_dataref("Strato/777/newsimconfig")
-- Temp location for fuel preselect for displaying in correct units
B777DR_fuel_preselect_temp				= deferred_dataref("Strato/B777/fuel/fuel_preselect_temp", "number")

--pos data
B777DR_waypoint_ata					= deferred_dataref("Strato/B777/nd/waypoint_ata", "string")
B777DR_last_waypoint				= deferred_dataref("Strato/B777/nd/last_waypoint", "string")
B777DR_last_waypoint_fuel=simDR_fueL_tank_weight_total_kg
B777DR_destination					= deferred_dataref("Strato/B777/nd/dest", "string")
B777DR_next_waypoint_eta					= deferred_dataref("Strato/B777/nd/next_waypoint_eta", "string")
B777DR_next_waypoint_dist					= deferred_dataref("Strato/B777/nd/next_waypoint_dist", "number")
B777DR_next_waypoint				= deferred_dataref("Strato/B777/nd/next_waypoint", "string")

--Waypoint info for ND DISPLAY
B777DR_ND_waypoint_eta					= deferred_dataref("Strato/B777/nd/waypoint_eta", "string")
B777DR_ND_current_waypoint				= deferred_dataref("Strato/B777/nd/current_waypoint", "string")
B777DR_ND_waypoint_distance				= deferred_dataref("Strato/B777/nd/waypoint_distance", "string")

--ND Range DISPLAY
B777DR_ND_range_display_capt			= deferred_dataref("Strato/B777/nd/range_display_capt", "number")
B777DR_ND_range_display_fo				= deferred_dataref("Strato/B777/nd/range_display_fo", "number")

--IRS ND DISPLAY
B777DR_ND_GPS_Line						= deferred_dataref("Strato/B777/irs/gps_display_line", "string")
B777DR_ND_IRS_Line						= deferred_dataref("Strato/B777/irs/irs_display_line", "string")

--SPEED ND DISPLAY
B777DR_ND_GS_TAS_Line					= deferred_dataref("Strato/B777/nd/gs_tas_line", "string")
B777DR_ND_GS_TAS_Line_Pilot				= deferred_dataref("Strato/B777/nd/gs_tas_line_pilot", "string")
B777DR_ND_GS_TAS_Line_CoPilot			= deferred_dataref("Strato/B777/nd/gs_tas_line_copilot", "string")
B777DR_ND_Wind_Line						= deferred_dataref("Strato/B777/nd/wind_line", "string")
B777DR_ND_Wind_Bearing					= deferred_dataref("Strato/B777/nd/wind_bearing", "number")

--STAB TRIM setting
B777DR_elevator_trim				    = deferred_dataref("Strato/B777/fmc/elevator_trim", "number")

--Sound Options (crazytimtimtim + Matt726)
B777DR_SNDoptions           = find_dataref("Strato/777/fmod/options")
B777DR_SNDoptions_volume    = find_dataref("Strato/777/fmod/options/volume") --TODO
B777DR_SNDoptions_gpws      = find_dataref("Strato/777/fmod/options/gpws")

B777DR_cdu_act          = deferred_dataref("Strato/777/cdu_fmc_act", "array[3]")
B777DR_readme_unlocked  = deferred_dataref("Strato/777/readme_unlocked", "number")

--Simulator Config Options
simConfigData = {}
function doneNewSimConfig()
	B777DR_newsimconfig_data=0
end
function pushSimConfig(values)
	B777DR_simconfig_data=json.encode(values)
	B777DR_newsimconfig_data=1
	run_after_time(doneNewSimConfig, 1)
end

local setSimConfig=false
function hasSimConfig()
	if B777DR_newsimconfig_data==1 then
		if string.len(B777DR_simconfig_data) > 1 then
			simConfigData["data"] = json.decode(B777DR_simconfig_data)
			setSimConfig=true
		else
			return false
		end
	end
	return setSimConfig
end

-- see "fms wb code.lua in project files"

fmsPages={}
--fmsPagesmall={}
fmsFunctionsDefs={}
fmsModules={} --set later

function defaultFMSData()
	return {
	acarsInitString="{}",
	fltno=string.rep("-", 8),
	fltdate="********",
	fltdep="****",
	fltdst="****",
	flttimehh="**",
	flttimemm="**",
	rpttimehh="**",
	rpttimemm="**",
	acarsAddress="*******",
	atc="****",
	grwt="***.*   ",
	crzalt = string.rep("*", 5),
	clbspd="250",
	transpd="272",
	spdtransalt="10000",
	transalt="18000",
	clbrestspd="250",
	maxkts="420",
	clbrestalt="5000 ",
	stepalt="FL360",
	crzspd="810",
	desspdmach="805",
	desspd="270",
	destranspd="240",
	desspdtransalt="10000",
	desrestspd="180",
	desrestalt="5000 ",
	fpa="*.*",
	vb="*.*",
	vs="****",
	fuel="***.*",
	zfw="***.*   ",
	reserves="***.*",
	costindex="****",
	crzcg="20.0",
	thrustsel=string.rep(" ", 2), --"26",  --Initally "blank" per FCOM FMC Preflight 2B - Thrust Limit Page
	thrustn1="**.*",
	toflap="**",
	v1="***",
	vr="***",
	v2="***",
	runway=string.rep("-", 5),
	coroute=string.rep("-", 10),
	grosswt="***.*",
	vref1="***",
	vref2="***",
	irsLat=string.rep(" ", 9),
	irsLon=string.rep(" ", 9),
	aptLat=string.rep(" ", 9),
	aptLon=string.rep(" ", 9),
	initIRSLat="****`**.*",
	initIRSLon="****`**.*",
	flapspeed="**/***",
	airportpos=string.rep("-", 4),
	airportgate=string.rep(" ", 5),
	preselectLeft=string.rep("-", 6),
	preselectRight=string.rep("-", 6),
	codata = string.rep("-", 6),
	lastpos = string.rep(" ", 18),
	sethdg = string.rep(" ", 4),
	stepsize = "ICAO",
	--[[cg_mac = string.rep("-", 2),
	stab_trim = string.rep(" ", 4),
	paxFirstClassA = string.rep("0", 2),
	paxBusClassB = string.rep("0", 2),
	paxEconClassC = string.rep("0", 2),
	paxEconClassD = string.rep("0", 3),
	paxEconClassE = string.rep("0", 3),
	paxTotal = string.rep("0", 3),
	paxWeightA = string.rep("0", 4),
	paxWeightB = string.rep("0", 5),
	paxWeightC = string.rep("0", 5),
	paxWeightD = string.rep("0", 5),
	paxWeightE = string.rep("0", 5),
	paxWeightTotal = string.rep("0", 6),
	cargoFwd = string.rep("0", 6),
	cargoAft = string.rep("0", 6),
	cargoBulk = string.rep("0", 5),
	cargoTotal = string.rep("0", 6),
	freightZoneA = string.rep("0", 6),
	freightZoneB = string.rep("0", 6),
	freightZoneC = string.rep("0", 6),
	freightZoneD = string.rep("0", 6),
	freightZoneE = string.rep("0", 6),
	freightTotal = string.rep("0", 7),]]
	irsAlignTime = string.rep("0", 3),
	fmcUnlocked = false,
	readmeCodeInput = "*****",
	pos = string.rep(" ", 18),
}
end

fmsModules["data"]=defaultFMSData()
B777DR_FMSdata=json.encode(fmsModules["data"]["values"])--make the fms data available to other modules

fmsModules["setData"]=function(self,id,value)
    --always retain the same length
    if value == "" then
		local initData=defaultFMSData()
		if initData[id]~=nil then
			print("default for " .. id .. " is " .. initData[id])
			value=initData[id]
		else
			print("default for " .. id .. " is nil")
			self["data"][id] = nil
			return
		end
    end
    len=string.len(self["data"][id])
    if len < string.len(value) then 
		value=string.sub(value,1,len)
    end
    --newVal=string.sub(value,1,len)
    self["data"][id]=string.format("%s%"..(len-string.len(value)).."s",value,"")
	B777DR_FMSdata=json.encode(fmsModules["data"]["values"])--make the fms data available to other modules
end

function setFMSData(id,value)
    print("setting " .. id )
	print(" to "..value)
	print(" curently "..fmsModules["data"][id])
	fmsModules:setData(id,value)
end

function getFMSData(id)
	if hasChild(fmsModules["data"],id) then
		return fmsModules["data"][id]
	end
	print("getting getFMSData" )
	print("getting " .. id )
	print(" curently "..fmsModules["data"][id])
	return fmsModules["data"][id]
end

fmsModules["lastcmd"]=" "
fmsModules["cmds"]={}
fmsModules["cmdstrings"]={}

function registerFMCCommand(commandID,dataString)
	--[[fmsModules["cmds"][commandID]=find_command(commandID)
	fmsModules["cmdstrings"][commandID]=dataString]]
	return
end

function switchCustomMode()
	fmsModules["fmsL"]["prevPage"] = fmsModules["fmsL"]["currentPage"]
	fmsModules["fmsC"]["prevPage"] = fmsModules["fmsC"]["currentPage"]
	fmsModules["fmsR"]["prevPage"] = fmsModules["fmsR"]["currentPage"]
	fmsModules["fmsL"]["inCustomFMC"]=fmsModules["fmsL"]["targetCustomFMC"]
	fmsModules["fmsC"]["inCustomFMC"]=fmsModules["fmsC"]["targetCustomFMC"]
	fmsModules["fmsR"]["inCustomFMC"]=fmsModules["fmsR"]["targetCustomFMC"]
	fmsModules["fmsL"]["currentPage"]=fmsModules["fmsL"]["targetPage"]
	fmsModules["fmsC"]["currentPage"]=fmsModules["fmsC"]["targetPage"]
	fmsModules["fmsR"]["currentPage"]=fmsModules["fmsR"]["targetPage"]
	fmsModules["fmsL"]["pgNo"]=fmsModules["fmsL"]["targetpgNo"]
	fmsModules["fmsC"]["pgNo"]=fmsModules["fmsC"]["targetpgNo"]
	fmsModules["fmsR"]["pgNo"]=fmsModules["fmsR"]["targetpgNo"]
	print("cdu blanking")
end

function createPage(page)
	retVal={}
	retVal.name=page
	retVal.template={
		"    " .. page,
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        "
	}

	retVal.templateSmall={
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ", 
		"                        "
	}

	retVal.getPage=function(self,pgNo) return self.template end
	retVal.getSmallPage=function(self,pgNo) return self.templateSmall end
	print("createPage")
	retVal.getNumPages=function(self) return 1 end
	fmsFunctionsDefs[page]={}
	print("createDone")
	return retVal
end

dofile("B777.notifications.lua")
--dofile("irs/irs_system.lua")
dofile("B777.fms.pages.lua")
--dofile("irs/rnav_system.lua")
dofile("B777.createfms.lua")

fmsC = {}
setmetatable(fmsC, {__index = fms})
fmsC.id="fmsC"
setDREFs(fmsC,"cdu1","fms1","sim/FMS/","fms3")
fmsC.inCustomFMC=true
fmsC.targetCustomFMC=true
fmsC.prevPage="README"
fmsC.currentPage="README"
fmsC.targetPage="README"

fmsL = {}
setmetatable(fmsL, {__index = fms})
fmsL.id="fmsL"
setDREFs(fmsL,"cdu1","fms3","sim/FMS/","fms1")
fmsL.inCustomFMC=true
fmsL.targetCustomFMC=true
fmsL.prevPage = "README"
fmsL.currentPage ="README"
fmsL.targetPage="README"

fmsR = {}
setmetatable(fmsR, {__index = fms})
fmsR.id="fmsR"
setDREFs(fmsR,"cdu1","fms2","sim/FMS/","fms2")
fmsR.inCustomFMC=true
fmsR.targetCustomFMC=true
fmsR.prevPage = "README"
fmsR.currentPage = "README"
fmsR.targetPage = "README"

fmsModules.fmsL=fmsL;
fmsModules.fmsC=fmsC;
fmsModules.fmsR=fmsR;

B777DR_CAS_memo_status          = find_dataref("Strato/B777/CAS/memo_status") -- no

--Marauder28
function getCurrentWayPoint(fms,usenext)

	for i=1,table.getn(fms),1 do
		--print("FMS j="..fmsJSON)

		if fms[i][10] == true then
			--print("Found TRUE = "..fms[i][1].." "..fms[i][2].." "..fms[i][8])
			if usenext == false then
				if fms[i][8] == "latlon" then
					return simDR_navID, fms[i][5], fms[i][6]
				else
					return fms[i][8], fms[i][5], fms[i][6]
				end
			elseif i+1 < table.getn(fms) then
				if fms[i+1][8] == "latlon" then
					return "-----", fms[i+1][5], fms[i+1][6]
				else
					return fms[i+1][8], fms[i+1][5], fms[i+1][6]
				end
			end
		end
	end
	return ""  --NOT FOUND
end
function get_ETA_for_Distance(distance,additionalTime)
	local meters_per_second_to_kts = 1.94384449
	local hours = 0
	local mins = 0
	local secs = 0
	local time_to_waypoint = 0
	local default_speed = 275 * meters_per_second_to_kts
	local actual_speed = simDR_groundspeed * meters_per_second_to_kts
	time_to_waypoint = additionalTime + (distance / math.max(default_speed, actual_speed)) * 3600

	hours = math.floor((time_to_waypoint % 86400) / 3600)
	mins = math.floor((time_to_waypoint % 3600) / 60)
	secs = (time_to_waypoint % 60) / 60
	--Add to current Zulu time
	hours = hours + hh
	mins = mins + mm
	secs = secs + (ss / 60)

	if hours >= 24 then
		hours = hours - 24
	end

	if mins >= 60 then
		mins = mins - 60
		hours = hours + 1
	end

	if secs >= 1 then
		secs = secs - 1
		mins = mins + 1
	end

	return time_to_waypoint,hours,mins,secs
end

function get_waypoint_estimate(latitude,longitude,fms_waypoint, fms_latitude, fms_longitude,additionalTime)
	local hours = 0
	local mins = 0
	local secs = 0
	local time_to_waypoint = 0
	local fms_distance_to_waypoint = 0

	if fms_waypoint ~= "" and fms_waypoint ~= "VECTOR" and not string.match(fms_waypoint, "%(") then
		--print("Checking distance for waypoint = "..fms_current_waypoint)
		ms_distance_to_waypoint = getDistance(latitude, longitude, fms_latitude, fms_longitude)
		ime_to_waypoint,hours,mins,secs = get_ETA_for_Distance(fms_distance_to_waypoint,additionalTime)
	end

	return fms_distance_to_waypoint,time_to_waypoint,hours,mins,secs
end

function waypoint_eta_display()
	local hours = 0
	local mins = 0
	local secs = 0
	local nhours = 0
	local nmins = 0
	local nsecs = 0
	local fms = {}
	local fms_current_waypoint = ""
	local fms_next_waypoint = ""
	local fms_latitude = ""
	local fms_longitude = ""
	local fms_next_latitude = ""
	local fms_next_longitude = ""
	local time_to_waypoint = 0
	local fms_distance_to_waypoint = 0
	local fms_distance_to_next_waypoint = 0
	if string.len(fmsJSON) > 2 then
		fms = json.decode(fmsJSON)

		if fms[table.getn(fms)][8] ~= "LATLON" then
			B777DR_destination = string.format("%4s",fms[table.getn(fms)][8])
		else
			B777DR_destination="----"
		end

		if simDR_onGround ~= 1 then
			--print(fmsJSON)
			fms_current_waypoint, fms_latitude, fms_longitude = getCurrentWayPoint(fms,false)
			--print(string.match(fms_current_waypoint, "%("))
			fms_distance_to_waypoint,time_to_waypoint,hours,mins,secs = get_waypoint_estimate(simDR_latitude, simDR_longitude,fms_current_waypoint, fms_latitude, fms_longitude,0)
			fms_next_waypoint, fms_next_latitude, fms_next_longitude = getCurrentWayPoint(fms,true)
			--print(string.match(fms_current_waypoint, "%("))
			fms_distance_to_next_waypoint,time_to_waypoint,nhours,nmins,nsecs = get_waypoint_estimate(fms_latitude, fms_longitude,fms_next_waypoint, fms_next_latitude, fms_next_longitude,time_to_waypoint)
		end
	else
		B777DR_destination="----"
	end

	if fms_current_waypoint == "" or string.match(fms_current_waypoint, "%(") then
		B777DR_ND_current_waypoint = "-----"
		B777DR_ND_waypoint_distance = "------NM"
		B777DR_ND_waypoint_eta = "------Z"
	elseif fms_current_waypoint == "VECTOR" then
		B777DR_ND_current_waypoint = fms_current_waypoint
		B777DR_ND_waypoint_distance = "------NM"
		B777DR_ND_waypoint_eta = "------Z"
	else
		if B777DR_ND_current_waypoint ~= fms_current_waypoint then
			B777DR_waypoint_ata = B777DR_ND_waypoint_eta
			B777DR_last_waypoint = B777DR_ND_current_waypoint
			B777DR_last_waypoint_fuel=simDR_fueL_tank_weight_total_kg
		end
		B777DR_ND_current_waypoint = fms_current_waypoint
		B777DR_ND_waypoint_distance = string.format("%5.1f".."nm", fms_distance_to_waypoint)
		B777DR_ND_waypoint_eta = string.format("%02d%02d.%d".."z", hours, mins, secs * 10)			
	end

	if B777DR_last_waypoint=="" then
		B777DR_last_waypoint="-----"
		B777DR_waypoint_ata="------Z"
	end

	if fms_next_waypoint == "" or string.match(fms_next_waypoint, "%(") then
		B777DR_next_waypoint = "-----"
		B777DR_next_waypoint_eta = "------Z"
		B777DR_next_waypoint_dist=0	
	elseif fms_next_waypoint == "VECTOR" then
		B777DR_next_waypoint = fms_next_waypoint
		B777DR_next_waypoint_dist=fms_distance_to_next_waypoint
		B777DR_next_waypoint_eta = "------Z"
	else
		B777DR_next_waypoint = fms_next_waypoint
		B777DR_next_waypoint_dist=fms_distance_to_next_waypoint
		B777DR_next_waypoint_eta = string.format("%02d%02d.%d".."z", nhours, nmins, nsecs * 10)			
	end
end

function nd_range_display ()
	local range = {5, 10, 20, 40, 80, 160, 320}
	B777DR_ND_range_display_capt	= range[simDR_range_dial_capt + 1]
	B777DR_ND_range_display_fo		= range[simDR_range_dial_fo + 1]
end

function nd_speed_wind_display()
	local meters_per_second_to_kts = 1.94384449  --Convert meters per second to KTS
	local a0 = 661.47  --Speed of sound at sea level
	local K0 = 273.15  --Kelvin temperature at sea level
	local M_pilot = simDR_mach_pilot  --Current Mach number
	local M_copilot = simDR_mach_copilot  --Current Mach number
	local T0 = 288.15  --Standard air temperature at sea level in Kelvin
	local Tt = K0 + simDR_total_air_temp  --Total air temperature in Kelvin
	local T_pilot = Tt / (1 + (0.2 * math.pow(M_pilot, 2)))  --Static air temperature in Kelvin	
	local T_copilot = Tt / (1 + (0.2 * math.pow(M_copilot, 2)))  --Static air temperature in Kelvin	

	local TAS_pilot = round(a0 * M_pilot * math.sqrt(T_pilot/T0))
	B777DR_TAS_pilot = TAS_pilot
	local TAS_copilot = round(a0 * M_copilot * math.sqrt(T_copilot/T0))

	local groundspeed = simDR_groundspeed * meters_per_second_to_kts
	local wind_hdg = round(simDR_wind_degrees)
	local wind_hdg_deviation = 360 - wind_hdg + simDR_aircraft_hdg
	local wind_bearing = 360 - wind_hdg_deviation
	local wind_spd = tostring(round(simDR_wind_speed))
	local wind_line_tmp = string.format("%03.0f`/%s", wind_hdg, wind_spd)

	if simDR_ias_pilot < 100 then
		B777DR_ND_GS_TAS_Line = "GS"
		B777DR_ND_GS_TAS_Line_Pilot = string.format("%d", groundspeed)
		B777DR_ND_GS_TAS_Line_CoPilot = string.format("%d", groundspeed)
		B777DR_ND_Wind_Line = ""
	else
		B777DR_ND_GS_TAS_Line = "GS     TAS"
		B777DR_ND_GS_TAS_Line_Pilot = string.format("%3.0f    %3.0f", groundspeed, TAS_pilot)
		B777DR_ND_GS_TAS_Line_CoPilot = string.format("%3.0f    %3.0f", groundspeed, TAS_copilot)
		B777DR_ND_Wind_Line = wind_line_tmp:gsub("°", "`")
		if wind_bearing < 0 then
			B777DR_ND_Wind_Bearing = wind_bearing + 180
		else
			B777DR_ND_Wind_Bearing = wind_bearing - 180
		end
	end
end

function loadLastPos()
		---local file_location = simDR_livery_path.."B777-300ER_lastpos.dat"
		local file_location = "Output/preferences/Strato_777_lastpos.dat"
		print("lastpos file = "..file_location)
		local file = io.open(file_location, "r")
		if file ~= nil then
			fmsModules["data"].lastpos = file:read()
			file:close()
			print("loaded lastpos: "..fmsModules["data"].lastpos)
		else
			print("lastpos file is nil")
		end
		loadedLastPos = true
end

function unloadLastPos()
	--local file_location = simDR_livery_path.."B777-300ER_lastpos.dat"
	local file_location = "Output/preferences/Strato_777_lastpos.dat"
	print("lastpos file = "..file_location)
	local file = io.open(file_location, "w")
	file:write(fmsModules["data"].pos)
	file:close()
	print("Unloaded lastpos: "..fmsModules["data"].pos)
end

function closeReadme()
	find_command("Strato/B777/fms1/ls_key/R6"):once()
	find_command("Strato/B777/fms2/ls_key/R6"):once()
	find_command("Strato/B777/fms3/ls_key/R6"):once()
end

--function livery_load() end

--Marauder28
debug_fms     = deferred_dataref("Strato/B777/debug/fms", "number")
function flight_start()
	B777DR_last_waypoint_fuel=simDR_fueL_tank_weight_total_kg
	--[[if simDR_startup_running == 0 then commented out for ss777
		irsSystem["irsL"]["aligned"]=false
		irsSystem["irsC"]["aligned"]=false
		irsSystem["irsR"]["aligned"]=false
	elseif simDR_startup_running == 1 then -- ENGINES RUNNING
		irsSystem["setPos"]=true
		irsSystem.align("irsL",true)
		irsSystem.align("irsC",true)
		irsSystem.align("irsR",true)
    end

	simDR_cg_adjust = 0  --reset CG slider to begin current flight

	--Ensure that CG location gets updated periodically so that the CG slider repositions automatically as fuel is burned during flight
	--run_at_interval(inflight_update_CG, 60) commented out for ss777]]
end

fms_style = find_dataref("sim/cockpit2/radios/indicators/fms_cdu1_style_line2")
lastNotify = 0

function setNotifications()
	local diff=simDRTime-lastNotify
	if diff<10 then return end
	--print("FMS notify")
	local hasNotify=false
	lastNotify=simDRTime
	for i =1,53,1 do
		--print("do FMS notify".." ".. i .." " ..B777DR_fmc_notifications[i])
		if B777DR_fmc_notifications[i]>0 then
			fmsModules["fmsL"]["notify"]=B777_FMCAlertMsg[i].name
			fmsModules["fmsC"]["notify"]=B777_FMCAlertMsg[i].name
			fmsModules["fmsR"]["notify"]=B777_FMCAlertMsg[i].name
			--print("do FMS notify "..B777_FMCAlertMsg[i].name)
			hasNotify=true
			break
		else
			if fmsModules["fmsL"]["notify"]==B777_FMCAlertMsg[i].name then fmsModules["fmsL"]["notify"]="" end
			if fmsModules["fmsC"]["notify"]==B777_FMCAlertMsg[i].name then fmsModules["fmsC"]["notify"]="" end
			if fmsModules["fmsR"]["notify"]==B777_FMCAlertMsg[i].name then fmsModules["fmsR"]["notify"]="" end
		end
	end

	--[[if hasNotify==true then ss777 comment
		B777DR_CAS_advisory_status[145] = 1
	else
		B777DR_CAS_advisory_status[145] = 0
	end]]
end

function after_physics()
	if debug_fms > 0 then return end
	if hasSimConfig() == false then return end

	fmsModules["data"].pos = toDMS(simDR_latitude, true).." "..toDMS(simDR_longitude, false)
	
--     for i =1,24,1 do
--       print(string.byte(fms_style,i))
--     end
	--refresh time
	local cM = hh
	cM = mm
	cM = ss
    setNotifications()
    B777DR_FMSdata=json.encode(fmsModules["data"]["values"])--make the fms data available to other modules
    --print(B777DR_FMSdata)
    fmsL:B777_fms_display()
    fmsC:B777_fms_display()
    fmsR:B777_fms_display()
	--print("FMS WORKING")
	--[[if simDR_bus_volts[0]>24 then ss777 comment
		irsSystem.update()
		B777_setNAVRAD()
    end]]

--[[    if acarsSystem.provider.online() then
		-- B777DR_CAS_memo_status[40]=0
		acars = 1 --for radio
		acarsSystem.provider.receive()
		local hasNew = 0
		for i = table.getn(acarsSystem.messages.values), 1, -1 do
			if not acarsSystem.messages[i]["read"] then
				hasNew = 1
			end
		end
		B777DR_CAS_memo_status[0] = hasNew
    else
		if B777DR_rtp_C_off == 0 then ss777 comment
			B777DR_CAS_memo_status[40] = 1 --for CAS
		else
			B777DR_CAS_memo_status[40] = 0
		end
		acars = 0 --for radio
    end
]]
	--Display Waypoint ETA on ND
	waypoint_eta_display()

	--Display range NM on ND
	nd_range_display()

	--Display speed and wind info on ND
	nd_speed_wind_display()

	--Ensure simConfig data is fresh	

	--Ensure DR's are updated in time for use in calc_CGMAC()
	--[[local payload_weight = B777DR_payload_weight s777 comment
	local fuel_qty = simDR_fuel_qty]]
	local simconfig = B777DR_simconfig_data
	--print(fmsModules["fmsL"]["prevPage"], fmsModules["fmsC"]["prevPage"], fmsModules["fmsR"]["prevPage"])
	B777DR_readme_unlocked = simConfigData["data"].FMC.unlocked

	if B777DR_cdu_efis_ctl[0] == 1 then
		simDR_vor_adf[1] = vor_adf[1]
		simDR_vor_adf[2] = vor_adf[1]
	else
		simDR_vor_adf[1] = B777DR_efis_vor_adf[0]
		simDR_vor_adf[2] = B777DR_efis_vor_adf[1]
	end

	if B777DR_cdu_efis_ctl[1] == 1 then
		simDR_vor_adf[3] = vor_adf[2]
		simDR_vor_adf[4] = vor_adf[2]
	else
		simDR_vor_adf[4] = B777DR_efis_vor_adf[2]
		simDR_vor_adf[4] = B777DR_efis_vor_adf[3]
	end
	if not is_timer_scheduled(unloadLastPos) then
		run_after_time(unloadLastPos, 30)
	end
end

function aircraft_load()
	simDR_cg_adjust = 0 --reset CG slider to begin current flight
	run_after_time(loadLastPos, 5)
	run_after_time(closeReadme, 5.1)
end

function aircraft_unload()
	-- simDR_cg_adjust = 0 --reset CG slider to neutral for future flights s777 comment
end