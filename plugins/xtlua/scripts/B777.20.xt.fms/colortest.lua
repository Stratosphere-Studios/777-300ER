testcases = {
    "something idk;r2",
    "hello, how are you doing;g5 i'm doing fine",
    "this;m3 is a test",
    "this method is;h2 stupid",
    "what;h9 if i do too many",
    "but how about a fake;k6 color?",
    "how about all white"
}

function cduColors(input)
    local colors = {
    g = "green",
    h = "highlight",
    r = "grey",
    m = "magenta",
    c = "cyan"
    }

    local code = string.match(input, ';..')

    if code ~= nil then
        local codePos = string.find(input, code)
        print(codePos)
        local color = string.lower(string.sub(code, 2, 2))
        if colors[color] ~= nil then
            local numChars = string.sub(code, 3, 3)
            local result = string.sub(input, codePos - numChars, codePos - 1)
            local colorOutput = string.rep(" ", codePos - 1 - numChars)..result..string.rep(" ", string.len(input) - codePos + 1)
            local whiteOutput = string.gsub(input, result..code, string.rep(" ", string.len(result)))
            return "I will write '"..colorOutput.."' in "..colors[color].." and '"..whiteOutput.."' in white."
        else
            return "WARNING: invalid color"
        end
    else
        return "I will write '"..input.."' in white."
    end
end

for i = 1, #testcases do
    print(cduColors(testcases[i]))
end

--

-- function to display the keypad and get user input
    function getInput()
        -- keypad display
        local keypad = [[
        1 2 3
        4 5 6
        7 8 9
        * 0 #
        ]]
        print(keypad)
        -- get user input
        local input = io.read()
        return input
    end
    
    -- main program
    print("Select a number field:")
    local field = io.read()
    local input = getInput()
    print("You selected field " .. field .. " and entered " .. input)

    

    -- create a table to store the commands for each key
local commands = {
    ["1"] = function() print("You pressed 1") end,
    ["2"] = function() print("You pressed 2") end,
    ["3"] = function() print("You pressed 3") end,
    ["4"] = function() print("You pressed 4") end,
    ["5"] = function() print("You pressed 5") end,
    ["6"] = function() print("You pressed 6") end,
    ["7"] = function() print("You pressed 7") end,
    ["8"] = function() print("You pressed 8") end,
    ["9"] = function() print("You pressed 9") end,
    ["*"] = function() print("You pressed *") end,
    ["0"] = function() print("You pressed 0") end,
    ["#"] = function() print("You pressed #") end,
}

-- function to display the keypad and get user input
function getInput()
    -- keypad display
    local keypad = [[
    1 2 3
    4 5 6
    7 8 9
    * 0 #
    ]]
    print(keypad)

    -- get user input
    local input = io.read()
    -- call the command associated with the pressed key
    commands[input]()
    return input
end

-- main program
print("Select a number field:")
local field = io.read()
local input = getInput()
print("You selected field " .. field .. " and entered " .. input)

--

local input = ""
local keypad = {
    ["1"] = function() input = input .. "1" end,
    ["2"] = function() input = input .. "2" end,
    ["3"] = function() input = input .. "3" end,
    ["4"] = function() input = input .. "4" end,
    ["5"] = function() input = input .. "5" end,
    ["6"] = function() input = input .. "6" end,
    ["7"] = function() input = input .. "7" end,
    ["8"] = function() input = input .. "8" end,
    ["9"] = function() input = input .. "9" end,
    ["*"] = function() input = input .. "*" end,
    ["0"] = function() input = input .. "0" end,
    ["#"] = function() input = input .. "#" end,
}

-- function that your api calls when key is pressed
function onKeyPress(key)
    if keypad[key] then
        keypad[key]()
    end
end

-- This can be called in a draw function to output the current input
function draw()
    print("The input is: " .. input)
end


local input = ""

-- function to handle key presses
function onKeyPress(key)
    if tonumber(key) ~= nil then -- check if the pressed key is a number
        input = input .. key
    elseif key == "backspace" then
        input = input:sub(1, #input - 1)
    end
end

-- function to display the input
function draw()
    print("The input is: " .. input)
end

--

local input = ""
local keypadOpen = false

function onKeyPress(key)
    if key == "kp_open" then -- key binding to open the keypad
        keypadOpen = true
    elseif key == "kp_close" then -- key binding to close the keypad
        keypadOpen = false
    elseif keypadOpen then
        if tonumber(key) ~= nil then -- check if the pressed key is a number
            input = input .. key
        elseif key == "backspace" then
            input = input:sub(1, -2)
        end
    end
end

-- function to display the input and the status of the keypad
function draw()
    if keypadOpen then
        print("Keypad is open. The input is: " .. input)
    else
        print("Keypad is closed.")
    end
end


--

local input = ""
local scratchpad = ""
local keypadOpen = false
local currentField

function onKeyPress(key)
    if keypadOpen then
        if tonumber(key) ~= nil then -- check if the pressed key is a number
            scratchpad = scratchpad .. key
        elseif key == "backspace" then
            scratchpad = scratchpad:sub(1, -2)
        elseif key == "enter" then -- key binding for the enter key
            input = scratchpad
            scratchpad = ""
        elseif key == "kp_close" then -- key binding to close the keypad
            keypadOpen = false
        end
    end
end

function onFieldClick(field)
    currentField = field
    keypadOpen = true
    input = ""
    scratchpad = ""
end

function draw()
    if keypadOpen then
        -- Draw keypad
        print("The input is: " .. scratchpad)
    else
        -- Draw fields
        for _, field in ipairs(fields) do
            -- Draw field
            print("Field "..field.name .. " : " .. input)
            -- event listener
            if field:isClicked() then
                onFieldClick(field)
            end
        end
    end
end

function openKeypad(field)
    currentField = field
    keypadOpen = true
    input = ""
    scratchpad = field:getValue()
  end

  local fields = {
    {name = "field1", x = 10, y = 20, width = 50, height = 50, onClick = function() openKeypad("field1") end},
    {name = "field2", x = 80, y = 20, width = 50, height = 50, onClick = function() openKeypad("field2") end}
  }
  