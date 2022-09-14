-------------------------------------------------------------------------------
-- Basic helpers
-------------------------------------------------------------------------------

private = {}

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Interprets 0 value as false.
--- @param v any
--- @return any
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#toboolean
function toboolean(v)
    if v == 0 then
        return false
    else
        return v
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Checks if 2D coordinates lays inside specified rectangle.
--- @param rect number[]
--- @param x number
--- @param y number
--- @return boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#isInRect
function isInRect(rect, x, y)
    local x1 = rect[1]
    local y1 = rect[2]
    local x2 = x1 + rect[3]
    local y2 = y1 + rect[4]
    return (x1 <= x) and (x2 > x) and (y1 <= y) and (y2 > y)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------