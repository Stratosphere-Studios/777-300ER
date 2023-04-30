--[[
*****************************************************************************************
* Page Name: readme verification
* Author Name: remenkemi (crazytimtimtim)
* Page Description:
*****************************************************************************************
--]]


fmsPages["README"] = createPage("README")
fmsPages["README"].getPage = function(self,pgNo,fmsID)

    if simConfigData["data"].FMC.unlocked == 0 then
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
            "                        ",
            "<"..fmsModules["data"].readmeCodeInput..";m5                  ",
        }
    else
        return {
            "    READ THE README!    ",
            "                        ",
            "FLIGHT INSTRUMENTS      ",
            "UNLOCKED. THANKS FOR    ",
            "READING THE README.     ",
            "                        ",
            "                        ",
            "                        ",
            "                        ",
            "                        ",
            "                        ",
            "                        ",
            "<"..fmsModules["data"].readmeCodeInput..";g5             MENU>"
        }
    end
end

fmsPages["README"].getSmallPage = function(self,pgNo,fmsID)
    local unlocked = "-- LOCKED"

    if simConfigData["data"].FMC.unlocked == 1 then
        unlocked = " UNLOCKED;h8"
    end

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
        "                        ",
        "CODE: ---------"..unlocked,
		"                        ",
	}
end

fmsFunctionsDefs["README"]={}

fmsFunctionsDefs["README"]["R6"]={"setpage2","MENU"}
fmsFunctionsDefs["README"]["L6"]={"setdata","readmeCode"}

fmsPages["README"].getNumPages = function(self)
    return 1
end