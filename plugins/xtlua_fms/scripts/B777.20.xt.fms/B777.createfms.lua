--[[
*****************************************************************************************
*        COPYRIGHT � 2020 Mark Parker/mSparks CC-BY-NC4
*     Converted from Sparky744 to Stratosphere 777 by remenkemi 
*****************************************************************************************
]]

fms={
  id = "",
  page1=false,
  prevPage = "README_1",
  currentPage = "README",
  targetPage = "README",
  targetpgNo = 1,
  scratchpad="",
  notify,
  dispMSG = {},
  pgNo = 1
}

_G.alertStack = {}
_G.commStack = {}
_G.outofdateNotified = {fmsL = false, fmsR = false}

_G.simCMD_FMS_key={}

_G.fmsKeyFunc={}

local nidModule -- bad
function notindatabaseClear()
  outofdateNotified[nidModule] = false
end

local newText = {fmsL = false, fmsC = false, fmsR = false}

local keyQueue = {} -- actually a queue but whatever

function delayKeyDown(fmsModule, key, ovrd) -- simulates realistic input lag
  if ovrd then
    keyDown(fmsModule, key)
  else
    table.insert(keyQueue, {fmsModule, key})
    stop_timer(keyDowner)
    run_after_time(keyDowner, 0.2) -- got 0.2 from somwhere, 0.1 is less annoying
  end
end

function keyDowner()
  for _, v in pairs(keyQueue) do
    keyDown(v[1], v[2])
  end
  keyQueue = {} -- reset call stack after all keys actuated
end

function keyDown(fmsModule, key) -- only page keys have delay, not entry ones

  if getSimConfig("FMC", "unlocked") == 1 then
    print(fmsModule.. " do " .. key)

    if key=="fix" then -- MENU
      fmsModules[fmsModule].targetPage = "INDEX"
      fmsModules[fmsModule].targetpgNo = 1
      switchCustomMode()
    end

    local i = fmsModule == "fmsL" and 0 or fmsModule == "fmsR" and 1 or 2

    if B777DR_cdu_act[i] == 1 and fmsModule ~= "fmsC" then -- keys only work when fmc is enabled and don't work on center fmc
      -- key names don't match page names initially for default aircraft modding purposes. too lazy to fix so look at comments for actual key name
      if key=="index" then -- INIT REF
        fmsModules[fmsModule].targetPage = "INITREF"
        fmsModules[fmsModule].targetpgNo = 1
        switchCustomMode()
        return
      elseif key=="fpln" then -- RTE
        fmsModules[fmsModule].targetPage = "RTE1"
        fmsModules[fmsModule].targetpgNo = 1
        switchCustomMode()
        return
      elseif key=="clb" then -- DEP ARR
        fmsModules[fmsModule].targetPage = "DEPARRINDEX"
        fmsModules[fmsModule].targetpgNo = 1
        switchCustomMode()
        return
      elseif key=="crz" then -- ALTN
        fmsModules[fmsModule]:notify("advs", advsMsgs[18]) -- KEY/FUNCTION INOP
        return
        --[[fmsModules[fmsModule].targetPage = "ATCINDEX"
        fmsModules[fmsModule].targetpgNo = 1
        switchCustomMode()]]
      elseif key=="des" then -- VNAV
        fmsModules[fmsModule]:notify("advs", advsMsgs[18]) -- KEY/FUNCTION INOP
        return
        --[[fmsModules[fmsModule].targetPage = "VNAV"
        fmsModules[fmsModule].targetpgNo = 1
        switchCustomMode()]]
      elseif key=="dir_intc" then -- FIX
        fmsModules[fmsModule]:notify("advs", advsMsgs[18]) -- KEY/FUNCTION INOP
        return
        --[[fmsModules[fmsModule].targetPage = "FIX"
        fmsModules[fmsModule].targetpgNo = 1
        switchCustomMode()]]
      elseif key=="legs" then -- LEGS
        fmsModules[fmsModule]:notify("advs", advsMsgs[18]) -- KEY/FUNCTION INOP
        return
        --[[fmsModules[fmsModule].targetPage = "LEGS"
        fmsModules[fmsModule].targetpgNo = 1
        switchCustomMode()]]
      elseif key=="dep_arr" then -- HOLD
        fmsModules[fmsModule]:notify("advs", advsMsgs[18]) -- KEY/FUNCTION INOP
        return
        --[[fmsModules[fmsModule].targetPage = "HOLD"
        fmsModules[fmsModule].targetpgNo = 1
        switchCustomMode()]]
      elseif key=="hold" then -- FMC COMM
        fmsModules[fmsModule]:notify("advs", advsMsgs[18]) -- KEY/FUNCTION INOP
        return
        --[[fmsModules[fmsModule].targetPage = "FMCCOMM"
        fmsModules[fmsModule].targetpgNo = 1
        switchCustomMode()]]
      elseif key=="navrad" then -- NAV RAD
        fmsModules[fmsModule].targetPage = "NAVRAD"
        fmsModules[fmsModule].targetpgNo = 1
        switchCustomMode()
        return
      elseif key=="prog" then -- PROG
        fmsModules[fmsModule]:notify("advs", advsMsgs[18]) -- KEY/FUNCTION INOP
        return
        --[[fmsModules[fmsModule].targetPage = "PROGRESS"
        fmsModules[fmsModule].targetpgNo = 1
        switchCustomMode()]]
      end
    end
  end

  local page = fmsModules[fmsModule].targetPage

  if key == "clear" then
    if next(alertStack) then
      table.remove(alertStack, 1)
    elseif next(commStack) then
      table.remove(commStack, 1)
    elseif next(fmsModules[fmsModule].dispMSG) then
      --if fmsModules[fmsModule].dispMSG[1].msg == "NOT IN DATABASE" then
        --B777DR_backend_clr[fmsModule == "fmsL" and 1 or 2] = 1
        --nidModule = fmsModule
        --run_after_time(notindatabaseClear, 1) -- fix this nonsense
      --end
      table.remove(fmsModules[fmsModule].dispMSG, 1)
    else
      fmsModules[fmsModule].scratchpad = fmsModules[fmsModule].scratchpad:sub(1, -2)
    end
    return
  end

  if key == "holdClear" then
    fmsModules[fmsModule].scratchpad = ""
    return
  end

  if hasChild(fmsFunctionsDefs[page],key) then
    print(fmsModule.. " found " .. fmsFunctionsDefs[page][key][1] .. " for " .. key)
    fmsFunctions[ fmsFunctionsDefs[page][key][1]](fmsModules[fmsModule],fmsFunctionsDefs[page][key][2])
    print(fmsModule.. " did " .. key .. " for " .. page)
    return
  elseif #key == 1 then
    if next(alertStack) and B777DR_cdu_act[fmsModule == "fmsL" and 0 or fmsModule == "fmsR" and 1 or 2] == 1 then
      newText[fmsModule] = true
    end
    fmsModules[fmsModule].scratchpad=fmsModules[fmsModule].scratchpad .. key
    return
  elseif key=="slash" then
    if next(alertStack) and B777DR_cdu_act[fmsModule == "fmsL" and 0 or fmsModule == "fmsR" and 1 or 2] == 1 then
      newText[fmsModule] = true
    end
    fmsModules[fmsModule].scratchpad=fmsModules[fmsModule].scratchpad.."/"
    return
  elseif key == "minus" then
    fmsModules[fmsModule].scratchpad=fmsModules[fmsModule].scratchpad..'-'
  elseif key == "plus" then
    fmsModules[fmsModule].scratchpad=fmsModules[fmsModule].scratchpad..'+'
  elseif key == "space" then
    if next(alertStack) and B777DR_cdu_act[fmsModule == "fmsL" and 0 or fmsModule == "fmsR" and 1 or 2] == 1 then
      newText[fmsModule] = true
    end
    fmsModules[fmsModule].scratchpad=fmsModules[fmsModule].scratchpad.." "
    return
  elseif key == "del" then
    fmsModules[fmsModule].scratchpad = ""
    for k, v in ipairs(fmsModules[fmsModule].dispMSG) do
      if v.msg == "DELETE" then
        table.remove(fmsModules[fmsModule].dispMSG, k)
        return
      end
    end
    fmsModules[fmsModule]:notify("advs", advsMsgs[1])
    return
  elseif key=="next" then
    if fmsModules[fmsModule].pgNo < fmsPages[page]:getNumPages(fmsModule) then
      fmsModules[fmsModule].targetpgNo = fmsModules[fmsModule].pgNo + 1
    else
      fmsModules[fmsModule].targetpgNo = 1
    end
    print(fmsModule.. " did " .. key .. " for " .. page)
    return
  elseif key=="prev" then
    if fmsModules[fmsModule].pgNo > 1 then
      fmsModules[fmsModule].targetpgNo = fmsModules[fmsModule].pgNo - 1
    else
      fmsModules[fmsModule].targetpgNo = fmsPages[page]:getNumPages(fmsModule)
    end
    print(fmsModule.. " did " .. key .. " for " .. page)
    switchCustomMode()
    return
  elseif key=="exec" then
    simCMD_FMS_key[fmsModule][key]:once()
    return
  end
  fmsModules[fmsModule]:notify("advs", advsMsgs[18]) -- KEY/FUNCTION INOP
