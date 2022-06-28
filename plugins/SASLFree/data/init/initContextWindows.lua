---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

local function runTopHandlerContextWindow(component, name, x, y, button, value)
    local path = { }
    local res = runHandler(component, name, x, y, button, path, value)
    if res then
        return true, path
    end
end

local function getTopFocusedPathContextWindow(component, x, y)
    local path = { }
    getFocusedPath(component, x, y, path)
    return path
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

local function contextWindowHeaderDrawDef(window, w, h)
    local elColor = { 0.8, 0.8, 0.8, 1.0 }
    sasl.gl.drawRectangle(0, 0, w, h, { 0.28, 0.28, 0.28, 1.0 })

    sasl.gl.drawWideLine(7, 7, h - 7, h - 7, 2, elColor)
    sasl.gl.drawWideLine(7, h - 7, h - 7, 7, 2, elColor)
    sasl.gl.drawConvexPolygon({ h + 7, 7, h + 18, 7, h + 18, h - 7, h + 7, h - 7 }, false, 1, elColor)
    sasl.gl.drawWidePolyLine({ h + 10, h - 7, h + 10, 10, h + 18, 10 }, 1, elColor)

    sasl.gl.drawWideLine(w - 7, 7, w - h + 7, h - 7, 2, elColor)
    sasl.gl.drawWideLine(w - 7, h - 7, w - h + 7, 7, 2, elColor)
    sasl.gl.drawConvexPolygon({ w - 2 * h + 7, 7, w - 2 * h + 18, 7, w - 2 * h + 18, h - 7, w - 2 * h + 7, h - 7 }, false, 1, elColor)
    sasl.gl.drawWidePolyLine({ w - 2 * h + 10, h - 7, w - 2 * h + 10, 10, w - 2 * h + 18, 10 }, 1, elColor)
end

local function contextWindowHeaderMDownDef(window, x, y, w, h, button)
    if isInRect({ 0, 0, h, h }, x, y) or isInRect({ w - h, 0, h, h }, x, y) then
        window:setIsVisible(false)
        return true
    end
    if isInRect({ h, 0, h, h }, x, y) or isInRect({ w - 2 * h, 0, h, h }, x, y) then
        window:setMode(SASL_CW_MODE_POPOUT)
        return true
    end
    return false
end

local function getContextWindowDecorationDef(window)
    return {
        headerHeight = 25,
        draw = function(w, h) contextWindowHeaderDrawDef(window, w, h) end,
        onMouseDown = function(x, y, w, h, button) return contextWindowHeaderMDownDef(window, x, y, w, h, button) end,
        onMouseUp = function(x, y, w, h, button) return false end,
        onMouseHold = function(x, y, w, h, button) return false end,
        onMouseMove = function(x, y, w, h) return 1 end,
        onMouseWheel = function(x, y, w, h, clicks) return false end,
        main = {}
    }
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

