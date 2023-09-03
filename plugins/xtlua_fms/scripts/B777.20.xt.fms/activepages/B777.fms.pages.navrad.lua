fmsPages["NAVRAD"]=createPage("NAVRAD")
fmsPages["NAVRAD"].getPage=function(self,pgNo,fmsID)
    return {
        "       NAV RADIO        ",
        "                        ",
        "---.-- xxx    xxx ---.--",
        "                        ",
        "---     ---  ---     ---",
        "                        ",
        " ---.-            ------",
        "                        ",
        "<                       ",
        "                        ",
        "                        ",
        "                        ",
        "------            ------",
    }
end

fmsPages["NAVRAD"].getSmallPage=function(self,pgNo,fmsID)
    return {
        "                        ",
        " VOR L             VOR R",
        "      x          x      ",
        " CRS     RADIAL      CRS",
        "                        ",
        " ADF L             ADF R",
        "      xxx               ",
        " ILS                    ",
        "                        ",
        "                        ",
        "                        ",
        "       PRESELECT        ",
        "                        ",
    }
end

fmsPages["NAVRAD"].getNumPages=function(self, fmsID)
    return 1
end