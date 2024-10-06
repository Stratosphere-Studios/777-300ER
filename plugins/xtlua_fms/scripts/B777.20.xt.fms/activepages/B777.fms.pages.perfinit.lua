local kgs_to_lbs = 2.204623
local minFuelSmall = ""
local fuelWeightSmall = ""

fmsPages["PERFINIT"]=createPage("PERFINIT")
fmsPages["PERFINIT"].getPage=function(self,pgNo,fmsID)

	local minFuelBig = ""
	local minFuelTempNum = getSimConfig("FMC", "min_fuel_temp")
	local minFuelTempStr = (minFuelTempNum > -10 and " "..minFuelTempNum or tostring(minFuelTempNum))

	if fmsModules["data"].customMinFuelTemp then
		minFuelBig = minFuelTempStr.."`"
		minFuelSmall = string.rep(" ", minFuelTempStr:len()).." C"
	else
		minFuelBig = string.rep(" ", minFuelTempStr:len())
		minFuelSmall = minFuelTempStr.."`C"
	end

	local costIndex = fmsModules["data"].costindex
	costIndex = pad(costIndex, 4, true)

	local crzAlt = fmsModules["data"].crzalt
	local crzAltNum = tonumber(crzAlt)
	if crzAltNum then
		if crzAltNum > 18000 then -- or local trans alt
			crzAlt = "FL"..math.floor(crzAltNum / 100)
		end
	end
	crzAlt = pad(crzAlt, 5, true)

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

	grwt = pad(grwt, 5, true)
	zfw = pad(zfw, 5, true)
	rsv = pad(rsv, 5, true)
	fuelWeight = pad(fuelWeight, 5, true)

	local fuelWeightBig = ""
	if fmsModules["data"].fmcFuel.mode == "MANUAL" then
		fuelWeightBig = fuelWeight
		fuelWeightSmall = string.rep(" ", fuelWeight:len())
	else
		fuelWeightBig = string.rep(" ", fuelWeight:len())
		fuelWeightSmall = fuelWeight
	end

	return {
		"       PERF INIT        ",
		"                         ",
		grwt.."              "..crzAlt,
		"                        ",
		fuelWeightBig.."               "..costIndex,
		"                        ",
		zfw.."              "..minFuelBig,
		"                        ",
		rsv.."                   ",
		"                        ",
		"<REQUEST;r08            "..getFMSData("stepsize"),
		"                        ",
		"<INDEX       THRUST LIM>"
	}
end

fmsPages["PERFINIT"].getSmallPage=function(self,pgNo,fmsID)

	local crzCG = fmsModules["data"].crzcg
	crzCG = pad(crzCG, 5, true)

	local weightUnits = getSimConfig("PLANE", "weight_display_units"):sub(1, 2)

	return {
		"                        ",
		" GR WT           CRZ ALT",
		"                        ",
		" FUEL         COST INDEX",
		fuelWeightSmall..weightUnits.." "..fmsModules["data"].fmcFuel.mode,
		" ZFW       MIN FUEL TEMP",
		"                   "..minFuelSmall,
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

fmsPages["PERFINIT"].getNumPages=function(self, fmsID)
	return 1
end
