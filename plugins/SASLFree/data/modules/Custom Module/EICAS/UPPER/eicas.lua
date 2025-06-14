--[[
*****************************************************************************************
* Script Name: eicas
* Author Name: discord/bruh4096#4512(Tim G.)
* Script Description: Code for upper eicas
*****************************************************************************************
--]]

addSearchPath(moduleDirectory .. "/Custom Module/")

include("misc_tools.lua")
include("constants.lua")

--Finding sim datarefs

--Cockpit controls
park_brake_valve = globalPropertyi("Strato/777/gear/park_brake_valve")
throttle_pos = globalPropertyf("sim/cockpit2/engine/actuators/throttle_jet_rev_ratio_all")
throttle_L = globalPropertyfae("sim/cockpit2/engine/actuators/throttle_jet_rev_ratio", 1)
throttle_R = globalPropertyfae("sim/cockpit2/engine/actuators/throttle_jet_rev_ratio", 2)
spoiler_handle = globalPropertyf("Strato/777/cockpit/switches/sb_handle")
stab_trim = globalPropertyf("sim/cockpit2/controls/elevator_trim")
ap_disc_bar = globalPropertyi("Strato/777/mcp/ap_disc_bar")
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
inbd_flap_L = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 1)
inbd_flap_R = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 2)
--Gear positions
nw_actual = globalPropertyfae("sim/aircraft/parts/acf_gear_deploy", 1)
mlg_actual_R = globalPropertyfae("sim/aircraft/parts/acf_gear_deploy", 2)
mlg_actual_L = globalPropertyfae("sim/aircraft/parts/acf_gear_deploy", 3)
--Operation
on_ground = globalPropertyi("sim/flightmodel/failures/onground_any")

--Finding own datarefs

efis_ctrl = globalProperty("Strato/777/cdu_efis_ctl")
dsp_ctrl = globalProperty("Strato/777/cdu_eicas_ctl")
--eicas_power_upper = globalPropertyi("Strato/777/elec/eicas_power_upper")
park_brake_valve = globalPropertyi("Strato/777/gear/park_brake_valve")
--Flight controls
fbw_mode = globalPropertyi("Strato/777/fctl/pfc/mode")
tac_fail = globalPropertyi("Strato/777/fctl/ace/tac_fail")
fbw_self_test = globalPropertyi("Strato/777/fctl/pfc/selftest")
max_allowable = globalPropertyi("Strato/777/fctl/vmax")
stall_speed = globalPropertyi("Strato/777/fctl/vstall")
manuever_speed = globalPropertyi("Strato/777/fctl/vmanuever")
--Flaps&slats:
flap_load_relief = globalPropertyi("Strato/777/flaps/load_relief")
c_time = globalPropertyf("Strato/777/time/current")
flap_mode = globalPropertyi("Strato/777/flaps/mode")
slat_mode = globalPropertyi("Strato/777/slats/mode")
slat_1 = globalPropertyf("sim/flightmodel2/controls/slat1_deploy_ratio")
slat_2 = globalPropertyf("sim/flightmodel2/controls/slat2_deploy_ratio")
slat_tgt = globalPropertyf("Strato/777/flaps/slat_tgt")
--Gear&brakes
eicas_brake_temp = globalPropertyi("Strato/777/eicas/brake_temp")
eicas_tire_press = globalPropertyi("Strato/777/eicas/tire_press")
altn_gear = globalPropertyi("Strato/777/gear/altn_extnsn")
main_s_locked = globalPropertyi("Strato/777/gear/main_s_locked")
handle_pos = globalPropertyf("Strato/777/gear/norm_extnsn")
acc = globalPropertyi("Strato/777/gear/brake_acc_in_use")
autobrk_mode = globalPropertyi("Strato/777/gear/autobrake_mode")
--Hydraulics
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
--Cabin stuff:
pass_sgn = globalPropertyi("Strato/777/overhead/pass_sgn")
no_smok = globalPropertyi("Strato/777/overhead/no_smok")
--Doors:
--Passenger:
pax_drs_l_anim = globalProperty("Strato/777/doors/cabin_ent_L_anim")
pax_drs_r_anim = globalProperty("Strato/777/doors/cabin_ent_R_anim")
pax_drs_arm_l = globalProperty("Strato/777/doors/cabin_ent_L_arm")
pax_drs_arm_r = globalProperty("Strato/777/doors/cabin_ent_R_arm")
--Cargo:
cargo_drs_anim = globalProperty("Strato/777/doors/cargo_anim")
--Lights:
lt_caut_cap = globalPropertyi("Strato/777/cockpit/lights/caut_cap")
lt_warn_cap = globalPropertyi("Strato/777/cockpit/lights/warn_cap")
lt_caut_fo = globalPropertyi("Strato/777/cockpit/lights/caut_fo")
lt_warn_fo = globalPropertyi("Strato/777/cockpit/lights/warn_fo")
--Autpoilot
ap_disc = globalPropertyi("Strato/777/autopilot/disc")
alt_alert = globalPropertyi("Strato/777/autopilot/alt_alert")
--Autothrottle
autothr_arm_l = globalPropertyi("Strato/777/mcp/autothr_arm_l")
autothr_arm_r = globalPropertyi("Strato/777/mcp/autothr_arm_r")
--Faults and misc
devmode = globalPropertyi("Strato/777/goku_area/devmode")

