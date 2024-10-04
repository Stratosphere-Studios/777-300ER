-- eicascheck.lua
-- Language: lua
-- Path: Custom Module\EICASCHECK\eicascheck.lua

size = { 1200, 1200 }
addSearchPath(moduleDirectory .. "/Custom Module/EICASCHECK")
addSearchPath(moduleDirectory .. "/Custom Module/CURSOR")
addSearchPath(moduleDirectory .. "/Custom Module/EICASCHECK/checklists")
addSearchPath(moduleDirectory .. "/Custom Module/EICASCHECK/assets")
include("checklist.lua")

local white = { 1, 1, 1, 1 }
local blue = { 1, 0.5, 1, 1 }
local cyan = { 0, 0.69, 0.69, 1 }
local black = { 0, 0, 0, 1 }
local color = { 1, 1, 1, 1 }
local grey = { 0.490, 0.490, 0.490, 1 }
local white = { 1.0, 1.0, 1.0, 1.0 }
local green = { 0, 1, 0, 1 }
local red = { 1, 0, 0, 1 }
local opensans = loadFont("BoeingFont.ttf")
local positionImage = loadImage("zYX5E.png")
local triRight = loadImage("tri.png")
local triLeft = loadImage("tri2.png")
local checkMark = loadImage("check.png")
local OverrideCheckBox = loadImage("OverrideCheckBox.png")
local ChecklistComplete = loadImage("ChecklistComplete.png")
local CheckOverridden = loadImage("CheckOverridden.png")
local ResetBox = loadImage("ResetBox.png")

--checklist property i just don't know where should i place
park_brake_valve = globalPropertyi("Strato/777/gear/park_brake_valve")
L_engn_off = globalProperty("sim/cockpit2/engine/actuators/mixture_ratio[0]")
R_engn_off = globalProperty("sim/cockpit2/engine/actuators/mixture_ratio[1]")
autobrk_pos = globalPropertyi("Strato/777/gear/autobrake_pos")
flaps = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 1)
gear_lever = globalPropertyi("sim/cockpit2/controls/gear_handle_down")
beacon_light = globalPropertyi("sim/cockpit/electrical/beacon_lights_on")
speedbrake_handle = globalPropertyf("sim/cockpit2/controls/speedbrake_ratio")
gear_deploy_ratio1 = globalPropertyfae("sim/flightmodel2/gear/deploy_ratio", 1)
gear_deploy_ratio2 = globalPropertyfae("sim/flightmodel2/gear/deploy_ratio", 2)

local previous_park_brake_valve = get(park_brake_valve)
local previous_L_engn_off = get(L_engn_off)
local previous_R_engn_off = get(R_engn_off)
local previous_autobrk_pos = get(autobrk_pos)
local previous_flaps = get(flaps)
local previous_gear_lever = get(gear_lever)
local previous_beacon_light = get(beacon_light)
local previous_speedbrake_handle = get(speedbrake_handle)
local previous_gear_deploy_ratio1 = get(gear_deploy_ratio1)
local previous_gear_deploy_ratio2 = get(gear_deploy_ratio2)

local lowEicasMode = globalPropertyf("Strato/777/displays/eicas_mode")

local page = 0

local homepagesurr = 0
local otherpagesurr = 0

local mainchecklists = {
    preflightchecklist,
    bfrstartchecklist,
    bfrtaxichecklist,
    bfrtakeoffchecklist,
    aftertakeoffchecklist,
    descentchecklist,
    approachecklist,
    landingchecklist,
    shutdownchecklist,
    securechecklist
}


local valueschecklist = {
    preflightchecklistvalues,
    bfrstartchecklistvalues,
    bfrtaxichecklistvalues,
    bfrtakeoffchecklistvalues,
    aftertakeoffchecklistvalues,
    descentchecklistvalues,
    approachecklistvalues,
    landingchecklistvalues,
    shutdownchecklistvalues,
    securechecklistvalues
}

