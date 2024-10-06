local utils = {}

function utils.animate(target, variable, speed)
    if math.abs(target - variable) < 0.1 then return target end
    variable = variable + ((target - variable) * (speed * SIM_PERIOD))
    return variable
end

function utils.ternary(condition, ifTrue, ifFalse)
    if condition then return ifTrue else return ifFalse end
end

function utils.rescale(in1, out1, in2, out2, x)
    if x < in1 then return out1 end
    if x > in2 then return out2 end
    return out1 + (out2 - out1) * (x - in1) / (in2 - in1)
end

function utils.lim(val, upper, lower)
	val = math.max(val, lower)
	val = math.min(val, upper)
	return val
end

function utils.tableLen(T) --Returns length of a table
	local idx = 0
	for i in pairs(T) do idx = idx + 1 end
	return idx
end

function utils.bool2num(value)
	return value and 1 or 0
end

function utils.round(x) --rounds everything behind the decimal
	return math.floor(x + 0.5)
end

function utils.indexOf(array, value) --returns index of a value in an array.
    for k, v in ipairs(array) do
        if v == value then
            return k
        end
    end
    return nil
end

function utils.split(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result
end

function utils.pad(str, len, indent) -- constant string length
    if indent then
        return string.rep(" ", len - str:len())..str
    else
        return str..string.rep(" ", len - str:len())
    end
end

return utils;