--Creating datarefs

recall = createGlobalPropertyi("Strato/777/eicas/rcl", 0)
recall_past = createGlobalPropertyi("Strato/777/eicas/rcl_past", 0)
canc = createGlobalPropertyi("Strato/777/eicas/canc", 0)
windows = createGlobalPropertyfa("Strato/777/windows", {0, 0})
window_target = createGlobalPropertyia("Strato/777/windows_tgt", {0, 0})

font = loadFont("BoeingFont.ttf")

tmp = 0
tmp1 = 0

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
conf_time = 0
advisories_start = 1
flap_retract_time = -11
park_brake_time = -1
park_brake_time_set = false
gear_display_time = -11
gear_transit_time = -26
gear_dn = true
n_adv_last = 0

FLP_FR_THCK = 3
FLP_TXT_LIST = {"F", "L", "A", "P", "S"}
FLP_AD_THCK = 2

flap_nml_rat = {0, 1/8, 1/5, 2/5, 3/5, 4/5, 1}
adv_main = {"PRI FLIGHT COMPUTERS", "HYD PRESS SYS L", "HYD PRESS SYS C", "HYD PRESS SYS R",
	"FLIGHT CONTROLS", "FLAP/SLAT CONTROL"} -- Advisories after which to shift to the right

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
		if get(act) ~= get(tgt) and (get(on_ground) == 1 or get(act) == 0) then
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

function UpdateAutoThrAdvisory(messages)
	local pos_sw_l = get(autothr_arm_l)
	local pos_sw_r = get(autothr_arm_r)
	if pos_sw_l == 0 and pos_sw_r == 1 then
		table.insert(messages, tlen(messages) + 1, "AUTOTHROTTLE DISC L")
	elseif pos_sw_l == 1 and pos_sw_r == 0 then
		table.insert(messages, tlen(messages) + 1, "AUTOTHROTTLE DISC R")
	elseif pos_sw_l == 0 and pos_sw_r == 0 then
		table.insert(messages, tlen(messages) + 1, "AUTOTHROTTLE DISC")
	end
end

function UpdateEntryDoorAdvisory(messages)
	for i=1,5 do
		if get(pax_drs_l_anim, i) > EICAS_DOOR_THRESH then
			table.insert(messages, tlen(messages) + 1, "DOOR ENTRY " .. tostring(i) .. "L")
		end
		if get(pax_drs_r_anim, i) > EICAS_DOOR_THRESH then
			table.insert(messages, tlen(messages) + 1, "DOOR ENTRY " .. tostring(i) .. "R")
		end
	end
