--[[
*****************************************************************************************
*        COPYRIGHT � 2020 Mark Parker/mSparks CC-BY-NC4
*         Converted for 777 by remenkemi (crazytimtimtim)
*****************************************************************************************
]]
--Marauder28
--V Speeds

--pushSimConfig(simConfigData["data"]["values"])
--B777CMD_save_simconfig:once()

B777DR_airspeed_V1			= deferred_dataref("Strato/B777/airspeed/V1", "number")
B777DR_airspeed_Vr			= deferred_dataref("Strato/B777/airspeed/Vr", "number")
B777DR_airspeed_V2			= deferred_dataref("Strato/B777/airspeed/V2", "number")
B777DR_airspeed_flapsRef	= deferred_dataref("Strato/B777/airspeed/flapsRef", "number")

--Refuel DR
B777DR_refuel							= deferred_dataref("Strato/B777/fuel/refuel", "number")
--Marauder28

--B777DR_cdu_act [0] left, [1] center, [2] right. 0 none actived, 1 fmc, 2 sat, 3 cab int

fmsFunctions={}
--dofile("stuff/acars/acars.lua")
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
	local efisOptL = "OFF;g3     "
	local dspOptL = "OFF;g3     "
	efisOptS, dspOptS  = "   <->ON", "   <->ON"

	if efisCTL == 1 then
		efisOptL = "      ON;g2"
		efisOptS = "OFF<->  "
		efisln = "EFIS>"
	end

	if dspCTL == 1 then
		dspOptL = "      ON;g2"
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
		"<SAT;r4    "..satACT.."      "..efisln,
		"                        ",
		"               "..dspOptL..">",
		"                        ",
		"                    "..dspln,
		"                        ",
		"                DISPLAY>;r8",
		"                        ",
		"                 MEMORY>;r7"
	}

	if fmsID == "fmsC" then
		page[3] = "                       "
		page[5] = "<SAT;r4                "
		page[9] = "<CAB INT;r8 "..intACT.."       "..dspln
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

--[[fmsPages["RTE1"]=createPage("RTE1")
fmsPages["RTE1"].getPage=function(self,pgNo,fmsID)
  local l1=cleanFMSLine(B777DR_srcfms[fmsID][1])
  local pageNo=tonumber(string.sub(l1,21,22))

  local lastLine="<RTE 2             PERF>"
  if simDR_onGround ==1 then
    fmsFunctionsDefs["RTE1"]["L6"]=nil
    lastLine="                   PERF>"
  else
    --fmsFunctionsDefs["RTE1"]["L6"]={"setpage","RTE2"}
    fmsFunctionsDefs["RTE1"]["L6"]={"setpage","LEGS"}
  end

  if pageNo~=1 then
	fmsFunctionsDefs["RTE1"]["L2"]={"custom2fmc","L2"}
	fmsFunctionsDefs["RTE1"]["R2"]={"custom2fmc","R2"}
	fmsFunctionsDefs["RTE1"]["R3"]={"custom2fmc","R3"}
	return {
		"      ACT RTE 1     " .. string.sub(cleanFMSLine(B777DR_srcfms[fmsID][1]),-4,-1) ,
		cleanFMSLine(B777DR_srcfms[fmsID][2]),
		cleanFMSLine(B777DR_srcfms[fmsID][3]),
		cleanFMSLine(B777DR_srcfms[fmsID][4]),
		cleanFMSLine(B777DR_srcfms[fmsID][5]),
		cleanFMSLine(B777DR_srcfms[fmsID][6]),
		cleanFMSLine(B777DR_srcfms[fmsID][7]),
		cleanFMSLine(B777DR_srcfms[fmsID][8]),
		cleanFMSLine(B777DR_srcfms[fmsID][9]),
		cleanFMSLine(B777DR_srcfms[fmsID][10]),
		cleanFMSLine(B777DR_srcfms[fmsID][11]),
		cleanFMSLine(B777DR_srcfms[fmsID][12]),
		lastLine,
		}
  end
  fmsFunctionsDefs["RTE1"]["L2"]={"setdata","runway"}
  fmsFunctionsDefs["RTE1"]["R2"]={"custom2fmc","R3"}
  
  fmsFunctionsDefs["RTE1"]["R3"]={"setpage","FMC"}
  
  local line5="                "..string.sub(cleanFMSLine(B777DR_srcfms[fmsID][5]),1,8)
  --if acarsSystem.provider.online() then line5=" <SEND          "..string.sub(cleanFMSLine(B777DR_srcfms[fmsID][5]),1,8) end
  local page={
  "      ACT RTE 1     " .. string.sub(cleanFMSLine(B777DR_srcfms[fmsID][1]),-4,-1) ,
  "                        ",
  cleanFMSLine(B777DR_srcfms[fmsID][3]),
  "                        ",
  fmsModules["data"]["runway"] .."            ".. string.sub(cleanFMSLine(B777DR_srcfms[fmsID][7]),-7,-1), 
  "                        ",
  line5,
  cleanFMSLine(B777DR_srcfms[fmsID][8]),
  cleanFMSLine(B777DR_srcfms[fmsID][9]),
  cleanFMSLine(B777DR_srcfms[fmsID][10]),
  cleanFMSLine(B777DR_srcfms[fmsID][11]),
  cleanFMSLine(B777DR_srcfms[fmsID][12]),
  lastLine,
  }
  return page
  
end]]

route1 = {

}

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

--[[fmsFunctionsDefs["RTE1"]["L1"]={"custom2fmc","L1"}
--fmsFunctionsDefs["RTE1"]["L1"]={"setdata","origin"}
fmsFunctionsDefs["RTE1"]["L2"]={"setdata","runway"}

fmsFunctionsDefs["RTE1"]["L3"]={"custom2fmc","L3"}
fmsFunctionsDefs["RTE1"]["L4"]={"custom2fmc","L4"}
fmsFunctionsDefs["RTE1"]["L5"]={"custom2fmc","L5"}

fmsFunctionsDefs["RTE1"]["R1"]={"custom2fmc","R1"}
fmsFunctionsDefs["RTE1"]["R2"]={"custom2fmc","R3"}
fmsFunctionsDefs["RTE1"]["R3"]={"custom2fmc","L2"}
fmsFunctionsDefs["RTE1"]["R4"]={"custom2fmc","R4"}
fmsFunctionsDefs["RTE1"]["R5"]={"custom2fmc","R5"}
fmsFunctionsDefs["RTE1"]["R6"]={"setpage","PERFINIT"}

fmsFunctionsDefs["RTE1"]["next"]={"custom2fmc","next"}
fmsFunctionsDefs["RTE1"]["prev"]={"custom2fmc","prev"}
fmsFunctionsDefs["RTE1"]["exec"]={"custom2fmc","exec"}]]

dofile("activepages/B777.fms.pages.legs.lua")
dofile("activepages/B777.fms.pages.maint.lua")
dofile("activepages/B777.fms.pages.maintbite.lua")
dofile("activepages/B777.fms.pages.maintcrossload.lua")
dofile("activepages/B777.fms.pages.maintperffactor.lua")
dofile("activepages/B777.fms.pages.fmccomm.lua")
dofile("activepages/B777.fms.pages.cmc.lua")
dofile("activepages/B777.fms.pages.acms.lua")
dofile("activepages/atc/B777.fms.pages.atcindex.lua")
dofile("activepages/atc/B777.fms.pages.atclogonstatus.lua")
dofile("activepages/atc/B777.fms.pages.atcreport.lua")
dofile("activepages/atc/B777.fms.pages.request.lua")
dofile("activepages/atc/B777.fms.pages.whencanwe.lua")
dofile("activepages/B777.fms.pages.actrte1.lua")
dofile("activepages/B777.fms.pages.identpage.lua")
dofile("activepages/B777.fms.pages.eicasctl.lua")
dofile("activepages/B777.fms.pages.readme.lua")
dofile("activepages/B777.fms.pages.posinit.lua")
dofile("activepages/B777.fms.pages.takeoff.lua")
dofile("activepages/B777.fms.pages.approach.lua")
dofile("activepages/B777.fms.pages.perfinit.lua")
dofile("activepages/B777.fms.pages.efisctl.lua")
dofile("activepages/B777.fms.pages.thrustlim.lua")

--[[
dofile("activepages/B777.fms.pages.maintirsmonitor.lua")
dofile("activepages/B777.fms.pages.progress.lua")
dofile("activepages/B777.fms.pages.vnav.lua")
dofile("activepages/B777.fms.pages.vnav.lrc.lua")
dofile("activepages/atc/B777.fms.pages.posreport.lua")]]

--[[ DO NOT UNCOMMENT
dofile("B777.fms.pages.actclb.lua")
dofile("B777.fms.pages.actcrz.lua")
dofile("B777.fms.pages.actdes.lua")
dofile("B777.fms.pages.actirslegs.lua")
dofile("B777.fms.pages.actrte1data.lua")
dofile("B777.fms.pages.actrte1hold.lua")
dofile("B777.fms.pages.actrte1legs.lua")
dofile("B777.fms.pages.altnnavradio.lua")
dofile("B777.fms.pages.approach.lua")
dofile("B777.fms.pages.arrivals.lua")


dofile("B777.fms.pages.atcrejectdueto.lua")

dofile("B777.fms.pages.atcreport2.lua")
dofile("B777.fms.pages.atcuplink.lua")
dofile("B777.fms.pages.atcverifyresponse.lua")
dofile("B777.fms.pages.deparrindex.lua")
dofile("B777.fms.pages.departures.lua")
dofile("B777.fms.pages.fixinfo.lua")

dofile("B777.fms.pages.identpage.lua")
dofile("B777.fms.pages.irsprogress.lua")
dofile("B777.fms.pages.navradpage.lua")
dofile("B777.fms.pages.progress.lua")
dofile("B777.fms.pages.refnavdata1.lua")
dofile("B777.fms.pages.satcom.lua")
dofile("B777.fms.pages.waypointwinds.lua")
]]

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
	"<IDENT         NAV DATA>;r9",
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
fmsFunctionsDefs["INITREF"]["R1"]={"setpage","DATABASE"}

local navAids
simDR_variation=find_dataref("sim/flightmodel/position/magnetic_variation")
B777DR_ils_dots           	= deferred_dataref("Strato/B777/autopilot/ils_dots", "number")
function findILS(value)

  local modes=B777DR_radioModes
  if navAidsJSON==nil or string.len(navAidsJSON)<5 then return false end
  if value=="DELETE" then 
    B777DR_radioModes=replace_char(1,modes," ")
	ilsData=""
	B777DR_ils_dots=0
    return true
  end
  B777DR_radioModes=replace_char(1,modes,"M")
  navAids=json.decode(navAidsJSON)
  local direction=nil
  local valueSO=split(value,"/")
  --print(value)
  if table.getn(valueSO) > 1 then
    value=valueSO[1]
     --print(value)
    direction=tonumber(valueSO[2])
    --print(value.." and " .. direction)
  else
    --print(value)
  end
  --print(" in " .. navAidsJSON)
  local val=tonumber(value)
  if val~=nil then val=val*100 end
  local found=false
  local bestDist=360
  for n=table.getn(navAids),1,-1 do
      if navAids[n][2] == 8 then
	  --print("navaid "..n.."->".. navAids[n][1].." ".. navAids[n][2].." ".. navAids[n][3].." ".. navAids[n][4].." ".. navAids[n][5].." ".. navAids[n][6].." ".. navAids[n][7].." ".. navAids[n][8])
	  
	 if (value==navAids[n][8] or (val~=nil and val==navAids[n][3])) and (direction==nil or getHeadingDifferenceM(direction,navAids[n][4])<bestDist) then
	    found=true
		ilsData=json.encode(navAids[n])
		local course=(navAids[n][4]+simDR_variation)
	    print("68 - Tuning ILSs ".. ilsData)
	    if direction ~=nil then
		  bestDist=getHeadingDifferenceM(direction,navAids[n][4])
		  --course=direction
		end
		if course<0 then
			course=course+360
		elseif course>360 then
			course=course-360
  		end
	    simDR_nav1Freq=navAids[n][3]
	    simDR_nav2Freq=navAids[n][3] 	
	    simDR_radio_nav_obs_deg[0]=course
		simDR_radio_nav_obs_deg[1]=course
	    print("68 - Tuned ILS "..course)
	    print("68 - useThis "..bestDist)
	  end
      end
   end
   --[[if found==true then
		B777DR_ils_dots=1
   else
		B777DR_ils_dots=0
   end]]--
   return found
end



fmsPages["NAVRAD"]=createPage("NAVRAD")

ils_line1 = ""
ils_line2 = ""
park = "PARK"
original_distance = -1

