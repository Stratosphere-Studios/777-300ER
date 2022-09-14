-------------------------------------------------------------------------------
-- Setup paths for additional packages and 3-rd party libraries
-------------------------------------------------------------------------------

local prPath = getProjectPath()
package.path = package.path .. ';' .. prPath .. '/3rd-modules/?.lua'
package.path = package.path .. ';' .. prPath .. '/Custom Module/?.lua'

local __OS = sasl.getOS()
local __PackExt

if __OS == "Windows" then
    __PackExt = "dll"
elseif __OS == "Linux" then
    __PackExt = "so"
else
    __PackExt = "dylib"
end

package.cpath = package.cpath .. ';' .. prPath .. '/3rd-modules/?.' .. __PackExt
package.cpath = package.cpath .. ';' .. prPath .. '/Custom Module/?.' .. __PackExt
_SLOADED = {}

-------------------------------------------------------------------------------
-- Components
-------------------------------------------------------------------------------

--- @class Component
--- @field components Component[]
--- @field component fun(comp:Component):Component
--- @field defineProperty fun(name:string, dflt:any)
--- @field include fun(name:string)
--- @field fbo Property | boolean
--- @field fpsLimit Property | number
--- @field noRenderSignal Property | boolean
--- @field clip Property | boolean
--- @field clipSize Property | number[]
--- @field draw fun(self:Component)
--- @field drawObjects fun(self:Component)
--- @field draw3D fun(self:Component)
--- @field update fun(self:Component)
--- @field name string
--- @field visible Property | boolean
--- @field movable Property | boolean
--- @field resizable Property | boolean
--- @field resizeProportional Property | boolean
--- @field onMouseDown fun(self:Component, x:number, y:number, button:MouseButton, parentX:number, parentY:number):boolean
--- @field onMouseUp fun(self:Component, x:number, y:number, button:MouseButton, parentX:number, parentY:number):boolean
--- @field onMouseHold fun(self:Component, x:number, y:number, button:MouseButton, parentX:number, parentY:number):boolean
--- @field onMouseMove fun(self:Component, x:number, y:number, button:MouseButton, parentX:number, parentY:number):boolean
--- @field onMouseWheel fun(self:Component, x:number, y:number, button:MouseButton, parentX:number, parentY:number, wheelClicks:number):boolean
--- @field onKeyDown fun(self:Component, char:number, key:number, shiftDown:number, ctrlDown:number, AltOptDown:number):boolean
--- @field onKeyUp fun(self:Component, char:number, key:number, shiftDown:number, ctrlDown:number, AltOptDown:number):boolean
--- @field logInfo fun(...)
--- @field logWarning fun(...)
--- @field logDebug fun(...)
--- @field logError fun(...)
--- @field print fun(...)