function contextWindow(tbl)
    local window = {}
    local c = createComponent("cWindow")
    c.position = createProperty { 0, 0, 0, 0 }

    local cwDecoration = SASL_CW_DECORATED_XP
    if get(tbl.noDecore) then
        cwDecoration = SASL_CW_NON_DECORATED
    elseif get(tbl.customDecore) then
        cwDecoration = SASL_CW_DECORATED
    end

    local layer = SASL_CW_LAYER_FLOATING_WINDOWS
    if tbl.layer ~= nil then
        layer = tbl.layer
    end

    set(c.position, { 0, 0, tbl.position[3], tbl.position[4] })
    set(c.clip, tbl.clip)
    set(c.clipSize, tbl.clipSize)
    if tbl.visible ~= nil then
        set(c.visible, tbl.visible)
    else
        set(c.visible, false)
    end
    c.size = { tbl.position[3], tbl.position[4] }
    c.components = tbl.components

    startComponentsCreation(tbl)
    if not get(tbl.noBackground) then
        if not rectangle then
            rectangle = loadComponent('rectangle')
        end

        table.insert(c.components, 1,
           rectangle { position = { 0, 0, c.size[1], c.size[2] } } )
    end
    finishComponentsCreation()

    ------------------------------------------------------------------------------------------------------

    function drawContextWindow(wId)
        drawComponent(c)
    end

    function onMouseDownContextWindow(wId, x, y, button)
        setFocusedPath(getTopFocusedPathContextWindow(c, x, y))
        setPressedButton(button)
        local handled, path = runTopHandlerContextWindow(c, "onMouseDown", x, y, button, 0)
        if handled then
            setPressedComponentPath(path)
        end
        return handled
    end

    function onMouseUpContextWindow(wId, x, y, button)
        local currentPressedComponentPath = getPressedComponentPath()
        if currentPressedComponentPath then
            local res = runPressedHandler(currentPressedComponentPath, "onMouseUp",
                    x, y, button, 0)
            setPressedButton(0)
            setPressedComponentPath(nil)
            return res
        else
            return runTopHandlerContextWindow(c, "onMouseUp", x, y, button, 0)
        end
    end

    function onMouseHoldContextWindow(wId, x, y, button)
        local pressedPath = getPressedComponentPath()
        if pressedPath then
            setCursor(cursor.shape)
            return runPressedHandler(pressedPath, "onMouseHold",
                    x, y, button, 0)
        else
            setPressedButton(button)
            local handled, path = runTopHandlerContextWindow(c, "onMouseHold", x, y, button, 0)
            if handled then
                setPressedComponentPath(path)
            end
            return handled
        end
    end

    function onMouseMoveContextWindow(wId, x, y)
        setOnInterceptingWindow(false)
        sasl.gl.setCursorLayer(wId)
        local resultCursorID = 0
        local res
        local pressedPath = getPressedComponentPath()
        if pressedPath then
            resultCursorID = 1
            local hideOSCursorMode = setCursor(cursor.shape)
            if hideOSCursorMode then
                resultCursorID = 2
            end
            res = runPressedHandler(pressedPath, "onMouseMove",
                    x, y, getPressedButton(), 0)
        else
            local cursor = getCursorShape(c, x, y)
            local hideOSCursorMode = setCursor(cursor)
            if hideOSCursorMode then
                resultCursorID = 2
            end
            local path
            res, path = runTopHandlerContextWindow(c, "onMouseMove", x, y, getPressedButton(), 0)
            local currentEnteredComponent = getEnteredComponent()
            if res == true then
                if currentEnteredComponent ~= path[1] then
                    if currentEnteredComponent ~= nil then
                        leaveHandler = rawget(currentEnteredComponent, "onMouseLeave")
                        if leaveHandler ~= nil then
                            leaveHandler()
                        end
                    end
                    setEnteredComponent(path[1])
                    enterHandler = rawget(getEnteredComponent(), "onMouseEnter")
                    if enterHandler ~= nil then
                        enterHandler()
                    end
                end
            else
                if currentEnteredComponent ~= nil then
                    leaveHandler = rawget(currentEnteredComponent, "onMouseLeave")
                    if leaveHandler ~= nil then
                        leaveHandler()
                    end
                end
                setEnteredComponent(nil)
            end
        end
        return resultCursorID
    end

    function onMouseWheelContextWindow(wId, x, y, wheelClicks)
        local pressedPath = getPressedComponentPath()
        if pressedPath then
            local res = runPressedHandler(pressedPath, "onMouseWheel",
                    x, y, 4, wheelClicks)
            return res
        else
            return runTopHandlerContextWindow(c, "onMouseWheel", x, y, 4, wheelClicks)
        end
    end

    local resizeCallback = tbl.resizeCallback
    function onContextWindowResize(wId, width, height, mode, proportional)
        if resizeCallback then
            return resizeCallback(c, width, height, mode, proportional)
        else
            local cP = get(c.position)
            if proportional and
                (mode == SASL_CW_MODE_POPOUT or
                mode == SASL_CW_MODE_MONITOR_FULL or
                cwDecoration == SASL_CW_DECORATED_XP)
            then
                local center = { width / 2, height / 2 }
                local scale = math.min(width / cP[3], height / cP[4])

                cP[3] = cP[3] * scale
                cP[4] = cP[4] * scale
                cP[1] = math.floor(center[1] - cP[3] / 2)
                cP[2] = math.floor(center[2] - cP[4] / 2)
            else
                cP[3] = width
                cP[4] = height
                cP[1] = 0
                cP[2] = 0
            end
            set(c.position, cP)
            return cP[1], cP[2], cP[3], cP[4]
        end
    end

    function onContextWindowLayoutChange(wId, isInFront)
        local currentFocusedComponentPath = getFocusedComponentPath()
        local focusedNow = false
        if currentFocusedComponentPath then
            focusedNow = currentFocusedComponentPath[1] == c
            if focusedNow and not isInFront then
                setFocusedPath(nil)
            end
        end
        if not focusedNow and isInFront then
            setFocusedPath({ c })
        end
    end

    ------------------------------------------------------------------------------------------------------

    local p = tbl.position
    window.id = sasl.windows.createContextWindow(cwDecoration, layer, p[1], p[2], p[3], p[4],
        drawContextWindow,
        onMouseDownContextWindow,
        onMouseUpContextWindow,
        onMouseHoldContextWindow,
        onMouseMoveContextWindow,
        onMouseWheelContextWindow,
        onContextWindowResize,
        onContextWindowLayoutChange)

    window.component = c

    ------------------------------------------------------------------------------------------------------

    if cwDecoration == SASL_CW_DECORATED then
        window.decoration = getContextWindowDecorationDef(window)
        local decor = window.decoration
        if tbl.decoration ~= nil then
            for k, v in pairs(tbl.decoration) do
                decor[k] = v
            end
        end
        sasl.windows.setContextWindowDecoration(window.id, decor.headerHeight,
            decor.draw, decor.onMouseDown, decor.onMouseUp,
            decor.onMouseHold, decor.onMouseMove, decor.onMouseWheel,
            decor.main.draw, decor.main.onMouseDown, decor.main.onMouseUp,
            decor.main.onMouseHold, decor.main.onMouseMove, decor.main.onMouseWheel)
    end

    ------------------------------------------------------------------------------------------------------

    window.setSizeLimits = function(self, minWidth, minHeight, maxWidth, maxHeight)
        sasl.windows.setContextWindowSizeLimits(self.id, minWidth, minHeight, maxWidth, maxHeight)
    end
    window.getSizeLimits = function(self)
        local minW, minH, maxW, maxH = sasl.windows.getContextWindowSizeLimits(self.id)
        return minW, minH, maxW, maxH
    end
    window.setResizeMode = function(self, mode)
        sasl.windows.setContextWindowResizeMode(self.id, mode)
    end

    local sLimits = { 100, 100, 2048, 2048 }
    if get(tbl.minimumSize) then
        sLimits[1] = tbl.minimumSize[1]
        sLimits[2] = tbl.minimumSize[2]
    end
    if get(tbl.maximumSize) then
        sLimits[3] = tbl.maximumSize[1]
        sLimits[4] = tbl.maximumSize[2]
    end
    window:setSizeLimits(sLimits[1], sLimits[2], sLimits[3], sLimits[4])

    local resizeMode = SASL_CW_RESIZE_ALL_BOUNDS
    if tbl.resizeMode ~= nil then
        resizeMode = tbl.resizeMode
    end
    window:setResizeMode(resizeMode)

    ------------------------------------------------------------------------------------------------------

    window.setIsVisible = function(self, isVisible)
        sasl.windows.setContextWindowVisible(self.id, isVisible)
        set(self.component.visible, isVisible)
        if not isVisible then
            setPressedComponentPath(nil)
            cursor.shape = nil
        end
    end
    window.isVisible = function(self)
        return sasl.windows.getContextWindowVisible(self.id)
    end

    if not get(c.visible) then
        window:setIsVisible(false)
    end

    ------------------------------------------------------------------------------------------------------

    if get(tbl.command) then
        local command = sasl.createCommand(get(tbl.command), get(tbl.description))

        function commandHandler(phase)
            if phase == SASL_COMMAND_BEGIN then
                window:setIsVisible(not window:isVisible())
            end
            return 0
        end

        sasl.registerCommandHandler(command, 0, commandHandler)
    end

    ------------------------------------------------------------------------------------------------------

    window.setTitle = function(self, title)
        sasl.windows.setContextWindowTitle(self.id, title)
    end
    if get(tbl.name) then
        window:setTitle(get(tbl.name))
    end

    window.setGravity = function(self, left, top, right, bottom)
        sasl.windows.setContextWindowGravity(self.id, left, top, right, bottom)
    end
    if get(tbl.gravity) then
        local gr = get(get(tbl.gravity))
        window:setGravity(gr[1], gr[2], gr[3], gr[4])
    end

    window.setPosition = function(self, x, y, width, height)
        sasl.windows.setContextWindowPosition(self.id, x, y, width, height)
    end
    window.getPosition = function(self)
        return sasl.windows.getContextWindowPosition(self.id)
    end

    ------------------------------------------------------------------------------------------------------

    window.setMode = function(self, mode, monitor)
        setCursor(nil)
        sasl.windows.setContextWindowMode(self.id, mode, monitor)
    end

    window.getMode = function(self)
        return sasl.windows.getContextWindowMode(self.id)
    end

    window.isPoppedOut = function(self)
        return sasl.windows.isContextWindowPoppedOut(self.id)
    end

    window.isInVR = function(self)
        return sasl.windows.isContextWindowInVR(self.id)
    end

    local autoVr = false
    window.setVrAutoHandling = function(self, auto)
        sasl.windows.setContextWindowVrAutoHandling(self.id, auto)
    end
    if tbl.vrAuto ~= nil then
        autoVr = tbl.vrAuto
    end
    window:setVrAutoHandling(autoVr)

    ------------------------------------------------------------------------------------------------------

    local proportional = true
    if tbl.proportional ~= nil then
        proportional = tbl.proportional
    end
    window.setProportional = function(self, isProportional)
        sasl.windows.setContextWindowProportional(self.id, isProportional)
    end
    window:setProportional(proportional)

    window.setResizable = function(self, isResizable)
        sasl.windows.setContextWindowResizable(self.id, isResizable)
    end
    if tbl.noResize then
        window:setResizable(false)
        window:setSizeLimits(p[3], p[4], p[3], p[4])
    end

    window.setMovable = function(self, isMovable)
        sasl.windows.setContextWindowMovable(self.id, isMovable)
    end
    if tbl.noMove then
        window:setMovable(false)
    end

    ------------------------------------------------------------------------------------------------------

    window.setCallback = function(self, callback)
        sasl.windows.setContextWindowCallback(self.id, callback)
    end
    if tbl.callback ~= nil then
        window:setCallback(tbl.callback)
    end

    ------------------------------------------------------------------------------------------------------

    contextWindows.component(c)
    return window
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