fmsPages["NAVRAD"].getPage=function(self,pgNo,fmsID)
  local ils1="                        "
  local ils2="                        "
  local modes=B777DR_radioModes
  local dist_to_TOD = B777BR_totalDistance - B777BR_tod
  if string.len(ilsData)>1 then
    local ilsNav=json.decode(ilsData)
    ils2= ilsNav[7]
	ils_line2 = "   "..ils2
    if original_distance == -1 then
		original_distance = B777BR_totalDistance  --capture original flightplan distance
	end
  --print("Dist to TOD = "..dist_to_tod)	
	local course = ilsNav[4]+simDR_variation
	if course<0 then
		course=course+360
	end

		if (dist_to_TOD >= 50 and dist_to_TOD < 200) then
			--ils2= string.format("%6.2f/%03d%s %4s          .", ilsNav[3]*0.01,(ilsNav[4]+simDR_variation), "˚", park)
			ils1 = "            "..park
			ils_line1 = string.format("<%6.2f/%03d%s           ", ilsNav[3]*0.01,((simDR_radio_nav_obs_deg[0])), "˚")
		elseif (dist_to_TOD < 50) then
			ils1= string.format("%6.2f/%03d%s          ", ilsNav[3]*0.01,((simDR_radio_nav_obs_deg[0])), "`"..modes:sub(1, 1))
			ils_line1 = ""
		end
  else
    ils1 = park
	ils_line1 = ""
	ils_line2 = ""
  end
  local modes=B777DR_radioModes
  local vorL_radial="---"
  local vorR_radial="---"
  local vorL_obs="---"
  local vorR_obs="---"
  if simDR_radio_nav_horizontal[2]==1 then vorL_radial=string.format("%03d",simDR_radio_nav_radial[2]) end
  if simDR_radio_nav_horizontal[3]==1 then vorR_radial=string.format("%03d",simDR_radio_nav_radial[3]) end
  if modes:sub(2, 2)=="M" then vorL_obs=string.format("%03d",simDR_radio_nav_obs_deg[2]) end
  if modes:sub(3, 3)=="M" then vorR_obs=string.format("%03d",simDR_radio_nav_obs_deg[3]) end
  local page={
    "        NAV RADIO       ",
    "                        ",
    string.format("%6.2f %4s  %4s %6.2f", simDR_radio_nav_freq_hz[2]*0.01, simDR_radio_nav03_ID, simDR_radio_nav04_ID, simDR_radio_nav_freq_hz[3]*0.01),
    string.format("                        ", ""),
    string.format("%3s      %3s  %3s    %3s", vorL_obs, vorL_radial,vorR_radial, vorR_obs),
    "                        ",
    string.format("%06.1f           %06.1f ", simDR_radio_adf1_freq_hz, simDR_radio_adf2_freq_hz),
    "                        ",
    ils1,
--    ils2,
    "                        ",	
    "                        ", 
--    "--------         -------",
    "                        ", 
    fmsModules["data"]["preselectLeft"].."            "..fmsModules["data"]["preselectRight"],
    }
  return page
end
fmsPages["NAVRAD"].getSmallPage=function(self,pgNo,fmsID)
  local modes=B777DR_radioModes
  return{
  "                        ",
  " VOR L             VOR R",
  "      ".. modes:sub(2, 2) .."          ".. modes:sub(3, 3) .."      ",
  " CRS      RADIAL     CRS",
  "                        ",
  " ADF L             ADF R",
  "      M                M",
--  " ILS ".. modes:sub(1, 1) .."                  ",
  " ILS - MLS              ",  
--  "                        ",
  ils_line1,
  ils_line2,
--  ,
--  "                        ",
  "                        ",
  "        PRESELECT       ",
  "                        ",
  }
end
fmsFunctionsDefs["NAVRAD"]["L1"]={"setDref","VORL"}
fmsFunctionsDefs["NAVRAD"]["L2"]={"setDref","CRSL"}
fmsFunctionsDefs["NAVRAD"]["L3"]={"setDref","ADFL"}
fmsFunctionsDefs["NAVRAD"]["R1"]={"setDref","VORR"}
fmsFunctionsDefs["NAVRAD"]["R2"]={"setDref","CRSR"}
fmsFunctionsDefs["NAVRAD"]["R3"]={"setDref","ADFR"}
fmsFunctionsDefs["NAVRAD"]["L4"]={"setDref","ILS"}
fmsFunctionsDefs["NAVRAD"]["L6"]={"setdata","preselectLeft"}
fmsFunctionsDefs["NAVRAD"]["R6"]={"setdata","preselectRight"}
--fmsFunctionsDefs["NAVRAD"]["L6"]={"setpage","ACARS"}


----- FMS FUNCTIONS ---------------


function fmsFunctions.setpage_no(fmsO,valueA) -- set page with target page number
	print("setpage_no="..valueA)
    local valueO=split(valueA,"_")
    print(valueO[1].." "..valueO[2])
	--fmsO["pgNo"]=tonumber(valueO[2])
	fmsO["targetpgNo"]=tonumber(valueO[2])
	value=valueO[1]

	if value=="FMC" then
		fmsO["targetCustomFMC"]=false
		fmsO["targetPage"]="FMC"
		simCMD_FMS_key[fmsO.id]["fpln"]:once()
		simCMD_FMS_key[fmsO.id]["L6"]:once()
		simCMD_FMS_key[fmsO.id]["L2"]:once()
	elseif value=="PROGRESS" then
		fmsModules[fmsO.id].targetCustomFMC=false
		simCMD_FMS_key[fmsO.id]["prog"]:once()
		fmsModules[fmsO.id].targetPage="PROGRESS"
		fmsModules[fmsO.id].targetpgNo=1
	elseif value=="VHFCONTROL" then
		fmsO["targetCustomFMC"]=false
		fmsO["targetPage"]="VHFCONTROL"
		simCMD_FMS_key[fmsO.id]["navrad"]:once()
	elseif value=="IDENT" then
		fmsO["targetCustomFMC"]=true
		fmsO["targetPage"]="IDENT"
		simCMD_FMS_key[fmsO.id]["index"]:once()
		simCMD_FMS_key[fmsO.id]["L1"]:once()
	elseif value=="DATABASE" then
		fmsO["targetCustomFMC"]=false
		fmsO["targetPage"]="DATABASE"
		simCMD_FMS_key[fmsO.id]["index"]:once()
		simCMD_FMS_key[fmsO.id]["R2"]:once()
	elseif value=="RTE1" then
		simCMD_FMS_key[fmsO.id]["fpln"]:once()
		fmsO["targetCustomFMC"]=true
		fmsO["targetPage"]="RTE1"
	elseif value=="RTE2" then
		fmsO["targetCustomFMC"]=false
		fmsO["targetPage"]="RTE2"
		simCMD_FMS_key[fmsO.id]["dir_intc"]:once()
	elseif value=="LEGS" then
		fmsModules[fmsO.id].targetCustomFMC=true
		fmsModules[fmsO.id].targetPage="LEGS"
		simCMD_FMS_key[fmsO.id]["legs"]:once()
		fmsModules[fmsO.id].targetpgNo=1
	else
		fmsO["targetCustomFMC"]=true
		fmsO["targetPage"]=value
	end

	print("setpage " .. value)
	run_after_time(switchCustomMode, 0.5)
end

function fmsFunctions.setpage(fmsO,value) -- set page
	value=value.."_1"
	fmsFunctions["setpage_no"](fmsO,value)
	--sim/FMS/navrad
	--sim/FMS2/navrad
end

function fmsFunctions.custom2fmc(fmsO,value)
	print("custom2fmc" .. value)
	simCMD_FMS_key[fmsO["id"]]["del"]:once()
	simCMD_FMS_key[fmsO["id"]]["clear"]:once()
	if value~="next" and value~="prev" and string.len(fmsO["scratchpad"])>0 then
		for c in string.gmatch(fmsO["scratchpad"],".") do
			local v = c
			if v == "/" then v = "slash" end
			simCMD_FMS_key[fmsO["id"]][v]:once()
		end
	elseif value=="next" then
		fmsO["targetpgNo"]=fmsO["pgNo"]+1
		run_after_time(switchCustomMode, 0.5)
	elseif value=="prev" then 
		fmsO["targetpgNo"]=fmsO["pgNo"]-1	run_after_time(switchCustomMode, 0.5)
	end
	simCMD_FMS_key[fmsO["id"]][value]:once()
	fmsO["scratchpad"]=""
end

function fmsFunctions.key2fmc(fmsO,value)
	print("key2fmc" .. value)
	if string.len(fmsO["scratchpad"])>0 then
		simCMD_FMS_key[fmsO["id"]]["del"]:once()
		simCMD_FMS_key[fmsO["id"]]["clear"]:once()
		if value~="next" and value~="prev" then
			for c in string.gmatch(fmsO["scratchpad"],".") do
			local v=c
			if v=="/" then v="slash" end
				simCMD_FMS_key[fmsO["id"]][v]:once()
			end
		end
	end
	simCMD_FMS_key[fmsO["id"]][value]:once()
	fmsO["scratchpad"]=""
	fmsO["notify"]=""
end

local updateFrom="fmsL"
local lastCrz=0
--[[function checkCRZ()
	if lastCrz==B777BR_cruiseAlt then return end
	if is_timer_scheduled(updateCRZ)==true then return end
	simCMD_FMS_key[fmsL.id]["fpln"]:once()--make sure we arent on the vnav page
    simCMD_FMS_key[fmsL.id]["clb"]:once()--go to the vnav page
    simCMD_FMS_key[fmsL.id]["next"]:once() --go to the vnav page 2

    fmsFunctions["custom2fmc"](fmsL,"R1")
    updateFrom=fmsL.id
    local toGet=B777DR_srcfms[updateFrom][3] --make sure we update it
    run_after_time(updateCRZ,0.5)

end

function updateCRZ()
	local setVal=string.sub(B777DR_srcfms[updateFrom][3],20,24)
	print("from line".. updateFrom.." "..B777DR_srcfms[updateFrom][3])
	print("to:"..setVal)
	local alt=validAlt(setVal)
	if alt~=nil then 
		B777BR_cruiseAlt=alt
		lastCrz=alt
	end
  fmsModules:setData("crzalt",setVal)
end
]]

function fmsFunctions.getdata(fmsO,value) -- getdata
	local data = ""
	if value == "gpspos" then
		data = fmsModules["data"].pos
	else
		data = getFMSData(value)
	end
	fmsO["scratchpad"] = data
end

function validateSpeed(value)
	local val=tonumber(value)
	if val==nil then return false end
	if val<130 or val>300 then return false end
	return true
end
function validAlt(value)
	local val=tonumber(value)
	if string.len(value)>2 and string.sub(value,1,2)=="FL" then val=tonumber(string.sub(value,3)) end
	if val==nil then return nil end
	if val<1000 then val=val*100 end
	if val<2000 or val>40000 then return nil end
	return ""..val
end
function validFL(value)
	local val=tonumber(value)
	if string.len(value)>2 and string.sub(value,1,2)=="FL" then val=tonumber(string.sub(value,3)) end
	if val==nil then return nil end
	if val<1000 then val=val*100 end
	if val<10000 or val>40000 then return nil end
	return "FL".. (val/100)
end
function validateMachSpeed(value)
	local val=tonumber(value)
	if val==nil then return nil end
	if val<1 then val=val*1000 end
	if val<100 then val=val*10 end
	if val<400 or val>870 then return nil end
	return ""..val
end
function validate_weight_units(value)
	--local val=tostring(value)
	--print(value)
	if value == "KGS" or value == "LBS" then
		return true
	else
		return false
	end
end
function validate_sethdg(value)
	--print(value)
	if tonumber(value) >= 0 and tonumber(value) <= 360 then
		return true
	else
		return false
	end
end

