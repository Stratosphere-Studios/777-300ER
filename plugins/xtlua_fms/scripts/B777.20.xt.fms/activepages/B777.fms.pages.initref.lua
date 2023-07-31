fmsPages["INITREF"]=createPage("INITREF")
fmsPages["INITREF"].getPage=function(self,pgNo,fmsID)
	local lineA="                        "
	local lineB="<APPROACH               "
--  if simDR_onGround ==1 then
    fmsFunctionsDefs["INITREF"]["L5"]={"setpage","TAKEOFF"}
    fmsFunctionsDefs["INITREF"]["R6"]={"setpage","MAINT"}
    lineA="<TAKEOFF                "
    lineB="<APPROACH         MAINT>;r6"
--  else
--    fmsFunctionsDefs["INITREF"]["L5"]=nil
--    fmsFunctionsDefs["INITREF"]["R6"]=nil
--  end
	return {
	"     INIT/REF INDEX     ",
	"                        ",
	"<IDENT         NAV DATA>",
	"                        ",
	"<POS               ALTN>;r5",
	"                        ",
	"<PERF                   ",
	"                        ",
	"<THRUST LIM             ",
	"                        ",
	lineA,
	"                        ",
	lineB
	}
end

fmsFunctionsDefs["INITREF"]={}
fmsFunctionsDefs["INITREF"]["L1"]={"setpage","IDENT"}
fmsFunctionsDefs["INITREF"]["L2"]={"setpage","POSINIT"}
fmsFunctionsDefs["INITREF"]["L3"]={"setpage","PERFINIT"}
fmsFunctionsDefs["INITREF"]["L4"]={"setpage","THRUSTLIM"}
fmsFunctionsDefs["INITREF"]["L6"]={"setpage","APPROACH"}
fmsFunctionsDefs["INITREF"]["R1"]={"setpage","REFNAVDATA"}