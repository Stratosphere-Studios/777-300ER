--[[
*****************************************************************************************
* Script Name: custom_commands
* Author Name: @bruh
* Script Description: Code for custom command handlers
*****************************************************************************************
--]]

--Landing gear
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
sys_C_press = globalPropertyfae("Strato/777/hydraulics/press", 2)
sys_R_press = globalPropertyfae("Strato/777/hydraulics/press", 3)
fbw_trim_speed = globalPropertyf("Strato/777/fctl/trs")
stab_trim = globalPropertyf("sim/cockpit2/controls/elevator_trim")
ths_degrees = globalPropertyf("sim/flightmodel2/controls/stabilizer_deflection_degrees")
stab_cutout_C = globalPropertyi("Strato/777/fctl/stab_cutout_C")
stab_cutout_R = globalPropertyi("Strato/777/fctl/stab_cutout_R")
--Operation
on_ground = globalPropertyi("sim/flightmodel/failures/onground_any")
f_time = globalPropertyf("sim/operation/misc/frame_rate_period")
--Finding own datarefs
ace_fail = globalProperty("Strato/777/failures/fctl/ace") --L1, L2, C, R
man_keyboard = globalPropertyi("Strato/777/gear/man_keyboard")
fbw_mode = globalPropertyi("Strato/777/fctl/pfc/mode")
pfc_disc = globalPropertyi("Strato/777/fctl/pfc/disc")
tac_engage = globalPropertyi("Strato/777/fctl/ace/tac_eng")
max_allowable = globalPropertyi("Strato/777/fctl/vmax")
manuever_speed = globalPropertyi("Strato/777/fctl/vmanuever")
rud_trim_man = globalPropertyf("Strato/777/fctl/ace/rud_trim_man")
rud_trim_reset = globalPropertyi("Strato/777/fctl/ace/rud_trim_reset")

--Finding simulator commands
toggle_regular = sasl.findCommand("sim/flight_controls/brakes_toggle_regular")
hold_regular = sasl.findCommand("sim/flight_controls/brakes_regular")
toggle_max = sasl.findCommand("sim/flight_controls/brakes_toggle_max")
gear_down = sasl.findCommand("sim/flight_controls/landing_gear_down")
gear_up = sasl.findCommand("sim/flight_controls/landing_gear_up")
gear_toggle = sasl.findCommand("sim/flight_controls/landing_gear_toggle")
stab_trim_up = sasl.findCommand("sim/flight_controls/pitch_trim_up")
stab_trim_down = sasl.findCommand("sim/flight_controls/pitch_trim_down")
rudder_trim_left = sasl.findCommand("sim/flight_controls/rudder_trim_left")
rudder_trim_right = sasl.findCommand("sim/flight_controls/rudder_trim_right")
rudder_trim_center = sasl.findCommand("sim/flight_controls/rudder_trim_center")
--Creating own commands
pfc_disc_switch = sasl.createCommand("Strato/777/commands/overhead/pfc_disc", "Command for the PFC disc switch")
tac_switch = sasl.createCommand("Strato/777/commands/overhead/tac", "Command for the TAC button")

park_brake_past = 0

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

function GearUp(phase)
	if get(on_ground) == 1 then
		if get(lock_ovrd) == 1 and get(normal_gear) == 1 then
			return 1
		else
			return 0
		end
	else
		return 1
	end
end

function ToggleGear(phase)
	if get(on_ground) == 1 and get(normal_gear) == 1 then
		if get(lock_ovrd) == 1 then
			return 1
		else
			return 0
		end
	else
		return 1
	end
end

function StabTrimUp(phase)
	if get(on_ground) == 1 or get(fbw_mode) ~= 1 then
		if get(sys_C_press) * (1 - get(stab_cutout_C)) > 900 or get(sys_R_press) * (1 - get(stab_cutout_R)) > 900 then
			return 1
		end
	else
		if get(fbw_trim_speed) - 0.1 >= get(manuever_speed) then
			set(fbw_trim_speed, get(fbw_trim_speed) - 0.1)
		end
	end
	return 0
end

function StabTrimDown(phase)
	if get(on_ground) == 1 or get(fbw_mode) ~= 1 then
		if get(sys_C_press) * (1 - get(stab_cutout_C)) > 900 or get(sys_R_press) * (1 - get(stab_cutout_R)) > 900 then
			return 1
		end
	else
		if get(fbw_trim_speed) + 0.1 <= get(max_allowable) then
			set(fbw_trim_speed, get(fbw_trim_speed) + 0.1)
		end
	end
	return 0
end

function RudderTrimLeft(phase)
	if get(ace_fail, 1) == 0 then
		if get(rud_trim_man) - 0.1 >= -17.6 then
			set(rud_trim_man, get(rud_trim_man) - 0.1)
		end
	end
	return 0
end

function RudderTrimRight(phase)
	if get(ace_fail, 1) == 0 then
		if get(rud_trim_man) + 0.1 <= 17.6 then
			set(rud_trim_man, get(rud_trim_man) + 0.1)
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
sasl.registerCommandHandler(stab_trim_up, 1, StabTrimUp)
sasl.registerCommandHandler(stab_trim_down, 1, StabTrimDown)
sasl.registerCommandHandler(rudder_trim_left, 1, RudderTrimLeft)
sasl.registerCommandHandler(rudder_trim_right, 1, RudderTrimRight)
sasl.registerCommandHandler(rudder_trim_center, 1, RudderTrimReset)
--Own commands
sasl.registerCommandHandler(pfc_disc_switch, 1, PFCDiscHandler)
sasl.registerCommandHandler(tac_switch, 1, TACHandler)

function update()
	set(park_brake_handle, get(park_brake_handle) + (get(park_brake_valve) - get(park_brake_handle)) * get(f_time) * 4)
end

function onAirportLoaded()
	park_brake_past = get(park_brake_valve)
end

onAirportLoaded()