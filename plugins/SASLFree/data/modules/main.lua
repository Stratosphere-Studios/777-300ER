-- main.lua
size = {4096, 4096}
panel2d = false
panelWidth3d = 4096
panelHeight3d = 4096
sasl.options.set3DRendering(true)
sasl.options.setAircraftPanelRendering(true)
sasl.options.setInteractivity(true)
addSearchPath(moduleDirectory.."/Custom Module/EICASCHECK")
addSearchPath(moduleDirectory.."/Custom Module/CURSOR")
addSearchPath(moduleDirectory.."/Custom Module/HYD")
addSearchPath(moduleDirectory.."/Custom Module/FCTL")
addSearchPath(moduleDirectory.."/Custom Module/EICAS/UPPER")
addSearchPath(moduleDirectory.."/Custom Module/EICAS/LOWER")

max_allowable = createGlobalPropertyi("Strato/777/fctl/vmax", 0)
stall_speed = createGlobalPropertyi("Strato/777/fctl/vstall", 0)
manuever_speed = createGlobalPropertyi("Strato/777/fctl/vmanuever", 0)
flap_tgt = createGlobalPropertyf("Strato/777/flaps/tgt", 0)
altn_gear = createGlobalPropertyi("Strato/777/gear/altn_extnsn", 0)
act_press = createGlobalPropertyi("Strato/777/gear/actuator_press", 0)
brake_sys = createGlobalPropertyi("Strato/777/gear/shuttle_valve", 3)
brake_qty_L = createGlobalPropertyf("Strato/777/gear/qty_brake_L", 0)
brake_qty_R = createGlobalPropertyf("Strato/777/gear/qty_brake_R", 0)
stab_cutout_C = createGlobalPropertyi("Strato/777/fctl/stab_cutout_C", 0)
stab_cutout_R = createGlobalPropertyi("Strato/777/fctl/stab_cutout_R", 0)

--Overrides

fctl_ovrd = globalPropertyf("sim/operation/override/override_control_surfaces") --for overriding default xp11 flight controls
brk_ovrd = globalPropertyi("sim/operation/override/override_gearbrake")
steer_ovrd = globalPropertyi("sim/operation/override/override_wheel_steer")

set(fctl_ovrd, 1)
set(steer_ovrd, 1)
set(brk_ovrd, 1)

components = {

	timers {},
	speed_calc {},
	hydraulics {},
	fbw_pid {},
	fctl {},
	gear {},
	eicascheck {
		position = {2730 , 0, 1365, 1365},
		visible = true,
		fpsLimit = 50
	},
	Cursor {
		position = {2730 , 0, 1365, 1365},
		visible = true,
		fpsLimit = 50
	},
	eicas_graphics{
		position = {2730 , 0, 1365, 1365},
		visible = true,
		fpsLimit = 50
	},
	eicas {
		position = {2730 , 1400, 1365, 1365},
		visible = true,
		fpsLimit = 50
	},
	custom_commands {}
}

function onModuleDone()
	sasl.print("Shutting down")
	set(fctl_ovrd, 0)
	set(steer_ovrd, 0)
	set(brk_ovrd, 0)
end