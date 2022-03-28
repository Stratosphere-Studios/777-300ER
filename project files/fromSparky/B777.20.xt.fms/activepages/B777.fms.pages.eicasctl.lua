registerFMCCommand("strato/B777/dsp/eng_switch","")
registerFMCCommand("strato/B777/dsp/stat_switch","")
registerFMCCommand("strato/B777/dsp/canc_switch","")
registerFMCCommand("strato/B777/dsp/fuel_switch","")
registerFMCCommand("strato/B777/dsp/gear_switch","")
registerFMCCommand("strato/B777/dsp/rcl_switch","")
registerFMCCommand("strato/B777/dsp/elec_switch","")
registerFMCCommand("strato/B777/dsp/ecs_switch","")
registerFMCCommand("strato/B777/dsp/hyd_switch","")
registerFMCCommand("strato/B777/dsp/drs_switch","")
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
"<CANC               RCL>",
"                        ",
"              SYNOPTICS>"
}


fmsFunctionsDefs["EICASMODES"]={}

fmsFunctionsDefs["EICASMODES"]["L1"]={"doCMD","strato/B777/dsp/eng_switch"}
fmsFunctionsDefs["EICASMODES"]["L2"]={"doCMD","strato/B777/dsp/stat_switch"}
fmsFunctionsDefs["EICASMODES"]["L5"]={"doCMD","strato/B777/dsp/canc_switch"}
fmsFunctionsDefs["EICASMODES"]["R1"]={"doCMD","strato/B777/dsp/fuel_switch"}
fmsFunctionsDefs["EICASMODES"]["R2"]={"doCMD","strato/B777/dsp/gear_switch"}
fmsFunctionsDefs["EICASMODES"]["R5"]={"doCMD","strato/B777/dsp/rcl_switch"}
fmsFunctionsDefs["EICASMODES"]["R6"]={"setpage","EICASSYN"}

fmsPages["EICASSYN"]=createPage("EICASSYN")
fmsPages["EICASSYN"]["template"]={

"       EICAS MODES      ",
"                        ",
"<ELEC               HYD>",
"                        ",
"<ECS              DOORS>",
"                        ",
"                        ",
"                        ",
"                        ",
"------------------------",
"<CANC               RCL>",
"                        ",
"                  MODES>"
}


fmsFunctionsDefs["EICASSYN"]={}

fmsFunctionsDefs["EICASSYN"]["L1"]={"doCMD","strato/B777/dsp/elec_switch"}
fmsFunctionsDefs["EICASSYN"]["L2"]={"doCMD","strato/B777/dsp/ecs_switch"}
fmsFunctionsDefs["EICASSYN"]["L5"]={"doCMD","strato/B777/dsp/canc_switch"}
fmsFunctionsDefs["EICASSYN"]["R1"]={"doCMD","strato/B777/dsp/hyd_switch"}
fmsFunctionsDefs["EICASSYN"]["R2"]={"doCMD","strato/B777/dsp/drs_switch"}
fmsFunctionsDefs["EICASSYN"]["R5"]={"doCMD","strato/B777/dsp/rcl_switch"}
fmsFunctionsDefs["EICASSYN"]["R6"]={"setpage","EICASMODES"}