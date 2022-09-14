-------------------------------------------------------------------------------
-- Default events handlers
-------------------------------------------------------------------------------

--- Default mouse click handler for component.
--- @param comp Component
--- @param _ number
--- @param _ number
--- @param button MouseButton
--- @param parentX number
--- @param parentY number
--- @return boolean
function private.defaultOnMouseHold(comp, _, _, button, parentX, parentY)
    if button == 1 and get(comp.movable) and comp.dragging == 1 then
        local position = get(comp.position)
        comp.dragStartX = parentX
        comp.dragStartY = parentY
        comp.dragStartPosX = position[1]
        comp.dragStartPosY = position[2]
        comp.dragging = 2
        return true
    end
    return false
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Default mouse down handler for component.
--- @param comp Component
--- @param x number
--- @param y number
--- @param button MouseButton
--- @param parentX number
--- @param parentY number
--- @return boolean
function private.defaultOnMouseDown(comp, x, y, button, parentX, parentY)
    if button == 1 and get(comp.resizable) and isInRect(comp.resizeRect, x, y) then
        local pos = get(comp.position)
        comp.resizing = true
        comp.dragStartX = parentX
        comp.dragStartY = parentY
        comp.dragStartPosX = pos[1]
        comp.dragStartPosY = pos[2]
        comp.dragStartSizeX = pos[3]
        comp.dragStartSizeY = pos[4]
        return true
    end

    if button == 1 and get(comp.movable) then
        comp.dragging = 1
        return true
    end
    return false
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Default mouse up handler for component.
--- @param comp Component
--- @param _ number
--- @param _ number
--- @param button MouseButton
--- @param _ number
--- @param _ number
--- @return boolean
function private.defaultOnMouseUp(comp, _, _, button, _, _)
    if button == 1 and (get(comp.movable) or get(comp.resizable)) then
        if comp.dragging then
            comp.dragging = 0
        end
        if get(comp.resizable) and comp.resizing then
            comp.resizing = false
        end
        return true
    end
    return false
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Default mouse move handler for component.
--- @param comp Component
--- @param _ number
--- @param _ number
--- @param _ MouseButton
--- @param parentX number
--- @param parentY number
--- @return boolean
function private.defaultOnMouseMove(comp, _, _, _, parentX, parentY)
    if rawget(comp, "resizing") then
        local pos = get(comp.position)
        local newSizeX = comp.dragStartSizeX + (parentX - comp.dragStartX)
        local newSizeY = comp.dragStartSizeY - (parentY - comp.dragStartY)

        if newSizeX < 10 then
            newSizeX = 10
        end
        if newSizeY < 10 then
            newSizeY = 10
        end

        if toboolean(get(comp.resizeProportional)) then
            ratio =  comp.dragStartSizeX / comp.dragStartSizeY
            propHeight = newSizeX / ratio;
            propWidth = newSizeY * ratio;
            if propHeight > newSizeY then
                newSizeY = propHeight
            else
                newSizeX = propWidth
            end
        end

        pos[2] = comp.dragStartY - (newSizeY - comp.dragStartSizeY)
        pos[3] = newSizeX
        pos[4] = newSizeY
        set(comp.position, pos)
        return true
    end

    if rawget(comp, "dragging") == 2 and get(comp.movable) then
        local position = get(comp.position)
        position[1] = comp.dragStartPosX + (parentX - comp.dragStartX)
        position[2] = comp.dragStartPosY + (parentY - comp.dragStartY)
        set(comp.position, position)
        return true
    else
        return false
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Default mouse wheel handler for component.
--- @return boolean
function private.defaultOnMouseWheel()
    return false
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Default key down handler.
--- @return boolean
function private.defaultOnKeyDown()
    return false
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Default key up handler.
--- @return boolean
function private.defaultOnKeyUp()
    return false
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