--- Creates basic component.
--- @param name string
--- @param parent Component
--- @return Component
function private.createComponent(name, parent)
    local data = {
        components = {},
        fbo = createProperty(false),
        renderTarget = -1,
        fpsLimit = createProperty(-1),
        frames = 0,
        noRenderSignal = createProperty(false),
        clip = createProperty(false),
        clipSize = createProperty { 0, 0, 0, 0 },
        draw = function(comp) drawAll(comp.components) end,
        drawObjects = function(comp) drawAllObjects(comp.components) end,
        draw3D = function(comp) drawAll3D(comp.components) end,
        update = function(comp) updateAll(comp.components) end,
        name = name,
        visible = createProperty(true),
        movable = createProperty(false),
        resizable = createProperty(false),
        focused = createProperty(false),
        resizeProportional = createProperty(true),
        onMouseDown = private.defaultOnMouseDown,
        onMouseUp = private.defaultOnMouseUp,
        onMouseHold = private.defaultOnMouseHold,
        onMouseMove = private.defaultOnMouseMove,
        onMouseWheel = private.defaultOnMouseWheel,
        onKeyDown = private.defaultOnKeyDown,
        onKeyUp = private.defaultOnKeyUp,
        logInfo = function(...) sasl.logInfo('"'..name..'"', ...) end,
        logError = function(...) sasl.logError('"'..name..'"', ...) end,
        logDebug = function(...) sasl.logDebug('"'..name..'"', ...) end,
        logWarning = function(...) sasl.logWarning('"'..name..'"', ...) end,
        print = function(...) sasl.print('"'..name..'"', ...) end
    }
    data._C = data
    if parent then
        data._P = parent
        if parent.position then
            local parentPosition = get(parent.position)
            data.size = { parentPosition[3], parentPosition[4] }
        elseif parent.size then
            data.size = parent.size
        end
        data.position = createProperty { 0, 0, data.size[1], data.size[2] }
    end
    private.addComponentFunc(data)
    return data
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Index lookup function for components system.
--- @param table table
--- @param key any
function private.compIndex(table, key)
    local comp = table
    while comp ~= nil do
        local v = rawget(comp, key)
        if v ~= nil then
            return v
        else
            comp = rawget(comp, '_P')
        end
    end

    v = _G[key]
    if v == nil then
        return loadComponent(key)
    else
        return v
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Creates <component> function for specified component.
--- @param component Component
--- @return Component
function private.addComponentFunc(component)
    component.component = function(comp)
        table.insert(component.components, comp)
        return comp
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Adds properties to component and setup component helper functions.
--- @param component Component
--- @param args table
function private.setupComponent(component, args)
    private.mergeComponentTables(component, private.argumentsToProperties(args))
    setmetatable(component, { __index = private.compIndex })

    component.defineProperty = function(name, dflt)
        if not rawget(component, name) then
            component[name] = createProperty(dflt)
        end
    end

    component.include = function(name)
        include(component, name)
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Components creation stack.
local creatingComponents = {}

--- Starts creation of components using current stack level.
--- @param parent Component
function private.startComponentsCreation(parent)
    table.insert(creatingComponents, parent)
end

--- Finishes creation of components using current stack level.
function private.finishComponentsCreation()
    table.remove(creatingComponents)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Loads component from constructor function.
--- @param name string
--- @param constructor function
--- @return function
function registerComponent(name, constructor)
    return loadComponent(name, constructor, false)
end