end

function UpdateCargoDoorAdvisory(messages)
	for i=1,3 do
		if get(cargo_drs_anim, i) > EICAS_DOOR_THRESH then
			table.insert(messages, tlen(messages) + 1, "DOOR " .. CARGO_DRS_EICAS_NM[i] .. " CARGO")
		end
	end
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
		if get(altn_gear)+get(devmode) == 0 then
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
		if FLAP_STGS_DSP[i] > pos then
			local delta = round((FLAP_HDL_DTTS[i] - FLAP_HDL_DTTS[i - 1]) * t_height)
			return round(FLAP_HDL_DTTS[i-1] * t_height + ((pos - FLAP_STGS_DSP[i-1]) / (FLAP_STGS_DSP[i] - FLAP_STGS_DSP[i - 1])) * delta)
		elseif FLAP_STGS_DSP[i] == pos then
			return round(FLAP_HDL_DTTS[i] * t_height)
		end
	end
	return 0
end

function GetSfcHt(h, psc, dfl, psp)
	local cv = Round(psc, 2)
	local ps_rat = 0
	for i=2,tlen(psp) do
		if psp[i] >= cv then
			ps_rat = ps_rat + (cv-psp[i-1])/(psp[i]-psp[i-1])*(dfl[i]-dfl[i-1])
			break
		else
			ps_rat = dfl[i]
		end
	end
	return h*ps_rat
end

function DrawSlatPos(x, y, w, h, psc, clr, lt, is_altn, is_lock)
	local v_offs = 15
	local k_ps = 0.4
	cl_upper = clr
	cl_lwr = CL_DARK_BLUE
	sasl.gl.drawRectangle(x, y, w, h*psc, clr)
	local s_tps = get(slat_tgt)*h
	if lt == 1 then
		sasl.gl.drawTriangle(x, y+h*psc, x+w, y+h*psc, x+w, y+h*psc+v_offs, cl_upper)
		sasl.gl.drawTriangle(x, y, x+w, y, x+w, y+v_offs, cl_lwr)
		if is_altn == 0 and is_lock == 0 then
			sasl.gl.drawWideLine(x-w*k_ps, y+s_tps-w*k_ps*(v_offs/w), x+w, y+s_tps+v_offs, FLP_FR_THCK, clr)
		end
		-- Draw the frame
		if is_altn == 1 then
			for i=0,2 do
				sasl.gl.drawWideLine(x-w*k_ps, y+h*i/2-w*k_ps*(v_offs/w), x, y+h*i/2, FLP_AD_THCK, clr)
			end
		end
		sasl.gl.drawWideLine(x, y, x, y+h, FLP_FR_THCK, clr)
		sasl.gl.drawWideLine(x, y+h, x+w, y+h+v_offs, FLP_FR_THCK, clr)
		sasl.gl.drawWideLine(x+w, y+h+v_offs, x+w, y+v_offs, FLP_FR_THCK, clr)
		sasl.gl.drawWideLine(x+w, y+v_offs, x, y, FLP_FR_THCK, clr)
	else
		sasl.gl.drawTriangle(x, y+h*psc+v_offs, x, y+h*psc, x+w, y+h*psc, cl_upper)
		sasl.gl.drawTriangle(x, y, x+w, y, x, y+v_offs, cl_lwr)
		if is_altn == 0 and is_lock == 0 then
			sasl.gl.drawWideLine(x+w+w*k_ps, y+s_tps-w*k_ps*(v_offs/w), x, y+s_tps+v_offs, FLP_FR_THCK, clr)
		end
		-- Draw the frame
		if is_altn == 1 then
			for i=0,2 do
				sasl.gl.drawWideLine(x+w+w*k_ps, y+h*i/2-w*k_ps*(v_offs/w), x+w, y+h*i/2, FLP_AD_THCK, clr)
			end
		end
		sasl.gl.drawWideLine(x, y+v_offs, x, y+h+v_offs, FLP_FR_THCK, clr)
		sasl.gl.drawWideLine(x, y+h+v_offs, x+w, y+h, FLP_FR_THCK, clr)
		sasl.gl.drawWideLine(x+w, y+h, x+w, y, FLP_FR_THCK, clr)
		sasl.gl.drawWideLine(x+w, y, x, y+v_offs, FLP_FR_THCK, clr)
	end
	
