local efisCTL = 0
local dspCTL = 0
local efisOptS, dspOptS = "", ""
fmsPages["INDEX"]=createPage("INDEX")
fmsPages["INDEX"].getPage=function(self,pgNo,fmsID)

	local fmcACT, satACT, intACT = "     ", "     ", "     "

	--fmsFunctionsDefs,["INDEX"]["L5"]={"setpage","ACMS"}
	--fmsFunctionsDefs["INDEX"]["L6"]={"setpage","CMC"}
	fmsFunctionsDefs["INDEX"]={}
	fmsFunctionsDefs["INDEX"]["L1"]={"setpage2","FMC"}
	fmsFunctionsDefs["INDEX"]["R1"]={"setDref", "efisCtrl"}
	fmsFunctionsDefs["INDEX"]["R3"]={"setDref", "dspCtrl"}
	fmsFunctionsDefs["INDEX"]["R4"]={"setpage2","EICASMODES"}
	fmsFunctionsDefs["INDEX"]["R2"]={"setpage2","EFISOPTIONS152"}

	if fmsID == "fmsL" then
		efisCTL = B777DR_cdu_efis_ctl[0]
		dspCTL = B777DR_cdu_eicas_ctl[0]
		if B777DR_cdu_act[0] == 1 then
			fmcACT = "<ACT>"
		elseif B777DR_cdu_act[0] == 2 then
			satACT = "<ACT>"
		end
	elseif fmsID == "fmsR" then
		efisCTL = B777DR_cdu_efis_ctl[1]
		dspCTL = B777DR_cdu_eicas_ctl[2]
		if B777DR_cdu_act[1] == 1 then
			fmcACT = "<ACT>"
		elseif B777DR_cdu_act[1] == 2 then
			satACT = "<ACT>"
		end
	else -- fmsC
		dspCTL = B777DR_cdu_eicas_ctl[1]
		if B777DR_cdu_act[2] == 2 then
			satACT = "<ACT>"
		elseif B777DR_cdu_act[2] == 3 then
			intACT = "<ACT>"
		end
	end

	local efisln = "     "
	local dspln = "    "
	local efisOptL = "OFF;g03     "
	local dspOptL = "OFF;g03     "
	efisOptS, dspOptS  = "   <->ON", "   <->ON"

	if efisCTL == 1 then
		efisOptL = "      ON;g02"
		efisOptS = "OFF<->  "
		efisln = "EFIS>"
	end

	if dspCTL == 1 then
		dspOptL = "      ON;g02"
		dspOptS = "OFF<->     "
		dspln = "DSP>"
	end

	--[[  local acarsS="             "

	if acars==1 and B777DR_rtp_C_off==0 then 
		acarsS="<ACARS  <REQ>" 
		fmsFunctionsDefs["INDEX"]["L2"]={"setpage","ACARS"}
	else
		fmsFunctionsDefs["INDEX"]["L2"]=nil
	end]]

	local page = {
		"         MENU           ",
		"                        ",
		"<FMC    "..fmcACT.."  "..efisOptL..">",
		"                        ",
		"<SAT;r04    "..satACT.."      "..efisln,
		"                        ",
		"               "..dspOptL..">",
		"                        ",
		"                    "..dspln,
		"                        ",
		"                DISPLAY>;r08",
		"                        ",
		"                 MEMORY>;r07"
	}

	if fmsID == "fmsC" then
		page[3] = "                       "
		page[5] = "<SAT;r04                "
		page[9] = "<CAB INT;r08 "..intACT.."      "..dspln
		if B777DR_cdu_eicas_ctl[0] == 1 or B777DR_cdu_eicas_ctl[2] == 1 then
			B777DR_cdu_eicas_ctl[1] = 0
			page[7] = "                        "
		end

	elseif fmsID == "fmsL" then
		if B777DR_cdu_eicas_ctl[1] == 1 or B777DR_cdu_eicas_ctl[2] == 1 then
			B777DR_cdu_eicas_ctl[0] = 0
			page[7] = "                        "
		end

	else
		if B777DR_cdu_eicas_ctl[0] == 1 or B777DR_cdu_eicas_ctl[1] == 1 then
			B777DR_cdu_eicas_ctl[2] = 0
			page[7] = "                        "
		end
	end

	return page
end


fmsPages["INDEX"].getSmallPage=function(self,pgNo,fmsID)
	local page = {
		"                        ",
		"                EFIS CTL",
		"               "..efisOptS,
		"                        ",
		"                        ",
		"                 DSP CTL",
		"               "..dspOptS,
		"                        ",
		"                        ",
		"              MAINT INFO",
		"                        ",
		"                        ",
		"                        ",
	}

	if fmsID == "fmsC" then
		page[2] = "                        "
		page[3] = "                        "
		if B777DR_cdu_eicas_ctl[0] == 1 or B777DR_cdu_eicas_ctl[2] == 1 then
			page[6] = "                        "
			page[7] = "                        "
		else
		end
	elseif fmsID == "fmsL" then
		if B777DR_cdu_eicas_ctl[1] == 1 or B777DR_cdu_eicas_ctl[2] == 1 then
			page[6] = "                        "
			page[7] = "                        "
		else
		end
	else
		if B777DR_cdu_eicas_ctl[0] == 1 or B777DR_cdu_eicas_ctl[1] == 1 then
			page[6] = "                        "
			page[7] = "                        "
		else
		end
	end

	return page
end

fmsPages["INDEX"].getNumPages=function(self, fmsID)
	return 1
end