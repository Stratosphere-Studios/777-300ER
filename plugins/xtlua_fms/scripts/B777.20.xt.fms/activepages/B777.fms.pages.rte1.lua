B777DR_backend_page = {find_dataref("Strato/777/FMC/FMC_L/page"), find_dataref("Strato/777/FMC/FMC_R/page")} -- already found in refnavdata

B777DR_backend_depIcao_out = find_dataref("Strato/777/FMC/RTE1/dep_icao_out") -- 4 characters
B777DR_backend_arrIcao_out = find_dataref("Strato/777/FMC/RTE1/arr_icao_out") -- 4 characters
B777DR_backend_depRwy_out = find_dataref("Strato/777/FMC/RTE1/dep_rnw_out") -- 3 characters

local depIcao = B777DR_backend_depIcao_out == "" and "****" or B777DR_backend_depIcao_out
local arrIcao = B777DR_backend_arrIcao_out == "" and "****" or B777DR_backend_arrIcao_out
local depRwy = depIcao == "****" and "     " or (B777DR_backend_depRwy_out == "" and "-----" or B777DR_backend_depRwy_out.."  ")
-- flight number goes in fmsdata

fmsPages["RTE1"]=createPage("RTE1")
fmsPages["RTE1"].getPage=function(self,pgNo,fmsID)
	if pgNo == 1 then
		return {
			"      RTE 1;c5             ",
			"                        ",
			depIcao.."                "..arrIcao,
			"                        ",
			depRwy.."         ----------",
			"                        ",
			"<REQUEST      ----------",
			"                        ",
			"                        ",
			"                        ",
			"<PRINT             ALTN>",
			"                        ",
			"<RTE 2         ACTIVATE>",
		}
	else
		return {
			"      RTE 1;c5             ",
			"                        ",
			"-----              -----",
			"                        ",
			"                        ",
			"                        ",
			"                        ",
			"                        ",
			"                        ",
			"                        ",
			"                        ",
			"                        ",
			"<RTE 2         ACTIVATE>"
		}
	end
end

fmsPages["RTE1"].getSmallPage=function(self,pgNo,fmsID)
	if pgNo == 1 then
		return {
			"                    1/2 ",
			" ORIGIN             DEST",
			"                        ",
			" RUNWAY           FLT NO",
			"                        ",
			" ROUTE          CO ROUTE",
			"                        ",
			"                        ",
			"                        ",
			" ROUTE -----------------",
			"                        ",
			"                        ",
			"                        ",
		}
	else
		return {
			"                    2/2 ",
			" VIA                  TO",
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
			"                        "
		}
	end
end

fmsPages["RTE1"].getNumPages=function(self)
	return 2
end

fmsFunctionsDefs["RTE1"]={}
fmsFunctionsDefs["RTE1"]["L1"] = {"setdata", "depIcao"}
fmsFunctionsDefs["RTE1"]["L2"] = {"setdata", "depRwy"}
fmsFunctionsDefs["RTE1"]["R1"] = {"setdata", "arrIcao"}
fmsFunctionsDefs["RTE1"]["R2"] = {"setdata", "flightNum"}

--[[if value == "depIcao" then
	return
elseif value == "arrIcao" then
	return
elseif value == "depRwy" then
	return
elseif value == "flightNum" then
	return
end]]