local checklistnames = {
    'PREFLIGHT',
    'BEFORE START',
    'BEFORE TAXI',
    'BEFORE TAKEOFF',
    'AFTER TAKEOFF',
    'DESCENT',
    'APPROACH',
    'LANDING',
    'SHUTDOWN',
    'SECURE'
}

function parseHome(list, x, y)
    loc = 1
    col = "cel"
    pos = 95
    for i, v in pairs(list) do
        loc = loc + 95
        pos = pos + 50
        col = get(col) .. (tostring(get(pos)))
        drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 + x, 1188 + 17 - 4 - 25 + 2 +- get(loc) + y, 600 - 10, 85, grey)
        drawText(opensans, 25, 1100 - 150 + 475 - 200 + 10 - 30 - get(loc) + y, v, 38, false,
            false, TEXT_ALIGN_LEFT, white)
    end
end

function surroun(U)
    xs1 = 1100 - 450 + 70 - 90 + 17 + 15 - 655
    xs2 = 1188 + 17 - 4 - 25 + 2 - 1 - 150 + U
    drawRectangle(get(xs1), get(xs2), 595, 5, white)
    drawRectangle(get(xs1), get(xs2), 5, 85, white)
    drawRectangle(get(xs1), get(xs2) + 85, 595, 5, white)
    drawRectangle(get(xs1) + 590, get(xs2), 5, 85, white)
end

function surroun2(U)
    xs12 = 15
    xs22 = 990 + U
    drawRectangle(get(xs12), get(xs22) - 5, 1095, 7, white)
    drawRectangle(get(xs12), get(xs22), 7, 60, white)
    drawRectangle(get(xs12), get(xs22) + 60, 1095, 7, white)
    drawRectangle(get(xs12) + 1095 - 7, get(xs22), 7, 60, white)
end

function surroun3(U)
    xs12 = 113
    xs22 = 987 + U
    drawRectangle(get(xs12), get(xs22) + 6, 987, 5, white)
    drawRectangle(get(xs12), get(xs22) + 6, 5, 56, white)
    drawRectangle(get(xs12), get(xs22) + 57, 987, 5, white)
    drawRectangle(get(xs12) + 987 - 3, get(xs22) + 6, 5, 56, white)
end

function surrounbottom(U)
    xs12 = 1100 - 450 + 70 - 90 + 17 + 15 - 655
    xs22 = 92 + U
    drawRectangle(get(xs12), get(xs22) + 6, 180, 5, white)
    drawRectangle(get(xs12), get(xs22) + 6, 5, 92, white)
    drawRectangle(get(xs12), get(xs22) + 92 + 1, 180, 5, white)
    drawRectangle(get(xs12) + 180 - 3, get(xs22) + 6, 5, 92, white)
end

function chklDraw(tbl, valtbl)
    local yVal = 0
    local ChklDrawCol = { 1, 1, 1, 1 }
    for i, v in pairs(tbl) do
        if (valtbl[i] == 1) then
            ChklDrawCol = { 0, 1, 0, 1 }
            drawRectangle(35, 990 - 61 + yVal, 50, 50, grey)
            drawTexture(checkMark, 37, 990 - 59 + yVal, 45, 45, white)
        elseif (valtbl[i] == 2) then
            ChklDrawCol = { 0, 1, 0, 1 }
            drawRectangle(35, 990 - 61 + yVal, 50, 50, grey)
            drawTexture(checkMark, 37, 990 - 59 + yVal, 45, 45, white)
        elseif (valtbl[i] == 3) then
            ChklDrawCol = { 1, 1, 1, 1 }
        elseif (valtbl[i] == 4) then
            ChklDrawCol = { 0, 1, 0, 1 }
            drawTexture(checkMark, 37, 990 - 59 + yVal, 45, 45, white)
        elseif (valtbl[i] == 5) then --Override without box
            ChklDrawCol = { 0, 0.7, 0.7, 1 }
            drawTexture(OverrideCheckBox,35, 990 - 61 + yVal, 50, 50, cyan)
        elseif (valtbl[i] == 6) then --Override with box
            ChklDrawCol = { 0, 0.7, 0.7, 1 }
        elseif (valtbl[i] == 7) then --Override with box checked
            ChklDrawCol = { 0, 0.7, 0.7, 1 }
            drawTexture(checkMark, 37, 990 - 59 + yVal, 45, 45, white)
        else
            ChklDrawCol = { 1, 1, 1, 1 }
            drawRectangle(35, 990 - 61 + yVal, 50, 50, grey)
        end
        yVal = yVal - 66
        drawText(opensans, 120, 1000 + yVal, tbl[i], 50, false, false, TEXT_ALIGN_LEFT, ChklDrawCol)
    end
