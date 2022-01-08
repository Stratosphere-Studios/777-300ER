--[[
            function surr(T, M)
                if get(T) == 1 then
                    surroun2(M)
                elseif get(T) == 0 then
                    
                end
            end

--]]
size = {4096, 4096}
local white = {1, 1, 1, 1}
local blue = {1, 0.5, 1, 1}
local black = {0, 0, 0, 1}
color = {1, 1, 1, 1}
local grey = {0.490, 0.490, 0.490, 1}
local white = {1.0, 1.0, 1.0, 1.0}
local opensans = loadFont("BoeingFont.ttf")
addSearchPath(moduleDirectory .. "/Custom Module/EICASCHECK")
addSearchPath(moduleDirectory .. "/Custom Module/CURSOR")

-----------------------------------------
local preflightscroll = 1
-----------------------------------------
local home = 1
local bfrstart = 0
local preflightpage = 0

----------------------------------------- MAIN MENU SURROUND-
local preflightsurr = 0
local bfrstartsurr = 0
local surtaxi = 0
local surbfrtakeoff = 0
local surafttakeoff = 0
local surpredecent = 0
local surapp = 0
local surland = 0
local surshut = 0
local sursecure = 0
----------------------------------------------- MAIN MENU SURR END-
---------------------------------------- BFRSTART START-
local bfrstartmcp = 0
local bfrstarttakeoffspd = 0
local bfrstartcdupre = 0
local bfrstarttrim = 0
local bfrstartflightdoor = 0
--------------------------------------- BFRSTART SURROUND START--
local bfrstartmcpsurr = 0
local bfrstarttakeoffspdsurr = 0
local bfrstartcdupresurr = 0
local bfrstarttrimsurr = 0
local bfrstartflightdoorsurr = 0
---------------------------------------- BFRSTART SURROUND END-

local ref = loadImage("zYX5E.png")
local check = loadImage("check.png")
local tri = loadImage("tri.png")
local tri2 = loadImage("tri2.png")
local uparrow = loadImage("Uparrow.png")
local downarrow = loadImage("Downarrow.png")
local green = {0, 1, 0, 1}

function update()
    local eicasmode = globalPropertyf("Strato/777/displays/eicas_mode")
