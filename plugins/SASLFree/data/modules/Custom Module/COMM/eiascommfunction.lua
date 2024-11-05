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

function clickmain(count, data, selecttype, x, y)
    table.insert(inputData, count, {id = count, data = "asdasdasd", selecttype = selecttype })
end

function Tabledata(count)
    for i, v in ipairs(inputData) do
        if v.id == count then
          return v
        end
      end
      return nil
end