--[[function preselect_fuel() -- ss777 comment
	-- DETERMINE FUEL WEIGHT DISPLAY UNITS
	local fuel_calculation_factor = 1
	
	if simConfigData["data"].SIM.weight_display_units == "LBS" then
		fuel_calculation_factor = simConfigData["data"].SIM.kgs_to_lbs
	end
	
	B777DR_refuel=B777DR_fuel_add * 1000 / fuel_calculation_factor  --(always add fuel in KGS behind the scenes)
	B777DR_fuel_preselect=simDR_fueL_tank_weight_total_kg + B777DR_refuel
	
	-- Used in calculation for displaying Preselect Fuel Qty in correct weight units (actual display done in B777.25.xt.fuel)
	B777DR_fuel_preselect_temp = B777DR_fuel_preselect
	B777DR_fuel_add=0
	simDR_m_jettison=simDR_acf_m_jettison
	
	--Marauder28
	--Set the totalizer to the current fuel amount before refueling
	simDR_fuel_totalizer_kg = simDR_fueL_tank_weight_total_kg
	--Marauder28
end

--Marauder28
function calc_pax_cargo()
	local pax_total				= 0
	local pax_weightA			= 0
	local pax_weightB			= 0
	local pax_weightC			= 0
	local pax_weightD			= 0
	local pax_weightE			= 0
	local pax_weight_Tot		= 0
	local cargo_weight_fwd		= 0
	local cargo_weight_aft		= 0
	local cargo_weight_bulk		= 0
	local cargo_weight_tot		= 0
	local freight_weightA		= 0
	local freight_weightB		= 0
	local freight_weightC		= 0
	local freight_weightD		= 0
	local freight_weightE		= 0
	local freight_weight_tot	= 0

	pax_total		= 	tonumber(fmsModules["data"].paxFirstClassA) + tonumber(fmsModules["data"].paxBusClassB)
						+ tonumber(fmsModules["data"].paxEconClassC) + tonumber(fmsModules["data"].paxEconClassD)
						+ tonumber(fmsModules["data"].paxEconClassE)
	pax_weightA		=	tonumber(fmsModules["data"].paxFirstClassA) * simConfigData["data"].SIM.std_pax_weight
	pax_weightB		= 	tonumber(fmsModules["data"].paxBusClassB) * simConfigData["data"].SIM.std_pax_weight
	pax_weightC		=	tonumber(fmsModules["data"].paxEconClassC) * simConfigData["data"].SIM.std_pax_weight
	pax_weightD		=	tonumber(fmsModules["data"].paxEconClassD) * simConfigData["data"].SIM.std_pax_weight
	pax_weightE		=	tonumber(fmsModules["data"].paxEconClassE) * simConfigData["data"].SIM.std_pax_weight
	pax_weight_Tot	=	pax_weightA + pax_weightB + pax_weightC + pax_weightD + pax_weightE

	cargo_weight_fwd	= tonumber(fmsModules["data"].cargoFwd)
	cargo_weight_aft	= tonumber(fmsModules["data"].cargoAft)
	cargo_weight_bulk	= tonumber(fmsModules["data"].cargoBulk)
	cargo_weight_tot	= cargo_weight_fwd + cargo_weight_aft + cargo_weight_bulk
	
	freight_weightA		= tonumber(fmsModules["data"].freightZoneA)
	freight_weightB		= tonumber(fmsModules["data"].freightZoneB)
	freight_weightC		= tonumber(fmsModules["data"].freightZoneC)
	freight_weightD		= tonumber(fmsModules["data"].freightZoneD)
	freight_weightE		= tonumber(fmsModules["data"].freightZoneE)
	freight_weight_tot	= freight_weightA + freight_weightB + freight_weightC + freight_weightD + freight_weightE
	
	--Assign values to FMC
	fmsModules["data"].paxTotal 		= pax_total
	fmsModules["data"].paxWeightA		= pax_weightA
	fmsModules["data"].paxWeightB		= pax_weightB
	fmsModules["data"].paxWeightC		= pax_weightC
	fmsModules["data"].paxWeightD		= pax_weightD
	fmsModules["data"].paxWeightE		= pax_weightE
	fmsModules["data"].paxWeightTotal	= pax_weight_Tot
	fmsModules["data"].cargoTotal		= cargo_weight_tot
	fmsModules["data"].freightTotal		= freight_weight_tot
	
	--Assign values to WB
	wb.passenger_zoneA_weight		= pax_weightA	
	wb.passenger_zoneB_weight		= pax_weightB
	wb.passenger_zoneC_weight		= pax_weightC
	wb.passenger_zoneD_weight		= pax_weightD
	wb.passenger_zoneE_weight		= pax_weightE
	wb.fwd_lower_cargo_weight		= cargo_weight_fwd
	wb.aft_lower_cargo_weight		= cargo_weight_aft
	wb.bulk_lower_cargo_weight		= cargo_weight_bulk
	wb.freight_zoneA_weight			= freight_weightA
	wb.freight_zoneB_weight			= freight_weightB
	wb.freight_zoneC_weight			= freight_weightC
	wb.freight_zoneD_weight			= freight_weightD
	wb.freight_zoneE_weight			= freight_weightE
	
	--Update Sim Payload weight with PAX & Cargo entries
	simDR_payload_weight = pax_weight_Tot + cargo_weight_tot + freight_weight_tot
	
	--print("PAX A Wgt = "..pax_weightA)
	--print("PAX A = "..tonumber(fmsModules["data"].paxFirstClassA))
	--print("PAX B Wgt = "..pax_weightB)
	--print("PAX B = "..tonumber(fmsModules["data"].paxBusClassB))
	--print("PAX C Wgt = "..pax_weightC)
	--print("PAX C = "..tonumber(fmsModules["data"].paxEconClassC))
	--print("PAX D Wgt = "..pax_weightD)
	--print("PAX D = "..tonumber(fmsModules["data"].paxEconClassD))
	--print("PAX E Wgt = "..pax_weightE)
	--print("PAX E = "..tonumber(fmsModules["data"].paxEconClassE))
	--print("PAX Tot = "..pax_weight_Tot)
	--print("Cargo Fwd = "..cargo_weight_fwd)
	--print("Cargo Aft = "..cargo_weight_aft)
	--print("Cargo Bulk = "..cargo_weight_bulk)
	--print("Cargo Tot = "..cargo_weight_tot)
	--print("FREIGHT A = "..freight_weightA)
	--print("FREIGHT B = "..freight_weightB)
	--print("FREIGHT C = "..freight_weightC)
	--print("FREIGHT D = "..freight_weightD)
	--print("FREIGHT E = "..freight_weightE)
	--print("Freight Tot = "..freight_weight_tot)
end
--Marauder28
]]

function saveSimconfig()
    pushSimConfig(simConfigData["data"]["values"])
	B777CMD_save_simconfig:once()
end

function slashEntry(input, field)
	local fieldPreSlash = field:sub(1, field:find("/") - 1)
    local fieldPostSlash= field:sub(field:find("/") + 1, -1)
	local inputSlashPos = input:find("/")

    if inputSlashPos then
        if inputSlashPos == 1 then
            return fieldPreSlash..input
        elseif inputSlashPos == input:len() then
            return input..fieldPostSlash
        elseif inputSlashPos > 1 and inputSlashPos < input:len() then
            return input
        end
    else
        return input.."/"..fieldPostSlash
    end
end

timer_start = 0
local kgs_to_lbs = 2.204623
function fmsFunctions.setdata(fmsO,value)
	local del=false
	if fmsO["scratchpad"]=="DELETE" then fmsO["scratchpad"]="" del=true end
	----- STRATOSPHERE 777 ----------

	if value == "BARO" then

		local id = fmsO.id == "fmsL" and 0 or 1;

		if fmsO["scratchpad"] == "S" or fmsO["scratchpad"] == "STD" then
			simDR_altimiter_setting[id+1] = 29.92
			fmsO["scratchpad"] = ""
			return
		end

		local baro = tonumber(fmsO["scratchpad"])

		if baro == nil then
			fmsO["notify"] = "INVALID ENTRY"
		else
			if baro % 1 == 0 then
				if baro >= 950 and baro <= 1050 then
					B777DR_baro_mode[id] = 1
					simDR_altimiter_setting[id+1] = baro / 33.863892
					fmsO["scratchpad"] = ""
				else
					fmsO["notify"] = "INVALID ENTRY"
				end
			else
				if baro <= 31 and baro >= 29 then
					B777DR_baro_mode[id] = 0
					simDR_altimiter_setting[id+1] = baro
					fmsO["scratchpad"] = ""
				else
					fmsO["notify"] = "INVALID ENTRY"
				end
			end
		end
		return
	end

	if value == "mins" then
		local id = fmsO.id == "fmsL" and 0 or 1;
		local mins = tonumber(fmsO["scratchpad"])
		if mins ~= nil then
			if B777DR_minimums_mode[id] == 0 then
				if mins >= 0 and mins <= 1000 then
					B777DR_minimums_dh[id] = mins
					fmsO["scratchpad"] = ""
					B777DR_minimums_visible[id] = 1
				else
					fmsO["notify"] = "INVALID ENTRY"
				end
			else
				if mins >= -1000 and mins <= 15000 then
					B777DR_minimums_mda[id] = mins
					fmsO["scratchpad"] = ""
					B777DR_minimums_visible[id] = 1
				else
					fmsO["notify"] = "INVALID ENTRY"
				end
			end
		else
			fmsO["notify"] = "INVALID ENTRY"
		end
		return
	end

	if value == "readmeCode" then
		if simConfigData["data"].FMC.unlocked == 0 then
			setFMSData("readmeCodeInput", fmsO["scratchpad"])
			if string.len(fmsO["scratchpad"]) == 5 then
				if fmsO["scratchpad"] == B777DR_readme_code or fmsO["scratchpad"] == "BIRDS" then
					fmsO["notify"] = "UNLOCKED"
					fmsO["scratchpad"] = ""
					simConfigData["data"].FMC.unlocked = 1
					saveSimconfig();
				else
					fmsO["notify"] = "INCORRECT CODE"
				end
			else
				fmsO["notify"] = "INVALID ENTRY"
			end
		else
			fmsO["notify"] = "ALREADY UNLOCKED"
		end
		return
	end

----- SPARKY 744 ----------

	if value=="depdst" and string.len(fmsO["scratchpad"])>3  then
		dep=string.sub(fmsO["scratchpad"],1,4)
		dst=string.sub(fmsO["scratchpad"],-4)
		--fmsModules["data"]["fltdep"]=dep
		--fmsModules["data"]["fltdst"]=dst
		setFMSData("fltdep",dep)
		setFMSData("fltdst",dst)
	elseif value=="clbspd" then
		if validateSpeed(fmsO["scratchpad"]) ==false then 
			fmsO["notify"]="INVALID ENTRY"
		else
			setFMSData("clbspd",fmsO["scratchpad"])
		end
	elseif value=="clbtrans" then
		spd=string.sub(fmsO["scratchpad"],1,3)
		alt=string.sub(fmsO["scratchpad"],5)
		if validateSpeed(spd) ==false then 
			fmsO["notify"]="INVALID ENTRY"
		else
			setFMSData("transpd",spd)
			if validAlt(alt) ~=nil then
				setFMSData("spdtransalt",validAlt(alt))
			end
		end
	elseif value=="transalt" then
		if validAlt(fmsO["scratchpad"]) ~=nil then
			setFMSData("transalt",validAlt(fmsO["scratchpad"]))
		else
			fmsO["notify"]="INVALID ENTRY"
		end
	elseif value=="clbrest" then
		spd=string.sub(fmsO["scratchpad"],1,3)
		alt=string.sub(fmsO["scratchpad"],5)
		if validateSpeed(spd) ==false then 
			fmsO["notify"]="INVALID ENTRY"
		else
			setFMSData("clbrestspd",spd)
			if validAlt(alt) ~=nil then
				setFMSData("clbrestalt",validAlt(alt))
			end
		end
	elseif value=="crzspd" then
		if validateMachSpeed(fmsO["scratchpad"]) ==nil then 
			fmsO["notify"]="INVALID ENTRY"
		else
			setFMSData("crzspd",validateMachSpeed(fmsO["scratchpad"]))
		end
	elseif value=="stepalt" then
		if validFL(fmsO["scratchpad"]) ~=nil then 
			setFMSData("stepalt",validFL(fmsO["scratchpad"]))
		else
			fmsO["notify"]="INVALID ENTRY"
		end
	elseif value=="desspds" then
		div = string.find(fmsO["scratchpad"], "%/")
		spd = getFMSData("desspd")
		-- print(spd)
		if div==nil then
			div=string.len(fmsO["scratchpad"])+1
		else
			spd=string.sub(fmsO["scratchpad"],div+1)
		end
		-- print(spd)
		machspd=string.sub(fmsO["scratchpad"],1,div-1)
		if validateMachSpeed(machspd) ==nil or validateSpeed(spd) ==false then 
			fmsO["notify"]="INVALID ENTRY"
		else
			setFMSData("desspd",spd)
			setFMSData("desspdmach",validateMachSpeed(machspd))
		end
	elseif value=="destrans" then
		spd=string.sub(fmsO["scratchpad"],1,3)
		alt=string.sub(fmsO["scratchpad"],5)
		if validateSpeed(spd) ==false then 
			fmsO["notify"]="INVALID ENTRY"
		else
			setFMSData("destranspd",spd)
			if validAlt(alt) ~=nil then 
				setFMSData("desspdtransalt",validAlt(alt))
			end
		end
	elseif value=="desrest" then
		spd=string.sub(fmsO["scratchpad"],1,3)
		alt=string.sub(fmsO["scratchpad"],5)
		if validateSpeed(spd) ==false then 
			fmsO["notify"]="INVALID ENTRY"
		else
			setFMSData("desrestspd",spd)
			if validAlt(alt) ~=nil then 
				setFMSData("desrestalt",validAlt(alt))
			end
		end
	elseif value=="airportpos" then --and string.len(fmsO["scratchpad"])>3 then
		if string.len(navAidsJSON) > 1 then
			if string.match(fmsO["scratchpad"], '%a%a%a%a') and string.len(fmsO["scratchpad"]) == 4 then
				local navAids=json.decode(navAidsJSON)
				print(table.getn(navAids).." navaids")
				print(navAidsJSON)
				local found = false
				for n=table.getn(navAids),1,-1 do
					--if navAids[n][2] == 1 and navAids[n][8]==fmsO["scratchpad"] then
					if navAids[n][2] == 1 and navAids[n][8]==fmsO["scratchpad"] then
						print("navaid "..n.."->".. navAids[n][1].." ".. navAids[n][2].." ".. navAids[n][3].." ".. navAids[n][4].." ".. navAids[n][5].." ".. navAids[n][6].." ".. navAids[n][7].." ".. navAids[n][8])
						print("airport pos1")
						local lat=toDMS(navAids[n][5],true)
						local lon=toDMS(navAids[n][6],false)
						print("airport pos2: "..lat..", "..lon)
						setFMSData("aptLat",lat)
						setFMSData("aptLon",lon)
						print("airport pos3: "..lat..", "..lon)
						found = true
					end
				end
				if found then
					setFMSData("airportpos",fmsO["scratchpad"])
					setFMSData("airportgate","-----")
				else
					fmsO["notify"]="NOT IN DATABASE"
				end
			elseif del == true then
				setFMSData("airportpos",defaultFMSData().airportpos)
				setFMSData("airportpos",defaultFMSData().airportgate)
				setFMSData("irsLat",defaultFMSData().irsLat)
				setFMSData("irsLon",defaultFMSData().irsLon)
			else
				fmsO["notify"]="INVALID ENTRY"
			end
		else
			print("ERROR: navAidsJSON is invalid: "..navAidsJSON)
		end
	elseif value=="flttime" then 
		hhV=string.sub(fmsO["scratchpad"],1,2)
		mmV=string.sub(fmsO["scratchpad"],-2)
		setFMSData("flttimehh",hhV)
		setFMSData("flttimemm",mmV)
	elseif value=="rpttime" then
		hhV=string.sub(fmsO["scratchpad"],1,2)
		mmV=string.sub(fmsO["scratchpad"],-2)
		setFMSData("rpttimehh",hhV)
		setFMSData("rpttimemm",mmV)
	elseif value=="fltdate" then 
		setFMSData("fltdate",os.date("%Y%m%d"))
	elseif value=="crzalt" then

    simCMD_FMS_key[fmsO.id]["fpln"]:once()--make sure we arent on the vnav page
    simCMD_FMS_key[fmsO.id]["clb"]:once()--go to the vnav page
    simCMD_FMS_key[fmsO.id]["next"]:once() --go to the vnav page 2

    fmsFunctions["custom2fmc"](fmsO,"R1")
    updateFrom=fmsO.id
    local toGet=B777DR_srcfms[updateFrom][3] --make sure we update it
    run_after_time(updateCRZ,0.5)
	elseif value=="irspos" then
		if string.len(fmsO["scratchpad"])>10 then
			print("set irs pos")
			lat=string.sub(fmsO["scratchpad"],1,9)
			lon=string.sub(fmsO["scratchpad"],-9)
			--fmsModules["data"]["fltdep"]=dep
			--fmsModules["data"]["fltdst"]=dst
			print(getFMSData("irsLat").." "..lat)
			print(getFMSData("irsLon").." "..lon)
			setFMSData("irsLat",lat)
			setFMSData("irsLon",lon)
			irsSystem["irsLat"]=lat
			irsSystem["irsLon"]=lon
			irsSystem["setPos"]=true
			fmsModules["data"]["initIRSLat"]=lat
			fmsModules["data"]["initIRSLon"]=lon
			B777DR_fmc_notifications[12]=0
		else
			fmsO["notify"]="INVALID ENTRY"
		end