end

function NonCheckparseHome(list, x, y)
    loc1 = 1
    loc2 = 1
    col = "cel"
    pos = 95
    for i, v in pairs(list) do
        extra = 0
        pos = pos + 50
        col = get(col) .. (tostring(get(pos)))
        if v:find("\n") then
            extra = 45 / 2
        end
        if i <= 10 then
            loc1 = loc1 + 95
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 + x, 1188 + 17 - 4 - 25 + 2 +- get(loc1) + y, 600 - 10, 85, grey)
            drawText(opensans, 25, 1100 - 150 + 475 - 200 + 10 - 30 - get(loc1) + y + extra, v, 38, false,
                false, TEXT_ALIGN_LEFT, white)
        else
            loc2 = loc2 + 95
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 + 600 + x, 1188 + 17 - 4 - 25 + 2 +- get(loc2) + y, 600 - 10, 85, grey)
            drawText(opensans, 25 + 600, 1100 - 150 + 475 - 200 + 10 - 30 - get(loc2) + y + extra, v, 38, false,
                false, TEXT_ALIGN_LEFT, white)
        end
    end
end

function veryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM(num)
    local tempYveryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM = 0

    for i = 0, num, 1 do
        components[#components + 1] = interactive {
            position = { 0,
                990 +
                tempYveryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM,
                1200, 50 },

            onMouseDown = function()
                local currentChecklistname
                local currentChecklistvalues

                if page >= 1 and page <= 10 then
                    currentChecklistname = mainchecklists[page]
                    currentChecklistvalues = valueschecklist[page]
                end


                if (currentChecklistvalues[i] == 0) then
                    currentChecklistvalues[i] = 1
                elseif (currentChecklistvalues[i] == 1) then
                    currentChecklistvalues[i] = 0
                end
            end,
            
            onMouseMove = function()
                otherpagesurr = i
                return true
            end,

            onMouseLeave = function()
                -- otherpagesurr = 0
                -- exhibit A.
                return true
            end,
        }
        tempYveryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM =
            tempYveryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM - 66
    end

    components[#components + 1] = interactive {

        position = { 1100 - 450 + 70 - 90 + 17 + 15 - 655, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92 },

        onMouseDown = function()
            page = 0
        end

    }

    components[#components + 1] = interactive {
        position = { 397 , 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92 },
        onMouseDown = function()
            page = 11
        end
    }

    components[#components + 1] = interactive {
        position = { 1100 - 450 + 70 - 90 + 17 + 15 - 655 + 393 + 393, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92 },
        onMouseDown = function()
            page = 12
        end
    }

    components[#components + 1] = interactive {
        position = { 10, 10, 180, 92 },
        onMouseDown = function()
            if checklistAllDone(get(page)) == 1 or checklistAllDone(get(page)) == 2 then
                if page >= 1 and page < 10 then
                    page = page + 1
                end
            else
                NormalButton(get(page))
            end
        end
    }
    
    components[#components + 1] = interactive {
        position = { 210, 10, 180, 92 },
        onMouseDown = function()
            if checklistAllDone(get(page)) ~= 1 and checklistAllDone(get(page)) ~= 2 then
                ItemOverride(get(page))
            end
        end
    }

    components[#components + 1] = interactive {
        position = { 605 + 5, 10, 180, 92 },
        onMouseDown = function()
            ChecklistOverride(get(page))
        end
    }


    components[#components + 1] = interactive {
        position = { 800 + 10, 10, 180, 92 },
        onMouseDown = function()
            ChecklistReset(get(page))
        end
    }
