--[[ 
*****************************************************************************************
* Script Name: Electronic Engine Control (EEC) Logic
* Author Name: nathroxer
* Script Description: this script contains the logic for engine ignition and control
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

B777DR_ovhd_eec_button_pos                     = deferred_dataref("Strato/777/cockpit/ovhd/eec/position", "array[3]")
B777DR_ovhd_eec_button_target                  = deferred_dataref("Strato/777/cockpit/ovhd/eec/target", "array[3]")

B777DR_ovhd_ign_switch_pos                     = deferred_dataref("Strato/777/cockpit/ovhd/ignition/position", "array[2]")
B777DR_ovhd_ign_switch_target                  = deferred_dataref("Strato/777/cockpit/ovhd/ignition/target", "array[2]")

--annunciators

B777DR_annun_autostart_off                     = deferred_dataref("Strato/777/cockpit/annunciator/eec/autostart_off", "number")
B777DR_annun_eec_altn                          = deferred_dataref("Strato/777/cockpit/annunciator/eec/eec_altn", "array[2]")


--*************************************************************************************--
--**                             CREATE CUSTOM COMMANDS                              **--
--*************************************************************************************--

B777CMD_ign_1_sel_up                              = deferred_command("Strato/777/cockpit/ovhd/ign_1/sel_up", "apu switch up", B777_ign_1_up_cmdHandler)
B777CMD_ign_1_sel_down                            = deferred_command("Strato/777/cockpit/ovhd/ign_1/sel_down", "apu switch down", B777_ign_1_down_cmdHandler)
B777CMD_ign_2_sel_up                              = deferred_command("Strato/777/cockpit/ovhd/ign_2/sel_up", "apu switch up", B777_ign_2_up_cmdHandler)
B777CMD_ign_2_sel_down                            = deferred_command("Strato/777/cockpit/ovhd/ign_2/sel_down", "apu switch down", B777_ign_2_down_cmdHandler)


--*************************************************************************************--
--**                          FUEL SYSTEM LOGIC PLACEHOLDER                          **--
--*************************************************************************************--


