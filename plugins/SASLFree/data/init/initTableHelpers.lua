---------------------------------------------------------------------------------------------------------------------------
-- TABLE HELPERS -----------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Load stands from cache
function loadTableFromFile(fileName, name)
    local chunk = loadfile(fileName)
    if nil ~= chunk then
        local t = {}
        setfenv(chunk, t)
        chunk()
        return t[name]
    else
        logError('file not exists', fileName)
        return nil
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Save table to file
function saveTableToFile(f, table, name)
    if name then
        f:write(name .. ' = ')
    end
    f:write('{\n')

    for k, v in pairs(table) do
        f:write('["' .. k .. '"] = ')
        if ('number' == type(v)) or ('boolean' == type(v)) then
            f:write(tostring(v) .. ';\n')
        elseif ('string' == type(v)) then
            f:write('"' .. v .. '";\n')
        elseif ('table' == type(v)) then
            saveTableToFile(f, v)
        end
    end

    f:write('};\n')
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Save positions to file
function savePositionsToFile(f, table, name)
    if name then
        f:write(name .. ' = ')
    end
    f:write('{\n')

    for k, v in pairs(table) do
        f:write('["' .. k .. '"] = { ')
        for i = 1, 4 do
            f:write(v[i])
            if 4 ~= i then
                f:write(', ')
            else
                f:write(' ')
            end
        end
        f:write('};\n')
    end

    f:write('};\n')
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Deep copies values from source table to destination table
function mergeComponentTables(dest, src)
    for k, v in pairs(src) do
        if "table" == type(v) then
            if not dest[k] then
                dest[k] = v
            elseif isProperty(dest[k]) and isProperty(v) then
                dest[k] = v
            else
                mergeComponentTables(dest[k], v)
            end
        else
            dest[k] = v
        end
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Simple merge of two tables
function table.merge(t1, t2)
    local t = {}
    for k, v in ipairs(t1) do
        table.insert(t, v)
    end
    for k, v in ipairs(t2) do
        table.insert(t, v)
    end
    return t
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Make deep copy of table
function cloneTable(table)
    local t = {}
    for k, v in pairs(table) do
        if "table" == type(v) then
            t[k] = cloneTable(v)
        else
            t[k] = v
        end
    end
    return t
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Table floor
function math.tablefloor(tbl)
    for i = 1, #tbl do
        tbl[i] = math.floor(tbl[i])
    end
    return tbl
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Transposing function
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

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Extracts N-dimensinal table into one table
function extractArrayData(arr)
    if type(arr[1]) ~= 'table' then
        return arr
    else
        if type(arr[1][1]) ~= 'table' then
            arr = transpose(arr)
        end

        local res={}
        for i = 1, #arr do
            res = table.merge(res, extractArrayData(arr[i]))
        end
        return res
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
