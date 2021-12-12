---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- UPDATE AND DRAW PROCESSORS -------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Draw all modules panel components
function drawPanelStage()
    drawComponent(panel)
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Draw all modules popups components
function drawPopupsStage()
    drawComponent(popups)
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Draw all 3D stuff
function draw3DStage()
    drawComponent3D(panel)
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Draw all objects
function drawObjectsStage()
    drawObjects(panel)
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Update all modules components
function update()
    updateComponent(panel)
    updateComponent(popups)
    updateComponent(contextWindows)
end

-- Update component
function updateComponent(v)
    if v and v.update then
        v:update()
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Update all components from table
function updateAll(table)
    for _, v in ipairs(table) do
        updateComponent(v)
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Draw to components render target
function renderToTarget(v)
    setRenderTarget(v.renderTarget, true)
    v:draw()
    restoreRenderTarget()
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Simulator framerate
local simFRP = globalPropertyf("sim/operation/misc/frame_rate_period")

-- Draw component
function drawComponent(v)
    if v and toboolean(get(v.visible)) then
        sasl.gl.saveGraphicsContext()
        local renderTargetExist = toboolean(get(v.fbo))
        if renderTargetExist then
            local omitRendering = toboolean(get(v.noRenderSignal))
            if not omitRendering then
                local currentFPS = 1.0 / get(simFRP)
                local limit = get(v.fpsLimit)
                if limit == -1 or limit >= currentFPS then
                    renderToTarget(v)
                    v.frames = 0
                else
                    if v.frames > currentFPS / limit then
                        renderToTarget(v)
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
            local cs = get(v.clipSize) and get(v.clipSize) or {pos[1], pos[2], pos[3], pos[4]}
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

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Draw component 3D stuff
function drawComponent3D(v)
    v:draw3D()
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Draw component 3D stuff
function drawObjects(v)
    v:drawObjects()
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Draw all components from table
function drawAll(table)
    for _, v in ipairs(table) do
        drawComponent(v)
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Draw all 3D stuff from components
function drawAll3D(table)
    for _, v in ipairs(table) do
        drawComponent3D(v)
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Draw all 3D stuff from components
function drawAllObjects(table)
    for _, v in ipairs(table) do
        drawObjects(v)
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
