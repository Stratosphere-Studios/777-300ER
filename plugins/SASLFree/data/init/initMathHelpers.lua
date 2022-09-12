-------------------------------------------------------------------------------
-- Interpolation helpers
-------------------------------------------------------------------------------

--- [DEPRECATED] Creates stepwise linear N-dimensional interpolator using specified grid parameters.
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#newInterpolator
function newInterpolator(...)
    local arg = { ... }
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
        logError("Number of input arguments into an interpolator must be greater than zero")
        return nil
    end

    for i = 1, N do
        input[i] = arg[i]
        size = size * #arg[i]
    end

    value = private.extractArrayData(matrix)
    if #value ~= size then
        logError("Size dimensions mismatch for interpolator object")
        return nil
    end

    return sasl.newCPPInterpolator(input, value)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- [DEPRECATED] Deletes interpolator object.
--- @param handle number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#deleteInterpolator
function deleteInterpolator(handle)
    sasl.deleteCPPInterpolator(handle)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- [DEPRECATED] Interpolates N-dimensional point.
--- @overload fun(x:table | number, interp:number):number
--- @param x table | number
--- @param interp number
--- @param flag boolean
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#interpolate
function interpolate(x, interp, flag)
    if type(x) == "number" then
        x = { x }
    end
    if flag == nil then
        flag = false
    end
    return sasl.interpolateCPP(interp, x, flag)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class Interpolator
--- @field interpolate fun(x:table | number, interp:number, flag:boolean):number
--- @field interp number

--- [DEPRECATED] Creates Interpolator object.
--- @return Interpolator
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#selfInterpolator
function selfInterpolator(...)
    local r = {}
    r.interp = newInterpolator(...)
    r.interpolate = function(x, flag)
        return interpolate(x, r.interp, flag)
    end
    return r
end

-------------------------------------------------------------------------------
-- Stereographic projection
-------------------------------------------------------------------------------

--- @class StereographicProjection
--- @field setProjectionCenter fun(self:StereographicProjection, lat:number, lon:number)
--- @field setScale fun(self:StereographicProjection, inNmRange:number, inCartesianRange:number)
--- @field LLtoXY fun(self:StereographicProjection, lat:number, lon:number):number, number
--- @field XYtoLL fun(self:StereographicProjection, x:number, y:number):number, number

--- Creates stereographic projection object
--- @param prCLatitude number
--- @param prCLongitude number
--- @param nmRange number
--- @param cartesianRange number
--- @return StereographicProjection
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#newStereographicProjection
function newStereographicProjection(prCLatitude, prCLongitude, nmRange, cartesianRange)
    local r = {}
    r.setProjectionCenter = function(self, lat, lon)
        self.prCLat = lat
        self.prCLon = lon
    end
    r.setScale = function(self, inNmRange, inCartesianRange)
        if inNmRange <= 0 or inCartesianRange <= 0 then
            logError("Incorrect scale values for stereographic projection")
        end
        self.nmR = inNmRange
        self.cR = inCartesianRange
    end
    r.LLtoXY = function(self, lat, lon)
        return sasl.stereographicLLtoXY(self.prCLat, self.prCLon, self.nmR, self.cR, lat, lon)
    end
    r.XYtoLL = function(self, x, y)
        return sasl.stereographicXYtoLL(self.prCLat, self.prCLon, self.nmR, self.cR, x, y)
    end

    r:setProjectionCenter(prCLatitude, prCLongitude)
    r:setScale(nmRange, cartesianRange)
    return r
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
