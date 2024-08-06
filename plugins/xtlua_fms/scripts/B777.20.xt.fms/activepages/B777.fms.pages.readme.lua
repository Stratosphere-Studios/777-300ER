--[[
*****************************************************************************************
* Page Name: readme verification
* Author Name: remenkemi 
* Page Description:
*****************************************************************************************
--]]

fmsPages["README"] = createPage("README")
fmsPages["README"].getPage = function(self,pgNo,fmsID)

    if getSimConfig("FMC", "unlocked") == 0 then
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
            "<"..fmsModules["data"].readmeCodeInput..";m06                 "
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
            "<"..fmsModules["data"].readmeCodeInput..";g06            MENU>"
        }
    end
end

fmsPages["README"].getSmallPage = function(self,pgNo,fmsID)
    local unlocked = "-- LOCKED"

    if getSimConfig("FMC", "unlocked") == 1 then
        unlocked = " UNLOCKED;h08"
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

fmsPages["README"].getNumPages = function(self, fmsID)
    return 1
end