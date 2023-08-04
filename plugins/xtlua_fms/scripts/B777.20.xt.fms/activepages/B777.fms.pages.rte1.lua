fmsPages["RTE1"]=createPage("RTE1")
fmsPages["RTE1"].getPage=function(self,pgNo,fmsID)
	if pgNo == 1 then
		return {
			"      RTE 1;c5             ",
			"                        ",
			"****                ****",
			"                        ",
			"-----         ----------",
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