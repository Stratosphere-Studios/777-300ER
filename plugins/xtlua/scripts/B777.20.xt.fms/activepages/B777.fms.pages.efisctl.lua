local cmdPath = ""
local sta, mtrs = "", ""
local zoomOut, zoomIn = "", ""
local minsRst = ""
local mapMode = 0

fmsPages["EFISCTL152"]=createPage("EFISCTL152")
fmsPages["EFISCTL152"].getPage=function(self,pgNo,fmsID)
    local mapSelected = "     "
    local plnSelected = "     "
    local appSelected = "     "
    local vorSelected = "     "
    local ctrSelected = "     "
    local radBaro = "<      BARO;g4"
    local altimeter = 0
    local mapCenter = simDR_nd_center_dial_capt
    local baro = simDR_altimeter_baro_inHg
    local baroString = ""
    local dh = string.format("%03d",B777DR_minimums_dh[0])
    local mda = string.format("%04d",B777DR_minimums_mda[0])
    if fmsID=="fmsR" then
        if B777DR_baro_mode[1] == 0 then
            altimeter = string.format("%.02f", simDR_altimiter_setting[2])
        else
            altimeter = round(simDR_altimiter_setting[2] * 33.863892)
        end
        mapMode = simDR_nd_mode[2]
        --[[baro=simDR_altimeter_baro_inHg_fo
        if B777DR_baro_mode[1]==1 then
            baro=baro*33.863892
            baroString=" "..string.format("%04d",baro)
        else
            baroString=string.format("%02.2f",baro)
        end
        elseif  B777DR_baro_mode[0] ==1 then
        baro=baro*33.863892 
        baroString=" "..string.format("%04d",baro)
    else
        baroString=string.format("%02.2f",baro)]]
        zoomOut = "sim/instruments/map_copilot_zoom_out"
        zoomIn = "sim/instruments/map_copilot_zoom_in"
        minsRst = "Strato/B777/minimums_rst_fo"
    else
        if B777DR_baro_mode[0] == 0 then
            altimeter = string.format("%.02f", simDR_altimiter_setting[1])
        else
            altimeter = round(simDR_altimiter_setting[1] * 33.863892).." "
        end
        mapMode = simDR_nd_mode[1]
        zoomOut = "sim/instruments/map_zoom_out"
        zoomIn = "sim/instruments/map_zoom_in"
        minsRst = "Strato/B777/minimums_rst_capt"
    end

    if mapMode == 0 then appSelected = "<SEL>"
    elseif mapMode == 1 then vorSelected = "<SEL>"
    elseif mapMode == 2 then mapSelected = "<SEL>"
    elseif mapMode == 3 then plnSelected = "<SEL>"
    elseif mapMode == 4 then ctrSelected ="<SEL>"
        --TODO: Find correct values
    end

    if B777DR_minimums_mode == 1 then
        radBaro = "<RAD;g3       "
    end

    local page={
    "      EFIS CONTROL      ",
    "                        ",
    altimeter.."        ".. appSelected .."  APP>",
    "                        ",
    radBaro.."  ".. vorSelected .."  VOR>",
    "                        ",
    "             ".. mapSelected .."  MAP>",
    "                        ",
    "<MINS RESET  ".. plnSelected .."  PLN>",
    "                        ",
    "<RANGE INCR  ".. ctrSelected .."  CTR>",
    "             -----------",
    "<RANGE DECR     OPTIONS>"
    }
    return page
end

    B777DR_baro_mode                       = find_dataref("Strato/777/baro_mode")
    B777DR_minimums_mda                    = find_dataref("Strato/777/minimums_mda")
    B777DR_minimums_dh                     = find_dataref("Strato/777/minimums_dh")
    simDR_nd_mode                          = {find_dataref("sim/cockpit2/EFIS/map_mode"), find_dataref("sim/cockpit2/EFIS/map_mode_copilot")}
    simDR_nd_range                         = {find_dataref("sim/cockpit2/EFIS/map_range"), find_dataref("sim/cockpit2/EFIS/map_range_copilot")}
    B777DR_minimums_mode                   = find_dataref("Strato/777/minimums_mode") --TODO: Override physical control
    simDR_altimiter_setting                = {find_dataref("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot"), find_dataref("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot")}

local ranges = {" 10", " 20", " 40", " 80", "160", "320", "640"}
fmsPages["EFISCTL152"].getSmallPage=function(self,pgNo,fmsID)

    local range = ""
    local baroMode = " IN"
    local radBaro = " RAD<->"
    local ft = "   FT "

    if fmsID == "fmsR" then
        range = ranges[simDR_nd_range[2] + 1]
    else
        range = ranges[simDR_nd_range[1] + 1]
    end

    if B777DR_minimums_mode == 1 then
        radBaro = "    <->BARO"
        if B777DR_minimums_dh > 999 then
            ft = "    FT"
        end
    end

    if B777DR_baro_mode[0] == 1 then
        baroMode = "HPA"
    end

    return {
        "                        ",
        " BARO SET           MODE",
        "    "..baroMode,
        "RAD/BARO SEL            ",
        radBaro.."                       ",
        " MINS SET               ",
        ft.."                  ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        range.."NM                   ",
        "                        "
    }
