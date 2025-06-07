--[[
*****************************************************************************************
* Script Name: custom_commands
* Author Name: discord/bruh4096#4512(Tim G.)
* Script Description: Code for custom command handlers
*****************************************************************************************
--]]

include("misc_tools.lua")
include("constants.lua")

--Finding datarefs

--ND
--hdg_src = globalPropertyi("Strato/777/cockpit/switches/mag_hdg")
--EICAS control:
recall = globalPropertyi("Strato/777/eicas/rcl")
caut_cap = globalPropertyi("Strato/777/glareshield/caut_cap")
caut_fo = globalPropertyi("Strato/777/glareshield/caut_fo")

caut_cap_anim = globalPropertyf("Strato/777/cockpit/switches/caut_cap")
caut_fo_anim = globalPropertyf("Strato/777/cockpit/switches/caut_fo")
--EICAS warning lights:
lt_caut_cap = globalPropertyi("Strato/777/cockpit/lights/caut_cap")
lt_warn_cap = globalPropertyi("Strato/777/cockpit/lights/warn_cap")
lt_caut_fo = globalPropertyi("Strato/777/cockpit/lights/caut_fo")
lt_warn_fo = globalPropertyi("Strato/777/cockpit/lights/warn_fo")
--Landing gear
gear_lever = globalPropertyi("Strato/777/cockpit/switches/gear_tgt")
normal_gear = globalPropertyi("sim/cockpit2/controls/gear_handle_down")
lock_ovrd = globalPropertyi("Strato/777/gear/lock_ovrd")
--Brakes
park_brake_valve = globalPropertyi("Strato/777/gear/park_brake_valve")
park_brake_handle = createGlobalPropertyf("Strato/777/gear/park_brake", 1)
realistic_prk_brk = globalPropertyi("Strato/777/gear/park_brake_realistic")
man_brakes_L = globalPropertyf("Strato/777/gear/manual_braking_L")
brake_qty_L = globalPropertyf("Strato/777/gear/qty_brake_L") --overall fluid quantity in left brakes
brake_press_L = globalPropertyi("Strato/777/gear/brake_press_L")
man_brakes_R = globalPropertyf("Strato/777/gear/manual_braking_R")
brake_qty_R = globalPropertyf("Strato/777/gear/qty_brake_R") --overall fluid quantity in left brakes
brake_press_R = globalPropertyi("Strato/777/gear/brake_press_R")
autobrk_mode = globalPropertyi("Strato/777/gear/autobrake_mode")
autobrk_sw_pos = globalPropertyf("Strato/777/gear/autobrake_pos")
--Stab trim
stab_trim = globalPropertyf("sim/cockpit2/controls/elevator_trim")
ths_degrees = globalPropertyf("sim/flightmodel2/controls/stabilizer_deflection_degrees")
pitch_trim_A = globalPropertyi("Strato/777/cockpit/switches/strim_A")
pitch_trim_B = globalPropertyi("Strato/777/cockpit/switches/strim_B")
pitch_trim_altn = globalPropertyi("Strato/777/cockpit/switches/strim_altn")
stab_cutout_C = globalPropertyi("Strato/777/fctl/stab_cutout_C")
stab_cutout_R = globalPropertyi("Strato/777/fctl/stab_cutout_R")
--Flaps
flap_altn = globalPropertyi("Strato/777/pedestal/flap_altn")
flap_altn_re = globalPropertyi("Strato/777/pedestal/flap_altn_re")

flap_altn_anim = globalPropertyf("Strato/777/cockpit/switches/altn_flaps")
flap_altn_re_anim = globalPropertyf("Strato/777/cockpit/switches/altn_re")
--Pass signs
pass_sgn = globalPropertyi("Strato/777/overhead/pass_sgn")
no_smok = globalPropertyi("Strato/777/overhead/no_smok")

pass_sgn_anim = globalPropertyf("Strato/777/cockpit/switches/pass_sgn")
no_smok_anim = globalPropertyf("Strato/777/cockpit/switches/no_smok")
--Anti ice
wai = globalPropertyi("Strato/777/overhead/wai")
eai_l = globalPropertyi("Strato/777/overhead/eai_l")
eai_r = globalPropertyi("Strato/777/overhead/eai_r")