--  print(get(eicasmode))
    function chelist(X)
        loc = 1
        col = "cel"
        pos = 0
        for i, v in pairs(X) do

            loc = loc + 80
            pos = pos + 1
            colorasdf = 'color' .. tostring(get(pos))
            col = get(col) .. (tostring(get(pos)))
            drawText(opensans, 750, 1100 - 50 - get(loc), "    " .. v, 50, false, false, TEXT_ALIGN_LEFT, white)
            drawRectangle(675, 1100 - 74 - get(loc), 73, 73, grey)

        end

    end
    


   

    -- HOME PAGE
    if get(eicasmode) == 10 then
        
    
        if (get(home) == 1) then

            checklisthome = {

                [1] = "PREFLIGHT",
                [2] = "BEFORE START",
                [3] = "BEFORE TAXI",
                [4] = "BEFORE TAKEOFF",
                [5] = "AFTER TAKEOFF",
                [6] = "PRE-DECENT",
                [7] = "APPROACH",
                [8] = "LANDING",
                [9] = "SHUT DOWN",
                [10] = 'SECURE'

            }

            function chelisthome(X)
                loc = 1
                col = "cel"
                pos = 0

                for i, v in pairs(X) do

                    loc = loc + 95
                    pos = pos + 50
                    col = get(col) .. (tostring(get(pos)))
                    drawRectangle(1100 - 450 + 70 - 90 + 17 + 15, 1188 + 17 - 4 - 25 + 2 - get(loc), 415, 92, grey)
                    drawText(opensans, 1100 - 400 + 150 + 15, 1100 - 150 + 475 - 200 + 10 - 30 - get(loc), v, 38, false,
                        false, TEXT_ALIGN_CENTER, white)

                end

            end

            function surroun(U)
                xs1 = 1100 - 450 + 70 - 90 + 17 + 15 - 3
                xs2 = 1100 - 150 + 475 - 200 + 10 - 30 - 125 + U
                drawRectangle(get(xs1), get(xs2), 420, 3, white)
                drawRectangle(get(xs1), get(xs2), 3, 95, white)
                drawRectangle(get(xs1), get(xs2) + 92, 420, 3, white)
                drawRectangle(get(xs1) + 415, get(xs2) + 5, 3, 95, white)
            end

            components = {interactive {
                position = {1100 - 450 + 70 - 90 + 17, 1188 + 17 - 4 - 25 + 2 - 95, 415, 92},

                onMouseDown = function()
                    preflightpage = 1
                    bfrstart = 0
                    home = 0
                end,

                onMouseMove = function()
                    preflightsurr = 1
                    return true
                end,

                onMouseLeave = function()
                    preflightsurr = 0
                    return true
                end

            }, ---------------------------------------------------------------------------
            interactive {
                position = {1100 - 450 + 70 - 90 + 17, 1188 + 17 - 4 - 25 + 2 - 190, 415, 92},
                onMouseDown = function()
                    bfrstart = 1
                    home = 0
                end,

                onMouseMove = function()
                    bfrstartsurr = 1
                    return true
                end,

                onMouseLeave = function()
                    bfrstartsurr = 0
                    return true
                end
            }, ----------------------------------------------------------------------------
            interactive {
                position = {1100 - 450 + 70 - 90 + 17, 1188 + 17 - 4 - 25 + 2 - 285, 415, 92},

                onMouseMove = function()
                    surtaxi = 1
                    return true
                end,

                onMouseLeave = function()
                    surtaxi = 0
                    return true
                end
            }, ----------------------------------------------------------------------------
            interactive {
                position = {1100 - 450 + 70 - 90 + 17, 1188 + 17 - 4 - 25 + 2 - 380, 415, 92},

                onMouseMove = function()
                    surbfrtakeoff = 1
                    return true
                end,

                onMouseLeave = function()
                    surbfrtakeoff = 0
                    return true
                end
            }, interactive {
                -- befrtakeoff
                position = {1100 - 450 + 70 - 90 + 17, 703, 415, 92},

                onMouseMove = function()
                    surbfrtakeoff = 1
                    return true
                end,

                onMouseLeave = function()
                    surbfrtakeoff = 0
                    return true
                end
            }, interactive {
                -- afttakeoff
                position = {1100 - 450 + 70 - 90 + 17, 703, 415, 92},

                onMouseMove = function()
                    surafttakeoff = 1
                    return true
                end,

                onMouseLeave = function()
                    surafttakeoff = 0
                    return true
                end
            }, interactive {
                -- predecent
                position = {1100 - 450 + 70 - 90 + 17, 703 - 95, 415, 92},

                onMouseMove = function()
                    surpredecent = 1
                    return true
                end,

                onMouseLeave = function()
                    surpredecent = 0
                    return true
                end
            }}

            function draw()

                -- drawTexture(ref, 1100-450-17+10, 1100-450+540-1170+10, 759*1.7, 734*1.7, color) 
                drawRectangle(1100 - 450 + 70 - 90 + 17 + 15, 1188 + 17 - 4 - 25 + 2, 415, 92, green)
                drawText(opensans, 1100 - 400 + 14 + 15 + 30, 1100 - 150 + 475 - 200 + 10 - 30, "NORMAL MENU", 38, false,
                    false, TEXT_ALIGN_LEFT, white)

                drawRectangle(1100 - 450 + 70 - 90 + 17 + 420 + 15, 1188 + 17 - 4 - 25 + 2, 415, 92, grey)
                drawText(opensans, 1100 - 400 + 154 + 420 + 15, 1100 - 150 + 475 - 200 + 10 - 30, "RESETS", 38, false,
                    false, TEXT_ALIGN_CENTER, white)

                drawRectangle(1502, 1188 + 17 - 4 - 25 + 2, 415, 92, grey)
                drawText(opensans, 1100 - 400 + 154 + 420 + 420 + 15, 1100 - 150 + 475 - 200 + 10 - 30, "NON-NORMAL MENU",
                    38, false, false, TEXT_ALIGN_CENTER, white)

                chelisthome(checklisthome)

                -----------------------------------------------
                if get(preflightsurr) == 1 then
                    surroun(0)
                end
                if get(bfrstartsurr) == 1 then
                    surroun(-95)
                end
                if get(surtaxi) == 1 then
                    surroun(-(95 * 2))
                end
                if get(surbfrtakeoff) == 1 then
                    surroun(-((95 * 3)))
                end
                if get(surafttakeoff) == 1 then
                    surroun(-(95 * 4))
                end

                if get(surpredecent) == 1 then
                    surroun(-(95 * 5))
                end
                -----------------------------------------------

            end

        elseif get(home) == 0 then

        end
        
        -----------------------------------------------

        if get(bfrstart) == 1 then
            bfrstartchecklist = {
                [1] = 'MCP.......V2___, HDG/TRK___, ALTITUDE___',
                [2] = 'Takeoff speeds.......V1___, VR___, V2___',
                [3] = 'CDU preflight..................completed',
                [4] = 'Trim......................___Units, 0, 0',
                [5] = 'Flight deck door........Closed and locked'

            }
            function surroun(U)
                xs1 = 1100 - 450 + 70 - 90 + 17 + 15 - 3
                xs2 = 1100 - 150 + 475 - 200 + 10 - 30 - 270 + U
                drawRectangle(get(xs1), get(xs2) + 5, 415 + 800, 3, white)
                drawRectangle(get(xs1), get(xs2) + 5, 3, 95 - 10, white)
                drawRectangle(get(xs1), get(xs2) + 92 - 5, 415 + 800, 3, white)
                drawRectangle(get(xs1) + 415 + 800, get(xs2) + 5, 3, 95 - 10, white)
            end

            components = {interactive {
                position = {1100 - 450 + 70 - 90 + 17 + 15, 1188 + 17 - 4 - 25 + 2, 415, 92},
                onMouseDown = function()
                    home = 1
                    bfrstart = 0
                end
            }, interactive {
                -- Mcp...
                position = {675, 1100 - 74 - 81, 1200, 73},

                onMouseMove = function()
                    bfrstartmcpsurr = 1
                    return true
                end,

                onMouseLeave = function()
                    bfrstartmcpsurr = 0
                    return true
                end,

                onMouseDown = function()
                    if get(bfrstartmcp) == 0 then
                        bfrstartmcp = 1
                    elseif get(bfrstartmcp) == 1 then
                        bfrstartmcp = 0
                    end
                    return true
                end

            }, interactive {
                -- Takeoffspeeds
                position = {675, 1100 - 74 - 81 - 80, 1200, 73},

                onMouseMove = function()
                    bfrstarttakeoffspdsurr = 1
                    return true
                end,

                onMouseLeave = function()
                    bfrstarttakeoffspdsurr = 0
                    return true
                end,
                onMouseDown = function()
                    if get(bfrstarttakeoffspd) == 0 then
                        bfrstarttakeoffspd = 1
                    elseif get(bfrstarttakeoffspd) == 1 then
                        bfrstarttakeoffspd = 0
                    end
                    return true
                end

            }, interactive {
                -- Cdu pre flight
                position = {675, 1100 - 74 - 81 - 80 - 80, 1200, 73},

                onMouseMove = function()
                    bfrstartcdupresurr = 1
                    return true
                end,

                onMouseLeave = function()
                    bfrstartcdupresurr = 0
                    return true
                end,
                onMouseDown = function()
                    if get(bfrstartcdupre) == 0 then
                        bfrstartcdupre = 1
                    elseif get(bfrstartcdupre) == 1 then
                        bfrstartcdupre = 0
                    end
                    return true
                end

            }, interactive {
                -- trim ___units
                position = {675, 705, 1200, 73},

                onMouseMove = function()
                    bfrstarttrimsurr = 1
                    return true
                end,

                onMouseLeave = function()
                    bfrstarttrimsurr = 0
                    return true
                end,
                onMouseDown = function()
                    if get(bfrstarttrim) == 0 then
                        bfrstarttrim = 1
                    elseif get(bfrstarttrim) == 1 then
                        bfrstarttrim = 0
                    end
                    return true
                end

            }, interactive {
                -- CHKL RESET
                position = {1502, 48, 200, 92},

                onMouseDown = function()
                    bfrstartmcp = 0
                    bfrstarttakeoffspd = 0
                    bfrstartcdupre = 0
                    bfrstartflightdoor = 0
                    bfrstarttrim = 0

                end
            }, interactive {
                -- flight deck door closed       
                position = {675, 705 - 80, 1200, 73},
                onMouseMove = function()
                    bfrstartflightdoorsurr = 1
                    return true
                end,

                onMouseLeave = function()
                    bfrstartflightdoorsurr = 0
                end,

                onMouseDown = function()
                    if get(bfrstartflightdoor) == 0 then
                        bfrstartflightdoor = 1
                    elseif get(bfrstartflightdoor) == 1 then
                        bfrstartflightdoor = 0
                    end
                end

            }}

            function draw()
                drawTexture(tri, 1125, 1075, 30, 50, white)
                drawText(opensans, 1295, 1085, "BEFORE START", 35, true, false, TEXT_ALIGN_CENTER, white)
                drawTexture(tri2, 1435, 1075, 30, 50, white)

                drawRectangle(662, 1178, 415, 92, grey)
                drawText(opensans, 729 + 30, 1205, "NORMAL MENU", 38, false, false, TEXT_ALIGN_LEFT, white)

                drawRectangle(1082, 1178, 415, 92, grey)
                drawText(opensans, 1289, 1205, "RESETS", 38, false, false, TEXT_ALIGN_CENTER, white)

                drawRectangle(1502, 1178, 415, 92, grey)
                drawText(opensans, 1709, 1205, "NON-NORMAL MENU", 38, false, false, TEXT_ALIGN_CENTER, white)
                -- drawTexture(ref, 1100 - 450 - 17 + 10, 1100 - 450 + 540 - 1170 + 10, 759 * 1.7, 734 * 1.7, color)

                drawRectangle(1502, 48, 200, 92, grey)
                drawText(opensans, 1502 + 100, 1188 + 17 - 4 - 25 + 2 - 1075, ' CHKL\nRESET', 38, false, false,
                    TEXT_ALIGN_CENTER, white)

                chelist(bfrstartchecklist)
                ---------------------------------------------------------------------------------
                if get(bfrstartmcpsurr) == 1 then
                    surroun(0)
                end
                if get(bfrstarttakeoffspdsurr) == 1 then
                    surroun(-81)
                end
                if get(bfrstartcdupresurr) == 1 then
                    surroun(-162)
                end
                if get(bfrstarttrimsurr) == 1 then
                    surroun(-243)
                end
                if get(bfrstartflightdoorsurr) == 1 then
                    surroun(-324)
                end
                ----------------------------------------------------------------------------------
                if get(bfrstartmcp) == 1 then
                    drawTexture(check, 675, 945, 73, 73, green)
                    drawText(opensans, 750, 969, "    " .. bfrstartchecklist[1], 50, false, false, TEXT_ALIGN_LEFT, green)
                end
                if get(bfrstarttakeoffspd) == 1 then
                    drawTexture(check, 675, 864, 73, 73, green)
                    drawText(opensans, 750, 889, "    " .. bfrstartchecklist[2], 50, false, false, TEXT_ALIGN_LEFT, green)
                end
                if get(bfrstartcdupre) == 1 then
                    drawTexture(check, 675, 784, 73, 73, green)
                    drawText(opensans, 750, 809, "    " .. bfrstartchecklist[3], 50, false, false, TEXT_ALIGN_LEFT, green)
                end
                if get(bfrstarttrim) == 1 then
                    drawTexture(check, 675, 704, 73, 73, green)
                    drawText(opensans, 750, 729, "    " .. bfrstartchecklist[4], 50, false, false, TEXT_ALIGN_LEFT, green)
                end
                if get(bfrstartflightdoor) == 1 then
                    drawTexture(check, 675, 624, 73, 73, green)
                    drawText(opensans, 750, 649, "    " .. bfrstartchecklist[5], 50, false, false, TEXT_ALIGN_LEFT, green)
                end

            end
        elseif get(bfrstart) == 0 then

        end

        -- Preflight PAGE
        if get(preflightpage) == 1 then
            local preflightchecklistpg1 = {
                [1] = "Block Fuel..........LOAD AND VERIFY",
                [2] = "Payload.............LOAD AND VERIFY",
                [3] = "Parking Brake...................SET",
                [4] = "Battery Switch...................ON",
                [5] = "Prim. Flight Computers.........AUTO",
                [6] = "Thrust Asymmetry Compensation...AUTO",
                [7] = "APU GEN Switch...................ON",
                [8] = "IFE/PASS SEATS...................ON",
                [9] = "CABIN/UTILITY....................ON",
                [10] = 'L AND R BUS TIE SWITCHES.......AUTO',
                [11] = 'L AND R GEN CONTROL SWITCHES.....ON',
                [12] = 'BACKUP GENERATOR SWITCHES........ON'

            }
            local preflightchecklistpg2 = {
                "APU SELECTOR SWITCH......START, ON", 
                "NAV LIGHT.......................ON",
                "LOGO LIGHT................AS NEEDED", 
                "COCKPIT LIGHTS............AS NEEDED",                
                "EMER. EXIT LIGHTS.....ARMED", 
                "L AND R PACK CONTROL SWITCHES.....AUTO",                     
                "ADIRU......................ON", 
                "FMC INITALIZATION........POSITION"}

                
                function surroun2(U)
                    xs1 = 1100 - 450 + 70 - 90 + 17 + 15 - 3
                    xs2 = 1100 - 150 + 475 - 200 + 10 - 30 - 270 + U
                    drawRectangle(get(xs1), get(xs2) + 5, 415 + 800, 3, white)
                    drawRectangle(get(xs1), get(xs2) + 5, 3, 95 - 10, white)
                    drawRectangle(get(xs1), get(xs2) + 92 - 5, 415 + 800, 3, white)
                    drawRectangle(get(xs1) + 415 + 800, get(xs2) + 5, 3, 95 - 10, white)
                end

                function chelistpreflt(X)
                    loc = 1
                    col = "cel"
                    pos = 0
                    for i, v in pairs(X) do
            
                        loc = loc + 80
                        pos = pos + 1
                        colorasdf = 'color' .. tostring(get(pos))
                        col = get(col) .. (tostring(get(pos)))
                        drawText(opensans, 750, 1100 - 50 - get(loc), "    " .. v, 50, false, false, TEXT_ALIGN_LEFT, white)
                        drawTexture(check, 675, 1020 - get(loc), 73, 73, green)
            
                    end
            
                end
                components = {
                    interactive {
                        -- CHKL RESET
                        position = {1502 + 345, 48 + 615 - 380, 70, 370},
            
                        onMouseDown = function()
                            preflightscroll = 2
                        end
                    },
                    interactive {
                        -- CHKL RESET
                        position = {1502 + 345, 48 + 615, 70, 370},
            
                        onMouseDown = function()
                            preflightscroll = 1
                        end
                    },
                    interactive {
                        -- CHKL RESET
                        position = {1502+345, 48 + 990, 70, 70},
            
                        onMouseDown = function()
                            preflightscroll = 1
                        end
                    },
                    interactive {
                        -- CHKL RESET
                        position = {1502 + 345, 48 + 615 - 455, 70, 70},
            
                        onMouseDown = function()
                            preflightscroll = 2
                        end
                    },
                    interactive {
                        position = {1100 - 450 + 70 - 90 + 17 + 15, 1188 + 17 - 4 - 25 + 2, 415, 92},
                        onMouseDown = function()
                            home = 1
                            bfrstart = 0
                            preflightpage = 0
                        end
                    },
                
                    }


            
        
        
        
        
            
            function draw()
                --drawTexture(ref, 1100 - 450 - 17 + 10, 1100 - 450 + 540 - 1170 + 10, 759 * 1.7, 734 * 1.7, color)
                ---------------------------------------------------------------------------
                drawTexture(tri, 1125, 1075, 30, 50, white)
                drawText(opensans, 1295, 1085, "PREFLIGHT", 35, true, false, TEXT_ALIGN_CENTER, white)
                drawTexture(tri2, 1435, 1075, 30, 50, white)

                drawRectangle(662, 1178, 415, 92, grey)
                drawText(opensans, 729 + 30, 1205, "NORMAL MENU", 38, false, false, TEXT_ALIGN_LEFT, white)

                drawRectangle(1082, 1178, 415, 92, grey)
                drawText(opensans, 1289, 1205, "RESETS", 38, false, false, TEXT_ALIGN_CENTER, white)

                drawRectangle(1502, 1178, 415, 92, grey)
                drawText(opensans, 1709, 1205, "NON-NORMAL MENU", 38, false, false, TEXT_ALIGN_CENTER, white)
                ---------------------------------------------------------------------------------
                --drawRectangle(1502 + 345, 48 + 615, 70, 370, grey)
                if get(preflightscroll) == 1 then
                    drawTexture(uparrow, 1502+345, 48 + 990, 70, 70, white) 
                    drawRectangle(1502 + 345, 48 + 615, 70, 370, white)
                    drawRectangle(1502 + 350, 48 + 780, 60, 45, black)
                    drawText(opensans,1502 + 380, 48 + 790, "1", 30, false, false, TEXT_ALIGN_CENTER, green)
                    drawRectangle(1502 + 345, 48 + 615 - 380, 70, 370, grey)
                    drawRectangle(1502 + 350, 48 + 780 - 380, 60, 45, black)
                    drawText(opensans,1502 + 380, 48 + 790 - 380, "2", 30, false, false, TEXT_ALIGN_CENTER, white)  
                    drawRotatedTexture(downarrow, 180, 1502 + 345, 48 + 615 - 455, 70, 70, white) 
                elseif get(preflightscroll) == 2 then
                    drawTexture(uparrow, 1502+345, 48 + 990, 70, 70, white) 
                    drawRectangle(1502 + 345, 48 + 615, 70, 370, grey)
                    drawRectangle(1502 + 350, 48 + 780, 60, 45, black)
                    drawText(opensans,1502 + 380, 48 + 790, "1", 30, false, false, TEXT_ALIGN_CENTER, white)
                    drawRectangle(1502 + 345, 48 + 615 - 380, 70, 370, white)
                    drawRectangle(1502 + 350, 48 + 780 - 380, 60, 45, black)
                    drawText(opensans,1502 + 380, 48 + 790 - 380, "2", 30, false, false, TEXT_ALIGN_CENTER, green)  
                    drawRotatedTexture(downarrow, 180, 1502 + 345, 48 + 615 - 455, 70, 70, white) 
                end
                

                ---------------------------------------------------------------------------

                if get(preflightscroll) == 2 then
                    chelistpreflt(preflightchecklistpg2)
                elseif get(preflightscroll) == 1 then
                    chelistpreflt(preflightchecklistpg1)
                end

            end

        elseif get(preflightpage) == 0 then
        end

    else
        function draw()
            
        end
           
    end
    
end