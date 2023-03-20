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

--Cockpit controls
park_brake_valve = globalPropertyi("Strato/777/gear/park_brake_valve")
throttle_pos = globalPropertyf("sim/cockpit2/engine/actuators/throttle_jet_rev_ratio_all")
spoiler_handle = globalPropertyf("sim/cockpit2/controls/speedbrake_ratio")
stab_trim = globalPropertyf("sim/cockpit2/controls/elevator_trim")
--Electrical
battery = globalPropertyiae("sim/cockpit2/electrical/battery_on", 1)
gen_1 = globalPropertyiae("sim/cockpit2/electrical/generator_on", 1)
gen_2 = globalPropertyiae("sim/cockpit2/electrical/generator_on", 2)
--Indicators
ra_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")
ra_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_copilot")
cas_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
cas_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_copilot")
--Hydraulics
pressure_L = globalPropertyiae("Strato/777/hydraulics/press", 1)
pressure_C = globalPropertyiae("Strato/777/hydraulics/press", 2)
pressure_R = globalPropertyiae("Strato/777/hydraulics/press", 3)
--Flight controls
flaps = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 1)
flap_handle = globalPropertyf("sim/cockpit2/controls/flap_ratio")
--Gear positions
nw_actual = globalPropertyfae("sim/aircraft/parts/acf_gear_deploy", 1)
mlg_actual_R = globalPropertyfae("sim/aircraft/parts/acf_gear_deploy", 2)
mlg_actual_L = globalPropertyfae("sim/aircraft/parts/acf_gear_deploy", 3)
--Operation
on_ground = globalPropertyi("sim/flightmodel/failures/onground_any")

--Finding own datarefs

efis_ctrl = globalProperty("Strato/777/cdu_efis_ctl")
dsp_ctrl = globalProperty("Strato/777/cdu_eicas_ctl")
eicas_power_upper = globalPropertyi("Strato/777/elec/eicas_power_upper")
park_brake_valve = globalPropertyi("Strato/777/gear/park_brake_valve")
fbw_mode = globalPropertyi("Strato/777/fctl/pfc/mode")
tac_fail = globalPropertyi("Strato/777/fctl/ace/tac_fail")
fbw_self_test = globalPropertyi("Strato/777/fctl/pfc/selftest")
max_allowable = globalPropertyi("Strato/777/fctl/vmax")
stall_speed = globalPropertyi("Strato/777/fctl/vstall")
manuever_speed = globalPropertyi("Strato/777/fctl/vmanuever")
flap_load_relief = globalPropertyi("Strato/777/flaps/load_relief")
c_time = globalPropertyf("Strato/777/time/current")
eicas_brake_temp = globalPropertyi("Strato/777/eicas/brake_temp")
eicas_tire_press = globalPropertyi("Strato/777/eicas/tire_press")
altn_gear = globalPropertyi("Strato/777/gear/altn_extnsn")
main_s_locked = globalPropertyi("Strato/777/gear/main_s_locked")
handle_pos = globalPropertyf("Strato/777/gear/norm_extnsn")
acc = globalPropertyi("Strato/777/gear/brake_acc_in_use")
sys_C_press = globalPropertyfae("Strato/777/hydraulics/press", 2)
sys_R_press = globalPropertyfae("Strato/777/hydraulics/press", 3)
stab_cutout_C = globalPropertyi("Strato/777/fctl/stab_cutout_C")
stab_cutout_R = globalPropertyi("Strato/777/fctl/stab_cutout_R")
--Flight controls
ace_spoiler_fail_17 = globalPropertyi("Strato/777/fctl/ace/ace_spoiler_fail_17", 0)
ace_spoiler_fail_2 = globalPropertyi("Strato/777/fctl/ace/ace_spoiler_fail_2", 0)
ace_spoiler_fail_36 = globalPropertyi("Strato/777/fctl/ace/ace_spoiler_fail_36", 0)
ace_spoiler_fail_4 = globalPropertyi("Strato/777/fctl/ace/ace_spoiler_fail_4", 0)
ace_spoiler_fail_5 = globalPropertyi("Strato/777/fctl/ace/ace_spoiler_fail_5", 0)
ace_elevator_fail_L = globalPropertyi("Strato/777/fctl/ace/elevator_fail_L", 0)
ace_elevator_fail_R = globalPropertyi("Strato/777/fctl/ace/elevator_fail_R", 0)
spoiler_fail = {ace_spoiler_fail_17, ace_spoiler_fail_2, ace_spoiler_fail_36, ace_spoiler_fail_4, ace_spoiler_fail_5}

