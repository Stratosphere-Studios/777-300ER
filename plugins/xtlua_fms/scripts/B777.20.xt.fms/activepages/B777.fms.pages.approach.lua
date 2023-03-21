simDR_acf_weight_total_kg          				= find_dataref("sim/flightmodel/weight/m_total")
B777DR_airspeed_Vf25                            = find_dataref("Strato/B777/airspeed/Vf25")
B777DR_airspeed_Vf30                            = find_dataref("Strato/B777/airspeed/Vf30")

fmsPages["APPROACH"]=createPage("APPROACH")
fmsPages["APPROACH"].getPage=function(self,pgNo,fmsID)--dynamic pages need to be this way
--[[    local acf_weight = simDR_acf_weight_total_kg

    if simConfigData["data"].SIM.weight_display_units == "LBS" then
    	acf_weight = simDR_acf_weight_total_kg * simConfigData["data"].SIM.kgs_to_lbs
    end
string.format("                   %3d", B777DR_airspeed_Vf30),
string.format("%4.1f              %3d", acf_weight/1000,B777DR_airspeed_Vf25),
        "                  "..fmsModules["data"]["flapspeed"] ,]]
    return{
        "      APPROACH REF      ",
        "                        ",
        "             20`        ",
        "                        ",
        "             25`        ",
        "                        ",
        "<      QNH;g3   30`        ",
        "                        ",
        "                 --/---",
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
        " LANDING REF            ",
        " QFE<->               KT",
        "              FLAP/SPEED",
        "     FT    M            ",
        "                        ",
        "                        ", 
        "------------------------",
        "                        "
    }
end

fmsPages["APPROACH"].getNumPages=function(self)
	return 1
end

fmsFunctionsDefs["APPROACH"]={}
fmsFunctionsDefs["APPROACH"]["L6"]={"setpage","INITREF"}
fmsFunctionsDefs["APPROACH"]["R6"]={"setpage","THRUSTLIM"}

--[[
fmsFunctionsDefs["APPROACH"]["L1"]={"setdata","grosswt"}
fmsFunctionsDefs["APPROACH"]["R1"]={"setdata","vref1"}
fmsFunctionsDefs["APPROACH"]["R2"]={"setdata","vref2"}
fmsFunctionsDefs["APPROACH"]["R4"]={"setdata","flapspeed"}]]