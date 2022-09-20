--[[
****************************************************************************************
* Program Script Name	:	B747.42.xt.EEC.lua
* Author Name			:	Marauder28
*							(with SIGNIFICANT contributions from @kudosi for aeronautic formulas)
*   Revisions:
*   -- DATE --	--- REV NO ---		--- DESCRIPTION ---
*   2021-01-11	0.01a				Start of Dev
*	2021-05-27	0.1					Initial Release
*
*
*
*****************************************************************************************
]]

--Load helper files
dofile("json/json.lua")
dofile("B747.42.xt.EEC.tbls.lua")


--[[
*************************************************************************************
** 				              MISC FUNCTIONS              		    	           **
*************************************************************************************
]]
function deferred_dataref(name,nilType,callFunction)
    if callFunction~=nil then
        print("WARN:" .. name .. " is trying to wrap a function to a dataref -> use xlua")
    end
    return find_dataref(name)
end

function B747_rescale(in1, out1, in2, out2, x)
    if x < in1 then
        return out1
    end
    if x > in2 then
        return out2
    end
    return out1 + (out2 - out1) * (x - in1) / (in2 - in1)
end

function round_thrustcalc(x, input_type)
    --print("x IN = "..x)  
  
    if input_type == "ALT" then
      if x < -2000 then
        x = -2000
      elseif x > 10000 then
        x = 10000
      end
      --print("x Corrected = "..x)
      return x >= 0 and math.floor((x / 1000) + 0.5) * 1000 or math.ceil((x / 1000) - 0.5) * 1000  --Alts in 1000s
    elseif input_type == "ALT-CLB" then
      if x < 0 then
        x = 0
      elseif x > 45000 then
        x = 45000
      end
      --print("x Corrected = "..x)
      return x >= 0 and math.floor((x / 5000) + 0.5) * 5000 or math.ceil((x / 5000) - 0.5) * 5000  --Alts in 5000s
    elseif input_type == "TEMP" then
  --    if x < 10 then
  --      x = 10
  --    elseif x > 70 then
  --      x = 70
  --    end
      --print("x Corrected = "..x)
      return x >= 0 and math.floor((x / 5) + 0.5) * 5 or math.ceil((x / 5) - 0.5) * 5  --Temps by 5's
    end
  end

  function find_closest_temperature(table_in, temp_target)
	local temp_table = {}
	local closest_match
	local last_difference = 99999999
	local counter = 1

	for i, v in pairs(table_in) do
		for i, v in pairs(v) do
			table.insert(temp_table, i)
		end
	end
	table.sort(temp_table)

	for i,v in pairs(temp_table) do
		local distance = math.abs(temp_target - v) --Distance away
		if distance < last_difference then
			closest_match = v
			last_difference = distance
		end
	end
	
	return closest_match
  end

	function find_closest_weight(table_in, weight_target)
		local temp_table = {}
		local closest_match
		local last_difference = 99999999
		local counter = 1

		for i, v in pairs(table_in) do
			for i, v in pairs(v) do
				table.insert(temp_table, i)
			end
		end
		table.sort(temp_table)

		for i,v in pairs(temp_table) do
			--print("Weight i, v = ", i, v)
			local distance = math.abs(weight_target - v) --Distance away
			if distance < last_difference then
				closest_match = v
				last_difference = distance
			end
		end

		return closest_match
	end

	function find_closest_altitude(table_in, alt_target)
		local temp_table = {}
		local closest_match
		local last_difference = 99999999
		local counter = 1

		for i, v in pairs(table_in) do
			for i, v in pairs(v) do
				for i, v in pairs(v) do
					table.insert(temp_table, i)
				end
			end
--			table.insert(temp_table, i)
		end
		table.sort(temp_table)

		for i,v in pairs(temp_table) do
			--print("Alt i, v = ", i, v)
			local distance = math.abs(alt_target - v) --Distance away
			if distance < last_difference then
				closest_match = v
				last_difference = distance
			end
		end

		return closest_match
	end