--Creating datarefs

recall = createGlobalPropertyi("Strato/777/eicas/rcl", 0)
recall_past = createGlobalPropertyi("Strato/777/eicas/rcl_past", 0)
canc = createGlobalPropertyi("Strato/777/eicas/canc", 0)
windows = createGlobalPropertyfa("Strato/777/windows", {0, 0})
window_target = createGlobalPropertyia("Strato/777/windows_tgt", {0, 0})

font = loadFont("BoeingFont.ttf")

tmp = 0
tmp1 = 0

flap_settings = {0, 1, 5, 15, 20, 25, 30}
detents = {0, 0.17, 0.33, 0.5, 0.67, 0.83, 1}

THS_greenband_min_val = 2.5
THS_greenband_max_val = 9
stab_c_past = 0
stab_time_no_pwr = 0
flaps_past = 0
park_brake_past = 0
handle_past = 1
altn_gear_past = 0
n_conf_warns_past = 0
conf_warns_past = {}
advisories_past = {}
n_dsp = 0
conf_time = 0
advisories_start = 1
flap_retract_time = -11
park_brake_time = -1
park_brake_time_set = false
gear_display_time = -11
gear_transit_time = -26
gear_dn = true

function UpdateAdvisorySide(messages, text_L, text_R, text_both, dref_l, dref_r)
	if round(get(dref_l)) == 1 and round(get(dref_r)) == 0 then
		table.insert(messages, tlen(messages) + 1, text_L)
	elseif round(get(dref_l)) == 0 and round(get(dref_r)) == 1 then
		table.insert(messages, tlen(messages) + 1, text_R)
	elseif round(get(dref_l)) == 1 and round(get(dref_r)) == 1 then
		table.insert(messages, tlen(messages) + 1, text_both)
	end
end

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

function UpdateCanc(n_adv, n_warn) --Updating cancel/recall
	if get(recall) ~= get(recall_past) then
		if get(recall) == 0 and get(c_time) >= tmp + 1 then
			if get(canc) == 1 then
				set(canc, 0)
			else
				local adv_disp = 11 - n_warn
				if n_adv + n_warn > 11 and n_adv - advisories_start >= adv_disp then
					advisories_start = advisories_start + adv_disp
				else
					set(canc, 1)
					advisories_start = 1
				end
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
	eicas_nest = 0
	if get(pressure_L) < 1200 and get(pressure_C) < 1200 and get(pressure_R) < 1200 then
		table.insert(messages, tlen(messages) + 1, "HYD PRESS SYS L+C+R")
		table.insert(messages, tlen(messages) + 1, "FLIGHT CONTROLS")
		eicas_nest = 1
	elseif get(pressure_L) >= 1200 and get(pressure_C) < 1200 and get(pressure_R) < 1200 then
		table.insert(messages, tlen(messages) + 1, "HYD PRESS SYS R+C")
		table.insert(messages, tlen(messages) + 1, "FLIGHT CONTROLS")
		eicas_nest = 1
	elseif get(pressure_L) < 1200 and get(pressure_C) >= 1200 and get(pressure_R) < 1200 then
		table.insert(messages, tlen(messages) + 1, "HYD PRESS SYS L+R")
		table.insert(messages, tlen(messages) + 1, "FLIGHT CONTROLS")
		eicas_nest = 1
	elseif get(pressure_L) < 1200 and get(pressure_C) < 1200 and get(pressure_R) >= 1200 then
		table.insert(messages, tlen(messages) + 1, "HYD PRESS SYS L+C")
		table.insert(messages, tlen(messages) + 1, "FLIGHT CONTROLS")
		eicas_nest = 1
	elseif get(pressure_L) < 1200 and get(pressure_C) >= 1200 and get(pressure_R) >= 1200 then
		table.insert(messages, tlen(messages) + 1, "HYD PRESS SYS L")
	elseif get(pressure_L) >= 1200 and get(pressure_C) < 1200 and get(pressure_R) >= 1200 then
		table.insert(messages, tlen(messages) + 1, "HYD PRESS SYS C")
	elseif get(pressure_L) >= 1200 and get(pressure_C) >= 1200 and get(pressure_R) < 1200 then
		table.insert(messages, tlen(messages) + 1, "HYD PRESS SYS R")
	end
end

