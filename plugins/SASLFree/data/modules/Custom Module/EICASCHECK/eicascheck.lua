--eicascheck.lua
-- Language: lua
-- Path: Custom Module\EICASCHECK\eicascheck.lua
size = {1200, 1200}
addSearchPath(moduleDirectory .. "/Custom Module/EICASCHECK")
addSearchPath(moduleDirectory .. "/Custom Module/CURSOR")
addSearchPath(moduleDirectory .. "/Custom Module/EICASCHECK/checklists")
addSearchPath(moduleDirectory .. "/Custom Module/EICASCHECK/assets")
include("checklist.lua")

local white = {1, 1, 1, 1}
local blue = {1, 0.5, 1, 1}
local black = {0, 0, 0, 1}
local color = {1, 1, 1, 1}
local grey = {0.490, 0.490, 0.490, 1}
local white = {1.0, 1.0, 1.0, 1.0}
local green = {0, 1, 0, 1}
local red = {1, 0, 0, 1}
local opensans = loadFont("BoeingFont.ttf")
local positionImage = loadImage("zYX5E.png")
local triRight = loadImage("tri.png")
local triLeft = loadImage("tri2.png")
local checkMark = loadImage("check.png")


local lowEicasMode = globalPropertyf("Strato/777/displays/eicas_mode")

local page = 0


local homepagesurr = 0
local otherpagesurr = 0




function parseHome(list, x, y) 
    loc = 1
    col = "cel"
    pos = 0
    for i, v in pairs(list) do
        loc = loc + 95
        pos = pos + 50
        col = get(col) .. (tostring(get(pos)))
        drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 + x, 1188 + 17 - 4 - 25 + 2 - get(loc) + y, 390, 92, grey)
        drawText(opensans, 1100 - 400 + 150 + 15 - 15 + x, 1100 - 150 + 475 - 200 + 10 - 30 - get(loc) + y, v, 38, false, false, TEXT_ALIGN_CENTER, white)
    end
end

function surroun(U)
    xs1 = 1100 - 450 + 70 - 90 + 17 + 15 -655
    xs2 = 1188 + 17 - 4 - 25 + 2 - 1 -76 + U
    drawRectangle(get(xs1), get(xs2), 390, 3, white)
    drawRectangle(get(xs1), get(xs2), 3, 95, white)
    drawRectangle(get(xs1), get(xs2) + 92, 390, 3, white)
    drawRectangle(get(xs1) + 387, get(xs2), 3, 95, white)
end

function surroun2(U)
    xs12 = 0
    xs22 = 990 + U
    drawRectangle(get(xs12), get(xs22), 1200, 3, white)
    drawRectangle(get(xs12), get(xs22), 3, 55, white)
    drawRectangle(get(xs12), get(xs22) + 55, 1200, 3, white)
    drawRectangle(get(xs12) + 1200 - 3, get(xs22), 3, 55, white)
end



function chklDraw(tbl, valtbl)
    local yVal = 0
    local ChklDrawCol = {1, 1, 1, 1}
    for i, v in pairs(tbl) do 
        if (valtbl[i] == 1) then
            ChklDrawCol = {0, 1, 0, 1}
            drawTexture(checkMark, 10, 990-61+yVal, 50, 50, white) 
        elseif (valtbl[i] == 2) then
            ChklDrawCol = {0, 1, 0, 1}
            drawTexture(checkMark, 10, 990-61+yVal, 50, 50, white) 
        elseif (valtbl[i] == 3) then
            ChklDrawCol = {1, 1, 1, 1}
        else
            ChklDrawCol = {1, 1, 1, 1}
            drawRectangle(10, 990-61 +yVal, 50, 50, grey) 
        end
        yVal = yVal - 65
        drawText(opensans, 120, 1000+yVal, tbl[i], 50, false, false, TEXT_ALIGN_LEFT, ChklDrawCol)
        
    end
end


function veryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM(num)
    local tempYveryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM = 0
    for i = 0, num, 1 do 
        components[#components+1] = interactive {
            position = {0, 990+tempYveryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM, 1200, 50},

            onMouseDown = function()
                if (bfrstartchecklistvalues[i]==0) then
                    bfrstartchecklistvalues[i] = 1
                elseif (bfrstartchecklistvalues[i]==1) then
                    bfrstartchecklistvalues[i] = 0
                end
            end,
            
            onMouseMove = function()
                otherpagesurr = i
                return true
            end,
        
            onMouseLeave = function()
                otherpagesurr = 0
                return true
            end
        }
        tempYveryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM = tempYveryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM - 65
    end

    components[#components+1] = interactive {
                
        position = {1100 - 450 + 70 - 90 + 17 + 15 - 655 , 1188 + 17 - 4 - 25 + 2 - 1 -76, 390, 92},

        onMouseDown = function()
            page = 0
        end
    
    }

end






components = {}
function update()
    components = {}
    if (get(page) == 0) then
        for i=0, 10, 1 do 
            
            components[#components+1] = interactive {
                
                position = {1100 - 450 + 70 - 90 + 17 + 15 - 655 , 1188 + 17 - 4 - 25 + 2 - 1 -76 - (97*i), 390, 92},

                onMouseDown = function()
                    page = i
                end,
                
                onMouseMove = function()
                    homepagesurr = i
                    return true
                end,
            
                onMouseLeave = function()
                    homepagesurr = 0
                    return true
                end
            
            }
        end
    end
    --------------------------------------------------------------------------------------
    if (get(page) == 2) then
        veryEfficientAndShortAndSmartAndNiceFunctionThatIGuessGetsTheJobDoneMadeByProfessionalProgrammerTM(7)
  
    end
