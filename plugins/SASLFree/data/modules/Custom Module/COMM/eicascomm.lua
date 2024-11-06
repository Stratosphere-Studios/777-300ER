-- eicascomm.lua
-- Language: lua
-- Path: Custom Module\COMM\eicascomm.lua

size = { 1200, 1200 }
local white = { 1, 1, 1, 1 }
local blue = { 1, 0.5, 1, 1 }
local cyan = { 0, 0.69, 0.69, 1 }
local black = { 0, 0, 0, 1 }
local color = { 1, 1, 1, 1 }
local grey = { 0.490, 0.490, 0.490, 1 }
local green = { 0, 1, 0, 1 }
local red = { 1, 0, 0, 1 }
local opensans = loadFont("BoeingFont.ttf")
battery = globalPropertyiae("sim/cockpit2/electrical/battery_on", 1)
eicas_mode = globalPropertyi("Strato/777/displays/eicas_mode")
hh = globalPropertyi("sim/cockpit2/clock_timer/zulu_time_hours")
mm = globalPropertyi("sim/cockpit2/clock_timer/zulu_time_minutes")
ss = globalPropertyi("sim/cockpit2/clock_timer/zulu_time_seconds")
addSearchPath(moduleDirectory .. "/Custom Module/COMM/assets")
include("menu.lua")
include("eiascommfunction.lua")
local selectkey = loadImage("selectkey.png")
local selectedkey = loadImage("selectedkey.png")
local downarrow = loadImage("downarrow.png")
local fullarrow = loadImage("fullarrow.png")

local page = 0
local detailpage = 1

local selectingX = 0
local selectingY = 0
local selectingW = 0
local selectingH = 0

local selectionX = 0
local selectionY = 0

local previouspage = get(page)
local previousdetailpage = get(detailpage)

local connected = false
local readytosend = false

function inputborder(X, Y, W, H)
    drawRectangle(X, Y, W, 5, white) --top
    drawRectangle(X, Y, 5, H, white) --left
    drawRectangle(X + W - 5, Y, 5, H, white) --right
    drawRectangle(X, Y + H, W, 5, white) --bottom
end

function ATCmenu(list, x, y)
    col1 = 1
    col2 = 1
    col3 = 1
    col = "cel"
    pos = 95
    for i, v in pairs(list) do
        extra = 0
        pos = pos + 50
        col = get(col) .. (tostring(get(pos)))
        if v:find("\n") then
            extra = 45 / 2
        end
        if i <= 4 then
            col1 = col1 + 95
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 + x, 1188 + 17 - 4 - 25 + 2 +- get(col1) + y, 400 - 10, 85, grey)
            drawText(opensans, 25, 1100 - 150 + 475 - 200 + 10 - 30 - get(col1) + y + extra, v, 38, false,
                false, TEXT_ALIGN_LEFT, white)
        elseif i > 4 and i <= 7 then
            col2 = col2 + 95
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 + 400 + x, 1188 + 17 - 4 - 25 + 2 +- get(col2) + y, 400 - 10, 85, grey)
            drawText(opensans, 25 + 400, 1100 - 150 + 475 - 200 + 10 - 30 - get(col2) + y + extra, v, 38, false,
                false, TEXT_ALIGN_LEFT, white)
        else
            col3 = col3 + 95
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 + 400 + 400 + x, 1188 + 17 - 4 - 25 + 2 +- get(col3) + y, 400 - 10, 85, grey)
            drawText(opensans, 25 + 400 + 400, 1100 - 150 + 475 - 200 + 10 - 30 - get(col3) + y + extra, v, 38, false,
                false, TEXT_ALIGN_LEFT, white)
        end
    end
end