end

function create_keypad(fms)
  fmsKeyFunc[fms]={};

  fmsKeyFunc[fms].funcs={
    key_L1_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"],"L1") end end,
    key_L2_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "L2") end end,
    key_L3_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "L3") end end,
    key_L4_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "L4") end end,
    key_L5_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "L5") end end,
    key_L6_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "L6") end end,

    key_R1_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "R1") end end,
    key_R2_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "R2") end end,
    key_R3_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "R3") end end,
    key_R4_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "R4") end end,
    key_R5_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "R5") end end,
    key_R6_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "R6") end end,

    key_index_CMDhandler	=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "index") end end,
    key_fpln_CMDhandler		=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "fpln") end end,
    key_navrad_CMDhandler	=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "navrad") end end,
    key_clb_CMDhandler		=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "clb") end end,
    key_crz_CMDhandler		=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "crz") end end,
    key_des_CMDhandler		=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "des") end end,
    key_dir_intc_CMDhandler	=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "dir_intc") end end,
    key_legs_CMDhandler		=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "legs") end end,
    key_dep_arr_CMDhandler	=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "dep_arr") end end,
    key_hold_CMDhandler		=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "hold") end end,
    key_prog_CMDhandler		=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "prog") end end,
    key_execute_CMDhandler	=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "exec") end end,
    key_fix_CMDhandler		=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "fix") end end,
    key_prev_pg_CMDhandler	=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "prev") end end,
    key_next_pg_CMDhandler	=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "next") end end,   

    key_0_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "0") end end,
    key_1_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "1") end end,
    key_2_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "2") end end,
    key_3_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "3") end end,
    key_4_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "4") end end,
    key_5_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "5") end end,
    key_6_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "6") end end,
    key_7_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "7") end end,
    key_8_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "8") end end,
    key_9_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "9") end end,

    key_period_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], ".") end end,
    key_minus_CMDhandler=function (phase, duration)
      if phase == 2 then
        if duration >= 1 then -- 2 sec?
          keyDown(fmsKeyFunc[fms]["funcs"]["parent"], "plus")
        else
          delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "minus")
        end
      end
    end,

    key_A_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "A") end end,
    key_B_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "B") end end,
    key_C_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "C") end end,
    key_D_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "D") end end,
    key_E_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "E") end end,
    key_F_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "F") end end,
    key_G_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "G") end end,
    key_H_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "H") end end,
    key_I_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "I") end end,
    key_J_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "J") end end,
    key_K_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "K") end end,
    key_L_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "L") end end,
    key_M_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "M") end end,
    key_N_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "N") end end,
    key_O_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "O") end end,
    key_P_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "P") end end,
    key_Q_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "Q") end end,
    key_R_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "R") end end,
    key_S_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "S") end end,
    key_T_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "T") end end,
    key_U_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "U") end end,
    key_V_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "V") end end,
    key_W_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "W") end end,
    key_X_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "X") end end,
    key_Y_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "Y") end end,
    key_Z_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "Z") end end,
    key_space_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "space") end end,
    key_del_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "del") end end,
    key_slash_CMDhandler=function (phase, duration) if phase ==0 then delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "slash") end end,
    key_clear_CMDhandler = function (phase, duration)
      if phase == 0 then
        delayKeyDown(fmsKeyFunc[fms]["funcs"]["parent"], "clear")
      end
      if duration >= 1 and fmsModules[fms].scratchpad:len() > 1 then  -- 2 sec?
        --keyDown(fmsKeyFunc[fms]["funcs"]["parent"], "holdClear")
        fmsModules[fms].scratchpad = ""
      end
    end
  }
  fmsKeyFunc[fms].funcs.parent=fms