--[[
*************************************************************************************
** 				              FIND X-PLANE DATAREFS              		    	   **
*************************************************************************************
]]
--simDR_EEC_button			= find_dataref("laminar/B747/button_switch/position")  --array positions 7,8,9,10
simDRTime					= find_dataref("sim/time/total_running_time_sec")
simDR_onGround				= find_dataref("sim/flightmodel/failures/onground_any")
simDR_altitude				= find_dataref("sim/cockpit2/gauges/indicators/altitude_ft_pilot")
simDR_temperature			= find_dataref("sim/cockpit2/temperature/outside_air_temp_degc")
simDR_TAT					= find_dataref("sim/cockpit2/temperature/outside_air_LE_temp_degc")
simDR_EPR					= find_dataref("sim/flightmodel/engine/ENGN_EPR")
simDR_EPR_target_bug		= find_dataref("sim/cockpit2/engine/actuators/EPR_target_bug")
simDR_N1					= find_dataref("sim/flightmodel/engine/ENGN_N1_")
simDR_N1_target_bug			= find_dataref("sim/cockpit2/engine/actuators/N1_target_bug")
simDR_N2					= find_dataref("sim/flightmodel/engine/ENGN_N2_")
simDR_throttle_ratio		= find_dataref("sim/cockpit2/engine/actuators/throttle_ratio")
simDR_override_throttles	= find_dataref("sim/operation/override/override_throttles")
simDR_engn_thro				= find_dataref("sim/flightmodel/engine/ENGN_thro")
simDR_engn_thro_use			= find_dataref("sim/flightmodel/engine/ENGN_thro_use")
simDR_throttle_max			= find_dataref("sim/aircraft/engine/acf_throtmax_FWD")
simDR_acf_weight_total_kg   = find_dataref("sim/flightmodel/weight/m_total")
simDR_ias_pilot				= find_dataref("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
simDR_vvi_fpm_pilot        	= find_dataref("sim/cockpit2/gauges/indicators/vvi_fpm_pilot")
simDR_tas_pilot				= find_dataref("sim/cockpit2/gauges/indicators/true_airspeed_kts_pilot")
simDR_flap_ratio			= find_dataref("sim/cockpit2/controls/flap_ratio")
simDR_flap_handle_ratio		= find_dataref("sim/cockpit2/controls/flap_handle_deploy_ratio")
simDR_thrust_max			= find_dataref("sim/aircraft/engine/acf_tmax")
simDR_thrust_n				= find_dataref("sim/cockpit2/engine/indicators/thrust_dry_n")
simDR_engine_anti_ice		= find_dataref("laminar/B747/antiice/nacelle/valve_pos")
simDR_autopilot_gs_status	= find_dataref("sim/cockpit2/autopilot/glideslope_status")
simDR_acceleration_kts_sec_pilot    = find_dataref("sim/cockpit2/gauges/indicators/airspeed_acceleration_kts_sec_pilot")
simDR_engn_EGT_c			= find_dataref("sim/flightmodel/engine/ENGN_EGT_c")
simDR_engine_high_idle_ratio	= find_dataref("sim/aircraft2/engine/high_idle_ratio")
simDR_rpm					= find_dataref("sim/cockpit2/engine/indicators/engine_speed_rpm")
simDR_reverser_on			= find_dataref("sim/cockpit2/annunciators/reverser_on")
simDR_reverser_deploy_ratio = find_dataref("sim/flightmodel2/engines/thrust_reverser_deploy_ratio")
simDR_reverser_max			= find_dataref("sim/aircraft/engine/acf_throtmax_REV")
simDR_engine_running		= find_dataref("sim/flightmodel/engine/ENGN_running")
simDR_compressor_area		= find_dataref("sim/aircraft/engine/acf_face_jet")
simDR_autothrottle_enabled	= find_dataref("sim/cockpit2/autopilot/autothrottle_enabled")
simDR_autothrottle_on		= find_dataref("sim/cockpit2/autopilot/autothrottle_on")
simDR_engine_starter_status	= find_dataref("sim/flightmodel2/engines/starter_is_running")
B747DR_ap_autoland            	= deferred_dataref("laminar/B747/autopilot/autoland", "number")
debug_ecc     = deferred_dataref("laminar/B747/debug/ecc", "number")
--[[
*************************************************************************************
** 				              FIND X-PLANE COMMANDS              		    	   **
*************************************************************************************
]]
simCMD_autopilot_AT_off		= find_command("sim/autopilot/autothrottle_off")
simCMD_ThrottleUp			= find_command("sim/engines/throttle_up")
simCMD_ThrottleDown			= find_command("sim/engines/throttle_down")

--[[
*************************************************************************************
** 				              CUSTOM READ/WRITE DATAREFS           		    	   **
*************************************************************************************
]]
B747DR_button_switch_position	= deferred_dataref("laminar/B747/button_switch/position")
--[[
	7 - 10	= EEC buttons
	44		= CONT button
]]
--array positions 7,8,9,10
B747DR_pack_ctrl_sel_pos		= deferred_dataref("laminar/B747/air/pack_ctrl/sel_dial_pos", "array[3]")
B747DR_nacelle_ai_valve_pos     = deferred_dataref("laminar/B747/antiice/nacelle/valve_pos", "array[4)")
B747DR_TO_throttle				= deferred_dataref("laminar/B747/engines/thrustref_throttle", "number")
B747DR_ap_FMA_autothrottle_mode	= deferred_dataref("laminar/B747/autopilot/FMA/autothrottle_mode", "number")
--[[
    0 = NONE
    1 = HOLD
    2 = IDLE
    3 = SPD
    4 = THR
    5 = THR REF
--]]
B747DR_ap_autothrottle_armed	= deferred_dataref("laminar/B747/autothrottle/armed", "number")
B747DR_engine_TOGA_mode			= deferred_dataref("laminar/B747/engines/TOGA_mode", "number")
B747DR_ref_thr_limit_mode		= deferred_dataref("laminar/B747/engines/ref_thr_limit_mode", "string")
--[[
    ["NONE"]
    ["TO"]
    ["TO 1"]
    ["TO 2"]
    ["D-TO"]
    ["D-TO 1"]
    ["D-TO 2"]
    ["CLB"]
    ["CLB 1"]
    ["CLB 2"]
    ["CRZ"]
    ["CON"]
    ["GA"]
]]
B747DR_ap_FMA_active_pitch_mode     	= deferred_dataref("laminar/B747/autopilot/FMA/active_pitch_mode", "number")
--[[
    0 = NONE
    1 = TOGA
    2 = G/S
    3 = FLARE
    4 = VNAV SPD
    5 = VNAV ALT
    6 = VNAV PATH
    7 = V/S
    8 = FLCH SPD
    9 = ALT
--]]
--[[mSparks, placeholder for RR displays]]
simDR_engine_N1_pct                 = find_dataref("sim/cockpit2/engine/indicators/N1_percent")
simDR_engine_N2_pct                 = find_dataref("sim/cockpit2/engine/indicators/N2_percent")
simDR_engine_EPR					= find_dataref("sim/cockpit2/engine/indicators/EPR_ratio")
--[[end mSparks]]
B747DR_ap_ias_bug_value            	= deferred_dataref("laminar/B747/autopilot/ias_bug_value", "number")
B747DR_display_N1					= deferred_dataref("laminar/B747/engines/display_N1", "array[4]")
B747DR_display_N1_ref				= deferred_dataref("laminar/B747/engines/display_N1_ref", "array[4]")
B747DR_display_N1_max				= deferred_dataref("laminar/B747/engines/display_N1_max", "array[4]")
B747DR_display_N2					= deferred_dataref("laminar/B747/engines/display_N2", "array[4]")
B747DR_display_N3					= deferred_dataref("laminar/B747/engines/display_N3", "array[4]")
B747DR_display_EPR					= deferred_dataref("laminar/B747/engines/display_EPR", "array[4]")
B747DR_display_EPR_ref				= deferred_dataref("laminar/B747/engines/display_EPR_ref", "array[4]")
B747DR_display_EPR_max				= deferred_dataref("laminar/B747/engines/display_EPR_max", "array[4]")
B747DR_display_GE_EGT				= deferred_dataref("laminar/B747/engines/display_GE_EGT", "array[4]")
B747DR_display_EGT					= deferred_dataref("laminar/B747/engines/display_EGT", "array[4]")
B747DR_FMSdata						= deferred_dataref("laminar/B747/fms/data", "string")
B747DR_radio_altitude				= deferred_dataref("laminar/B747/efis/radio_altitude")
B747DR_altitude_dial				= deferred_dataref("laminar/B747/autopilot/heading/altitude_dial_ft")
B747DR_ap_flightPhase 				= deferred_dataref("laminar/B747/autopilot/flightPhase", "number")
B747DR_toderate						= deferred_dataref("laminar/B747/engine/derate/TO","number")
B747DR_clbderate					= deferred_dataref("laminar/B747/engine/derate/CLB","number")
B747DR_ref_line_magenta				= deferred_dataref("laminar/B747/engines/display_ref_line_magenta", "number")
B747DR_throttle_resolver_angle 		= deferred_dataref("laminar/B747/engines/TRA", "array[4]")
B747DR_engineType					= deferred_dataref("laminar/B747/engines/type", "number")

-- Holds all SimConfig options
B747DR_simconfig_data				= deferred_dataref("laminar/B747/simconfig", "string")
B747DR_newsimconfig_data				= deferred_dataref("laminar/B747/newsimconfig", "number")
--FMS data
B747DR_FMSdata						= deferred_dataref("laminar/B747/fms/data", "string")
B747DR_autothrottle_fail			= deferred_dataref("laminar/B747/engines/autothrottle_fail", "number")
B747DR_ap_vvi_fpm					= deferred_dataref("laminar/B747/autopilot/vvi_fpm")
B747DR_ap_ias_bug_value				= deferred_dataref("laminar/B747/autopilot/ias_bug_value")
B747DR_airspeed_pilot				= deferred_dataref("laminar/B747/gauges/indicators/airspeed_kts_pilot")			

--[[
*************************************************************************************
** 				              GLOBAL VARIABLES           		    	 		   **
*************************************************************************************
]]
--Constants
lbf_to_N = 4.4482216
mtrs_per_sec = 1.94384

--Logging On/Off
B747DR_log_level = deferred_dataref("laminar/B747/engines/logging", "number")  --true / false

--Simulator Config Options
simConfigData = {}

--FMS data
fmsModules = {}
fms_data = {}
fmc_alt = 0

--Atmosphere
altitude_ft = 0.0 --simDR_altitude
altitude_mtrs = 0.0 --altitude_ft * 0.3048
pressure_pa = 0.0  --pascals
pressure_ratio = 0.0
density = 0.0  --kg per m^3
temperature_K = 0.0  --kelvin
temperature_C = 0.0  --celcius
corner_temperature_K = 0.0  --kelvin
temperature_ratio = 0.0
temperature_ratio_adapted = 0.0
speed_of_sound = 0.0  --mtrs per sec
sigma_density_ratio = 0.0

--Flight Coefficients
mach = 0.0
cL = 0.0
cD = 0.0
--climb_angle_deg = 0.0
tas_mtrs_sec = 0.0
--acceleration_kts_sec = simDR_acceleration_kts_sec_pilot / 1.94384
--acceleration_mtrs_sec = 0.0  --mtrs per sec^2

--EEC Status Flag
EEC_status = 0

--General Engine Parameters
engine_max_thrust_n = 0

takeoff_TOGA_n1 = 0.0
takeoff_TOGA_EPR = 0.0

--[[
*************************************************************************************
** 				              LOCAL VARIABLES           		    	 		   **
*************************************************************************************
]]


--[[
*************************************************************************************
** 				              GLOBAL CODE                  		    	 		   **
*************************************************************************************
]]
if string.len(B747DR_simconfig_data) > 1 then
	simConfigData["data"] = json.decode(B747DR_simconfig_data)
else
	simConfigData["data"] = json.decode("[]")
end

if string.len(B747DR_FMSdata) > 1 then
	fmsModules["data"] = json.decode(B747DR_FMSdata)
else
	fmsModules["data"] = json.decode("[]")
end

B747DR_ref_line_magenta = 0
function B747_animate_value(current_value, target, min, max, speed)

    local fps_factor = math.min(0.1, speed * SIM_PERIOD)

    if target >= (max - 0.001) and current_value >= (max - 0.01) then
        return max
    elseif target <= (min + 0.001) and current_value <= (min + 0.01) then
       return min
    else
        return current_value + ((target - current_value) * fps_factor)
    end

end
--[[
*************************************************************************************
** 				              AERODYNAMIC FUNCTIONS (GLOBAL)	    	           **
*************************************************************************************
]]
function atmosphere(altitude_ft_in, delta_t_isa_K_in)
    local altitude_mtrs = altitude_ft_in * 0.3048

    if altitude_mtrs < 11000 then
        pressure_pa = (1-0.00651 * altitude_mtrs / 288.15)^5.255 * 101325
        temperature_K = 288.15 - 6.5 / 1000 * altitude_mtrs
    else
        pressure_pa = 22632 * 2.71828^(-9.81 * (altitude_mtrs - 11000) / (287 *216.65))
        temperature_K = 216.65
    end

	temperature_K = simDR_temperature + 273.15
    pressure_ratio = pressure_pa / 101325
    density = pressure_pa / (287 * temperature_K)
    temperature_C = temperature_K - 273.15
    corner_temperature_K = 7.31E-12 * altitude_ft_in^3 - 7.73E-08 * altitude_ft_in^2 - 0.00216 * altitude_ft_in + 305
    temperature_ratio = (temperature_K + delta_t_isa_K_in) / 288.15
    temperature_ratio_adapted = (temperature_K + delta_t_isa_K_in + 5) / 288.15
    speed_of_sound = math.sqrt(287 * 1.4 * temperature_K)
	sigma_density_ratio = pressure_pa / (287.058 * temperature_K * 1.225)

    if B747DR_log_level >= 1 then
		print("\t\t\t\t\t<<<--- ATMOSPHERE --->>>")
		print("Altitude IN = ", altitude_ft_in)
		print("Delta T ISA K IN = ", delta_t_isa_K_in)
		print("Altitude MTRS = ", altitude_mtrs)
		print("Pressure PA = ", pressure_pa)
		print("Pressure Ratio = ", pressure_ratio)
		print("Density = ", density)
		print("Sigma Density Ratio", sigma_density_ratio)
		print("Temperature K = ", temperature_K)
		print("Temperature C = ", temperature_C)
		print("Corner Temperature K = ", corner_temperature_K)
		print("Temperature Ratio = ", temperature_ratio)
		print("Temperature Ratio Adapted = ", temperature_ratio_adapted)
		print("Speed of Sound = ", speed_of_sound)
    --print("\n")
	end

    --return altitude_mtrs, pressure_pa, pressure_ratio, density, temperature_K, temperature_C, corner_temperature_K, temperature_ratio, temperature_ratio_adapted, speed_of_sound
end

function flight_coefficients(gw_kg_in, tas_kts_in)
	local flaps_incremental_drag = 0.0

	if tonumber(string.format("%4.3f", simDR_flap_ratio)) == 0.0 then
		flaps_incremental_drag = 0.0
	elseif tonumber(string.format("%4.3f", simDR_flap_ratio)) == 0.167 then  --Flaps 1
		flaps_incremental_drag = 0.008
	elseif tonumber(string.format("%4.3f", simDR_flap_ratio)) == 0.333 then  --Flaps 5
		flaps_incremental_drag = 0.018
	elseif tonumber(string.format("%4.3f", simDR_flap_ratio)) == 0.5 then  --Flaps 10
		flaps_incremental_drag = 0.018
	elseif tonumber(string.format("%4.3f", simDR_flap_ratio)) == 0.667 then  --Flaps 20
		flaps_incremental_drag = 0.028
	elseif tonumber(string.format("%4.3f", simDR_flap_ratio)) == 0.833 then  --Flaps 25 & Gear Down
		flaps_incremental_drag = 0.088
	elseif tonumber(string.format("%4.3f", simDR_flap_ratio)) == 1.0 then  --Flaps 30  & Gear Down
		flaps_incremental_drag = 0.108
	end

	--Removed the above flaps drag code since it was doing weird things to the initial climb calculations.  Now just use minimal flaps drag regardless of the flaps setting.
	--if tonumber(string.format("%4.3f", simDR_flap_ratio)) > 0.0 then
	--	flaps_incremental_drag = 0.008
	--else
	--	flaps_incremental_drag = 0.0
	--end

	tas_mtrs_sec = tas_kts_in / mtrs_per_sec
    mach = tas_mtrs_sec / speed_of_sound
    cL = (gw_kg_in * 9.81) / (0.5 * density * tas_mtrs_sec^2 * 511)

    if mach > 0.7 then
        cD = -1.881 + 7.115 * mach + 0.5293 * cL - 8.928 * mach^2 -1.091 * mach * cL -0.2917 * cL^2 +3.746 * mach^3 + 0.5522 * mach^2 * cL + 0.3291 * mach * cL^2 + 0.1029 * cL^3 + flaps_incremental_drag
    else
        cD = 0.106 * cL^2 - 0.0463 * cL + 0.0219 + flaps_incremental_drag
    end

    --climb_angle_deg = math.asin(0.00508 * climb_rate_fpm_in / tas_mtrs_sec) * 180 / math.pi
    --acceleration_mtrs_sec = acceleration_kts_sec_in / 1.94384

	if B747DR_log_level >= 1 then
		print("\t\t\t\t\t<<<--- FLIGHT COEFFICIENTS --->>>")
		print("Gross Weight IN = ", gw_kg_in)
		print("Mach = ", mach)
		print("Coefficient of Lift = ", cL)
		print("Coefficient of Drag = ", cD)
		print("Flap Handle = ", simDR_flap_ratio)
		print("Flaps Incremental Drag = ", flaps_incremental_drag)
		--print("Climb Angle Degrees = ", climb_angle_deg)
		print("TAS MTRS Sec = ", tas_mtrs_sec)
		--print("Acceleration MTRS Sec = ", acceleration_mtrs_sec)
		--print("\n")
	end

    --return mach, cL, cD, climb_angle_deg, tas_mtrs_sec, acceleration_mtrs_sec
	--return mach, cL, cD, tas_mtrs_sec
end


--[[
*************************************************************************************
** 				              EEC FUNCTIONS              		    	           **
*************************************************************************************
]]
function clear_thrust_targets()
	-- Clear Thrust Target Bugs
	for i = 0, 8 do
		simDR_EPR_target_bug[i] = 0.0
		simDR_N1_target_bug[i] = 0.0
	end
end

function take_off_thrust_corrected(altitude_ft_in, temperature_K_in)
	local TOGA_corrected_thrust_lbf = 0.0
	local TOGA_actual_thrust_lbf = 0.0
	local TOGA_actual_thrust_N = 0.0
	local approximate_max_TO_thrust_lbf = 0

	--Approximate TOGA Max thrust
	--  GE CFG-802C-B1F = 57160 lbf (Engine Max = 58000 lbf / 258000 Newtons)
	--  GE CFG-802C-B5F = 60030 lbf (Engine Max = 60800 lbf / 270500 Newtons)
	--  PW4056 = 56750 lbf (Engine Max = 56750 lbf / 252500 Newtons)
	--  PW4060 = 60000 lbf (Engine Max = 60000 lbf / 266900 Newtons)
	--  PW4062 = 62000 lbf (Engine Max = 62000 lbf / 275800 Newtons)
	--  RR RB211-524G = 56870 lbf (Engine Max = 58000 lbf / 258000 Newtons)
	--  RR RB211-524H = 59450 lbf (Engine Max = 60600 lbf / 269600 Newtons)
  
	if string.match(simConfigData["data"].PLANE.engines, "B1F")  then
		approximate_max_TO_thrust_lbf = 57160
	elseif string.match(simConfigData["data"].PLANE.engines, "B5F")  then
		approximate_max_TO_thrust_lbf = 60030
	elseif string.match(simConfigData["data"].PLANE.engines, "B1F1")  then
	  approximate_max_TO_thrust_lbf = 60030
	elseif string.match(simConfigData["data"].PLANE.engines, "4056") then
	    approximate_max_TO_thrust_lbf = 56750
	elseif string.match(simConfigData["data"].PLANE.engines, "4060")  then
	    approximate_max_TO_thrust_lbf = 60000
	elseif string.match(simConfigData["data"].PLANE.engines, "4062")  then
	    approximate_max_TO_thrust_lbf = 62000
	elseif string.match(simConfigData["data"].PLANE.engines, "524G")  then
	    approximate_max_TO_thrust_lbf = 56870
	elseif string.match(simConfigData["data"].PLANE.engines, "524H")  then
	    approximate_max_TO_thrust_lbf = 59450
	else
	    approximate_max_TO_thrust_lbf = 56500  --failsafe option
	end

	if temperature_K_in > corner_temperature_K then
		TOGA_corrected_thrust_lbf = (-1.79545 * (temperature_K_in / corner_temperature_K) + 2.7874) * (-0.0000546 * altitude_ft_in^2 + 1.37 * altitude_ft_in + approximate_max_TO_thrust_lbf)
	else
		TOGA_corrected_thrust_lbf = (-0.0000546 * altitude_ft_in^2 + 1.37 * altitude_ft_in + approximate_max_TO_thrust_lbf)
	end
  
	if B747DR_toderate == 1 then
	  TOGA_corrected_thrust_lbf = TOGA_corrected_thrust_lbf * 0.9
	elseif B747DR_toderate == 2 then
	  TOGA_corrected_thrust_lbf = TOGA_corrected_thrust_lbf * 0.8
	end
  
	TOGA_actual_thrust_lbf = TOGA_corrected_thrust_lbf * sigma_density_ratio  --pressure_ratio
	TOGA_actual_thrust_N = TOGA_actual_thrust_lbf * lbf_to_N
  
	if B747DR_log_level >= 1 then
	  print("\t\t\t\t\t<<<--- Takeoff Calcs --->>>")
	  print("Altitude IN = ", altitude_ft_in)
	  print("Temperature K IN = ", temperature_K_in)
	  print("Approximate Takeoff Thrust Required = ", approximate_max_TO_thrust_lbf)
	  print("TOGA Corrected LBF = ", TOGA_corrected_thrust_lbf)
	  print("TOGA Actual LBF = ", TOGA_actual_thrust_lbf)
	  print("TOGA Actual N = ", TOGA_actual_thrust_N)
	end
  
	return TOGA_corrected_thrust_lbf, TOGA_actual_thrust_lbf, TOGA_actual_thrust_N
end
  
function in_flight_thrust(gw_kg_in, climb_angle_deg_in)
	local total_thrust_required_N = 0.0
	local thrust_per_engine_N = 0.0
	local corrected_thrust_N = 0.0
	local corrected_thrust_lbf = 0.0

	total_thrust_required_N = 0.5 * cD * tas_mtrs_sec^2 * density * 511 + math.sin(climb_angle_deg_in / 180 * math.pi) * gw_kg_in * 9.81

	if B747DR_clbderate == 1 then
		total_thrust_required_N = total_thrust_required_N * B747_rescale(10000.0, 0.9, 15000.0, 1.0, simDR_altitude)  --0.9  --Scale linearly from CLB1 to CLB from 10K to 15K ft  FCOM 7/11.32.3
	elseif B747DR_clbderate == 2 then
		total_thrust_required_N = total_thrust_required_N * B747_rescale(10000.0, 0.8, 15000.0, 1.0, simDR_altitude)  --0.8  --Scale linearly from CLB1 to CLB from 10K to 15K ft
	end

	thrust_per_engine_N = total_thrust_required_N / 4

	corrected_thrust_N = thrust_per_engine_N / pressure_ratio
	corrected_thrust_lbf = corrected_thrust_N / lbf_to_N

	if B747DR_log_level >= 1 then
		print("\t\t\t\t<<<--- IN FLIGHT THRUST --->>>")
		print("Gross Weight IN = ", gw_kg_in)
		print("Climb Angle IN = ", climb_angle_deg_in)
		print("Pressure Ratio = ", pressure_ratio)
		print("Density = ", density)
		print("Coefficient of Drag = ", cD)
		print("TAS MTRS Sec = ", tas_mtrs_sec)
		print("Total Thrust Required N = ", total_thrust_required_N)
		print("Thrust per Engine N = ", thrust_per_engine_N)
		print("Corrected Thrust N = ", corrected_thrust_N)
		print("Corrected Thrust LBF = ", corrected_thrust_lbf)
	end

	return total_thrust_required_N, thrust_per_engine_N, corrected_thrust_N, corrected_thrust_lbf
end
lastNewTargetModeTime=0
lastNewTarget=""
function ecc_mode_set()
	newTarget=""
	--Set Specific sub-mode for TO or CLB
	--if (B747DR_ap_autoland==-2 or B747DR_ap_FMA_active_roll_mode ==3 ) and simDR_flap_ratio_control>0 then
	--if simDR_altitude>32000 then
	--	newTarget = "CRZ"
	--else
	if B747DR_ap_autoland==-2 or (B747DR_ap_flightPhase >= 2 and simDR_flap_ratio > 0) then
		newTarget = "GA"
	elseif B747DR_ap_flightPhase==0 then
		if B747DR_toderate == 0 then
			newTarget = "TO"
		elseif B747DR_toderate == 1 then
			newTarget = "TO 1"
		elseif B747DR_toderate == 2 then
			newTarget = "TO 2"
		end
	elseif B747DR_ap_flightPhase==1 then
		if B747DR_clbderate == 0 then
			newTarget = "CLB"
		elseif B747DR_clbderate == 1 then
			newTarget = "CLB 1"
		elseif B747DR_clbderate == 2 then
			newTarget = "CLB 2"
		end
	elseif B747DR_ap_flightPhase>=2 then
		newTarget = "CRZ"
	end
	if newTarget~=lastNewTarget then
		lastNewTarget=newTarget
		lastNewTargetModeTime=simDRTime
	end

	if simDRTime-lastNewTargetModeTime>0.25 then
		B747DR_ref_thr_limit_mode=newTarget
	end
end

local previous_altitude = 0
function throttle_management()

	--Get FMC data for CRZ ALT
	if string.len(B747DR_FMSdata) > 2 then
		fms_data["data"] = json.decode(B747DR_FMSdata)
	else
		return
		--fms_data["data"].crzalt = B747DR_altitude_dial
	end

	--Disconnect A/T if any of the EEC buttons move from NORMAL to ALTERNATE
	if (B747DR_button_switch_position[7] == 0 or B747DR_button_switch_position[8] == 0 or B747DR_button_switch_position[9] == 0 or B747DR_button_switch_position[10] == 0) and EEC_status == 0 then
		--simCMD_autopilot_AT_off:once()
		B747DR_autothrottle_fail = 1
		EEC_status = 1
		simDR_autothrottle_enabled = 0
		simDR_autothrottle_on = 0
	elseif (B747DR_button_switch_position[7] == 1 and B747DR_button_switch_position[8] == 1 and B747DR_button_switch_position[9] == 1 and B747DR_button_switch_position[10] == 1) then
		EEC_status = 0
	end
	
	if string.match(fms_data["data"].crzalt, "FL") then
		fmc_alt = tonumber(string.sub(fms_data["data"].crzalt, 3,-1)) * 100
	elseif string.match(fms_data["data"].crzalt, "*") then
		fmc_alt = 0
	else
		fmc_alt = tonumber(fms_data["data"].crzalt)
	end
	
	if B747DR_log_level >= 1 then
		print("EEC Status = ", EEC_status)
		print("FMC CRZ ALT = ", fms_data["data"].crzalt)
		print("temp FMC ALT = ", fmc_alt)
	end

	--Set EICAS Thrust Limit Mode
	if B747DR_ap_autothrottle_armed == 1 then
		--Take-off
		if B747DR_engine_TOGA_mode > 0 and B747DR_engine_TOGA_mode <= 1 and B747DR_ap_FMA_autothrottle_mode==5 then
			--B747DR_ref_thr_limit_mode = "TO"
			B747DR_ap_flightPhase=0
			--Initially set previous_altitude to the FMC cruise altitude
			previous_altitude = fmc_alt

			--Spool-up the engines for TO
			if simConfigData["data"].PLANE.thrust_ref == "N1" then
				if B747DR_display_N1[0] < B747DR_display_N1_ref[0] or B747DR_display_N1[1] < B747DR_display_N1_ref[1]
					or B747DR_display_N1[2] < B747DR_display_N1_ref[2] or B747DR_display_N1[3] < B747DR_display_N1_ref[3] then
					print("TOGA Engaged - Waiting for spool-up.....")
					simCMD_ThrottleUp:once()
					simDR_autothrottle_enabled = 2
					return
				end
			elseif simConfigData["data"].PLANE.thrust_ref == "EPR" then
				if B747DR_display_EPR[0] < B747DR_display_EPR_ref[0] or B747DR_display_EPR[1] < B747DR_display_EPR_ref[1]
					or B747DR_display_EPR[2] < B747DR_display_EPR_ref[2] or B747DR_display_EPR[3] < B747DR_display_EPR_ref[3] then
					print("TOGA Engaged - Waiting for spool-up.....")
					simCMD_ThrottleUp:once()
					simDR_autothrottle_enabled = 2
					return
				end
			end
		end
		--Set Initial Climb based on Flap position (5 degrees) if occurs prior to FMC thrust reduction point
		
		--Remove De-rate above 15000 feet
		if B747DR_clbderate > 0 and simDR_altitude >= 15000 then
			B747DR_clbderate = 0
		end

		
	end

	ecc_mode_set()

	--After landing and reversers stowed reset mode to TO
	--print("-------< ATTEMPTING TO CLEAN-UP GA MODE >-----")
	--print("On Ground = ", simDR_onGround)
	--print("Speed = ", simDR_ias_pilot)
	--print("Reverser On = ", simDR_reverser_on[1])
	--print("Reverser Deployed = ", simDR_reverser_deploy_ratio[1])
	if simDR_onGround == 1 and simDR_ias_pilot<30 -- B747DR_ref_thr_limit_mode == "GA"
		and math.max(simDR_reverser_on[0], simDR_reverser_on[1], simDR_reverser_on[2], simDR_reverser_on[3]) == 0
		and math.max(simDR_reverser_deploy_ratio[0], simDR_reverser_deploy_ratio[1], simDR_reverser_deploy_ratio[2], simDR_reverser_deploy_ratio[3]) <= 0.1 then
			--B747DR_ref_thr_limit_mode = "TO"
			B747DR_ap_flightPhase=0
	end
	--print("Flight Phase = ", B747DR_ap_flightPhase)

	--Determine FMA Mode
	--THR REF Mode
	if B747DR_ap_autothrottle_armed == 1 and B747DR_ap_FMA_autothrottle_mode == 5 
	and B747DR_ap_flightPhase<2 and EEC_status == 0 then
		--Take control of the throttles from the user and manage via Thrust Ref targets
		--hold_mode = 0
		if B747DR_ap_FMA_active_pitch_mode == 1 or B747DR_ap_FMA_active_pitch_mode == 4
		or B747DR_ap_FMA_active_pitch_mode == 5 or B747DR_ap_FMA_active_pitch_mode == 6 --then
		or B747DR_ap_FMA_active_pitch_mode == 7 or B747DR_ap_FMA_active_pitch_mode == 8
		or B747DR_ap_FMA_active_pitch_mode == 9 then
			simDR_override_throttles = 1
			simDR_autothrottle_enabled = 2
			simDR_autothrottle_on = 1
		end

		--Thrust ref target line should stay GREEN when in TOGA mode
		if string.match(B747DR_ref_thr_limit_mode, "TO") then
			B747DR_ref_line_magenta = 0
		else
			B747DR_ref_line_magenta = 1
		end
		
		if B747DR_log_level >= 1 then
			print("THR REF MODE")
			print("Override Throttles = ", simDR_override_throttles)
		end

	-- HOLD Mode
	elseif (B747DR_ap_autothrottle_armed == 1  or simDR_override_throttles == 1 ) and B747DR_ap_FMA_autothrottle_mode == 1 and EEC_status == 0 then
		--Give throttle control back to the user
		simDR_override_throttles = 0
		if simDR_autothrottle_enabled == 2 and simDR_autothrottle_on == 1 then
			simDR_autothrottle_enabled = 0
			simDR_autothrottle_on = 0
		end
		B747DR_ref_line_magenta = 0
		--hold_mode = 1

		if B747DR_log_level >= 1 then
			print("HOLD MODE")
			print("Override REMOVED = ", simDR_override_throttles)
		end

	--SPEED Mode
	elseif B747DR_ap_autothrottle_armed == 1 and B747DR_ap_FMA_autothrottle_mode == 3 and EEC_status == 0 then
		--Give throttle control back to the user
		--hold_mode = 0
		simDR_override_throttles = 0
		if simDR_autothrottle_enabled == 2 and simDR_autothrottle_on == 1 then
			simDR_autothrottle_enabled = 0
			simDR_autothrottle_on = 0
		end
		B747DR_ref_line_magenta = 0
		--speed_mode = 1
		
		if B747DR_log_level >= 1 then
			print("SPEED MODE")
			print("Override Throttles = ", simDR_override_throttles)
		end
	elseif B747DR_autothrottle_fail == 1 then
		--Autothrottle has been disabled for some reason
		simDR_autothrottle_enabled = 0
		simDR_autothrottle_on = 0
	else
		simDR_override_throttles = 0
		--simDR_autothrottle_enabled = 0
		--simDR_autothrottle_on = 0
		B747DR_ref_line_magenta = 0
		--hold_mode = 0
		--speed_mode = 0

		if B747DR_log_level >= 1 then
			print("---Setting Back to Normal---")
		end
	end

end

dofile("B747.42.xt.EEC.GE.lua")
dofile("B747.42.xt.EEC.PW.lua")
dofile("B747.42.xt.EEC.RR.lua")

function set_engines()
	--Engine Thrust Parameters based on selected engine
	if B747DR_engineType==1 then
		GE(simDR_altitude)
	elseif B747DR_engineType==0 then
		PW(simDR_altitude)
	elseif B747DR_engineType==2 then
		RR(simDR_altitude)
	else  --Assume PW engine if all else fails
		PW(simDR_altitude)
	end
end


--[[
*************************************************************************************
** 				              XP CALLBACKS              		    	           **
*************************************************************************************
]]
function aircraft_load()
	clear_thrust_targets()  --Set all thrust target bugs to 0
end

local setSimConfig=false
function hasSimConfig()
	if B747DR_newsimconfig_data==1 then
		if string.len(B747DR_simconfig_data) > 1 then
			simConfigData["data"] = json.decode(B747DR_simconfig_data)
			setSimConfig=true
		else
			return false
		end
	end
	return setSimConfig
end

function after_physics()
	if debug_ecc>0 then return end
    if hasSimConfig()==false then return end
    atmosphere(simDR_altitude, 0)
    flight_coefficients(simDR_acf_weight_total_kg, simDR_tas_pilot)

	--fmsModules["data"] = json.decode(B747DR_FMSdata)
	set_engines()
	
	--[[if string.len(B747DR_simconfig_data) > 1 then
		set_engines()
	end]]
end