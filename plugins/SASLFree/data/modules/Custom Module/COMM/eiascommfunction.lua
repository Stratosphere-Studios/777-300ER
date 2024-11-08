addSearchPath(moduleDirectory .. "/Custom Module/COMM/assets")
include("menu.lua")
local white = { 1, 1, 1, 1 }
local selectedkey = loadImage("selectedkey.png")
local opensans = loadFont("BoeingFont.ttf")
cpdlc_hoppie_id = globalProperty("Strato/777/cpdlc/hoppie_id")
cpdlc_connect = globalPropertyi("Strato/777/cpdlc/connect")
cpdlc_ready_to_send = globalPropertyi("Strato/777/cpdlc/ready_to_send")

loginto = ""
count = 0

inputData = {}
selectdata = {}

components = {}
function update()
    components = {}
end

function clickmain(count, page, sub, data, selecttype, x, y)
	if (page == 1) then --alt request
		if (count == 1) then
			local success, result = pcall(validFL, data)
			if success and result then
				inserdata(count, page, result, selecttype)
				clickselect(count, page, sub, x, y)
			end
			if not success then
				print("throw")
			end
		elseif (count == 2) then
			
		end
	elseif (page == 7) then
		if (count == 3) then --loginto
			if (string.len(data) ~= 4) then
				--display error
				return
			end
			inserdata(count, page, data, selecttype)
		end
		if (count == 4) then
			inserdata(count, page, data, selecttype)
		end
	end
end

function getpayload(page)
    print("getpayload called with page:", page)
	if (inputData == nil) then
		print("selectdata is nil")
		return
	end

	for i, v in ipairs(inputData) do
		print("Checking page:", v.page, "with data:", v.data)
    	if v.page == page and v.data ~= nil then
            print("Found matching page and data:", v.data)
            return v.data
        end
    end
	print("No matching page or data found for page:", page)
	return nil
end

function sendcpdlc(page)
	local payload = getpayload(page)
	if (payload == nil) then
		print("payload is nil")
		return
	end
	count = count + 1
	if (page == 1) then
		url = "https://www.hoppie.nl/acars/system/connect.html?logon=" .. cpdlc_hoppie_id .. "&from=" .. "AXM123" .. "&to=" .. "WMKK" .. "&type=" .. "cpdlc" .. "&packet=/data2/" .. count .. "//Y/REQUEST+@" .. payload .."@"
		local downloaded, contents = sasl.net.downloadFileContentsSync(url)
        if downloaded then
            print(contents)
        else
            print("error downloading file")
        end
	end
end

function clickselect(count, page, sub, x, y)
	if (sub == false) then
		selectdata[1] = {id = count, page = page, x = x, y = y }
	end
	selectdata[count] = {id = count, page = page, x = x, y = y }
	readytosend(page)
end

function inserdata(count, page, result, selecttype)
	table.insert(inputData, {id = count, page = page, data = result, selecttype = selecttype })
end

function clearselect(page)
	for i = #selectdata, 1, -1 do
		if selectdata[i].page == page then
			table.remove(selectdata, i)
		end
	end
end

function readytosend(page)
	local ready = false
	for i, v in ipairs(inputData) do
		if v.page == page and v.selecttype == 0 then
			ready = true
		elseif v.page == page and v.selecttype == 1 then
			for i, v in ipairs(selectdata) do
				if v.page == page then
					ready = true
				end
			end
		end
	end
	if ready then
		print("ready to send")
		set(cpdlc_ready_to_send, 1)
		set(cpdlc_connect, 1)
	else
		print("not ready to send")
		set(cpdlc_ready_to_send, 0)
	end
	return ready
end

function clearinputdata(page)
	for i, v in ipairs(inputData) do
		if v.page == page then
			table.remove(inputData, i)
		end
	end
end

function validateSpeed(value)
	local val=tonumber(value)
	if val==nil then return false end
	if val<130 or val>300 then return false end
	return true
end

function validFL(value)
	local val=tonumber(value)
	if string.len(value)>2 and string.sub(value,1,2)=="FL" then val=tonumber(string.sub(value,3)) end
	if val==nil then return nil end
	if val<1000 then val=val*100 end
	if val<10000 or val>40000 then return nil end
	return "FL".. (val/100)
end

function Tabledata(count, page)
    for i, v in ipairs(inputData) do
        if v.id == count and v.page == page then
          return v
        end
      end
      return nil
end