--TODO: ADD REMAINING PAGES 
registerFMCCommand("Strato/B777/button_switch/efis/lEicas/eng","")
registerFMCCommand("Strato/B777/button_switch/efis/lEicas/stat","")
registerFMCCommand("Strato/B777/button_switch/efis/lEicas/rcl","")
registerFMCCommand("Strato/B777/button_switch/efis/lEicas/fuel","")
registerFMCCommand("Strato/B777/button_switch/efis/lEicas/gear","")
registerFMCCommand("Strato/B777/button_switch/efis/lEicas/elec","")
registerFMCCommand("Strato/B777/button_switch/efis/lEicas/air","")
registerFMCCommand("Strato/B777/button_switch/efis/lEicas/hyd","")
registerFMCCommand("Strato/B777/button_switch/efis/lEicas/door","")

--"Strato/B777/button_switch/efis/lEicas/fctl"
--"Strato/B777/button_switch/efis/lEicas/cam"

fmsPages["EICASMODES"]=createPage("EICASMODES")
fmsPages["EICASMODES"]["template"]={

"       EICAS MODES      ",
"                        ",
"<ENG               FUEL>",
"                        ",
"<STAT              GEAR>",
"                        ",
"                        ",
"                        ",
"                        ",
"------------------------",
"               CANC/RCL>",
"                        ",
"              SYNOPTICS>"
}


fmsFunctionsDefs["EICASMODES"]={}

fmsFunctionsDefs["EICASMODES"]["L1"]={"doCMD","Strato/B777/button_switch/efis/lEicas/eng"}
fmsFunctionsDefs["EICASMODES"]["L2"]={"doCMD","Strato/B777/button_switch/efis/lEicas/stat"}
fmsFunctionsDefs["EICASMODES"]["L5"]={"doCMD","Strato/B777/button_switch/efis/lEicas/rcl"}
fmsFunctionsDefs["EICASMODES"]["R1"]={"doCMD","Strato/B777/button_switch/efis/lEicas/fuel"}
fmsFunctionsDefs["EICASMODES"]["R2"]={"doCMD","Strato/B777/button_switch/efis/lEicas/gear"}
fmsFunctionsDefs["EICASMODES"]["R5"]={"doCMD","laminar/B777/dsp/rcl_switch"}
fmsFunctionsDefs["EICASMODES"]["R6"]={"setpage","EICASSYN"}

fmsPages["EICASSYN"]=createPage("EICASSYN")
fmsPages["EICASSYN"]["template"]={

"       EICAS MODES      ",
"                        ",
"<ELEC               HYD>",
"                        ",
"<air              DOORS>",
"                        ",
"                        ",
"                        ",
"                        ",
"------------------------",
"               CANC/RCL>",
"                        ",
"                  MODES>"
}


fmsFunctionsDefs["EICASSYN"]={}

fmsFunctionsDefs["EICASSYN"]["L1"]={"doCMD","Strato/B777/button_switch/efis/lEicas/elec"}
fmsFunctionsDefs["EICASSYN"]["L2"]={"doCMD","Strato/B777/button_switch/efis/lEicas/air"}
fmsFunctionsDefs["EICASSYN"]["R5"]={"doCMD","Strato/B777/button_switch/efis/lEicas/rcl"}
fmsFunctionsDefs["EICASSYN"]["R1"]={"doCMD","Strato/B777/button_switch/efis/lEicas/hyd"}
fmsFunctionsDefs["EICASSYN"]["R2"]={"doCMD","Strato/B777/button_switch/efis/lEicas/door"}
fmsFunctionsDefs["EICASSYN"]["R6"]={"setpage","EICASMODES"}