wing_ai_anim = globalPropertyf("Strato/777/cockpit/switches/wai")
eng_ai_l_anim = globalPropertyf("Strato/777/cockpit/switches/eai_l")
eng_ai_r_anim = globalPropertyf("Strato/777/cockpit/switches/eai_r")
--Spoilers:
speedbrake_handle = globalPropertyf("Strato/777/cockpit/switches/sb_handle")
--Autopilot
ap_disc = globalPropertyi("Strato/777/autopilot/disc")
ap_engaged = globalPropertyi("Strato/777/mcp/ap_on")
ap_disc_bar = globalPropertyi("Strato/777/mcp/ap_disc_bar")

autothr_arm_l = globalPropertyi("Strato/777/overhead/autothr_arm_l", 0)
autothr_arm_r = globalPropertyi("Strato/777/overhead/autothr_arm_r", 0)

autothr_arm_l_anim = globalPropertyf("Strato/777/cockpit/switches/autothr_arm_l", 0)
autothr_arm_r_anim = globalPropertyf("Strato/777/cockpit/switches/autothr_arm_r", 0)
--Operation
on_ground = globalPropertyi("sim/flightmodel/failures/onground_any")
f_time = globalPropertyf("sim/operation/misc/frame_rate_period")
dsp_ctrl = globalProperty("Strato/777/cdu_eicas_ctl")
ace_fail = globalProperty("Strato/777/failures/fctl/ace") --L1, L2, C, R
man_keyboard = globalPropertyi("Strato/777/gear/man_keyboard")
fbw_mode = globalPropertyi("Strato/777/fctl/pfc/mode")
pfc_disc = globalPropertyi("Strato/777/fctl/pfc/disc")
tac_engage = globalPropertyi("Strato/777/fctl/ace/tac_eng")
rud_trim_man = globalPropertyf("Strato/777/fctl/ace/rud_trim_man")
rud_trim_reset = globalPropertyi("Strato/777/fctl/ace/rud_trim_reset")

--Creating own datarefs:


--Finding simulator commands
--Brakes:
toggle_regular = sasl.findCommand("sim/flight_controls/brakes_toggle_regular")
hold_regular = sasl.findCommand("sim/flight_controls/brakes_regular")
toggle_max = sasl.findCommand("sim/flight_controls/brakes_toggle_max")
--Gear:
gear_down = sasl.findCommand("sim/flight_controls/landing_gear_down")
gear_up = sasl.findCommand("sim/flight_controls/landing_gear_up")
gear_toggle = sasl.findCommand("sim/flight_controls/landing_gear_toggle")
--Stab trim:
ptA_up = sasl.findCommand("sim/flight_controls/pitch_trimA_up")
ptB_up = sasl.findCommand("sim/flight_controls/pitch_trimB_up")
ptA_dn = sasl.findCommand("sim/flight_controls/pitch_trimA_down")
ptB_dn = sasl.findCommand("sim/flight_controls/pitch_trimB_down")
stab_trim_up = sasl.findCommand("sim/flight_controls/pitch_trim_up")
stab_trim_down = sasl.findCommand("sim/flight_controls/pitch_trim_down")
--Speedbrakes:
sb_ret_one = sasl.findCommand("sim/flight_controls/speed_brakes_up_one")
sb_ext_one = sasl.findCommand("sim/flight_controls/speed_brakes_down_one")
sb_ret_full = sasl.findCommand("sim/flight_controls/speed_brakes_up_all")
sb_ext_full = sasl.findCommand("sim/flight_controls/speed_brakes_down_all")
sb_toggle = sasl.findCommand("sim/flight_controls/speed_brakes_toggle")
--Rudder:
rudder_trim_left = sasl.findCommand("sim/flight_controls/rudder_trim_left")
rudder_trim_right = sasl.findCommand("sim/flight_controls/rudder_trim_right")
rudder_trim_center = sasl.findCommand("sim/flight_controls/rudder_trim_center")
--Creating own commands
--mag_hdg_btn = sasl.createCommand("Strato/777/commands/ND/mag_hdg", 
--									"Command for the magnetic heading switch")
--Flight controls:
pfc_disc_switch = sasl.createCommand("Strato/777/commands/overhead/pfc_disc", 
										"Command for the PFC disc switch")
