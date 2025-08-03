--[[ 
*****************************************************************************************
* Script Name: Electrical System
* Author Name: nathroxer
* Script Description: Init script for electrical system and gen logic
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

B777DR_spar_valve                               = deferred_dataref("Strato/777/cockpit/fuel/spar_valve_open", "array[2]") --0 = L, 1 = R

B777DR_ovhd_fuel_button_pos                     = deferred_dataref("Strato/777/cockpit/ovhd/fuel/position", "array[11]")
B777DR_ovhd_fuel_button_target                  = deferred_dataref("Strato/777/cockpit/ovhd/fuel/target", "array[11]")
B777DR_fuel_cutoff_switch_target                = deferred_dataref("Strato/777/cockpit/ovhd/fuel/cutoff_switch_target", "array[2]") --0 = L, 1 = R
B777DR_fuel_cutoff_switch_pos                   = deferred_dataref("Strato/777/cockpit/ovhd/fuel/cutoff_switch_position", "array[2]") --0 = L, 1 = R
B777DR_fuel_pump_powered                        = deferred_dataref("Strato/777/cockpit/fuel/pump/powered", "array[6]") --0 = L fwd, 1 = L aft, 2 = CTR L, 3 = CTR R, 4 = R aft, 5 = R fwd

B777DR_fuel_pump_pressure                       = deferred_dataref("Strato/777/cockpit/fuel/pump/pressure", "array[6]")

B777DR_ovhd_fuel_jett_select                    = deferred_dataref("Strato/777/cockpit/ovhd/fuel/jettison/selector/position", "number")

--annunciators
B777DR_annun_fuel_low_press                     = deferred_dataref("Strato/777/cockpit/annunciator/fuel/low_press", "array[6]")

B777DR_pump_test                                = deferred_dataref("Strato/777/cockpit/fuel/pump_test", "array[6]")

B777DR_eng_flag_test                            = deferred_dataref("Strato/777/cockpit/fuel/eng_flag", "array[12]")

--synoptic

B777DR_pump_avail                              = deferred_dataref("Strato/777/cockpit/fuel/pump/avail", "array[6]") --0 = L fwd, 1 = L aft, 2 = CTR L, 3 = CTR R, 4 = R aft, 5 = R fwd
B777DR_pump_supply                             = deferred_dataref("Strato/777/cockpit/fuel/pump/supply", "array[6]") --0 = L fwd, 1 = L aft, 2 = CTR L, 3 = CTR R, 4 = R aft, 5 = R fwd
B777DR_pump_failure                            = deferred_dataref("Strato/777/cockpit/fuel/pump/failure", "array[6]") --0 = L fwd, 1 = L aft, 2 = CTR L, 3 = CTR R, 4 = R aft, 5 = R fwd 
B777DR_crossfeed_dir                           = deferred_dataref("Strato/777/cockpit/fuel/crossfeed/dir", "array[2]") --0 norm, 1 left-right, 2 right-left
B777DR_crossfeed_active                        = deferred_dataref("Strato/777/cockpit/fuel/crossfeed/active", "number") --0 = no crossfeed, 1 = fwd crossfeed, 2 = aft crossfeed
B777DR_crossfeed_open                          = deferred_dataref("Strato/777/cockpit/fuel/crossfeed/open", "array[2]") --0 = no crossfeed, 1 = fwd, 2 = aft
B777DR_apu_active                              = deferred_dataref("Strato/777/cockpit/fuel/apu/active", "number") --0 = APU on, 1 = APU off
B777DR_apu_synoptic                            = deferred_dataref("Strato/777/cockpit/fuel/apu/synoptic", "number") --0 = APU off, 1 = APU on
B777DR_min_fuel_temp                           = deferred_dataref("Strato/777/cockpit/fuel/min_temp", "number") --minimum fuel temperature for APU operation
B777DR_fuel_temp                               = deferred_dataref("Strato/777/cockpit/fuel/temp", "number") --fuel temperature

--*************************************************************************************--
--**                             CREATE CUSTOM COMMANDS                              **--
--*************************************************************************************--



--*************************************************************************************--
--**                          FUEL SYSTEM LOGIC PLACEHOLDER                          **--
--*************************************************************************************--