function checkGearDoors()
	n_not_in_pos = 0
	if get(c_time) >= gear_transit_time + 26 then
		for i=2,4 do
			local door_pos = globalPropertyfae("Strato/777/gear/doors", i)
			if get(door_pos) ~= 0 then
				n_not_in_pos = n_not_in_pos + 1
			end
		end
	end
	if n_not_in_pos > 0 then
		return 1
	end
	return 0
end

function CheckOvht(pump_type, messages) --Returns the second line of the overheat message
	names = {"L", "C1", "C2", "R"}
	ovht = {}
	for i=1,4 do
		local pump_ovht = globalPropertyfae("Strato/777/hydraulics/pump/primary/ovht", i)
		if pump_type == 2 then --1 = primary, 2 = demand
			pump_ovht = globalPropertyfae("Strato/777/hydraulics/pump/demand/ovht", i)
		end
		if get(pump_ovht) == 1 then
			msg = ""
			if pump_type == 1 then
				msg = "HYD OVERHEAT PRI " .. names[i]
			else
				msg = "HYD OVERHEAT DEM " .. names[i]
			end
			table.insert(messages, tlen(messages) + 1, msg)
		end
	end
end

function CheckFail(pump_type, messages)
	names = {"L", "C1", "C2", "R"}
	for i=1,4 do
		local s = i
		if i > 2 then
			s = i - 1
		end
		local pump_fail = globalPropertyfae("Strato/777/hydraulics/pump/primary/fail", i)
		local pump_state = globalPropertyiae("Strato/777/hydraulics/pump/primary/state", i)
		local hyd_press = globalPropertyiae("Strato/777/hydraulics/press", s)
		if pump_type == 2 then --1 = primary, 2 = demand
			pump_fail = globalPropertyfae("Strato/777/hydraulics/pump/demand/fail", i)
			pump_state = globalPropertyiae("Strato/777/hydraulics/pump/demand/state", i)
		end
		if (get(pump_fail) == 1 and get(pump_state) > 0) or (get(hyd_press) > 1200 and get(hyd_press) < 1800) then
			msg = ""
			if pump_type == 1 then
				msg = "HYD PRESS PRI " .. names[i]
			else
				msg = "HYD PRESS DEM " .. names[i]
			end
			table.insert(messages, tlen(messages) + 1, msg)
		end
	end
end

function UpdateWindowAdvisory(messages)
	local pos_w_l = globalPropertyfae("Strato/777/windows", 1)
	local pos_w_r = globalPropertyfae("Strato/777/windows", 2)
	UpdateAdvisorySide(messages, "WINDOW FLT DECK L", "WINDOW FLT DECK R", "WINDOWS", pos_w_l, pos_w_r)
end

function UpdateSpoilerAdvisory(messages)
	sp_inop = false
	for i, v in ipairs(spoiler_fail) do
		if get(v) == 1 then
			table.insert(messages, tlen(messages) + 1, "SPOILERS")
			break
		end
	end
end

function UpdateStabCutoutAdvisory(messages)
	if get(stab_cutout_R) == 1 then
		table.insert(messages, tlen(messages) + 1, "STABILIZER R")
	end
	if get(stab_cutout_C) == 1 then
		table.insert(messages, tlen(messages) + 1, "STABILIZER C")
	end
end

function UpdateCDUCtrl(messages)
	if get(dsp_ctrl, 1) == 1 or get(dsp_ctrl, 2) == 1 or get(dsp_ctrl, 3) == 1 then
		table.insert(messages, tlen(messages) + 1, "DISPLAY SELECT PNL")
	end
	if get(efis_ctrl, 1) == 1 then
		table.insert(messages, tlen(messages) + 1, "EFIS CONTROL PNL L")
	end
	if get(efis_ctrl, 2) == 1 then
		table.insert(messages, tlen(messages) + 1, "EFIS CONTROL PNL R")
	end
end