tac_switch = sasl.createCommand("Strato/777/commands/overhead/tac", 
										"Command for the TAC button")
altn_trim_up = sasl.createCommand("Strato/777/commands/pedestal/pitch_trim_altn_up", 
										"Command for the alternate stab trim switch")
altn_trim_dn = sasl.createCommand("Strato/777/commands/pedestal/pitch_trim_altn_down", 
										"Command for the alternate stab trim switch")
--Flaps:
altn_flaps_btn = sasl.createCommand("Strato/777/commands/pedestal/altn_flaps", "")
altn_flaps_re_btn_incr = sasl.createCommand("Strato/777/commands/pedestal/altn_flaps_re_incr", "")
altn_flaps_re_btn_decr = sasl.createCommand("Strato/777/commands/pedestal/altn_flaps_re_decr", "")
--Autopilot:
ap_on_btn = sasl.createCommand("Strato/777/commands/mcp/otto_on", 
										"Command for autopilot on switch")
ap_disc_btn = sasl.createCommand("Strato/777/commands/yoke/otto_disc", 
										"Command for autopilot disconnect switch")
ap_disc_bar_btn = sasl.createCommand("Strato/777/commands/mcp/otto_off", 
										"Command for autopilot disconnect bar")
autothr_arm_l_btn = sasl.createCommand("Strato/777/commands/mcp/autothr_arm_l", 
										"")
autothr_arm_r_btn = sasl.createCommand("Strato/777/commands/mcp/autothr_arm_r", 
										"")
--Autobrake:
abrk_incr = sasl.createCommand("Strato/777/commands/pedestal/abrk_incr", 
	"Command for increasing autobrake mode")
abrk_decr = sasl.createCommand("Strato/777/commands/pedestal/abrk_decr", 
	"Command for increasing autobrake mode")
--Master caution and recall:
mast_wc_capt = sasl.createCommand("Strato/777/commands/glareshield/mast_wc_capt", 
	"Command not for captain's toilet flush button, but the master warning button")
mast_wc_fo = sasl.createCommand("Strato/777/commands/glareshield/mast_wc_fo", 
	"Command first officer's master warning button")
recall_btn = sasl.createCommand("Strato/777/commands/glareshield/recall", 
	"Command for the recall button")
--Pass signs:
pass_sgn_btn_incr = sasl.createCommand("Strato/777/commands/overhead/pass_sgn_incr", "")
pass_sgn_btn_decr = sasl.createCommand("Strato/777/commands/overhead/pass_sgn_decr", "")
no_smok_btn_incr = sasl.createCommand("Strato/777/commands/overhead/no_smok_incr", "")
no_smok_btn_decr = sasl.createCommand("Strato/777/commands/overhead/no_smok_decr", "")
--Anti ice:
wai_btn_incr = sasl.createCommand("Strato/777/commands/overhead/wai_incr", "")
wai_btn_decr = sasl.createCommand("Strato/777/commands/overhead/wai_decr", "")
eai_l_btn_incr = sasl.createCommand("Strato/777/commands/overhead/eai_l_incr", "")
eai_l_btn_decr = sasl.createCommand("Strato/777/commands/overhead/eai_l_decr", "")
eai_r_btn_incr = sasl.createCommand("Strato/777/commands/overhead/eai_r_incr", "")
eai_r_btn_decr = sasl.createCommand("Strato/777/commands/overhead/eai_r_decr", "")

park_brake_past = 0

sb_handle_detents = {SPEEDBRK_HANDLE_ARMED, 0, 0.5, 1}


--Command handler declaration:

--Brakes:

function BrakeHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(man_keyboard, 1)
		set(man_brakes_L, 1 - get(man_brakes_L))
		set(man_brakes_R, 1 - get(man_brakes_R))
		if 1 - get(man_brakes_L) == 0 and get(park_brake_valve) == 1 then
			set(park_brake_valve, 0)
			park_brake_past = 0
		end
	elseif phase == SASL_COMMAND_END then
		set(man_keyboard, 0)
	end
