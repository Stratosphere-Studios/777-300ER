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

--*************************************************************************************--
--** 					         EARLY FUNCTION DEFITIONS                            **--
--*************************************************************************************--
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
--** 				        CREATE READ-WRITE CUSTOM DATAREFS                        **--
--*************************************************************************************--
-- Holds all SimConfig options
B777DR_simconfig_data					= deferred_dataref("strato/B777/simconfig", "string")
B777DR_newsimconfig_data				= deferred_dataref("strato/B777/newsimconfig", "number")
B777DR_pfd_style						= deferred_dataref("strato/B777/pfd/style", "number")
B777DR_nd_style							= deferred_dataref("strato/B777/nd/style", "number")
B777DR_thrust_ref						= deferred_dataref("strato/B777/engines/thrust_ref", "number")
B777DR_engineType						= deferred_dataref("strato/B777/engines/type", "number") -- crazytimtimtim engine type DR
B777DR_hideGE						= deferred_dataref("strato/B777/engines/hideGE", "number") 
B777DR_hideRR						= deferred_dataref("strato/B777/engines/hideRR", "number") 

B777DR_hideCabin						= deferred_dataref("strato/B777/objects/hideCabin", "number")
B777DR_hideGear						= deferred_dataref("strato/B777/objects/hideGear", "number") 
B777DR_hideHStab						= deferred_dataref("strato/B777/objects/hideHStab", "number")   
B777DR_hideFuse						= deferred_dataref("strato/B777/objects/hideFuse", "number")   
B777DR_modernAlarms						= deferred_dataref("strato/B777/fmod/options/modernAlarms", "number")