end

function DrawSfcPos(x, y, w, h, psc, clr, dfl, psp)
	sasl.gl.drawRectangle(x, y, w, -GetSfcHt(h, psc, dfl, psp), clr)
end

function DrawFlapSecAltn(st_disp, hdl_idx, hdl_clr, flap_md, slat_md)
	local tape_height_altn = 190
	local altn_hdl_offs = 18

	local handle_on_screen = 415-GetSfcHt(tape_height_altn, hdl_idx, flap_nml_rat, FLAP_STGS)
	local pos_l = get(inbd_flap_L)
	local pos_r = get(inbd_flap_R)
	local pos_slat = (get(slat_1)+get(slat_2))/2
	
	local flp_clr = CL_WHITE
	if flap_md == FLAP_MD_SEC_LOCK then
		flp_clr = CL_AMBER
	end
	local slt_clr = CL_WHITE
	if slat_md == FLAP_MD_SEC_LOCK then
		slt_clr = CL_AMBER
	end
	local is_altn = 0
	local is_slat_lock = 0
	if flap_md == FLAP_MD_ALTN or slat_md == FLAP_MD_ALTN then
		is_altn = 1
	end
	if slat_md == FLAP_MD_SEC_LOCK then
		is_slat_lock = 1
	end

	DrawRect(944, 415, 50, tape_height_altn, FLP_FR_THCK, flp_clr, false)
	DrawRect(1064, 415, 50, tape_height_altn, FLP_FR_THCK, flp_clr, false)
	DrawSfcPos(944, 415, 50, tape_height_altn, pos_l, flp_clr, flap_nml_rat, FLAP_STGS)
	DrawSfcPos(1064, 415, 50, tape_height_altn, pos_r, flp_clr, flap_nml_rat, FLAP_STGS)

	if is_altn == 0 then
		sasl.gl.drawWideLine(944-altn_hdl_offs, handle_on_screen, 994, handle_on_screen, 6, hdl_clr)
		sasl.gl.drawWideLine(1064, handle_on_screen, 1114+altn_hdl_offs, handle_on_screen, 6, hdl_clr)
	else
		for i=0,5 do
			local cps = 415-tape_height_altn*i/5
			sasl.gl.drawWideLine(944-altn_hdl_offs, cps, 944, cps, FLP_AD_THCK, CL_WHITE)
			sasl.gl.drawWideLine(1114, cps, 1114+altn_hdl_offs, cps, FLP_AD_THCK, CL_WHITE)
			if i == 1 then
				drawText(font, 1151, cps - 15, "5", 45, false, false, TEXT_ALIGN_LEFT, hdl_clr)
				drawText(font, 910, cps - 15, "5", 45, false, false, TEXT_ALIGN_RIGHT, hdl_clr)
			elseif i == 3 then
				drawText(font, 1151, cps - 15, "20", 45, false, false, TEXT_ALIGN_LEFT, hdl_clr)
				drawText(font, 910, cps - 15, "20", 45, false, false, TEXT_ALIGN_RIGHT, hdl_clr)
			end
		end
	end
	
	DrawSlatPos(944, 440, 50, 70, pos_slat, slt_clr, 1, is_altn, is_slat_lock)
	DrawSlatPos(1064, 440, 50, 70, pos_slat, slt_clr, 0, is_altn, is_slat_lock)

	if is_altn == 0 then
		if hdl_idx ~= 0 then
			drawText(font, 1141, handle_on_screen - 15, tostring(st_disp), 45, false, false, TEXT_ALIGN_LEFT, hdl_clr)
		else
			drawText(font, 1141, handle_on_screen - 15, "UP", 45, false, false, TEXT_ALIGN_LEFT, hdl_clr)
		end
	end
	
	for i=1,5 do --Draw flaps text vertically
		drawText(font, 1020, 430 - 35 * (i - 1), FLP_TXT_LIST[i], 40, false, false, TEXT_ALIGN_LEFT, {0.17, 0.71, 0.83})
	end