end

function BrakeHoldHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(man_keyboard, 1)
		if park_brake_past == 1 and get(park_brake_valve) == 1 then
			set(park_brake_valve, 0)
			park_brake_past = 0
		end
	elseif phase == SASL_COMMAND_CONTINUE then
		set(man_brakes_L, 1)
		set(man_brakes_R, 1)
	elseif phase == SASL_COMMAND_END then
		set(man_brakes_L, 0)
		set(man_brakes_R, 0)
		set(man_keyboard, 0)
	end
end

function ParkBrakeHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		if get(realistic_prk_brk) == 0 then
			set(park_brake_valve, 1 - get(park_brake_valve))
			set(brake_qty_L, 0.02 * get(park_brake_valve))
			set(brake_qty_R, 0.02 * get(park_brake_valve))
			set(brake_press_L, 3000 * get(park_brake_valve))
			set(brake_press_R, 3000 * get(park_brake_valve))
		else
			if get(park_brake_valve) == 0 then
				if get(brake_qty_L) > 0 and get(brake_qty_R) > 0 then
					set(park_brake_valve, 1)
				end
			else
				set(park_brake_valve, 0)
			end
		end
	elseif phase == SASL_COMMAND_END then
		park_brake_past = get(park_brake_valve)
	end
end

function AutoBrkIncrHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(autobrk_mode, math.min(get(autobrk_mode)+1, ABRK_MD_MAX))
	end
end

function AutoBrkDecrHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(autobrk_mode, math.max(get(autobrk_mode)-1, ABRK_MD_RTO))
	end
end

--ND

--function MagHdgBtn(phase)
--	if phase == SASL_COMMAND_BEGIN then
--		set(hdg_src_switch, 1 - get(hdg_src_switch))
--	end
--end

--EICAS control

function ToggleRecall(phase)
	if phase == SASL_COMMAND_CONTINUE then
		if get(dsp_ctrl, 1) == 0 and 
		   get(dsp_ctrl, 2) == 0 and
		   get(dsp_ctrl, 3) == 0 then
			set(recall, 1)
		end
	elseif phase == SASL_COMMAND_END then
		set(recall, 0)
	end
end

--FBW:

function PFCDiscHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(pfc_disc, 1 - get(pfc_disc))
	end
end

function TACHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(tac_engage, 1 - get(tac_engage))
	end
end

--Gear:

function GearUp(phase)
	if phase == XPLM_CMD_START then
		if get(on_ground) == 1 then
			if get(lock_ovrd) == 1 and get(gear_lever) == 1 then
				set(gear_lever, 0)
			end
		else
			set(gear_lever, 0)
		end
	end
	return 0
end

function ToggleGear(phase)
	if phase == XPLM_CMD_START then
		if get(on_ground) == 1 then
			if (get(lock_ovrd) == 1 and get(gear_lever) == 1) or get(gear_lever) == 0 then
				set(gear_lever, 1 - get(gear_lever))
			end
		else
			set(gear_lever, 1 - get(gear_lever))
		end
	end
	return 0
end

--Horizontal stabilizer trim

function PitchTrimUpA(phase)
	if phase == XPLM_CMD_CONTINUE then
		set(pitch_trim_A, 1)
	elseif phase == XPLM_CMD_END then
		set(pitch_trim_A, 0)
	end
	return 0
end

function PitchTrimUpB(phase)
	if phase == XPLM_CMD_CONTINUE then
		set(pitch_trim_B, 1)
	elseif phase == XPLM_CMD_END then
		set(pitch_trim_B, 0)
	end
	return 0
end

function PitchTrimDnA(phase)
	if phase == XPLM_CMD_CONTINUE then
		set(pitch_trim_A, -1)
	elseif phase == XPLM_CMD_END then
		set(pitch_trim_A, 0)
	end
	return 0
end

function PitchTrimDnB(phase)
	if phase == XPLM_CMD_CONTINUE then
		set(pitch_trim_B, -1)
	elseif phase == XPLM_CMD_END then
		set(pitch_trim_B, 0)
	end
	return 0
