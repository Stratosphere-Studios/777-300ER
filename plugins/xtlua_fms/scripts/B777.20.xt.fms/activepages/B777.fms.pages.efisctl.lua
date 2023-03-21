local mins;
fmsPages["EFISCTL152"]=createPage("EFISCTL152")
fmsPages["EFISCTL152"].getPage=function(self,pgNo,fmsID)
    local id = fmsID == "fmsL" and 0 or 1;
    local mapSelected = "     "
    local plnSelected = "     "
    local appSelected = "     "
    local vorSelected = "     "
    local ctrSelected = "     "
    local radBaro = "<      BARO;g4"
    local altimeter = 0

    local stringMins;
    if B777DR_minimums_mode[id] == 1 then
        mins = B777DR_minimums_mda[id]
    else
        mins = B777DR_minimums_dh[id]
        radBaro = "<RAD;g3       "
    end

    stringMins = mins..string.rep(" ", 5 - tostring(mins):len()) -- make sure minimums always takes up 5 spaces on the display

    if B777DR_baro_mode[id] == 0 then
        altimeter = string.format("%.02f", simDR_altimiter_setting[id+1])
    else
        altimeter = round(simDR_altimiter_setting[id+1] * 33.863892).." "
    end

    if simDR_nd_mode[id+1] == 0 then appSelected = "<SEL>"
    elseif simDR_nd_mode[id+1] == 1 then vorSelected = "<SEL>"
    elseif simDR_nd_mode[id+1] == 3 then mapSelected = "<SEL>"
    elseif simDR_nd_mode[id+1] == 4 then plnSelected = "<SEL>"
    end

    if simDR_map_hsi[id+1] == 1 then ctrSelected ="<SEL>"end

    local page={
    "      EFIS CONTROL      ",
    "                        ",
    altimeter.."        ".. appSelected .."  APP>",
    "                        ",
    radBaro.."  ".. vorSelected .."  VOR>",
    "                        ",
    stringMins.."        ".. mapSelected .."  MAP>",
    "                        ",
    "<MINS RESET  ".. plnSelected .."  PLN>",
    "                        ",
    "<RANGE INCR  ".. ctrSelected .."  CTR>",
    "             -----------",
    "<RANGE DECR     OPTIONS>"
    }
    return page
end

fmsPages["EFISCTL152"].getSmallPage=function(self,pgNo,fmsID)
    local id = fmsID == "fmsL" and 0 or 1;

    local range = ""
    local baroMode = " IN"
    local radBaro = " RAD<->    "
    local ft = "   FT "

    range = simDR_nd_range[id+1]

    if B777DR_minimums_mode[id] == 0 then
        radBaro = "    <->BARO"
    end

    ft = string.rep(" ", tostring(mins):len()).."FT"

    if B777DR_baro_mode[id] == 1 then
        baroMode = "HPA"
    end

    return {
        "                        ",
        " BARO SET           MODE",
        "    "..baroMode,
        "RAD/BARO SEL            ",
        radBaro.."                       ",
        " MINS SET               ",
        ft.."                    ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        range.."NM                   ",
        "                        "
    }
end

fmsFunctionsDefs["EFISCTL152"]={}
fmsFunctionsDefs["EFISCTL152"]["L1"]={"setdata","BARO"}
fmsFunctionsDefs["EFISCTL152"]["L2"]={"setDisp","radBaro"}
fmsFunctionsDefs["EFISCTL152"]["L3"]={"setdata","mins"}
fmsFunctionsDefs["EFISCTL152"]["L4"]={"setDisp", "minsRst"}
fmsFunctionsDefs["EFISCTL152"]["L5"]={"setDisp", "zoomOut"}
fmsFunctionsDefs["EFISCTL152"]["L6"]={"setDisp", "zoomIn"}
fmsFunctionsDefs["EFISCTL152"]["R1"]={"setDisp", "mapMode_0"}
fmsFunctionsDefs["EFISCTL152"]["R2"]={"setDisp", "mapMode_1"}
fmsFunctionsDefs["EFISCTL152"]["R3"]={"setDisp", "mapMode_2"}
fmsFunctionsDefs["EFISCTL152"]["R4"]={"setDisp", "mapMode_3"}
fmsFunctionsDefs["EFISCTL152"]["R5"]={"setDisp", "mapMode_4"}
fmsFunctionsDefs["EFISCTL152"]["R6"]={"setpage","EFISOPTIONS152"}