end

function UpdateFlaps() --this is for updating flap position on eicas
	local tape_height = 300
	local ftx_x = 965
	local handle_color = {0, 1, 0}
	local magenta = {0.94, 0.57, 1}
	
	local hdl_idx = indexGR(FLAP_HDL_DTTS, get(flap_handle), 2)
	--print(hdl_idx, get(flap_handle))
	local setting = FLAP_STGS[hdl_idx]
	local setting_disp = FLAP_STGS_DSP[hdl_idx]
	local cur_flap = 0
	local cur_md_fp = get(flap_mode)
	local cur_md_st = get(slat_mode)

	local avg_slat = (get(slat_1)+get(slat_2))/2

	local draw_pri = 0
	if get(devmode) == 0 then
		if cur_md_fp == FLAP_MD_PRI and cur_md_st == FLAP_MD_PRI then
			draw_pri = 1
		end
	else
		cur_md_fp = FLAP_MD_SEC
		cur_md_st = FLAP_MD_SEC
	end

	if draw_pri == 1 then
		cur_flap = get(flaps)+avg_slat
		setting = FLAP_STGS_CMB[hdl_idx]
	else
		cur_flap = get(flaps)
	end
	if cur_flap ~= flaps_past then
		if cur_flap <= 0.001 then
			flap_retract_time = get(c_time)
		end
		flaps_past = cur_flap
	end

	if math.abs(cur_flap - setting) > 0.0002 then
		handle_color = magenta
	else
		handle_color = {0, 1, 0}
	end

	if setting > 0 or cur_flap > 0.01 or get(c_time) < flap_retract_time + 10 or draw_pri ~= 1 then
		if draw_pri == 1 then
			local handle_on_screen = 530-GetSfcHt(tape_height, setting, flap_nml_rat, FLAP_STGS_CMB)
			DrawRect(1000, 530, 50, tape_height, FLP_FR_THCK, CL_WHITE, false)
			DrawSfcPos(1000, 530, 50, tape_height, cur_flap, CL_WHITE, flap_nml_rat, FLAP_STGS_CMB)
			sasl.gl.drawWideLine(990, handle_on_screen, 1060, handle_on_screen, 6, handle_color)
			if setting ~= 0 then
				drawText(font, 1070, handle_on_screen - 15, tostring(setting_disp), 45, false, false, TEXT_ALIGN_LEFT, handle_color)
			else
				drawText(font, 1070, handle_on_screen - 15, "UP", 45, false, false, TEXT_ALIGN_LEFT, handle_color)
			end
			for i=1,5 do --Draw flaps text vertically
				drawText(font, 965, 430 - 35 * (i - 1), FLP_TXT_LIST[i], 40, false, false, TEXT_ALIGN_LEFT, {0.17, 0.71, 0.83})
			end
		else
			DrawFlapSecAltn(setting_disp, setting, handle_color, cur_md_fp, cur_md_st)
		end
	end
end