function draw()
	if get(battery) == 1 and get(eicas_mode) == 11 then
		if get(page) == 0 then
            drawText(opensans, 1200 / 2, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 6, "ATC", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, green)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75, "ATC", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655 + 393 + 6, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655 + 393 + 6, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 + 24, "   FLIGHT\nINFORMATION", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655 + 393 + 393 + 12, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655 + 393 + 393 + 12, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75, "COMPANY", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655, 1188 + 17 - 4 - 25 + 2 - 1 - 76 - 97 - 6, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 97 - 6, "REVIEW", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655 + 393 + 6, 1188 + 17 - 4 - 25 + 2 - 1 - 76 - 97 - 6, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655 + 393 + 6, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 97 - 6, "MANAGER", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655 + 393 + 393 + 12, 1188 + 17 - 4 - 25 + 2 - 1 - 76 - 97 - 6, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655 + 393 + 393 + 12, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 97 - 6, "NEW MESSAGES", 45, false, false, TEXT_ALIGN_CENTER, white)
            ATCmenu(ATC, -655, -250)
        elseif get(page) >= 1 and get(page) <= 16 then
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, green)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75, "ATC", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655 + 393 + 6, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655 + 393 + 6, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 + 24, "   Flight\nInformation", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655 + 393 + 393 + 12, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655 + 393 + 393 + 12, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75, "Company", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655, 1188 + 17 - 4 - 25 + 2 - 1 - 76 - 97 - 6, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 97 - 6, "REVIEW", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655 + 393 + 6, 1188 + 17 - 4 - 25 + 2 - 1 - 76 - 97 - 6, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655 + 393 + 6, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 97 - 6, "MANAGER", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 450 + 70 - 90 + 17 + 15 - 655 + 393 + 393 + 12, 1188 + 17 - 4 - 25 + 2 - 1 - 76 - 97 - 6, 390, 92, grey)
            drawText(opensans, 1100 - 400 + 150 + 15 - 15 - 655 + 393 + 393 + 12, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 97 - 6, "NEW MESSAGES", 45, false, false, TEXT_ALIGN_CENTER, white)
            ShowPage(get(page))

            if (connected) then
                if (readytosend) then
                    drawRectangle(10, 10, 180, 92, grey)
                    drawText(opensans, 100, 37,"Send", 45, false, false, TEXT_ALIGN_CENTER, white)
                else
                    drawRectangle(10, 10, 180, 5, cyan) --top
                    drawRectangle(10, 10, 5, 92, cyan) --left
                    drawRectangle(180 + 5, 10, 5, 92, cyan) --right
                    drawRectangle(10, 102, 180, 5, cyan) --bottom
                    drawText(opensans, 100, 37,"Send", 45, false, false, TEXT_ALIGN_CENTER, cyan)
                end

                if (get(page) == 7) then
                    --todo disconnect
                end
            else
                drawRectangle(10, 10, 180, 5, cyan) --top
                drawRectangle(10, 10, 5, 92, cyan) --left
                drawRectangle(180 + 5, 10, 5, 92, cyan) --right
                drawRectangle(10, 102, 180, 5, cyan) --bottom
                drawText(opensans, 100, 37,"Send", 45, false, false, TEXT_ALIGN_CENTER, cyan)
            end

            if (get(page) == 7 and connected == false and readytosend == true) then
                drawRectangle(10, 10, 180, 92, grey)
                drawText(opensans, 100, 37,"Send", 45, false, false, TEXT_ALIGN_CENTER, white)
            end
            drawRectangle(405 + 5, 10, 180, 92, grey)
            drawText(opensans, 1200 / 2 + 95 + 5 - 200, 37,"Print", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(605 + 5, 10, 180, 92,grey)
            drawText(opensans, 1200 / 2 + 95 + 5, 37,"Reset", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(800 + 10, 10, 180, 92,grey)
            drawText(opensans, 1200 / 2 + 210 + 90, 37,"Return", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(800 + 10 + 200, 10, 180, 92,grey)
            drawText(opensans, 1200 / 2 + 210 + 90 + 200, 37,"Exit", 45, false, false, TEXT_ALIGN_CENTER, white)
        end

        if get(selectingX) ~= 0 then
            inputborder(get(selectingX), get(selectingY), get(selectingW), get(selectingH))
        end

        if get(selectionX) ~= 0 then
            drawRotatedTexture(selectedkey, 45, selectionX, selectionY, 30, 30, white)
        end
	end
    --ATC
    components[#components + 1] = interactive {
        position = { 1100 - 450 + 70 - 90 + 17 + 15 - 655, 1188 + 17 - 4 - 25 + 2 - 1 - 76, 390, 92 },
        onMouseDown = function()
            page = 0
        end,

        onMouseMove = function()
            selectingX = 1100 - 450 + 70 - 90 + 17 + 15 - 655
            selectingY = 1188 + 17 - 4 - 25 + 2 - 1 - 76
            selectingW = 390
            selectingH = 92
            return true
        end,

        onMouseLeave = function()
            return true
        end
    }
    --Footer
    --reset
    components[#components + 1] = interactive {
        position = { 605 + 5, 10, 180, 92 },
        onMouseMove = function()
            selectingX = 605 + 5
            selectingY = 10
            selectingW = 180
            selectingH = 92
            return true
        end,

        onMouseLeave = function()
            return true
        end,

        onMouseDown = function()
            inputData = {}
            return true
        end
    }
end



function ShowPage(page)
    local detailpageavail = false
    --header
    local CurrentFunction
    CurrentFunction = Headertitle[page] -- Assuming you meant to use ATCAltRequest here instead of ATCmenulist
    drawText(opensans, 25, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 6, 
              string.format("%02d", get(hh)) .. string.format("%02d", get(mm)) .. "Z", 
              45, false, false, TEXT_ALIGN_LEFT, white)
    drawText(opensans, 1200 / 2, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 6, 
              CurrentFunction,
              45, false, false, TEXT_ALIGN_CENTER, white)
    
    --content
    if page == 1 then
        detailpageavail = true
        if (detailpage == 1) then
            Displayitem(1, "Altitude:", 1, false, -15, 5, 0, false, 0)
            Displayitem(2, "Step At:", 1, true, 0, 15, 0, false, 0)
            Displayitem(3, "Cruise climb", 1, true, 0, 0, 0, false, 0)
            Displayitem(4, "Block:", 1, false, 20, 5, 0, false, 0)
            Displayitem(5, "TO:", 0, false, 20, 5, 70, false, 0)
            Displayitem(6, "Request VMC Decent", 1, false, 0, 0, 0, false, 0)
        else
            StandardReason()
        end
    elseif page == 2 then
        detailpageavail = true
        if (detailpage == 1) then
            Displayitem(1, "Direct to:", 1, false, -15, 12, 0, false, 0)
            Displayitem(2, "Route 1", 1, false, 0, 0, 0, false, 0)
            Displayitem(2, "Route 2", 1, false, 15, 0, 500, true, 2)
            Displayitem(3, "Heading:", 1, false, 15, 3, 0, false, 0)
            Displayitem(4, "Ground track:", 1, false, -35, 3, 0, false, 0)
            Displayitem(5, "DEP/ARR:", 1, false, 0, 3, 0, false, 0)
            Displayitem(6, "Weather deviation\nUp to:", 1, false, -300, 3, 0, false, 0)
            Displayitem(7.2, "Offset:", 1, false, 0, 3, 0, false, 0)
            Displayitem(8.2, "Offset at:", 2, true, 0, 12, 0, false, 0)
            drawText(opensans, 50 + 25 + 40 + 20 + 525, 1188 + 17 - 4 - 25 + 2 +- (6 * 87) + -300, "NM", 45, false, false, TEXT_ALIGN_LEFT, white) --Weather Deviation NM
            drawText(opensans, 50 + 25 + 40 + 20 + 270, 1188 + 17 - 4 - 25 + 2 +- (7.2 * 87) + -300, "NM", 45, false, false, TEXT_ALIGN_LEFT, white) --offset NM
        else
            StandardReason()
        end
    elseif page == 3 then
        detailpageavail = true
        if (detailpage == 1) then
            Displayitem(1, "Speed:", 1, false, 20, 3, 0, false, 0)
        else
            StandardReason()
        end
    elseif page == 4 then
        Displayitem(1, "Request Clearance", 2, false, 0, 0, 0, false, 0)
        FreeText()
    elseif page == 5 then
        Displayitem(1, "Altitude", 1, false, 5, 0, 0, false, 0)
        Displayitem(2, "Cruise climb", 2, true, 0, 0, 0, false, 0)
        Displayitem(3, "Higher Alt", 1, false, 0, 0, 0, false, 0)
        Displayitem(4, "Lower Alt:", 1, false, 0, 0, 0, false, 0)
        Displayitem(5, "Speed:", 2, false, 20, 3, 0, false, 0)
        Displayitem(6, "Back on route", 2, false, 0, 0, 0, false, 0)
        FreeText(7, true)
    elseif page == 6 then
        Displayitem(1, "Request Clearance", 2, false, 0, 0, 0, false, 0)
        FreeText(7, true)
    elseif page == 7 then
        Displayitem(1, "Active center:", 0, false, 0, 0, 0, false, 0)
        Displayitem(2, "Next center:", 0, false, 0, 0, 0, false, 0)
        Displayitem(3, "ATC Connection:", 0, true, 0, 0, 0, false, 0)
        Displayitem(4, "Logon to:", 0, true, 0, 4, 0, false, 0)
        Displayitem(5, "Flight Number:", 0, false, -65, 8, 0, false, 0)
        Displayitem(6, "Tail Number:", 0, false, -50, 6, 0, false, 0)
    elseif page == 8 then
        Displayitem(1, "Mayday", 1, false, 0, 0, 0, false, 0)
        Displayitem(1, "Pan", 1, false, 0, 0, 400, false, 0)
        Displayitem(1, "Cancel\nEmergency", 1, false, 0, 0, 700, false, 0)
        Displayitem(3, "Diverting\nto:", 2, false, -50, 12, 0, false, 0)
        Displayitem(4.3, "Fuel remaining", 2, false, -65, 4, 0, false, 0)
        Displayitem(5.3, "Descending to:", 0, false, -50, 6, 0, false, 0)
        Displayitem(6.3, "Offsetting:", 0, false, 0, 3, 0, false, 0)
        Displayitem(7.3, "Free Text:", 0, false, 0, 24, 0, false, 0)
    end

    --scrollbar
    if detailpageavail then
        if detailpage == 1 then
            drawRotatedTexture(fullarrow, 180, 1100 - 9 + 15, 200 + 20, 75, 75, white)
            drawTexture(downarrow, 1100 - 9 + 15, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 6 - 80, 75, 75, white)
            drawRectangle(1100 - 9 + 15, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 6 - 80 - 171 - 106, 75, 277, white)
            drawRectangle(1100 - 9 + 15, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 6 - 80 - 171 - 100 - 290, 75, 277, grey)
            drawRectangle(1100 - 9 + 15 + 7, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 6 - 80 - 171 - 100 - 290 + (277 / 2) - 20 + 277, 60, 50, black)
            drawText(opensans, 1100 - 9 + 15 + 7 + (60 / 2), 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 80 - 171 - 100 - 290 + (277 / 2) - 20 + 277, "1", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 9 + 15 + 7, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 6 - 80 - 171 - 100 - 290 + (277 / 2) - 20, 60, 50, black)
            drawText(opensans, 1100 - 9 + 15 + 7 + (60 / 2), 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 80 - 171 - 100 - 290 + (277 / 2) - 20, "2", 45, false, false, TEXT_ALIGN_CENTER, white)
            components[#components + 1] = interactive {
                position = { 1100 - 9 + 15, 200 + 20, 75, 75 },
                onMouseMove = function()
                    selectingX = 1100 - 9 + 15
                    selectingY = 200 + 20
                    selectingW = 75
                    selectingH = 75
                    return true
                end,

                onMouseDown = function()
                    detailpage = 2
                    return true
                end,

                onMouseLeave = function()
                    return true
                end
            }
        else
            drawRotatedTexture(downarrow, 180, 1100 - 9 + 15, 200 + 20, 75, 75, white)
            drawRectangle(1100 - 9 + 15, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 6 - 80 - 171 - 106, 75, 277, grey)
            drawRectangle(1100 - 9 + 15, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 6 - 80 - 171 - 100 - 290, 75, 277, white)
            drawTexture(fullarrow, 1100 - 9 + 15, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 6 - 80, 75, 75, white)
            drawRectangle(1100 - 9 + 15 + 7, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 6 - 80 - 171 - 100 - 290 + (277 / 2) - 20 + 277, 60, 50, black)
            drawText(opensans, 1100 - 9 + 15 + 7 + (60 / 2), 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 80 - 171 - 100 - 290 + (277 / 2) - 20 + 277, "1", 45, false, false, TEXT_ALIGN_CENTER, white)
            drawRectangle(1100 - 9 + 15 + 7, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 6 - 80 - 171 - 100 - 290 + (277 / 2) - 20, 60, 50, black)
            drawText(opensans, 1100 - 9 + 15 + 7 + (60 / 2), 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 80 - 171 - 100 - 290 + (277 / 2) - 20, "2", 45, false, false, TEXT_ALIGN_CENTER, white)

            components[#components + 1] = interactive {
                position = { 1100 - 9 + 15, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 6 - 80, 75, 75 },
                onMouseMove = function()
                    selectingX = 1100 - 9 + 15
                    selectingY = 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 6 - 80
                    selectingW = 75
                    selectingH = 75
                    return true
                end,

                onMouseDown = function()
                    detailpage = 1
                    return true
                end,

                onMouseLeave = function()
                    return true
                end
            }
        end

        components[#components + 1] = interactive {
            position = { 1100 - 9 + 15, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 6 - 80 - 171 - 100 - 290, 75, 277 },
            onMouseDown = function()
                detailpage = 2
            end,

            onMouseMove = function()
                selectingX = 1100 - 9 + 15
                selectingY = 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 6 - 80 - 171 - 100 - 290
                selectingW = 75
                selectingH = 277
                return true
            end
        }

        components[#components + 1] = interactive {
            position = { 1100 - 9 + 15, 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 6 - 80 - 171 - 106, 75, 277 },
            onMouseDown = function()
                detailpage = 1
            end,

            onMouseMove = function()
                selectingX = 1100 - 9 + 15
                selectingY = 1100 - 150 + 475 - 200 + 10 - 30 - 1 - 75 - 90 - 97 - 6 - 80 - 171 - 106
                selectingW = 75
                selectingH = 277
                return true
            end,

            onMouseLeave = function()
                return true
            end
        }
    end
end

function StandardReason()
    Displayitem(1, "At pilots descretion", 2, false, 0, 0, 0, false, 0)
    Displayitem(2, "Due to weather", 2, false, 0, 0, 0, false, 0)
    Displayitem(3, "Due to aircraft performance", 2, false, 0, 0, 0, false, 0)
    Displayitem(4, "Maintain own separation and vmc", 2, false, 0, 0, 0, false, 0)
    FreeText()
end
    
function Displayitem(count, text, selecttype, sub, offsetinputbox, lenght, offsetfromstart, choosedoption, choosedwithcount)
    startposition = 60
    subposition = 0
    fixboxposition = 0
    if (sub) then
        subposition = 100
    end

    if (string.len(text) <= 4) then
        fixboxposition = 10 * string.len(text)
    end

    local fontsize = 33
    local Textlenght = string.len(text) * fontsize

    if (selecttype == 1) then
        drawRotatedTexture(selectkey, 45, 50 + 25 + subposition + offsetfromstart,  1188 + 17 - 4 - 25 + 2 +- (count * 87) - 5 + -300, 40, 40, white)
    elseif (selecttype == 2) then
        drawRotatedTexture(selectkey, 0, 50 + 25 + subposition + offsetfromstart,  1188 + 17 - 4 - 25 + 2 +- (count * 87) - 5 + -300, 40, 40, white)
    end
    drawText(opensans, 50 + 25 + 40 + 20 + subposition + offsetfromstart,  1188 + 17 - 4 - 25 + 2 +- (count * 87) + -300, text, 45, false, false, TEXT_ALIGN_LEFT, white)

    components[#components + 1] = interactive {
        position = { 50 + 25 + subposition + offsetfromstart, 1188 + 17 - 4 - 25 + 2 +- (count * 87) - 5 + -300, 40, 40 },
        onMouseDown = function()
            if (selecttype == 0) then
                return
            end
            subposition = 0

            if (sub) then
                subposition = 50
            end
            selectionX = 50 + 25 + subposition + offsetfromstart + 5 + subposition
            selectionY = 1188 + 17 - 4 - 25 + 2 +- (count * 87) - 5 + -300 + 5
            return true
        end,

        onMouseMove = function()
            -- position = { 50 + subposition + offsetfromstart, 1188 + 17 - 4 - 25 + 2 +- (count * 87) - 5 + -300 - 20, 25 + 25 + Textlenght, 75 } bugging

            -- if (selecttype == 0) then
            --     return
            -- end

            -- local fontsize = 33
            -- local Textlenght = string.len(text) * fontsize

            -- startposition = 90
            -- subposition = 0
            -- fixboxposition = 0
            -- if (sub) then
            --     subposition = 100
            -- end
            -- if (string.len(text) <= 4) then
            --     fixboxposition = 10 * string.len(text)
            -- end
            -- selectingX = 50 + subposition + offsetfromstart
            -- selectingY = 1188 + 17 - 4 - 25 + 2 +- (count * 87) - 5 + -300 - 20
            -- selectingW = Textlenght
            -- selectingH = 75
            return true
        end,

        onMouseLeave = function()
            return true
        end
    }

    if (lenght ~= 0) then
        drawRectangle(25 + 25 + Textlenght + 20 + subposition + offsetfromstart + fixboxposition + offsetinputbox,  1188 + 17 - 4 - 25 + 2 +- (count * 87) - 12 + -300, lenght * 30, 60, grey)
        components[#components + 1] = interactive {
            position = { 25 + 25 + Textlenght + 20 + subposition + offsetfromstart + fixboxposition + offsetinputbox,  1188 + 17 - 4 - 25 + 2 +- (count * 87) - 12 + -300, lenght * 30, 60 },
            onMouseDown = function()
                clickmain(count, text, selecttype)
                return true
            end,

            onMouseMove = function()
                startposition = 90
                subposition = 0
                fixboxposition = 0
                if (sub) then
                    subposition = 100
                end
                if (string.len(text) <= 4) then
                    fixboxposition = 10 * string.len(text)
                end
                selectingX = 25 + 25 + Textlenght + 20 + subposition + offsetfromstart + fixboxposition + offsetinputbox
                selectingY = 1188 + 17 - 4 - 25 + 2 +- (count * 87) - 12 + -300
                selectingW = lenght * 30
                selectingH = 60
                return true
            end,

            onMouseLeave = function()
                return true
            end,
        }

        --input text box "---""
        local entry = Tabledata(count, get(page))
        if entry then
            drawText(opensans, 25 + 25 + Textlenght + 20 + subposition + offsetfromstart + fixboxposition + ((lenght * 30) / 2) + offsetinputbox,  1188 + 17 - 4 - 25 + 2 +- (count * 87) + -300, entry.data, 45, false, false, TEXT_ALIGN_CENTER, white)
        else
            local inputlength = {}
            for i = 1, lenght, 1 do
                table.insert(inputlength, "-")
            end
            drawText(opensans, 25 + 25 + Textlenght + 20 + subposition + offsetfromstart + fixboxposition + ((lenght * 30) / 2) + offsetinputbox,  1188 + 17 - 4 - 25 + 2 +- (count * 87) + -300, table.concat(inputlength), 45, false, false, TEXT_ALIGN_CENTER, white)
        end
    end
end

function FreeText(count, sub)
    offset = 0
    count = count or 5 --for default
    sub = sub or false --for default
    if (sub) then
        offset = 100
    end
    drawText(opensans, 50 + 25 + offset, 1188 + 17 - 4 - 25 + 2 +- (count * 87) - 5 + -300, "Free text:", 45, false, false, TEXT_ALIGN_LEFT, white)
    drawRectangle(25 + 25 + 260 + offset, 1188 + 17 - 4 - 25 + 2 +- (count * 87) - 5 + -300 - 125, 600, 60 * 3, grey) --standard 3 lines

    local inputlength = {}
    for i = 1, 25, 1 do
        table.insert(inputlength, "-")
    end

    drawText(opensans, 25 + 25 + 260 + (600 / 2) + offset, 1188 + 17 - 4 - 25 + 2 +- (count * 87) - 5 + -300 - 110, table.concat(inputlength), 45, false, false, TEXT_ALIGN_CENTER, white)
    drawText(opensans, 25 + 25 + 260 + (600 / 2) + offset, 1188 + 17 - 4 - 25 + 2 +- (count * 87) - 5 + -300 - 110 + 60, table.concat(inputlength), 45, false, false, TEXT_ALIGN_CENTER, white)
    drawText(opensans, 25 + 25 + 260 + (600 / 2) + offset, 1188 + 17 - 4 - 25 + 2 +- (count * 87) - 5 + -300 - 110 + 60 + 60, table.concat(inputlength), 45, false, false, TEXT_ALIGN_CENTER, white)

    components[#components + 1] = interactive {
        position = { 25 + 25 + 260 + offset, 1188 + 17 - 4 - 25 + 2 +- (count * 87) - 5 + -300 - 125, 600, 60 * 3 },
        onMouseDown = function()
            return true
        end,

        onMouseMove = function()
            if (sub) then
                offset = 100
            end
            selectingX = 25 + 25 + 260 + offset
            selectingY = 1188 + 17 - 4 - 25 + 2 +- (count * 87) - 5 + -300 - 125
            selectingW = 600
            selectingH = 60 * 3
            return true
        end,

        onMouseLeave = function()
            return true
        end,
    }
end


components = {}
function update()
    components = {}
    if (get(page) == 0) then
        for i = 1, 4, 1 do
            components[#components + 1] = interactive {
                position = { 1100 - 450 + 70 - 90 + 17 + 15 + -655, 1188 + 17 - 4 - 25 + 2 +- (95 * i) + -250, 390, 85 }, --here
                onMouseDown = function()
                    page = i
                end,

                onMouseMove = function()
                    selectingX = 1100 - 450 + 70 - 90 + 17 + 15 + -655
                    selectingY = 1188 + 17 - 4 - 25 + 2 +- (95 * i) + -250
                    selectingW = 390
                    selectingH = 85
                    return true
                end,

                onMouseLeave = function()
                    return true
                end
            }
        end

        for i = 5, 7, 1 do
            components[#components + 1] = interactive {
                position = { 1100 - 450 + 70 - 90 + 17 + 15 + -655 + 400, 1188 + 17 - 4 - 25 + 2 +- (95 * i) + -250 + (95 * 4), 390, 85 }, --here
                onMouseDown = function()
                    page = i
                end,

                onMouseMove = function()
                    selectingX = 1100 - 450 + 70 - 90 + 17 + 15 + -655 + 400
                    selectingY = 1188 + 17 - 4 - 25 + 2 +- (95 * i) + -250 + (95 * 4)
                    selectingW = 390
                    selectingH = 85
                    return true
                end,

                onMouseLeave = function()
                    return true
                end
            }
        end

        for i = 8, 11, 1 do
            components[#components + 1] = interactive {
                position = { 1100 - 450 + 70 - 90 + 17 + 15 + -655 + 400 + 400, 1188 + 17 - 4 - 25 + 2 +- (95 * i) + -250 + (95 * 7), 390, 85 }, --here
                onMouseDown = function()
                    page = i
                end,

                onMouseMove = function()
                    selectingX = 1100 - 450 + 70 - 90 + 17 + 15 + -655 + 400 + 400
                    selectingY = 1188 + 17 - 4 - 25 + 2 +- (95 * i) + -250 + (95 * 7)
                    selectingW = 390
                    selectingH = 85
                    return true
                end,

                onMouseLeave = function()
                    return true
                end
            }
        end
    end

    local currentpage = get(page)
    local currentdetailpage = get(detailpage)
    if currentpage ~= previouspage then
        selectingX = 0
        detailpage = 1
        previouspage = currentpage
    end
    if currentdetailpage ~= previousdetailpage then
        selectingX = 0
        previousdetailpage = currentdetailpage
    end
end