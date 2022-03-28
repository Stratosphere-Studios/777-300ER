fmsPages["MAINTSIMCONFIG"]=createPage("MAINTSIMCONFIG")
fmsPages["MAINTSIMCONFIG"].getPage=function(self,pgNo,fmsID)
	if pgNo == 1 then
		fmsFunctionsDefs["MAINTSIMCONFIG"]["L1"]={"setdata","weightUnits"}
		fmsFunctionsDefs["MAINTSIMCONFIG"]["L2"]={"setdata","irsAlignTime"}
		fmsFunctionsDefs["MAINTSIMCONFIG"]["L4"]={"setdata","baroIndicator"}
		fmsFunctionsDefs["MAINTSIMCONFIG"]["L5"]={"setdata","baroSync"}
		fmsFunctionsDefs["MAINTSIMCONFIG"]["R6"]={"setdata","simConfigSave"}

		local weight_factor = 1
		local display_weight_units = string.format("%-3s", simConfigData["data"].SIM.weight_display_units)
		local irs_align_time = string.format("%-2d", simConfigData["data"].SIM.irs_align_time / 60)  --Mins
		local baro_indicator = string.format("%-3s", simConfigData["data"].SIM.baro_indicator)
		local baro_sync = string.format("%-3s", simConfigData["data"].SIM.baro_sync)

		if simConfigData["data"].SIM.weight_display_units == "LBS" then
			weight_factor = simConfigData["data"].SIM.kgs_to_lbs
		end

		return {
		"       SIM CONFIG       ",
		"                        ",
		" "..display_weight_units,
		"                        ",
		" "..irs_align_time,
		"                        ",
		"                        ",
		"                        ",
		" "..baro_indicator,
		"                        ",
		" "..baro_sync,
		"                        ",
		"<MENU              SAVE>"
		}

	elseif pgNo == 2 then

		fmsFunctionsDefs["MAINTSIMCONFIG"]["L1"]={"setDref","VNAVSPAUSE"}
		fmsFunctionsDefs["MAINTSIMCONFIG"]["L2"]={"setDref","PAUSEVAL"}
		fmsFunctionsDefs["MAINTSIMCONFIG"]["L3"]=nil
		fmsFunctionsDefs["MAINTSIMCONFIG"]["L4"]=nil
		fmsFunctionsDefs["MAINTSIMCONFIG"]["L5"]=nil
		fmsFunctionsDefs["MAINTSIMCONFIG"]["R1"]=nil
		fmsFunctionsDefs["MAINTSIMCONFIG"]["R2"]=nil
		fmsFunctionsDefs["MAINTSIMCONFIG"]["R3"]=nil
		fmsFunctionsDefs["MAINTSIMCONFIG"]["R4"]=nil
		fmsFunctionsDefs["MAINTSIMCONFIG"]["R5"]=nil
		fmsFunctionsDefs["MAINTSIMCONFIG"]["R6"]=nil

		local LineA="<ENABLE PAUSE AT T/D    "
    	local LineB="<PAUSE AT ***NM TO DEST "
		if B777DR_ap_vnav_pause == 1.0 then
			LineA="<DISABLE PAUSE AT T/D   "
			if B777BR_tod > 0 then
				LineB="<PAUSE AT ".. string.format("%03d",B777BR_tod) .."NM TO DEST "
			end
		elseif B777DR_ap_vnav_pause > 1.0 then
			LineA="<DISABLE PAUSE          "
			LineB="<PAUSE AT ".. string.format("%03d",B777DR_ap_vnav_pause) .."NM TO DEST "   
		end
		return {

		"     CONFIG PAUSE       ",
		"   	                 ",
		LineA,
		"                        ",
		LineB,
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"<MENU                   "
		}

	elseif pgNo == 3 then

		-- SOUND OPTIONS (CRAZYTIMTIMTIM + MATT726)

		fmsFunctionsDefs["MAINTSIMCONFIG"]["L1"]={"setpage","MISCSOUNDCONFIG"}
		fmsFunctionsDefs["MAINTSIMCONFIG"]["L2"]={"setpage","PASSENGERSOUNDCONFIG"}
		fmsFunctionsDefs["MAINTSIMCONFIG"]["L3"]={"setpage","GPWSSOUNDCONFIG"}
		--fmsFunctionsDefs["MAINTSIMCONFIG"]["L4"]={"setpage","VOLUME"}

		fmsFunctionsDefs["MAINTSIMCONFIG"]["R1"] = nil
		fmsFunctionsDefs["MAINTSIMCONFIG"]["R2"] = nil
		fmsFunctionsDefs["MAINTSIMCONFIG"]["R3"] = nil
		fmsFunctionsDefs["MAINTSIMCONFIG"]["R4"] = nil
		fmsFunctionsDefs["MAINTSIMCONFIG"]["R5"] = nil
		fmsFunctionsDefs["MAINTSIMCONFIG"]["R6"] = nil
		fmsFunctionsDefs["MAINTSIMCONFIG"]["L4"] = nil
		fmsFunctionsDefs["MAINTSIMCONFIG"]["L5"] = nil

		return{
		"      SOUND CONFIG      ",
		"                        ",
		"<GENERAL                ",
		"                        ",
		"<PASSENGERS             ",
		"                        ",
		"<GPWS CALLOUTS          ",
		"                        ",
		"<VOLUME (INOP.)         ",
		"                        ",
		"                        ",
		"------------------------",
		"<MENU                   "
		}

	end
end

fmsPages["MAINTSIMCONFIG"].getSmallPage=function(self,pgNo,fmsID)
	if pgNo == 1 then
		local display_weight_units = "KGS"
		local fuel_mgmt = "NO"
		local baro_indicator = "IN"
		local baro_sync = "NO"

		if simConfigData["data"].SIM.weight_display_units == "KGS" then
			display_weight_units = "/LBS"
		else
			display_weight_units = "/KGS"
		end

		if simConfigData["data"].SIM.baro_indicator == "IN" then
			baro_indicator = "/HPA"
		else
			baro_indicator = "/IN "
		end

		if simConfigData["data"].SIM.baro_sync == "NO" then
			baro_sync = "/YES"
		else
			baro_sync = "/NO "
		end

		return {
		"                     1/3",
		" WEIGHT UNITS           ",
		"     "..display_weight_units,
		" IRS ALIGN TIME         ",
		"    MINS                ",
		" BARO INDICATOR         ",
		"     "..baro_indicator,
		" BARO SYNC              ",
		"     "..baro_sync,
		"                        ",
		"                        ",
		"                        ",
		"                        "
    }

	elseif pgNo == 2 then
		return {
		"                     2/3",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        "
		}

	elseif pgNo == 3 then
		return {
		"                     3/3",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        "
		}
	end
end

fmsPages["MAINTSIMCONFIG"].getNumPages=function(self)
	return 3
end

fmsFunctionsDefs["MAINTSIMCONFIG"]["L6"]={"setpage","INDEX"}