local efisModeSmall = "   <->   <->    "

fmsPages["EFISOPTIONS152"]=createPage("EFISOPTIONS152")
fmsPages["EFISOPTIONS152"].getPage=function(self,pgNo,fmsID)
    local id = fmsID == "fmsL" and 0 or 1;

    local wxrSelected  = "     "
    local terrSelected = "     "
    local tfcSelected  = "     "
    local arptSelected = "     "
    local wptSelected  = "     "
    local staSelected  = "     "
    local mtrsSelected = "     "
    local efisModeBig   = "OFF   ADF   VOR>"

    if vor_adf[id+1] == 0 then
        efisModeBig   = "      ADF;g3      >"
        efisModeSmall = "OFF<->   <->VOR "
    elseif vor_adf[id+1] == 1 then
        efisModeBig   = "OFF;g3            >"
        efisModeSmall = "   <->ADF<->VOR "
    else
        efisModeBig   = "            VOR;g3>"
        efisModeSmall = "OFF<->ADF<->    "
    end

    if B777DR_nd_sta[id] == 1 then staSelected="<SEL>" end
    if B777DR_pfd_mtrs[id] == 1 then mtrsSelected = "<SEL>" end

    if fmsID=="fmsR" then
        if simDR_efis_tfc_fo == 1 then tfcSelected = "<SEL>" end
        if simDR_efis_terr_fo == 1 then terrSelected = "<SEL>" end
        if simDR_efis_fix_fo == 1 then wptSelected="<SEL>" end
        if simDR_efis_arpt_fo == 1 then arptSelected="<SEL>" end
        if simDR_efis_wxr_fo == 1 then wxrSelected = "<SEL>" end
    else
        if simDR_efis_tfc ==1 then tfcSelected = "<SEL>" end
        if simDR_efis_terr ==1 then terrSelected = "<SEL>" end
        if simDR_efis_fix == 1 then wptSelected="<SEL>" end
        if simDR_efis_arpt == 1 then arptSelected="<SEL>" end
        if simDR_efis_wxr == 1 then wxrSelected = "<SEL>" end
    end

    return {
        "      EFIS OPTIONS      ",
        "                        ",
        "<WXR  ".. wxrSelected .."         FPV>;r4",
        "                        ",
        "<STA  "..staSelected.." ".. terrSelected .."  TERR>;r5",
        "                        ",
        "<WPT  "..wptSelected.." "..mtrsSelected.."  MTRS>",
        "                        ",
        "<ARPT ".. arptSelected .." ".. tfcSelected .."   TFC>",
        "                        ",
        "<DATA   "..efisModeBig,
        "             -----------",
        "<POS;r4            CONTROL>"
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
fmsFunctionsDefs["EFISOPTIONS152"]["L1"]={"setDisp", "wxr"}
fmsFunctionsDefs["EFISOPTIONS152"]["L2"]={"setDisp", "sta"}
fmsFunctionsDefs["EFISOPTIONS152"]["L3"]={"setDisp", "fix"}
fmsFunctionsDefs["EFISOPTIONS152"]["L4"]={"setDisp", "apt"}
--fmsFunctionsDefs["EFISOPTIONS152"]["L5"]={"setDisp",""}
--fmsFunctionsDefs["EFISOPTIONS152"]["L6"]={"setDisp",""}
fmsFunctionsDefs["EFISOPTIONS152"]["R2"]={"setDisp", "terr"}
fmsFunctionsDefs["EFISOPTIONS152"]["R3"]={"setDisp", "mtrs"}
fmsFunctionsDefs["EFISOPTIONS152"]["R4"]={"setDisp", "tcas"}
fmsFunctionsDefs["EFISOPTIONS152"]["R5"]={"setDisp","adfvor"}
fmsFunctionsDefs["EFISOPTIONS152"]["R6"]={"setpage","EFISCTL152"}