--[[ 
*****************************************************************************************
* Script Name: Electrical System
* Author Name: nathroxer
* Script Description: Init script for fuel system and pump logic
*****************************************************************************************
--]]

--replace create_command
function deferred_command(name, desc, nilFunc)
    c = XLuaCreateCommand(name, desc)
    return nil --make_command_obj(c)
end

--replace create_dataref
function deferred_dataref(name, type, notifier)
    dref = XLuaCreateDataRef(name, type, "yes", notifier)
    return wrap_dref_any(dref, type)
end

--*************************************************************************************--
--**                             CREATE CUSTOM DATAREFS                              **--
--*************************************************************************************--



--*************************************************************************************--
--**                             CREATE CUSTOM COMMANDS                              **--
--*************************************************************************************--


--*************************************************************************************--
--**                          FUEL SYSTEM LOGIC PLACEHOLDER                          **--
--*************************************************************************************--

--create datarefs

B777DR_left_main_bus_volts                     = deferred_dataref("Strato/777/cockpit/elec/left_main_bus_volts", "number")
B777DR_left_xfr_bus_volts                      = deferred_dataref("Strato/777/cockpit/elec/left_xfr_bus_volts", "number")
B777DR_right_main_bus_volts                    = deferred_dataref("Strato/777/cockpit/elec/right_main_bus_volts", "number")
B777DR_right_xfr_bus_volts                     = deferred_dataref("Strato/777/cockpit/elec/right_xfr_bus_volts", "number")

B777DR_ovhd_elec_button_pos                     = deferred_dataref("Strato/777/cockpit/ovhd/elec/position", "array[14]")
B777DR_ovhd_elec_button_target                  = deferred_dataref("Strato/777/cockpit/ovhd/elec/target", "array[14]")

B777DR_ovhd_apu_switch_pos                      = deferred_dataref("Strato/777/cockpit/ovhd/elec/apu/position", "number")
B777DR_ovhd_apu_switch_target                   = deferred_dataref("Strato/777/cockpit/ovhd/elec/apu/target", "number")

B777DR_ext_pwr_primary_switch_mode              = deferred_dataref("Strato/777/cockpit/elec/ext_pwr_primary_switch_mode", "number")
B777DR_ext_pwr_secondary_switch_mode            = deferred_dataref("Strato/777/cockpit/elec/ext_pwr_secondary_switch_mode", "number")

B777DR_left_backup_gen_on                     = deferred_dataref("Strato/777/cockpit/elec/left_backup_gen_on", "number")
B777DR_right_backup_gen_on                    = deferred_dataref("Strato/777/cockpit/elec/right_backup_gen_on", "number")
--annunciators

B777DR_annun_pos                                = deferred_dataref("Strato/777/cockpit/annunciator/pos", "number")
B777DR_annun_target                             = deferred_dataref("Strato/777/cockpit/annunciator/target", "number")
B777DR_annun_mode                               = deferred_dataref("Strato/777/cockpit/annunciator/test_mode", "number")

B777DR_annun_elec_battery_off                   = deferred_dataref("Strato/777/cockpit/annunciator/elec/battery_off", "number")
B777DR_annun_elec_ext_pwr_primary_avail         = deferred_dataref("Strato/777/cockpit/annunciator/elec/ext_pwr_primary_avail", "number")
B777DR_annun_elec_ext_pwr_primary_on            = deferred_dataref("Strato/777/cockpit/annunciator/elec/ext_pwr_primary_on", "number")
B777DR_annun_elec_ext_pwr_secondary_avail       = deferred_dataref("Strato/777/cockpit/annunciator/elec/ext_pwr_secondary_avail", "number")
B777DR_annun_elec_ext_pwr_secondary_on          = deferred_dataref("Strato/777/cockpit/annunciator/elec/ext_pwr_secondary_on", "number")
B777DR_annun_elec_apu_gen_off                   = deferred_dataref("Strato/777/cockpit/annunciator/elec/apu_gen_off", "number")
B777DR_annun_elec_apu_failed                    = deferred_dataref("Strato/777/cockpit/annunciator/elec/apu_fail", "number")