function UpdateGearPos()
	local height = 615
	gear_status_pos = {990, 620, 900, 554, 1080, 554} --Coordinates of the bottom left corner of gear status signs for alternate extension
	--If gear has been retracted, weit 10 seconds before we hide the status
	local gear_in_pos = Round(get(nw_actual), 2) ~= 0 or Round(get(mlg_actual_L), 2) ~= 0 or Round(get(mlg_actual_R), 2) ~= 0
	if gear_in_pos == false and handle_past == 1 and Round(get(handle_pos), 2) == 0 then
		gear_display_time = get(c_time)
		handle_past = 0
	end
	if handle_past == 0 and Round(get(handle_pos), 2) ~= 0 then
		handle_past = 1
		if get(altn_gear) == 0 then
			gear_transit_time = get(c_time)
		end
	elseif handle_past == 1 and get(handle_pos) ~= 1 and gear_dn == true then
		if get(altn_gear) == 0 then
			gear_transit_time = get(c_time)
		end
	end
	if get(altn_gear) ~= altn_gear_past then
		if get(altn_gear) == 1 then
			gear_transit_time = get(c_time)
		end
		altn_gear_past = get(altn_gear)
	end
	if gear_in_pos == true or Round(get(handle_pos), 2) ~= 0 or get(c_time) < gear_display_time + 10 or get(altn_gear) == 1 then
		if get(altn_gear) == 0 then
			--Display simplified gear status if alternate extension isn't used
			local avg_gear_pos = (get(nw_actual) + get(mlg_actual_L) + get(mlg_actual_R)) / 3
			local color = {1, 1, 1}
			local text = ""
			if avg_gear_pos == 0 then
				text = "UP"
				gear_dn = false
			elseif avg_gear_pos == 1 then
				text = "DOWN"
				color = {0, 1, 0}
				gear_dn = true
			else
				gear_dn = false
			end
			DrawRect(970, height, 110, 60, 5, color)
			if text ~= "" then
				drawText(font, 1025, height + 12, text, 50, false, false, TEXT_ALIGN_CENTER, color)
			else
				Stripify(970, height, 110, 60, 6, 5, color)
			end
		else
			--Advanced status displaying
			n_gear_dn = 0
			for i=1,3 do
				local color = {1, 1, 1}
				local text = ""
				local gear_pos = globalPropertyfae("sim/aircraft/parts/acf_gear_deploy", i)
				if get(gear_pos) == 0 then
					text = "UP"
				elseif get(gear_pos) == 1 then
					color = {0, 1, 0}
					text = "DN"
					n_gear_dn = n_gear_dn + 1
				end
				DrawRect(gear_status_pos[i*2-1], gear_status_pos[i*2], 70, 50, 5, color)
				if text ~= "" then
					drawText(font, gear_status_pos[i*2-1] + 34, gear_status_pos[i*2] + 7, text, 45, false, false, TEXT_ALIGN_CENTER, color)
				else
					Stripify(gear_status_pos[i*2-1], gear_status_pos[i*2], 70, 50, 4, 5, color)
				end
			end
			if n_gear_dn == 3 then
				gear_dn = true
			else
				gear_dn = false
			end
		end
		drawText(font, 1025, height - 48, "GEAR", 45, false, false, TEXT_ALIGN_CENTER, {0.17, 0.71, 0.83})
	end
end

function Flap_pos2Tape(pos, t_height) --calculates an offset from the top of the flap position bar
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
	local setting = flap_settings[indexOf(detents, get(flap_handle), 1)]
	local cur_flap = 0
	if get(flaps) ~= nil then
		cur_flap = get(flaps)
	end
	if setting == nil then
		setting = 0
	end
	if cur_flap ~= flaps_past then
		if cur_flap == 0 then
			flap_retract_time = get(c_time)
		end
		flaps_past = cur_flap
	end
	if setting > 0 or cur_flap > 0 or get(c_time) < flap_retract_time + 10 then
		if math.abs(cur_flap - setting) > 0.0002 then
			color = magenta
		else
			color = {0, 1, 0}
		end
		handle_on_screen = round(530 - tape_height * get(flap_handle)) --position of flap handle on screen
		flaps_on_screen = round(530 - Flap_pos2Tape(cur_flap, tape_height))
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

