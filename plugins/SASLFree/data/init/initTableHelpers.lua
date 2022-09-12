-------------------------------------------------------------------------------
-- Table helpers
-------------------------------------------------------------------------------

local function transpose(x)
    local r = {}
    for i = 1, #x[1] do
        r[i] = {}
        for j = 1, #x do
            r[i][j] = x[j][i]
        end
    end
    return r
end

local function mergeTablesSimple(t1, t2)
    local t = {}
    for _, v in ipairs(t1) do
        table.insert(t, v)
    end
    for _, v in ipairs(t2) do
        table.insert(t, v)
    end
    return t
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Merges two tables to setup a component.
--- @param dest table
--- @param src table
function private.mergeComponentTables(dest, src)
    for k, v in pairs(src) do
        if type(v) == "table" then
            if not dest[k] then
                dest[k] = v
            elseif isProperty(dest[k]) and isProperty(v) then
                dest[k] = v
            else
                private.mergeComponentTables(dest[k], v)
            end
        else
            dest[k] = v
        end
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Extracts data from N-dimensional table to simple array-like table.
--- @param arr table
function private.extractArrayData(arr)
    if type(arr[1]) ~= "table" then
        return arr
    else
        if type(arr[1][1]) ~= "table" then
            arr = transpose(arr)
        end

        local res = {}
        for i = 1, #arr do
            res = mergeTablesSimple(res, private.extractArrayData(arr[i]))
        end
        return res
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Writes table to file in valid Lua syntax.
--- @param fileName string
--- @param t table
--- @param tname string
function private.writeTableToFile(fileName, t, tname)
    local f = io.open(fileName, "w+")
    if f ~= nil then
        local cache = {}
        local function writeTable(inT, depth)
            local tStr = tostring(inT)
            local indent = string.rep(' ', depth * 4)
            if cache[tStr] then
            else
                cache[tStr] = true
                for k, v in pairs(inT) do
                    local vt = type(v)
                    local kStr
                    if type(k) == "number" then
                        kStr = tostring(k)
                    else
                        kStr = "'"..tostring(k).."'"
                    end
                    if vt == "table" then
                        f:write(indent.."["..kStr.."] = {\n")
                        writeTable(v, depth + 1)
                        f:write(indent.."};\n")
                    elseif vt == "string" then
                        f:write(indent.."["..kStr.."] = '"..v.."';\n")
                    elseif vt == "number" or vt == "boolean" then
                        f:write(indent.."["..kStr.."] = "..tostring(v)..";\n")
                    end
                end
            end
        end
        f:write(tname.." = {\n")
        writeTable(t, 1)
        f:write("};\n")
        f:close()
    else
        logWarning("Can't write table to '" .. fileName .. "'")
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------