B777DR_backend_page = {fmsL = find_dataref("Strato/777/FMC/FMC_L/page"), fmsR = find_dataref("Strato/777/FMC/FMC_R/page")}

-- Navaid inhibit
B777DR_something = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/navaid_1_in"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/navaid_1_in")}
--B777DR_something = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/navaid_2_in"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/navaid_2_in")}

B777DR_backend_navaidInhibit_out = {find_dataref("Strato/777/FMC/REF_NAV/navaid_1_out"), find_dataref("Strato/777/FMC/REF_NAV/navaid_2_out")}
B777DR_backend_vorInIhibit_out = {find_dataref("Strato/777/FMC/REF_NAV/vor_1_out"), find_dataref("Strato/777/FMC/REF_NAV/vor_2_out")}

--VOR only inhibit:
--B777DR_something = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/vor_1_in"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/vor_1_in")}
--B777DR_something = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/vor_2_in"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/vor_2_in")}


B777DR_backend_inIcao = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/input_icao"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/input_icao")}-- 5 characters
B777DR_backend_outIcao = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/out_icao"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/out_icao")}


B777DR_backend_poi_type = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/poi_type"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/poi_type")}
B777DR_backend_poi_lat = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/poi_lat"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/poi_lat")} -- double. Need to convert to DMS format before outputting
B777DR_backend_poi_lon = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/poi_lon"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/poi_lon")} -- double. Need to convert to DMS format before outputting
B777DR_backend_poi_elev = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/poi_elev"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/poi_elev")}
B777DR_backend_poi_freq = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/poi_freq"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/poi_lon")} -- need to convert to Boeing-style(https://github.com/Stratosphere-Studios/FMC-backend-plugin/blob/master/src/lib/libnav/str_utils.hpp#L23)
B777DR_backend_poi_magVar = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/poi_mag_var"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/poi_mag_var")} -- string. Just display it. No transformations needed.
B777DR_backend_poi_len_ft = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/poi_length_ft"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/poi_length_ft")}
B777DR_backend_poi_len_m = {find_dataref("Strato/777/FMC/FMC_L/REF_NAV/poi_length_m"), find_dataref("Strato/777/FMC/FMC_R/REF_NAV/poi_length_m")}

local rndL = {"", "", ""}
local rndS = {"", "", "", "", ""}

B777DR_backend_radNavInhibit = find_dataref("Strato/777/FMC/REF_NAV/rad_nav_inh") -- 0: ON, 1: VOR, 2: OFF

local radNavInhibitL = "   <->   <->ON;g02>"
local radNavInhibitS = "OFF<->VOR<->  >"

fmsPages["REFNAVDATA"] = createPage("REFNAVDATA")
fmsPages["REFNAVDATA"].getPage = function(self,pgNo,fmsID)
    local idNum = fmsID == "fmsL" and 1 or "fmsR" and 2 or 3
    print(B777DR_something[idNum].."end")

    B777DR_backend_page[fmsID] = 2 -- set page to ref nav data mode

    if B777DR_backend_radNavInhibit == 2 then
        radNavInhibitL = "OFF;g03<->   <->  >"
        radNavInhibitS = "      VOR   ON "
        rndS[3] = B777DR_backend_radNavInhibit"----                ----"
        rndS[4] = "----                ----"
    elseif B777DR_backend_radNavInhibit == 1 then
        radNavInhibitL = "   <->VOR;g03<->  >"
        radNavInhibitS = "OFF         ON "
        rndS[3] = "----                ----"
        rndS[4] = "ALL                  ALL"
    elseif B777DR_backend_radNavInhibit == 0 then
        radNavInhibitL = "   <->   <->ON;g02>"
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
    else
        rndL[1] = B777DR_backend_outIcao[idNum].."                   "
        rndS[1] = " LATITUDE      LONGITUDE"
        rndL[2] = toDMS(B777DR_backend_poi_lat[idNum], true).."        "..toDMS(B777DR_backend_poi_lon[idNum], false)
        if B777DR_backend_poi_type[idNum] == 2 then -- poi is waypoint
            rndS[2] = "                        "
            rndL[3] = "                        "
        elseif B777DR_backend_poi_type[idNum] == 3 then -- poi is a navaid
            rndS[2] = " MAG VAR                "
            rndL[3] = B777DR_backend_poi_magVar[idNum].."                     "
        elseif B777DR_backend_poi_type[idNum] == 5 then -- poi is an airport
            rndS[2] = "               ELEVATION"
            rndL[3] = "                     "..string.format("%d", B777DR_backend_poi_elev[idNum])
        elseif B777DR_backend_poi_type[idNum] == 7 then -- poi is a runway
            rndS[2] = " LENGTH        ELEVATION"
            rndL[3] = B777DR_backend_poi_len_ft[idNum].."  "..B777DR_backend_poi_len_m[idNum].."                      "
            rndS[5] = "     FT    M            " -- line7, same as rndL[3] above
        end
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
		rndS[5],
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