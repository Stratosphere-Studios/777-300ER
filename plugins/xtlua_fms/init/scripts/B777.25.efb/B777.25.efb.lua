--[[
*****************************************************************************************
* Script Name: EFB
* Author Name: remenkemi 
* Script Description: (Init) Electronic Flight Bag Code
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
--**                             CREATE CUSTOM COMMANDS                              **--
--*************************************************************************************--

B777CMD_efb_L1                         = deferred_command("Strato/777/efb_L1", "EFB Top Left Button", efb_L1_CMDhandler)
B777CMD_efb_L2                         = deferred_command("Strato/777/efb_L2", "EFB Bottom Left Button", efb_L2_CMDhandler)
B777CMD_efb_LC1                        = deferred_command("Strato/777/efb_LC1", "EFB Top Left-Center Button", efb_LC1_CMDhandler)
B777CMD_efb_LC2                        = deferred_command("Strato/777/efb_LC2", "EFB Bottom Left-Center Button", efb_LC2_CMDhandler)
B777CMD_efb_RC1                        = deferred_command("Strato/777/efb_RC1", "EFB Top Right-Center Button", efb_RC1_CMDhandler)
B777CMD_efb_RC2                        = deferred_command("Strato/777/efb_RC2", "EFB Bottom Right-Center Button", efb_RC2_CMDhandler)
B777CMD_efb_R1                         = deferred_command("Strato/777/efb_R1", "EFB Top Right Button", efb_R1_CMDhandler)
B777CMD_efb_R2                         = deferred_command("Strato/777/efb_R2", "EFB Bottom Right Button", efb_R2_CMDhandler)

B777CMD_efb_home                       = deferred_command("Strato/777/efb_home", "EFB Home Button", efb_home_CMDhandler)
B777CMD_efb_pwr                        = deferred_command("Strato/777/efb_pwr", "EFB Power Button", efb_pwr_CMDhandler)
B777CMD_efb_back                       = deferred_command("Strato/777/efb_back", "EFB Back Button", efb_back_CMDhandler)

B777CMD_toggle_weight_mode             = deferred_command("Strato/777/options/weight_mode_toggle", "Toggle Weight Mode", weight_mode_toggle_CMDHandler)
B777CMD_toggle_prkBrk_mode             = deferred_command("Strato/777/options/prkBrk_mode_toggle", "Toggle Parking Brake Mode", prkBrk_mode_toggle_CMDHandler)
B777CMD_toggle_smartKnobs              = deferred_command("Strato/777/options/smartKnobs_toggle", "Toggle Smart Knobs", smartKnobs_toggle_CMDHandler)
B777CMD_toggle_gsInd                   = deferred_command("Strato/777/options/gsInd_mode_toggle", "Toggle GS/MACH Indicator", gsInd_toggle_CMDHandler)
B777CMD_toggle_trsInd                  = deferred_command("Strato/777/options/trsInd_toggle", "Toggle TRS Indicator", trsInd_toggle_CMDHandler)
B777CMD_toggle_aoaInd                  = deferred_command("Strato/777/options/aoaInd_toggle", "Toggle AOA Indicator", aoaInd_toggle_CMDHandler)
B777CMD_toggle_acfType                 = deferred_command("Strato/777/options/acfType_toggle", "Toggle Aircraft Type", acfType_toggle_CMDHandler)

--*************************************************************************************--
--**                             CREATE CUSTOM DATAREFS                              **--
--*************************************************************************************--

B777DR_efb_page                        = deferred_dataref("Strato/777/displays/efb_page", "number")
B777DR_efb_page_type                   = deferred_dataref("Strato/777/displays/efb_page_type", "number")
B777DR_maint_covers                    = deferred_dataref("Strato/777/maint/covers", "array[3]")
B777DR_maint_doors                     = deferred_dataref("Strato/777/maint/doors", "array[6]")