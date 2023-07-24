local kgs_to_lbs = 2.204623

fmsPages["PERFINIT"]=createPage("PERFINIT")
fmsPages["PERFINIT"].getPage=function(self,pgNo,fmsID)

	local costIndex = fmsModules["data"].costindex
	costIndex = string.rep(" ", 4 - costIndex:len())..costIndex

	local crzAlt = fmsModules["data"].crzalt
	local crzAltNum = tonumber(crzAlt)
	if crzAltNum then
		if crzAltNum > 18000 then -- or local trans alt
			crzAlt = "FL"..math.floor(crzAltNum / 100)
		end
	end
	crzAlt = string.rep(" ", 5 - crzAlt:len())..crzAlt

	local grwt = fmsModules["data"].grwt
	local zfw = fmsModules["data"].zfw
	local rsv = fmsModules["data"].reserves

	local fuelWeight = string.format("%3.1f", fmsModules["data"].fmcFuel.value / 1000)

	if getSimConfig("PLANE", "weight_display_units") == "LBS" then
		grwt = grwt ~= "***.*" and string.format("%3.1f", grwt * kgs_to_lbs) or grwt
		zfw = zfw ~= "***.*" and string.format("%3.1f", zfw * kgs_to_lbs) or zfw
		rsv = rsv ~= "***.*" and string.format("%3.1f", rsv * kgs_to_lbs) or rsv
		fuelWeight = string.format("%3.1f", fuelWeight * kgs_to_lbs)
	end

	grwt = string.rep(" ", 5 - grwt:len())..grwt
	zfw = string.rep(" ", 5 - zfw:len())..zfw
	rsv = string.rep(" ", 5 - rsv:len())..rsv
	fuelWeight = string.rep(" ", 5 - fuelWeight:len())..fuelWeight

	return {
		"       PERF INIT        ",
		"                         ",
		grwt.."              "..crzAlt,
		"                        ",
		fuelWeight.."               "..costIndex,
		"                        ",
		zfw.."                   ",
		"                        ",
		rsv.."                   ",
		"                        ",
		"<REQUEST;r8            "..getFMSData("stepsize"),
		"                        ",
		"<INDEX       THRUST LIM>"
	}
end

fmsPages["PERFINIT"].getSmallPage=function(self,pgNo,fmsID)
	local minFuelTemp = getSimConfig("FMC", "min_fuel_temp")
	minFuelTemp = (minFuelTemp > -10 and " "..minFuelTemp or minFuelTemp).."`C"

	local crzCG = fmsModules["data"].crzcg
	crzCG = string.rep(" ", 5 - crzCG:len())..crzCG

	local weightUnits = getSimConfig("PLANE", "weight_display_units"):sub(1, 2)

	return {
		"                        ",
		" GR WT           CRZ ALT",
		"                        ",
		" FUEL         COST INDEX",
		"     "..weightUnits.." "..fmsModules["data"].fmcFuel.mode,
		" ZFW       MIN FUEL TEMP",
		"                   "..minFuelTemp,
		" RESERVES         CRZ CG",
		"                   "..crzCG,
		"PERF INIT      STEP SIZE",
		"                        ",
		"------------------------",
		"                        "
	}
end

fmsFunctionsDefs["PERFINIT"]={}
fmsFunctionsDefs["PERFINIT"]["L1"]={"setdata","grwt"}
fmsFunctionsDefs["PERFINIT"]["L2"]={"setdata","perfinitfuel"}
fmsFunctionsDefs["PERFINIT"]["L3"]={"setdata","zfw"}
fmsFunctionsDefs["PERFINIT"]["L4"]={"setdata","reserves"}
fmsFunctionsDefs["PERFINIT"]["R1"]={"setdata","crzalt"}
fmsFunctionsDefs["PERFINIT"]["R2"]={"setdata","costindex"}
fmsFunctionsDefs["PERFINIT"]["R3"]={"setdata","minfueltemp"}
fmsFunctionsDefs["PERFINIT"]["R4"]={"setdata","crzcg"}
fmsFunctionsDefs["PERFINIT"]["R5"]={"setdata","stepsize"}
fmsFunctionsDefs["PERFINIT"]["L6"]={"setpage","INITREF"}
fmsFunctionsDefs["PERFINIT"]["R6"]={"setpage","THRUSTLIM"}

fmsPages["PERFINIT"].getNumPages=function(self)
	return 1
end