function UpdateEicasWarnings(messages, conf_warn)
	local ths_min_val_conv = THS_greenband_min_val * (2/15)-1
	local ths_max_val_conv = THS_greenband_max_val * (2/15)-1
	local avg_cas = (get(cas_pilot) + get(cas_copilot)) / 2
	local avg_ra = (get(ra_pilot) + get(ra_copilot)) / 2
	local to_flaps = {5, 15, 20}
	if get(on_ground) == 0 then
		if avg_cas < get(stall_speed) then
			table.insert(messages, tlen(messages) + 1, "STALL")
		elseif avg_cas > get(max_allowable) then
			table.insert(messages, tlen(messages) + 1, "OVERSPEED")
		end
	else
		--Config warnings
		local tmp_warns = {}
		local n_warns = 0
		if get(throttle_pos) > 0.5 then
			local idx = indexOf(to_flaps, get(flaps), 1)
			if get(spoiler_handle) < 0 then
				table.insert(tmp_warns, tlen(tmp_warns) + 1, "CONFIG SPOILERS")
				n_warns = n_warns + 1
			end
			if get(stab_trim) < ths_min_val_conv or get(stab_trim) > ths_max_val_conv then
				table.insert(tmp_warns, tlen(tmp_warns) + 1, "CONFIG STABILIZER")
				n_warns = n_warns + 1
			end
			if get(park_brake_valve) == 1 then
				table.insert(tmp_warns, tlen(tmp_warns) + 1, "CONFIG PARKING BRAKE")
				n_warns = n_warns + 1
			end
			if get(main_s_locked) == 0 then
				table.insert(tmp_warns, tlen(tmp_warns) + 1, "CONFIG GEAR STEERING")
				n_warns = n_warns + 1
			end
			if idx == nil then
				table.insert(tmp_warns, tlen(tmp_warns) + 1, "CONFIG FLAPS")
				n_warns = n_warns + 1
			end
		end
		if (get(c_time) >= conf_time + 10 and n_conf_warns_past == 0) or n_warns > 0 then
			conf_warn = tmp_warns
			conf_time = get(c_time)
		end
		n_conf_warns_past = n_warns
	end
	for k in pairs(conf_warn) do
		table.insert(messages, tlen(messages) + 1, conf_warn[k])
	end
	if avg_ra < 800 and get(throttle_pos) < 0.05 and gear_dn == false then
		table.insert(messages, tlen(messages) + 1, "CONFIG GEAR")
	end
	if get(sys_C_press) < 900 and get(sys_R_press) < 900 and get(stab_cutout_C) * get(stab_cutout_R) == 0 then
		if get(c_time) > stab_time_no_pwr + 5 then
			table.insert(messages, tlen(messages) + 1, "STABILIZER")
		end
	else
		stab_time_no_pwr = get(c_time)
	end
	return conf_warn
end

function UpdateEicasAdvisory(messages)
	local avg_cas = (get(cas_pilot) + get(cas_copilot)) / 2
	local avg_ra = (get(ra_pilot) + get(ra_copilot)) / 2
	local nest_strg = ""
	--Draw cautions
	if get(fbw_mode) == 2 then
		table.insert(messages, tlen(messages) + 1, "FLIGHT CONTROL MODE")
	elseif get(fbw_mode) == 3 then
		table.insert(messages, tlen(messages) + 1, "PRI FLIGHT COMPUTERS")
	end
	if avg_cas < get(manuever_speed) and avg_cas > get(stall_speed) and get(on_ground) == 0 then
		table.insert(messages, tlen(messages) + 1, "AIRSPEED LOW")
	end
	UpdatePress(messages)
	if get(spoiler_handle) > 0 then
		if avg_ra > 15 and (avg_ra < 800 or get(flap_handle) >= 0.5 or get(throttle_pos) > 0.1) then
			table.insert(messages, tlen(messages) + 1, "SPEEDBRAKE EXTENDED")
		end
	end
	if get(tac_fail) == 1 then
		table.insert(messages, tlen(messages) + 1, "THRUST ASYM COMP")
	end
	UpdateStabCutoutAdvisory(messages)
	local door_stat = checkGearDoors()
	if door_stat == 1 then
		table.insert(messages, tlen(messages) + 1, "GEAR DOOR")
	end
	if get(acc) == 1 then
		table.insert(messages, tlen(messages) + 1, "BRAKE SOURCE")
	end
	if get(stab_cutout_C) * get(stab_cutout_R) == 1  then
		table.insert(messages, tlen(messages) + 1, "STABILIZER CUTOUT")
	end
	UpdateSpoilerAdvisory(messages)
	if get(pressure_C) < 1200 or (get(fbw_mode) > 1 and get(fbw_self_test) == 0) then
		table.insert(messages, tlen(messages) + 1, "AUTO SPEEDBRAKE")
	end
	if get(eicas_tire_press) == 1 then
		table.insert(messages, tlen(messages) + 1, "TIRE PRESS")
	end
	if get(eicas_brake_temp) == 1 then
		table.insert(messages, tlen(messages) + 1, "BRAKE TEMP")
	end
	UpdateCDUCtrl(messages)
	CheckFail(1, messages)
	CheckFail(2, messages)
	CheckOvht(1, messages)
	CheckOvht(2, messages)
	--window advisory
	UpdateWindowAdvisory(messages)
