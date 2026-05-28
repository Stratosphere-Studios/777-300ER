-------------------------------------------------------------------------------
-- Avionics
-------------------------------------------------------------------------------

local av = sasl.avionics

if not av.isAvionicsApiAvailable() then
    return
end

--- @class AvionicsDeviceID

--- @class AvionicsDeviceParams
--- @field name string
--- @field id string
--- @field size number[]
--- @field bezelSize number[]
--- @field screenOffset number[]
--- @field drawOnDemand boolean
--- @field brightnessCallback fun(brtRheo:number, ambiantBrt:number, busVoltsRatio:number):number
--- @field components Component[]
--- @field bezelComponents Component[]

--- @class AvionicsDeviceOverrideParams
--- @field name string
--- @field id number
--- @field size number[]
--- @field bezelSize number[]
--- @field replace boolean
--- @field components Component[]
--- @field bezelComponents Component[]

--- @param params AvionicsDeviceParams
local function deviceParamsProcess(params)
    local size, bezelSize, screenOffset
    if params.name == nil or
       params.id == nil or
       params.size == nil
    then
        logWarning("Mandatory Avionics Device params missing: name, id, size")
        return nil
    end
    size = params.size
    if size[1] <= 0 or size[2] <= 0 then
        logWarning("Incorrect Avionics Device screen size specified")
        return nil
    end
    bezelSize = params.bezelSize
    screenOffset = params.screenOffset
    if bezelSize == nil or screenOffset == nil then
        bezelSize = size
        screenOffset = { 0, 0 }
    end
    return size, bezelSize, screenOffset
end

local function setupAvionicsComponent(name, size, components)
    local c = private.createComponent(name)
    c.position = createProperty({ 0, 0, size[1], size[2] })
    c.size = size
    c.components = components
    c._mEv = {}
    c._mEv.hold = { false, false }
    set(c.visible, true)
    return c
end

local function avProcessDraw(component)
    private.drawComponent(component)
end

local mouseEvent = {
    clickDown = 1,
    clickDrag = 2,
    clickUp = 3
}
local mouseClickEvents = {
    processMouseDown,
    processMouseHold,
    processMouseUp
}
local function avProcessMouseClick(component, x, y, button, event)
    private.eventCounter = 0
    if event == mouseEvent.clickDrag then
        return true
    else
        local mouseHold = component._mEv.hold
        local handled = mouseClickEvents[event](component, x, y, button)
        mouseHold[button] = handled and (event == mouseEvent.clickDown)
        return handled
    end
end

local function avProcessMouseWheel(component, x, y, wheelClicks)
    private.eventCounter = 0
    return processMouseWheel(component, x, y, wheelClicks)
end

local function avProcessMouseCursor(layer, component, x, y)
    private.eventCounter = 0
    private.setOnInterceptingWindow(false)
    private.setCursorLayer(layer)

    processMouseMove(component, x, y)
    local nativeCsId = private.nativeCursorId()
    local resultCursor = (nativeCsId ~= nil) and nativeCsId or 1
    local mouseHold = component._mEv.hold
    for i = 1, #mouseHold do
        if mouseHold[i] then
            processMouseHold(component, x, y, i)
        end
    end
    return resultCursor
end

