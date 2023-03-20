--TODO: ADD REMAINING PAGES
--[[registerFMCCommand("Strato/B777/button_switch/efis/lEicas/eng","")
registerFMCCommand("Strato/B777/button_switch/efis/lEicas/stat","")
registerFMCCommand("Strato/B777/button_switch/efis/lEicas/rcl","")
registerFMCCommand("Strato/B777/button_switch/efis/lEicas/fuel","")
registerFMCCommand("Strato/B777/button_switch/efis/lEicas/gear","")
registerFMCCommand("Strato/B777/button_switch/efis/lEicas/elec","")
registerFMCCommand("Strato/B777/button_switch/efis/lEicas/air","")
registerFMCCommand("Strato/B777/button_switch/efis/lEicas/hyd","")
registerFMCCommand("Strato/B777/button_switch/efis/lEicas/door","")
registerFMCCommand("Strato/B777/button_switch/efis/lEicas/fctl","")
registerFMCCommand("Strato/B777/button_switch/efis/lEicas/cam","")
Strato/B777/button_switch/efis/lEicas/chkl
]]

fmsPages["EICASMODES"]=createPage("EICASMODES")
fmsPages["EICASMODES"].getPage=function(self,pgNo,fmsID)
    return {
        "     DISPLAY MODES      ",
        "                        ",
        "<L INBD;r7            CHKL>",
        "                        ",
        "<LWR CTR<SEL>      COMM>;r5",
        "                        ",
        "<R INBD             NAV>;r4",
        "                        ",
        "<ENG                    ",
        "                        ",
        "<STAT          CANC/RCL>",
        "------------------------",
        "              SYNOPTICS>"
    }
end

fmsPages["EICASMODES"].getSmallPage=function(self,pgNo,fmsID)
    return {
        "                        ",
        " SEL DISPLAY        MODE",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        " EICAS                  ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        }
end

fmsFunctionsDefs["EICASMODES"]={}
fmsFunctionsDefs["EICASMODES"]["L4"]={"setDisp","eicasEng"}
fmsFunctionsDefs["EICASMODES"]["L5"]={"setDisp","eicasStat"}
fmsFunctionsDefs["EICASMODES"]["R1"]={"setDisp","eicasChkl"}
fmsFunctionsDefs["EICASMODES"]["R5"]={"doCMD","Strato/777/commands/glareshield/recall"}
fmsFunctionsDefs["EICASMODES"]["R6"]={"setpage","EICASSYN"}

fmsPages["EICASSYN"]=createPage("EICASSYN")
fmsPages["EICASSYN"].getPage=function(self,pgNo,fmsID)
    return {
        "   DISPLAY SYNOPTICS    ",
        "                        ",
        "<L INBD;r7            ELEC>",
        "                        ",
        "<LWR CTR<SEL>     	 HYD>",
        "                        ",
        "<R INBD;r7            FUEL>",
        "                        ",
        "<DOOR               AIR>",
        "                        ",
        "<GEAR              FCTL>",
        "------------------------",
        "                  MODES>"
    }
end

fmsPages["EICASSYN"].getSmallPage=function(self,pgNo,fmsID)
    return {
        "                        ",
        " SEL DISPLAY            ",
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

fmsFunctionsDefs["EICASSYN"]={}
fmsFunctionsDefs["EICASSYN"]["L4"]={"setDisp","eicasDoor"}
fmsFunctionsDefs["EICASSYN"]["L5"]={"setDisp","eicasGear"}
fmsFunctionsDefs["EICASSYN"]["R1"]={"setDisp","eicasElec"}
fmsFunctionsDefs["EICASSYN"]["R2"]={"setDisp","eicasHyd"}
fmsFunctionsDefs["EICASSYN"]["R3"]={"setDisp","eicasFuel"}
fmsFunctionsDefs["EICASSYN"]["R4"]={"setDisp","eicasAir"}
fmsFunctionsDefs["EICASSYN"]["R5"]={"setDisp","eicasFctl"}
fmsFunctionsDefs["EICASSYN"]["R6"]={"setpage","EICASMODES"}