end

function PitchTrimUpAltn(phase)
	if phase == SASL_COMMAND_CONTINUE then
		set(pitch_trim_altn, 1)
	elseif phase == SASL_COMMAND_END then
		set(pitch_trim_altn, 0)
	end
end

function PitchTrimDnAltn(phase)
	if phase == SASL_COMMAND_CONTINUE then
		set(pitch_trim_altn, -1)
	elseif phase == SASL_COMMAND_END then
		set(pitch_trim_altn, 0)
	end
end

function StabTrimUp(phase)
	if phase == XPLM_CMD_CONTINUE then
		set(pitch_trim_A, 1)
		set(pitch_trim_B, 1)
	elseif phase == XPLM_CMD_END then
		set(pitch_trim_A, 0)
		set(pitch_trim_B, 0)
	end
	return 0
end

function StabTrimDown(phase)
	if phase == XPLM_CMD_CONTINUE then
		set(pitch_trim_A, -1)
		set(pitch_trim_B, -1)
	elseif phase == XPLM_CMD_END then
		set(pitch_trim_A, 0)
		set(pitch_trim_B, 0)
	end
	return 0
end

--Speedbrake handle:

function SpeedbrakeDnOne(phase)
	if phase == XPLM_CMD_START then
		for i=2,tlen(sb_handle_detents) do
			if sb_handle_detents[i] > Round(get(speedbrake_handle), 2) then
				set(speedbrake_handle, sb_handle_detents[i])
				break
			end
		end
	end
	return 0
end

function SpeedbrakeUpOne(phase)
	if phase == XPLM_CMD_START then
		local tgt_detent = 0
		for i=1,tlen(sb_handle_detents) do
			if sb_handle_detents[i] >= Round(get(speedbrake_handle), 2) then
				if i ~= 1 then
					tgt_detent = sb_handle_detents[i - 1]
					break
				end
			end
		end
		set(speedbrake_handle, tgt_detent)
	end
	return 0
end

function SpeedbrakeDnFull(phase)
	if phase == XPLM_CMD_START then
		set(speedbrake_handle, 1)
	end
	return 0
end

function SpeedbrakeUpFull(phase)
	if phase == XPLM_CMD_START then
		set(speedbrake_handle, 0)
	end
	return 0
end

function SpeedbrakeToggle(phase)
	if phase == XPLM_CMD_START then
		set(speedbrake_handle, 1 - round(get(speedbrake_handle)))
	end
	return 0
end

--Rudder trim:

function RudderTrimLeft(phase)
	if get(ace_fail, 1) == 0 then
		if get(rud_trim_man) - 0.1 >= -27 then
			set(rud_trim_man, get(rud_trim_man) - 0.1)
		else
			set(rud_trim_man, -27)
		end
	end
	return 0
end

function RudderTrimRight(phase)
	if get(ace_fail, 1) == 0 then
		if get(rud_trim_man) + 0.1 <= 27 then
			set(rud_trim_man, get(rud_trim_man) + 0.1)
		else
			set(rud_trim_man, 27)
		end
	end
	return 0
end

function RudderTrimReset(phase)
	if get(fbw_mode) ~= 3 then
		set(rud_trim_reset, 1)
	end
	return 0
end

--Autopilot
function APOnHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		if get(ap_disc_bar) == 0 and get(on_ground) == 0 then
			set(ap_engaged, 1)
		end
	end 
end

function APDiscHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		if get(ap_engaged) == 1 then
			set(ap_engaged, 0)
			set(ap_disc, 1)
		elseif get(ap_disc) == 1 then
			set(ap_disc, 0)
		end
	end
end

function APDiscBarHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(ap_disc_bar, 1 - get(ap_disc_bar))
		if get(ap_disc_bar) == 1 and get(ap_engaged) == 1 then
			set(ap_engaged, 0)
			set(ap_disc, 1)
		end
	end
end

function WCCapHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(caut_cap, 1)
		set(lt_caut_cap, 0)
	elseif phase == SASL_COMMAND_END then
		set(caut_cap, 0)
	end
end

function WCFOHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(caut_fo, 1)
		set(lt_caut_fo, 0)
	elseif phase == SASL_COMMAND_END then
		set(caut_fo, 0)
	end
end

--Autothrottle
function ATLeftHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(autothr_arm_l, 1-get(autothr_arm_l))
	end
end

function ATRightHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(autothr_arm_r, 1-get(autothr_arm_r))
	end
end

--Flaps:
function AltnFlapExtHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(flap_altn, 1-get(flap_altn))
	end
end

function AltnFlapExtReIncrHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(flap_altn_re, math.min(1, 1+get(flap_altn_re)))
	end
end

function AltnFlapExtReDecrHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(flap_altn_re, math.max(-1, -1+get(flap_altn_re)))
	end
end

--Pass signs:
function PassSignIncrHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(pass_sgn, math.min(2, get(pass_sgn)+1))
	end
end

function PassSignDecrHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(pass_sgn, math.max(0, get(pass_sgn)-1))
	end
end

function NoSmokIncrHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(no_smok, math.min(2, get(no_smok)+1))
	end
end

function NoSmokDecrHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(no_smok, math.max(0, get(no_smok)-1))
	end
end

--Anti ice:
function WAIIncrHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(wai, math.min(2, get(wai)+1))
	end
end

function WAIDecrHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(wai, math.max(0, get(wai)-1))
	end
end

function EAI_LIncrHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(eai_l, math.min(2, get(eai_l)+1))
	end
end

function EAI_LDecrHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(eai_l, math.max(0, get(eai_l)-1))
	end
end

function EAI_RIncrHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(eai_r, math.min(2, get(eai_r)+1))
	end
end

function EAI_RDecrHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(eai_r, math.max(0, get(eai_r)-1))
	end
end


--Registering own command handlers
--Sim commands
sasl.registerCommandHandler(toggle_regular, 1, BrakeHandler)
sasl.registerCommandHandler(hold_regular, 1, BrakeHoldHandler)
sasl.registerCommandHandler(toggle_max, 1, ParkBrakeHandler)
sasl.registerCommandHandler(gear_up, 1, GearUp)
sasl.registerCommandHandler(gear_toggle, 1, ToggleGear)
sasl.registerCommandHandler(ptA_up, 1, PitchTrimUpA)
sasl.registerCommandHandler(ptB_up, 1, PitchTrimUpB)
sasl.registerCommandHandler(ptA_dn, 1, PitchTrimDnA)
sasl.registerCommandHandler(ptB_dn, 1, PitchTrimDnB)
sasl.registerCommandHandler(stab_trim_up, 1, StabTrimUp)
sasl.registerCommandHandler(stab_trim_down, 1, StabTrimDown)
sasl.registerCommandHandler(sb_ret_one, 1, SpeedbrakeUpOne)
sasl.registerCommandHandler(sb_ext_one, 1, SpeedbrakeDnOne)
sasl.registerCommandHandler(sb_ret_full, 1, SpeedbrakeUpFull)
sasl.registerCommandHandler(sb_ext_full, 1, SpeedbrakeDnFull)
sasl.registerCommandHandler(sb_toggle, 1, SpeedbrakeToggle)
sasl.registerCommandHandler(rudder_trim_left, 1, RudderTrimLeft)
sasl.registerCommandHandler(rudder_trim_right, 1, RudderTrimRight)
sasl.registerCommandHandler(rudder_trim_center, 1, RudderTrimReset)
--Own commands
sasl.registerCommandHandler(recall_btn, 1, ToggleRecall)
sasl.registerCommandHandler(pfc_disc_switch, 1, PFCDiscHandler)
sasl.registerCommandHandler(tac_switch, 1, TACHandler)
sasl.registerCommandHandler(altn_trim_up, 1, PitchTrimUpAltn)
sasl.registerCommandHandler(altn_trim_dn, 1, PitchTrimDnAltn)
sasl.registerCommandHandler(ap_on_btn, 1, APOnHandler)
sasl.registerCommandHandler(ap_disc_btn, 1, APDiscHandler)
sasl.registerCommandHandler(ap_disc_bar_btn, 1, APDiscBarHandler)
sasl.registerCommandHandler(abrk_incr, 1, AutoBrkIncrHandler)
sasl.registerCommandHandler(abrk_decr, 1, AutoBrkDecrHandler)
sasl.registerCommandHandler(mast_wc_capt, 1, WCCapHandler)
sasl.registerCommandHandler(mast_wc_fo, 1, WCFOHandler)
--Autothrottle:
sasl.registerCommandHandler(autothr_arm_l_btn, 1, ATLeftHandler)
sasl.registerCommandHandler(autothr_arm_r_btn, 1, ATRightHandler)
--Flaps
sasl.registerCommandHandler(altn_flaps_btn, 1, AltnFlapExtHandler)
sasl.registerCommandHandler(altn_flaps_re_btn_decr, 1, AltnFlapExtReDecrHandler)
sasl.registerCommandHandler(altn_flaps_re_btn_incr, 1, AltnFlapExtReIncrHandler)
--Pass signs:
sasl.registerCommandHandler(pass_sgn_btn_incr, 1, PassSignIncrHandler)
sasl.registerCommandHandler(pass_sgn_btn_decr, 1, PassSignDecrHandler)
sasl.registerCommandHandler(no_smok_btn_incr, 1, NoSmokIncrHandler)
sasl.registerCommandHandler(no_smok_btn_decr, 1, NoSmokDecrHandler)
--Anti ice
sasl.registerCommandHandler(wai_btn_incr, 1, WAIIncrHandler)
sasl.registerCommandHandler(wai_btn_decr, 1, WAIDecrHandler)
sasl.registerCommandHandler(eai_l_btn_incr, 1, EAI_LIncrHandler)
sasl.registerCommandHandler(eai_l_btn_decr, 1, EAI_LDecrHandler)
sasl.registerCommandHandler(eai_r_btn_incr, 1, EAI_RIncrHandler)
sasl.registerCommandHandler(eai_r_btn_decr, 1, EAI_RDecrHandler)