end



function NoCheckAvail()
    local current_park_brake_valve = get(park_brake_valve)
    local current_L_engn_off = get(L_engn_off)
    local current_R_engn_off = get(R_engn_off)
    local current_autobrk_pos = get(autobrk_pos)
    local current_flaps = get(flaps)
    local current_beacon_light = get(beacon_light)
    local current_gear_lever = get(gear_lever)
    local current_speedbrake_handle = get(speedbrake_handle)
    local current_gear_deploy_ratio1 = get(gear_deploy_ratio1)
    local current_gear_deploy_ratio2 = get(gear_deploy_ratio2)
    

    --methods(current value, previous value, enable value, checklist page, item in list) i'm so smart
    --preflightchecklist
    NoCheckAvailRun(current_park_brake_valve, previous_park_brake_valve, 1, 1, 3)
    
    --bfrstartchecklist
    NoCheckAvailRun(current_beacon_light, previous_beacon_light, 1, 2, 8)
    
    --bfrtaxichecklist
    NoCheckAvailRun(current_autobrk_pos, previous_autobrk_pos, -3, 3, 3)
    
    --bfrtakeoffchecklist TODO: flaps waiting for FMC dataref
    
    --aftertakeoffchecklist
    NoCheckAvailRun(current_flaps, previous_flaps, 0, 5, 2)
    if current_gear_deploy_ratio1 == 0 and current_gear_deploy_ratio2 == 0 then
        NoCheckAvailRun(current_gear_deploy_ratio1, previous_gear_deploy_ratio1, 0, 5, 1)
    end

    --landingchecklist TODO: flaps waiting for FMC dataref
    if current_gear_deploy_ratio1 == 1 and current_gear_deploy_ratio2 == 1 then
        NoCheckAvailRun(current_gear_deploy_ratio1, previous_gear_deploy_ratio1, 1, 8, 2)
    end
    NoCheckAvailRun(current_speedbrake_handle, previous_speedbrake_handle, -1, 8, 1)

    --shutdownchecklist huh?
    
    --preflightchecklist & shutdownchecklist 
    if current_L_engn_off == 0 and current_R_engn_off == 0 then
        NoCheckAvailRun(current_L_engn_off, previous_L_engn_off, 0, 1, 4)
        NoCheckAvailRun(current_R_engn_off, previous_R_engn_off, 0, 1, 4)
    end
end

function NoCheckAvailRun(current_value, previous_value, enable, page, item)
    if current_value ~= previous_value or current_value == enable then
        local currentChecklistvalues = valueschecklist[page]
        if checklistAllDone(page) ~= 2 then --if return 2 all should static
            if current_value == enable then
                currentChecklistvalues[item] = 4
            else
                currentChecklistvalues[item] = 3
            end
        end
        previous_value = current_value
    end
end

