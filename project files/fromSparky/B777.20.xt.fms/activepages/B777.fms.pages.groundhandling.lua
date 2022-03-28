
registerFMCCommand("sim/ground_ops/service_plane","GROUND SERVICES")
registerFMCCommand("BetterPushback/stop","STOP PUSHBACK")
registerFMCCommand("BetterPushback/start","START PUSHBACK")
registerFMCCommand("BetterPushback/start_planner","PLAN PUSHBACK")

fmsPages["GNDHNDL"]=createPage("GNDHNDL")
fmsPages["GNDHNDL"].getPage=function(self,pgNo,fmsID)

  fmsFunctionsDefs["GNDHNDL"]["L1"]={"doCMD","sim/ground_ops/service_plane"}
  fmsFunctionsDefs["GNDHNDL"]["L2"]={"setpage","DOORS"}
  fmsFunctionsDefs["GNDHNDL"]["L6"]={"setpage","INDEX"}

  local LineA="<PLAN PUSHBACK          "
  local LineB="<START PUSHBACK         "

  if simDR_groundspeed > 0.01 then
    LineA="<STOP PUSHBACK          "
    LineB="                        "
    fmsFunctionsDefs["GNDHNDL"]["L3"]={"doCMD","BetterPushback/stop"}
    fmsFunctionsDefs["GNDHNDL"]["L4"]=nil
  else
    LineA="<PLAN PUSHBACK          "
    LineB="<START PUSHBACK         "
    fmsFunctionsDefs["GNDHNDL"]["L3"]={"doCMD","BetterPushback/start_planner"}
    fmsFunctionsDefs["GNDHNDL"]["L4"]={"doCMD","BetterPushback/start"}
  end

  return {

  "     GROUND HANDLING    ",
  "                        ",
  "<REQUEST GROUND SERVICES",
  "                        ",
  "<DOOR CONTROL           ",
  "                        ",
  LineA,
  "                        ",
  LineB,
  "                        ",
  "                        ",--..fmsModules["lastcmd"],
  "                        ",
  "<INDEX                  "
  }
end

