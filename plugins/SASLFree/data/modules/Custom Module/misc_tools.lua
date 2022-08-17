--[[
*****************************************************************************************
* Script Name: misc_tools
* Author Name: @bruh
* Script Description: Functions that are used frequently
*****************************************************************************************
--]]

ac_heading = globalPropertyf("sim/flightmodel/position/magpsi")
wind_dir = globalPropertyf("sim/weather/wind_direction_degt")

--Generic utilities

function tlen(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

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

--Sim only utilities

function IsAcConnected() --1 if ac is connected
	for i=1,3 do
		local voltage = globalPropertyfae("sim/cockpit2/electrical/bus_volts", i)
		if get(voltage) > 27 then
			return 1
		end
	end
	return 0
end

function GetWindVector()
	local tmp_heading = (get(ac_heading) + 180) % 360
	if get(wind_dir) == get(ac_heading) or get(wind_dir) == tmp_heading then
		return 0
	else
		if tmp_heading == get(ac_heading) + 180 then
			if get(wind_dir) > get(ac_heading) and get(wind_dir) < get(tmp_heading) then
				return 1
			end
		else
			if get(wind_dir) > get(ac_heading) and get(wind_dir) < 360 or get(wind_dir) >= 0 and get(wind_dir) < tmp_heading then
				return 1
			end
		end
	end
	return -1
end

function GetFltState() --this is needed for demand pump activation during takeoff/landing/ and pcu logic
	local gear_pos = globalPropertyi("sim/cockpit2/controls/gear_handle_down")
	local flap_pos = globalPropertyf("sim/cockpit2/controls/flap_ratio")
	local throttle_pos = globalPropertyf("sim/cockpit2/engine/actuators/throttle_ratio_all")
	local on_ground = globalPropertyi("sim/flightmodel/failures/onground_any")
	if get(gear_pos) == 1 and get(flap_pos) < 0.8 and get(throttle_pos) >= 0.6 and get(flap_pos) > 0 and get(on_ground) == 1 then
		return 1
	elseif get(gear_pos) == 1 and get(flap_pos) >= 0.5 and get(on_ground) == 0 then
		return 2
	else
		return 0
	end
end

function GetSysIdx(num) --matches pump index with system index
	if num == 1 then
		return 1
	elseif num == 4 then
		return 3
	else
		return 2
	end
end

function DrawRect(x, y, width, height, thickness, color, bottom) --draws rectangle with definable line thickness
	if bottom == false then
		sasl.gl.drawWideLine(x, y, x + width, y, thickness, color)
		sasl.gl.drawWideLine(x + width, y, x + width, y - height, thickness, color)
		sasl.gl.drawWideLine(x + width, y - height, x, y - height, thickness, color)
		sasl.gl.drawWideLine(x, y - height, x, y, thickness, color)
	else
		sasl.gl.drawWideLine(x, y, x, y + height, thickness, color)
		sasl.gl.drawWideLine(x, y + height, x + width, y + height, thickness, color)
		sasl.gl.drawWideLine(x + width, y + height, x + width, y, thickness, color)
		sasl.gl.drawWideLine(x + width, y, x, y, thickness, color)
	end
end

function DrawCrossedRect(x, y, width, height, thickness, color) --draws rectangle with definable line thickness
	sasl.gl.drawWideLine(x, y, x + width, y, thickness, color)
	sasl.gl.drawWideLine(x + width, y, x + width, y - height, thickness, color)
	sasl.gl.drawWideLine(x + width, y - height, x, y - height, thickness, color)
	sasl.gl.drawWideLine(x, y - height, x, y, thickness, color)
	sasl.gl.drawWideLine(x, y, x + width, y - height, thickness, color)
	sasl.gl.drawWideLine(x + width, y, x, y - height, thickness, color)
end