end

fmsFunctionsDefs["EFISCTL152"]={}
fmsFunctionsDefs["EFISCTL152"]["L1"]={"setdata","BARO"} --
fmsFunctionsDefs["EFISCTL152"]["L2"]={"toggleVar","radBaro"}
fmsFunctionsDefs["EFISCTL152"]["L3"]={"setdata","MDA"}
fmsFunctionsDefs["EFISCTL152"]["L4"]={"doCMD", minsRst} --
fmsFunctionsDefs["EFISCTL152"]["L5"]={"doCMD", zoomOut} --
fmsFunctionsDefs["EFISCTL152"]["L6"]={"doCMD", zoomIn} --
fmsFunctionsDefs["EFISCTL152"]["R1"]={"setDref2", mapMode.."_0"} --
fmsFunctionsDefs["EFISCTL152"]["R2"]={"setDref2", mapMode.."_1"} --
fmsFunctionsDefs["EFISCTL152"]["R3"]={"setDref2", mapMode.."_2"} --
fmsFunctionsDefs["EFISCTL152"]["R4"]={"setDref2", mapMode.."_3"} --
fmsFunctionsDefs["EFISCTL152"]["R5"]={"setDref2", mapMode.."_4"} --
fmsFunctionsDefs["EFISCTL152"]["R6"]={"setpage","EFISOPTIONS152"} --




























	simDR_efis_wxr                         = find_dataref("sim/cockpit2/EFIS/EFIS_weather_on")
	simDR_efis_terr                        = find_dataref("sim/cockpit2/EFIS/EFIS_terrain_on")
	simDR_efis_tfc                         = find_dataref("sim/cockpit2/EFIS/EFIS_tcas_on")
	simDR_efis_arpt                        = find_dataref("sim/cockpit2/EFIS/EFIS_airport_on")
	simDR_efis_fix                         = find_dataref("sim/cockpit2/EFIS/EFIS_fix_on")
    simDR_efis_wxr                         = find_dataref("sim/cockpit2/EFIS/EFIS_weather_on_copilot")
	simDR_efis_terr_fo                     = find_dataref("sim/cockpit2/EFIS/EFIS_terrain_on_copilot")
	simDR_efis_tfc_fo                      = find_dataref("sim/cockpit2/EFIS/EFIS_tcas_on_copilot")
	simDR_efis_arpt_fo                     = find_dataref("sim/cockpit2/EFIS/EFIS_airport_on_copilot")
	simDR_efis_fix_fo                      = find_dataref("sim/cockpit2/EFIS/EFIS_fix_on_copilot")
    simDR_efis_sel1                        = find_dataref("sim/cockpit2/EFIS/EFIS_1_selection_pilot")
    simDR_efis_sel1_fo                     = find_dataref("sim/cockpit2/EFIS/EFIS_1_selection_copilot")
    simDR_efis_sel2                        = find_dataref("sim/cockpit2/EFIS/EFIS_1_selection_pilot")
    simDR_efis_sel2_fo                     = find_dataref("sim/cockpit2/EFIS/EFIS_1_selection_coilot")
    simDR_efis_wpt                         = find_dataref("sim/cockpit2/EFIS/EFIS_fix_on")
	simDR_efis_wpt_fo                      = find_dataref("sim/cockpit2/EFIS/EFIS_fix_on_copilot")
    B777DR_nd_sta                          = find_dataref("Strato/777/EFIS/sta")
    B777DR_pfd_mtrs                        = find_dataref("Strato/777/displays/mtrs")

local efisModeSmall = "   <->   <->    "

