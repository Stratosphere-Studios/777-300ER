--[[
*****************************************************************************************
* Script Name: manipulators
* Author Name: remenkemi (crazytimtimtim)
* Script Description: functions for cockpit switches
*****************************************************************************************
--]]
-- RUDDER TRIM KNOB IS IN FLIGHT INSTRUMENTS
function null_command(phase, duration)
end
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
--**                              CREATE CUSTOM COMMANDS                             **--
--*************************************************************************************--

---MCP----------

B777CMD_mcp_ap_engage_1                   = deferred_command("Strato/B777/button_switch/mcp/ap/engage_1", "Engage A/P 1", B777_ap_engage_switch_1_CMDhandler)
B777CMD_mcp_ap_engage_2                   = deferred_command("Strato/B777/button_switch/mcp/ap/engage_2", "Engage A/P 2", B777_ap_engage_switch_2_CMDhandler)
B777CMD_mcp_ap_disengage_switch           = deferred_command("Strato/B777/button_switch/mcp/ap/disengage", "Disengage A/P", B777_ap_disengage_switch_CMDhandler)

B777CMD_mcp_autothrottle_spd_mode         = deferred_command("Strato/B777/button_switch/mcp/autothrottle/spd", "Autothrottle Speed Mode", B777_autothrottle_spd_switch_CMDhandler)
B777CMD_mcp_autothrottle_clbcon_mode      = deferred_command("Strato/B777/button_switch/mcp/autothrottle/clbcon", "CLB/CON Mode", B777_autothrottle_clbcon_switch_CMDhandler)
--B777CMD_mcp_autothrottle_switch_2         = deferred_command("Strato/B777/button_switch/mcp/autothrottle/switch_2", "Autothrottle Switch 2", B777_autothrottle_switch_2_CMDhandler)

B777CMD_mcp_ap_loc                        = deferred_command("Strato/B777/button_switch/mcp/ap/loc", "Localizer A/P Mode", B777_ap_loc_switch_CMDhandler)
B777CMD_mcp_ap_app                        = deferred_command("Strato/B777/button_switch/mcp/ap/app", "Approach A/P Mode", B777_ap_app_switch_CMDhandler)
B777CMD_mcp_ap_altHold                    = deferred_command("Strato/B777/button_switch/mcp/ap/altHold", "Altitude Hold A/P Mode", B777_ap_altHold_switch_CMDhandler)
B777CMD_mcp_ap_vs                         = deferred_command("Strato/B777/button_switch/mcp/ap/vs", "Vertical Speed A/P Mode", B777_ap_vs_switch_CMDhandler)
B777CMD_mcp_ap_hdgHold                    = deferred_command("Strato/B777/button_switch/mcp/ap/hdgHold", "Heading Hold A/P Mode", B777_ap_hdgHold_switch_CMDhandler)
B777CMD_mcp_ap_hdgSel                     = deferred_command("Strato/B777/button_switch/mcp/ap/hdgSel", "Heading Select A/P Mode", B777_ap_hdgSel_switch_CMDhandler)
B777CMD_mcp_ap_lnav                       = deferred_command("Strato/B777/button_switch/mcp/ap/lnav", "LNAV A/P Mode", B777_ap_lnav_switch_CMDhandler)
B777CMD_mcp_ap_vnav                       = deferred_command("Strato/B777/button_switch/mcp/ap/vnav", "VNAV A/P Mode", B777_ap_vnav_switch_CMDhandler)
B777CMD_mcp_ap_flch                       = deferred_command("Strato/B777/button_switch/mcp/ap/flch", "FLCH A/P Mode", B777_ap_flch_switch_CMDhandler)

---OVERHEAD----------

--FORWARD-----

--LIGHT SWITCHES USE THEIR RESPECTIVE DEFAULT DATAREFS

--CENTER-----

-- RAM AIR TURBINE USES DEFAULT DATAREF: sim/cockpit2/switches/ram_air_turbine_on

--AFT-----

B777CMD_ail_trim_r                        = deferred_command("Strato/777/cockpit/ail_trim_r", "Aileron Trim ", ail_trim_r_CMDhandler)
B777CMD_ail_trim_l                        = deferred_command("Strato/777/cockpit/ail_trim_l", "Aileron Trim ", ail_trim_l_CMDhandler)

---MAIN PANEL----------

--GEAR LEVER USES DEFAULT DATAREF: sim/cockpit/switches/gear_handle_status