--      if fmsModules["fmsL"].notify=="ENTER IRS POSITION" then fmsModules["fmsL"].notify="" end
--      if fmsModules["fmsC"].notify=="ENTER IRS POSITION" then fmsModules["fmsC"].notify="" end
--      if fmsModules["fmsR"].notify=="ENTER IRS POSITION" then fmsModules["fmsR"].notify="" end
   elseif value=="passengers" then
     local numPassengers=tonumber(fmsO["scratchpad"])
     if numPassengers==nil then numPassengers=2 end
     if numPassengers<2 then numPassengers=2 end
     if numPassengers>416 then numPassengers=416 end
     B777DR_payload_weight=numPassengers*120
   elseif value=="services" then
     if simDR_acf_m_jettison==0 then
		if B777DR_elec_ext_pwr1_available==0 then
        	fmsModules["cmds"]["Strato/B777/electrical/connect_power"]:once() 
		end
		fmsModules["cmds"]["sim/ground_ops/service_plane"]:once() 
     end
     fmsModules["lastcmd"]=fmsModules["cmdstrings"]["sim/ground_ops/service_plane"]
     run_after_time(preselect_fuel,30)
   elseif value=="fuelpreselect" then
	if string.len(fmsO["scratchpad"])>0 then
     local fuel=tonumber(fmsO["scratchpad"])
     if fuel~=nil then
       B777DR_fuel_add=fuel
       
     end
	else
		fmsO["notify"]="INVALID ENTRY"
	end
   elseif value=="origin" then
	if string.len(fmsO["scratchpad"])>0 then
     fmsFunctions["custom2fmc"](fmsO,"L1")
     fmsModules:setData("crzalt","*****") -- clear cruise alt /crzalt when entering a new source airport (this is broken and currently disabled)
	else
		fmsO["notify"]="INVALID ENTRY"
	end
	elseif value=="airportgate" then
		if string.len(fmsO["scratchpad"]) <= 5 then
			--[[local lat=toDMS(simDR_latitude,true)
			local lon=toDMS(simDR_longitude,false)
			setFMSData("irsLat",lat)
			setFMSData("irsLon",lon)]]
			fmsModules["data"].airportgate = fmsO["scratchpad"]
		else
			fmsO["notify"]="INVALID ENTRY"
		end
		return
	elseif value == "sethdg" then
		if validate_sethdg(fmsO["scratchpad"]) == false then
			fmsO["notify"]="INVALID ENTRY"
		else
			if fmsModules["data"] ~= "---`" then
				if (fmsO["scratchpad"] == "0" or fmsO["scratchpad"] == "00" or fmsO["scratchpad"] == "000") then
					fmsO["scratchpad"] = "360`"
				end
				setFMSData(value, fmsO["scratchpad"].."`")
				timer_start = simDRTime
			end
		end
		return
	elseif value == "vref1" then
		fmsO["scratchpad"]=string.format("25/%3d", B777DR_airspeed_Vf25)
		return
	elseif value == "vref2" then
		fmsO["scratchpad"]=string.format("30/%3d", B777DR_airspeed_Vf30)
		return
	elseif value == "flapspeed" then
		if fmsO["scratchpad"]=="" then
			B777DR_airspeed_VrefFlap=0
			setFMSData(value,"")
			return
		end
		local vref=tonumber(string.sub(fmsO["scratchpad"],4))
		if vref==nil or vref<110 or vref>180 then
			fmsO["notify"]="INVALID ENTRY"
			return
		end
		B777DR_airspeed_Vref=vref
		print(string.sub(fmsO["scratchpad"],1,2))
		if string.sub(fmsO["scratchpad"],1,2) == "25" then
			B777DR_airspeed_VrefFlap=1
		else
			B777DR_airspeed_VrefFlap=2
		end	
		setFMSData(value,fmsO["scratchpad"])
		return
	elseif value == "drag_ff" then
		local input = fmsO["scratchpad"]

		if input == "ARM" then
			if getFMSData("dragFF_armed") == "ARM" then
				setFMSData("dragFF_armed", "   ")
			else
				setFMSData("dragFF_armed", "ARM")
			end
			return
		else
			if getFMSData("dragFF_armed") == "ARM" then
				local output = ""
				if input:match("/") then
					local inputSplit = split(input, "/")
					for i = 1, 2 do
						if inputSplit[i] then
							if not tonumber(inputSplit[i]) then
								fmsO["notify"]="INVALID ENTRY"
								return
							else
								inputSplit[i] = string.format("%.1f", inputSplit[i])
								if inputSplit[i]:sub(1, 1):match("%d") then
									inputSplit[i] = "+"..inputSplit[i]
								end
								if tonumber(inputSplit[i]) < -5.0 then
									inputSplit[i] = "-5.0"
								elseif tonumber(inputSplit[i]) > 9.9 then
									inputSplit[i] = "9.9"
								end
								output = output..inputSplit[i].."/"
							end
						end
					end
					output = output:sub(1, -2)
				else
					if not tonumber(input) then
						fmsO["notify"]="INVALID ENTRY"
						return
					else
						if tonumber(input) < -5.0 then
							input = "-5.0"
						elseif tonumber(input) > 9.9 then
							input = "9.9"
						end
						if output:sub(1, 1):match("%d") then
							output = "+"..string.format("%.1f", input)
						else
							output = string.format("%.1f", input)
						end
					end
				end
				output = slashEntry(output, simConfigData["data"].FMC.drag_ff)
				simConfigData["data"].FMC.drag_ff = output
				saveSimconfig();
			end
		end
		return
	elseif value == "grwt" then
		local grwt
		if string.len(fmsO["scratchpad"]) ~= 0 and string.len(fmsO["scratchpad"]) ~= 3 and string.len(fmsO["scratchpad"]) ~= 5 then
			fmsO["notify"]="INVALID ENTRY"
			fmsO["scratchpad"] = ""
			return
			
		elseif string.len(fmsO["scratchpad"]) > 0 and string.len(fmsO["scratchpad"]) <= 5 and string.match(fmsO["scratchpad"], "%d") then
			if simConfigData["data"].OPTIONS.weight_display_units == "LBS" then
				grwt = fmsO["scratchpad"] / kgs_to_lbs
			else
				grwt = fmsO["scratchpad"]
			end
		elseif fmsO["scratchpad"] == "" then
			grwt = simDR_GRWT / 1000
		else
			fmsO["notify"]="INVALID ENTRY"
			fmsO["scratchpad"] = ""
			return
		end
		grwt = string.format("%5.1f", grwt)
		if tonumber(grwt) > 999 then
			fmsO["notify"]="INVALID ENTRY"
			fmsO["scratchpad"] = ""
			return
		end
		local zfw = string.format("%5.1f", tonumber(grwt) - (simDR_fuel / 1000))
		if tonumber(zfw) <50 then
			fmsO["notify"]="INVALID ENTRY"
			fmsO["scratchpad"] = ""
			return
		end
		setFMSData(value, grwt)
		setFMSData("zfw", zfw)
		calc_CGMAC()  --Recalc CG %MAC and TRIM units
		if (B777DR_airspeed_V1 < 999 or B777DR_airspeed_Vr < 999 or B777DR_airspeed_V2 < 999) and simDR_onground == 1 then
			B777DR_airspeed_flapsRef = 0
			--B777DR_airspeed_V1 = 999
			--B777DR_airspeed_Vr = 999
			--B777DR_airspeed_V2 = 999
			fmsO["notify"] = "TAKEOFF SPEEDS DELETED"
		end
		return
	elseif value == "zfw" and not del then
		local zfw;
		if string.len(fmsO["scratchpad"]) > 0 and string.len(fmsO["scratchpad"]) <= 5 and string.match(fmsO["scratchpad"], "%d") then
			if simConfigData["data"].SIM.weight_display_units == "LBS" then
				zfw = fmsO["scratchpad"] / simConfigData["data"].SIM.kgs_to_lbs  --store LBS in KGS
			else
				zfw = fmsO["scratchpad"]
			end
		elseif fmsO["scratchpad"] == "" then
			zfw = (simDR_GRWT-simDR_fuel) / 1000
		else
			fmsO["notify"]="INVALID ENTRY"
			fmsO["scratchpad"] = ""
			return
		end
		zfw = string.format("%5.1f", zfw)
		grwt = string.format("%5.1f", tonumber(zfw) + (simDR_fuel / 1000))
		setFMSData(value, zfw)
		setFMSData("grwt", grwt)
		calc_CGMAC()  --Recalc CG %MAC and TRIM units
		if (B777DR_airspeed_V1 < 999 or B777DR_airspeed_Vr < 999 or B777DR_airspeed_V2 < 999) and simDR_onground == 1 then
			B777DR_airspeed_flapsRef = 0
			--B777DR_airspeed_V1 = 999
			--B777DR_airspeed_Vr = 999
			--B777DR_airspeed_V2 = 999
			fmsO["notify"] = "TAKEOFF SPEEDS DELETED"
		end
		return
	elseif value == "reserves" then
	local rsv = 0
		if not string.match(fmsO["scratchpad"], "%d") or string.len(fmsO["scratchpad"]) > 5 then
			fmsO["notify"] = "INVALID ENTRY"
			fmsO["scratchpad"] = ""
			return
		else
			if simConfigData["data"].SIM.weight_display_units == "LBS" then
				rsv = string.format("%5.1f", fmsO["scratchpad"] / simConfigData["data"].SIM.kgs_to_lbs)  --store LBS in KGS
			else
				rsv = string.format("%5.1f", fmsO["scratchpad"])
			end
			setFMSData(value, rsv)
		end
	elseif value == "crzcg" then
		if len(fmsO["scratchpad"]):len() > 0 and not string.find(fmsO["scratchpad"], " ") then
			setFMSData("crzcg", fmsO["scratchpad"])
			crzcg_lineLg = string.format("%4.1f%%", tonumber(fmsModules["data"].crzcg))
		end
	elseif value == "stepsize" then
		if fmsO["scratchpad"] == "ICAO" or fmsO["scratchpad"] == "RVSM "then
			setFMSData(value, fmsO["scratchpad"])
		elseif tonumber(fmsO["scratchpad"]) == nil then
			fmsO["notify"] = "INVALID ENTRY"
		elseif tonumber(fmsO["scratchpad"]) < 0 or tonumber(fmsO["scratchpad"]) > 9000 or math.fmod(tonumber(fmsO["scratchpad"]), 1000) > 0 then  --ensure increments of 1000
			fmsO["notify"] = "INVALID ENTRY"
		else
			setFMSData(value, fmsO["scratchpad"])
		end
		return
  elseif value == "cg_mac" then
	if string.match(fmsO["scratchpad"], "%a") or string.match(fmsO["scratchpad"], "%s") or fmsModules["data"].cg_mac == "--" then
		fmsO["notify"] = "INVALID ENTRY"
		return
	elseif string.len(fmsO["scratchpad"]) > 0 then 
		calc_stab_trim(fmsModules["data"].grwt, fmsO["scratchpad"])
		setFMSData(value, fmsO["scratchpad"])
	else
		calc_stab_trim(fmsModules["data"].grwt, fmsModules["data"].cg_mac)
	end
	
	cg_lineLg = string.format("%2.0f%%", tonumber(fmsModules["data"].cg_mac))