components = {}
function update()
    NoCheckAvail()
    components = {}
    if (get(page) == 0) then
        for i = 0, 10, 1 do
            components[#components + 1] = interactive {
                position = { 1100 - 450 + 70 - 90 - 150 + 17 + 15 - 655, 1188 + 17 - 75 - 4 - 25 + 2 - 1 - 76 - (97 * i), 390, 92 },

                onMouseDown = function()
                    page = i
                end,

                onMouseMove = function()
                    homepagesurr = i
                    return true
                end,

                onMouseLeave = function()
                    --  homepagesurr = 0
                    return true
                end
            }
        end
    end

    if (get(page) == 12) then
        for i = 0, 10, 1 do
            components[#components + 1] = interactive {
                position = { 1100 - 450 + 70 - 90 - 150 + 17 + 15 - 655, 1188 + 17 - 75 - 4 - 25 + 2 - 1 - 76 - (97 * i), 390, 92 },

                onMouseDown = function()
                    -- page = i
                end,

                onMouseMove = function()
                    homepagesurr = i
                    return true
                end,

                onMouseLeave = function()
                    --  homepagesurr = 0
                    return true
                end
            }
        end

        for i = 0, 6, 1 do
            components[#components + 1] = interactive {
                position = { 1100 - 450 + 70 - 90 - 150 + 17 + 15 - 655 + 600, 1188 + 17 - 75 - 4 - 25 + 2 - 1 - 76 - (97 * i), 390, 92 },

                onMouseDown = function()
                    -- page = i
                end,

                onMouseMove = function()
                    NonNormalhomepagesurr = i
                    return true
                end,

                onMouseLeave = function()
                    --  homepagesurr = 0
                    return true
                end
            }
        end
    end
    --------------------------------------------------------------------------------------

    local page = get(page)

    local actions = {
        [1] = function()
            veryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM(4)
        end,
        [2] = function()
            veryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM(8)
        end,
        [3] = function()
            veryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM(5)
        end,
        [4] = function()
            veryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM(1)
        end,
        [5] = function()
            veryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM(2)
        end,
        [6] = function()
            veryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM(5)
        end,
        [7] = function()
            veryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM(1)
        end,
        [8] = function()
            veryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM(3)
        end,
        [9] = function()
            veryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM(5)
        end,
        [10] = function()
            veryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM(3)
        end
    }

    if actions[page] then
        actions[page]()
    end
end

function NormalButton(page)
    local currentChecklistname
    local currentChecklistvalues
    local num = 1 --startup change

    if page >= 1 and page <= 10 then
        currentChecklistname = mainchecklists[page]
        currentChecklistvalues = valueschecklist[page]
    end

    for i, value in ipairs(currentChecklistvalues) do
        if value == 0 then
            currentChecklistvalues[num] = 1
            break
        else
            num = num + 1
        end
    end
end

function ItemOverride(page)
    local currentChecklistname
    local currentChecklistvalues
    local num = 1

    if page >= 1 and page <= 10 then
        currentChecklistname = mainchecklists[page]
        currentChecklistvalues = valueschecklist[page]
    end

    for i, value in ipairs(currentChecklistvalues) do
        if value == 0 then
            currentChecklistvalues[num] = 5
            break
        elseif value == 3 then
            currentChecklistvalues[num] = 6
            break
        else
            num = num + 1
        end
    end
end

function ChecklistOverride(page)
    local currentChecklistname
    local currentChecklistvalues

    if page >= 1 and page <= 10 then
        currentChecklistname = mainchecklists[page]
        currentChecklistvalues = valueschecklist[page]
    end

    for i, value in ipairs(currentChecklistvalues) do
        if value == 0 or value == 2 then
            currentChecklistvalues[i] = 5
        elseif value == 3 then
            currentChecklistvalues[i] = 6
        elseif value == 1 or value == 4 then
            currentChecklistvalues[i] = 7
        end
    end
end

function ChecklistReset(page)
    local currentChecklistvalues
    if page >= 1 and page <= 10 then
        currentChecklistvalues = valueschecklist[page]
        for i, value in ipairs(currentChecklistvalues) do
            if value == 1 or value == 4 or value == 5 or value == 7 then
                currentChecklistvalues[i] = 0
            elseif value == 2 or value == 6 then
                currentChecklistvalues[i] = 3
            end
        end
    end
end