end



    function draw()
        
        if get(lowEicasMode) == 10 then


            drawRectangle(0, 0, 4096, 4096, black)
            
      


            if get(page == 0) then
                drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 -655, 1188 + 17 - 4 - 25 + 2 - 1 -76, 390, 92, green)
                drawText(opensans, 1100 - 400 + 150 + 15 - 15 -655, 1100 - 150 + 475 - 200 + 10 - 30 - 1 -76, "NORMAL MENU", 38, false, false, TEXT_ALIGN_CENTER, white)
                drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 -655+393, 1188 + 17 - 4 - 25 + 2 - 1 -76, 390, 92, grey)
                drawText(opensans, 1100 - 400 + 150 + 15 - 15 -655+393, 1100 - 150 + 475 - 200 + 10 - 30 - 1 -76, "RESETS", 38, false, false, TEXT_ALIGN_CENTER, white)
                drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 -655+393+393, 1188 + 17 - 4 - 25 + 2 - 1 -76, 390, 92, grey)
                drawText(opensans, 1100 - 400 + 150 + 15 - 15 -655+393+393, 1100 - 150 + 475 - 200 + 10 - 30 - 1 -76, "NON-NORMAL MENU", 38, false, false, TEXT_ALIGN_CENTER, white)
            else get(page ~= 1)
                drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 -655, 1188 + 17 - 4 - 25 + 2 - 1 -76, 390, 92, grey)
                drawText(opensans, 1100 - 400 + 150 + 15 - 15 -655, 1100 - 150 + 475 - 200 + 10 - 30 - 1 -76, "NORMAL MENU", 38, false, false, TEXT_ALIGN_CENTER, white)
                drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 -655+393, 1188 + 17 - 4 - 25 + 2 - 1 -76, 390, 92, grey)
                drawText(opensans, 1100 - 400 + 150 + 15 - 15 -655+393, 1100 - 150 + 475 - 200 + 10 - 30 - 1 -76, "RESETS", 38, false, false, TEXT_ALIGN_CENTER, white)
                drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 -655+393+393, 1188 + 17 - 4 - 25 + 2 - 1 -76, 390, 92, grey)
                drawText(opensans, 1100 - 400 + 150 + 15 - 15 -655+393+393, 1100 - 150 + 475 - 200 + 10 - 30 - 1 -76, "NON-NORMAL MENU", 38, false, false, TEXT_ALIGN_CENTER, white)
            end
           

 

            if get(page) == 0 then
                parseHome(checklisthome, -655, -76)
                if get(homepagesurr ~= 0) then
                    surroun(-95*(get(homepagesurr)))
                end
                
            end

            if get(page) == 2 then
                drawTexture(triRight, 375+63, 1200-145, 25, 32.6, white) 
                drawText(opensans, 1200/2, 1200-145, "BEFORE START", 45, false, false, TEXT_ALIGN_CENTER, white)
                drawTexture(triLeft, 375+63+295, 1200-145, 25, 32.6, white) 
                chklDraw(bfrstartchecklist, bfrstartchecklistvalues)
                if (get(otherpagesurr) ~= 0) then
                    surroun2(-65*(get(otherpagesurr)))
                end
            
            end





            

















































            --PAGE FUCTNIONALS
            if get(page) == 0 then
                drawText(opensans, 450, 1035, "<-PAGE NON-FUNCTIONAL", 35, false, false, TEXT_ALIGN_LEFT, red) 
                drawText(opensans, 450, 1035-95, "<-PAGE FUNCTIONAL", 35, false, false, TEXT_ALIGN_LEFT, green) 
                drawText(opensans, 450, 1035-95-95, "<-PAGE NON-FUNCTIONAL", 35, false, false, TEXT_ALIGN_LEFT, red) 
                drawText(opensans, 450, 1035-95-95-95, "<-PAGE NON-FUNCTIONAL", 35, false, false, TEXT_ALIGN_LEFT, red) 
                drawText(opensans, 450, 1035-95-95-95-95, "<-PAGE NON-FUNCTIONAL", 35, false, false, TEXT_ALIGN_LEFT, red) 
                drawText(opensans, 450, 1035-95-95-95-95-95, "<-PAGE NON-FUNCTIONAL", 35, false, false, TEXT_ALIGN_LEFT, red) 
                drawText(opensans, 450, 1035-95-95-95-95-95-95, "<-PAGE NON-FUNCTIONAL", 35, false, false, TEXT_ALIGN_LEFT, red) 
                drawText(opensans, 450, 1035-95-95-95-95-95-95-95, "<-PAGE NON-FUNCTIONAL", 35, false, false, TEXT_ALIGN_LEFT, red)
                drawText(opensans, 450, 1035-95-95-95-95-95-95-95-95, "<-PAGE NON-FUNCTIONAL", 35, false, false, TEXT_ALIGN_LEFT, red)  
                drawText(opensans, 450, 1035-95-95-95-95-95-95-95-95-95, "<-PAGE NON-FUNCTIONAL", 35, false, false, TEXT_ALIGN_LEFT, red)  
            end
        end
        
    end


