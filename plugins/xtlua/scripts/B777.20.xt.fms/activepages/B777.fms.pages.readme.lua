--[[
*****************************************************************************************
* Page Name:
* Author Name: crazytimtimtim
* Page Description:
*****************************************************************************************
--]]

local unlocked = " LOCKED"
fmsPages["README"] = createPage("README")
fmsPages["README"].getPage = function(self,pgNo,fmsID)
    local menuBtn = "-----"
    local code = fmsModules["data"].readmeCodeInput..";m4"
    if simConfigData["data"].FMC.unlocked == 1 then
        menuBtn = " MENU>"
        code = fmsModules["data"].readmeCodeInput..";g4"
        unlocked = "UNLOCKED;h8"
    end
    if pgNo == 1 then
        return {
            "    READ THE README!    ",
            "                        ",
            "PLEASE READ THE README  ",
            "INSTRUCTIONS IN THE 777 ",
            "FOLDER TO FIND THE CODE ",
            "TO UNLOCK THE DISPLAYS. ",
            "PLEASE DON'T ASK THE    ",
            "DEVS WHY THINGS ARE     ",
            "BROKEN BEFORE READING IT",
            "                        ",
            "                        ",
            code.." -------------"..menuBtn,
            "                        "
        }
    end
end

fmsPages["README"].getSmallPage = function(self,pgNo,fmsID)
	return {
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"CODE:           "..unlocked,
		"                        ",
		"                        ",
	}
end

fmsFunctionsDefs["README"]={}

fmsFunctionsDefs["README"]["R6"]={"setpage2","MENU"}
fmsFunctionsDefs["README"]["L6"]={"setdata","readmeCode"}

fmsPages["README"].getNumPages = function(self)
    return 1
end