---CENTER PED 1 (FWD)----------

B777CMD_ctr1_at_disco                     = deferred_command("Strato/B777/button_switch/ctr1/at_disco", "Autothrottle Disconnect", B777_ctr1_at_disco_CMDhandler)
B777CMD_ctr1_toga                         = deferred_command("Strato/B777/button_switch/ctr1/toga", "TOGA switch", B777_ctr1_toga_CMDhandler)

---OTHER---------------

B777CMD_cockpit_door                      = deferred_command("Strato/B777/knob_switch/cockpit_door", "Cockpit Door Knob", B777_cockpit_door_CMDhandler)

--*************************************************************************************--
--**                              CREATE CUSTOM DATAREFS                             **--
--*************************************************************************************--

testNum                                   = deferred_dataref("testNum", "number")

B777DR_mcp_button_pos                     = deferred_dataref("Strato/777/cockpit/mcp/buttons/position", "array[18]")
B777DR_mcp_button_target                  = deferred_dataref("Strato/777/cockpit/mcp/buttons/target", "array[18]")

B777DR_ovhd_fwd_button_positions          = deferred_dataref("Strato/777/cockpit/ovhd/fwd/buttons/position", "array[20]")
B777DR_ovhd_ctr_button_positions          = deferred_dataref("Strato/777/cockpit/ovhd/ctr/buttons/position", "array[20]")
B777DR_ovhd_aft_button_positions          = deferred_dataref("Strato/777/cockpit/ovhd/aft/buttons/position", "array[20]")

B777DR_ovhd_ctr_button_target             = deferred_dataref("Strato/777/cockpit/ovhd/ctr/buttons/target", "array[46]")
B777DR_ovhd_aft_button_target             = deferred_dataref("Strato/777/cockpit/ovhd/aft/buttons/target", "array[24]")

B777DR_ctr1_button_pos                    = deferred_dataref("Strato/777/cockpit/ctr/fwd/buttons/position", "array[8]")

B777DR_ovhd_ctr_cover_positions           = deferred_dataref("Strato/777/cockpit/ovhd/ctr/button_cover/position", "array[5]")
B777DR_ovhd_aft_cover_positions           = deferred_dataref("Strato/777/cockpit/ovhd/aft/button_cover/position", "array[7]")
B777DR_main_cover_positions               = deferred_dataref("Strato/777/cockpit/main_pnl/button_cover/position", "array[5]")
B777DR_ctr_cover_positions                = deferred_dataref("Strato/777/cockpit/ctr/button_cover/position", "array[4]")

B777DR_ovhd_ctr_cover_target              = deferred_dataref("Strato/777/cockpit/ovhd/ctr/button_cover/target", "array[5]")
B777DR_ovhd_aft_cover_target              = deferred_dataref("Strato/777/cockpit/ovhd/aft/button_cover/target", "array[6]")
B777DR_main_cover_target                  = deferred_dataref("Strato/777/cockpit/main_pnl/button_cover/target", "array[5]")
B777DR_ctr_cover_target                   = deferred_dataref("Strato/777/cockpit/ctr/button_cover/target", "array[4]")

B777DR_cockpit_door_pos                   = deferred_dataref("Strato/777/cockpit_door_pos", "number")

B777DR_hyd_primary_switch_pos             = deferred_dataref("Strato/cockpit/ovhd/hyd/primary_pumps/button_pos", "array[4]")
B777DR_hyd_demand_switch_pos              = deferred_dataref("Strato/cockpit/ovhd/hyd/demand_pumps/button_pos", "array[4]")

B777DR_gear_altn_extnsn_pos               = deferred_dataref("Strato/777/gear_alt_extnsn_pos", "number")

B777DR_cockpit_panel_lights_brightness    = deferred_dataref("Strato/777/cockpit/cockpit_panel_lights", "array[6]")
B777DR_cockpit_panel_lights_knob_pos      = deferred_dataref("Strato/777/cockpit/cockpit_panel_lights_knob_pos", "array[6]")

B777DR_cockpit_door_target                = deferred_dataref("Strato/cockpit/door_target", "number")
B777DR_rudder_trim_ctr                    = deferred_dataref("Strato/777/cockpit/rudder_trim_ctr", "number")
B777DR_ail_trim                           = deferred_dataref("Strato/777/cockpit/ail_trim", "number")
