--[[
*****************************************************************************************
* Script Name: manipulators
* Author Name: crazytimtimtim
* Script Description: functions for cockpit switches
*****************************************************************************************
--]]

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
	--print("Deffereed dataref: "..name)
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

B777CMD_mcp_flightdirector_capt           = deferred_command("Strato/B777/button_switch/mcp/fd/capt", "Captain Flight Director Switch", B777_fd_capt_CMDhandler)
--B777CMD_mcp_flightdirector_capt_off       = deferred_command("Strato/B777/button_switch/mcp/fd/capt/off", "Captain Flight Director Switch Off", B777_fd_capt_dn_CMDhandler)

B777CMD_mcp_flightdirector_fo             = deferred_command("Strato/B777/button_switch/mcp/fd/fo", "F/O Flight Director Switch", B777_fd_fo_CMDhandler)
--B777CMD_mcp_flightdirector_fo_off         = deferred_command("Strato/B777/button_switch/mcp/fd/fo/off", "F/O Flight Director Switch Off", B777_fd_fo_dn_CMDhandler)

B777CMD_mcp_autothrottle_switch           = deferred_command("Strato/B777/button_switch/mcp/autothrottle/switch_1", "Autothrottle Switch 1", B777_autothrottle_switch_CMDhandler)
B777CMD_mcp_autothrottle_spd_mode         = deferred_command("Strato/B777/button_switch/mcp/autothrottle/spd", "Autothrottle Speed Mode", B777_autothrottle_spd_switch_CMDhandler)
B777CMD_mcp_autothrottle_spd_mode         = deferred_command("Strato/B777/button_switch/mcp/autothrottle/clbcon", "CLB/CON Mode", B777_autothrottle_clbcon_switch_CMDhandler)
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

---EFIS CONTROL----------

B777CMD_efis_lEicas_eng                   = deferred_command("Strato/B777/button_switch/efis/lEicas/eng", "Lower Eicas ENG Page", B777_efis_lEicas_eng_switch_CMDhandler)
B777CMD_efis_lEicas_stat                  = deferred_command("Strato/B777/button_switch/efis/lEicas/stat", "Lower Eicas STAT Page", B777_efis_lEicas_stat_switch_CMDhandler)
B777CMD_efis_lEicas_elec                  = deferred_command("Strato/B777/button_switch/efis/lEicas/elec", "Lower Eicas ELEC Page", B777_efis_lEicas_elec_switch_CMDhandler)
B777CMD_efis_lEicas_hyd                   = deferred_command("Strato/B777/button_switch/efis/lEicas/hyd", "Lower Eicas HYD Page", B777_efis_lEicas_hyd_switch_CMDhandler)
B777CMD_efis_lEicas_fuel                  = deferred_command("Strato/B777/button_switch/efis/lEicas/fuel", "Lower Eicas FUEL Page", B777_efis_lEicas_fuel_switch_CMDhandler)
B777CMD_efis_lEicas_air                   = deferred_command("Strato/B777/button_switch/efis/lEicas/air", "Lower Eicas AIR Page", B777_efis_lEicas_air_switch_CMDhandler)
B777CMD_efis_lEicas_door                  = deferred_command("Strato/B777/button_switch/efis/lEicas/door", "Lower Eicas DOOR Page", B777_efis_lEicas_door_switch_CMDhandler)
B777CMD_efis_lEicas_gear                  = deferred_command("Strato/B777/button_switch/efis/lEicas/gear", "Lower Eicas GEAR Page", B777_efis_lEicas_gear_switch_CMDhandler)
B777CMD_efis_lEicas_fctl                  = deferred_command("Strato/B777/button_switch/efis/lEicas/fctl", "Lower Eicas FCTL Page", B777_efis_lEicas_fctl_switch_CMDhandler)
B777CMD_efis_lEicas_cam                   = deferred_command("Strato/B777/button_switch/efis/lEicas/cam", "Lower Eicas CAM Page", B777_efis_lEicas_cam_switch_CMDhandler)
B777CMD_efis_lEicas_chkl                  = deferred_command("Strato/B777/button_switch/efis/lEicas/chkl", "Lower Eicas CHKL Page", B777_efis_lEicas_chkl_switch_CMDhandler)

