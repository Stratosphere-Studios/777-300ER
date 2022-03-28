-- Very minor modification by crazytimtimtim
simDR_acf_weight_total_kg          				= find_dataref("sim/flightmodel/weight/m_total")
B777DR_airspeed_Vf25                            = find_dataref("strato/B777/airspeed/Vf25")
B777DR_airspeed_Vf30                            = find_dataref("strato/B777/airspeed/Vf30")

fmsPages["APPROACH"]=createPage("APPROACH")
fmsPages["APPROACH"].getPage=function(self,pgNo,fmsID)--dynamic pages need to be this way
local acf_weight = simDR_acf_weight_total_kg

if simConfigData["data"].SIM.weight_display_units == "LBS" then
	acf_weight = simDR_acf_weight_total_kg * simConfigData["data"].SIM.kgs_to_lbs
end

    return{
    "      APPROACH REF      ",
    "                        ",
    "             20`   "..string.format("%4.1f              %3d", acf_weight/1000,B777DR_airspeed_Vf25),
    "                        ",
    "             25`   "..string.format("                   %3d", B777DR_airspeed_Vf30),
    "                        ",
    "             30`        ",
    "                        ",
    "*****  ****       "..fmsModules["data"]["flapspeed"] ,
    "                        ",
    "                        ",
    "------------------------",
    "<INDEX       THRUST LIM>"
    }
end

fmsPages["APPROACH"].getSmallPage=function(self,pgNo,fmsID)
    return{
    "                        ",
    " GROSS WT   FLAPS   VREF",
    "                      KT",
    "                        ",
    "                      KT",
    "                        ",
    "                      KT",
    " *******      FLAP/SPEED",
    "     FT    M            ",
    "                            ",
    "                        ",
    "                        ",
    "                        "
    }
end

fmsFunctionsDefs["APPROACH"]={}
fmsFunctionsDefs["APPROACH"]["L6"]={"setpage","INITREF"}
fmsFunctionsDefs["APPROACH"]["R6"]={"setpage","THRUSTLIM"}
fmsFunctionsDefs["APPROACH"]["L1"]={"setdata","grosswt"}
fmsFunctionsDefs["APPROACH"]["R1"]={"setdata","vref1"}
fmsFunctionsDefs["APPROACH"]["R2"]={"setdata","vref2"}
--fmsFunctionsDefs["APPROACH"]["R3"]={"setdata","vref3"}
fmsFunctionsDefs["APPROACH"]["R4"]={"setdata","flapspeed"}