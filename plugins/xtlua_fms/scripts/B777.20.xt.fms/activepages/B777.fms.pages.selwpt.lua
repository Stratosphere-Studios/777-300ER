B777DR_backend_selwpt_pageActive = {find_dataref("Strato/777/FMC/FMC_L/SEL_WPT/is_active"), find_dataref("Strato/777/FMC/FMC_R/SEL_WPT/is_active")}
B777DR_POItable = {find_dataref("Strato/777/FMC/FMC_L/SEL_WPT/poi_list"), find_dataref("Strato/777/FMC/FMC_R/SEL_WPT/poi_list")}                    --done
B777DR_backend_selwpt_poi1 = {find_dataref("Strato/777/FMC/FMC_L/SEL_WPT/poi1_type"), find_dataref("Strato/777/FMC/FMC_R/SEL_WPT/poi1_type")}       --done
B777DR_backend_selwpt_poi2 = {find_dataref("Strato/777/FMC/FMC_L/SEL_WPT/poi2_type"), find_dataref("Strato/777/FMC/FMC_R/SEL_WPT/poi2_type")}       --done
B777DR_backend_selwpt_poi3 = {find_dataref("Strato/777/FMC/FMC_L/SEL_WPT/poi3_type"), find_dataref("Strato/777/FMC/FMC_R/SEL_WPT/poi3_type")}       --done
B777DR_backend_selwpt_poi4 = {find_dataref("Strato/777/FMC/FMC_L/SEL_WPT/poi4_type"), find_dataref("Strato/777/FMC/FMC_R/SEL_WPT/poi4_type")}       --done
B777DR_backend_selwpt_poi5 = {find_dataref("Strato/777/FMC/FMC_L/SEL_WPT/poi5_type"), find_dataref("Strato/777/FMC/FMC_R/SEL_WPT/poi5_type")}       --done
B777DR_backend_selwpt_poi6 = {find_dataref("Strato/777/FMC/FMC_L/SEL_WPT/poi6_type"), find_dataref("Strato/777/FMC/FMC_R/SEL_WPT/poi6_type")}       --done
B777DR_backend_selwpt_numPOIs = {find_dataref("Strato/777/FMC/FMC_L/SEL_WPT/n_pois_disp"), find_dataref("Strato/777/FMC/FMC_R/SEL_WPT/n_pois_disp")}--done
B777DR_backend_selwpt_numPages = {find_dataref("Strato/777/FMC/FMC_L/SEL_WPT/n_subpages"), find_dataref("Strato/777/FMC/FMC_R/SEL_WPT/n_subpages")}    -- total number of sub pages. Read only, int.
B777DR_backend_selwpt_currPage = {find_dataref("Strato/777/FMC/FMC_L/SEL_WPT/subpage"), find_dataref("Strato/777/FMC/FMC_R/SEL_WPT/subpage")}       --done; int dataref. Writable. Equal to current page the user is on. Should be in the range of [1, n_subpages]
B777DR_backend_selwpt_pickedWpt = {find_dataref("Strato/777/FMC/FMC_L/SEL_WPT/wpt_idx"), find_dataref("Strato/777/FMC/FMC_R/SEL_WPT/wpt_idx")}         -- int, writable. Set to value in range [0, 5]. To let the fmc plugin know about user's selection, set the following dataref:

function getPOIdata(idNum, poiNum)
    local num = (poiNum - 1) * 3
    local freqString = tostring(B777DR_POItable[idNum][num])
    local numPOIs = B777DR_backend_selwpt_numPOIs[idNum] <= 6 and B777DR_backend_selwpt_numPOIs[idNum] or B777DR_backend_selwpt_numPOIs[idNum] - 6
    if freqString:len() == 3 then
        freqString = freqString..".0 "
    else
        freqString = string.format("%3.2f", B777DR_POItable[idNum][num] / 100)
    end

    if poiNum <= numPOIs then
        return freqString.." "..toDMS(B777DR_POItable[idNum][num+1], true)..toDMS(B777DR_POItable[idNum][num+2], false)
    else
        return "                        "
    end
end

fmsPages["SELWPT"]=createPage("SELWPT")
fmsPages["SELWPT"].getPage=function(self,pgNo,fmsID)
    local idNum = fmsID == "fmsL" and 1 or "fmsR" and 2 or 3
    B777DR_backend_selwpt_currPage[idNum] = pgNo - 1
    return {
        " SELECT DESIRED WPT     ",
        "                        ",
        getPOIdata(idNum, 1),
        "                        ",
        getPOIdata(idNum, 2),
        "                        ",
        getPOIdata(idNum, 3),
        "                        ",
        getPOIdata(idNum, 4),
        "                        ",
        getPOIdata(idNum, 5),
        "                        ",
        getPOIdata(idNum, 6)
    }
end

fmsPages["SELWPT"].getSmallPage=function(self,pgNo,fmsID)
    local idNum = fmsID == "fmsL" and 1 or "fmsR" and 2 or 3
    print(B777DR_backend_selwpt_poi1[idNum])

    return {
        "                    "..pgNo.."/"..B777DR_backend_selwpt_numPages[idNum],
        B777DR_backend_selwpt_poi1[idNum],
        "                        ",
        B777DR_backend_selwpt_poi2[idNum],
        "                        ",
        B777DR_backend_selwpt_poi3[idNum],
        "                        ",
        B777DR_backend_selwpt_poi4[idNum],
        "                        ",
        B777DR_backend_selwpt_poi5[idNum],
        "                        ",
        B777DR_backend_selwpt_poi6[idNum],
        "                        ",
    }
end

fmsPages["SELWPT"].getNumPages=function(self)
    return 1 -- B777DR_backend_selwpt_numPages separate on each fms, may need to change the way this works (should be easy?)
end