--Marauder28
--PAX / CARGO page
  elseif value == "paxFirstClassA" then
	if string.match(fmsO["scratchpad"], "%d") and math.abs(tonumber(fmsO["scratchpad"])) <= 23 then
		setFMSData(value, math.abs(string.format("%2d", fmsO["scratchpad"])))
		calc_pax_cargo()
	elseif fmsO["scratchpad"] == "F" then  --Add FULL PAX
		setFMSData("paxFirstClassA", "23")
		setFMSData("paxBusClassB", "80")
		setFMSData("paxEconClassC", "77")
		setFMSData("paxEconClassD", "104")
		setFMSData("paxEconClassE", "132")
		setFMSData("freightZoneA", "")
		setFMSData("freightZoneB", "")
		setFMSData("freightZoneC", "")
		setFMSData("freightZoneD", "")
		setFMSData("freightZoneE", "")
		calc_pax_cargo()
	elseif fmsO["scratchpad"] == "C" then  --Clear PAX / CARGO entries
		setFMSData("paxFirstClassA", "")
		setFMSData("paxBusClassB", "")
		setFMSData("paxEconClassC", "")
		setFMSData("paxEconClassD", "")
		setFMSData("paxEconClassE", "")
		setFMSData("cargoFwd", "")
		setFMSData("cargoAft", "")
		setFMSData("cargoBulk", "")
		setFMSData("freightZoneA", "")
		setFMSData("freightZoneB", "")
		setFMSData("freightZoneC", "")
		setFMSData("freightZoneD", "")
		setFMSData("freightZoneE", "")
		calc_pax_cargo()
	elseif string.len(fmsO["scratchpad"]) < 1 then
		setFMSData(value, "23")
		calc_pax_cargo()
	elseif string.match(fmsO["scratchpad"], "%d") and tonumber(fmsO["scratchpad"]) > 23 then  --Add set number of PAX by round-robin through all zones
		setFMSData("paxFirstClassA", "")
		setFMSData("paxBusClassB", "")
		setFMSData("paxEconClassC", "")
		setFMSData("paxEconClassD", "")
		setFMSData("paxEconClassE", "")

		local x = tonumber(fmsO["scratchpad"])
		local paxA = 0
		local paxB = 0
		local paxC = 0
		local paxD = 0
		local paxE = 0
		
		if x > 416 then
			x = 416
		end
		repeat
			if x > 0 and paxA < 23 then
				paxA = paxA + 1
				x = x - 1
			end
			if x > 0 and paxB < 80 then
				paxB = paxB + 1
				x = x - 1
			end
			if x > 0 and paxC < 77 then
				paxC = paxC + 1
				x = x - 1
			end
			if x > 0 and paxD < 104 then
				paxD = paxD + 1
				x = x - 1
			end
			if x > 0 and paxE < 132 then
				paxE = paxE + 1
				x = x - 1
			end
		until (x == 0)
		
		fmsModules["data"].paxFirstClassA = string.format("%2d", paxA)
		fmsModules["data"].paxBusClassB = string.format("%2d", paxB)
		fmsModules["data"].paxEconClassC = string.format("%2d", paxC)
		fmsModules["data"].paxEconClassD = string.format("%3d", paxD)
		fmsModules["data"].paxEconClassE = string.format("%3d", paxE)
		
		calc_pax_cargo()
	else
		fmsO["notify"] = "INVALID ENTRY"
	end
  elseif value == "paxBusClassB" then
	if string.match(fmsO["scratchpad"], "%d") then
		local pax = math.abs(tonumber(fmsO["scratchpad"]))
		if pax > 80 then
			pax = 80
		end
		setFMSData(value, string.format("%2d", pax))
		calc_pax_cargo()
	elseif string.len(fmsO["scratchpad"]) < 1 then
		setFMSData(value, "80")
		calc_pax_cargo()
	else
		fmsO["notify"] = "INVALID ENTRY"
	end
  elseif value == "paxEconClassC" then
	if string.match(fmsO["scratchpad"], "%d") then
		local pax = math.abs(tonumber(fmsO["scratchpad"]))
		if pax > 77 then
			pax = 77
		end
		setFMSData(value, string.format("%2d", pax))
		calc_pax_cargo()
	elseif string.len(fmsO["scratchpad"]) < 1 then
		setFMSData(value, "77")
		calc_pax_cargo()
	else
		fmsO["notify"] = "INVALID ENTRY"
	end
  elseif value == "paxEconClassD" then
	if string.match(fmsO["scratchpad"], "%d") then
		local pax = math.abs(tonumber(fmsO["scratchpad"]))
		if pax > 104 then
			pax = 104
		end
		setFMSData(value, string.format("%3d", pax))
		calc_pax_cargo()
	elseif string.len(fmsO["scratchpad"]) < 1 then
		setFMSData(value, "104")
		calc_pax_cargo()
	else
		fmsO["notify"] = "INVALID ENTRY"
	end
  elseif value == "paxEconClassE" then
	if string.match(fmsO["scratchpad"], "%d") then
		local pax = math.abs(tonumber(fmsO["scratchpad"]))
		if pax > 132 then
			pax = 132
		end
		setFMSData(value, string.format("%3d", pax))
		calc_pax_cargo()
	elseif string.len(fmsO["scratchpad"]) < 1 then
		setFMSData(value, "132")
		calc_pax_cargo()
	else
		fmsO["notify"] = "INVALID ENTRY"
	end
  elseif value == "paxPayload" then
	if string.match(fmsO["scratchpad"], "%d") then
		local weight_factor = 1

		if simConfigData["data"].SIM.weight_display_units == "LBS" then
			weight_factor = simConfigData["data"].SIM.kgs_to_lbs
		else
			weight_factor = 1
		end

		local pax_weight = math.abs(tonumber(fmsO["scratchpad"])) * 1000
		local pax = 0
		local paxA = 0
		local paxB = 0
		local paxC = 0
		local paxD = 0
		local paxE = 0
	
		pax = math.ceil(pax_weight / (simConfigData["data"].SIM.std_pax_weight * weight_factor))
		if pax > 416 then
			pax = 416
		end

		setFMSData("paxFirstClassA", "")
		setFMSData("paxBusClassB", "")
		setFMSData("paxEconClassC", "")
		setFMSData("paxEconClassD", "")
		setFMSData("paxEconClassE", "")
		setFMSData("freightZoneA", "")
		setFMSData("freightZoneB", "")
		setFMSData("freightZoneC", "")
		setFMSData("freightZoneD", "")
		setFMSData("freightZoneE", "")

		repeat
			if pax > 0 and paxA < 23 then
				paxA = paxA + 1
				pax = pax - 1
			end
			if pax > 0 and paxB < 80 then
				paxB = paxB + 1
				pax = pax - 1
			end
			if pax > 0 and paxC < 77 then
				paxC = paxC + 1
				pax = pax - 1
			end
			if pax > 0 and paxD < 104 then
				paxD = paxD + 1
				pax = pax - 1
			end
			if pax > 0 and paxE < 132 then
				paxE = paxE + 1
				pax = pax - 1
			end
		until (pax == 0)
		
		fmsModules["data"].paxFirstClassA = string.format("%2d", paxA)
		fmsModules["data"].paxBusClassB = string.format("%2d", paxB)
		fmsModules["data"].paxEconClassC = string.format("%2d", paxC)
		fmsModules["data"].paxEconClassD = string.format("%3d", paxD)
		fmsModules["data"].paxEconClassE = string.format("%3d", paxE)

		calc_pax_cargo()
	elseif string.len(fmsO["scratchpad"]) < 1 then
		setFMSData("paxFirstClassA", "0")
		setFMSData("paxBusClassB", "0")
		setFMSData("paxEconClassC", "0")
		setFMSData("paxEconClassD", "0")
		setFMSData("paxEconClassE", "0")
		calc_pax_cargo()
	else
		fmsO["notify"] = "INVALID ENTRY"
	end
  elseif value == "cargoFwd" then
	local weight_factor = 1

	if simConfigData["data"].SIM.weight_display_units == "LBS" then
		weight_factor = simConfigData["data"].SIM.kgs_to_lbs
	else
		weight_factor = 1
	end

	if string.match(fmsO["scratchpad"], "%d") and (string.match(fmsO["scratchpad"], "P") or string.match(fmsO["scratchpad"], "C")) then
		local digits = math.abs(tonumber(string.match(fmsO["scratchpad"], "%d+")))
		local chars = string.match(fmsO["scratchpad"], "%u")
		local weight_per_unit = 0

		if chars == "P" then
			weight_per_unit = 5035 * weight_factor
			if digits > 5 then
				digits = 5
			end
		elseif chars == "C" then
			weight_per_unit = 1588 * weight_factor
			if digits > 16 then
				digits = 16
			end
		end
		
		fmsO["scratchpad"] = string.format("%6d", digits * weight_per_unit)
	end
	if string.match(fmsO["scratchpad"], "%d") and not string.match(fmsO["scratchpad"], "%u") then
		local cwt = 0

		cwt = math.abs(tonumber(fmsO["scratchpad"])) / weight_factor  --store LBS in KGS
		
		if cwt > 26490 then
			cwt = 26490
		end
		
		setFMSData(value, string.format("%6d", cwt))
		calc_pax_cargo()
	else
		fmsO["notify"] = "INVALID ENTRY"
	end
  elseif value == "cargoAft" then
	local weight_factor = 1

	if simConfigData["data"].SIM.weight_display_units == "LBS" then
		weight_factor = simConfigData["data"].SIM.kgs_to_lbs
	else
		weight_factor = 1
	end

	if string.match(fmsO["scratchpad"], "%d") and (string.match(fmsO["scratchpad"], "P") or string.match(fmsO["scratchpad"], "C")) then
		local digits = math.abs(tonumber(string.match(fmsO["scratchpad"], "%d+")))
		local chars = string.match(fmsO["scratchpad"], "%u")
		local weight_per_unit = 0
		
		if chars == "P" then
			weight_per_unit = 5035 * weight_factor
			if digits > 4 then
				digits = 4
			end
		elseif chars == "C" then
			weight_per_unit = 1588 * weight_factor
			if digits > 14 then
				digits = 14
			end
		end
		
		fmsO["scratchpad"] = string.format("%6d", digits * weight_per_unit)
	end
	if string.match(fmsO["scratchpad"], "%d") and not string.match(fmsO["scratchpad"], "%u") then
		local cwt = 0

		cwt = math.abs(tonumber(fmsO["scratchpad"])) / weight_factor  --store LBS in KGS

		if cwt > 22938 then
			cwt = 22938
		end

		setFMSData(value, string.format("%6d", cwt))
		calc_pax_cargo()
	else
		fmsO["notify"] = "INVALID ENTRY"
	end
  elseif value == "cargoBulk" then
	local weight_factor = 1

	if simConfigData["data"].SIM.weight_display_units == "LBS" then
		weight_factor = simConfigData["data"].SIM.kgs_to_lbs
	else
		weight_factor = 1
	end

	if string.match(fmsO["scratchpad"], "%d") and not string.match(fmsO["scratchpad"], "%u") then
		local cwt = 0

		cwt = math.abs(tonumber(fmsO["scratchpad"])) / weight_factor  --store LBS in KGS

		if cwt > 6749 then
			cwt = 6749
		end

		setFMSData(value, string.format("%5d", cwt))
		calc_pax_cargo()
	else
		fmsO["notify"] = "INVALID ENTRY"
	end
