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

--Finding own datarefs

fbw_mode = globalPropertyi("Strato/777/fctl/pfc/mode")
max_allowable = globalPropertyi("Strato/777/fctl/vmax")
manuever_speed = globalPropertyi("Strato/777/fctl/vmanuever")

--Finding simulator commands
toggle_regular = sasl.findCommand("sim/flight_controls/brakes_toggle_regular")
hold_regular = sasl.findCommand("sim/flight_controls/brakes_regular")
toggle_max = sasl.findCommand("sim/flight_controls/brakes_toggle_max")
gear_down = sasl.findCommand("sim/flight_controls/landing_gear_down")
gear_up = sasl.findCommand("sim/flight_controls/landing_gear_up")
gear_toggle = sasl.findCommand("sim/flight_controls/landing_gear_toggle")
trim_up = sasl.findCommand("sim/flight_controls/pitch_trim_up")
trim_down = sasl.findCommand("sim/flight_controls/pitch_trim_down")

function BrakeHandler(phase)
	if phase == SASL_COMMAND_BEGIN then
		set(man_brakes_L, 1 - get(man_brakes_L))
		set(man_brakes_R, 1 - get(man_brakes_R))
	end
end

function BrakeHoldHandler(phase)
	if phase == SASL_COMMAND_CONTINUE then
		set(man_brakes_L, 1)
		set(man_brakes_R, 1)
	elseif phase == SASL_COMMAND_END then
		set(man_brakes_L, 0)
		set(man_brakes_R, 0)
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
	if get(on_ground) == 1 or get(fbw_mode) == 3 then
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
	if get(on_ground) == 1 or get(fbw_mode) == 3 then
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

--Registering own command handlers
sasl.registerCommandHandler(toggle_regular, 1, BrakeHandler)
sasl.registerCommandHandler(hold_regular, 1, BrakeHoldHandler)
sasl.registerCommandHandler(toggle_max, 1, ParkBrakeHandler)
sasl.registerCommandHandler(gear_up, 1, GearUp)
sasl.registerCommandHandler(gear_toggle, 1, ToggleGear)
sasl.registerCommandHandler(trim_up, 1, StabTrimUp)
sasl.registerCommandHandler(trim_down, 1, StabTrimDown)

