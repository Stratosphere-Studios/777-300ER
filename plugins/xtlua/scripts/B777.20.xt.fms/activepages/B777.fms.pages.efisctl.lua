--TODO: FO side controls
fmsPages["EFISCTL152"]=createPage("EFISCTL152")
fmsPages["EFISCTL152"].getPage=function(self,pgNo,fmsID)
    B777DR_baro_mode                       = find_dataref("Strato/777/baro_mode")
    B777DR_minimums_mda                    = find_dataref("Strato/777/minimums_mda")
    B777DR_minimums_dh                     = find_dataref("Strato/777/minimums_dh")


    local mapMode=simDR_nd_mode_dial_capt
    local mapCenter=simDR_nd_center_dial_capt
    local baro=simDR_altimeter_baro_inHg
    local baroString=""
    local dh=string.format("%03d",B777DR_minimums_dh[0])
    local mda=string.format("%04d",B777DR_minimums_mda[0])
    if fmsID=="fmsR" then
        mapMode=simDR_nd_mode_dial_fo
        mapCenter=simDR_nd_center_dial_fo
        baro=simDR_altimeter_baro_inHg_fo
        if B777DR_baro_mode[1]==1 then
            baro=baro*33.863892
            baroString=" "..string.format("%04d",baro)
        else
            baroString=string.format("%02.2f",baro)
        end
        dh=string.format("%03d",B777DR_minimums_dh[1])
        mda=string.format("%04d",B777DR_minimums_mda[1])
    elseif  B777DR_baro_mode[0] ==1 then
        baro=baro*33.863892 
        baroString=" "..string.format("%04d",baro)
    else
        baroString=string.format("%02.2f",baro)
    end

    local mapSelected="     "
    local plnSelected="     "
    local appSelected="     "
    local vorSelected="     "
    local ctrSelected="     "

    if mapMode==0 then appSelected="<SEL>"
    elseif mapMode==1 then vorSelected="<SEL>"
    elseif mapMode==2 then mapSelected="<SEL>" 
    elseif mapMode==3 then plnSelected="<SEL>"
    end

    if mapCenter==1 then ctrSelected ="<SEL>" end  
    local page={
    "      EFIS CONTROL      ",
    "                        ",
    "            ".. appSelected .."  APP>",
    "                        ",
    "<RAD<->BARO         ".. vorSelected .."  VOR>", -- deselected option is small and white
    "                        ",
    "            ".. mapSelected .."  MAP>",
    "                        ",
    "<MINS RESET ".. plnSelected .."  PLN>",
    "                        ",
    "<RANGE INCR ".. ctrSelected .."  CTR>",
    "             -----------",
    "<RANGE DECR     OPTIONS>"
    }
    return page
end

local ranges = {" 10", " 20", " 40", " 80", "160", "320", "640"}
fmsPages["EFISCTL152"].getSmallPage=function(self,pgNo,fmsID)
    local mode="IN "
    local baromode=B777DR_baro_mode[0]
    local range=ranges[simDR_range_dial_capt+1]
    if fmsID=="fmsR" then 
        baromode=B777DR_baro_mode[1]
        range=ranges[simDR_range_dial_fo+1]
    end 
    if baromode==1 then mode="HPA" end
    return {
        "                        ",
        " BARO SET           MODE",
        "                        ",
        "RAD/BARO SEL            ",
        "                        ",
        " MINS SET               ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ", 
        range.."NM                   ",
        "                        "
        }
	end
fmsFunctionsDefs["EFISCTL152"]={}
--[[fmsFunctionsDefs["EFISCTL152"]["L1"]={"setdata","BARO"}
fmsFunctionsDefs["EFISCTL152"]["L2"]={"setdata","DH"}
fmsFunctionsDefs["EFISCTL152"]["L4"]={"setdata","MDA"}
fmsFunctionsDefs["EFISCTL152"]["L5"]={"setdata","RANGEINC"}
fmsFunctionsDefs["EFISCTL152"]["L6"]={"setdata","RANGEDEC"}
fmsFunctionsDefs["EFISCTL152"]["R1"]={"setdata","EFISMAP"}
fmsFunctionsDefs["EFISCTL152"]["R2"]={"setdata","EFISPLN"}
fmsFunctionsDefs["EFISCTL152"]["R3"]={"setdata","EFISAPP"}
fmsFunctionsDefs["EFISCTL152"]["R4"]={"setdata","EFISVOR"}
fmsFunctionsDefs["EFISCTL152"]["R5"]={"setdata","EFISCTR"}]]
fmsFunctionsDefs["EFISCTL152"]["R6"]={"setpage","EFISOPTIONS152"}

if fmsO.id=="fmsR" then
    fmsFunctionsDefs["EFISCTL152"]["L3"]={"doCMD","Strato/B777/minimums_rst_fo"}
else
    fmsFunctionsDefs["EFISCTL152"]["L3"]={"doCMD","Strato/B777/minimums_rst_capt"}
