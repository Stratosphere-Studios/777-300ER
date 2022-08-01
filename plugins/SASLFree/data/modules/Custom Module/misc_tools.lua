--[[
*****************************************************************************************
* Script Name: misc_tools
* Author Name: @bruh
* Script Description: Functions that are used frequently
*****************************************************************************************
--]]

function bool2num(value)
	return value and 1 or 0
end

function round(number) --rounds everything behind the decimal
	return math.floor(number+0.5)
end

function Round(num, dp) --rounds evcerything until a certain point
    local mult = 10^(dp or 0)
    return math.floor(num * mult + 0.5)/mult
end

function indexOf(array, value, round_) --returns index of a value in an array.
	if round_ == 1 then
		value = Round(value, 2)
	end
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

function IsAcConnected() --1 if ac is connected
	for i=1,3 do
		local voltage = globalPropertyfae("sim/cockpit2/electrical/bus_volts", i)
		if get(voltage) > 27 then
			return 1
		end
	end
	return 0
end

function DrawRect(x, y, width, height, thickness, color) --draws rectangle with definable line thickness
	sasl.gl.drawWideLine(x, y, x + width, y, thickness, color)
	sasl.gl.drawWideLine(x + width, y, x + width, y - height, thickness, color)
	sasl.gl.drawWideLine(x + width, y - height, x, y - height, thickness, color)
	sasl.gl.drawWideLine(x, y - height, x, y, thickness, color)
end

function DrawCrossedRect(x, y, width, height, thickness, color) --draws rectangle with definable line thickness
	sasl.gl.drawWideLine(x, y, x + width, y, thickness, color)
	sasl.gl.drawWideLine(x + width, y, x + width, y - height, thickness, color)
	sasl.gl.drawWideLine(x + width, y - height, x, y - height, thickness, color)
	sasl.gl.drawWideLine(x, y - height, x, y, thickness, color)
	sasl.gl.drawWideLine(x, y, x + width, y - height, thickness, color)
	sasl.gl.drawWideLine(x + width, y, x, y - height, thickness, color)
end