--FREIGHT Page
  elseif value == "freightZoneA" then
	local weight_factor = 1

	if simConfigData["data"].SIM.weight_display_units == "LBS" then
		weight_factor = simConfigData["data"].SIM.kgs_to_lbs
	else
		weight_factor = 1
	end

	if string.match(fmsO["scratchpad"], "%d") and not string.match(fmsO["scratchpad"], "%u") and math.abs(tonumber(fmsO["scratchpad"])) <= (11160 * weight_factor) then
		setFMSData(value, math.abs(string.format("%5d", fmsO["scratchpad"])) / weight_factor)
		calc_pax_cargo()
	elseif fmsO["scratchpad"] == "F" then  --Add FULL FREIGHT
		setFMSData("freightZoneA", "11289")
		setFMSData("freightZoneB", "30104")
		setFMSData("freightZoneC", "22578")
		setFMSData("freightZoneD", "45156")
		setFMSData("freightZoneE", "3763")
		setFMSData("paxFirstClassA", "")
		setFMSData("paxBusClassB", "")
		setFMSData("paxEconClassC", "")
		setFMSData("paxEconClassD", "")
		setFMSData("paxEconClassE", "")
		calc_pax_cargo()
	elseif fmsO["scratchpad"] == "C" then  --Clear FREIGHT entries
		setFMSData("freightZoneA", "")
		setFMSData("freightZoneB", "")
		setFMSData("freightZoneC", "")
		setFMSData("freightZoneD", "")
		setFMSData("freightZoneE", "")
		setFMSData("cargoFwd", "")
		setFMSData("cargoAft", "")
		setFMSData("cargoBulk", "")
		setFMSData("paxFirstClassA", "")
		setFMSData("paxBusClassB", "")
		setFMSData("paxEconClassC", "")
		setFMSData("paxEconClassD", "")
		setFMSData("paxEconClassE", "")
		calc_pax_cargo()
	elseif string.len(fmsO["scratchpad"]) < 1 then
		setFMSData(value, "11160")
		calc_pax_cargo()
	elseif string.match(fmsO["scratchpad"], "%d") and not string.match(fmsO["scratchpad"], "%u") and tonumber(fmsO["scratchpad"]) > (11289 * weight_factor) then  --Add FREIGHT by round-robin through all zones
		setFMSData("freightZoneA", "")
		setFMSData("freightZoneB", "")
		setFMSData("freightZoneC", "")
		setFMSData("freightZoneD", "")
		setFMSData("freightZoneE", "")

		local x = tonumber(string.format("%6d", fmsO["scratchpad"] / weight_factor)) --convert to base units of KGS
		local zoneA = 0
		local zoneB = 0
		local zoneC = 0
		local zoneD = 0
		local zoneE = 0
		
		if x > 112890 then  --112,900 KGS is the MAX Revenue Payload.  112,890 KGS is the defined average pallet weight (3763) * 30 pallets
			x = 112890
		end
		repeat
			if x > 0 and zoneA < 11289 then
				zoneA = zoneA + 1
				x = x - 1
			end
			if x > 0 and zoneB < 30104 then
				zoneB = zoneB + 1
				x = x - 1
			end
			if x > 0 and zoneC < 22578 then
				zoneC = zoneC + 1
				x = x - 1
			end
			if x > 0 and zoneD < 45156 then
				zoneD = zoneD + 1
				x = x - 1
			end
			if x > 0 and zoneE < 3763 then
				zoneE = zoneE + 1
				x = x - 1
			end
			--print("X = "..x.." ZoneA = "..zoneA.." ZoneB = "..zoneB.." ZoneC = "..zoneC.." ZoneD = "..zoneD.." ZoneE = "..zoneE)
		until (x == 0)
		
		fmsModules["data"].freightZoneA = string.format("%5d", zoneA)
		fmsModules["data"].freightZoneB = string.format("%5d", zoneB)
		fmsModules["data"].freightZoneC = string.format("%5d", zoneC)
		fmsModules["data"].freightZoneD = string.format("%5d", zoneD)
		fmsModules["data"].freightZoneE = string.format("%4d", zoneE)
		
		fmsO["scratchpad"] = ""
		
		calc_pax_cargo()
	elseif string.match(fmsO["scratchpad"], "%d") and string.match(fmsO["scratchpad"], "P") then
		local digits = math.abs(tonumber(string.match(fmsO["scratchpad"], "%d+")))
		local chars = string.match(fmsO["scratchpad"], "%u")
		local weight_per_unit = 0

		if chars == "P" then
			weight_per_unit = 3763 * weight_factor
			if digits > 3 then
				digits = 3
			end
		end
		
		fmsO["scratchpad"] = string.format("%5d", digits * weight_per_unit)
	else
		fmsO["notify"] = "INVALID ENTRY"
	end
	if string.match(fmsO["scratchpad"], "%d") and not string.match(fmsO["scratchpad"], "%u") then
		local fwt = 0

		fwt = math.abs(tonumber(fmsO["scratchpad"])) / weight_factor  --store LBS in KGS
		
		if fwt > 11289 then
			fwt = 11289
		end
		
		setFMSData(value, string.format("%5d", fwt))
		calc_pax_cargo()
	end
  elseif value == "freightZoneB" then
	local weight_factor = 1

	if simConfigData["data"].SIM.weight_display_units == "LBS" then
		weight_factor = simConfigData["data"].SIM.kgs_to_lbs
	else
		weight_factor = 1
	end

	if string.match(fmsO["scratchpad"], "%d") and string.match(fmsO["scratchpad"], "P") then
		local digits = math.abs(tonumber(string.match(fmsO["scratchpad"], "%d+")))
		local chars = string.match(fmsO["scratchpad"], "%u")
		local weight_per_unit = 0

		if chars == "P" then
			weight_per_unit = 3763 * weight_factor
			if digits > 8 then
				digits = 8
			end
		end
		
		fmsO["scratchpad"] = string.format("%5d", digits * weight_per_unit)
	end
	if string.match(fmsO["scratchpad"], "%d") and not string.match(fmsO["scratchpad"], "%u") then
		local fwt = 0

		fwt = math.abs(tonumber(fmsO["scratchpad"])) / weight_factor  --store LBS in KGS
		
		if fwt > 30104 then
			fwt = 30104
		end
		
		setFMSData(value, string.format("%5d", fwt))
		calc_pax_cargo()
	else
		fmsO["notify"] = "INVALID ENTRY"
	end
  elseif value == "freightZoneC" then
	local weight_factor = 1

	if simConfigData["data"].SIM.weight_display_units == "LBS" then
		weight_factor = simConfigData["data"].SIM.kgs_to_lbs
	else
		weight_factor = 1
	end

	if string.match(fmsO["scratchpad"], "%d") and string.match(fmsO["scratchpad"], "P") then
		local digits = math.abs(tonumber(string.match(fmsO["scratchpad"], "%d+")))
		local chars = string.match(fmsO["scratchpad"], "%u")
		local weight_per_unit = 0

		if chars == "P" then
			weight_per_unit = 3763 * weight_factor
			if digits > 6 then
				digits = 6
			end
		end
		
		fmsO["scratchpad"] = string.format("%5d", digits * weight_per_unit)
	end
	if string.match(fmsO["scratchpad"], "%d") and not string.match(fmsO["scratchpad"], "%u") then
		local fwt = 0

		fwt = math.abs(tonumber(fmsO["scratchpad"])) / weight_factor  --store LBS in KGS
		
		if fwt > 22578 then
			fwt = 22578
		end
		
		setFMSData(value, string.format("%5d", fwt))
		calc_pax_cargo()
	else
		fmsO["notify"] = "INVALID ENTRY"
	end
  elseif value == "freightZoneD" then
	local weight_factor = 1

	if simConfigData["data"].SIM.weight_display_units == "LBS" then
		weight_factor = simConfigData["data"].SIM.kgs_to_lbs
	else
		weight_factor = 1
	end

	if string.match(fmsO["scratchpad"], "%d") and string.match(fmsO["scratchpad"], "P") then
		local digits = math.abs(tonumber(string.match(fmsO["scratchpad"], "%d+")))
		local chars = string.match(fmsO["scratchpad"], "%u")
		local weight_per_unit = 0

		if chars == "P" then
			weight_per_unit = 3763 * weight_factor
			if digits > 12 then
				digits = 12
			end
		end
		
		fmsO["scratchpad"] = string.format("%6d", digits * weight_per_unit)
	end
	if string.match(fmsO["scratchpad"], "%d") and not string.match(fmsO["scratchpad"], "%u") then
		local fwt = 0

		fwt = math.abs(tonumber(fmsO["scratchpad"])) / weight_factor  --store LBS in KGS
		
		if fwt > 45156 then
			fwt = 45156
		end
		
		setFMSData(value, string.format("%6d", fwt))
		calc_pax_cargo()
	else
		fmsO["notify"] = "INVALID ENTRY"
	end
  elseif value == "freightZoneE" then
	local weight_factor = 1

	if simConfigData["data"].SIM.weight_display_units == "LBS" then
		weight_factor = simConfigData["data"].SIM.kgs_to_lbs
	else
		weight_factor = 1
	end

	if string.match(fmsO["scratchpad"], "%d") and string.match(fmsO["scratchpad"], "P") then
		local digits = math.abs(tonumber(string.match(fmsO["scratchpad"], "%d+")))
		local chars = string.match(fmsO["scratchpad"], "%u")
		local weight_per_unit = 0

		if chars == "P" then
			weight_per_unit = 3763 * weight_factor
			if digits > 1 then
				digits = 1
			end
		end
		
		fmsO["scratchpad"] = string.format("%4d", digits * weight_per_unit)
	end
	if string.match(fmsO["scratchpad"], "%d") and not string.match(fmsO["scratchpad"], "%u") then
		local fwt = 0

		fwt = math.abs(tonumber(fmsO["scratchpad"])) / weight_factor  --store LBS in KGS
		
		if fwt > 3763 then
			fwt = 3763
		end
		
		setFMSData(value, string.format("%4d", fwt))
		calc_pax_cargo()
	else
		fmsO["notify"] = "INVALID ENTRY"
	end
   elseif value == "freightPayload" then
	if string.match(fmsO["scratchpad"], "%d") then --and not string.match(fmsO["scratchpad"], "%u") then
		local weight_factor = 1

		if simConfigData["data"].SIM.weight_display_units == "LBS" then
			weight_factor = simConfigData["data"].SIM.kgs_to_lbs
		else
			weight_factor = 1
		end

		setFMSData("paxFirstClassA", "")
		setFMSData("paxBusClassB", "")
		setFMSData("paxEconClassC", "")
		setFMSData("paxEconClassD", "")
		setFMSData("paxEconClassE", "")
		setFMSData("freightZoneA", "")
		setFMSData("freightZoneB", "")
		setFMSData("freightZoneC", "")
		setFMSData("freightZoneD", "")
		setFMSData("freightZoneE", "")

		local x = math.abs(tonumber(fmsO["scratchpad"]) / weight_factor) * 1000  --convert to base units of KGS
		local zoneA = 0
		local zoneB = 0
		local zoneC = 0
		local zoneD = 0
		local zoneE = 0
		
		if x > 112890 then  --112,900 KGS is the MAX Revenue Payload.  112,890 KGS is the defined average pallet weight (3763) * 30 pallets
			x = 112890
		end
		
		repeat
			if x > 0 and zoneA < 11289 then
				zoneA = zoneA + 1
				x = x - 1
			end
			if x > 0 and zoneB < 30104 then
				zoneB = zoneB + 1
				x = x - 1
			end
			if x > 0 and zoneC < 22578 then
				zoneC = zoneC + 1
				x = x - 1
			end
			if x > 0 and zoneD < 45156 then
				zoneD = zoneD + 1
				x = x - 1
			end
			if x > 0 and zoneE < 3763 then
				zoneE = zoneE + 1
				x = x - 1
			end
			--print("X = "..x.." ZoneA = "..zoneA.." ZoneB = "..zoneB.." ZoneC = "..zoneC.." ZoneD = "..zoneD.." ZoneE = "..zoneE)
		until (x <= 0)
		
		fmsModules["data"].freightZoneA = string.format("%5d", zoneA)
		fmsModules["data"].freightZoneB = string.format("%5d", zoneB)
		fmsModules["data"].freightZoneC = string.format("%5d", zoneC)
		fmsModules["data"].freightZoneD = string.format("%5d", zoneD)
		fmsModules["data"].freightZoneE = string.format("%4d", zoneE)
		
		fmsO["scratchpad"] = ""
		
		calc_pax_cargo()
	else
		fmsO["notify"] = "INVALID ENTRY"
	end