end

B777DR_fms_hl={}
B777DR_fms_c={}
B777DR_fms_gn={}
B777DR_fms_gy={}
B777DR_fms_m={}
B777DR_fms={}
B777DR_fms_s={}
B777DR_fms_s_hl={}

function setDREFs(fmsO,cduid,fmsid,keyid,fmskeyid) -- fmsObject | xp cdu | id for datarefs | xp cmd prefix | id for cmds
  B777DR_fms[fmsO.id]={}
  B777DR_fms[fmsO.id][1]                = find_dataref("Strato/B777/"..fmsid.."/Line01_L")
  B777DR_fms[fmsO.id][2]                = find_dataref("Strato/B777/"..fmsid.."/Line02_L")
  B777DR_fms[fmsO.id][3]                = find_dataref("Strato/B777/"..fmsid.."/Line03_L")
  B777DR_fms[fmsO.id][4]                = find_dataref("Strato/B777/"..fmsid.."/Line04_L")
  B777DR_fms[fmsO.id][5]                = find_dataref("Strato/B777/"..fmsid.."/Line05_L")
  B777DR_fms[fmsO.id][6]                = find_dataref("Strato/B777/"..fmsid.."/Line06_L")
  B777DR_fms[fmsO.id][7]                = find_dataref("Strato/B777/"..fmsid.."/Line07_L")
  B777DR_fms[fmsO.id][8]                = find_dataref("Strato/B777/"..fmsid.."/Line08_L")
  B777DR_fms[fmsO.id][9]                = find_dataref("Strato/B777/"..fmsid.."/Line09_L")
  B777DR_fms[fmsO.id][10]               = find_dataref("Strato/B777/"..fmsid.."/Line10_L")
  B777DR_fms[fmsO.id][11]               = find_dataref("Strato/B777/"..fmsid.."/Line11_L")
  B777DR_fms[fmsO.id][12]               = find_dataref("Strato/B777/"..fmsid.."/Line12_L")
  B777DR_fms[fmsO.id][13]               = find_dataref("Strato/B777/"..fmsid.."/Line13_L")
  B777DR_fms[fmsO.id][14]               = find_dataref("Strato/B777/"..fmsid.."/Line14_L")

  B777DR_fms_s[fmsO.id]={}
  B777DR_fms_s[fmsO.id][1]                = find_dataref("Strato/B777/"..fmsid.."/Line01_S")
  B777DR_fms_s[fmsO.id][2]                = find_dataref("Strato/B777/"..fmsid.."/Line02_S")
  B777DR_fms_s[fmsO.id][3]                = find_dataref("Strato/B777/"..fmsid.."/Line03_S")
  B777DR_fms_s[fmsO.id][4]                = find_dataref("Strato/B777/"..fmsid.."/Line04_S")
  B777DR_fms_s[fmsO.id][5]                = find_dataref("Strato/B777/"..fmsid.."/Line05_S")
  B777DR_fms_s[fmsO.id][6]                = find_dataref("Strato/B777/"..fmsid.."/Line06_S")
  B777DR_fms_s[fmsO.id][7]                = find_dataref("Strato/B777/"..fmsid.."/Line07_S")
  B777DR_fms_s[fmsO.id][8]                = find_dataref("Strato/B777/"..fmsid.."/Line08_S")
  B777DR_fms_s[fmsO.id][9]                = find_dataref("Strato/B777/"..fmsid.."/Line09_S")
  B777DR_fms_s[fmsO.id][10]               = find_dataref("Strato/B777/"..fmsid.."/Line10_S")
  B777DR_fms_s[fmsO.id][11]               = find_dataref("Strato/B777/"..fmsid.."/Line11_S")
  B777DR_fms_s[fmsO.id][12]               = find_dataref("Strato/B777/"..fmsid.."/Line12_S")
  B777DR_fms_s[fmsO.id][13]               = find_dataref("Strato/B777/"..fmsid.."/Line13_S")
  B777DR_fms_s[fmsO.id][14]               = find_dataref("Strato/B777/"..fmsid.."/Line14_S")

	-- highlight
  B777DR_fms_hl[fmsO.id]={}
	B777DR_fms_hl[fmsO.id][1]               = find_dataref("Strato/B777/"..fmsid.."/Line01_L_hl")
	B777DR_fms_hl[fmsO.id][2]               = find_dataref("Strato/B777/"..fmsid.."/Line02_L_hl")
	B777DR_fms_hl[fmsO.id][3]               = find_dataref("Strato/B777/"..fmsid.."/Line03_L_hl")
	B777DR_fms_hl[fmsO.id][4]               = find_dataref("Strato/B777/"..fmsid.."/Line04_L_hl")
	B777DR_fms_hl[fmsO.id][5]               = find_dataref("Strato/B777/"..fmsid.."/Line05_L_hl")
	B777DR_fms_hl[fmsO.id][6]               = find_dataref("Strato/B777/"..fmsid.."/Line06_L_hl")
	B777DR_fms_hl[fmsO.id][7]               = find_dataref("Strato/B777/"..fmsid.."/Line07_L_hl")
	B777DR_fms_hl[fmsO.id][8]               = find_dataref("Strato/B777/"..fmsid.."/Line08_L_hl")
	B777DR_fms_hl[fmsO.id][9]               = find_dataref("Strato/B777/"..fmsid.."/Line09_L_hl")
	B777DR_fms_hl[fmsO.id][10]              = find_dataref("Strato/B777/"..fmsid.."/Line10_L_hl")
	B777DR_fms_hl[fmsO.id][11]              = find_dataref("Strato/B777/"..fmsid.."/Line11_L_hl")
	B777DR_fms_hl[fmsO.id][12]              = find_dataref("Strato/B777/"..fmsid.."/Line12_L_hl")
	B777DR_fms_hl[fmsO.id][13]              = find_dataref("Strato/B777/"..fmsid.."/Line13_L_hl")
	B777DR_fms_hl[fmsO.id][14]              = find_dataref("Strato/B777/"..fmsid.."/Line14_L_hl")

  B777DR_fms_s_hl[fmsO.id]={}
	B777DR_fms_s_hl[fmsO.id][1]             = find_dataref("Strato/B777/"..fmsid.."/Line01_S_hl")
	B777DR_fms_s_hl[fmsO.id][2]             = find_dataref("Strato/B777/"..fmsid.."/Line02_S_hl")
	B777DR_fms_s_hl[fmsO.id][3]             = find_dataref("Strato/B777/"..fmsid.."/Line03_S_hl")
	B777DR_fms_s_hl[fmsO.id][4]             = find_dataref("Strato/B777/"..fmsid.."/Line04_S_hl")
	B777DR_fms_s_hl[fmsO.id][5]             = find_dataref("Strato/B777/"..fmsid.."/Line05_S_hl")
	B777DR_fms_s_hl[fmsO.id][6]             = find_dataref("Strato/B777/"..fmsid.."/Line06_S_hl")
	B777DR_fms_s_hl[fmsO.id][7]             = find_dataref("Strato/B777/"..fmsid.."/Line07_S_hl")
	B777DR_fms_s_hl[fmsO.id][8]             = find_dataref("Strato/B777/"..fmsid.."/Line08_S_hl")
	B777DR_fms_s_hl[fmsO.id][9]             = find_dataref("Strato/B777/"..fmsid.."/Line09_S_hl")
	B777DR_fms_s_hl[fmsO.id][10]            = find_dataref("Strato/B777/"..fmsid.."/Line10_S_hl")
	B777DR_fms_s_hl[fmsO.id][11]            = find_dataref("Strato/B777/"..fmsid.."/Line11_S_hl")
	B777DR_fms_s_hl[fmsO.id][12]            = find_dataref("Strato/B777/"..fmsid.."/Line12_S_hl")
	B777DR_fms_s_hl[fmsO.id][13]            = find_dataref("Strato/B777/"..fmsid.."/Line13_S_hl")
	B777DR_fms_s_hl[fmsO.id][14]            = find_dataref("Strato/B777/"..fmsid.."/Line14_S_hl")

  -- cyan
	B777DR_fms_c[fmsO.id]={}
	B777DR_fms_c[fmsO.id][1]                = find_dataref("Strato/B777/"..fmsid.."/Line01_L_c")
	B777DR_fms_c[fmsO.id][2]                = find_dataref("Strato/B777/"..fmsid.."/Line02_L_c")
	B777DR_fms_c[fmsO.id][3]                = find_dataref("Strato/B777/"..fmsid.."/Line03_L_c")
	B777DR_fms_c[fmsO.id][4]                = find_dataref("Strato/B777/"..fmsid.."/Line04_L_c")
	B777DR_fms_c[fmsO.id][5]                = find_dataref("Strato/B777/"..fmsid.."/Line05_L_c")
	B777DR_fms_c[fmsO.id][6]                = find_dataref("Strato/B777/"..fmsid.."/Line06_L_c")
	B777DR_fms_c[fmsO.id][7]                = find_dataref("Strato/B777/"..fmsid.."/Line07_L_c")
	B777DR_fms_c[fmsO.id][8]                = find_dataref("Strato/B777/"..fmsid.."/Line08_L_c")
	B777DR_fms_c[fmsO.id][9]                = find_dataref("Strato/B777/"..fmsid.."/Line09_L_c")
	B777DR_fms_c[fmsO.id][10]               = find_dataref("Strato/B777/"..fmsid.."/Line10_L_c")
	B777DR_fms_c[fmsO.id][11]               = find_dataref("Strato/B777/"..fmsid.."/Line11_L_c")
	B777DR_fms_c[fmsO.id][12]               = find_dataref("Strato/B777/"..fmsid.."/Line12_L_c")
	B777DR_fms_c[fmsO.id][13]               = find_dataref("Strato/B777/"..fmsid.."/Line13_L_c")
	B777DR_fms_c[fmsO.id][14]               = find_dataref("Strato/B777/"..fmsid.."/Line14_L_c")

	-- green
  B777DR_fms_gn[fmsO.id]={}
	B777DR_fms_gn[fmsO.id][1]                = find_dataref("Strato/B777/"..fmsid.."/Line01_L_gn")
	B777DR_fms_gn[fmsO.id][2]                = find_dataref("Strato/B777/"..fmsid.."/Line02_L_gn")
	B777DR_fms_gn[fmsO.id][3]                = find_dataref("Strato/B777/"..fmsid.."/Line03_L_gn")
	B777DR_fms_gn[fmsO.id][4]                = find_dataref("Strato/B777/"..fmsid.."/Line04_L_gn")
	B777DR_fms_gn[fmsO.id][5]                = find_dataref("Strato/B777/"..fmsid.."/Line05_L_gn")
	B777DR_fms_gn[fmsO.id][6]                = find_dataref("Strato/B777/"..fmsid.."/Line06_L_gn")
	B777DR_fms_gn[fmsO.id][7]                = find_dataref("Strato/B777/"..fmsid.."/Line07_L_gn")
	B777DR_fms_gn[fmsO.id][8]                = find_dataref("Strato/B777/"..fmsid.."/Line08_L_gn")
	B777DR_fms_gn[fmsO.id][9]                = find_dataref("Strato/B777/"..fmsid.."/Line09_L_gn")
	B777DR_fms_gn[fmsO.id][10]               = find_dataref("Strato/B777/"..fmsid.."/Line10_L_gn")
	B777DR_fms_gn[fmsO.id][11]               = find_dataref("Strato/B777/"..fmsid.."/Line11_L_gn")
	B777DR_fms_gn[fmsO.id][12]               = find_dataref("Strato/B777/"..fmsid.."/Line12_L_gn")
	B777DR_fms_gn[fmsO.id][13]               = find_dataref("Strato/B777/"..fmsid.."/Line13_L_gn")
	B777DR_fms_gn[fmsO.id][14]               = find_dataref("Strato/B777/"..fmsid.."/Line14_L_gn")

	-- grey
  B777DR_fms_gy[fmsO.id]={}
	B777DR_fms_gy[fmsO.id][1]                = find_dataref("Strato/B777/"..fmsid.."/Line01_L_gy")
	B777DR_fms_gy[fmsO.id][2]                = find_dataref("Strato/B777/"..fmsid.."/Line02_L_gy")
	B777DR_fms_gy[fmsO.id][3]                = find_dataref("Strato/B777/"..fmsid.."/Line03_L_gy")
	B777DR_fms_gy[fmsO.id][4]                = find_dataref("Strato/B777/"..fmsid.."/Line04_L_gy")
	B777DR_fms_gy[fmsO.id][5]                = find_dataref("Strato/B777/"..fmsid.."/Line05_L_gy")
	B777DR_fms_gy[fmsO.id][6]                = find_dataref("Strato/B777/"..fmsid.."/Line06_L_gy")
	B777DR_fms_gy[fmsO.id][7]                = find_dataref("Strato/B777/"..fmsid.."/Line07_L_gy")
	B777DR_fms_gy[fmsO.id][8]                = find_dataref("Strato/B777/"..fmsid.."/Line08_L_gy")
	B777DR_fms_gy[fmsO.id][9]                = find_dataref("Strato/B777/"..fmsid.."/Line09_L_gy")
	B777DR_fms_gy[fmsO.id][10]               = find_dataref("Strato/B777/"..fmsid.."/Line10_L_gy")
	B777DR_fms_gy[fmsO.id][11]               = find_dataref("Strato/B777/"..fmsid.."/Line11_L_gy")
	B777DR_fms_gy[fmsO.id][12]               = find_dataref("Strato/B777/"..fmsid.."/Line12_L_gy")
	B777DR_fms_gy[fmsO.id][13]               = find_dataref("Strato/B777/"..fmsid.."/Line13_L_gy")
	B777DR_fms_gy[fmsO.id][14]               = find_dataref("Strato/B777/"..fmsid.."/Line14_L_gy")

	-- magenta
  B777DR_fms_m[fmsO.id]={}
	B777DR_fms_m[fmsO.id][1]                = find_dataref("Strato/B777/"..fmsid.."/Line01_L_m")
	B777DR_fms_m[fmsO.id][2]                = find_dataref("Strato/B777/"..fmsid.."/Line02_L_m")
	B777DR_fms_m[fmsO.id][3]                = find_dataref("Strato/B777/"..fmsid.."/Line03_L_m")
	B777DR_fms_m[fmsO.id][4]                = find_dataref("Strato/B777/"..fmsid.."/Line04_L_m")
	B777DR_fms_m[fmsO.id][5]                = find_dataref("Strato/B777/"..fmsid.."/Line05_L_m")
	B777DR_fms_m[fmsO.id][6]                = find_dataref("Strato/B777/"..fmsid.."/Line06_L_m")
	B777DR_fms_m[fmsO.id][7]                = find_dataref("Strato/B777/"..fmsid.."/Line07_L_m")
	B777DR_fms_m[fmsO.id][8]                = find_dataref("Strato/B777/"..fmsid.."/Line08_L_m")
	B777DR_fms_m[fmsO.id][9]                = find_dataref("Strato/B777/"..fmsid.."/Line09_L_m")
	B777DR_fms_m[fmsO.id][10]               = find_dataref("Strato/B777/"..fmsid.."/Line10_L_m")
	B777DR_fms_m[fmsO.id][11]               = find_dataref("Strato/B777/"..fmsid.."/Line11_L_m")
	B777DR_fms_m[fmsO.id][12]               = find_dataref("Strato/B777/"..fmsid.."/Line12_L_m")
	B777DR_fms_m[fmsO.id][13]               = find_dataref("Strato/B777/"..fmsid.."/Line13_L_m")
	B777DR_fms_m[fmsO.id][14]               = find_dataref("Strato/B777/"..fmsid.."/Line14_L_m")

  create_keypad(fmsO.id)
  B777CMD_fms1_ls_key_L1              = deferred_command("Strato/B777/".. fmskeyid .. "/ls_key/L1", "FMS1 Line Select Key 1-Left", fmsKeyFunc[fmsO.id]["funcs"]["key_L1_CMDhandler"])
  B777CMD_fms1_ls_key_L2              = deferred_command("Strato/B777/".. fmskeyid .. "/ls_key/L2", "FMS1 Line Select Key 2-Left", fmsKeyFunc[fmsO.id]["funcs"]["key_L2_CMDhandler"])
  B777CMD_fms1_ls_key_L3              = deferred_command("Strato/B777/".. fmskeyid .. "/ls_key/L3", "FMS1 Line Select Key 3-Left", fmsKeyFunc[fmsO.id]["funcs"]["key_L3_CMDhandler"])
  B777CMD_fms1_ls_key_L4              = deferred_command("Strato/B777/".. fmskeyid .. "/ls_key/L4", "FMS1 Line Select Key 4-Left", fmsKeyFunc[fmsO.id]["funcs"]["key_L4_CMDhandler"])
  B777CMD_fms1_ls_key_L5              = deferred_command("Strato/B777/".. fmskeyid .. "/ls_key/L5", "FMS1 Line Select Key 5-Left", fmsKeyFunc[fmsO.id]["funcs"]["key_L5_CMDhandler"])
  B777CMD_fms1_ls_key_L6              = deferred_command("Strato/B777/".. fmskeyid .. "/ls_key/L6", "FMS1 Line Select Key 6-Left", fmsKeyFunc[fmsO.id]["funcs"]["key_L6_CMDhandler"])

  B777CMD_fms1_ls_key_R1              = deferred_command("Strato/B777/".. fmskeyid .. "/ls_key/R1", "FMS1 Line Select Key 1-Right", fmsKeyFunc[fmsO.id]["funcs"]["key_R1_CMDhandler"])
  B777CMD_fms1_ls_key_R2              = deferred_command("Strato/B777/".. fmskeyid .. "/ls_key/R2", "FMS1 Line Select Key 2-Right", fmsKeyFunc[fmsO.id]["funcs"]["key_R2_CMDhandler"])
  B777CMD_fms1_ls_key_R3              = deferred_command("Strato/B777/".. fmskeyid .. "/ls_key/R3", "FMS1 Line Select Key 3-Right", fmsKeyFunc[fmsO.id]["funcs"]["key_R3_CMDhandler"])
  B777CMD_fms1_ls_key_R4              = deferred_command("Strato/B777/".. fmskeyid .. "/ls_key/R4", "FMS1 Line Select Key 4-Right", fmsKeyFunc[fmsO.id]["funcs"]["key_R4_CMDhandler"])
  B777CMD_fms1_ls_key_R5              = deferred_command("Strato/B777/".. fmskeyid .. "/ls_key/R5", "FMS1 Line Select Key 5-Right", fmsKeyFunc[fmsO.id]["funcs"]["key_R5_CMDhandler"])
  B777CMD_fms1_ls_key_R6              = deferred_command("Strato/B777/".. fmskeyid .. "/ls_key/R6", "FMS1 Line Select Key 6-Right", fmsKeyFunc[fmsO.id]["funcs"]["key_R6_CMDhandler"])

  -- FUNCTION KEYS ------------------------------------------------------------------------
  B777CMD_fms1_func_key_index         = deferred_command("Strato/B777/".. fmskeyid .. "/func_key/index", "FMS1 Function Key INDEX",fmsKeyFunc[fmsO.id]["funcs"]["key_index_CMDhandler"])
  B777CMD_fms1_func_key_fpln          = deferred_command("Strato/B777/".. fmskeyid .. "/func_key/fpln", "FMS1 Function Key FPLN", fmsKeyFunc[fmsO.id]["funcs"]["key_fpln_CMDhandler"])
  B777CMD_fms1_func_key_navrad        = deferred_command("Strato/B777/".. fmskeyid .. "/func_key/navrad", "FMS1 Function Key FPLN", fmsKeyFunc[fmsO.id]["funcs"]["key_navrad_CMDhandler"])
  B777CMD_fms1_func_key_clb           = deferred_command("Strato/B777/".. fmskeyid .. "/func_key/clb", "FMS1 Function Key CLB", fmsKeyFunc[fmsO.id]["funcs"]["key_clb_CMDhandler"])
  B777CMD_fms1_func_key_crz           = deferred_command("Strato/B777/".. fmskeyid .. "/func_key/crz", "FMS1 Function Key CRZ", fmsKeyFunc[fmsO.id]["funcs"]["key_crz_CMDhandler"])
  B777CMD_fms1_func_key_des           = deferred_command("Strato/B777/".. fmskeyid .. "/func_key/des", "FMS1 Function Key DES", fmsKeyFunc[fmsO.id]["funcs"]["key_des_CMDhandler"])
  B777CMD_fms1_func_key_dir_intc      = deferred_command("Strato/B777/".. fmskeyid .. "/func_key/dir_intc", "FMS1 Function Key DIR/INTC",fmsKeyFunc[fmsO.id]["funcs"]["key_dir_intc_CMDhandler"])
  B777CMD_fms1_func_key_legs          = deferred_command("Strato/B777/".. fmskeyid .. "/func_key/legs", "FMS1 Function Key LEGS", fmsKeyFunc[fmsO.id]["funcs"]["key_legs_CMDhandler"])
  B777CMD_fms1_func_key_dep_arr       = deferred_command("Strato/B777/".. fmskeyid .. "/func_key/dep_arr", "FMS1 Function Key DEP/ARR", fmsKeyFunc[fmsO.id]["funcs"]["key_dep_arr_CMDhandler"])
  B777CMD_fms1_func_key_hold          = deferred_command("Strato/B777/".. fmskeyid .. "/func_key/hold", "FMS1 Function Key HOLD", fmsKeyFunc[fmsO.id]["funcs"]["key_hold_CMDhandler"])
  B777CMD_fms1_func_key_prog          = deferred_command("Strato/B777/".. fmskeyid .. "/func_key/prog", "FMS1 Function Key PROG", fmsKeyFunc[fmsO.id]["funcs"]["key_prog_CMDhandler"])
  B777CMD_fms1_key_execute            = deferred_command("Strato/B777/".. fmskeyid .. "/key/execute", "FMS1 KEY EXEC", fmsKeyFunc[fmsO.id]["funcs"]["key_execute_CMDhandler"])
  B777CMD_fms1_func_key_fix           = deferred_command("Strato/B777/".. fmskeyid .. "/func_key/fix", "FMS1 Function Key FIX", fmsKeyFunc[fmsO.id]["funcs"]["key_fix_CMDhandler"])
  B777CMD_fms1_func_key_prev_pg       = deferred_command("Strato/B777/".. fmskeyid .. "/func_key/prev_pg", "FMS1 Function Key PREV PAGE", fmsKeyFunc[fmsO.id]["funcs"]["key_prev_pg_CMDhandler"])
  B777CMD_fms1_func_key_next_pg       = deferred_command("Strato/B777/".. fmskeyid .. "/func_key/next_pg", "FMS1 Function Key NEXT PAGE", fmsKeyFunc[fmsO.id]["funcs"]["key_next_pg_CMDhandler"])

  -- ALPHA-NUMERIC KEYS -------------------------------------------------------------------
  B777CMD_fms1_alphanum_key_0         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/0", "FMS1 Alpha/Numeric Key 0", fmsKeyFunc[fmsO.id]["funcs"]["key_0_CMDhandler"])
  B777CMD_fms1_alphanum_key_1         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/1", "FMS1 Alpha/Numeric Key 1", fmsKeyFunc[fmsO.id]["funcs"]["key_1_CMDhandler"])
  B777CMD_fms1_alphanum_key_2         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/2", "FMS1 Alpha/Numeric Key 2", fmsKeyFunc[fmsO.id]["funcs"]["key_2_CMDhandler"])
  B777CMD_fms1_alphanum_key_3         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/3", "FMS1 Alpha/Numeric Key 3", fmsKeyFunc[fmsO.id]["funcs"]["key_3_CMDhandler"])
  B777CMD_fms1_alphanum_key_4         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/4", "FMS1 Alpha/Numeric Key 4", fmsKeyFunc[fmsO.id]["funcs"]["key_4_CMDhandler"])
  B777CMD_fms1_alphanum_key_5         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/5", "FMS1 Alpha/Numeric Key 5", fmsKeyFunc[fmsO.id]["funcs"]["key_5_CMDhandler"])
  B777CMD_fms1_alphanum_key_6         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/6", "FMS1 Alpha/Numeric Key 6", fmsKeyFunc[fmsO.id]["funcs"]["key_6_CMDhandler"])
  B777CMD_fms1_alphanum_key_7         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/7", "FMS1 Alpha/Numeric Key 7", fmsKeyFunc[fmsO.id]["funcs"]["key_7_CMDhandler"])
  B777CMD_fms1_alphanum_key_8         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/8", "FMS1 Alpha/Numeric Key 8", fmsKeyFunc[fmsO.id]["funcs"]["key_8_CMDhandler"])
  B777CMD_fms1_alphanum_key_9         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/9", "FMS1 Alpha/Numeric Key 9", fmsKeyFunc[fmsO.id]["funcs"]["key_9_CMDhandler"])

  B777CMD_fms1_key_period             = deferred_command("Strato/B777/".. fmskeyid .. "/key/period", "FMS1 Key '.'", fmsKeyFunc[fmsO.id]["funcs"]["key_period_CMDhandler"])
  B777CMD_fms1_key_minus              = deferred_command("Strato/B777/".. fmskeyid .. "/key/minus", "FMS1 Key '+/-'", fmsKeyFunc[fmsO.id]["funcs"]["key_minus_CMDhandler"])

  B777CMD_fms1_alphanum_key_A         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/A", "FMS1 Alpha/Numeric Key A", fmsKeyFunc[fmsO.id]["funcs"]["key_A_CMDhandler"])
  B777CMD_fms1_alphanum_key_B         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/B", "FMS1 Alpha/Numeric Key B", fmsKeyFunc[fmsO.id]["funcs"]["key_B_CMDhandler"])
  B777CMD_fms1_alphanum_key_C         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/C", "FMS1 Alpha/Numeric Key C", fmsKeyFunc[fmsO.id]["funcs"]["key_C_CMDhandler"])
  B777CMD_fms1_alphanum_key_D         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/D", "FMS1 Alpha/Numeric Key D", fmsKeyFunc[fmsO.id]["funcs"]["key_D_CMDhandler"])
  B777CMD_fms1_alphanum_key_E         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/E", "FMS1 Alpha/Numeric Key E", fmsKeyFunc[fmsO.id]["funcs"]["key_E_CMDhandler"])
  B777CMD_fms1_alphanum_key_F         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/F", "FMS1 Alpha/Numeric Key F", fmsKeyFunc[fmsO.id]["funcs"]["key_F_CMDhandler"])
  B777CMD_fms1_alphanum_key_G         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/G", "FMS1 Alpha/Numeric Key G", fmsKeyFunc[fmsO.id]["funcs"]["key_G_CMDhandler"])
  B777CMD_fms1_alphanum_key_H         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/H", "FMS1 Alpha/Numeric Key H", fmsKeyFunc[fmsO.id]["funcs"]["key_H_CMDhandler"])
  B777CMD_fms1_alphanum_key_I         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/I", "FMS1 Alpha/Numeric Key I", fmsKeyFunc[fmsO.id]["funcs"]["key_I_CMDhandler"])
  B777CMD_fms1_alphanum_key_J         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/J", "FMS1 Alpha/Numeric Key J", fmsKeyFunc[fmsO.id]["funcs"]["key_J_CMDhandler"])
  B777CMD_fms1_alphanum_key_K         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/K", "FMS1 Alpha/Numeric Key K", fmsKeyFunc[fmsO.id]["funcs"]["key_K_CMDhandler"])
  B777CMD_fms1_alphanum_key_L         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/L", "FMS1 Alpha/Numeric Key L", fmsKeyFunc[fmsO.id]["funcs"]["key_L_CMDhandler"])
  B777CMD_fms1_alphanum_key_M         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/M", "FMS1 Alpha/Numeric Key M", fmsKeyFunc[fmsO.id]["funcs"]["key_M_CMDhandler"])
  B777CMD_fms1_alphanum_key_N         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/N", "FMS1 Alpha/Numeric Key N", fmsKeyFunc[fmsO.id]["funcs"]["key_N_CMDhandler"])
  B777CMD_fms1_alphanum_key_O         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/O", "FMS1 Alpha/Numeric Key O", fmsKeyFunc[fmsO.id]["funcs"]["key_O_CMDhandler"])
  B777CMD_fms1_alphanum_key_P         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/P", "FMS1 Alpha/Numeric Key P", fmsKeyFunc[fmsO.id]["funcs"]["key_P_CMDhandler"])
  B777CMD_fms1_alphanum_key_Q         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/Q", "FMS1 Alpha/Numeric Key Q", fmsKeyFunc[fmsO.id]["funcs"]["key_Q_CMDhandler"])
  B777CMD_fms1_alphanum_key_R         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/R", "FMS1 Alpha/Numeric Key R", fmsKeyFunc[fmsO.id]["funcs"]["key_R_CMDhandler"])
  B777CMD_fms1_alphanum_key_S         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/S", "FMS1 Alpha/Numeric Key S", fmsKeyFunc[fmsO.id]["funcs"]["key_S_CMDhandler"])
  B777CMD_fms1_alphanum_key_T         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/T", "FMS1 Alpha/Numeric Key T", fmsKeyFunc[fmsO.id]["funcs"]["key_T_CMDhandler"])
  B777CMD_fms1_alphanum_key_U         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/U", "FMS1 Alpha/Numeric Key U", fmsKeyFunc[fmsO.id]["funcs"]["key_U_CMDhandler"])
  B777CMD_fms1_alphanum_key_V         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/V", "FMS1 Alpha/Numeric Key V", fmsKeyFunc[fmsO.id]["funcs"]["key_V_CMDhandler"])
  B777CMD_fms1_alphanum_key_W         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/W", "FMS1 Alpha/Numeric Key W", fmsKeyFunc[fmsO.id]["funcs"]["key_W_CMDhandler"])
  B777CMD_fms1_alphanum_key_X         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/X", "FMS1 Alpha/Numeric Key X", fmsKeyFunc[fmsO.id]["funcs"]["key_X_CMDhandler"])
  B777CMD_fms1_alphanum_key_Y         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/Y", "FMS1 Alpha/Numeric Key Y", fmsKeyFunc[fmsO.id]["funcs"]["key_Y_CMDhandler"])
  B777CMD_fms1_alphanum_key_Z         = deferred_command("Strato/B777/".. fmskeyid .. "/alphanum_key/Z", "FMS1 Alpha/Numeric Key Z", fmsKeyFunc[fmsO.id]["funcs"]["key_Z_CMDhandler"])

  B777CMD_fms1_key_space              = deferred_command("Strato/B777/".. fmskeyid .. "/key/space", "FMS1 KEY SP",fmsKeyFunc[fmsO.id]["funcs"]["key_space_CMDhandler"])
  B777CMD_fms1_key_del                = deferred_command("Strato/B777/".. fmskeyid .. "/key/del", "FMS1 KEY DEL", fmsKeyFunc[fmsO.id]["funcs"]["key_del_CMDhandler"])
  B777CMD_fms1_key_slash              = deferred_command("Strato/B777/".. fmskeyid .. "/key/slash", "FMS1 Key '/'", fmsKeyFunc[fmsO.id]["funcs"]["key_slash_CMDhandler"])
  B777CMD_fms1_key_clear              = deferred_command("Strato/B777/".. fmskeyid .. "/key/clear", "FMS1 KEY CLR", fmsKeyFunc[fmsO.id]["funcs"]["key_clear_CMDhandler"])