B777CMD_efis_wxr_button                   = deferred_command("Strato/B777/button_switch/efis/wxr", "ND Weather Radar Button", B777_efis_wxr_switch_CMDhandler)
B777CMD_efis_sta_button                   = deferred_command("Strato/B777/button_switch/efis/sta", "ND STA Button", B777_efis_sta_switch_CMDhandler)
B777CMD_efis_wpt_button                   = deferred_command("Strato/B777/button_switch/efis/wpt", "ND Waypoint Button", B777_efis_wpt_switch_CMDhandler)
B777CMD_efis_tfc_button                   = deferred_command("Strato/B777/button_switch/efis/tfc", "ND Traffic Button", B777_efis_tfc_switch_CMDhandler)
B777CMD_efis_apt_button                   = deferred_command("Strato/B777/button_switch/efis/apt", "ND Airport Button", B777_efis_apt_switch_CMDhandler)
B777CMD_efis_mtrs_capt                    = deferred_command("Strato/B777/button_switch/efis/mtrs_capt", "Toggle Meters on PFD (Captain)", B777_efis_mtrs_capt_CMDhandler)

---OVERHEAD----------

--FORWARD-----

--LIGHT SWITCHES USE THEIR RESPECTIVE DEFAULT DATAREFS

--CENTER-----

B777CMD_ovhd_c_batt_button                = deferred_command("Strato/B777/button_switch/ovhd_c/batt", "Battery Switch", B777_ovhd_c_batt_switch_CMDhandler)
B777CMD_ovhd_c_apu_gen_button             = deferred_command("Strato/B777/button_switch/ovhd_c/apu_gen", "APU Generator Switch", B777_ovhd_c_apu_gen_switch_CMDhandler)

B777CMD_ovhd_c_eng_gen_l_button           = deferred_command("Strato/B777/button_switch/ovhd_c/eng_gen1", "L Engine Generator Switch", B777_ovhd_c_eng_gen_l_switch_CMDhandler)
B777CMD_ovhd_c_eng_gen_r_button           = deferred_command("Strato/B777/button_switch/ovhd_c/eng_gen2", "R Engine Generator Switch", B777_ovhd_c_eng_gen_r_switch_CMDhandler)
--B777CMD_ovhd_c_bus_tie_l_button           = deferred_command("Strato/B777/button_switch/ovhd_c/apu_gen", "L Bus Tie Switch", B777_ovhd_c_bus_tie_l_switch_CMDhandler)
--B777CMD_ovhd_c_bus_tie_r_button           = deferred_command("Strato/B777/button_switch/ovhd_c/apu_gen", "R Bus Tie Switch", B777_ovhd_c_bus_tie_r_switch_CMDhandler)
--B777CMD_ovhd_c_ext_pwr_button             = deferred_command("Strato/B777/button_switch/ovhd_c/apu_gen", "External Power Switch", B777_ovhd_c_ext_pwr_switch_CMDhandler)
--EXTERNAL POWER IS IN ELECTRICAL MODULE

-- RAM AIR TURBINE USES DEFAULT DATAREF: sim/cockpit2/switches/ram_air_turbine_on

--AFT-----


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

B777DR_efis_button_positions              = deferred_dataref("Strato/777/cockpit/efis/buttons/position", "array[10]")

B777DR_ovhd_fwd_button_positions          = deferred_dataref("Strato/777/cockpit/ovhd/fwd/buttons/position", "array[20]")
B777DR_ovhd_ctr_button_positions          = deferred_dataref("Strato/777/cockpit/ovhd/ctr/buttons/position", "array[20]")
B777DR_ovhd_aft_button_positions          = deferred_dataref("Strato/777/cockpit/ovhd/aft/buttons/position", "array[20]")

B777DR_ovhd_fwd_button_target             = deferred_dataref("Strato/777/cockpit/ovhd/fwd/buttons/target", "array[20]")
B777DR_ovhd_ctr_button_target             = deferred_dataref("Strato/777/cockpit/ovhd/ctr/buttons/target", "array[46]")
B777DR_ovhd_aft_button_target             = deferred_dataref("Strato/777/cockpit/ovhd/aft/buttons/target", "array[24]")

B777DR_ctr1_button_pos                    = deferred_dataref("Strato/777/cockpit/ctr/fwd/buttons/position", "array[5]")

B777DR_button_cover_positions             = deferred_dataref("Strato/777/cockpit/button_cover/position", "array[16]")

B777DR_cockpit_door_pos                   = deferred_dataref("Strato/777/cockpit_door_pos", "number")

B777DR_pfd_mtrs_capt                      = deferred_dataref("Strato/777/displays/mtrs_capt", "number")