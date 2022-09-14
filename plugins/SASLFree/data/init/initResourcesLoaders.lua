-------------------------------------------------------------------------------
-- Resources loaders
-------------------------------------------------------------------------------

--- Loads texture from image.
--- @param fileName string
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @overload fun(fileName:string):number
--- @overload fun(fileName:string, width:number, height:number):number
--- @return number, number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#loadImage
function loadImage(fileName, x, y, width, height)
    local f = findResourceFile(fileName)
    if f == nil then
        logError("Can't find texture", fileName)
        return nil
    end

    local s
    if height ~= nil then s = sasl.gl.getGLTexture(f, x, y, width, height)
    elseif y ~= nil then s = sasl.gl.getGLTexture(f, x, y)
    else s = sasl.gl.getGLTexture(f) end

    if not s then
        logError("Can't load texture", fileName)
        return nil
    end
    local w, h = sasl.gl.getTextureSize(s)
    return s, w, h
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Loads SVG texture from image.
--- @param fileName string
--- @param rasterWidth number
--- @param rasterHeight number
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @overload fun(fileName:string, rasterWidth:number, rasterHeight:number):number
--- @overload fun(fileName:string, rasterWidth:number, rasterHeight:number, x:number, y:number):number
--- @return number, number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#loadVectorImage
function loadVectorImage(fileName, rasterWidth, rasterHeight, x, y, width, height)
    local f = findResourceFile(fileName)
    if f == nil then
        logError("Can't find vector texture", fileName)
        return nil
    end

    local s
    if height ~= nil then s = sasl.gl.getGLVectorTexture(f, rasterWidth, rasterHeight, x, y, width, height)
    elseif y ~= nil then s = sasl.gl.getGLVectorTexture(f, rasterWidth, rasterHeight, x, y)
    else s = sasl.gl.getGLVectorTexture(f, rasterWidth, rasterHeight) end

    if not s then
        logError("Can't load vector texture", fileName)
        return nil
    end
    local w, h = sasl.gl.getTextureSize(s)
    return s, w, h
end

sasl.gl.loadImage = loadImage
sasl.gl.loadVectorImage = loadVectorImage

sasl.gl.unloadImage = unloadTexture
unloadImage = unloadTexture
sasl.gl.loadImageFromMemory = loadTextureFromMemory
loadImageFromMemory = loadTextureFromMemory

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Loads old-style bitmap font from file.
--- @param fileName string
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#loadBitmapFont
function loadBitmapFont(fileName)
    local f = findResourceFile(fileName)
    if f == nil then
        logError("Can't find bitmap font", fileName)
        return nil
    end

    local font = sasl.gl.getGLBitmapFont(f)
    if not font then
        logError("Can't load bitmap font", fileName)
    end
    return font
end

sasl.gl.loadBitmapFont = loadBitmapFont

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Loads font from file (TTF, TTC, OTF, etc).
--- @param fileName string
--- @param texture number
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @overload fun(fileName:string):number
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#loadFont
function loadFont(fileName, texture, x, y, width, height)
    return private.loadFont(fileName, FONT_HINTER_AUTO, texture, x, y, width, height)
end
sasl.gl.loadFont = loadFont

--- Loads font from file (TTF, TTC, OTF, etc) using specific hinting preference.
--- @param fileName string
--- @param hinter FontHinterPreference
--- @param texture number
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @overload fun(fileName:string):number
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#loadFontHinted
function loadFontHinted(fileName, hinter, texture, x, y, width, height)
    return private.loadFont(fileName, hinter, texture, x, y, width, height)
end
sasl.gl.loadFontHinted = loadFontHinted

function private.loadFont(fileName, hinter, texture, x, y, width, height)
    local f = findResourceFile(fileName)
    if f == nil then
        logError("Can't find font", fileName)
        return nil
    end

    local font
    if height ~= nil then font = sasl.gl.getGLFont(f, hinter, texture, x, y, width, height)
    elseif texture ~= nil then font = sasl.gl.getGLFont(f, hinter, texture)
    else font = sasl.gl.getGLFont(f, hinter) end

    if not font then
        logError("Can't load font", fileName)
    end
    return font
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Load sound sample from file.
--- @param fileName string
--- @param needToCreateTimer boolean
--- @param needReversed boolean
--- @overload fun(fileName:string):number
--- @overload fun(fileName:string, needToCreateTimer:boolean):number
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#loadSample
function loadSample(fileName, needToCreateTimer, needReversed)
    if needToCreateTimer == nil then needToCreateTimer = false end
    if needReversed == nil then needReversed = false end

    local f = findResourceFile(fileName)
    if f == nil then
        logError("Can't find sound", fileName)
        return nil
    end

    local s = sasl.al.loadSampleFromFile(f, needToCreateTimer, needReversed)
    if s == nil then
        logError("Can't load sound", fileName)
        return nil
    end
    return s
end

sasl.al.loadSample = loadSample

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Loads XP object from file.
--- @param fileName string
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#loadObject
function loadObject(fileName)
    local f = findResourceFile(fileName)
    if f == nil then
        logError("Can't find object", fileName)
        return nil
    end

    local o = sasl.loadObjectFromFile(f)
    if o == nil then
        logError("Can't load object", fileName)
    end
    return o
end

sasl.loadObject = loadObject

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Loads XP object from file asynchronously.
--- @param fileName string
--- @param callback fun(id:number)
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#loadObjectAsync
function loadObjectAsync(fileName, callback)
    local f = findResourceFile(fileName)
    if f == nil then
        logError("Can't find object", fileName)
        return nil
    end

    local o = sasl.loadObjectAsyncFromFile(f, callback)
    if o == nil then
        logError("Can't load object", fileName)
    end
    return o
end

sasl.loadObjectAsync = loadObjectAsync

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Loads shader source from file.
--- @param shaderID number
--- @param fileName string
--- @param shType ShaderTypeID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#loadShader
function loadShader(shaderID, fileName, shType)
    local f = findResourceFile(fileName)
    if f == nil then
        logError("Can't find shader source", fileName)
        return nil
    end

    sasl.gl.addShader(shaderID, f, shType)
end

sasl.gl.loadShader = loadShader

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
