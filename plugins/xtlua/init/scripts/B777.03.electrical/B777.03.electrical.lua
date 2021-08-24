--[[
*****************************************************************************************
* Script Name: Electrical
* Author Name: @crazytimtimtim
* Script Description: Code for Electrical systems
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
	--print("Deffereed dataref: "..name)
	dref=XLuaCreateDataRef(name, type,"yes",notifier)
	return wrap_dref_any(dref,type)
end

--*************************************************************************************--
--**                             CREATE CUSTOM COMMANDS                              **--
--*************************************************************************************--

B777CMD_ovhd_c_ext_pwr_button             = deferred_command("Strato/B777/button_switch/ovhd_c/ext_pwr", "External Power Switch", B777_ovhd_c_ext_pwr_switch_CMDhandler)

--*************************************************************************************--
--**                             CREATE CUSTOM DATAREFS                              **--
--*************************************************************************************--

