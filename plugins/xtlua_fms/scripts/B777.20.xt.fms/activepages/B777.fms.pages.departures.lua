fmsPages["DEPARTURES"]=createPage("DEPARTURES")
fmsPages["DEPARTURES"].getPage=function(self,pgNo,fmsID)--dynamic pages need to be this way
    return{
        B777DR_backend_depIcao_out

        "   "..B777DR_backend_depIcao_out.." DEPARTURES      ",
        "         RTE 1          ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "------------------------",
        "<INDEX            ROUTE>"
    }
end

fmsPages["DEPARTURES"].getSmallPage=function(self,pgNo,fmsID)
    return {
        "                    x/x ",
        " SIDS            RUNWAYS",
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
    }
end

fmsFunctionsDefs["DEPARTURES"]={}
fmsFunctionsDefs["DEPARTURES"]["L6"]={"setpage","DEPARRINDEX"}
fmsFunctionsDefs["DEPARTURES"]["R6"]={"setpage","RTE1"}

fmsPages["DEPARTURES"].getNumPages=function(self, fmsID)
	return 1
end