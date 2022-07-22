--Cursor.lua
size = {1200, 1200}
local white = {1, 1, 1, 1}
battery = globalPropertyiae("sim/cockpit2/electrical/battery_on", 1)
eicas_mode = globalPropertyi("Strato/777/displays/eicas_mode")

-- cursors --
local cursors = {
    x = 0,
    y = 0,
    type = 0,
    hideOSCursor =true,
    cpt_default = {
        texture = sasl.gl.loadImage("cursor.png"),
        xOffset = 30, 
        yOffset = 20, 
        size = {78/1.5, 78/1.5},
    }
}

onMouseMove = function(comp, x, y, button, px, py)
    cursors.x = x
    cursors.y = y
    hideOSCursor = true
end


function draw()
	if get(battery) == 1 and get(eicas_mode) == 10 then
		setClipArea(0, 0, 4096, 4096) 
		sasl.gl.drawTexture(
			cursors.cpt_default.texture, 
			cursors.x - cursors.cpt_default.xOffset, 
			cursors.y - cursors.cpt_default.yOffset, 
			cursors.cpt_default.size[1],
			cursors.cpt_default.size[2],
			white
		)
		resetClipArea()
	end
end
