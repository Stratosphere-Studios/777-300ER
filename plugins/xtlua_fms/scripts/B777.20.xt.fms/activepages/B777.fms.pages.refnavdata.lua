B777DR_backend_inIcao = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/input_icao"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/input_icao")}-- 5 characters
B777DR_backend_outIcao = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/out_icao"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/out_icao")}
B777DR_backend_page = {find_dataref("Strato/777/FMC/FMC_L/page"), find_dataref("Strato/777/FMC/FMC_R/page")}

B777DR_backend_poi_type = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/poi_type"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/poi_type")}
B777DR_backend_poi_lat = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/poi_lat"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/poi_lat")} -- double. Need to convert to DMS format before outputting
B777DR_backend_poi_lon = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/poi_lon"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/poi_lon")} -- double. Need to convert to DMS format before outputting
B777DR_backend_poi_elev = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/poi_elev"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/poi_elev")}
B777DR_backend_poi_freq = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/poi_freq"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/poi_lon")} -- need to convert to Boeing-style(https://github.com/Stratosphere-Studios/FMC-backend-plugin/blob/master/src/lib/libnav/str_utils.hpp#L23)
B777DR_backend_poi_magVar = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/poi_mag_var"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/poi_mag_var")} -- string. Just display it. No transformations needed.

local rndL = {"", "", ""}
local rndS = {"", "", "", ""}
local radNavInhibit = 2 -- 0, 1, 2; should be in fmsModules[] - need merge notif branch; should separate for each cdu?

local radNavInhibitL = "   <->   <->ON;g2>" -- should separate for each cdu?
local radNavInhibitS = "OFF<->VOR<->  >" -- should separate for each cdu?

fmsPages["REFNAVDATA"] = createPage("REFNAVDATA")
fmsPages["REFNAVDATA"].getPage = function(self,pgNo,fmsID)
    local idNum = fmsID == "fmsL" and 1 or "fmsR" and 2 or 3

    B777DR_backend_page[idNum] = 2 -- set page to ref nav data mode

    if radNavInhibit == 0 then
        radNavInhibitL = "OFF;g3<->   <->  >"
        radNavInhibitS = "      VOR   ON "
        rndS[3] = "----                ----"
        rndS[4] = "----                ----"
    elseif radNavInhibit == 1 then
        radNavInhibitL = "   <->VOR;g3<->  >"
        radNavInhibitS = "OFF         ON "
        rndS[3] = "----                ----"
        rndS[4] = "ALL                  ALL"
    else
        radNavInhibitL = "   <->   <->ON;g2>"
        radNavInhibitS = "OFF   VOR      "
        rndS[3] = "ALL                  ALL"
        rndS[4] = "ALL                  ALL"
    end

    if B777DR_backend_poi_type[idNum] == 0 then -- no poi entered
        rndL[1] = "-----                   "
        rndS[1] = "                        "
        rndL[2] = "                        "
        rndS[2] = "                        "
        rndL[3] = "                        "
    elseif B777DR_backend_poi_type[idNum] == 1 then -- poi is waypoint
        rndL[1] = B777DR_backend_outIcao[idNum].."                   "
        rndS[1] = " LATITUDE      LONGITUDE"
        rndL[2] = toDMS(B777DR_backend_poi_lat[idNum], true).."        "..toDMS(B777DR_backend_poi_lon[idNum], false)
        rndS[2] = "                        "
        rndL[3] = "                        "
    elseif B777DR_backend_poi_type[idNum] == 3 then -- poi is a navaid
        rndL[1] = B777DR_backend_outIcao[idNum].."                   "
        rndS[1] = " LATITUDE      LONGITUDE"
        rndL[2] = toDMS(B777DR_backend_poi_lat[idNum], true).."        "..toDMS(B777DR_backend_poi_lon[idNum], false)
        rndS[2] = " MAG VAR                "
        rndL[3] = B777DR_backend_poi_magVar[idNum].."                     "
    elseif B777DR_backend_poi_type[idNum] == 5 then -- poi is an airport
        rndL[1] = B777DR_backend_outIcao[idNum].."                   "
        rndS[1] = " LATITUDE      LONGITUDE"
        rndL[2] = toDMS(B777DR_backend_poi_lat[idNum], true).."        "..toDMS(B777DR_backend_poi_lon[idNum], false)
        rndS[2] = "               ELEVATION"
        rndL[3] = "                     "..string.format("%d", B777DR_backend_poi_elev[idNum])
    end

    return {
        "      REF NAV DATA      ",
        "                        ",
        rndL[1],
        "                        ",
        rndL[2],
        "                        ",
        rndL[3],
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "<INDEX   "..radNavInhibitL
    }
end

fmsPages["REFNAVDATA"].getSmallPage = function(self,pgNo,fmsID)
	return {
		"                        ",
		" IDENT                  ",
		"                        ",
		rndS[1],
		"                        ",
        rndS[2],
		"                        ",
		"     NAVAID INHIBIT     ",
		rndS[3],
		"    VOR ONLY INHIBIT    ",
		rndS[4],
        "---------RAD NAV INHIBIT",
		"         "..radNavInhibitS
	}
end

fmsFunctionsDefs["REFNAVDATA"]={}
fmsFunctionsDefs["REFNAVDATA"]["L1"]={"setdata","refnavdata_poi"} -- need merge notif branch
fmsFunctionsDefs["REFNAVDATA"]["L6"]={"setpage","INITREF"}
fmsFunctionsDefs["REFNAVDATA"]["R6"]={"setdata","radNavInhibit"} -- need merge notif branch

fmsPages["REFNAVDATA"].getNumPages = function(self)
    return 1
end

B777DR_backend_msg_notInDatabase = {find_dataref("Strato/777/FMC/FMC_L/scratchpad/not_in_database"), find_dataref("Strato/777/FMC/FMC_R/scratchpad/not_in_database")}  -- need merge notif branch
B777DR_backend_msg_clear = {find_dataref("Strato/777/FMC/FMC_L/clear_msg"), find_dataref("Strato/777/FMC/FMC_R/clear_msg")} -- need merge notif branch

--[[if value == "radNavInhibit" then
    radNavInhibit = radNavInhibit == 3 and 0 or radNavInhibit + 1
    return
elseif value == "refnavdata_poi" then
    local idNum = fmsO.id == "fmsL" and 1 or fmsO.id == "fmsR" and 2 or 3
    B777DR_backend_inIcao[idNum] = fmsO["scratchpad"]
    fmsO["scratchpad"] = "" -- only clear if valid, if invalid notify without clearing
    return
end]]
