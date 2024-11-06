addSearchPath(moduleDirectory .. "/Custom Module/COMM/assets")
include("menu.lua")
local white = { 1, 1, 1, 1 }
local selectedkey = loadImage("selectedkey.png")
local opensans = loadFont("BoeingFont.ttf")

inputData = {}

components = {}
function update()
    components = {}
end

function clickmain(count, page, data, selecttype)
    table.insert(inputData, {id = count, page = page, data = data, selecttype = selecttype })
end

function Tabledata(count, page)
    for i, v in ipairs(inputData) do
        if v.id == count and v.page == page then
          return v
        end
      end
      return nil
end