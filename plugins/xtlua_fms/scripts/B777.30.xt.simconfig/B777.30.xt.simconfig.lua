---@diagnostic disable: param-type-mismatch
--[[
*****************************************************************************************
* Program Script Name	:	B777.20.xt.simconfig
* Author Name			:	Marauder28
* Converted to 777 by remenkemi

-- wait... why am i using json between modules... I need to make datarefs for them anyway so might as well just do that directly

*****************************************************************************************
--]]

-- update any time the data being written to the config file is changed. makes sure config file is same version as aircraft
local version = 5

--replace create_command
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

--*************************************************************************************--
--**                                Find Datarefs                                    **--
--*************************************************************************************--

dofile("../../../libs/json/json.lua")

--simDR_livery_path			= find_dataref("sim/aircraft/view/acf_livery_path")

--Baro Sync
simDR_baro_capt				= find_dataref("sim/cockpit/misc/barometer_setting")
simDR_baro_fo				= find_dataref("sim/cockpit/misc/barometer_setting2")

--*************************************************************************************--
--** 				              CREATE CUSTOM DATAREFS                             **--
--*************************************************************************************--

-- Holds all SimConfig options
B777DR_simconfig_data       = deferred_dataref("Strato/777/simconfig", "string")
B777DR_newsimconfig_data    = deferred_dataref("Strato/777/newsimconfig", "number")

B777DR_SNDoptions           = deferred_dataref("Strato/777/fmod/options", "array[7]")
B777DR_SNDoptions_volume    = deferred_dataref("Strato/777/fmod/options/volume", "array[8]") --TODO
B777DR_SNDoptions_gpws      = deferred_dataref("Strato/777/fmod/options/gpws", "array[16]")

B777DR_acf_is_freighter     = deferred_dataref("Strato/777/acf_is_freighter", "number")
B777DR_lbs_kgs              = deferred_dataref("Strato/777/lbs_kgs", "number")
B777DR_trs_bug_enabled      = deferred_dataref("Strato/777/displays/trs_bug_enabled", "number")
B777DR_aoa_enabled          = deferred_dataref("Strato/777/displays/pfd_aoa_enabled", "number")
B777DR_smart_knobs          = deferred_dataref("Strato/777/smart_knobs", "number")
B777DR_pfd_mach_gs          = deferred_dataref("Strato/777/pfd_mach_gs", "number")

--*************************************************************************************--
--** 				        MAIN PROGRAM LOGIC                                       **--
--*************************************************************************************--
local fileLocation = "Output/preferences/Strato_777_config.json"

local simConfigData = {}

function defaultValues()
	return {
		VERSION = version,
		SOUND = {
			paOption = 1,
			musicOption = 1,
			PM_toggle = 1,
			V1Option = 1,
			GPWSminimums = 1,
			GPWSapproachingMinimums = 1,
			GPWS2500 = 1,
			GPWS1000 = 1,
			GPWS500 = 1,
			GPWS400 = 1,
			GPWS300 = 1,
			GPWS200 = 1,
			GPWS100 = 1,
			GPWS50 = 1,
			GPWS40 = 1,
			GPWS30 = 1,
			GPWS20 = 1,
			GPWS10 = 1
		},
		FMC = {
			drag_ff = "+0.0/+0.0",
			unlocked = 0, -- 1 if readme code unlocked, 0 if locked
			min_fuel_temp = -37, -- options are -37 (Jet A), -44 (Jet A1), and -60 (Jet B), in addition to other
			keyboard_input = 0 -- use keyboard for fmc and lower eicas cpdlc input, 0 off 1 on
			--autoGRWT = 1,
			--TO_derates = 1,
			--CLB_derates = 1,
			--CLB_derate_washout = 12000, -- ft, this is from pmdg. other option is 30000ft
			--company_spd = 300, -- pmdg
			--CRZ_thr_lim = "CRZ", -- pmdg, other option is CLB
			--dflt_accel_ht = 1500,
			--dflt_eng_out_ht = 800,
			--dflt_flap_alt = 1500,
			--dflt_trans_alt = 18000
		},
		--INSTRUMENTS = {},
		--SYSTEMS = {},
		--OPTIONS = {},
		PLANE = {
			aircraft_type = 0, -- 0 = pax, 1 = Freighter
			weight_display_units = "LBS", --"LBS", "KGS"
			iru_align_real = 1, -- 1 = real, else = time in seconds
			real_park_brake = 1, -- 0 = real, 1 = simple
			trs_bug = 1, -- 0 = disabled, 1 = enabled
			aoa_indicator = 1, -- 0 = disabled, 1 = enabled
			smart_knobs = 0, -- 0 = disabled, 1 = enabled
			baro_mins_sync = 0, -- 0 = no sync, 1 = sync to capt, 2 = sync to fo
			gs_mach_indicator = 1, -- 0 = disabled, 1 = enabled
			transponder_type = 0, -- 0, 1, 2, 3, 4
			nosewheel_ctrl = 0, -- 0 = independant, 1 = yaw, 2 = roll; will also link rudder to roll while on ground when in roll mode
			gasper_switch = 0, -- 0 = not installed, 1 = installed
			takeoff_chk_btn = 0, -- 0 = not installed, 1 = installed
			--raas = 1,
			--satcom = 1,
			--tailskid = 1,
			--apu_to_pack = 1, -- this is an option?
			--temp units = 1, -- for ac info
			--cabin signs = 1,
			--clock_digital = 0,
			--adf_installed = 1,
			--capture_gs_before_loc = 1, -- allow/deny
			--auto_lnav_GA = 1, -- automatic lnav on go around
		}
	}