--Marauder28
--SimConfig Page
   elseif value=="weightUnits" then
	if string.len(fmsO["scratchpad"])>0 and validate_weight_units(fmsO["scratchpad"]) == false then 
      fmsO["notify"]="INVALID ENTRY"
	elseif is_timer_scheduled(preselect_fuel) == true then
	  fmsO["notify"]="NA - WAITING FOR FUEL TRUCK"
	elseif string.len(fmsO["scratchpad"]) > 0 then
		simConfigData["data"].SIM.weight_display_units = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
    else
		if simConfigData["data"].SIM.weight_display_units == "KGS" then
			fmsO["scratchpad"] = "LBS"
		else
			fmsO["scratchpad"] = "KGS"
		end
		simConfigData["data"].SIM.weight_display_units = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
	end
  elseif value == "irsAlignTime" then
	if not string.match(fmsO["scratchpad"], "%d") or string.len(fmsO["scratchpad"]) > 2 then
		fmsO["notify"] = "INVALID ENTRY"
	else
		--setFMSData(value, tonumber(fmsO["scratchpad"]) * 60)
		simConfigData["data"].SIM.irs_align_time = tonumber(fmsO["scratchpad"]) * 60
		pushSimConfig(simConfigData["data"]["values"])
		--print("FMC IRS = "..fmsO["scratchpad"] * 60)
	end
   elseif value=="autoFuelMgmt" then
	if string.len(fmsO["scratchpad"])>0 and not (fmsO["scratchpad"] == "YES" or fmsO["scratchpad"] == "NO") then 
      fmsO["notify"]="INVALID ENTRY"
	elseif string.len(fmsO["scratchpad"]) > 0 then
		simConfigData["data"].SIM.auto_fuel_mgmt = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
    else
		if simConfigData["data"].SIM.auto_fuel_mgmt == "NO" then
			fmsO["scratchpad"] = "YES"
		else
			fmsO["scratchpad"] = "NO"
		end
		simConfigData["data"].SIM.auto_fuel_mgmt = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
	end
   elseif value=="baroIndicator" then
	if string.len(fmsO["scratchpad"])>0 and not (fmsO["scratchpad"] == "IN" or fmsO["scratchpad"] == "HPA") then
      fmsO["notify"]="INVALID ENTRY"
	elseif string.len(fmsO["scratchpad"]) > 0 then
		simConfigData["data"].SIM.baro_indicator = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
    else
		if simConfigData["data"].SIM.baro_indicator == "IN" then
			fmsO["scratchpad"] = "HPA"
		else
			fmsO["scratchpad"] = "IN"
		end
		simConfigData["data"].SIM.baro_indicator = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
	end
   elseif value=="baroSync" then
	if string.len(fmsO["scratchpad"])>0 and not (fmsO["scratchpad"] == "YES" or fmsO["scratchpad"] == "NO") then
      fmsO["notify"]="INVALID ENTRY"
	elseif string.len(fmsO["scratchpad"]) > 0 then
		simConfigData["data"].SIM.baro_sync = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
    else
		if simConfigData["data"].SIM.baro_sync == "NO" then
			fmsO["scratchpad"] = "YES"
		else
			fmsO["scratchpad"] = "NO"
		end
		simConfigData["data"].SIM.baro_sync = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
	end
  elseif value == "stdPaxWeight" then
	local weight_factor = 1

	if simConfigData["data"].SIM.weight_display_units == "LBS" then
		weight_factor = simConfigData["data"].SIM.kgs_to_lbs
	else
		weight_factor = 1
	end

	if string.match(fmsO["scratchpad"], "%d") and not string.match(fmsO["scratchpad"], "%u") and tonumber(fmsO["scratchpad"]) < 500.0 then
		local pax_weight = 0

		pax_weight = string.format("%5.1f", math.abs(tonumber(fmsO["scratchpad"]) / weight_factor))  --store weight in KGS

		simConfigData["data"].SIM.std_pax_weight = pax_weight
		pushSimConfig(simConfigData["data"]["values"])		
	else
		fmsO["notify"] = "INVALID ENTRY"
	end
   elseif value=="captInbd" then
	if string.len(fmsO["scratchpad"])>0 and not (fmsO["scratchpad"] == "EICAS" or fmsO["scratchpad"] == "NORM" or fmsO["scratchpad"] == "PFD") then
      fmsO["notify"]="INVALID ENTRY"
	elseif string.len(fmsO["scratchpad"]) > 0 then
		simConfigData["data"].SIM.capt_inbd = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
    else
		if simConfigData["data"].SIM.capt_inbd == "EICAS" then
			fmsO["scratchpad"] = "NORM"
		elseif simConfigData["data"].SIM.capt_inbd == "NORM" then
			fmsO["scratchpad"] = "PFD"
		else
			fmsO["scratchpad"] = "EICAS"
		end
		simConfigData["data"].SIM.capt_inbd = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
	end
   elseif value=="captLwr" then
	if string.len(fmsO["scratchpad"])>0 and not (fmsO["scratchpad"] == "EICAS PRI" or fmsO["scratchpad"] == "NORM" or fmsO["scratchpad"] == "ND") then
      fmsO["notify"]="INVALID ENTRY"
	elseif string.len(fmsO["scratchpad"]) > 0 then
		simConfigData["data"].SIM.capt_inbd = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
    else
		if simConfigData["data"].SIM.capt_lwr == "EICAS PRI" then
			fmsO["scratchpad"] = "NORM"
		elseif simConfigData["data"].SIM.capt_lwr == "NORM" then
			fmsO["scratchpad"] = "ND"
		else
			fmsO["scratchpad"] = "EICAS PRI"
		end
		simConfigData["data"].SIM.capt_lwr = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
	end
   elseif value=="foInbd" then
	if string.len(fmsO["scratchpad"])>0 and not (fmsO["scratchpad"] == "PFD" or fmsO["scratchpad"] == "NORM" or fmsO["scratchpad"] == "EICAS") then
      fmsO["notify"]="INVALID ENTRY"
	elseif string.len(fmsO["scratchpad"]) > 0 then
		simConfigData["data"].SIM.fo_inbd = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
    else
		if simConfigData["data"].SIM.fo_inbd == "PFD" then
			fmsO["scratchpad"] = "NORM"
		elseif simConfigData["data"].SIM.fo_inbd == "NORM" then
			fmsO["scratchpad"] = "EICAS"
		else
			fmsO["scratchpad"] = "PFD"
		end
		simConfigData["data"].SIM.fo_inbd = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
	end
   elseif value=="foLwr" then
	if string.len(fmsO["scratchpad"])>0 and not (fmsO["scratchpad"] == "ND" or fmsO["scratchpad"] == "NORM" or fmsO["scratchpad"] == "EICAS PRI") then
      fmsO["notify"]="INVALID ENTRY"
	elseif string.len(fmsO["scratchpad"]) > 0 then
		simConfigData["data"].SIM.fo_inbd = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
    else
		if simConfigData["data"].SIM.fo_lwr == "ND" then
			fmsO["scratchpad"] = "NORM"
		elseif simConfigData["data"].SIM.fo_lwr == "NORM" then
			fmsO["scratchpad"] = "EICAS PRI"
		else
			fmsO["scratchpad"] = "ND"
		end
		simConfigData["data"].SIM.fo_lwr = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
	end
