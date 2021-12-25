---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- FILESYSTEM HELPERS ----------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Return true if file exists
function isFileExists(fileName)
    local f = io.open(fileName)
    if nil == f then
        return false
    else
        io.close(f)
        return true
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Remove extension from file name
function extractFileName(filePath)
    for i = string.len(filePath), 1, -1 do
        if string.sub(filePath, i, i) == '.' then
            return string.sub(filePath, 1, i-1)
        end
    end
    return filePath
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Try to find file on search paths
function openFile(fileName)
    local name = extractFileName(fileName)

    for _, v in ipairs(searchPath) do
        local fullName
        local subdir
        if 0 < string.len(v) then
            fullName = v .. '/' .. fileName
            subdir = v .. '/' .. name
        else
            fullName = fileName
            subdir = name
        end

        -- Check if it is available at current path
        if isFileExists(fullName) then
            local f, errorMsg = loadfile(fullName)
            if f then
                return f
            else
                logError(errorMsg)
            end
        end

        -- Check subdirectory
        local subFullName = subdir .. '/' .. fileName
        if isFileExists(subFullName) then
            local f, errorMsg = loadfile(subFullName)
            if f then
                return f, subdir
            else
                logError(errorMsg)
            end
        end
    end

    return nil
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Find specified resource file
function findResourceFile(fileName) 
    for _, v in ipairs(searchResourcesPath) do
        local f = v .. '/' .. fileName
        if isFileExists(f) then
            return f
        end
    end
   
    if not isFileExists(fileName) then    
        return 0
    else
        return fileName
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------