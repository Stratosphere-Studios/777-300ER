---------------------------------------------------------------------------------------------------------------------------
-- PROJECT TREE ------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Initiates current project state tree
function initiateStateTree()
    _G["stateTree"] = {}
    initStateTree(_G["panel"], _G["stateTree"])
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Initiates current project state tree recursive
function initStateTree(inTable, inStateTree)
    local cache = {}
    local function subInitStateTree(inTable, inStateTree)
        if (cache[tostring(inTable)]) then
            -- Do nothing
        else
            cache[tostring(inTable)] = true
            if (type(inTable) == "table") then
                for pos, val in pairs(inTable) do
                    if (type(val) == "table" and pos ~= "_P" and pos ~= "_C") then
                        inStateTree["open"] = 0
                        inStateTree[pos] = {}
                        subInitStateTree(val, inStateTree[pos])
                    end
                end
            end
        end
    end
    if (type(inTable) == "table") then
        subInitStateTree(inTable, inStateTree)
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Exports project tree
function exportProjectTreePanel(seekFunctions)
    if (_G["panel"]) then
        exportProjectTree(_G["panel"], _G["stateTree"], seekFunctions)
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Exports project tree recursive
function exportProjectTree(inTable, inStateTree, seekFunctions)
    local seekF = seekFunctions
    local exportCache = {}
    local function subExportProjectTree(inTable, inStateTree, seekF)
        if (exportCache[tostring(inTable)]) then
            -- Do nothing
        else
            exportCache[tostring(inTable)] = true
            if (type(inTable) == "table") then
                for pos, val in pairs(inTable) do
                    if (type(val) == "table" and pos ~= "_P" and pos ~= "_C") then
                        if (type(inStateTree) == "table" and inStateTree["open"] == 1)  then
                            local isComponent = rawget(val, "_C") ~= nil
                            sasl.projectTreeBeginCommand("["..tostring(pos).."]", isComponent)
                            subExportProjectTree(val, inStateTree[pos], seekF)
                            sasl.projectTreeEndCommand()
                        else
                            sasl.projectTreeCreateCommand("["..tostring(pos).."]", TYPE_STRING, '', true)
                        end
                    elseif (type(val) == "string") then
                        sasl.projectTreeCreateCommand("["..tostring(pos).."]", TYPE_STRING, val, false)
                    elseif (pos ~= "_P" and pos ~= "_C" and pos ~= "__p") then
                        if (type(val) ~= "function" or seekFunctions == 1) then
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
    if (type(inTable) == "table") then
        subExportProjectTree(inTable, inStateTree)
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
