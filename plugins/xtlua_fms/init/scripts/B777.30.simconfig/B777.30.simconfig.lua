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
	--print("Deferred dataref: "..name)
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

B777DR_acf_is_freighter           = deferred_dataref("Strato/777/acf_is_freighter", "number")
B777DR_lbs_kgs                    = deferred_dataref("Strato/777/lbs_kgs", "number")
B777DR_trs_bug_enabled            = deferred_dataref("Strato/777/displays/trs_bug_enabled", "number")
B777DR_aoa_enabled                = deferred_dataref("Strato/777/displays/pfd_aoa_enabled", "number")
B777DR_smart_knobs                = deferred_dataref("Strato/777/smart_knobs", "number")
B777DR_pfd_mach_gs                = deferred_dataref("Strato/777/pfd_mach_gs", "number")

--*************************************************************************************--
--**                              CREATE COMMANDS                                    **--
--*************************************************************************************--

B777CMD_toggle_weight_mode            = deferred_command("Strato/777/options/weight_mode_toggle", "Toggle Weight Mode", weight_mode_toggle_CMDHandler)
B777CMD_toggle_prkBrk_mode            = deferred_command("Strato/777/options/prkBrk_mode_toggle", "Toggle Parking Brake Mode", prkBrk_mode_toggle_CMDHandler)
B777CMD_toggle_smartKnobs             = deferred_command("Strato/777/options/smartKnobs_toggle", "Toggle Smart Knobs", smartKnobs_toggle_CMDHandler)
B777CMD_toggle_gsInd                  = deferred_command("Strato/777/options/gsInd_mode_toggle", "Toggle GS/MACH Indicator", gsInd_toggle_CMDHandler)
B777CMD_toggle_trsInd                 = deferred_command("Strato/777/options/trsInd_toggle", "Toggle TRS Indicator", trsInd_toggle_CMDHandler)
B777CMD_toggle_aoaInd                 = deferred_command("Strato/777/options/aoaInd_toggle", "Toggle AOA Indicator", aoaInd_toggle_CMDHandler)
B777CMD_toggle_acfType                = deferred_command("Strato/777/options/acfType_toggle", "Toggle Aircraft Type", acfType_toggle_CMDHandler)