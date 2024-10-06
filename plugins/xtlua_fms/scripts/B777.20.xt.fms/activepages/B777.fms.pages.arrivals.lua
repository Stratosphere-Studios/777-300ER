fmsPages["ARRIVALS"]=createPage("ARRIVALS")
fmsPages["ARRIVALS"].getPage=function(self,pgNo,fmsID)--dynamic pages need to be this way
    return{
        "   "..B777DR_backend_arrIcao_out.." ARRIVALS        ",
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

fmsPages["ARRIVALS"].getSmallPage=function(self,pgNo,fmsID)
    return {
        "                    x/x ",
        " STARS        APPROACHES",
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

fmsFunctionsDefs["ARRIVALS"]={}
fmsFunctionsDefs["ARRIVALS"]["L6"]={"setpage","DEPARRINDEX"}
fmsFunctionsDefs["ARRIVALS"]["R6"]={"setpage","RTE1"}

fmsPages["ARRIVALS"].getNumPages=function(self, fmsID)
	return 1
end