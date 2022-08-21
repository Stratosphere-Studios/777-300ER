--[[
*****************************************************************************************
* Script Name: eicas
* Author Name: @bruh
* Script Description: Code for upper eicas
*****************************************************************************************
--]]

addSearchPath(moduleDirectory .. "/Custom Module/")

include("misc_tools.lua")

--Finding sim datarefs

battery = globalPropertyiae("sim/cockpit2/electrical/battery_on", 1)
gen_1 = globalPropertyiae("sim/cockpit2/electrical/generator_on", 1)
gen_2 = globalPropertyiae("sim/cockpit2/electrical/generator_on", 2)
pressure_L = globalPropertyiae("Strato/777/hydraulics/press", 1)
pressure_C = globalPropertyiae("Strato/777/hydraulics/press", 2)
pressure_R = globalPropertyiae("Strato/777/hydraulics/press", 3)
flaps = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 1)
flap_handle = globalPropertyf("sim/cockpit2/controls/flap_ratio")

--Finding own datarefs

c_time = globalPropertyf("Strato/777/time/current")
eicas_brake_temp = globalPropertyi("Strato/777/eicas/brake_temp")
eicas_tire_press = globalPropertyi("Strato/777/eicas/tire_press")

--Creating datarefs

recall = createGlobalPropertyi("Strato/777/eicas/rcl", 0)
recall_past = createGlobalPropertyi("Strato/777/eicas/rcl_past", 0)
canc = createGlobalPropertyi("Strato/777/eicas/canc", 0)
windows = createGlobalPropertyfa("Strato/777/windows", {0, 0})
window_target = createGlobalPropertyia("Strato/777/windows_tgt", {0, 0})

font = loadFont("BoeingFont.ttf")

tmp = 0
tmp1 = 0

flaps_past = 0
flap_retract_time = -11
advisories_past = {}

function UpdateWindows()
	for i=1,2 do
		local act = globalPropertyfae("Strato/777/windows", i)
		local tgt = globalPropertyfae("Strato/777/windows_tgt", i)
		if get(act) ~= get(tgt) then
			if math.abs(get(act) - get(tgt)) < 0.05 then
				set(act, get(tgt))
			else
				set(act, get(act) + (get(tgt) - get(act)) * 0.02)
			end
		end
	end
end

function UpdateCanc() --Updating cancell/recall
	if get(recall) ~= get(recall_past) then
		if get(recall) == 0 and get(c_time) >= tmp + 1 then
			if get(canc) == 1 then
				set(canc, 0)
			else
				set(canc, 1)
			end
			set(recall_past, get(recall))
		elseif get(recall) == 1 then
			set(recall_past, get(recall))
		end
	end
	if get(c_time) >= tmp + 1 then
		tmp = get(c_time)
	end
end

function UpdatePress(messages) --Update pressure advisories
	if get(pressure_L) < 1200 and get(pressure_C) < 1200 and get(pressure_R) < 1200 then
		table.insert(messages, tlen(messages) + 1, "HYD PRESS SYS L+C+R")
		table.insert(messages, tlen(messages) + 1, "FLIGHT CONTROLS")
	elseif get(pressure_L) >= 1200 and get(pressure_C) < 1200 and get(pressure_R) < 1200 then
		table.insert(messages, tlen(messages) + 1, "HYD PRESS SYS R+C")
		table.insert(messages, tlen(messages) + 1, "FLIGHT CONTROLS")
	elseif get(pressure_L) < 1200 and get(pressure_C) >= 1200 and get(pressure_R) < 1200 then
		table.insert(messages, tlen(messages) + 1, "HYD PRESS SYS L+R")
		table.insert(messages, tlen(messages) + 1, "FLIGHT CONTROLS")
	elseif get(pressure_L) < 1200 and get(pressure_C) < 1200 and get(pressure_R) >= 1200 then
		table.insert(messages, tlen(messages) + 1, "HYD PRESS SYS L+C")
		table.insert(messages, tlen(messages) + 1, "FLIGHT CONTROLS")
	elseif get(pressure_L) < 1200 and get(pressure_C) >= 1200 and get(pressure_R) >= 1200 then
		table.insert(messages, tlen(messages) + 1, "HYD PRESS SYS L")
	elseif get(pressure_L) >= 1200 and get(pressure_C) < 1200 and get(pressure_R) >= 1200 then
		table.insert(messages, tlen(messages) + 1, "HYD PRESS SYS C")
	elseif get(pressure_L) >= 1200 and get(pressure_C) >= 1200 and get(pressure_R) < 1200 then
		table.insert(messages, tlen(messages) + 1, "HYD PRESS SYS R")
	end
end

