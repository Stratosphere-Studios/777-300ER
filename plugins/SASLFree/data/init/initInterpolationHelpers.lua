---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- INTERPOLATION HELPERS ------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Creates new interpolator, returns its handle
function newInterpolator(...)
    local arg = {...}
    local input = {}
    local value = {}

    if #arg == 1 then
        input = { arg[1][1] }
        value = arg[1][2]
        return sasl.newCPPInterpolator(input, value)
    end

    local N = #arg - 1
    local matrix = arg[N + 1]
    local size = 1

    if N == 0 then
        logError('newInterpolator: Number of input arguments into an interpolator must be greater than zero')
        return
    end

    for i = 1,N do
        input[i] = arg[i]
        size = size * #arg[i]
    end

    value = extractArrayData(matrix)
    if #value ~= size then
        logError('newInterpolator: Size dimensions mismatch')
        return
    end

    return sasl.newCPPInterpolator(input, value)
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Deletes provided interpolator-object
function deleteInterpolator(handle)
    sasl.deleteCPPInterpolator(handle)
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Interpolates current point
function interpolate(x, interp, flag)
    if type(x) == 'number' then
        x = { x }
    end
    if flag == nil then
        flag = false
    end
    return sasl.interpolateCPP(interp, x, flag)
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Creates self-interpolator object
function selfInterpolator(...)
    local r = {}
    r.interp = newInterpolator(...)
    local temp = function(x, flag)
                     return interpolate(x, r.interp, flag)
                 end
    r.interpolate = temp
    return r
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