end

B777DR_backend_showSelWpt = {find_dataref("Strato/777/FMC/FMC_L/SEL_WPT/is_active"), find_dataref("Strato/777/FMC/FMC_R/SEL_WPT/is_active")}

function fms:B777_fms_display()

  local thisID = self.id

  local page=self.currentPage
  local fmsPage = fmsPages[page]:getPage(self.pgNo,thisID);
  local fmsPagesmall = fmsPages[page]:getSmallPage(self.pgNo,thisID);

  for i, input in ipairs(fmsPage) do
    local colorCount = select(2, input:gsub( ";", "")) -- how many ;'s are there
    if colorCount ~= 0 then -- if any
      local colorsCounted = 0
      local remainingInput = input

      local colors = {
        g = "",
        h = "",
        r = "",
        m = "",
        c = ""
      }
      local white = ""

      for match in input:gmatch(";") do
        colorsCounted = colorsCounted + 1
        local before, color, numChars, after = remainingInput:match("(.-);([ghrmc])(%d?%d)(.*)") -- syntax: ;cn where c = color (g/h/r/m/c) and n = num previous chars to color
        remainingInput = after
        numChars = tostring(numChars)
        local charsToColor = before:sub(-numChars, -1)

        local spaces = string.rep(" ", #before)

        for k, v in pairs(colors) do
          if k == color then
            colors[k] = v..string.rep(" ", #before-numChars)..charsToColor
          else
            colors[k] = v..spaces
          end
        end
        white = white..before:sub(1, -numChars-1)..string.rep(" ", numChars)

        if colorCount == colorsCounted then
          white = white..remainingInput
        end
      end

      B777DR_fms[thisID][i] = white
      B777DR_fms_gn[thisID][i] = colors.g
      B777DR_fms_hl[thisID][i] = colors.h
      B777DR_fms_gy[thisID][i] = colors.r
      B777DR_fms_m[thisID][i] =  colors.m
      B777DR_fms_c[thisID][i] =  colors.c
    else
      B777DR_fms[thisID][i] = input
      B777DR_fms_gn[thisID][i] = ""
      B777DR_fms_hl[thisID][i] = ""
      B777DR_fms_gy[thisID][i] = ""
      B777DR_fms_m[thisID][i] =  ""
      B777DR_fms_c[thisID][i] =  ""
    end
  end
  -- TODO: print an error message when invalid input. if you ever get an error around here check your color input... there is no safety in this code lol
  -- maybe i can check for chars to color being <= #previous chars as well as an cases where it doesn't match ;g00
  for i, input in ipairs(fmsPagesmall) do
    local colorCount = select(2, input:gsub( ";", ""))
    if colorCount ~= 0 then
      local colorsCounted = 0
      local hl = ""
      local white = ""
      local remainingInput = input

      for match in input:gmatch(";") do
        colorsCounted = colorsCounted + 1
        local before, numChars, after = remainingInput:match("(.-);h(%d?%d)(.*)")
        remainingInput = after
        numChars = tostring(numChars)
        local charsToColor = before:sub(-numChars, -1)

        hl = hl..string.rep(" ", #before-numChars)..charsToColor
        white = white..before:sub(1, -numChars-1)..string.rep(" ", numChars)

        if colorCount == colorsCounted then
          white = white..remainingInput
        end
      end
      B777DR_fms_s_hl[thisID][i] = hl
      B777DR_fms_s[thisID][i] = white
    else
      B777DR_fms_s_hl[thisID][i] = ""
      B777DR_fms_s[thisID][i] = input
    end
  end

  if newText[thisID] and (self.scratchpad == "" or not next(alertStack) or B777DR_cdu_act[thisID == "fmsL" and 0 or thisID == "fmsR" and 1 or 2] ~= 1) then
    newText[thisID] = false
  end

  self.scratchpad = self.scratchpad:len() > 24 and self.scratchpad:sub(1, 24) or self.scratchpad -- limit scratchpad length
  --[[for k, v in ipairs(alertStack) do
    print("alert "..k.." "..v)
  end
  for k, v in ipairs(self.dispMSG) do
    print("alert "..k.." "..v)
  end]]
  -- since com and alert messages display on all cdus, they have separate stacks
  if newText[thisID] then -- if typed while alert message
    B777DR_fms[thisID][14] = self.scratchpad;
  elseif next(alertStack) and B777DR_cdu_act[thisID == "fmsL" and 0 or thisID == "fmsR" and 1 or 2] == 1 then -- if alert message
    B777DR_fms[thisID][14] = alertStack[1]
  elseif next(commStack) then -- if comm message
    B777DR_fms[thisID][14] = commStack[1]
  elseif next(self.dispMSG) then -- if other messages
    B777DR_fms[thisID][14] = self.dispMSG[1].msg
  else
    B777DR_fms[thisID][14] = self.scratchpad;
  end
end

-- test vors not showing frequency
--[[  overview
clr needs extra click
key not active and readme dont show up until fmc act (change category)]]


--[[
either throw an exception when bad input (error())
or catch any exeptions when trying to do colors and output]]