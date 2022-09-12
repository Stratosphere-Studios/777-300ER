-------------------------------------------------------------------------------
-- Filesystem helpers
-------------------------------------------------------------------------------

local function findFileInPaths(fileName, pathsList)
    for _, v in ipairs(pathsList) do
        local f = v .. '/' .. fileName
        if isFileExists(f) then
            return f
        end
    end

    if not isFileExists(fileName) then
        return nil
    else
        return fileName
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Checks if specified file exists.
--- @param fileName string
--- @return boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#isFileExists
function isFileExists(fileName)
    local f = io.open(fileName)
    if f == nil then
        return false
    else
        io.close(f)
        return true
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Removes extension from path to file and returns removed extension separately.
--- @param filePath string
--- @return string, string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#extractFileName
function extractFileName(filePath)
    for i = string.len(filePath), 1, -1 do
        local s = string.sub(filePath, i, i)
        if s == '.' then
            return string.sub(filePath, 1, i - 1), string.sub(filePath, i)
        elseif s == '/' then
            return filePath, nil
        end
    end
    return filePath, nil
end

--- Appends default scripts extension to path if extension isn't specified
--- @param filePath string
--- @return string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#appendDefaultFileExtension
function appendDefaultFileExtension(filePath)
    local p, ext = extractFileName(filePath)
    if ext == nil then
        return p .. ".lua"
    end
    return filePath
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

_SFCACHE = {}

--- Loads chunk of Lua code from specified file.
--- Will be searched according to the current list of search paths.
--- @param fileName string
--- @param cache boolean
--- @return function
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#openFile
function openFile(fileName, cache)
    local ch = cache or false
    local name = extractFileName(fileName)

    for _, v in ipairs(private.searchPath) do
        local fullName
        local subdir
        if 0 < string.len(v) then
            fullName = v..'/'..fileName
            subdir = v..'/'..name
        else
            fullName = fileName
            subdir = name
        end

        if ch and _SFCACHE[fullName] then return _SFCACHE[fullName] end
        if isFileExists(fullName) then
            local f, errorMsg = loadfile(fullName)
            if f then
                if ch then
                    _SFCACHE[fullName] = f
                end
                return f
            else
                logError(errorMsg)
            end
        end

        local subFullName = subdir .. '/' .. fileName
        if ch and _SFCACHE[subFullName] then return _SFCACHE[subFullName] end
        if isFileExists(subFullName) then
            local f, errorMsg = loadfile(subFullName)
            if f then
                if ch then
                    _SFCACHE[subFullName] = f
                end
                return f, subdir
            else
                logError(errorMsg)
            end
        end
    end

    return nil
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Finds specified file in project.
--- Will be searched according to the current list of search paths.
--- @param fileName string
--- @return string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#findFile
function findFile(fileName)
    return findFileInPaths(fileName, private.searchPath)
end

--- Finds specified resource file in project.
--- Will be searched according to the current list of search resources paths.
--- @param fileName string
--- @return string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#findResourceFile
function findResourceFile(fileName)
    return findFileInPaths(fileName, private.searchResourcesPath)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------