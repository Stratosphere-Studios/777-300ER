-------------------------------------------------------------------------------
-- Popup close button
-------------------------------------------------------------------------------

defineProperty("panel")
defineProperty("closeButtonFocused", false)

function draw()
    drawAll(components)

    local isFocused = get(closeButtonFocused)
    local signColor = { 0.5, 0.5, 0.5, 1.0 }
    if isFocused then
        signColor = { 0.5, 0.9, 0.5, 1.0 }
    end

    sasl.gl.drawLine(2, 2, size[1] - 2, size[2] - 2, signColor)
    sasl.gl.drawLine(2, size[2] - 2, size[1] - 2, 2, signColor)
end

components = {
    rectangle {
        color = { 0.2, 0.2, 0.2, 1.0 }
    },
    mouseFocusedZone {
        mouseHovered = closeButtonFocused,
        onMouseDown = function()
            set(get(panel).visible, false)
            return true
        end
    }
}

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------