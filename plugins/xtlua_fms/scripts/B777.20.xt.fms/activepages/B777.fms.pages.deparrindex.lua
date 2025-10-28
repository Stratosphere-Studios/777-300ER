fmsPages["DEPARRINDEX"]=createPage("DEPARRINDEX")
fmsPages["DEPARRINDEX"].getPage=function(self,pgNo,fmsID)--dynamic pages need to be this way
    return{
        "      DEP/ARR INDEX     ",
        "                        ",
        "<DEP      "..B777DR_backend_depIcao_out.."      ARR>",
        "                        ",
        "          "..B777DR_backend_arrIcao_out.."      ARR>",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "------------------------",
        "                        ",
        " DEP     OTHER      ARR ",
        "<----              ---->"
    }
end

fmsPages["DEPARRINDEX"].getSmallPage=function(self,pgNo,fmsID)
    return {
        "                        ",
        "        RTE 1 (ACT)     ",
        "                        ",
        "                        ",
        "                        ",
        "--------RTE 2 ----------",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        "
    }
end

fmsFunctionsDefs["DEPARRINDEX"]={}

fmsPages["DEPARRINDEX"].getNumPages=function(self, fmsID)
	return 1
end

fmsFunctionsDefs["DEPARRINDEX"]["L1"]={"setpage","DEPARTURES"}
fmsFunctionsDefs["DEPARRINDEX"]["R2"]={"setpage","ARRIVALS"}