end
local defaultValuesJSON = json.encode(defaultValues())

function baro_sync()
	if getSimConfig("PLANE","baro_mins_sync") == 1 then
		simDR_baro_fo = simDR_baro_capt
	elseif getSimConfig("PLANE","baro_mins_sync") == 2 then
		simDR_baro_capt = simDR_baro_fo
	end
end

function readmeCode() -- sets file to boeing for any users used to the old system. will eventually delete that file
	local file = io.open("Output/777 Readme Code.txt", "r")
	if file then
		file:close()
		file = io.open("Output/777 Readme Code.txt", "w")
		file:write("Enter this code into the FMS to unlock the flight instruments: \"BOEING\"\nNOTE: the code has moved to the readme itself and this file will soon be removed.")
		file:close()
	end
	--print("created readme code "..B777DR_readme_code)
end

function setSoundOption(key,value)
	if key == "paOption" then B777DR_SNDoptions[2] = value end
	if key == "musicOption" then B777DR_SNDoptions[3] = value end
	if key == "PM_toggle" then B777DR_SNDoptions[4] = value end
	if key == "V1Option" then B777DR_SNDoptions[5] = value end
	if key == "GPWSminimums" then B777DR_SNDoptions_gpws[1] = value end
	if key == "GPWSapproachingMinimums" then B777DR_SNDoptions_gpws[2] = value end
	if key == "GPWS2500" then B777DR_SNDoptions_gpws[3] = value end
	if key == "GPWS1000" then B777DR_SNDoptions_gpws[4] = value end
	if key == "GPWS500" then B777DR_SNDoptions_gpws[5] = value end
	if key == "GPWS400" then B777DR_SNDoptions_gpws[6] = value end
	if key == "GPWS300" then B777DR_SNDoptions_gpws[7] = value end
	if key == "GPWS200" then B777DR_SNDoptions_gpws[8] = value end
	if key == "GPWS100" then B777DR_SNDoptions_gpws[9] = value end
	if key == "GPWS50" then B777DR_SNDoptions_gpws[10] = value end
	if key == "GPWS40" then B777DR_SNDoptions_gpws[11] = value end
	if key == "GPWS30" then B777DR_SNDoptions_gpws[12] = value end
	if key == "GPWS20" then B777DR_SNDoptions_gpws[13] = value end
	if key == "GPWS10" then B777DR_SNDoptions_gpws[14] = value end
	if key == "GPWS5" then B777DR_SNDoptions_gpws[15] = value end
end

function getSimConfig(p1, p2)
    if simConfigData[p1] then
		if simConfigData[p1][p2] then
			return simConfigData[p1][p2]
		end
    end
    print("ERROR: Attempt to get invalid simconfig value in SIMCONFIG")
	return "fail"