function UpdateEicasWarnings(messages, conf_warn)
	local ths_min_val_conv = THS_greenband_min_val * (2/15)-1
	local ths_max_val_conv = THS_greenband_max_val * (2/15)-1
	local avg_cas = (get(cas_pilot) + get(cas_copilot)) / 2
	local avg_ra = (get(ra_pilot) + get(ra_copilot)) / 2
	local to_flaps = {9, 15, 20}
	local tmp_warns = {}
	local n_config_warnings = 0
	if get(on_ground) == 0 then
		if avg_cas < get(stall_speed) then
			table.insert(messages, tlen(messages) + 1, "STALL")
		elseif avg_cas > get(max_allowable) then
			table.insert(messages, tlen(messages) + 1, "OVERSPEED")
		end
		if get(ap_disc) == 1 then
			table.insert(messages, tlen(messages) + 1, "AUTOPILOT DISC")
		end
	else
		--Config warnings
		if get(throttle_L) > 0.5 or get(throttle_R) > 0.5 then
			local idx = indexOf(to_flaps, get(flaps), 1)
			if get(spoiler_handle) < 0 then
				table.insert(tmp_warns, tlen(tmp_warns) + 1, "CONFIG SPOILERS")
				n_config_warnings = n_config_warnings + 1
			end
			if get(stab_trim) < ths_min_val_conv or get(stab_trim) > ths_max_val_conv then
				table.insert(tmp_warns, tlen(tmp_warns) + 1, "CONFIG STABILIZER")
				n_config_warnings = n_config_warnings + 1
			end
			if get(park_brake_valve) == 1 then
				table.insert(tmp_warns, tlen(tmp_warns) + 1, "CONFIG PARKING BRAKE")
				n_config_warnings = n_config_warnings + 1
			end
			if get(main_s_locked) == 0 then
				table.insert(tmp_warns, tlen(tmp_warns) + 1, "CONFIG GEAR STEERING")
				n_config_warnings = n_config_warnings + 1
			end
			if idx == nil then
				table.insert(tmp_warns, tlen(tmp_warns) + 1, "CONFIG FLAPS")
				n_config_warnings = n_config_warnings + 1
			end
		end
	end
	if (get(c_time) >= conf_time + 10 and n_conf_warns_past == 0) or n_config_warnings > 0 then
		conf_warn = tmp_warns
		conf_time = get(c_time)
	end
	n_conf_warns_past = n_config_warnings
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
	--Update cautions
	UpdateAutoThrAdvisory(messages)
	if get(alt_alert) == 1 then
		table.insert(messages, tlen(messages) + 1, "ALTITUDE ALERT")
	end
	if get(ap_disc_bar) == 1 then
		table.insert(messages, tlen(messages) + 1, "NO AUTOLAND")
	end
	if get(fbw_mode) == 2 then
		table.insert(messages, tlen(messages) + 1, "FLIGHT CONTROL MODE")
	elseif get(fbw_mode) == 3 then
		table.insert(messages, tlen(messages) + 1, "PRI FLIGHT COMPUTERS")
	end
	local flap_md = get(flap_mode)
	local slat_md = get(slat_mode)
	if flap_md == FLAP_MD_ALTN then
		table.insert(messages, tlen(messages) + 1, "FLAP/SLAT CONTROL")
	end
	if flap_md == FLAP_MD_SEC_LOCK or flap_md == FLAP_MD_SEC then
		table.insert(messages, tlen(messages) + 1, "FLAPS PRIMARY FAIL")
	end
	if slat_md == FLAP_MD_SEC_LOCK or slat_md == FLAP_MD_SEC then
		table.insert(messages, tlen(messages) + 1, "SLATS PRIMARY FAIL")
	end
	if get(flap_mode) == FLAP_MD_SEC_LOCK then
		table.insert(messages, tlen(messages) + 1, "FLAPS DRIVE")
	end
	if get(slat_mode) == FLAP_MD_SEC_LOCK then
		table.insert(messages, tlen(messages) + 1, "SLATS DRIVE")
	end
	if avg_cas < get(manuever_speed) and avg_cas > get(stall_speed) and get(on_ground) == 0 then
		table.insert(messages, tlen(messages) + 1, "AIRSPEED LOW")
	end
	UpdateEntryDoorAdvisory(messages)
	UpdateCargoDoorAdvisory(messages)
	UpdatePress(messages)
	if get(spoiler_handle) > 0 then
		if avg_ra > 15 and (avg_ra < 800 or get(flap_handle) >= 0.5 or get(throttle_pos) > 0.1) then
			table.insert(messages, tlen(messages) + 1, "SPEEDBRAKE EXTENDED")
		end
	end
	if get(tac_fail) == 1 then
		table.insert(messages, tlen(messages) + 1, "THRUST ASYM COMP")
	end
	if get(autobrk_mode) == ABRK_MD_DISARM then
		table.insert(messages, tlen(messages) + 1, "AUTOBRAKE")
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
	local abrk_str = ABRK_MODE_STRS[get(autobrk_mode)+3]
	if abrk_str ~= "" and c_avail >= 1 then
		table.insert(messages, 1, "AUTOBRAKE " .. abrk_str)
		c_avail = c_avail - 1
	end
	if c_avail >= 1 then
		if get(no_smok) ~= PASS_SGN_ON and get(pass_sgn) == PASS_SGN_ON then
			table.insert(messages, 1, "SEATBELTS ON")
			c_avail = c_avail - 1
		elseif get(no_smok) == PASS_SGN_ON and get(pass_sgn) ~= PASS_SGN_ON then
			table.insert(messages, 1, "NO SMOKING ON")
			c_avail = c_avail - 1
		elseif get(no_smok) == PASS_SGN_ON and get(pass_sgn) == PASS_SGN_ON then
			table.insert(messages, 1, "PASS SIGNS ON")
			c_avail = c_avail - 1
		end
	end
	local has_doors_auto = 0
	local has_doors_man = 0
	for i=1,4 do
		if get(pax_drs_arm_l, i)+get(pax_drs_arm_r, i) >= 1 then
			has_doors_auto = 1
		end
		if get(pax_drs_arm_l, i)+get(pax_drs_arm_r, i) ~= 2 then
			has_doors_man = 1
		end
	end
	if get(on_ground) == 1 and get(throttle_pos) < 0.5 and c_avail >= 1 then
		if has_doors_auto == 1 and has_doors_man == 0 then
			table.insert(messages, 1, "DOORS AUTO")
		elseif has_doors_auto == 0 and has_doors_man == 1 then
			table.insert(messages, 1, "DOORS MANUAL")
		else
			table.insert(messages, 1, "DOORS AUTO/MANUAL")
		end
	end