--- Loads component from file or predefined function and creates constructor.
--- @param name string
--- @param source string | function
--- @param isRoot boolean
--- @return function
function loadComponent(name, source, isRoot)
    local f, subdir, fileName

    if type(source) == "function" then
        f = source
    else
        fileName = source
        if not isRoot then
            logInfo("loading", name)
        end

        if not fileName then
            fileName = name..".lua"
        end

        f, subdir = openFile(fileName)
        if not f then
            logError("can't load component", name)
            return nil
        end
    end

    local constr = function(args)
        local parent = creatingComponents[#creatingComponents]
        if parent then
            if parent.name == "module" and parent.size then
                parent.position = createProperty { 0, 0, parent.size[1], parent.size[2] }
            end
        elseif args.parent then
            parent = args.parent
        end

        if subdir then
            addSearchPath(subdir)
        end
        local t = private.createComponent(name, parent)
        args.parent = nil
        t.componentFileName = fileName

        private.setupComponent(t, args)
        if isProperty(t.position) or type(t.position) == 'function' then
            local curPosition = get(t.position)
            t.size = { curPosition[3], curPosition[4] }
        elseif parent then
            t.size = { 0, 0 }
            if isProperty(parent.position) or type(parent.position) == 'function' then
                local parentPosition = get(parent.position)
                t.size = { parentPosition[3], parentPosition[4] }
            elseif parent.size then
                t.size = parent.size
            end
            t.position = createProperty { 0, 0, t.size[1], t.size[2] }
        end

        private.startComponentsCreation(t)
        setfenv(f, t)
        f(t)
        private.finishComponentsCreation()

        if get(t.fpsLimit) ~= -1 then
            set(t.fbo, true)
        end

        if toboolean(get(t.fbo)) then
            t.renderTarget = sasl.gl.createRenderTarget(t.size[1], t.size[2])
        end

        if subdir then
            popSearchPath(subdir)
        end
        return t
    end

    _G[name] = constr
    return constr
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Loads script inside component environment.
--- @param component Component
--- @param name string
function include(component, name)
    logInfo("including", name)
    name = appendDefaultFileExtension(name)

    local f, subdir = openFile(name, true)
    if not f then
        logError("Can't include script "..name)
    else
        if subdir then
            addSearchPath(subdir)
        end

        setfenv(f, component)
        f()

        if subdir then
            popSearchPath(subdir)
        end
    end
end

--- Loads and provides SASL Lua module. Mimics standard
--- 'require' behavior, but loads only Lua scripts using current SASL project
--- search paths and scripts naming conventions.
--- @param name string
--- @param forceInstance boolean
--- @return any
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#request
function request(name, forceInstance)
    logInfo("requesting", name)
    name = appendDefaultFileExtension(name)
    if _SLOADED[name] then
        if _SLOADED[name] == _SGUARD then
            logError("Loop during script request or error on previous script request")
            return nil
        end
        local fInst = forceInstance or false
        if not fInst then
            return _SLOADED[name]
        end
    end
    local oName = name
    local f, subdir = openFile(name, true)
    if not f then
        logError("Can't request script "..oName)
        return nil
    else
        _SLOADED[oName] = _SGUARD
        if subdir then
            addSearchPath(subdir)
        end
        local r = f()
        if subdir then
            popSearchPath(subdir)
        end
        if r then
            _SLOADED[oName] = r
        end
        if _SLOADED[oName] == _SGUARD then
            _SLOADED[oName] = true
            return true
        end
        return _SLOADED[oName]
    end
end

-------------------------------------------------------------------------------
-- Global internal settings and states
-------------------------------------------------------------------------------

globalShowInteractiveAreas = false
private.savedState = nil

function private.initState()
    private.savedState = {}
    private.savedState.legacyPopups = {}
    private.savedState.contextWindows = {}
end

--- Saves current state.
function private.saveState()
    private.savePopupsState()
    private.saveContextWindowsState()
    private.writeTableToFile(moduleDirectory.."/state.txt", private.savedState, "state")
end

--- Loads current state.
function private.loadState()
    private.initState()
    local savedStateFile = loadfile(moduleDirectory.."/state.txt")
    if savedStateFile ~= nil then
        local temp = {}
        setfenv(savedStateFile, temp)
        savedStateFile()
        private.savedState = temp["state"]
    end
end

-------------------------------------------------------------------------------
-- Common functional for mouse events handlers
-------------------------------------------------------------------------------

--- Runs mouse event handler of component.
--- @param component Component
--- @param name string
--- @param mx number
--- @param my number
--- @param button number
--- @param x number
--- @param y number
--- @param value number
--- @return boolean
function private.runMouseEventComp(component, name, mx, my, button, x, y, value)
    local handler = rawget(component, name)
    if handler then
        return handler(component, mx, my, button, x, y, value)
    else
        return false
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Goes through components hierarchy and executes most appropriate event handler with specified name.
--- @param component Component
--- @param name string
--- @param x number
--- @param y number
--- @param button number
--- @param value number
--- @return boolean, Component[]
function private.runMouseEvent(component, name, x, y, button, value)
    local function runMouseEvent(component, name, x, y, button, path, value)
        local position = get(component.position)
        local size = component.size
        if not (position and size) then
            return false
        end
        local mx = (x - position[1]) * size[1] / position[3]
        local my = (y - position[2]) * size[2] / position[4]
        for i = #component.components, 1, -1 do
            local v = component.components[i]
            if toboolean(get(v.visible)) and isInRect(get(v.position), mx, my) then
                local res = runMouseEvent(v, name, mx, my, button, path, value)
                if res then
                    if path then
                        table.insert(path, component)
                    end
                    return true
                end
            end
        end
        local res = private.runMouseEventComp(component, name, mx, my, button, x, y, value)
        if res then
            if path then
                table.insert(path, component)
            end
        end
        return res
    end

    local path = {}
    return runMouseEvent(component, name, x, y, button, path, value), path
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Runs mouse event for specific component.
--- @param path Component[]
--- @param name string
--- @param x number
--- @param y number
--- @param button number
--- @param value number
--- @return boolean
function private.runMouseEventByPath(path, name, x, y, button, value)
    local mx = x
    local my = y
    local px = x
    local py = y
    for i = #path, 1, -1 do
        local c = path[i]
        px = mx
        py = my
        local position = get(c.position)
        mx = (mx - position[1]) * c.size[1] / position[3]
        my = (my - position[2]) * c.size[2] / position[4]
    end
    return private.runMouseEventComp(path[1], name, mx, my, button, px, py, value)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Returns path to component under mouse.
--- @param component Component
--- @param x number
--- @param y number
--- @return Component[]
function private.getMouseHoverPath(component, x, y)
    local function getMouseHoverPath(component, x, y, path)
        table.insert(path, component)
        local position = get(component.position)
        local size = component.size
        if not (position and size) then
            return
        end
        local mx = (x - position[1]) * size[1] / position[3]
        local my = (y - position[2]) * size[2] / position[4]
        for i = #component.components, 1, -1 do
            local v = component.components[i]
            if toboolean(get(v.visible)) and isInRect(get(v.position), mx, my) then
                getMouseHoverPath(v, mx, my, path)
            end
        end
    end

    local path = {}
    getMouseHoverPath(component, x, y, path)
    return path
end

-------------------------------------------------------------------------------
-- Auxiliary functional for cursors
-------------------------------------------------------------------------------

--- @class Cursor
--- @field x number
--- @field y number
--- @field width number
--- @field height number
--- @field shape number
--- @field hideOSCursor boolean

--- Cursor state and position.
private.cursor = nil
private.cursorLayer = 0

local function isCursorTable(c)
    return c.x ~= nil and
        c.y ~= nil and
        c.width ~= nil and
        c.height ~= nil and
        c.shape ~= nil
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Sets cursor.
--- @param cursor Cursor
function private.setCursor(cursor)
    private.cursor = get(cursor)
    local sh = private.cursor
    if sh ~= nil and isCursorTable(sh) then
        sasl.gl.setCursorShape(true, sh.shape, sh.x, sh.y, sh.width, sh.height)
    else
        sasl.gl.setCursorShape(false)
    end
end

--- Sets current cursor layer.
--- @param layer number
function private.setCursorLayer(layer)
    private.cursorLayer = layer
    sasl.gl.setCursorLayer(layer)
end

--- Gets current cursor layer.
function private.getCursorLayer()
    return private.cursorLayer
end

--- Checks if OS cursor should be hidden for current cursor.
--- @return boolean
function private.isOSCursorHidden()
    local sh = private.cursor
    if sh ~= nil and isCursorTable(sh) then
        if sh.hideOSCursor ~= nil and sh.hideOSCursor == true then
            return true
        end
    end
    return false
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Runs through components hierarchy and finds most appropriate cursor.
--- @param component Component
--- @param x number
--- @param y number
--- @return Cursor
function private.getComponentCursor(component, x, y)
    local position = get(component.position)
    local size = component.size
    if not (position and size) then
        return nil
    end
    local mx = (x - position[1]) * size[1] / position[3]
    local my = (y - position[2]) * size[2] / position[4]
    for i = #component.components, 1, -1 do
        local v = component.components[i]
        if toboolean(get(v.visible)) and isInRect(get(v.position), mx, my) then
            local res = private.getComponentCursor(v, mx, my)
            if res then
                return res
            end
        end
    end
    return rawget(component, "cursor")
end

-------------------------------------------------------------------------------
-- Auxiliary functional for interaction system
-------------------------------------------------------------------------------

private.eventCounter = 0

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local pressedButton = 0

function private.setPressedButton(button)
    pressedButton = button
end

function private.getPressedButton()
    return pressedButton
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local pressedComponentPath = {}

function private.setPressedComponentPath(path)
    pressedComponentPath[private.eventCounter] = path
end

function private.getPressedComponentPath()
    return pressedComponentPath[private.eventCounter]
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local enteredComponent = {}

function private.setEnteredComponent(c)
    enteredComponent[private.eventCounter] = c
end

function private.getEnteredComponent()
    return enteredComponent[private.eventCounter]
end

-------------------------------------------------------------------------------
-- Focusing
-------------------------------------------------------------------------------

local focusedComponentPath = {}

function private.setFocusedComponentPath(path)
    focusedComponentPath[private.eventCounter] = path
end

function private.getFocusedComponentPath()
    return focusedComponentPath[private.eventCounter]
end

function private.clearFocusedComponentPaths()
    for _, v in ipairs(focusedComponentPath) do
        for _, c in ipairs(v) do
            set(c.focused, false)
        end
    end
    focusedComponentPath = {}
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Sets focused component path.
--- @param path Component[]
function private.setFocusedPath(path)
    if path and #path == 0 then
        path = nil
    end
    local currentFocusedComponentPath = private.getFocusedComponentPath()
    if currentFocusedComponentPath then
        for _, c in ipairs(currentFocusedComponentPath) do
            set(c.focused, false)
        end
    end
    private.setFocusedComponentPath(path)
    if path then
        for _, c in ipairs(path) do
            set(c.focused, true)
        end
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Runs specified key event handler for currently visible focused component.
--- @param root Component
--- @param name string
--- @param char number
--- @param key number
--- @param shiftDown number
--- @param ctrlDown number
--- @param altOptDown number
--- @return boolean
function private.runKeyEventFocused(root, name, char, key, shiftDown, ctrlDown, altOptDown)
    private.eventCounter = private.eventCounter + 1
    local handled = false
    local currentFocusedComponentPath = private.getFocusedComponentPath()
    if currentFocusedComponentPath then
        local allowEvent = true
        if root ~= nil then
            local rootHasFocused = false
            for i = 1, #currentFocusedComponentPath do
                if currentFocusedComponentPath[i] == root then
                    rootHasFocused = true
                    break
                end
            end
            allowEvent = rootHasFocused
        end
        if allowEvent then
            local maxVisible = 0
            for i = 1, #currentFocusedComponentPath, 1 do
                local c = currentFocusedComponentPath[i]
                if toboolean(get(c.visible)) then
                    maxVisible = i
                else
                    break
                end
            end
            for i = maxVisible, 1, -1 do
                local c = currentFocusedComponentPath[i]
                local res = c[name](c, char, key, shiftDown, ctrlDown, altOptDown)
                if res then
                    handled = true
                end
            end
        end
    end
    private.eventCounter = private.eventCounter - 1
    return handled
end

--- Runs key down event handler for currently visible focused component.
--- @param root Component
--- @param char number
--- @param key number
--- @param shiftDown number
--- @param ctrlDown number
--- @param altOptDown number
--- @return boolean
function processKeyDownEvent(root, char, key, shiftDown, ctrlDown, altOptDown)
    return private.runKeyEventFocused(root, "onKeyDown", char, key, shiftDown, ctrlDown, altOptDown)
end

--- Runs key up event handler for currently visible focused component.
--- @param root Component
--- @param char number
--- @param key number
--- @param shiftDown number
--- @param ctrlDown number
--- @param altOptDown number
--- @return boolean
function processKeyUpEvent(root, char, key, shiftDown, ctrlDown, altOptDown)
    return private.runKeyEventFocused(root, "onKeyUp", char, key, shiftDown, ctrlDown, altOptDown)
end

-------------------------------------------------------------------------------
-- Functional for legacy intercepting window
-------------------------------------------------------------------------------

local onInterceptingWindow = false

--- Activates/deactivates cursor for legacy intercepting window.
--- @param isOn boolean
function private.setOnInterceptingWindow(isOn)
    if isOn then
        private.setCursorLayer(0)
        if onInterceptingWindow ~= isOn then
            private.setCursor(nil)
        end
    end
    onInterceptingWindow = isOn
end

-------------------------------------------------------------------------------
-- General mouse events handlers for components system
-------------------------------------------------------------------------------

--- Finds and executes mouse button down event for components hierarchy.
--- @param component Component
--- @param x number
--- @param y number
--- @param button number
--- @return boolean
function processMouseDown(component, x, y, button)
    private.eventCounter = private.eventCounter + 1
    private.setFocusedPath(private.getMouseHoverPath(component, x, y))
    private.setPressedButton(button)
    local handled, path = private.runMouseEvent(component, "onMouseDown", x, y, button)
    if handled then
        private.setPressedComponentPath(path)
    end
    private.eventCounter = private.eventCounter - 1
    return handled
end

--- Called when mouse button was pressed.
function onMouseDown(x, y, button, layer)
    private.eventCounter = 1
    if layer == MB_LAYER_POPUP or button == MB_LEFT then
        local path = private.getMouseHoverPath(layer == MB_LAYER_POPUP and popups or panel, x, y)
        if layer == MB_LAYER_POPUP and #path == 1 then
            path = {}
        end
        private.setFocusedPath(path)
    end
    private.setPressedButton(button)
    local handled, path = private.runMouseEvent(layer == MB_LAYER_POPUP and popups or panel, "onMouseDown", x, y, button)
    if handled then
        private.setPressedComponentPath(path)
        if layer == MB_LAYER_POPUP then
            local comp = path[1]
            for i, v in ipairs(popups.components) do
                if v == comp then
                    table.remove(popups.components, i)
                    table.insert(popups.components, comp)
                    private.setPressedComponentPath(nil)
                    return handled
                end
            end
        end
    end
    return handled
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Finds and executes mouse button up event for components hierarchy.
--- @param component Component
--- @param x number
--- @param y number
--- @param button number
--- @return boolean
function processMouseUp(component, x, y, button)
    private.eventCounter = private.eventCounter + 1
    local pressedPath = private.getPressedComponentPath()
    local handled
    if pressedPath then
        handled = private.runMouseEventByPath(pressedPath, "onMouseUp", x, y, button)
        private.setPressedButton(0)
        private.setPressedComponentPath(nil)
    else
        handled = private.runMouseEvent(component, "onMouseUp", x, y, button)
    end
    private.eventCounter = private.eventCounter - 1
    return handled
end

--- Called when mouse button was released.
function onMouseUp(x, y, button, layer)
    private.eventCounter = 0
    return processMouseUp(layer == MB_LAYER_POPUP and popups or panel, x, y, button)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Finds and executes mouse button hold event for components hierarchy.
--- @param component Component
--- @param x number
--- @param y number
--- @param button number
--- @return boolean
function processMouseHold(component, x, y, button)
    private.eventCounter = private.eventCounter + 1
    private.setPressedButton(button)
    local handled, path = private.runMouseEvent(component, "onMouseHold", x, y, button)
    if handled then
        private.setPressedComponentPath(path)
    end
    private.eventCounter = private.eventCounter - 1
    return handled
end

--- Called when mouse hold event was processed.
function onMouseHold(x, y, button, layer)
    private.eventCounter = 0
    return processMouseHold(layer == MB_LAYER_POPUP and popups or panel, x, y, button)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Finds and executes mouse wheel event for components hierarchy.
--- @param component Component
--- @param x number
--- @param y number
--- @param wheelClicks number
--- @return boolean
function processMouseWheel(component, x, y, wheelClicks)
    private.eventCounter = private.eventCounter + 1
    local handled = private.runMouseEvent(component, "onMouseWheel", x, y, 4, wheelClicks)
    private.eventCounter = private.eventCounter - 1
    return handled
end

--- Called when mouse wheel event was processed.
function onMouseWheel(x, y, wheelClicks, layer)
    private.eventCounter = 0
    return processMouseWheel(layer == MB_LAYER_POPUP and popups or panel, x, y, wheelClicks)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Finds and executes mouse move event for components hierarchy.
--- @param component Component
--- @param x number
--- @param y number
--- @param keepCursor boolean
function processMouseMove(component, x, y, keepCursor)
    private.eventCounter = private.eventCounter + 1
    local curKeep = keepCursor or false
    local cursor = private.getComponentCursor(component, x, y)
    if cursor ~= nil or not curKeep then
        private.setCursor(cursor)
    end

    local res, path = private.runMouseEvent(component, "onMouseMove", x, y, private.getPressedButton())
    local currentEnteredComponent = private.getEnteredComponent()
    if res == true then
        if currentEnteredComponent ~= path[1] then
            if currentEnteredComponent ~= nil then
                leaveHandler = rawget(currentEnteredComponent, "onMouseLeave")
                if leaveHandler ~= nil then
                    leaveHandler()
                end
            end
            private.setEnteredComponent(path[1])
            enterHandler = rawget(private.getEnteredComponent(), "onMouseEnter")
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
        private.setEnteredComponent(nil)
    end
    private.eventCounter = private.eventCounter - 1
end

--- Called when mouse motion event was processed.
function onMouseMove(x, y, layer)
    private.eventCounter = 1
    if layer == MB_LAYER_POPUP then
        private.setOnInterceptingWindow(true)
    end
    local resultCursor = 0
    local pressedPath = private.getPressedComponentPath()
    if not pressedPath then
        if layer == MB_LAYER_POPUP and #popups.components > 0 then
            local size = popups.size
            local position = get(popups.position)
            local mx = (x - position[1]) * size[1] / position[3]
            local my = (y - position[2]) * size[2] / position[4]
            for i = #popups.components, 1, -1 do
                local v = popups.components[i]
                if toboolean(get(v.visible)) and isInRect(get(v.position), mx, my) then
                    resultCursor = 1
                    break
                end
            end
        end
        if layer == MB_LAYER_PANEL and x < 0 and y < 0 then
            private.setCursor(nil)
            return resultCursor
        end
    else
        resultCursor = 1
    end
    if layer == MB_LAYER_POPUP and resultCursor == 0 then
        return resultCursor
    end
    private.eventCounter = 0
    processMouseMove(layer == MB_LAYER_POPUP and popups or panel, x, y)
    if private.isOSCursorHidden() then
        resultCursor = 2
    end
    return resultCursor
end

-------------------------------------------------------------------------------
-- General key events handlers for components system
-------------------------------------------------------------------------------

--- Called when button pressed.
function onKeyDown(char, key, shiftDown, ctrlDown, altOptDown)
    private.eventCounter = 0
    return processKeyDownEvent(nil, char, key, shiftDown, ctrlDown, altOptDown)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Called when button released.
function onKeyUp(char, key, shiftDown, ctrlDown, altOptDown)
    private.eventCounter = 0
    return processKeyUpEvent(nil, char, key, shiftDown, ctrlDown, altOptDown)
end

-------------------------------------------------------------------------------
-- Global project data and corresponding helpers
-------------------------------------------------------------------------------

--- List of paths to search module components.
private.searchPath = { ".", "" }

--- List of paths to search module resources (images, fonts, shaders, sounds, objects).
private.searchResourcesPath = { ".", "" }

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Adds path to search paths lists.
--- @param path string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#addSearchPath
function addSearchPath(path)
    table.insert(private.searchPath, 1, path)
    table.insert(private.searchResourcesPath, 1, path)
end

--- Adds path to search resources paths list.
--- @param path string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#addSearchResourcesPath
function addSearchResourcesPath(path)
    table.insert(private.searchResourcesPath, 1, path)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Removes path from search paths lists.
--- @overload fun()
--- @param path string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#popSearchPath
function popSearchPath(path)
    local remover = function(path, list)
        for k, v in ipairs(list) do
            if v == path then
                table.remove(list, k)
                return
            end
        end
    end
    if path then
        remover(path, private.searchPath)
        remover(path, private.searchResourcesPath)
        return
    end
    table.remove(private.searchPath, 1)
    table.remove(private.searchResourcesPath, 1)
end

--- Removes path from search resources paths list.
--- @overload fun()
--- @param path string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#popSearchResourcesPath
function popSearchResourcesPath(path)
    if path then
        for k, v in ipairs(private.searchResourcesPath) do
            if v == path then
                table.remove(private.searchResourcesPath, k)
                return
            end
        end
        return
    end
    table.remove(private.searchResourcesPath, 1)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Resizes panel main component.
function resizePanel(width, height)
    set(panel.position, { 0, 0, width, height })
    panel.size[1] = width
    panel.size[2] = height
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Resizes legacy popups main component.
function resizePopup(width, height)
    set(popups.position, { 0, 0, width, height })
    popups.size[1] = width
    popups.size[2] = height
end

-------------------------------------------------------------------------------
-- Loading module
-------------------------------------------------------------------------------

--- Loads module from main module file.
function loadModule(fileName, panelWidth, panelHeight, popupWidth, popupHeight)
    popups = private.createComponent("popups")
    popups.position = createProperty { 0, 0, popupWidth, popupHeight }
    popups.size = { popupWidth, popupHeight }

    contextWindows = private.createComponent("contextWindows")
    private.loadState()

    local c = loadComponent("module", fileName, isRoot)
    if not c then
        logError("Error loading main component", fileName)
    end
    panel = c({ position = { 0, 0, panelWidth, panelHeight } })
    popups._P = panel
    contextWindows._P = panel
    return panel
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
