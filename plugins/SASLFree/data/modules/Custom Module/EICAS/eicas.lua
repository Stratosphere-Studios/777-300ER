--[[
*****************************************************************************************
* Script Name: eicas
* Author Name: @bruh
* Script Description: Code for upper eicas
*****************************************************************************************
--]]

addSearchPath(moduleDirectory .. "/Custom Module/")

include("misc_tools.lua")

battery = globalPropertyiae("sim/cockpit2/electrical/battery_on", 1)
gen_1 = globalPropertyiae("sim/cockpit2/electrical/generator_on", 1)
gen_2 = globalPropertyiae("sim/cockpit2/electrical/generator_on", 2)
pressure_L = globalPropertyiae("Strato/777/hydraulics/press", 1)
pressure_C = globalPropertyiae("Strato/777/hydraulics/press", 2)
pressure_R = globalPropertyiae("Strato/777/hydraulics/press", 3)
flaps = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 1)
flap_handle = globalPropertyf("sim/cockpit2/controls/flap_ratio")

windows = createGlobalPropertyfa("Strato/777/windows", {0, 0})

font = loadFont("BoeingFont.ttf")

function CheckOvht(pump_type) --Returns the second line of the overheat message
	names = {"L", "C1", "C2", "R"}
	ovht = {}
	msg = ""
	local n_ovht = 0
	for i=1,4 do
		local pump_temp = globalPropertyfae("Strato/777/hydraulics/pump/primary/temperatures", i)
		if pump_type == 2 then --1 = primary, 2 = demand
			pump_temp = globalPropertyfae("Strato/777/hydraulics/pump/demand/temperatures", i)
		end
		if get(pump_temp) >= 75 then
			table.insert(ovht, n_ovht + 1, names[i])
			n_ovht = n_ovht + 1
		end
	end
	msg = table.concat(ovht, ", ")
	if pump_type == 1 then
		msg = "PRI " .. msg
	else
		msg = "DEM " .. msg
	end
	return msg
end

function Flap_pos2Tape(pos, t_height) --calculates an offset from the top of the flap position bar
	flap_settings = {0, 1, 5, 15, 20, 25, 30}
	detents = {0, 0.17, 0.33, 0.5, 0.67, 0.83, 1}
	for i=1,7 do
		if flap_settings[i] > pos then
			local delta = round((detents[i] - detents[i - 1]) * t_height)
			return round(detents[i-1] * t_height + ((pos - flap_settings[i-1]) / (flap_settings[i] - flap_settings[i - 1])) * delta)
		elseif flap_settings[i] == pos then
			return round(detents[i] * t_height)
		end
	end
	return 0
end

function UpdateFlaps() --this is for updating flap position on eicas
	local tape_height = 300
	local color = {0, 1, 0}
	local magenta = {0.94, 0.57, 1}
	flap_settings = {0, 1, 5, 15, 20, 25, 30}
	text = {"F", "L", "A", "P", "S"}
	detents = {0, 0.17, 0.33, 0.5, 0.67, 0.83, 1}
	setting = flap_settings[indexOf(detents, get(flap_handle), 1)]
	if setting > 0 or get(flaps) > 0 then
		if round(get(flaps)) ~= setting then
			color = magenta
		else
			color = {0, 1, 0}
		end
		handle_on_screen = round(530 - tape_height * get(flap_handle)) --position of flap handle on screen
		flaps_on_screen = round(530 - Flap_pos2Tape(get(flaps), tape_height))
		DrawRect(1000, 530, 50, tape_height, 3, {1, 1, 1})
		sasl.gl.drawRectangle(1000, 530, 50,  - 530 + flaps_on_screen, {1, 1, 1})
		sasl.gl.drawWideLine(990, handle_on_screen, 1060, handle_on_screen, 6, color)
		if setting ~= 0 then
			drawText(font, 1070, handle_on_screen - 15, tostring(setting), 45, false, false, TEXT_ALIGN_LEFT, color)
		else
			drawText(font, 1070, handle_on_screen - 15, "UP", 45, false, false, TEXT_ALIGN_LEFT, color)
		end
		for i=1,5 do --Draw flaps text vertically
			drawText(font, 965, 430 - 35 * (i - 1), text[i], 40, false, false, TEXT_ALIGN_LEFT, {0.17, 0.71, 0.83})
		end
	end
end

