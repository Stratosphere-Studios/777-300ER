--[[
*****************************************************************************************
* Script Name: Flight Instruments
* Author Name: remenkemi (crazytimtimtim)
* Script Description: Various SASL features for flight instruments XTLua doesn't have.
*****************************************************************************************
--]]

printInput = createGlobalPropertys("Strato/777/print_input", "");

fmcPrint = sasl.createCommand("Strato/777/fmc_print", "Print to the printer");
sasl.registerCommandHandler(fmcPrint, 0, function(phase)
    local pathSep = package.config:sub(1,1)
    if pathSep == "\\" then
        print("Windows")
        local filePath = getXPlanePath().."print.txt"
        local file = io.open(filePath, "w")
        file:write(get(printInput))
        file:close()
        print("created file "..filePath)
        os.execute("powershell.exe -Command \"& {Get-Content \\\""..filePath .."\\\" | Out-Printer}\"")
        os.remove(filePath)
        print("finished printing")
    else
        print("Unix")
        os.execute("lpr <<< \""..get(printInput) .."\"")
        print("finished printing")
    end
end)

-- metar

metarInput = createGlobalPropertys("Strato/777/metar_input", "");
metarOutput = createGlobalPropertys("Strato/777/metar_Output", "");

getMetar = sasl.createCommand("Strato/777/get_metar", "Search online for specifed METAR");
sasl.registerCommandHandler(getMetar, 0, function(phase)
        if get(metarInput):len() == 4 and get(metarInput):find('%a%a%a%a') then
            local link = "https://tgftp.nws.noaa.gov/data/observations/metar/stations/"..get(metarInput)..".TXT"
            local downloaded, contents = sasl.net.downloadFileContentsSync(link)
            if downloaded then
                set(metarOutput, contents)
            else
                set(metarOutput, "ERROR RETRIEVING METAR DATA")
            end
        else
            set(metarOutput, "INVALID METAR")
        end
    print("Retrieved metar for "..get(metarInput)..": "..get(metarOutput))
end)