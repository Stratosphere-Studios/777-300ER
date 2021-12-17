size = {4096, 4096}
local white = {1, 1, 1, 1}
local blue = {1, 0.5, 1, 1}
local black = {0, 0, 0, 1}
color = {1, 1, 1, 1}
local grey = {0.490, 0.490, 0.490, 1}
local white = {1.0, 1.0, 1.0, 1.0}
local opensans = loadFont("OpenSans-Bold.ttf")
local home = 1
local bfrstart = 0

------------------------------------------
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
-----------------------------------------
local bfrstartmcp = 0
local bfrstarttakeoffspd = 0
local bfrstartcdupre = 0
local bfrstarttrim = 0
-----------------------------------------
local bfrstartmcpsurr = 0
local bfrstarttakeoffspdsurr = 0
local bfrstartcdupresurr = 0
local bfrstarttrimsurr = 0
-----------------------------------------

local ref = loadImage("zYX5E.png")
local check = loadImage("check.png")
local tri = loadImage("tri.png")
local tri2 = loadImage("tri2.png")
local green = {0, 1, 0, 1}


function update()

    function chelist(X)
        loc = 1
        col = "cel"
        pos = 0
            for i, v in pairs(X) do
                  
                   loc = loc + 80
                   pos = pos+1
                   colorasdf = 'color'..tostring(get(pos))
                   col = get(col)..(tostring(get(pos)))
                   drawText(opensans, 1100-400+50, 1100-50-get(loc), "    "..v, 50, false, false, TEXT_ALIGN_LEFT, white)
                   drawRectangle(1100-450+50-25, 1100-74-get(loc), 73, 73, grey)
                   
                  
                   
            end
            
        end
        
    function compe(Y)
        for i, v in pairs(Y) do 
            first = [[interactive {position = {-60, -10, 500+600]]
            second = [[, 500+600}, 
        
            onMouseDown = function()
                color = {1, 2, 1, 1}
             
            end
        },
        ]]
        
        
            return first..second
        end
    end
    --interactives
    --[[
    if (get(eng) == 1) then	
    
        components = {
          
        	interactive {position = {-60, -10, 500+600, 500+600}, 
        
        	    onMouseDown = function()
                    color = {1, 0.5, 1, 1}
        	     
        	    end
        	},
        
          
            
            
            
        }
    
    end
      ]]--
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    
    ------------------------------------------------------
    
    --HOME PAGE


    print(get(home))

    if (get(home) == 1) then 
    
        checklisthome = {
        
        [1] = "PREFLIGHT",
        [2] = "BEFORE START",
        [3] = "BEFORE TAXI",
        [4] = "BEFORE TAKEOFF",
        [5] = "AFTER TAKEOFF",
        [6] = "PRE-DESCENT",
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
                       col = get(col)..(tostring(get(pos)))
                       drawRectangle(1100-450+70-90+17+15, 1188+17-4-25+2-get(loc), 415, 92, grey)
                       drawText(opensans, 1100-400+150+15, 1100-150+475-200+10-30-get(loc), v, 38, false, false, TEXT_ALIGN_CENTER, white)
                       
    
                end
                
            end
            
            
        function surroun(U)
            xs1 = 1100-450+70-90+17+15-3
            xs2 = 1100-150+475-200+10-30-125+U
            drawRectangle(get(xs1), get(xs2), 415, 3, white)
            drawRectangle(get(xs1), get(xs2), 3, 95, white)
            drawRectangle(get(xs1), get(xs2)+92, 415, 3, white)
            drawRectangle(get(xs1)+415, get(xs2), 3, 95, white)
        end
            
            
            components = {
    
                interactive {position = {1100-450+70-90+17, 1188+17-4-25+2-95, 415, 92},

                
                onMouseMove = function()
                    preflightsurr = 1
                    return true
                end,
                
                
                onMouseLeave = function()
                    preflightsurr = 0
                    return true
                end,
                

                },
                ---------------------------------------------------------------------------
                interactive {position = {1100-450+70-90+17, 1188+17-4-25+2-190, 415, 92},
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
                },
                ----------------------------------------------------------------------------
                interactive {position = {1100-450+70-90+17, 1188+17-4-25+2-285, 415, 92},
                
                onMouseMove = function()
                    surtaxi = 1
                    return true
                end,
                
                
                onMouseLeave = function()
                    surtaxi = 0
                    return true
                end  
                },
                ----------------------------------------------------------------------------
                interactive {position = {1100-450+70-90+17, 1188+17-4-25+2-380, 415, 92},
                
                onMouseMove = function()
                    surbfrtakeoff = 1
                    return true
                end,
                
                
                onMouseLeave = function()
                    surbfrtakeoff = 0
                    return true
                end  
                },
            
            }
            
    
    
        function draw()
            
            --drawTexture(ref, 1100-450-17+10, 1100-450+540-1170+10, 759*1.7, 734*1.7, color) 
            drawRectangle(1100-450+70-90+17+15, 1188+17-4-25+2, 415, 92, green)
            drawText(opensans, 1100-400+14+15, 1100-150+475-200+10-30, "NORMAL MENU", 38, false, false, TEXT_ALIGN_LEFT, white)
            
            
            drawRectangle(1100-450+70-90+17+420+15, 1188+17-4-25+2, 415, 92, grey)
            drawText(opensans, 1100-400+154+420+15, 1100-150+475-200+10-30, "RESETS", 38, false, false, TEXT_ALIGN_CENTER, white)
            
            
            drawRectangle(1100-450+70-90+17+420+420+15, 1188+17-4-25+2, 415, 92, grey)
            drawText(opensans, 1100-400+154+420+420+15, 1100-150+475-200+10-30, "NON-NORMAL MENU", 38, false, false, TEXT_ALIGN_CENTER, white)
            
            
            chelisthome(checklisthome)
            
            -----------------------------------------------
            if get(preflightsurr) == 1 then
                surroun(0)
            end
            if get(bfrstartsurr) == 1 then
                surroun(-95)
            end
            if get(surtaxi) == 1 then
                surroun(-(95*2))
            end
            if get(surbfrtakeoff) == 1 then
                surroun(-(95*3))
            end
            -----------------------------------------------
            
            
        end
    
    
    
    
    
    
    
    
    
    
    
    elseif get(home) == 0 then
        
    end
 
    








-----------------------------------------------
    


    if get(bfrstart) == 1 then
        bfrstartchecklist = {
        [1] = 'MCP..........V2___, HDG/TRK___, ALTITUDE___',
        [2] = 'Takeoff speeds..........V1___, VR___, V2___',
        [3] = 'CDU preflight.............................completed',  
        [4] = 'Trim.........................................___Units, 0, 0',
        [5] = 'Flight deck door......................Closed and locked'
        
        }
        function surroun(U)
            xs1 = 1100-450+70-90+17+15-3
            xs2 = 1100-150+475-200+10-30-270+U
            drawRectangle(get(xs1), get(xs2)+5, 415+800, 3, white)
            drawRectangle(get(xs1), get(xs2)+5, 3, 95-10, white)
            drawRectangle(get(xs1), get(xs2)+92-5, 415+800, 3, white)
            drawRectangle(get(xs1)+415+800, get(xs2)+5, 3, 95-10, white)
        end

        components = {
            interactive {position = {1100-450+70-90+17+15, 1188+17-4-25+2, 415, 92},
                onMouseDown = function()
                    home = 1
                    bfrstart = 0
                end
            },
            
            interactive {position = {1100-450+50-25, 1100-74-81, 1200, 73},

                
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
            end,

            
            
            

            }, 
            interactive {position = {1100-450+50-25, 1100-74-81-80, 1200, 73},

                
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
            end,
            
            
            

            },   
            interactive {position = {1100-450+50-25, 1100-74-81-80-80, 1200, 73},

                
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
            end,
            
            
            

            }, 
            
        
        
        }
    

    
        
    
        function draw()
            drawTexture(tri, 1100-450+50-25+400+50, 1100-74-81+130, 30, 50, white) 
            drawText(opensans, 1100-450+50-25+620, 1100-74-81+140, "BEFORE START", 35, true, false, TEXT_ALIGN_CENTER, white) 
            drawTexture(tri2, 1100-450+50-25+400+50+310, 1100-74-81+130, 30, 50, white) 
            
            drawRectangle(1100-450+70-90+17+15, 1188+17-4-25+2, 415, 92, grey)
            drawText(opensans, 1100-400+14+15, 1100-150+475-200+10-30, "NORMAL MENU", 38, false, false, TEXT_ALIGN_LEFT, white)
            
            
            drawRectangle(1100-450+70-90+17+420+15, 1188+17-4-25+2, 415, 92, grey)
            drawText(opensans, 1100-400+154+420+15, 1100-150+475-200+10-30, "RESETS", 38, false, false, TEXT_ALIGN_CENTER, white)
            
            
            drawRectangle(1100-450+70-90+17+420+420+15, 1188+17-4-25+2, 415, 92, grey)
            drawText(opensans, 1100-400+154+420+420+15, 1100-150+475-200+10-30, "NON-NORMAL MENU", 38, false, false, TEXT_ALIGN_CENTER, white)
            --drawTexture(ref, 1100-450-17+10, 1100-450+540-1170+10, 759*1.7, 734*1.7, color)
            
            chelist(bfrstartchecklist)
            ---------------------------------------------------------------------------------
            if get(bfrstartmcpsurr) == 1 then
                surroun(0)
            end
            if get(bfrstarttakeoffspdsurr) == 1 then
                surroun(-81)
            end
            if get(bfrstartcdupresurr) == 1 then
                surroun(-81-81)
            end
            ----------------------------------------------------------------------------------
            if get(bfrstartmcp) == 1 then
                drawTexture(check, 1100-450+50-25, 1100-74-81, 73, 73, green) 
                drawText(opensans, 1100-400+50, 1100-50-81, "    ".."MCP..........V2___, HDG/TRK___, ALTITUDE___", 50, false, false, TEXT_ALIGN_LEFT, green)
            end
            if get(bfrstarttakeoffspd) == 1 then
                drawTexture(check, 1100-450+50-25, 1100-74-81-81, 73, 73, green) 
                drawText(opensans, 1100-400+50, 1100-50-81-80, "    ".."Takeoff speeds..........V1___, VR___, V2___", 50, false, false, TEXT_ALIGN_LEFT, green)
            end
            if get(bfrstartcdupre) == 1 then
                drawTexture(check, 1100-450+50-25, 1100-74-81-81-80, 73, 73, green) 
                drawText(opensans, 1100-400+50, 1100-50-81-80-80, "    ".."CDU preflight.............................completed", 50, false, false, TEXT_ALIGN_LEFT, green)
            end
            
            
        end
    end
    

end



   