function UpdateEicasAdvisory()
	local cur_y = 1245
	local step = 50
	--window positions
	local pos_w_l = globalPropertyfae("Strato/777/windows", 1)
	local pos_w_r = globalPropertyfae("Strato/777/windows", 2)
	--Draw cautions
	local primary_ovht = CheckOvht(1)
	if primary_ovht ~= "PRI " then
		drawText(font, 850, cur_y, "HYD OVERHEAT", 50, false, false, TEXT_ALIGN_LEFT, {1, 0.96, 0.07})
		cur_y = cur_y - step
		drawText(font, 850, cur_y, primary_ovht, 50, false, false, TEXT_ALIGN_LEFT, {1, 0.96, 0.07})
		cur_y = cur_y - step
	end
	local demand_ovht = CheckOvht(2)
	if demand_ovht ~= "DEM " then
		drawText(font, 850, cur_y, "HYD OVERHEAT", 50, false, false, TEXT_ALIGN_LEFT, {1, 0.96, 0.07})
		cur_y = cur_y - step
		drawText(font, 850, cur_y, demand_ovht, 50, false, false, TEXT_ALIGN_LEFT, {1, 0.96, 0.07})
		cur_y = cur_y - step
	end
	if get(pressure_L) < 2500 and get(pressure_C) < 2500 and get(pressure_R) < 2500 then
		drawText(font, 850, cur_y, "HYD PRESS SYS L+C+R", 50, false, false, TEXT_ALIGN_LEFT, {1, 0.96, 0.07})
		cur_y = cur_y - step
	elseif get(pressure_L) >= 2500 and get(pressure_C) < 2500 and get(pressure_R) < 2500 then
		drawText(font, 850, cur_y, "HYD PRESS SYS R+C", 50, false, false, TEXT_ALIGN_LEFT, {1, 0.96, 0.07})
		cur_y = cur_y - step
	elseif get(pressure_L) < 2500 and get(pressure_C) >= 2500 and get(pressure_R) < 2500 then
		drawText(font, 850, cur_y, "HYD PRESS SYS L+R", 50, false, false, TEXT_ALIGN_LEFT, {1, 0.96, 0.07})
		cur_y = cur_y - step
	elseif get(pressure_L) < 2500 and get(pressure_C) < 2500 and get(pressure_R) >= 2500 then
		drawText(font, 850, cur_y, "HYD PRESS SYS L+C", 50, false, false, TEXT_ALIGN_LEFT, {1, 0.96, 0.07})
		cur_y = cur_y - step
	elseif get(pressure_L) < 2500 and get(pressure_C) >= 2500 and get(pressure_R) >= 2500 then
		drawText(font, 850, cur_y, "HYD PRESS SYS L", 50, false, false, TEXT_ALIGN_LEFT, {1, 0.96, 0.07})
		cur_y = cur_y - step
	elseif get(pressure_L) >= 2500 and get(pressure_C) < 2500 and get(pressure_R) >= 2500 then
		drawText(font, 850, cur_y, "HYD PRESS SYS C", 50, false, false, TEXT_ALIGN_LEFT, {1, 0.96, 0.07})
		cur_y = cur_y - step
	elseif get(pressure_L) >= 2500 and get(pressure_C) >= 2500 and get(pressure_R) < 2500 then
		drawText(font, 850, cur_y, "HYD PRESS SYS R", 50, false, false, TEXT_ALIGN_LEFT, {1, 0.96, 0.07})
		cur_y = cur_y - step
	end
	--window advisory
	if get(pos_w_l) > 0 and get(pos_w_r) == 0 then
		drawText(font, 850, cur_y, "WINDOW FLT DECK L", 50, false, false, TEXT_ALIGN_LEFT, {1, 0.96, 0.07})
		cur_y = cur_y - step
	elseif get(pos_w_l) == 0 and get(pos_w_r) > 0 then
		drawText(font, 850, cur_y, "WINDOW FLT DECK R", 50, false, false, TEXT_ALIGN_LEFT, {1, 0.96, 0.07})
		cur_y = cur_y - step
	elseif get(pos_w_l) > 0 and get(pos_w_r) > 0 then
		drawText(font, 850, cur_y, "WINDOWS", 50, false, false, TEXT_ALIGN_LEFT, {1, 0.96, 0.07})
		cur_y = cur_y - step
	end
	--drawText(font, 850, cur_y, "RAT UNLOCKED", 50, false, false, TEXT_ALIGN_LEFT, {1, 0.96, 0.07})
end

function draw()
	flap_load_relief = globalPropertyi("Strato/777/flaps/load_relief")
	if get(battery) == 1 or IsAcConnected() == 1 then
		UpdateFlaps()
		UpdateEicasAdvisory()
		if get(flap_load_relief) == 1 then
			drawText(font, 1130, 380, "LOAD", 50, false, false, TEXT_ALIGN_LEFT, {1, 1, 1})
			drawText(font, 1130, 330, "RELIEF", 50, false, false, TEXT_ALIGN_LEFT, {1, 1, 1})
		end
	end
end
