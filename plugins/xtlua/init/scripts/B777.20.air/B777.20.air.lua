--[[
*****************************************************************************************
* Script Name: Air
* Author Name: remenkemi
* Script Description: Init script for pneumatics
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
	--print("Deferred dataref: "..name)
	dref=XLuaCreateDataRef(name, type,"yes",notifier)
	return wrap_dref_any(dref,type)
end

--*************************************************************************************--
--**                             CREATE CUSTOM COMMANDS                              **--
--*************************************************************************************--


--*************************************************************************************--
--**                             CREATE CUSTOM DATAREFS                              **--
--*************************************************************************************--

B777DR_bleed_valves_status = deferred_dataref("Strato/777/air/bleed_valves_status", "array[3]") -- eng 1, 2, apu
-- ^ these are for the synopticm 1 for open and 2 for flow. off vs auto will just be vars (switch pos animated off of)

--hyd

--B777DR_synoptic_flow = deferred_dataref("Strato/777/air/synoptic_flow", "number[21]")
--B777DR_synoptic_open = deferred_dataref("Strato/777/air/synoptic_open", "number[12]")


-- Anti Ice
B777DR_engine_anti_ice_valves_status = deferred_dataref("Strato/777/air/engine_anti_ice_valves_status", "array[2]") -- L, R; Is this necessary?
B777DR_wing_anti_ice_valves_status = deferred_dataref("Strato/777/air/wing_anti_ice_valves_status", "array[2]") -- L, R; is this necessary?

-- Hydraulic Pumps
B777DR_duct_press = deferred_dataref("Strato/777/air/duct_press", "array[2]") -- L, R

-- Starters
B777DR_starter_valve_status = deferred_dataref("Strato/777/air/starter_valve_status", "array[3]") -- L, R, APU

-- Air Conditioning
B777DR_zone_temps_status = deferred_dataref("Strato/777/air/zone_temps_status", "array[9]")  -- cockpit, 6 zones, aft, bulkhead, fwd
B777DR_trim_air_valves_status = deferred_dataref("Strato/777/air/trim_air_valves_status", "array[3]") -- L, R, cockpit?
B777DR_pack_valves_status = deferred_dataref("Strato/777/air/pack_valves_status", "array[2]") -- L, R
B777DR_equip_cooling_status = deferred_dataref("Strato/777/air/equip_cooling_status", "number") -- not sure if necessary, maybe just switch needed
B777DR_recirc_fan_status = deferred_dataref("Strato/777/air/recirc_fan_status", "number") -- not sure if necessary, maybe just switch needed

B777DR_zone_temps_target = deferred_dataref("Strato/777/air/zone_temps_target", "array[10]") -- cockpit, 6 zones, aft, bulkhead, fwd, master

-- Pressurization
B777DR_outflow_valve_pos_status = deferred_dataref("Strato/777/air/outflow_valve_pos_status", "array[2]") -- foreward, aft
B777DR_landing_alt_val = deferred_dataref("Strato/777/air/landing_alt_val", "number")


B777DR_pack_trim_sw_pos = deferred_dataref("Strato/777/air/pack_trim_sw_pos", "array[4]")


B777DR_air_hyd_pump_state = find_dataref("Strato/777/hydraulics/pump/primary/actual")

-- B777DR_landing_alt_man = deferred_dataref("Strato/777/air/landing_alt_man", "number") -- 0 = auto, 1 = manual -- switch will be command, go up to 500 after certain duration
-- B777DR_outflow_valve_auto_sw = deferred_dataref("Strato/777/air/outflow_valve_auto", "array[2]")
-- B777CMD_outflow_valve_open_fwd = deferred_command("Strato/777/air/outflow_fwd_open", "Forward Outflow Valve Open (Manual Mode)", outflow_fwd_open_CMDhandler)
-- B777CMD_outflow_valve_close_fwd = deferred_command("Strato/777/air/outflow_fwd_close", "Forward Outflow Valve Close (Manual Mode)", outflow_fwd_close_CMDhandler)
-- B777CMD_outflow_valve_open_aft = deferred_command("Strato/777/air/outflow_aft_open", "Aft Outflow Valve Open (Manual Mode)", outflow_aft_open_CMDhandler)
-- B777CMD_outflow_valve_close_aft = deferred_command("Strato/777/air/outflow_aft_close", "Aft Outflow Valve Close (Manual Mode)", outflow_aft_close_CMDhandler)
-- B777CMD_landing_alt_up = deferred_command("Strato/777/air/landing_alt_up", "Landing Altitude Up")
-- B777CMD_landing_alt_dn = deferred_command("Strato/777/air/landing_alt_dn", "Landing Altitude Down")
-- B777CMD_btn_engL = deferred_command("Strato/777/air/eng_L_sw", "Left Engine Bleed Switch")
-- B777CMD_btn_apu = deferred_command("Strato/777/air/apu_sw", "APU Bleed Switch")
-- B777CMD_btn_engR = deferred_command("Strato/777/air/eng_R_sw", "Right Engine Bleed Switch")


B777DR_iso_valves_sw_pos = deferred_dataref("Strato/777/air/isolation_valves_sw_pos", "array[3]") -- L, C, R
DR_iso_vlv_stat = deferred_dataref("Strato/777/air/isolation_valves_status", "array[3]") -- L, C, R


B777CMD_btn_isoL = deferred_command("Strato/777/air/isln_L_sw", "Left Isolation Valve Switch", B777_isoL_cmdHandler)
B777CMD_btn_isoC = deferred_command("Strato/777/air/isln_C_sw", "Center Isolation Valve Switch", B777_isoC_cmdHandler)
B777CMD_btn_isoR = deferred_command("Strato/777/air/isln_R_sw", "Right Isolation Valve Switch", B777_isoR_cmdHandler)

B777CMD_btn_packL = deferred_command("Strato/777/air/pack_L_sw", "Left Pack Valve Switch", function(p,d)packL:switchListener(p)end)
B777CMD_btn_packR = deferred_command("Strato/777/air/pack_R_sw", "Right Pack Valve Switch", function(p,d)packR:switchListener(p)end)
B777CMD_btn_trimL = deferred_command("Strato/777/air/trim_L_sw", "Left Trim Valve Switch", function(p,d)trimL:switchListener(p)end)
B777CMD_btn_trimR = deferred_command("Strato/777/air/trim_R_sw", "Right Trim Valve Switch", function(p,d)trimR:switchListener(p)end)