-------------------------------------------------------------------------------
-- Popup resize button
-------------------------------------------------------------------------------

defineProperty("resizeButtonFocused", false)

function draw()
    drawAll(components)

    local isFocused = get(resizeButtonFocused)
    local signColor = { 0.5, 0.5, 0.5, 1.0 }
    if isFocused then
        signColor = { 0.0, 0.9, 0.5, 1.0 }
    end

    sasl.gl.drawTriangle(0, 0, size[1], size[2], size[1], 0, signColor)
end

components = {
    mouseFocusedZone {
        mouseHovered = resizeButtonFocused
    }
}

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