end

function UpdateMemo(messages, msg_avail)
	local c_avail = msg_avail
	if get(park_brake_valve) ~= park_brake_past then
		if not park_brake_time_set then
			park_brake_time = get(c_time)
			park_brake_time_set = true
		elseif park_brake_time_set and get(c_time) > park_brake_time + 1 then
			park_brake_past = get(park_brake_valve)
			park_brake_time_set = false
		end
	end
	if park_brake_past == 1 and c_avail >= 1 then
		table.insert(messages, 1, "PARKING BRAKE SET")
		c_avail = c_avail - 1
	end
	if get(spoiler_handle) < 0 and c_avail >= 1 then
		table.insert(messages, 1, "SPEEDBRAKE ARMED")
		c_avail = c_avail - 1
	end
	if get(on_ground) == 1 and get(throttle_pos) < 0.5 and c_avail >= 1 then
		table.insert(messages, 1, "DOORS AUTO")
	end
end

function DisplayMessages(messages, offset, color, step, start_p, end_p)
	if end_p >= start_p then
		local hyd_idx = nil
		local fctl_mode_idx = indexOf(messages, "FLIGHT CONTROL MODE")
		local hyd_press_idx1 = indexOf(messages, "HYD PRESS SYS L")
		local hyd_press_idx2 = indexOf(messages, "HYD PRESS SYS C")
		local hyd_press_idx3 = indexOf(messages, "HYD PRESS SYS R")
		if hyd_press_idx1 ~= nil then
			hyd_idx = hyd_press_idx1
		elseif hyd_press_idx2 ~= nil then
			hyd_idx = hyd_press_idx2
		elseif hyd_press_idx3 ~= nil then
			hyd_idx = hyd_press_idx3
		end
		local fctl_idx = indexOf(messages, "FLIGHT CONTROLS")
		for i=1,end_p - start_p + 1 do
			local curr_idx = start_p + i - 1
			local curr_msg = messages[curr_idx]
			if fctl_idx ~= nil and curr_idx > fctl_idx then
				curr_msg = " "..curr_msg
			elseif fctl_idx == nil and hyd_idx ~= nil and curr_idx > hyd_idx then
				curr_msg = " "..curr_msg
			end
			drawText(font, 830, offset - step * (i - 1), curr_msg, 50, false, false, TEXT_ALIGN_LEFT, color)
		end
	end
end

function draw()
	UpdateWindows()
	if get(eicas_power_upper) == 1 then
		local offset = 1275
		local n_dsp = 0
		local curr_end = 0
		local n_warnings = 0
		local n_advisories = 0
		local warnings = {}
		local advisories = {}
		local memo = {}
		UpdateGearPos()
		UpdateFlaps()
		conf_warns_past = UpdateEicasWarnings(warnings, conf_warns_past)
		if get(c_time) >= tmp1 + 1 then
			UpdateEicasAdvisory(advisories)
			advisories_past = advisories
		end
		n_warnings = tlen(warnings)
		n_advisories = tlen(advisories_past)
		n_dsp = n_advisories + n_warnings
		UpdateMemo(memo, 11 - n_dsp)
		UpdateCanc(n_advisories, n_warnings)
		DisplayMessages(warnings, offset, {1, 0, 0}, 50, 1, n_warnings)
		offset = offset - 50 * n_warnings
		if get(canc) == 0 or get(recall_past) == 1 then
			if n_dsp > 11 then
				local curr_pg = math.floor(advisories_start / (11 - n_warnings)) + 1
				drawText(font, 1280, 740, "PG "..tostring(curr_pg), 30, false, false, TEXT_ALIGN_CENTER, {1, 1, 1})
			end
			if n_dsp - advisories_start < 10 then
				curr_end = n_dsp - n_warnings
			else
				curr_end = advisories_start + 10 - n_warnings
			end
			DisplayMessages(advisories_past, offset, {1, 0.96, 0.07}, 50, advisories_start, curr_end)
		end
		DisplayMessages(memo, 775, {1, 1, 1}, -50, 1, tlen(memo))
		if get(recall_past) == 1 and get(canc) == 1 then
			drawText(font, 830, 740, "RECALL", 30, false, false, TEXT_ALIGN_LEFT, {1, 1, 1})
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
