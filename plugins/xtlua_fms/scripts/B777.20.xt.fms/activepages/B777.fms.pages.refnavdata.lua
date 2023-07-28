fmsPages["REFNAVDATA"] = createPage("REFNAVDATA")
fmsPages["REFNAVDATA"].getPage = function(self,pgNo,fmsID)
    return {
        "      REF NAV DATA      ",
        "                        ",
        "------                  ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "----                ----",
        "                        ",
        "                        ",
        "                        ",
        "<INDEX         OFF;g3     >"
    }
end

fmsPages["REFNAVDATA"].getSmallPage = function(self,pgNo,fmsID)
	return {
		"                        ",
		" IDENT                  ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"     NAVAID INHIBIT     ",
		"                        ",
		"    VOR ONLT INHIBIT    ",
		"ALL                  ALL",
        "-------------VOR/DME NAV",
		"                  <->ON "
	}
end

fmsFunctionsDefs["REFNAVDATA"]={}
fmsFunctionsDefs["REFNAVDATA"]["L6"]={"setpage","INITREF"}

fmsPages["REFNAVDATA"].getNumPages = function(self)
    return 1
end