function checklistAllDone(page)
    if page >= 1 and page <= 10 then
        local currentChecklistvalues = valueschecklist[page]
        local allOverridden = true
        for i, value in ipairs(currentChecklistvalues) do
            if value == 0 or value == 3 then
                return 0 -- Zero or 3 found, return false
            elseif value ~= 5 and value ~= 6 and value ~= 7 then
                allOverridden = false
            end
        end
        if allOverridden then
            return 2 -- All values are either 5, 6, or 7
        else
            return 1 -- No zeros or 3s found, but not all are 5, 6, or 7
        end
    else
        return 0 -- Invalid page, return false (base case)
    end
end

function ResetBeforeTakeoff()
    local currentChecklistvalues
    currentChecklistvalues = valueschecklist[4] --before takeoff page
    for i, value in ipairs(currentChecklistvalues) do
        if value ~= 3 and value ~= 0 then
            drawRectangle(1200 / 2, 990 - 20 - 10 - 92 - 45, 1200 / 2 - 7, 92, grey)
            drawText(opensans, 600 + 20, 990 - 20 - 4 - 90 - 45 / 2, "RESET BEFORE TAKEOFF", 45, false, false, TEXT_ALIGN_LEFT, white)
            components[#components + 1] = interactive {
                position = { 1200 / 2, 990 - 20 - 10 - 92 - 45, 1200 / 2 - 7 - 7, 92 },
                onMouseDown = function()
                    ChecklistReset(4)
                end
            }
        end
    end
end

function ResetNormal()
    components[#components + 1] = interactive {
        position = { 7, 990 - 20 - 10 - 92 - 45, 1200 / 2 - 7, 92 },
        onMouseDown = function()
            for i = 0, 10, 1 do
                ChecklistReset(i)
            end
        end
    }
end

function ResetAll()
    components[#components + 1] = interactive {
        position = { 7, 990 - 20 - 10 - 92 - 45 - 92 - 10 - 92 - 10, 1200 / 2 - 7 - 7, 92 },
        onMouseDown = function()
            for i = 0, 10, 1 do
                ChecklistReset(i)
            end
        end
        --TODO: reset non-normal
    }
end

