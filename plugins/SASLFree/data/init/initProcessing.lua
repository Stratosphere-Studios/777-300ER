-------------------------------------------------------------------------------
-- Draw
-------------------------------------------------------------------------------

--- Draws (2D) all components.
--- @param components Component[]
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawAll
function drawAll(components)
    for _, v in ipairs(components) do
        private.drawComponent(v)
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Draws 3D from components.
--- @param components Component[]
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawAll3D
function drawAll3D(components)
    for _, v in ipairs(components) do
        v:draw3D()
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Draws objects from components.
--- @param components Component[]
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawAllObjects
function drawAllObjects(components)
    for _, v in ipairs(components) do
        v:drawObjects()
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Simulator framerate dataref
local simFRP = globalPropertyf("sim/operation/misc/frame_rate_period")

--- Draws component to its 2D render target.
--- @param v Component
function private.drawComponentToTarget(v)
    setRenderTarget(v.renderTarget, true)
    v:draw()
    restoreRenderTarget()
end

--- Draws component in 2D.
--- @param v Component
function private.drawComponent(v)
    if v and toboolean(get(v.visible)) then
        sasl.gl.saveGraphicsContext()
        local renderTargetExist = toboolean(get(v.fbo))
        if renderTargetExist then
            local omitRendering = toboolean(get(v.noRenderSignal))
            if not omitRendering then
                local currentFPS = 1.0 / get(simFRP)
                local limit = get(v.fpsLimit)
                if limit == -1 or limit >= currentFPS then
                    private.drawComponentToTarget(v)
                    v.frames = 0
                else
                    if v.frames > currentFPS / limit then
                        private.drawComponentToTarget(v)
                        v.frames = 0
                    else
                        v.frames = v.frames + 1
                    end
                end
            end
            local pos = get(v.position)
            sasl.gl.setComponentTransform(pos[1], pos[2], pos[3], pos[4], v.size[1], v.size[2])
            sasl.gl.drawTexture(v.renderTarget, 0, 0, v.size[1], v.size[2], 1, 1, 1, 1)
            set(v.noRenderSignal, false)
        else
            local pos = get(v.position)
            sasl.gl.setComponentTransform(pos[1], pos[2], pos[3], pos[4], v.size[1], v.size[2])
            local clip = toboolean(get(v.clip))
            local cs = get(v.clipSize) and get(v.clipSize) or { pos[1], pos[2], pos[3], pos[4] }
            local clipSize = cs[3] > 0 and cs[4] > 0
            if clip then
                if clipSize then
                    sasl.gl.setClipArea(cs[1], cs[2], cs[3], cs[4])
                else
                    sasl.gl.setClipArea(0, 0, v.size[1], v.size[2])
                end
            end
            v:draw()
            if clip then
                sasl.gl.resetClipArea()
            end
        end
        sasl.gl.restoreGraphicsContext()
    end
end

-------------------------------------------------------------------------------
-- Update
-------------------------------------------------------------------------------

--- Updates all components.
--- @param components Component[]
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#updateAll
function updateAll(components)
    for _, v in ipairs(components) do
        v:update()
    end
end

-------------------------------------------------------------------------------
-- Utilities
-------------------------------------------------------------------------------

--- Calls callback function for component recursively.
--- @param name string
--- @param component Component
--- @param isForward boolean
--- @param arg any
function private.callCallback(name, component, isForward, arg)
    local handler = rawget(component, name)
    if handler then
        handler(arg)
    end
    local first, last, step
    if isForward then
        first = 1
        last = #component.components
        step = 1
    else
        first = #component.components
        last = 1
        step = -1
    end
    for i = first, last, step do
        private.callCallback(name, component.components[i], isForward, arg)
    end
end

--- Calls callback for all components layers.
--- @param name string
--- @param isForward boolean
--- @param arg any
function private.callCallbackForAllLayers(name, isForward, arg)
    private.callCallback(name, popups, isForward, arg)
    private.callCallback(name, panel, isForward, arg)
    private.callCallback(name, contextWindows, isForward, arg)
end

-------------------------------------------------------------------------------
-- Other
-------------------------------------------------------------------------------

--- Draws 3D panel components.
function drawPanelStage()
    private.drawComponent(panel)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Draws old-style popups components.
function drawPopupsStage()
    private.drawComponent(popups)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Draws 3D.
function draw3DStage()
    panel:draw3D()
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Draws objects.
function drawObjectsStage()
    panel:drawObjects()
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Updates components.
function update()
    panel:update()
    popups:update()
    contextWindows:update()
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Called whenever the user's plane is positioned at a new airport (or new flight start).
--- @param flightIndex number
function onAirportLoaded(flightIndex)
    private.callCallbackForAllLayers("onAirportLoaded", true, flightIndex)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Called whenever new scenery is loaded.
function onSceneryLoaded()
    private.callCallbackForAllLayers("onSceneryLoaded", true)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Called whenever the user adjusts the number of X-Plane aircraft models.
function onAirplaneCountChanged()
    private.callCallbackForAllLayers("onAirplaneCountChanged", true)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Called when user aircraft is loaded.
function onPlaneLoaded()
    private.callCallbackForAllLayers("onPlaneLoaded", true)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Called when user aircraft is unloaded.
function onPlaneUnloaded()
    private.callCallbackForAllLayers("onPlaneUnloaded", false)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Called whenever user plane is crashed.
function onPlaneCrash()
    local planeCrashHandler = rawget(panel, 'onPlaneCrash')
    needReload = 1
    if planeCrashHandler then
        needReload = planeCrashHandler()
    end
    if needReload == 0 then
        for i = #panel.components, 1, -1 do
            private.callCallback('onPlaneCrash', panel.components[i], false)
        end
        private.callCallback('onPlaneCrash', popups, false)
        private.callCallback('onPlaneCrash', contextWindows, false)
    end
    return needReload
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Called on module shutdown.
function shutdownModules()
    private.callCallbackForAllLayers("onModuleShutdown", false)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Called right before first 'update' call.
function initModules()
    private.callCallbackForAllLayers("onModuleInit", true)
end

--- Called when module is unloading.
function doneModules()
    private.callCallbackForAllLayers("onModuleDone", false)
    private.saveState()
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------