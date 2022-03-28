--[[
*****************************************************************************************
*        COPYRIGHT � 2020 Mark Parker/mSparks CC-BY-NC4
*****************************************************************************************
]]

function deferred_dataref(name,type,notifier)
	print("Deffered dataref: "..name)
	dref=XLuaCreateDataRef(name, type,"yes",notifier)
	return wrap_dref_any(dref,type) 
end
B777DR_ap_vnav_pause            = deferred_dataref("strato/B777/autopilot/vnav_pause","number")
B777DR_fmc_notifications            = deferred_dataref("strato/B777/fms/notification","array[53]")
ilsData=deferred_dataref("strato/B777/radio/ilsData", "string")
acars=create_dataref("strato/B777/comm/acars","number")  
toderate=deferred_dataref("strato/B777/engine/derate/TO","number") 
clbderate=deferred_dataref("strato/B777/engine/derate/CLB","number")

radioModes=deferred_dataref("strato/B777/radio/tuningmodes", "string")
B777DR_TAS_pilot=deferred_dataref("strato/B777/nd/TAS_pilot", "number")
radioModes="AAAMM" --ils,vor l/r,adf l/r (ADF is manual only
B777DR_FMSdata=deferred_dataref("strato/B777/fms/data", "string")
B777DR_FMSdata="{}"
function createFMSDatarefs(fmsid)
create_dataref("strato/B777/"..fmsid.."/Line01_L", "string")
create_dataref("strato/B777/"..fmsid.."/Line02_L", "string")
create_dataref("strato/B777/"..fmsid.."/Line03_L", "string")
create_dataref("strato/B777/"..fmsid.."/Line04_L", "string")
create_dataref("strato/B777/"..fmsid.."/Line05_L", "string")
create_dataref("strato/B777/"..fmsid.."/Line06_L", "string")
create_dataref("strato/B777/"..fmsid.."/Line07_L", "string")
create_dataref("strato/B777/"..fmsid.."/Line08_L", "string")
create_dataref("strato/B777/"..fmsid.."/Line09_L", "string")
create_dataref("strato/B777/"..fmsid.."/Line10_L", "string")
create_dataref("strato/B777/"..fmsid.."/Line11_L", "string")
create_dataref("strato/B777/"..fmsid.."/Line12_L", "string")
create_dataref("strato/B777/"..fmsid.."/Line13_L", "string")
create_dataref("strato/B777/"..fmsid.."/Line14_L", "string")
create_dataref("strato/B777/"..fmsid.."/Line01_S", "string")
create_dataref("strato/B777/"..fmsid.."/Line02_S", "string")
create_dataref("strato/B777/"..fmsid.."/Line03_S", "string")
create_dataref("strato/B777/"..fmsid.."/Line04_S", "string")
create_dataref("strato/B777/"..fmsid.."/Line05_S", "string")
create_dataref("strato/B777/"..fmsid.."/Line06_S", "string")
create_dataref("strato/B777/"..fmsid.."/Line07_S", "string")
create_dataref("strato/B777/"..fmsid.."/Line08_S", "string")
create_dataref("strato/B777/"..fmsid.."/Line09_S", "string")
create_dataref("strato/B777/"..fmsid.."/Line10_S", "string")
create_dataref("strato/B777/"..fmsid.."/Line11_S", "string")
create_dataref("strato/B777/"..fmsid.."/Line12_S", "string")
create_dataref("strato/B777/"..fmsid.."/Line13_S", "string")
create_dataref("strato/B777/"..fmsid.."/Line14_S", "string")
end
createFMSDatarefs("fms1")
createFMSDatarefs("fms2")
createFMSDatarefs("fms3")
--*************************************************************************************--
--** 				        CREATE READ-WRITE CUSTOM DATAREFS                        **--
--*************************************************************************************--

-- CRT BRIGHTNESS DIAL ------------------------------------------------------------------
B777DR_fms1_display_brightness      = create_dataref("strato/B777/fms1/display_brightness", "number", B777_fms1_display_brightness_DRhandler)

--pos data
B777DR_waypoint_ata					= deferred_dataref("strato/B777/nd/waypoint_ata", "string")
B777DR_last_waypoint				= deferred_dataref("strato/B777/nd/last_waypoint", "string")
B777DR_destination					= deferred_dataref("strato/B777/nd/dest", "string")
B777DR_next_waypoint_eta					= deferred_dataref("strato/B777/nd/next_waypoint_eta", "string")
B777DR_next_waypoint_dist					= deferred_dataref("strato/B777/nd/next_waypoint_dist", "number")
B777DR_next_waypoint				= deferred_dataref("strato/B777/nd/next_waypoint", "string")

--Waypoint info for ND DISPLAY
B777DR_ND_waypoint_eta					= deferred_dataref("strato/B777/nd/waypoint_eta", "string")
B777DR_ND_current_waypoint				= deferred_dataref("strato/B777/nd/current_waypoint", "string")
B777DR_ND_waypoint_distance				= deferred_dataref("strato/B777/nd/waypoint_distance", "string")

--ND Range DISPLAY
B777DR_ND_range_display_capt			= deferred_dataref("strato/B777/nd/range_display_capt", "number")
B777DR_ND_range_display_fo				= deferred_dataref("strato/B777/nd/range_display_fo", "number")

--IRS ND DISPLAY
B777DR_ND_GPS_Line						= deferred_dataref("strato/B777/irs/gps_display_line", "string")
B777DR_ND_IRS_Line						= deferred_dataref("strato/B777/irs/irs_display_line", "string")

--SPEED ND DISPLAY
B777DR_ND_GS_TAS_Line					= deferred_dataref("strato/B777/nd/gs_tas_line", "string")
B777DR_ND_GS_TAS_Line_Pilot				= deferred_dataref("strato/B777/nd/gs_tas_line_pilot", "string")
B777DR_ND_GS_TAS_Line_CoPilot			= deferred_dataref("strato/B777/nd/gs_tas_line_copilot", "string")
B777DR_ND_Wind_Line						= deferred_dataref("strato/B777/nd/wind_line", "string")
B777DR_ND_Wind_Bearing					= deferred_dataref("strato/B777/nd/wind_bearing", "number")

--STAB TRIM setting
B777DR_elevator_trim				    = deferred_dataref("strato/B777/fmc/elevator_trim", "number")

--Sound Options (crazytimtimtim + Matt726)
B777DR_SNDoptions			        	= deferred_dataref("strato/B777/fmod/options", "array[7]")
--B777DR_SNDoptions_volume				= deferred_dataref("strato/B777/fmod/options/volume", "array[8]")
B777DR_SNDoptions_gpws					= deferred_dataref("strato/B777/fmod/options/gpws", "array[16]")

function createFMSCommands(fmsO,cduid,fmsid,keyid,fmskeyid)
B777CMD_fms1_ls_key_L1              = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/ls_key/L1", fmsO.." Line Select Key 1-Left")
B777CMD_fms1_ls_key_L2              = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/ls_key/L2", fmsO.." Line Select Key 2-Left")
B777CMD_fms1_ls_key_L3              = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/ls_key/L3", fmsO.." Line Select Key 3-Left")
B777CMD_fms1_ls_key_L4              = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/ls_key/L4", fmsO.." Line Select Key 4-Left")
B777CMD_fms1_ls_key_L5              = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/ls_key/L5", fmsO.." Line Select Key 5-Left")
B777CMD_fms1_ls_key_L6              = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/ls_key/L6", fmsO.." Line Select Key 6-Left")

B777CMD_fms1_ls_key_R1              = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/ls_key/R1", fmsO.." Line Select Key 1-Right")
B777CMD_fms1_ls_key_R2              = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/ls_key/R2", fmsO.." Line Select Key 2-Right")
B777CMD_fms1_ls_key_R3              = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/ls_key/R3", fmsO.." Line Select Key 3-Right")
B777CMD_fms1_ls_key_R4              = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/ls_key/R4", fmsO.." Line Select Key 4-Right")
B777CMD_fms1_ls_key_R5              = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/ls_key/R5", fmsO.." Line Select Key 5-Right")
B777CMD_fms1_ls_key_R6              = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/ls_key/R6", fmsO.." Line Select Key 6-Right")


-- FUNCTION KEYS ------------------------------------------------------------------------
B777CMD_fms1_func_key_index         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/func_key/index", fmsO.." Function Key INDEX")
B777CMD_fms1_func_key_fpln          = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/func_key/fpln", fmsO.." Function Key FPLN")
B777CMD_fms1_func_key_navrad        = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/func_key/navrad", fmsO.." Function Key FPLN")
B777CMD_fms1_func_key_clb           = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/func_key/clb", fmsO.." Function Key CLB")
B777CMD_fms1_func_key_crz           = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/func_key/crz", fmsO.." Function Key CRZ")
B777CMD_fms1_func_key_des           = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/func_key/des", fmsO.." Function Key DES")
B777CMD_fms1_func_key_dir_intc      = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/func_key/dir_intc", fmsO.." Function Key DIR/INTC")
B777CMD_fms1_func_key_legs          = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/func_key/legs", fmsO.." Function Key LEGS")
B777CMD_fms1_func_key_dep_arr       = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/func_key/dep_arr", fmsO.." Function Key DEP/ARR")
B777CMD_fms1_func_key_hold          = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/func_key/hold", fmsO.." Function Key HOLD")
B777CMD_fms1_func_key_prog          = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/func_key/prog", fmsO.." Function Key PROG")
B777CMD_fms1_key_execute            = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/key/execute", fmsO.." KEY EXEC")
B777CMD_fms1_func_key_fix           = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/func_key/fix", fmsO.." Function Key FIX")
B777CMD_fms1_func_key_prev_pg       = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/func_key/prev_pg", fmsO.." Function Key PREV PAGE")
B777CMD_fms1_func_key_next_pg       = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/func_key/next_pg", fmsO.." Function Key NEXT PAGE")


-- ALPHA-NUMERIC KEYS -------------------------------------------------------------------
B777CMD_fms1_alphanum_key_0         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/0", fmsO.." Alpha/Numeric Key 0")
B777CMD_fms1_alphanum_key_1         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/1", fmsO.." Alpha/Numeric Key 1")
B777CMD_fms1_alphanum_key_2         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/2", fmsO.." Alpha/Numeric Key 2")
B777CMD_fms1_alphanum_key_3         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/3", fmsO.." Alpha/Numeric Key 3")
B777CMD_fms1_alphanum_key_4         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/4", fmsO.." Alpha/Numeric Key 4")
B777CMD_fms1_alphanum_key_5         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/5", fmsO.." Alpha/Numeric Key 5")
B777CMD_fms1_alphanum_key_6         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/6", fmsO.." Alpha/Numeric Key 6")
B777CMD_fms1_alphanum_key_7         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/7", fmsO.." Alpha/Numeric Key 7")
B777CMD_fms1_alphanum_key_8         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/8", fmsO.." Alpha/Numeric Key 8")
B777CMD_fms1_alphanum_key_9         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/9", fmsO.." Alpha/Numeric Key 9")

B777CMD_fms1_key_period             = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/key/period", fmsO.." Key '.'")
B777CMD_fms1_key_minus              = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/key/minus", fmsO.." Key '+/-'")

B777CMD_fms1_alphanum_key_A         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/A", fmsO.." Alpha/Numeric Key A")
B777CMD_fms1_alphanum_key_B         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/B", fmsO.." Alpha/Numeric Key B")
B777CMD_fms1_alphanum_key_C         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/C", fmsO.." Alpha/Numeric Key C")
B777CMD_fms1_alphanum_key_D         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/D", fmsO.." Alpha/Numeric Key D")
B777CMD_fms1_alphanum_key_E         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/E", fmsO.." Alpha/Numeric Key E")
B777CMD_fms1_alphanum_key_F         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/F", fmsO.." Alpha/Numeric Key F")
B777CMD_fms1_alphanum_key_G         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/G", fmsO.." Alpha/Numeric Key G")
B777CMD_fms1_alphanum_key_H         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/H", fmsO.." Alpha/Numeric Key H")
B777CMD_fms1_alphanum_key_I         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/I", fmsO.." Alpha/Numeric Key I")
B777CMD_fms1_alphanum_key_J         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/J", fmsO.." Alpha/Numeric Key J")
B777CMD_fms1_alphanum_key_K         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/K", fmsO.." Alpha/Numeric Key K")
B777CMD_fms1_alphanum_key_L         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/L", fmsO.." Alpha/Numeric Key L")
B777CMD_fms1_alphanum_key_M         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/M", fmsO.." Alpha/Numeric Key M")
B777CMD_fms1_alphanum_key_N         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/N", fmsO.." Alpha/Numeric Key N")
B777CMD_fms1_alphanum_key_O         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/O", fmsO.." Alpha/Numeric Key O")
B777CMD_fms1_alphanum_key_P         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/P", fmsO.." Alpha/Numeric Key P")
B777CMD_fms1_alphanum_key_Q         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/Q", fmsO.." Alpha/Numeric Key Q")
B777CMD_fms1_alphanum_key_R         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/R", fmsO.." Alpha/Numeric Key R")
B777CMD_fms1_alphanum_key_S         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/S", fmsO.." Alpha/Numeric Key S")
B777CMD_fms1_alphanum_key_T         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/T", fmsO.." Alpha/Numeric Key T")
B777CMD_fms1_alphanum_key_U         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/U", fmsO.." Alpha/Numeric Key U")
B777CMD_fms1_alphanum_key_V         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/V", fmsO.." Alpha/Numeric Key V")
B777CMD_fms1_alphanum_key_W         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/W", fmsO.." Alpha/Numeric Key W")
B777CMD_fms1_alphanum_key_X         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/X", fmsO.." Alpha/Numeric Key X")
B777CMD_fms1_alphanum_key_Y         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/Y", fmsO.." Alpha/Numeric Key Y")
B777CMD_fms1_alphanum_key_Z         = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/alphanum_key/Z", fmsO.." Alpha/Numeric Key Z")

B777CMD_fms1_key_space              = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/key/space", fmsO.." KEY SP")
B777CMD_fms1_key_del                = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/key/del", fmsO.." KEY DEL")
B777CMD_fms1_key_slash              = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/key/slash", fmsO.." Key '/'")
B777CMD_fms1_key_clear              = XLuaCreateCommand("strato/B777/".. fmskeyid .. "/key/clear", fmsO.." KEY CLR")
end

createFMSCommands("FMS C","cdu1","fms1","sim/FMS/","fms3")

createFMSCommands("FMS L","cdu1","fms3","sim/FMS/","fms1")

createFMSCommands("FMS R","cdu1","fms2","sim/FMS/","fms2")
