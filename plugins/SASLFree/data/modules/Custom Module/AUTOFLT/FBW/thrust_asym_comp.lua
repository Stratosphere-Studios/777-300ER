--[[
*****************************************************************************************
* Script Name: thrust_asym_comp
* Author Name: discord/bruh4096#4512(Tim G.)
* Script Description: Code for thrust asymmetry compensation
*****************************************************************************************
--]]

function computeRudTrim(thrust_L, thrust_R)
    local max_engn = math.max(thrust_L, thrust_R)
    local min_engn = math.min(thrust_L, thrust_R)
    if max_engn * 0.1 <= (max_engn - min_engn) then
        return (thrust_L - thrust_R) * -15.4
    end
    return 0
end

function GetRudderTrim(thrust_L, thrust_R, rev_deployed, speed, trim_past)
    local trim = 0
    if get(on_ground) == 1 then
        if speed > 70 and not rev_deployed then
            trim = computeRudTrim(thrust_L, thrust_R)
        else
            return trim_past
        end
    else
        trim = computeRudTrim(thrust_L, thrust_R)
    end
    return trim
end