--Plane Config Page
	elseif value=="model" then
		simConfigData["data"].PLANE.model = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
   elseif value=="aircraftType" then
	if string.len(fmsO["scratchpad"])>0 and not (fmsO["scratchpad"] == "PASSENGER" or fmsO["scratchpad"] == "FREIGHTER") then
      fmsO["notify"]="INVALID ENTRY"
	elseif string.len(fmsO["scratchpad"]) > 0 then
		simConfigData["data"].PLANE.aircraft_type = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
    else
		if simConfigData["data"].PLANE.aircraft_type == "PASSENGER" then
			fmsO["scratchpad"] = "FREIGHTER"
		else
			fmsO["scratchpad"] = "PASSENGER"
		end
		simConfigData["data"].PLANE.aircraft_type = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
	end
   elseif value=="engines" then
	if string.len(fmsO["scratchpad"])>0 and not (fmsO["scratchpad"] == "CF6-80C2-B1F" or fmsO["scratchpad"] == "CF6-80C2-B5F" or fmsO["scratchpad"] == "CF6-80C2-B1F1"
		or fmsO["scratchpad"] == "PW4056" or fmsO["scratchpad"] == "PW4060" or fmsO["scratchpad"] == "PW4062"
		or fmsO["scratchpad"] == "RB211-524G" or fmsO["scratchpad"] == "RB211-524H") then
      fmsO["notify"]="INVALID ENTRY"
	elseif string.len(fmsO["scratchpad"]) > 0 then
		simConfigData["data"].PLANE.engines = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
    else
		if simConfigData["data"].PLANE.engines == "CF6-80C2-B1F" then
			fmsO["scratchpad"] = "CF6-80C2-B5F"
			simConfigData["data"].PLANE.thrust_ref = "N1"
		elseif simConfigData["data"].PLANE.engines == "CF6-80C2-B5F" then
			fmsO["scratchpad"] = "CF6-80C2-B1F1"
			simConfigData["data"].PLANE.thrust_ref = "N1"
		elseif simConfigData["data"].PLANE.engines == "CF6-80C2-B1F1" then
			fmsO["scratchpad"] = "PW4056"
			simConfigData["data"].PLANE.thrust_ref = "EPR"
		elseif simConfigData["data"].PLANE.engines == "PW4056" then
			fmsO["scratchpad"] = "PW4060"
			simConfigData["data"].PLANE.thrust_ref = "EPR"
		elseif simConfigData["data"].PLANE.engines == "PW4060" then
			fmsO["scratchpad"] = "PW4062"
			simConfigData["data"].PLANE.thrust_ref = "EPR"
		elseif simConfigData["data"].PLANE.engines == "PW4062" then
			fmsO["scratchpad"] = "RB211-524G"
			simConfigData["data"].PLANE.thrust_ref = "EPR"
		elseif simConfigData["data"].PLANE.engines == "RB211-524G" then
			fmsO["scratchpad"] = "RB211-524H"
			simConfigData["data"].PLANE.thrust_ref = "EPR"
		elseif simConfigData["data"].PLANE.engines == "RB211-524H" then
			fmsO["scratchpad"] = "RB211-524H8T"
			simConfigData["data"].PLANE.thrust_ref = "EPR"
		else
			fmsO["scratchpad"] = "CF6-80C2-B1F"
			simConfigData["data"].PLANE.thrust_ref = "N1"
		end
		simConfigData["data"].PLANE.engines = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
	end
   --Removed to allow engine code above to forcibly set the thrust_ref mode (i.e. don't let users select and mess things up)
--[[   elseif value=="thrustRef" then
	if string.len(fmsO["scratchpad"])>0 and not (fmsO["scratchpad"] == "EPR" or fmsO["scratchpad"] == "N1") then
      fmsO["notify"]="INVALID ENTRY"
	elseif string.len(fmsO["scratchpad"]) > 0 then
		simConfigData["data"].PLANE.thrust_ref = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
    else
		if simConfigData["data"].PLANE.thrust_ref == "EPR" then
			fmsO["scratchpad"] = "N1"
		else
			fmsO["scratchpad"] = "EPR"
		end
		simConfigData["data"].PLANE.thrust_ref = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
	end]]
   elseif value=="airline" then
		simConfigData["data"].PLANE.airline = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
   elseif value=="civilRegistration" then
		simConfigData["data"].PLANE.civil_registration = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
   elseif value=="finNbr" then
		simConfigData["data"].PLANE.fin_nbr = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
   elseif value=="pfdStyle" then
	if string.len(fmsO["scratchpad"])>0 and not (fmsO["scratchpad"] == "CRT" or fmsO["scratchpad"] == "LCD") then
      fmsO["notify"]="INVALID ENTRY"
	elseif string.len(fmsO["scratchpad"]) > 0 then
		simConfigData["data"].PLANE.pfd_style = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
    else
		if simConfigData["data"].PLANE.pfd_style == "CRT" then
			fmsO["scratchpad"] = "LCD"
		else
			fmsO["scratchpad"] = "CRT"
		end
		simConfigData["data"].PLANE.pfd_style = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
	end
   elseif value=="ndStyle" then
	if string.len(fmsO["scratchpad"])>0 and not (fmsO["scratchpad"] == "LCD" or fmsO["scratchpad"] == "CRT") then
      fmsO["notify"]="INVALID ENTRY"
	elseif string.len(fmsO["scratchpad"]) > 0 then
		simConfigData["data"].PLANE.nd_style = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
    else
		if simConfigData["data"].PLANE.nd_style == "CRT" then
			fmsO["scratchpad"] = "LCD"
		else
			fmsO["scratchpad"] = "CRT"
		end
		simConfigData["data"].PLANE.nd_style = fmsO.scratchpad
		pushSimConfig(simConfigData["data"]["values"])
	end
--Marauder28
   elseif value=="atc" then
		setFMSData(value,fmsO["scratchpad"])
		
		fmsFunctions["acarsLogonATC"](fmsO,"Logon " .. fmsO["scratchpad"])
	elseif value=="fltdepatc" then
		setFMSData("atc",fmsModules.data["fltdep"])
		
		fmsFunctions["acarsLogonATC"](fmsO,"Logon " .. fmsModules.data["fltdep"])
	elseif value=="fltdstatc" then
		setFMSData("atc",fmsModules.data["fltdst"])
		
		fmsFunctions["acarsLogonATC"](fmsO,"Logon " .. fmsModules.data["fltdst"])	
	elseif value=="metarreq" then	
		fmsFunctions["acarsATCRequest"](fmsO,"REQUEST METAR")	
	elseif value=="tafreq" then	
		fmsFunctions["acarsATCRequest"](fmsO,"REQUEST TAF")	
   elseif fmsO["scratchpad"]=="" and del==false then
      cVal=getFMSData(value)
    
      fmsO["scratchpad"]=cVal
    return 
  else
    setFMSData(value,fmsO["scratchpad"])
  end
  fmsO["scratchpad"]=""
end

function fmsFunctions.setDref(fmsO,value)
	local val=tonumber(fmsO["scratchpad"])
	print(fmsO.id)

	-----STRATOSPHERE 777----------

	if value == "dspCtrl" then
		if fmsO.id == "fmsL" then
			if B777DR_cdu_eicas_ctl[1] == 0 and B777DR_cdu_eicas_ctl[2] == 0 then
				B777DR_cdu_eicas_ctl[0] = 1 - B777DR_cdu_eicas_ctl[0]
			else
				fmsModules["fmsL"].notify="KEY/FUNCTION INOP"
			end
		elseif fmsO.id == "fmsC" then
			if B777DR_cdu_eicas_ctl[0] == 0 and B777DR_cdu_eicas_ctl[2] == 0 then
				B777DR_cdu_eicas_ctl[1] = 1 - B777DR_cdu_eicas_ctl[1]
			else
				fmsModules["fmsC"].notify="KEY/FUNCTION INOP"
			end
		else
			if B777DR_cdu_eicas_ctl[0] == 0 and B777DR_cdu_eicas_ctl[1] == 0 then
				B777DR_cdu_eicas_ctl[2] = 1 - B777DR_cdu_eicas_ctl[2]
			else
				fmsModules["fmsR"].notify="KEY/FUNCTION INOP"
			end
		end
		return
	end

	if value == "efisCtrl" then
		if fmsO.id == "fmsL" then
			B777DR_cdu_efis_ctl[0] = 1 - B777DR_cdu_efis_ctl[0]
		elseif fmsO.id == "fmsR" then
			B777DR_cdu_efis_ctl[1] = 1 - B777DR_cdu_efis_ctl[1]
		else
			fmsModules["fmsC"].notify="KEY/FUNCTION INOP"
		end
		return
	end


	----- SPARKY 744 ----------

  if value=="VNAVS1" and B777DR_ap_vnav_system ~=1.0 then B777DR_ap_vnav_system=1 return elseif value=="VNAVS1" then B777DR_ap_vnav_system=0 return end 
  if value=="VNAVS2" and B777DR_ap_vnav_system ~=2.0 then B777DR_ap_vnav_system=2 return elseif value=="VNAVS2" then B777DR_ap_vnav_system=0 return end 
  if value=="VNAVSPAUSE" then 
	if B777DR_ap_vnav_pause>0 then 
		B777DR_ap_vnav_pause=0
	else
		B777DR_ap_vnav_pause=1 
	end 
	return 
	end 
  if value=="CHOCKS" then
	B777DR__gear_chocked = 1 - B777DR__gear_chocked
	--Stop refueling operation if CHOCKS are removed
	if B777DR__gear_chocked == 0 then
		B777DR_refuel=0.0
	end
	return
  end
  if value=="PAUSEVAL" then
	local numVal=tonumber(fmsO["scratchpad"])
	fmsO["scratchpad"]="" 
	if numVal==nil then fmsO["notify"]="INVALID ENTRY" return end
	if numVal>999 then numVal=999 end
	if numVal<=1 then numVal=1 end
	B777DR_ap_vnav_pause=numVal
	return 
  end


 	
  if value=="TO" then toderate=0 clbderate=0 return  end
  if value=="TO1" then toderate=1 clbderate=1 return  end
  if value=="TO2" then toderate=2 clbderate=2 return  end
  if value=="CLB" then clbderate=0 return  end
  if value=="CLB1" then clbderate=1 return  end
  if value=="CLB2" then clbderate=2  return end
  if value=="ILS" then 
    if findILS(fmsO["scratchpad"])==false then fmsO["notify"]="INVALID ENTRY" end
    fmsO["scratchpad"]="" 
    return 
  end
  local modes=B777DR_radioModes
  if value=="VORL" and val==nil then B777DR_radioModes=replace_char(2,modes,"A") fmsO["scratchpad"]="" return end
  if value=="VORR" and val==nil then B777DR_radioModes=replace_char(3,modes,"A") fmsO["scratchpad"]="" return end
   if val==nil or (value=="CRSL" and modes:sub(2, 2)=="A") or (value=="CRSR" and modes:sub(3, 3)=="A") then
     fmsO["notify"]="INVALID ENTRY"
     return 
   end
 --print(val)
  if value=="VORL" then B777DR_radioModes=replace_char(2,modes,"M") simDR_radio_nav_freq_hz[2]=val*100  end
  if value=="VORR" then B777DR_radioModes=replace_char(3,modes,"M") simDR_radio_nav_freq_hz[3]=val*100  end
  if value=="CRSL" then simDR_radio_nav_obs_deg[2]=val end
  if value=="CRSR" then simDR_radio_nav_obs_deg[3]=val end
  if value=="ADFL" then simDR_radio_adf1_freq_hz=val end
  if value=="ADFR" then simDR_radio_adf2_freq_hz=val end
  if value=="V1" then
	if val<100 or val>200 then
		fmsO["notify"]="INVALID ENTRY"
     	return 
	end
	B777DR_airspeed_V1=val 
  end
  if value=="VR" then
	if val<100 or val>200 then
		fmsOsetsound["notify"]="INVALID ENTRY"
     	return 
	end
	
	B777DR_airspeed_Vr=val 
  end
  if value=="V2" then
	if val<100 or val>200 then
		fmsO["notify"]="INVALID ENTRY"
     	return 
	end
	B777DR_airspeed_V2=val 
  end
  if value=="flapsRef" then 
	if val~=10 and val~=20 then
		fmsO["notify"]="INVALID ENTRY"
     	return 
	end
	B777DR_airspeed_flapsRef=val 
  end

  fmsO["scratchpad"]=""
end

function fmsFunctions.showmessage(fmsO,value)
  acarsSystem.currentMessage=value
  fmsO["inCustomFMC"]=true
  fmsO["targetPage"]="VIEWACARSMSG"
  run_after_time(switchCustomMode, 0.5)
end

function fmsFunctions.doCMD(fmsO,value)
  --[[if fmsModules["cmds"][value] ~= nil then
	fmsModules["cmds"][value]:once()
	fmsModules["lastcmd"]=fmsModules["cmdstrings"][value]
  end]]
	find_command(value):once()
	print("do fmc command "..value)
end

function fmsFunctions.setDrefNum(fmsO, value)
    local valuesplit = split(value,"_")
	local dref = find_dataref(valuesplit[1])
	if #valuesplit == 3 then
		dref = valuesplit[2]
	else
		dref = tonumber(valuesplit[2])
	end
end

function fmsFunctions.toggleDref(fmsO, value)
	local dref = find_dataref(value)
	dref = 1 - dref
end

function setEicasPage(id)
	print(id)
	if B777DR_eicas_mode == id then
		B777DR_eicas_mode = 0
	else
		B777DR_eicas_mode = id
	end
end

function fmsFunctions.setDisp(fmsO, value)

	if value == "eicasEng" then
		setEicasPage(4)
		return
	end
	if value == "eicasStat" then
		setEicasPage(9)
		return
	end
	if value == "eicasChkl" then
		setEicasPage(10)
		return
	end
	if value == "eicasDoor" then
		setEicasPage(2)
		return
	end
	if value == "eicasGear" then
		setEicasPage(7)
		return
	end
	if value == "eicasElec" then
		setEicasPage(3)
		return
	end
	if value == "eicasHyd" then
		setEicasPage(8)
		return
	end
	if value == "eicasFuel" then
		setEicasPage(6)
		return
	end
	if value == "eicasAir" then
		setEicasPage(1)
		return
	end
	if value == "eicasFctl" then
		setEicasPage(5)
		return
	end
	if value == "eicasEng" then
		setEicasPage(4)
		return
	end

	if value=="adfvor" then
		if fmsO.id=="fmsL" then
			if vor_adf[1] == 0 then
				vor_adf[1] = 2
			elseif vor_adf[1] == 2 then
				vor_adf[1] = 1
			else
				vor_adf[1] = 0
			end
		else
			if vor_adf[2] == 0 then
				vor_adf[2] = 2
			elseif vor_adf[2] == 2 then
				vor_adf[2] = 1
			else
				vor_adf[2] = 0
			end
		end
		return
	end

	if fmsO.id == "fmsL" then
		if value == "wxr" then
			find_command("sim/instruments/EFIS_wxr"):once()
		elseif value == "fix" then
			find_command("sim/instruments/EFIS_fix"):once()
		elseif value == "apt" then
			find_command("sim/instruments/EFIS_apt"):once()
		elseif value == "terr" then
			find_command("sim/instruments/EFIS_terr"):once()
		elseif value == "tcas" then
			find_command("sim/instruments/EFIS_tcas"):once()
		elseif value == "minsRst" then
			find_command("Strato/777/minimums_rst_capt_fmc"):once()
		elseif value == "sta" then
			B777DR_nd_sta[0] = 1 - B777DR_nd_sta[0]
		elseif value == "zoomOut" then
			find_command("sim/instruments/map_zoom_out"):once()
		elseif value == "zoomIn" then
			find_command("sim/instruments/map_zoom_in"):once()
		elseif value == "mtrs" then
			B777DR_pfd_mtrs[0] = 1 - B777DR_pfd_mtrs[0]
		elseif value == "mapMode_0" then
			simDR_nd_mode[1] = 0
		elseif value == "mapMode_1" then
			simDR_nd_mode[1] = 1
		elseif value == "mapMode_2" then
			simDR_nd_mode[1] = 3
		elseif value == "mapMode_3" then
			simDR_nd_mode[1] = 4
		elseif value == "mapMode_4" then
			simDR_map_hsi[1] = 1 - simDR_map_hsi[1]
		elseif value == "radBaro" then
			B777DR_minimums_mode[0] = 1 - B777DR_minimums_mode[0]
		end
		return
	else
		if value == "wxr" then
			find_command("sim/instruments/EFIS_copilot_wxr"):once()
		elseif value == "fix" then
			find_command("sim/instruments/EFIS_copilot_fix"):once()
		elseif value == "apt" then
			find_command("sim/instruments/EFIS_copilot_apt"):once()
		elseif value == "terr" then
			find_command("sim/instruments/EFIS_copilot_terr"):once()
		elseif value == "tcas" then
			find_command("sim/instruments/EFIS_copilot_tcas"):once()
		elseif value == "minsRst" then
			find_command("Strato/777/minimums_rst_fo_fmc"):once()
		elseif value == "sta" then
			B777DR_nd_sta[1] = 1 - B777DR_nd_sta[1]
		elseif value == "zoomOut" then
			find_command("sim/instruments/map_copilot_zoom_out"):once()
		elseif value == "zoomIn" then
			find_command("sim/instruments/map_copilot_zoom_in"):once()
		elseif value == "mtrs" then
			B777DR_pfd_mtrs[1] = 1 - B777DR_pfd_mtrs[1]
		elseif value == "mapMode_0" then
			simDR_nd_mode[2] = 0
		elseif value == "mapMode_1" then
			simDR_nd_mode[2] = 1
		elseif value == "mapMode_2" then
			simDR_nd_mode[2] = 3
		elseif value == "mapMode_3" then
			simDR_nd_mode[2] = 4
		elseif value == "mapMode_4" then
			simDR_map_hsi[2] = 1 - simDR_map_hsi[2]
		elseif value == "radBaro" then
			B777DR_minimums_mode[1] = 1 - B777DR_minimums_mode[1]
		end
		return
	end
end
--[[function fmsFunctions.setpage2(fmsO, value)
	if value == "FMC" then
		if fmsO.id == "fmsL" then
			if B777DR_cdu_act[0] == 0 then
				B777DR_cdu_act[0] = 1
				fmsFunctions["setpage"](fmsO,"IDENT")
			else
				if not string.match(fmsModules["fmsL"]["prevPage"], "EIswS") and
				not string.match(fmsModules["fmsL"]["prevPage"], "EFIS")
				and fmsModules["fmsL"]["prevPage"] ~= "README" then

					fmsFunctions["setpage"](fmsO,fmsModules["fmsL"]["prevPage"])

				end
			end
		elseif fmsO.id == "fmsR" then
			if B777DR_cdu_act[1] == 0 then
				B777DR_cdu_act[1] = 1
				fmsFunctions["setpage"](fmsO,"IDENT")
			else
				if not string.match(fmsModules["fmsR"]["prevPage"], "EICAS") and
				not string.match(fmsModules["fmsR"]["prevPage"], "EFIS")
				and fmsModules["fmsR"]["prevPage"] ~= "README" then

					fmsFunctions["setpage"](fmsO,fmsModules["fmsR"]["prevPage"])

				end
			end
]]
function fmcPageButton(fmsO)
	local idNum = fmsO.id == "fmsL" and 0 or 1
	if B777DR_cdu_act[idNum] == 0 then

		B777DR_cdu_act[idNum] = 1
		fmsFunctions["setpage"](fmsO,"IDENT")

	else
		if not string.match(fmsModules[fmsO.id]["prevPage"], "EICAS")
		and not string.match(fmsModules[fmsO.id]["prevPage"], "EFIS")
		and fmsModules[fmsO.id]["prevPage"] ~= "README" then

			fmsFunctions["setpage"](fmsO,fmsModules[fmsO.id]["prevPage"])

		end
	end
end

function fmsFunctions.setpage2(fmsO, value)
	if value == "FMC" then
		if fmsO.id ~= "fmsC" then
			--fmcPageButton(fmsO);
		else
			fmsModules["fmsC"].notify="KEY/FUNCTION INOP"
		end
		return
	end

	if value == "EICASMODES" then
		if fmsO.id == "fmsL" then
			if B777DR_cdu_eicas_ctl[0] == 1 then
				fmsFunctions["setpage"](fmsO,value)
			else
				fmsModules[fmsO.id].notify="KEY/FUNCTION INOP"
			end
		elseif fmdO.id == "fmsC" then
			if B777DR_cdu_eicas_ctl[1] == 1 then
				fmsFunctions["setpage"](fmsO,value)
			else
				fmsModules[fmsO.id].notify="KEY/FUNCTION INOP"
			end
		else
			if B777DR_cdu_eicas_ctl[2] == 1 then
				fmsFunctions["setpage"](fmsO,value)
			else
				fmsModules[fmsO.id].notify="KEY/FUNCTION INOP"
			end
		end
		return
	end

	if value == "EFISOPTIONS152" then
		if fmsO.id == "fmsL" then
			if B777DR_cdu_efis_ctl[0] == 1 then
				fmsFunctions["setpage"](fmsO,value)
			else
				fmsModules[fmsO.id].notify="KEY/FUNCTION INOP"
			end
		elseif fmsO.id == "fmsR" then
			if B777DR_cdu_efis_ctl[1] == 1 then
				fmsFunctions["setpage"](fmsO,value)
			else
				fmsModules[fmsO.id].notify="KEY/FUNCTION INOP"
			end
		else
			fmsModules[fmsO.id].notify="KEY/FUNCTION INOP"
		end
		return
	end

	if value == "MENU" then
		if simConfigData["data"].FMC.unlocked == 1 then
			fmsFunctions["setpage"](fmsO,"INDEX")
		else
			fmsModules[fmsO.id].notify="CDU LOCKED"
		end
	end
end

function lim(val, upper, lower)
	if val > upper then
		return upper
	elseif val < lower then
		return lower
	end
	return val
end

function tableLen(T) --Returns length of a table
	local idx = 0
	for i in pairs(T) do idx = idx + 1 end
	return idx
end

function bool2num(value)
	return value and 1 or 0
end

function round(number) --rounds everything behind the decimal
	return math.floor(number + 0.5)
end

function indexOf(array, value) --returns index of a value in an array.
    for k, v in ipairs(array) do
        if v == value then
            return k
        end
    end
    return nil
end

function animate(target, variable, speed)
	if math.abs(target - variable) < 0.1 then return target end
	variable = variable + ((target - variable) * (speed * SIM_PERIOD))
	return variable
end

function ternary(condition, ifTrue, ifFalse)
	if condition then return ifTrue else return ifFalse end
end

--[[B777DR_print_input = find_dataref("Strato/777/print_input");
B777CMD_print = find_command("Strato/777/fmc_print");

function print(input)
	B777DR_print_input = input
	B777CMD_print:once()
end

B777DR_metar_input = find_dataref("Strato/777/metar_input")
B777DR_metar_output = find_dataref("Strato/777/metar_output")
B777CMD_getMetar = find_command("Strato/777/get_metar")

function fetchMetar(icao)
	B777DR_metar_input = icao
	getMetar:once()
	return B777DR_metar_output
end]]