function update()
	set(park_brake_handle, get(park_brake_handle) + (get(park_brake_valve) - get(park_brake_handle)) * get(f_time) * 4)
	set(autobrk_sw_pos, get(autobrk_sw_pos) + (get(autobrk_mode) - get(autobrk_sw_pos)) * get(f_time) * 4)
	set(caut_cap_anim, get(caut_cap_anim) + (get(caut_cap)-get(caut_cap_anim)) * get(f_time) * 4)
	set(caut_fo_anim, get(caut_fo_anim) + (get(caut_fo)-get(caut_fo_anim)) * get(f_time) * 4)
	
	set(flap_altn_anim, get(flap_altn_anim) + (get(flap_altn)-get(flap_altn_anim)) * get(f_time) * 4)
	set(flap_altn_re_anim, get(flap_altn_re_anim) + (get(flap_altn_re)-get(flap_altn_re_anim)) * get(f_time) * 4)
	
	set(autothr_arm_l_anim, get(autothr_arm_l_anim) + (get(autothr_arm_l)-get(autothr_arm_l_anim)) * get(f_time) * 4)
	set(autothr_arm_r_anim, get(autothr_arm_r_anim) + (get(autothr_arm_r)-get(autothr_arm_r_anim)) * get(f_time) * 4)

	set(pass_sgn_anim, get(pass_sgn_anim) + (get(pass_sgn)-get(pass_sgn_anim)) * get(f_time) * 4)
	set(no_smok_anim, get(no_smok_anim) + (get(no_smok)-get(no_smok_anim)) * get(f_time) * 4)

	set(wing_ai_anim, get(wing_ai_anim) + (get(wai)-get(wing_ai_anim)) * get(f_time) * 4)
	set(eng_ai_l_anim, get(eng_ai_l_anim) + (get(eai_l)-get(eng_ai_l_anim)) * get(f_time) * 4)
	set(eng_ai_r_anim, get(eng_ai_r_anim) + (get(eai_r)-get(eng_ai_r_anim)) * get(f_time) * 4)

	if get(on_ground) == 0 then
		set(normal_gear, get(gear_lever))
	end
end

function onAirportLoaded()
	park_brake_past = get(park_brake_valve)
end

onAirportLoaded()