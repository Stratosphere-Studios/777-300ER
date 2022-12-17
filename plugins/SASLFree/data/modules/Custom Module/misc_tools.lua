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

function lim(val, upper, lower)
	if val > upper then
		return upper
	elseif val < lower then
		return lower
	end
	return val
end

function tlen(T) --Returns length of a table
  local idx = 0
  for i in pairs(T) do idx = idx + 1 end
  return idx
end

function getGreaterThan(T, val)
	local idx = 0
	for i in pairs(T) do
		idx = idx + 1
		if T[idx] >= val then
			break
		end
	end
	return idx
end

function bool2num(value)
	return value and 1 or 0
end

function round(number) --rounds everything behind the decimal
	return math.floor(number+0.5)
end

function Round(num, dp) --rounds everything until a certain point
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

function PID_Compute(kp, ki, kd, target, current, errtotal, errlast, lim1, lim2)
	local current_error = target - current
	local et = errtotal + current_error --total error
	--Limiting total error
	if et > lim1 then
		et = lim1
	elseif et < -lim1 then
		et = -lim1
	end
	local delta_error = current_error - errlast
	local compute = 0
	if get(f_time) ~= 0 then --only perform calculations when sim is not paused
		compute = kp * current_error + ki * get(f_time) * et + (kd / get(f_time)) * delta_error
	end
	--Limiting output
	if compute > lim2 then
		compute = lim2
	elseif compute < -lim2 then
		compute = -lim2
	end
	return {compute, et, current_error}
end	

function EvenChange(val, tgt, step)
	if math.abs(val - tgt) <= step then
		return val
	else
		return val + (bool2num(val < tgt) - bool2num(val > tgt)) * step * get(f_time) / 0.0166
	end
end

--Sim only utilities

function EvenAnim(dref, tgt, step)
	if math.abs(get(dref) - tgt) <= step then
		set(dref, tgt)
	else
		set(dref, get(dref) + (bool2num(get(dref) < tgt) - bool2num(get(dref) > tgt)) * step * get(f_time) / 0.0166)
	end
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

--Drawing utilities

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

function Stripify(x, y, width, height, n, thickness, color) --draws diagonal stripes across a rectangle
	local step = (width+height) / n
	for i=step,width+height,step do
		local x1 = 0
        local y1 = 0
        local x2 = 0
        local y2 = 0
		if i <= height then
			x1 = x
			y1 = y + height - i
		else
			x1 = x + i - height
			y1 = y
		end
		if i <= width then
			x2 = x + i
			y2 = y + height
		else
			x2 = x + width
			y2 = y + height - i + width
		end
		sasl.gl.drawWideLine(round(x1), round(y1), round(x2), round(y2), thickness, color)
	end
end