B777DR_annun_elec_gen_ctrl_off                  = deferred_dataref("Strato/777/cockpit/annunciator/elec/gen_ctrl_off", "array[2]")
B777DR_annun_elec_gen_drive                     = deferred_dataref("Strato/777/cockpit/annunciator/elec/gen_drive_off", "array[4]")

B777DR_annun_elec_bus_tie_off                   = deferred_dataref("Strato/777/cockpit/annunciator/elec/bus_tie_off", "array[2]")
B777DR_annun_cabin_util_off                     = deferred_dataref("Strato/777/cockpit/annunciator/elec/cabin_util", "array[2]")

B777DR_GPU                                      = deferred_dataref("Strato/777/cockpit/elec/gpu_on", "number")

B777DR_load_shed                                = deferred_dataref("Strato/777/cockpit/elec/load_shed", "number")

B777DR_bus_tie_test                             = deferred_dataref("Strato/777/cockpit/elec/tie_test", "array[2]")
B777DR_left_AC_proximity                        = deferred_dataref("Strato/777/cockpit/elec/left_AC/tie_test", "array[3]")
B777DR_right_AC_proximity                       = deferred_dataref("Strato/777/cockpit/elec/right_AC/tie_test", "array[4]")
B777DR_AC_status                                = deferred_dataref("Strato/777/cockpit/elec/AC_status", "array[5]")
B777DR_primary_ext_pwr_on                       = deferred_dataref("Strato/777/cockpit/elec/primary_ext_pwr_on", "number")
B777DR_secondary_ext_pwr_on                     = deferred_dataref("Strato/777/cockpit/elec/secondary_ext_pwr_on", "number")

B777DR_apu_gen_dir                              = deferred_dataref("Strato/777/cockpit/elec/apu_gen_direction", "number") --1 for right 0 for left
B777DR_sec_ext_pwr_dir                          = deferred_dataref("Strato/777/cockpit/elec/sec_ext_pwr_direction", "number") --1 for right 0 for left

B777DR_bus_tie_left_open                        = deferred_dataref("Strato/777/cockpit/elec/bus_tie_left_open", "number")
B777DR_bus_tie_right_open                       = deferred_dataref("Strato/777/cockpit/elec/bus_tie_right_open", "number")
B777DR_elec_flow_sharing                        = deferred_dataref("Strato/777/cockpit/elec/flow_sharing", "number")

B777DR_left_TBB                                 = deferred_dataref("Strato/777/cockpit/elec/left_TBB", "number")
B777DR_right_TBB                                = deferred_dataref("Strato/777/cockpit/elec/right_TBB", "number")

B777DR_right_util_avail                         = deferred_dataref("Strato/777/cockpit/elec/right_util_avail", "number")
B777DR_left_util_avail                         = deferred_dataref("Strato/777/cockpit/elec/left_util_avail", "number")
B777DR_batt_charging_status                     = deferred_dataref("Strato/777/cockpit/elec/batt_charging_status", "number") -- 0 = not charging, 1 = charging, 2 = charged

-- MISC

B777DR_autoland_status                          = deferred_dataref("Strato/777/cockpit/autoland/status", "number") -- 0 = off, 2 = active
B777DR_batt_amps_indicated                      = deferred_dataref("Strato/777/cockpit/elec/battery_amps_indicated", "array[2]")


B777CMD_ext_pwr_primary                         = deferred_command("Strato/777/cockpit/ovhd/elec/ext_pwr_primary", "external power primary", B777_ext_pwr_primary_cmdHandler)
B777CMD_ext_pwr_secondary                       = deferred_command("Strato/777/cockpit/ovhd/elec/ext_pwr_secondary", "external power secondary", B777_ext_pwr_secondary_cmdHandler)
B777CMD_apu_sel_up                              = deferred_command("Strato/777/cockpit/ovhd/apu/sel_up", "apu switch up", B777_apu_up_cmdHandler)
B777CMD_apu_sel_down                            = deferred_command("Strato/777/cockpit/ovhd/apu/sel_down", "apu switch down", B777_apu_down_cmdHandler)

B777CMD_annun_sel_up                            = deferred_command("Strato/777/cockpit/ovhd/annun/sel_up", "annunciator switch up", B777_annun_up_cmdHandler)
B777CMD_annun_sel_down                          = deferred_command("Strato/777/cockpit/ovhd/annun/sel_down", "annunciator down", B777_annun_down_cmdHandler)