local function addDeviceInterface(device)
    device.setBrightnessRheo = function(self, brtRheo)
        av.setAvionicsBrightnessRheo(self.id, brtRheo)
    end

    device.getBrightnessRheo = function(self)
        return av.getAvionicsBrightnessRheo(self.id)
    end

    device.getBusVoltsRatio = function(self)
        return av.getAvionicsBusVoltsRatio(self.id)
    end

    device.isCursorOver = function(self)
        return av.isCursorOverAvionics(self.id)
    end

    device.needRedraw = function(self)
        av.avionicsNeedsDrawing(self.id)
    end

    device.setPopupVisible = function(self, isVisible)
        av.setAvionicsPopupVisible(self.id, isVisible)
    end

    device.isPopupVisible = function(self)
        return av.isAvionicsPopupVisible(self.id)
    end

    device.popOut = function(self)
        av.popOutAvionics(self.id)
    end

    device.isPoppedOut = function(self)
        return av.isAvionicsPoppedOut(self.id)
    end

    device.setPopupPosition = function(self, x, y, width, height)
        av.setAvionicsPopupPosition(self.id, x, y, width, height)
    end

    device.getPopupPosition = function(self)
        return av.getAvionicsPopupPosition(self.id)
    end

    device.setPopoutPosition = function(self, x, y, width, height)
        av.setAvionicsPopoutPosition(self.id, x, y, width, height)
    end

    device.getPopoutPosition = function(self)
        return av.getAvionicsPopoutPosition(self.id)
    end

    device.getBezelAmbiantColor = function(self)
        local r, g, b = av.getAvionicsBezelAmbiant(self.id)
        return r, g, b
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local avionicsDeviceLayer = 1000

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class AvionicsDevice
--- @field id number
--- @field setBrightnessRheo fun(self:AvionicsDevice, brtRheo:number)
--- @field getBrightnessRheo fun(self:AvionicsDevice):number
--- @field getBusVoltsRatio fun(self:AvionicsDevice):number
--- @field isCursorOver fun(self:AvionicsDevice):boolean, number, number
--- @field needRedraw fun(self:AvionicsDevice)
--- @field setPopupVisible fun(self:AvionicsDevice, isVisible:boolean)
--- @field isPopupVisible fun(self:AvionicsDevice):boolean
--- @field popOut fun(self:AvionicsDevice)
--- @field isPoppedOut fun(self:AvionicsDevice):boolean
--- @field setPopupPosition fun(self:AvionicsDevice, x:number, y:number, w:number, h:number)
--- @field getPopupPosition fun(self:AvionicsDevice):number, number, number, number
--- @field setPopoutPosition fun(self:AvionicsDevice, x:number, y:number, w:number, h:number)
--- @field getPopoutPosition fun(self:AvionicsDevice):number, number, number, number
--- @field getBezelAmbiantColor fun(self:AvionicsDevice):number, number, number
--- @field destroy fun(self:AvionicsDevice)

--- Creates new avionics device with attached components hierarchy
--- @param params AvionicsDeviceParams
--- @return AvionicsDevice
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#avionicsDevice
function avionicsDevice(params)
    local size, bezelSize, screenOffset = deviceParamsProcess(params)
    if size == nil then return nil end

    local screenC
    local bezelC

    local hasBezel = params.bezelComponents ~= nil
    local screenClear = params.screenClear
    local drawOnDemand = params.drawOnDemand
    if drawOnDemand == nil then drawOnDemand = false end
    screenC = setupAvionicsComponent(params.name, size, params.components)
    if hasBezel then
        bezelC = setupAvionicsComponent(params.name .. "Bezel", bezelSize, params.bezelComponents)
    end

    local device = {}

    local bezelDraw
    local bezelMouseClick
    local bezelMouseWheel
    local bezelMouseCursor

    if hasBezel then
        local bezelLayer = avionicsDeviceLayer
        avionicsDeviceLayer = avionicsDeviceLayer + 1
        bezelDraw = function()
            avProcessDraw(bezelC)
            return bezelLayer
        end

        bezelMouseClick = function(x, y, button, event)
            return avProcessMouseClick(bezelC, x, y, button, event)
        end

        bezelMouseWheel = function(x, y, wheelClicks)
            return avProcessMouseWheel(bezelC, x, y, wheelClicks)
        end

        bezelMouseCursor = function(x, y)
            return avProcessMouseCursor(bezelLayer, bezelC, x, y)
        end
    end

    local screenLayer = avionicsDeviceLayer
    avionicsDeviceLayer = avionicsDeviceLayer + 1

    local function screenDraw()
        if screenClear then
            local cs = screenC.size
            sasl.gl.clearRenderTarget(0, 0, cs[1], cs[2])
        end
        avProcessDraw(screenC)
        return screenLayer
    end

    local function screenMouseClick(x, y, button, event)
        return avProcessMouseClick(screenC, x, y, button, event)
    end

    local function screenMouseWheel(x, y, wheelClicks)
        return avProcessMouseWheel(screenC, x, y, wheelClicks)
    end

    local function screenMouseCursor(x, y)
        return avProcessMouseCursor(screenLayer, screenC, x, y)
    end

    device.id = av.createAvionicsDevice(params.name, params.id,
        size[1], size[2], bezelSize[1], bezelSize[2], screenOffset[1], screenOffset[2], drawOnDemand,
        bezelDraw, bezelMouseClick, bezelMouseWheel, bezelMouseCursor,
        screenDraw, screenMouseClick, screenMouseWheel, screenMouseCursor,
        params.brightnessCallback)

    if device.id == nil then
        return nil
    end
    addDeviceInterface(device)

    if hasBezel then
        avionicsDevices.component(bezelC)
    end
    avionicsDevices.component(screenC)

    device.destroy = function(self)
        av.destroyAvionicsDevice(self.id)
        if avionicsDevices ~= nil then
            local avComp = avionicsDevices.components
            for i = #avComp, 1, -1 do
                if avComp[i] == bezelC or avComp[i] == screenC then
                    table.remove(avComp, i)
                end
            end
        end
    end

    return device
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Checks if Avionics Device with specified numeric ID is bound to currently loaded aircraft
--- @param deviceId AvionicsDeviceID
--- @return boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#avionicsDeviceIsBound
function avionicsDeviceIsBound(deviceId)
    local id = av.getAvionicsHandle(deviceId)
    if id == nil then return false end
    return av.isAvionicsBound(id)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Finds builtin avionics device