function CheckOvht(pump_type, messages) --Returns the second line of the overheat message
	names = {"L", "C1", "C2", "R"}
	ovht = {}
	for i=1,4 do
		local pump_temp = globalPropertyfae("Strato/777/hydraulics/pump/primary/temperatures", i)
		if pump_type == 2 then --1 = primary, 2 = demand
			pump_temp = globalPropertyfae("Strato/777/hydraulics/pump/demand/temperatures", i)
		end
		if get(pump_temp) >= 75 then
			msg = "HYD OVERHEAT PRI " .. names[i]
			table.insert(messages, tlen(messages) + 1, msg)
		end
	end
end

function CheckFail(pump_type, messages)
	names = {"L", "C1", "C2", "R"}
	for i=1,4 do
		local pump_fail = globalPropertyfae("Strato/777/hydraulics/pump/primary/fail", i)
		local pump_state = globalPropertyiae("Strato/777/hydraulics/pump/primary/state", i)
		if pump_type == 2 then --1 = primary, 2 = demand
			pump_fail = globalPropertyfae("Strato/777/hydraulics/pump/demand/fail", i)
			pump_state = globalPropertyiae("Strato/777/hydraulics/pump/demand/state", i)
		end
		if get(pump_fail) == 1 and get(pump_state) > 0 then
			msg = "HYD PRESS PRI " .. names[i]
			table.insert(messages, tlen(messages) + 1, msg)
		end
	end
end

function UpdateWindowAdvisory(messages)
	local pos_w_l = globalPropertyfae("Strato/777/windows", 1)
	local pos_w_r = globalPropertyfae("Strato/777/windows", 2)
	if get(pos_w_l) > 0 and get(pos_w_r) == 0 then
		table.insert(messages, tlen(messages) + 1, "WINDOW FLT DECK L")
	elseif get(pos_w_l) == 0 and get(pos_w_r) > 0 then
		table.insert(messages, tlen(messages) + 1, "WINDOW FLT DECK R")
	elseif get(pos_w_l) > 0 and get(pos_w_r) > 0 then
		table.insert(messages, tlen(messages) + 1, "WINDOWS")
	end
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
	if get(flaps) ~= flaps_past then
		if get(flaps) == 0 then
			flap_retract_time = get(c_time)
		end
		flaps_past = get(flaps)
	end
	if setting > 0 or get(flaps) > 0 or get(c_time) < flap_retract_time + 10 then
		if math.abs(get(flaps) - setting) > 0.0002 then
			color = magenta
		else
			color = {0, 1, 0}
		end
		handle_on_screen = round(530 - tape_height * get(flap_handle)) --position of flap handle on screen
		flaps_on_screen = round(530 - Flap_pos2Tape(get(flaps), tape_height))
		DrawRect(1000, 530, 50, tape_height, 3, {1, 1, 1}, false)
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

function UpdateEicasAdvisory(messages)
	local cur_y = 1245
	local step = 50
	--window positions
	local acc = globalPropertyi("Strato/777/gear/brake_acc_in_use")
	--Draw cautions
	UpdatePress(messages)
	if get(acc) == 1 then
		table.insert(messages, tlen(messages) + 1, "BRAKE SOURCE")
	end
	if get(eicas_tire_press) == 1 then
		table.insert(messages, tlen(messages) + 1, "TIRE PRESS")
	end
	if get(eicas_brake_temp) == 1 then
		table.insert(messages, tlen(messages) + 1, "BRAKE TEMP")
	end
	CheckOvht(1, messages)
	CheckOvht(2, messages)
	CheckFail(1, messages)
	CheckFail(2, messages)
	--window advisory
	UpdateWindowAdvisory(messages)
end

function DisplayMessages(messages)
	local n_advisories = tlen(messages)
	if n_advisories > 0 then
		for i=1,n_advisories do
			drawText(font, 850, 1245 - 50 * (i - 1), messages[i], 50, false, false, TEXT_ALIGN_LEFT, {1, 0.96, 0.07})
		end
	end
end

function draw()
	flap_load_relief = globalPropertyi("Strato/777/flaps/load_relief")
	UpdateWindows()
	if get(battery) == 1 or IsAcConnected() == 1 then
		UpdateCanc()
		UpdateFlaps()
		if get(canc) == 0 or get(recall_past) == 1 then
			local advisories = {}
			if get(c_time) >= tmp1 + 2 then
				UpdateEicasAdvisory(advisories)
				advisories_past = advisories
			end
			DisplayMessages(advisories_past)
		end
		if get(recall_past) == 1 and get(canc) == 1 then
			drawText(font, 850, 680, "RECALL", 30, false, false, TEXT_ALIGN_LEFT, {1, 1, 1})
		end
		if get(flap_load_relief) == 1 then
			drawText(font, 1130, 380, "LOAD", 50, false, false, TEXT_ALIGN_LEFT, {1, 1, 1})
			drawText(font, 1130, 330, "RELIEF", 50, false, false, TEXT_ALIGN_LEFT, {1, 1, 1})
		end
	end
	if get(c_time) >= tmp1 + 2 then
		tmp1 = get(c_time)
	end
end
