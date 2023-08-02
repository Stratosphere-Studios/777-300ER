fmsPages["NAVRAD"]=createPage("NAVRAD")

local ils_line1 = ""
local ils_line2 = ""
local park = "PARK"
local original_distance = -1

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

fmsPages["NAVRAD"].getNumPages=function(self)
	return 1
end