B777DR_backend_depIcao_out = find_dataref("Strato/777/FMC/RTE1/dep_icao_out") -- 4 characters
B777DR_backend_arrIcao_out = find_dataref("Strato/777/FMC/RTE1/arr_icao_out") -- 4 characters
B777DR_backend_depRwy_out = find_dataref("Strato/777/FMC/RTE1/dep_rnw_out") -- 3 characters

B777DR_backend_depIcao_in = {find_dataref("Strato/777/FMC/FMC_L/RTE1/dep_icao_in"), find_dataref("Strato/777/FMC/FMC_R/RTE1/dep_icao_in")}
B777DR_backend_arrIcao_in = {find_dataref("Strato/777/FMC/FMC_L/RTE1/arr_icao_in"), find_dataref("Strato/777/FMC/FMC_R/RTE1/arr_icao_in")}
B777DR_backend_repRwy_in = {find_dataref("Strato/777/FMC/FMC_L/RTE1/dep_rnw_in"), find_dataref("Strato/777/FMC/FMC_R/RTE1/dep_rnw_in")}

fmsPages["RTE1"]=createPage("RTE1")

-- flight number goes in fmsdata

fmsPages["RTE1"].getPage=function(self,pgNo,fmsID)
	local depIcao = not B777DR_backend_depIcao_out:match('%a') and "****" or B777DR_backend_depIcao_out
	local arrIcao = not B777DR_backend_arrIcao_out:match('%a') and "****" or B777DR_backend_arrIcao_out
	local depRwy = depIcao == "****" and "     " or (not B777DR_backend_depRwy_out:match('%a') and "-----" or B777DR_backend_depRwy_out)

	B777DR_backend_page[fmsID] = 1 -- set page to RTE1 mode

	if pgNo == 1 then
		return {
			"      RTE 1;c5             ",
			"                        ",
			depIcao.."                "..arrIcao,
			"                        ",
			depRwy.."         "..fmsModules["data"].fltno,
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

fmsPages["RTE1"].getNumPages=function(self, fmsID)
	return 2
end

fmsFunctionsDefs["RTE1"]={}
fmsFunctionsDefs["RTE1"]["L1"] = {"setdata", "depIcao"}
fmsFunctionsDefs["RTE1"]["L2"] = {"setdata", "depRwy"}
fmsFunctionsDefs["RTE1"]["R1"] = {"setdata", "arrIcao"}
fmsFunctionsDefs["RTE1"]["R2"] = {"setdata", "flightNum"}
fmsFunctionsDefs["RTE1"]["R3"] = {"setdata", "coroute"}