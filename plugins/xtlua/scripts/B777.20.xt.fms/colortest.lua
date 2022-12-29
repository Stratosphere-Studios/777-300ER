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