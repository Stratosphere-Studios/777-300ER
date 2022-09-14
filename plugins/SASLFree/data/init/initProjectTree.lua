-------------------------------------------------------------------------------
-- Project tree
-------------------------------------------------------------------------------

--- Initiates current project state tree.
function initiateStateTree()
    _G["stateTree"] = {}
    private.initStateTree(_G["panel"], _G["stateTree"])
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Exports project tree.
--- @param seekFunctions boolean
function exportProjectTreePanel(seekFunctions)
    if _G["panel"] then
        private.exportProjectTree(_G["panel"], _G["stateTree"], seekFunctions)
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Initiates current project state tree recursive.
--- @param inTable table
--- @param inStateTree table
function private.initStateTree(inTable, inStateTree)
    local cache = {}
    local function subInitStateTree(inTableS, inStateTreeS)
        if (cache[tostring(inTableS)]) then
            -- Do nothing
        else
            cache[tostring(inTableS)] = true
            if type(inTableS) == "table" then
                for pos, val in pairs(inTableS) do
                    if type(val) == "table" and pos ~= "_P" and pos ~= "_C" then
                        inStateTreeS["open"] = 0
                        inStateTreeS[pos] = {}
                        subInitStateTree(val, inStateTreeS[pos])
                    end
                end
            end
        end
    end
    subInitStateTree(inTable, inStateTree)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Exports project tree recursive.
--- @param inTable table
--- @param inStateTree table
--- @param seekFunctions boolean
function private.exportProjectTree(inTable, inStateTree, seekFunctions)
    local exportCache = {}
    local function subExportProjectTree(inTableS, inStateTreeS)
        if (exportCache[tostring(inTableS)]) then
            -- Do nothing
        else
            exportCache[tostring(inTableS)] = true
            if type(inTableS) == "table" then
                for pos, val in pairs(inTableS) do
                    if type(val) == "table" and pos ~= "_P" and pos ~= "_C" then
                        if type(inStateTreeS) == "table" and inStateTreeS["open"] == 1 then
                            local isComponent = rawget(val, "_C") ~= nil
                            sasl.projectTreeBeginCommand("["..tostring(pos).."]", isComponent)
                            subExportProjectTree(val, inStateTreeS[pos])
                            sasl.projectTreeEndCommand()
                        else
                            sasl.projectTreeCreateCommand("["..tostring(pos).."]", TYPE_STRING, '', true)
                        end
                    elseif type(val) == "string" then
                        sasl.projectTreeCreateCommand("["..tostring(pos).."]", TYPE_STRING, val, false)
                    elseif pos ~= "_P" and pos ~= "_C" and pos ~= "__p" then
                        if type(val) ~= "function" or seekFunctions == 1 then
                            local typeIdentifier
                            local currentType = type(val)
                            if (currentType == "number") then
                                typeIdentifier = TYPE_FLOAT
                            elseif (currentType == "boolean") then
                                typeIdentifier = TYPE_BOOLEAN
                            elseif (currentType == "function") then
                                typeIdentifier = TYPE_FUNCTION
                            else
                                typeIdentifier = TYPE_STRING
                            end
                            sasl.projectTreeCreateCommand("["..tostring(pos).."]", typeIdentifier, tostring(val), false)
                        end
                    end
                end
            end
        end
    end
    subExportProjectTree(inTable, inStateTree)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