fmsPages["EFISOPTIONS152"]=createPage("EFISOPTIONS152")
fmsPages["EFISOPTIONS152"].getPage=function(self,pgNo,fmsID)

    if B777DR_cdu_efis_ctl[0] == 1 then
		simDR_vor_adf[1] = vor_adf[1]
		simDR_vor_adf[2] = vor_adf[1]
	else
		simDR_vor_adf[1] = B777DR_efis_vor_adf[0]
		simDR_vor_adf[2] = B777DR_efis_vor_adf[1]
	end

	if B777DR_cdu_efis_ctl[1] == 1 then
		simDR_vor_adf[3] = vor_adf[2]
		simDR_vor_adf[4] = vor_adf[2]
	else
		simDR_vor_adf[4] = B777DR_efis_vor_adf[2]
		simDR_vor_adf[4] = B777DR_efis_vor_adf[3]
	end

    local wxrSelected  = "     "
    local terrSelected = "     "
    local tfcSelected  = "     "
    local arptSelected = "     "
    local wptSelected  = "     "
    local staSelected  = "     "
    local mtrsSelected = "     "
    local efisModeBig   = "OFF   ADF   VOR>"

    if fmsID=="fmsR" then
        if vor_adf[2] == 0 then
            efisModeBig   = "      ADF;g3      >"
            efisModeSmall = "OFF<->   <->VOR "
        elseif vor_adf[2] == 1 then
            efisModeBig   = "OFF;g3            >"
            efisModeSmall = "   <->ADF<->VOR "
        else
            efisModeBig   = "            VOR>"
            efisModeSmall = "OFF<->ADF<->    "
        end
        if B777DR_nd_sta[1] == 1 then staSelected="<SEL>" end
        if simDR_efis_tfc_fo == 1 then tfcSelected = "<SEL>" end
        if simDR_efis_terr_fo == 1 then terrSelected = "<SEL>" end
        if simDR_efis_fix_fo == 1 then wptSelected="<SEL>" end
        if simDR_efis_arpt_fo == 1 then arptSelected="<SEL>" end
        if simDR_efis_wxr_fo == 1 then wxrSelected = "<SEL>" end
        if B777DR_pfd_mtrs[1] == 1 then mtrsSelected = "<SEL>" end
    else
        if vor_adf[1] == 0 then
            efisModeBig   = "      ADF;g3      >"
            efisModeSmall = "OFF<->   <->VOR "
        elseif vor_adf[1] == 1 then
            efisModeBig   = "OFF;g3            >"
            efisModeSmall = "   <->ADF<->VOR "
        else
            efisModeBig   = "            VOR;g3>"
            efisModeSmall = "OFF<->ADF<->    "
        end
        if B777DR_nd_sta[0] == 1 then staSelected="<SEL>" end
        if simDR_efis_tfc ==1 then tfcSelected = "<SEL>" end
        if simDR_efis_terr ==1 then terrSelected = "<SEL>" end
        if simDR_efis_fix == 1 then wptSelected="<SEL>" end
        if simDR_efis_arpt == 1 then arptSelected="<SEL>" end
        if simDR_efis_wxr == 1 then wxrSelected = "<SEL>" end
        if B777DR_pfd_mtrs[0] == 1 then mtrsSelected = "<SEL>" end
    end

    if fmsID == "fmsR" then
        cmdPath = "sim/instruments/EFIS_copilot_"
        sta, mtrs = "Strato/777/EFIS/sta[0]", "Strato/777/displays/mtrs[0]"
    else
        cmdPath = "sim/instruments/EFIS_"
        sta, mtrs = "sta = Strato/777/EFIS/sta[1]", "Strato/777/displays/mtrs[1]"
    end

    return {
        "      EFIS OPTIONS      ",
        "                        ",
        "<WXR  ".. wxrSelected .."         FPV>;r4",
        "                        ",
        "<STA  "..staSelected.." ".. terrSelected .."  TERR>",
        "                        ",
        "<WPT  "..wptSelected.." "..mtrsSelected.."  MTRS>",
        "                        ",
        "<ARPT ".. arptSelected .." ".. tfcSelected .."   TFC>",
        "                        ",
        "<DATA   "..efisModeBig,
        "             -----------",
        "<POS            CONTROL>"
    }

end

fmsPages["EFISOPTIONS152"].getSmallPage=function(self,pgNo,fmsID)
    return {
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "             SEL ADF/VOR",
        "        "..efisModeSmall,
        "                        ",
        "                        "
    }
end

fmsFunctionsDefs["EFISOPTIONS152"]={}
fmsFunctionsDefs["EFISOPTIONS152"]["L1"]={"doCMD", cmdPath.."wxr"}
fmsFunctionsDefs["EFISOPTIONS152"]["L2"]={"toggleDref", sta}
fmsFunctionsDefs["EFISOPTIONS152"]["L3"]={"doCMD", cmdPath.."fix"}
fmsFunctionsDefs["EFISOPTIONS152"]["L4"]={"doCMD", cmdPath.."apt"}
--fmsFunctionsDefs["EFISOPTIONS152"]["L5"]={"doCMD",""}
--fmsFunctionsDefs["EFISOPTIONS152"]["L6"]={"doCMD",""}
fmsFunctionsDefs["EFISOPTIONS152"]["R1"]={"setDisp","fpv"} -- TODO
fmsFunctionsDefs["EFISOPTIONS152"]["R2"]={"doCMD", cmdPath.."terr"}
fmsFunctionsDefs["EFISOPTIONS152"]["R3"]={"toggleDref", mtrs} --TODO: FO side
fmsFunctionsDefs["EFISOPTIONS152"]["R4"]={"doCMD", cmdPath.."tcas"}
fmsFunctionsDefs["EFISOPTIONS152"]["R5"]={"setDisp","adfvor"}
fmsFunctionsDefs["EFISOPTIONS152"]["R6"]={"setpage","EFISCTL152"}