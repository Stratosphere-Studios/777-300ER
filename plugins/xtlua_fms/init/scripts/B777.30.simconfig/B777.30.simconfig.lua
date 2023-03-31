--[[
*****************************************************************************************
* Program Script Name	:	B777.05.simconfig
* Author Name			:	Marauder28
*
*   Revisions:
*   -- DATE --	--- REV NO ---		--- DESCRIPTION ---
*   2020-11-19	0.01a				Start of Dev
*
*
*
*
*****************************************************************************************
*
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
--**                               CREATE DATAREFS                                   **--
--*************************************************************************************--
-- Holds all SimConfig options
B777DR_simconfig_data       = deferred_dataref("Strato/777/simconfig", "string")
B777DR_newsimconfig_data    = deferred_dataref("Strato/777/newsimconfig", "number")

B777DR_SNDoptions           = deferred_dataref("Strato/777/fmod/options", "array[7]")
B777DR_SNDoptions_volume    = deferred_dataref("Strato/777/fmod/options/volume", "array[8]") --TODO
B777DR_SNDoptions_gpws      = deferred_dataref("Strato/777/fmod/options/gpws", "array[16]")
B777DR_readme_code          = deferred_dataref("Strato/777/readme_code", "string")

--*************************************************************************************--
--**                              CREATE COMMANDS                                    **--
--*************************************************************************************--

B777CMD_save_simconfig = deferred_command("Strato/777/save_simconfig", "Save Configuration Options", saveSimconfig_CMDhandler)