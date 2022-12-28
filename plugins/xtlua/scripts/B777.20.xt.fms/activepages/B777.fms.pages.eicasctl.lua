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
        "<L INBD            CHKL>",
        "                        ",
        "<LWR CTR<SEL>      COMM>",
        "                        ",
        "<R INBD             NAV>",
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
fmsFunctionsDefs["EICASMODES"]["L4"]={"doCMD","Strato/B777/button_switch/efis/lEicas/eng"}
fmsFunctionsDefs["EICASMODES"]["L5"]={"doCMD","Strato/B777/button_switch/efis/lEicas/stat"}
fmsFunctionsDefs["EICASMODES"]["R1"]={"doCMD","Strato/B777/button_switch/efis/lEicas/chkl"}
fmsFunctionsDefs["EICASMODES"]["R5"]={"doCMD","Strato/B777/button_switch/efis/lEicas/rcl"}
fmsFunctionsDefs["EICASMODES"]["R6"]={"setpage","EICASSYN"}

fmsPages["EICASSYN"]=createPage("EICASSYN")
fmsPages["EICASSYN"].getPage=function(self,pgNo,fmsID)
    return {
        "   DISPLAY SYNOPTICS    ",
        "                        ",
        "<L INBD            ELEC>",
        "                        ",
        "<LWR CTR<SEL>     DOORS>",
        "                        ",
        "<R INBD            FUEL>",
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
fmsFunctionsDefs["EICASSYN"]["L4"]={"doCMD","Strato/B777/button_switch/efis/lEicas/door"}
fmsFunctionsDefs["EICASSYN"]["L5"]={"doCMD","Strato/B777/button_switch/efis/lEicas/gear"}
fmsFunctionsDefs["EICASSYN"]["R1"]={"doCMD","Strato/B777/button_switch/efis/lEicas/elec"}
fmsFunctionsDefs["EICASSYN"]["R2"]={"doCMD","Strato/B777/button_switch/efis/lEicas/hyd"}
fmsFunctionsDefs["EICASSYN"]["R3"]={"doCMD","Strato/B777/button_switch/efis/lEicas/fuel"}
fmsFunctionsDefs["EICASSYN"]["R4"]={"doCMD","Strato/B777/button_switch/efis/lEicas/air"}
fmsFunctionsDefs["EICASSYN"]["R5"]={"doCMD","Strato/B777/button_switch/efis/lEicas/fctl"}
fmsFunctionsDefs["EICASSYN"]["R6"]={"setpage","EICASMODES"}