end

function DisplayMessages(messages, offset, color, step, start_p, end_p)
	if end_p >= start_p then
		local idxmin = 100000
		for i, v in ipairs(adv_main) do
			local tmp = indexOf(messages, v)
			if tmp ~= nil then
				idxmin = math.min(idxmin, tmp)
			end
		end
		for i=1,end_p - start_p + 1 do
			local curr_idx = start_p + i - 1
			local curr_msg = messages[curr_idx]
			if curr_idx > idxmin then
				curr_msg = " "..curr_msg
			end
			drawText(font, 830, offset - step * (i - 1), curr_msg, 50, false, false, TEXT_ALIGN_LEFT, color)
		end
	end
end

function UpdateCautionLights(n_advisories, n_warnings)
	if n_advisories ~= n_adv_last and n_advisories ~= 0 then
		set(lt_caut_cap, 1)
		set(lt_caut_fo, 1)
	elseif n_advisories == 0 then
		set(lt_caut_cap, 0)
		set(lt_caut_fo, 0)
	end
	if n_warnings ~= 0 then
		set(lt_warn_cap, 1)
		set(lt_warn_fo, 1)
	else
		set(lt_warn_cap, 0)
		set(lt_warn_fo, 0)
	end
	n_adv_last = n_advisories
end

function draw()
	UpdateWindows()
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

	UpdateCautionLights(n_advisories, n_warnings)

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
	if get(c_time) >= tmp1 + 2 then
		tmp1 = get(c_time)
	end
end