--- @param deviceId AvionicsDeviceID
--- @return AvionicsDevice
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#avionicsDeviceBuiltin
function avionicsDeviceBuiltin(deviceId)
    local device = {}
    device.id = av.getAvionicsHandle(deviceId)
    if device.id == nil then
        return nil
    end
    addDeviceInterface(device)

    device.destroy = function(self) end

    return device
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Finds builtin avionics device and overrides/adds new behaviour using attached components hierarchy
--- @param params AvionicsDeviceOverrideParams
--- @return AvionicsDevice
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#avionicsDeviceOverride
function avionicsDeviceOverride(params)
    local size, bezelSize = deviceParamsProcess(params)
    if size == nil then return nil end

    local screenC
    local bezelC

    local hasBezel = params.bezelComponents ~= nil
    screenC = setupAvionicsComponent(params.name, size, params.components)
    if hasBezel then
        bezelC = setupAvionicsComponent(params.name .. "Bezel", bezelSize, params.bezelComponents)
    end

    local device = {}

    local bezelMouseClick
    local bezelMouseWheel
    local bezelMouseCursor

    if hasBezel then
        local bezelLayer = avionicsDeviceLayer
        avionicsDeviceLayer = avionicsDeviceLayer + 1

        bezelMouseClick = function(x, y, button, event)
            return avProcessMouseClick(bezelC, x, y, button, event)
        end

        bezelMouseWheel = function(x, y, wheelClicks)
            return avProcessMouseWheel(bezelC, x, y, wheelClicks)
        end

        bezelMouseCursor = function(x, y)
            return avProcessMouseCursor(bezelLayer, bezelC, x, y)
        end
    end

    local screenLayer = avionicsDeviceLayer
    avionicsDeviceLayer = avionicsDeviceLayer + 1

    local function screenDraw()
        avProcessDraw(screenC)
        return screenLayer
    end

    local function screenMouseClick(x, y, button, event)
        return avProcessMouseClick(screenC, x, y, button, event)
    end

    local function screenMouseWheel(x, y, wheelClicks)
        return avProcessMouseWheel(screenC, x, y, wheelClicks)
    end

    local function screenMouseCursor(x, y)
        return avProcessMouseCursor(screenLayer, screenC, x, y)
    end

    local drawBefore = params.replace and screenDraw or nil
    local drawAfter = drawBefore == nil and screenDraw or nil

    device.id = av.registerAvionicsCallbacks(params.id, drawBefore, bezelMouseClick, bezelMouseWheel, bezelMouseCursor,
            drawAfter, screenMouseClick, screenMouseWheel, screenMouseCursor)

    if device.id == nil then
        return nil
    end
    addDeviceInterface(device)

    if hasBezel then
        avionicsDevices.component(bezelC)
    end
    avionicsDevices.component(screenC)

    device.destroy = function(self)
        av.unregisterAvionicsCallbacks(self.id)
        if avionicsDevices ~= nil then
           local avComp = avionicsDevices.components
           for i = #avComp, 1, -1 do
               if avComp[i] == bezelC or avComp[i] == screenC then
                   table.remove(avComp, i)
               end
           end
        end
    end

    return device
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