end

function setSimConfig(p1, p2, value)
	if simConfigData[p1] then
		if simConfigData[p1][p2] then
			simConfigData[p1][p2] = value
			B777DR_simconfig_data = json.encode(simConfigData["values"])
			B777DR_newsimconfig_data = 1
			return "success"
		end
	end
	print("ERROR: Attempt to set invalid simconfig value in SIMCONFIG.")
	return "fail"
end

function setLoadedConfigs()
	for key, value in pairs(simConfigData.SOUND) do
		setSoundOption(key,value)
	end
	B777DR_lbs_kgs = getSimConfig("PLANE", "weight_display_units") == "LBS" and 1 or 0;
	B777DR_realistic_prk_brk = getSimConfig("PLANE","real_park_brake")
	B777DR_smart_knobs = getSimConfig("PLANE","smart_knobs")
	B777DR_pfd_mach_gs = getSimConfig("PLANE","gs_mach_indicator")
	B777DR_trs_bug_enabled = getSimConfig("PLANE","trs_bug")
	B777DR_aoa_enabled = getSimConfig("PLANE","aoa_indicator")
	B777DR_acf_is_freighter = getSimConfig("PLANE","aircraft_type")
	if getSimConfig("FMC", "unlocked") == 0 then
		if jit.os == "Windows" then
			os.execute("mshta javascript:alert(\"Please read the readme before asking questions. It's located in the 777's folder. To unlock the aircraft, find the unlocking instructions in the readme. Do not close the black console window. Happy flying!\");close();")
		elseif jit.os == "Linux" then
			os.execute("notify-send \"Please read the 777 readme before asking questions. It's located in the 777's folder. To unlock the aircraft, find the unlocking instructions in the readme. Do not close the black console window. Happy flying!\"")
		elseif jit.os == "OSX" then
			os.execute("osascript -e 'display alert \"Read 777 Readme\" message \"Please read the 777 readme before asking questions. It's located in the 777's folder. To unlock the aircraft, find the unlocking instructions in the readme. Do not close the black console window. Happy flying!\"")
		end
	end
end

function loadSimConfig()
	readmeCode()
	--os.remove("Output/preferences/Strato_777_config.dat") -- remove .dat version (switched to .json)
	--print("File = "..fileLocation)
	local file = io.open(fileLocation, "r")

	if file then
		local data = file:read()

		if data:match("\"VERSION\":"..version) then
			B777DR_simconfig_data = data
		else -- this is very dumb
			if jit.os == "Windows" then
				os.execute("mshta javascript:alert(\"The 777's settings file is from an older version. Settings have been reset.\");close();")
			elseif jit.os == "Linux" then
				os.execute("notify-send \"The 777's settings file is from an older version. Settings have been reset.\"")
			elseif jit.os == "OSX" then
				os.execute("osascript -e 'display alert \"Out Of Date 777 Settings\" message \"The 777's settings file is from an older version. Settings have been reset.\"")
			end
			B777DR_simconfig_data = defaultValuesJSON
		end
	else
		local newFile = io.open(fileLocation, "w")
		B777DR_simconfig_data = defaultValuesJSON
		newFile:write(defaultValuesJSON)
		newFile:close()
	end

	file:close()

	--print("simconfig: "..B777DR_simconfig_data)
	B777DR_newsimconfig_data = 1
	run_after_time(setLoadedConfigs, 1)
end

function flight_start()
	loadSimConfig()
end

--function aircraft_load()

function noNewData()
	B777DR_newsimconfig_data = 0
end

function hasSimConfig()
	if B777DR_newsimconfig_data == 1 and B777DR_simconfig_data:len() > 2 then
		local file = io.open(fileLocation, "w")
		local data = B777DR_simconfig_data
		simConfigData = json.decode(data)
		--print(data)
		file:write(data)
		file:close()
		if not is_timer_scheduled(noNewData) then run_after_time(noNewData, 0.2) end
	end
end

function after_physics()
---@diagnostic disable-next-line: unused-local
	local temp1, temp2 = B777DR_newsimconfig_data, B777DR_simconfig_data -- keep data fresh
	hasSimConfig()
	baro_sync()
end