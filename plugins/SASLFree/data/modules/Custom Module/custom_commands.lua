--[[
*****************************************************************************************
* Script Name: custom_commands
* Author Name: @bruh
* Script Description: Code for custom command handlers
*****************************************************************************************
--]]

--EICAS control:
recall = globalPropertyi("Strato/777/eicas/rcl", 0)
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
--Stab trim
stab_trim = globalPropertyf("sim/cockpit2/controls/elevator_trim")
ths_degrees = globalPropertyf("sim/flightmodel2/controls/stabilizer_deflection_degrees")
pitch_trim_A = globalPropertyi("Strato/777/cockpit/switches/strim_A")
pitch_trim_B = globalPropertyi("Strato/777/cockpit/switches/strim_B")
pitch_trim_altn = globalPropertyi("Strato/777/cockpit/switches/strim_altn")
stab_cutout_C = globalPropertyi("Strato/777/fctl/stab_cutout_C")
stab_cutout_R = globalPropertyi("Strato/777/fctl/stab_cutout_R")
--Operation
on_ground = globalPropertyi("sim/flightmodel/failures/onground_any")
f_time = globalPropertyf("sim/operation/misc/frame_rate_period")
--Finding own datarefs
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
toggle_regular = sasl.findCommand("sim/flight_controls/brakes_toggle_regular")
hold_regular = sasl.findCommand("sim/flight_controls/brakes_regular")
toggle_max = sasl.findCommand("sim/flight_controls/brakes_toggle_max")
gear_down = sasl.findCommand("sim/flight_controls/landing_gear_down")
gear_up = sasl.findCommand("sim/flight_controls/landing_gear_up")
gear_toggle = sasl.findCommand("sim/flight_controls/landing_gear_toggle")
ptA_up = sasl.findCommand("sim/flight_controls/pitch_trimA_up")
ptB_up = sasl.findCommand("sim/flight_controls/pitch_trimB_up")
ptA_dn = sasl.findCommand("sim/flight_controls/pitch_trimA_down")
ptB_dn = sasl.findCommand("sim/flight_controls/pitch_trimB_down")
stab_trim_up = sasl.findCommand("sim/flight_controls/pitch_trim_up")
stab_trim_down = sasl.findCommand("sim/flight_controls/pitch_trim_down")
rudder_trim_left = sasl.findCommand("sim/flight_controls/rudder_trim_left")
rudder_trim_right = sasl.findCommand("sim/flight_controls/rudder_trim_right")
rudder_trim_center = sasl.findCommand("sim/flight_controls/rudder_trim_center")
--Creating own commands
pfc_disc_switch = sasl.createCommand("Strato/777/commands/overhead/pfc_disc", 
										"Command for the PFC disc switch")
tac_switch = sasl.createCommand("Strato/777/commands/overhead/tac", 
										"Command for the TAC button")
recall_btn = sasl.createCommand("Strato/777/commands/glareshield/recall", 
										"Command for the recall button")
altn_trim_up = sasl.createCommand("Strato/777/commands/pedestal/pitch_trim_altn_up", 
										"Command for the alternate stab trim switch")
altn_trim_dn = sasl.createCommand("Strato/777/commands/pedestal/pitch_trim_altn_down", 
										"Command for the alternate stab trim switch")

park_brake_past = 0

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
		set(park_brake_valve, 1 - get(park_brake_valve))
		if get(realistic_prk_brk) == 0 then
			set(brake_qty_L, 0.02 * get(park_brake_valve))
			set(brake_qty_R, 0.02 * get(park_brake_valve))
			set(brake_press_L, 3000 * get(park_brake_valve))
			set(brake_press_R, 3000 * get(park_brake_valve))
		end
	elseif phase == SASL_COMMAND_END then
		park_brake_past = 1 - park_brake_past
	end
end

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
	if phase == 0 then
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
	if phase == 0 then
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
	if phase == 1 then
		set(pitch_trim_A, 1)
	elseif phase == 2 then
		set(pitch_trim_A, 0)
	end
	return 0
end

function PitchTrimUpB(phase)
	if phase == 1 then
		set(pitch_trim_B, 1)
	elseif phase == 2 then
		set(pitch_trim_B, 0)
	end
	return 0
end

function PitchTrimDnA(phase)
	if phase == 1 then
		set(pitch_trim_A, -1)
	elseif phase == 2 then
		set(pitch_trim_A, 0)
	end
	return 0
end

function PitchTrimDnB(phase)
	if phase == 1 then
		set(pitch_trim_B, -1)
	elseif phase == 2 then
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
	if phase == 1 then
		set(pitch_trim_A, 1)
		set(pitch_trim_B, 1)
	elseif phase == 2 then
		set(pitch_trim_A, 0)
		set(pitch_trim_B, 0)
	end
	return 0
end

function StabTrimDown(phase)
	if phase == 1 then
		set(pitch_trim_A, -1)
		set(pitch_trim_B, -1)
	elseif phase == 2 then
		set(pitch_trim_A, 0)
		set(pitch_trim_B, 0)
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
sasl.registerCommandHandler(rudder_trim_left, 1, RudderTrimLeft)
sasl.registerCommandHandler(rudder_trim_right, 1, RudderTrimRight)
sasl.registerCommandHandler(rudder_trim_center, 1, RudderTrimReset)
--Own commands
sasl.registerCommandHandler(recall_btn, 1, ToggleRecall)
sasl.registerCommandHandler(pfc_disc_switch, 1, PFCDiscHandler)
sasl.registerCommandHandler(tac_switch, 1, TACHandler)
sasl.registerCommandHandler(altn_trim_up, 1, PitchTrimUpAltn)
sasl.registerCommandHandler(altn_trim_dn, 1, PitchTrimDnAltn)

function update()
	set(park_brake_handle, get(park_brake_handle) + (get(park_brake_valve) - get(park_brake_handle)) * get(f_time) * 4)
	if get(on_ground) == 0 then
		set(normal_gear, get(gear_lever))
	end
end

function onAirportLoaded()
	park_brake_past = get(park_brake_valve)
end

onAirportLoaded()