function draw()
    if get(lowEicasMode) == 10 then
        drawRectangle(0, 0, 4096, 4096, black)
        if page >= 1 and page <= 10 then
            if checklistAllDone(get(page)) == 1 then
                drawTexture(ChecklistComplete, 725 / 2, 110, 475, 55, white)
                drawText(opensans, 1200 / 2, 120, "Checklist Complete", 45, false, false, TEXT_ALIGN_CENTER, white)
                drawRectangle(10 + 225, 10, 215, 92,black)
            elseif checklistAllDone(get(page)) == 2 then
                drawTexture(CheckOverridden, 725 / 2, 110, 475, 55, white)
                drawText(opensans, 1200 / 2, 120, "Checklist Overridden", 45, false, false, TEXT_ALIGN_CENTER, white)
                drawRectangle(10 + 225, 10, 215, 92,black)
            else
                drawRectangle(210, 10, 180, 92,grey)
                drawText(opensans, 210 + 90, 57,"ITEM", 45, false, false, TEXT_ALIGN_CENTER, white)
                drawText(opensans, 210 + 90, 17,"OVRD", 45, false, false, TEXT_ALIGN_CENTER, white)
            end
        end
        if get(page) == 0 then
            drawText(opensans, 1200 / 2, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90, "NORMAL MENU", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, green)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75, "NORMAL MENU", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655 + 393, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655 + 393, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75, "RESETS", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655 + 393 + 393, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655 + 393 + 393, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75, "NON-NORMAL MENU", 45, false, false, TEXT_ALIGN_CENTER, white)
        elseif get(page) == 11 then
            drawText(opensans, 1200 / 2, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90, "RESETS", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75, "NORMAL MENU", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655 + 393, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, green)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655 + 393, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75, "RESETS", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655 + 393 + 393, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655 + 393 + 393, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75, "NON-NORMAL MENU", 45, false, false, TEXT_ALIGN_CENTER, white)
        elseif get(page) == 12 then
            drawText(opensans, 1200 / 2, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90, "NON-NORMAL", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75, "NORMAL MENU", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655 + 393, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655 + 393, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75, "RESETS", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655 + 393 + 393, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, green)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655 + 393 + 393, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75, "NON-NORMAL MENU", 45, false, false, TEXT_ALIGN_CENTER, white)
        else
            get(page ~= 1)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75, "NORMAL MENU", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655 + 393, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655 + 393, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75, "RESETS", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655 + 393 + 393, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655 + 393 + 393, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75, "NON-NORMAL MENU", 45, false, false, TEXT_ALIGN_CENTER, white)
            --bottom
            drawRectangle(10, 10, 180, 92,grey)
            drawText(opensans, 100, 37,"NORMAL", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(605 + 5, 10, 180, 92,grey)
            drawText(opensans, 1200 / 2 + 95 + 5, 57,"CHKL", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawText(opensans, 1200 / 2 + 95 + 5, 17,"OVRD", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(800 + 10, 10, 180, 92,grey)
            drawText(opensans, 1200 / 2 + 210 + 90, 57,"CHKL", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawText(opensans, 1200 / 2 + 210 + 90, 17,"RESET", 45, false, false, TEXT_ALIGN_CENTER, white)
        end
        --normal function
        if get(page) == 0 then
            parseHome(checklisthome, -655, -150)
            if get(homepagesurr ~= 0) then
                surroun(-95 * (get(homepagesurr)))
            end
        elseif get(page) == 12 then
            NonCheckparseHome(NonNormal, -655, -150)
            --i just lazy to do surron 
        end
        
        if page >= 1 and page <= 10 then
            local currentChecklistname
            local currentChecklistvalues
            local checklistTitle = checklistnames[page]
            local foundZero = false
            
            currentChecklistname = mainchecklists[page]
            currentChecklistvalues = valueschecklist[page]
            
            drawText(opensans, 1200 / 2, 1200 - 145, checklistTitle, 45, false, false, TEXT_ALIGN_CENTER, white)
            chklDraw(currentChecklistname, currentChecklistvalues)
            if (get(otherpagesurr) ~= 0) then
                if currentChecklistvalues[otherpagesurr] ~= 3 and currentChecklistvalues[otherpagesurr] ~= 6 then
                    surroun2(-66 * (get(otherpagesurr)))
                end
                surroun3(-66 * (get(otherpagesurr)))
            else
                for i, value in ipairs(currentChecklistvalues) do
                    if value == 0 then
                        surroun3(-66 * i)  -- Execute when `0` is found
                        foundZero = true
                        break  -- Stop loop once `0` is found
                    end
                end

                -- If no `0` was found, check for `3`
                if not foundZero then
                    for i, value in ipairs(currentChecklistvalues) do
                        if value == 3 then
                            surroun3(-66 * i)  -- Execute when `3` is found
                            break
                        end
                    end
                end
            end
        end

        components[#components + 1] = interactive {
            position = { 1100 - 450 + 70 - 90 + 17 + 15 - 655, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92 },
            onMouseDown = function()
                page = 0
            end
        }
    
        components[#components + 1] = interactive {
            position = { 397 , 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92 },
            onMouseDown = function()
                page = 11
            end
        }

        components[#components + 1] = interactive {
            position = { 1100 - 450 + 70 - 90 + 17 + 15 - 655 + 393 + 393, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92 },
            onMouseDown = function()
                page = 12
            end
        }
        
        --commiat
        
        --PAGE FUCTNIONALS
        if get(page) == 1 then
                drawTexture(triRight, 475, 1200 - 145, 25, 32.6, white)
                drawTexture(triLeft, 375 - 5 + 295 + 30, 1200 - 145, 25, 32.6, white)
            elseif get(page) == 2 then
                drawTexture(triRight, 440, 1200 - 145, 25, 32.6, white)
                drawTexture(triLeft, 375 + 30 + 295 + 30, 1200 - 145, 25, 32.6, white)
            elseif get(page) == 3 then
                drawTexture(triRight, 450, 1200 - 145, 25, 32.6, white)
                drawTexture(triLeft, 720, 1200 - 145, 25, 32.6, white)
            elseif get(page) == 4 then
                drawTexture(triRight, 415, 1200 - 145, 25, 32.6, white)
                drawTexture(triLeft, 755, 1200 - 145, 25, 32.6, white)
            elseif get(page) == 5 then
                drawTexture(triRight, 430, 1200 - 145, 25, 32.6, white)
                drawTexture(triLeft, 745, 1200 - 145, 25, 32.6, white)
            elseif get(page) == 6 then
                drawTexture(triRight, 495, 1200 - 145, 25, 32.6, white)
                drawTexture(triLeft, 675, 1200 - 145, 25, 32.6, white)
            elseif get(page) == 7 then
                drawTexture(triRight, 490, 1200 - 145, 25, 32.6, white)
                drawTexture(triLeft, 690, 1200 - 145, 25, 32.6, white)
            elseif get(page) == 8 then
                drawTexture(triRight, 495, 1200 - 145, 25, 32.6, white)
                drawTexture(triLeft, 680, 1200 - 145, 25, 32.6, white)
            elseif get(page) == 9 then
                drawTexture(triRight, 485, 1200 - 145, 25, 32.6, white)
                drawTexture(triLeft, 690, 1200 - 145, 25, 32.6, white)
            elseif get(page) == 10 then
                drawTexture(triRight, 510, 1200 - 145, 25, 32.6, white)
                drawTexture(triLeft, 665, 1200 - 145, 25, 32.6, white)
            elseif get(page) == 11 then
                drawTexture(ResetBox, 7, 990 - 65, 1200 - 7 - 7, 99, white)
                drawText(opensans, 20, 990 - 10, "AIRLINE DATABASE", 45, false, false, TEXT_ALIGN_LEFT, white)
                drawText(opensans, 20, 990 - 10 - 45, "STTS-000-002", 45, false, false, TEXT_ALIGN_LEFT, white)
                drawText(opensans, 600 + 20, 990 - 10, "EFFECTIVE DATE", 45, false, false, TEXT_ALIGN_LEFT, white)
                drawText(opensans, 600 + 20, 990 - 10 - 45, "  - -  ", 45, false, false, TEXT_ALIGN_LEFT, white)
                drawRectangle(7, 990 - 20 - 10 - 92 - 45, 1200 / 2 - 7 - 7, 92, grey)
                drawText(opensans, 7 + 20, 990 - 20 - 4 - 90 - 45 / 2, "RESET NORMAL", 45, false, false, TEXT_ALIGN_LEFT, white)
                drawRectangle(7, 990 - 20 - 10 - 92 - 45 - 92 - 10, 1200 / 2 - 7 - 7, 92, grey)
                drawText(opensans, 7 + 20, 990 - 20 - 4 - 90 - 92 - 10 - 45 / 2, "RESET NON-NORMAL", 45, false, false, TEXT_ALIGN_LEFT, white)
                drawRectangle(7, 990 - 20 - 10 - 92 - 45 - 92 - 10 - 92 - 10, 1200 / 2 - 7 - 7, 92, grey)
                drawText(opensans, 7 + 20, 990 - 20 - 4 - 90 - 92 - 10 - 92 - 10 - 45 / 2, "RESET ALL", 45, false, false, TEXT_ALIGN_LEFT, white)
                ResetBeforeTakeoff()
                ResetNormal()
                ResetAll()
            end
        end
    end