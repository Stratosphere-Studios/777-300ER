fmsPages["IDENT"]=createPage("IDENT")

fmsPages["IDENT"].getPage=function(self,pgNo,fmsID)--dynamic pages need to be this way
	local nav_data_from_month = string.sub(simDR_fmsL_line4,3,5)
	local nav_data_from_day = string.sub(simDR_fmsL_line4,1,2)
	local nav_data_to_month = string.sub(simDR_fmsL_line4,11,13)
	local nav_data_to_day = string.sub(simDR_fmsL_line4,9,10)
	local nav_data_yr = string.sub(simDR_fmsL_line4,14,15)
	local navdata = string.format("%s%s%s%s/%s", nav_data_from_month, nav_data_from_day, nav_data_to_month, nav_data_to_day, nav_data_yr)
	local monthTable = {
		JAN = "01",
		FEB = "02",
		MAR = "03",
		APR = "04",
		MAY = "05",
		JUN = "06",
		JUL = "07",
		AUG = "08",
		SEP = "09",
		OCT = "10",
		NOV = "11",
		DEC = "12"
	}
	local airac = "AIRAC-"..nav_data_yr..monthTable[nav_data_to_month] -- may crash on linux; needs testing; try using assert(pcall()) or something
    return{

		"          IDENT         ",
		"                        ",
		"777.300.2    GE90-115BL1",
		"                        ",
		airac.." "..navdata,
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"               "..getSimConfig("FMC", "drag_ff"),
		"------------------------",
		"<INDEX         POS INIT>"
	}
end

fmsPages["IDENT"].getSmallPage=function(self,pgNo,fmsID)
	local dragffArmed = "   "
	
	return {
		"                        ",
		" MODEL        ENG RATING",
		"                        ",
		" NAV DATA         ACTIVE",
		"                        ",
		"                        ",
		"                        ",
		--" OP PROGRAM             ",
		"                        ",
		"                        ",
		"             "..fmsModules["data"].dragFF_armed.." DRAG/FF",
		"                        ",
		"                        ",
		"                        "
	}
end

fmsPages["IDENT"].getNumPages = function(Self)
	return 1
end

fmsFunctionsDefs["IDENT"]={}
fmsFunctionsDefs["IDENT"]["L6"]={"setpage","INITREF"}
fmsFunctionsDefs["IDENT"]["R6"]={"setpage","POSINIT"}
fmsFunctionsDefs["IDENT"]["R5"]={"setdata", "drag_ff"}