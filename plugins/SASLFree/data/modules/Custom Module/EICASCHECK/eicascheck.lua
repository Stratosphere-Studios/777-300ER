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


flaps = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 1)

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
    xs12 = 113
    xs22 = 987 + U
    drawRectangle(get(xs12), get(xs22) + 6, 987, 5, white)
    drawRectangle(get(xs12), get(xs22) + 6, 5, 56, white)
    drawRectangle(get(xs12), get(xs22) + 57, 987, 5, white)
    drawRectangle(get(xs12) + 987 - 3, get(xs22) + 6, 5, 56, white)
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
        elseif (valtbl[i] == 5) then --Override without checkbox
            ChklDrawCol = { 0, 0.7, 0.7, 1 }
            drawTexture(OverrideCheckBox,35, 990 - 61 + yVal, 50, 50, cyan)
        elseif (valtbl[i] == 6) then --Override with checkbox
            ChklDrawCol = { 0, 0.7, 0.7, 1 }
        elseif (valtbl[i] == 7) then --Override with checkbox
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
                --otherpagesurr = 0
                --exhibit A.
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
        position = { 605 + 5, 10, 180, 92 },
        onMouseDown = function()
            ChecklistOverride(get(page))
        end
    }

    -- components[#components + 1] = interactive {
    --     position = { 800 + 10, 10, 180, 92 },
    --     onMouseDown = function()
    --         ChecklistReset(get(page))
    --     end
    -- }
end

components = {}
function update()
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
    local num = 1

    if page >= 1 and page <= 10 then
        currentChecklistname = mainchecklists[page]
        currentChecklistvalues = valueschecklist[page]
    end

    for i, value in ipairs(currentChecklistvalues) do
        if value == 0 then
            currentChecklistvalues[num] = 1
            return
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
        if value == 0 or value == 1 or value == 2 then
            currentChecklistvalues[i] = 5
        elseif value == 3 then
            currentChecklistvalues[i] = 6
        elseif value == 4 then
            currentChecklistvalues[i] = 7
        end
    end
end

--TODO: reset
--[[
    function ChecklistReset(page)
        local currentChecklistname
        local currentChecklistvalues
        if page >= 1 and page <= 10 then
            currentChecklistname = mainchecklists[page]
            currentChecklistvalues = valueschecklist[page]
        end
    end
--]]

function checklistAllDone(page)
    if page >= 1 and page <= 10 then
        local currentChecklistvalues = valueschecklist[page]
        for i, value in ipairs(currentChecklistvalues) do
            if value == 0 or value == 3 then
                return 0 -- Zero found, return false
            elseif value ~= 0 and value ~= 1 and value ~= 2 and value ~= 3 and value ~= 4 then
                return 2 --all overrideen
            end
        end
        return 1  -- No zeros found, return true
    else
        return 0 -- Invalid page, return false (base case)
    end
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
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75, "NORMAL MENU", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655 + 393, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, green)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655 + 393, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75, "RESETS", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655 + 393 + 393, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655 + 393 + 393, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75, "NON-NORMAL MENU", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawText(opensans, 1200 / 2, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90, "RESETS", 45, false, false, TEXT_ALIGN_CENTER, white)
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
            drawText(opensans, 105, 37,"NORMAL", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(605 + 5, 10, 180, 92,grey)
            drawText(opensans, 1200 / 2 + 95 + 5, 57,"CHKL", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawText(opensans, 1200 / 2 + 95 + 5, 17,"OVRD", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(800 + 10, 10, 180, 92,grey)
            drawText(opensans, 1200 / 2 + 210 + 90, 57,"CHKL", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawText(opensans, 1200 / 2 + 210 + 90, 17,"RESET", 45, false, false, TEXT_ALIGN_CENTER, white)

            --TODO: non-normal page
            --drawRectangle(410, 10, 180, 92,grey)
            --drawText(opensans, 410 + 90, 37,"NOTES", 45, false, false, TEXT_ALIGN_CENTER, white)
            --drawRectangle(1000 + 10, 10, 180, 92,grey)
            --drawText(opensans, 1000 + 10 + 90, 57,"NON-", 45, false, false, TEXT_ALIGN_CENTER, white)
            --drawText(opensans, 1000 + 10 + 90, 17,"NORMAL", 45, false, false, TEXT_ALIGN_CENTER, white)
        end
        --normal function
        if get(page) == 0 then
            parseHome(checklisthome, -655, -150)
            if get(homepagesurr ~= 0) then
                surroun(-95 * (get(homepagesurr)))
            end
        end
        
        if page >= 1 and page <= 10 then
            local currentChecklistname
            local currentChecklistvalues
            local checklistTitle = checklistnames[page]
            
            currentChecklistname = mainchecklists[page]
            currentChecklistvalues = valueschecklist[page]
            
            drawText(opensans, 1200 / 2, 1200 - 145, checklistTitle, 45, false, false, TEXT_ALIGN_CENTER, white)
            chklDraw(currentChecklistname, currentChecklistvalues)
            if (get(otherpagesurr) ~= 0) then
                for i, value in ipairs(currentChecklistvalues) do
                    if value ~= 3 then
                        surroun2(-66 * (get(otherpagesurr)))
                        break
                    end
                end
                surroun3(-66 * (get(otherpagesurr)))
            end
        end
        
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
            end
        end
    end