---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- SUBPANEL CREATOR -----------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Create movable resizable subpanel hidden by default
function subpanel(tbl)
    local name = tbl.name
    if name == nil then
        name = 'subpanel'
    end
    local c = createComponent(name, popups)
    c.position = createProperty { 0, 0, 0, 0 }
    set(c.position, tbl.position)
    set(c.clip, tbl.clip)
    set(c.clipSize, tbl.clipSize)
    set(c.fbo, tbl.fbo)
    c.size = { tbl.position[3], tbl.position[4] }
    c.onMouseHold = function(comp, x, y, button, parentX, parentY)
        defaultOnMouseHold(comp, x, y, button, parentX, parentY)
        return true
    end
    c.onMouseDown = function(comp, x, y, button, parentX, parentY)
        defaultOnMouseDown(comp, x, y, button, parentX, parentY)
        return true
    end
    c.onMouseMove = function(comp, x, y, button, parentX, parentY)
        defaultOnMouseMove(comp, x, y, button, parentX, parentY)
        return true
    end
    c.onMouseWheel = function(comp, x, y, button, parentX, parentY, wheelClicks)
        defaultOnMouseWheel(comp, x, y, button, parentX, parentY, wheelClicks)
        return true
    end

    if tbl.visible then
        set(c.visible, tbl.visible)
    else
        set(c.visible, false)
    end

    set(c.movable, true)
    if get(tbl.noMove) then
        set(c.movable, false)
    end

	c.savePosition = createProperty(false)
    if get(tbl.savePosition) then
        set(c.savePosition, true)
    end

    c.pinnedToXWindow = createProperty { false, true }
    c.proportionalToXWindow = createProperty(false)

    if tbl.pinnedToXWindow then
        set(c.pinnedToXWindow, tbl.pinnedToXWindow)
    end
    set(c.proportionalToXWindow, tbl.proportionalToXWindow)
    c.components = tbl.components

    startComponentsCreation(tbl)
    if not get(tbl.noBackground) then
        if not rectangle then
            rectangle = loadComponent('rectangle')
        end

        table.insert(c.components, 1,
           rectangle { position = { 0, 0, c.size[1], c.size[2] } } )
    end

    if not get(tbl.noClose) then
        local pos = get(c.position)
        local btnWidth = c.size[1] / pos[3] * 16
        local btnHeight = c.size[2] / pos[4] * 16

        if not popupCloseButton then
            popupCloseButton = loadComponent('popupCloseButton')
        end

        local closeButton = popupCloseButton {
            position = { c.size[1] - btnWidth, c.size[2] - btnHeight,
                btnWidth, btnHeight },
            panel = c
        }
        closeButton.size = { btnWidth, btnHeight }
        c.component('closeButton', closeButton)
    end

    if not get(tbl.noResize) and not get(c.proportionalToXWindow) then
        set(c.resizable, true)
        local pos = get(c.position)
        c.resizeWidth = c.size[1] / pos[3] * 10
        c.resizeHeight = c.size[2] / pos[4] * 10

        if not rectangle then
            rectangle = loadComponent('rectangle')
        end
       if not popupResizeButton then
            popupResizeButton = loadComponent('popupResizeButton')
        end

        c.resizeRect = { c.size[1] - c.resizeWidth, 0,
                c.resizeWidth, c.resizeHeight };

        local resizeButton = popupResizeButton {
            position = c.resizeRect
        }
        resizeButton.size = { c.resizeWidth, c.resizeHeight }
        c.component('resizeButton', resizeButton)
    end
    finishComponentsCreation()

    if get(tbl.command) then
        -- Register panel popup command
        local command = sasl.createCommand(get(tbl.command), get(tbl.description))

        -- Show or hide panel on command received
        function commandHandler(phase)
            if phase == SASL_COMMAND_BEGIN then
                set(c.visible, not toboolean(get(c.visible)))
                if toboolean(get(c.visible)) then
                    movePanelToTop(c)
                end
            end
            return 0
        end

        -- Register created command handler
        sasl.registerCommandHandler(command, 0, commandHandler)
    end

    if popupsPositions and get(c.savePosition) and (name ~= 'subpanel') then
        local pos = popupsPositions[name]
        if pos then
            set(c.position, pos)
        end
    end

    popup(c)
    return c
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Save positions of popup components
function savePopupsPositions()
    local positions = { }
    for _, c in ipairs(popups.components) do
        if get(c.savePosition) and (get(c.name) ~= 'subpanel') then
            positions[get(c.name)] = get(c.position)
        end
    end

    if not #positions then
        return
    end

    local fileName = moduleDirectory .. '/popupsPositions.txt'
    local f = io.open(fileName, 'w+')
    if f ~= nil then
        savePositionsToFile(f, positions, 'positions')
        f:close()
    else
        logWarning("Can't open file '" .. fileName .. "' for writing")
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

function adaptPopupsPositions(diffX, diffY, ratioX, ratioY)
    for i = 1, #popups.components do
        local pinOption = get(popups.components[i].pinnedToXWindow)
        local proportionalOption = get(popups.components[i].proportionalToXWindow)
        local currentPosition = get(popups.components[i].position)

        local oldSize = { currentPosition[3], currentPosition[4] }
        if proportionalOption then
            if ratioX ~= 1 then
                currentPosition[3] = math.floor(currentPosition[3] * ratioX)
                currentPosition[4] = math.floor(currentPosition[3] / (oldSize[1] / oldSize[2]))
            else
                currentPosition[4] = math.floor(currentPosition[4] * ratioY)
                currentPosition[3] = math.floor(currentPosition[4] / (oldSize[1] / oldSize[2]))
            end
        end
        if pinOption[1] then
            currentPosition[1] = currentPosition[1] + diffX
            if proportionalOption then
                currentPosition[1] = currentPosition[1] - (currentPosition[3] - oldSize[1])
            end
        end
        if pinOption[2] then
            currentPosition[2] = currentPosition[2] + diffY
            if propportionalOption then
                currentPosition[2] = currentPosition[2] - (currentPosition[4] - oldSize[2])
            end
        end

        set(popups.components[i].position, currentPosition)
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
