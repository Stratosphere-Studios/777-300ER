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



--*************************************************************************************--
--**                             CREATE CUSTOM COMMANDS                              **--
--*************************************************************************************--

B777DR_N1                                       = deferred_dataref("Strato/777/engines/N1", "array[2]")
B777DR_fuel_flow_indicated                      = deferred_dataref("Strato/777/cockpit/engines/fuel_flow_indicated", "array[2]")

--*************************************************************************************--
--**                          FUEL SYSTEM LOGIC PLACEHOLDER                          **--
--*************************************************************************************--


