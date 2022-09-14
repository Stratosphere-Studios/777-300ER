-------------------------------------------------------------------------------
-- Mouse focused zone
-------------------------------------------------------------------------------

defineProperty("mouseHovered", false)

components = {
    interactive {
        onMouseMove = function()
            return true
        end,
        onMouseEnter = function()
            set(mouseHovered, true)
            return true
        end,
        onMouseLeave = function()
            set(mouseHovered, false)
            return true
        end
    }
}

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
