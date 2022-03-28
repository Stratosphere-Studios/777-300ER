fmsPages["IDENT"]=createPage("IDENT")

fmsPages["IDENT"].getPage=function(self,pgNo,fmsID)--dynamic pages need to be this way
	local nav_data_from_month = string.sub(B777DR_srcfms[fmsID][5],3,5)
	local nav_data_from_day = string.sub(B777DR_srcfms[fmsID][5],1,2)
	local nav_data_to_month = string.sub(B777DR_srcfms[fmsID][5],11,13)
	local nav_data_to_day = string.sub(B777DR_srcfms[fmsID][5],9,10)
	local nav_data_yr = string.sub(B777DR_srcfms[fmsID][5],14,15)
	simConfigData["data"].FMC.INIT.active = string.format("%s%s%s%s/%s", nav_data_from_month, nav_data_from_day, nav_data_to_month, nav_data_to_day, nav_data_yr)

    return {
		"       IDENT            ",
		"                        ",
		"777-300.1      GE90-115B",
		"                        ",
		"           "..simConfigData["data"].FMC.INIT.active,
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"               "..simConfigData["data"].FMC.INIT.drag_ff
		"------------------------",
		"<INDEX         POS INIT>"
    }
end

fmsPages["IDENT"]["templateSmall"]={

	" MODEL        ENG RATING",
	"                        ",
	" NAV DATA         ACTIVE",
	"                        ",
	"                        ",
	"                        ",
	"                        ",
	"                        ",
	"                 DRAG/FF",
	"                        ",
	"                        ",
	"                        "

}

fmsFunctionsDefs["IDENT"]={}
fmsFunctionsDefs["IDENT"]["L6"]={"setpage","INITREF"}
fmsFunctionsDefs["IDENT"]["R5"]={"setdata","codata"}
fmsFunctionsDefs["IDENT"]["R6"]={"setpage","POSINIT"}