end

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
    simDR_efis_sel2_fo                     = find_dataref("sim/cockpit2/EFIS/EFIS_1_selection_copilot")
    simDR_efis_wpt                         = find_dataref("sim/cockpit2/EFIS/EFIS_fix_on")
	simDR_efis_wpt_fo                      = find_dataref("sim/cockpit2/EFIS/EFIS_fix_on_copilot")
    B777DR_nd_sta                          = find_dataref("Strato/777/EFIS/sta")
    B777DR_pfd_mtrs                        = find_dataref("Strato/777/displays/mtrs")


local efisModeSmall = "   <->   <->    "

fmsPages["EFISOPTIONS152"]=createPage("EFISOPTIONS152")
fmsPages["EFISOPTIONS152"].getPage=function(self,pgNo,fmsID)

    local wxrSelected  = "     "
    local terrSelected = "     "
    local tfcSelected  = "     "
    local arptSelected = "     "
    local wptSelected  = "     "
    local staSelected  = "     "
    local mtrsSelected = "     "
    local efisModeBig   = "OFF   ADF   VOR>"

    if fmsID=="fmsR" then
        if simDR_efis_sel1_fo == 0 then
            efisModeBig   = "      ADF;g3      >"
            efisModeSmall = "OFF<->   <->VOR "
        elseif simDR_efis_sel1_fo == 1 then
            efisModeBig   = "OFF;g3            >"
            efisModeSmall = "   <->ADF<->VOR "
        else
            efisModeBig   = "            VOR>;g4"
            efisModeSmall = "OFF<->ADF<->    "
        end
        if B777DR_nd_sta[1] == 1 then staSelected="<SEL>" end
        if simDR_efis_tfc_fo == 1 then tfcSelected = "<SEL>" end
        if simDR_efis_terr_fo == 1 then terrSelected = "<SEL>" end
        if simDR_efis_fix_fo ==1 then wptSelected="<SEL>" end
        if simDR_efis_arpt_fo == 1 then arptSelected="<SEL>" end
        if simDR_efis_wxr_fo == 1 then wxrSelected = "<SEL>" end
        if B777DR_pfd_mtrs[1] == 1 then mtrsSelected = "<SEL>" end
    else
        if simDR_efis_sel1 == 0 then
            efisModeBig   = "      ADF;g3      >"
            efisModeSmall = "OFF<->   <->VOR "
        elseif simDR_efis_sel1 == 1 then
            efisModeBig   = "OFF;g3            >"
            efisModeSmall = "   <->ADF<->VOR "
        else
            efisModeBig   = "            VOR>;g4"
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

    return {
        "      EFIS OPTIONS      ",
        "                        ",
        "<WXR  ".. wxrSelected .."    FPV>;r4",
        "                        ",
        "<STA  "..staSelected.."   ".. terrSelected .."  TERR>",
        "                        ",
        "<WPT  "..wptSelected.."   "..mtrsSelected.."  MTRS>",
        "                        ",
        "<ARPT ".. arptSelected .."   ".. tfcSelected .."   TFC>",
        "                        ",
        "<DATA;r4   "..efisModeBig,
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
        "                        ",
        "             SEL ADF/VOR",
        "                        ",
        "        "..efisModeSmall,
    }
end

--[[fmsFunctionsDefs["EFISOPTIONS152"]["L2"]={"setdata","POS"}
fmsFunctionsDefs["EFISOPTIONS152"]["L3"]={"setdata","TERR"}
fmsFunctionsDefs["EFISOPTIONS152"]["R1"]={"setdata","WPT"}
fmsFunctionsDefs["EFISOPTIONS152"]["R2"]={"setdata","STA"}
--fmsFunctionsDefs["EFISOPTIONS152"]["R4"]={"setdata","DATA"}
fmsFunctionsDefs["EFISOPTIONS152"]["R5"]={"setdata","ADFDISP"}]]

local cmdPath = ""



if fmsO.id=="fmsR" then
    cmdPath = "sim/instruments/EFIS_copilot_"
else
    cmdPath = "sim/instruments/EFIS_"

end

fmsFunctionsDefs["EFISOPTIONS152"]={}
fmsFunctionsDefs["EFISOPTIONS152"]["L1"]={"doCMD", cmdPath.."wxr"}
fmsFunctionsDefs["EFISOPTIONS152"]["L2"]={"doCMD",""}
fmsFunctionsDefs["EFISOPTIONS152"]["L3"]={"doCMD",""}
fmsFunctionsDefs["EFISOPTIONS152"]["L4"]={"doCMD", cmdPath.."apt"}
fmsFunctionsDefs["EFISOPTIONS152"]["L5"]={"doCMD",""}
fmsFunctionsDefs["EFISOPTIONS152"]["L6"]={"doCMD",""}
--msFunctionsDefs["EFISOPTIONS152"]["R1"]={"doCMD",""}
fmsFunctionsDefs["EFISOPTIONS152"]["R2"]={"doCMD", cmdPath.."terr"}
fmsFunctionsDefs["EFISOPTIONS152"]["R3"]={"doCMD",""}
fmsFunctionsDefs["EFISOPTIONS152"]["R4"]={"doCMD", cmdPath.."tcas"}
fmsFunctionsDefs["EFISOPTIONS152"]["R5"]={"doCMD",""}
fmsFunctionsDefs["EFISOPTIONS152"]["R6"]={"setpage","EFISCTL152"}