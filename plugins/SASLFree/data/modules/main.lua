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
addSearchPath(moduleDirectory.."/Custom Module/ELEC")
addSearchPath(moduleDirectory.."/Custom Module/AUTOFLT/FBW")
addSearchPath(moduleDirectory.."/Custom Module/EICAS/UPPER")
addSearchPath(moduleDirectory.."/Custom Module/EICAS/LOWER")

--Data Ref registering/finding:

--Switches

gear_lever = createGlobalPropertyi("Strato/777/cockpit/switches/gear_tgt", 0)
pitch_trim_A = createGlobalPropertyi("Strato/777/cockpit/switches/strim_A", 0)
pitch_trim_B = createGlobalPropertyi("Strato/777/cockpit/switches/strim_B", 0)
pitch_trim_altn = createGlobalPropertyi("Strato/777/cockpit/switches/strim_altn", 0)
rud_pedals = createGlobalPropertyf("Strato/777/cockpit/switches/rud_pedals", 0)

--Systems datarefs

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

--Failure datarefs

fbw_secondary_fail = createGlobalPropertyi("Strato/777/failures/fctl/secondary", 0)
fbw_direct_fail = createGlobalPropertyi("Strato/777/failures/fctl/direct", 0)
goofy_fault_haha = createGlobalPropertyi("Strato/777/failures/737max", 1)

--Overrides

fctl_ovrd = globalPropertyf("sim/operation/override/override_control_surfaces") --for overriding default xp11 flight controls
brk_ovrd = globalPropertyi("sim/operation/override/override_gearbrake")
steer_ovrd = globalPropertyi("sim/operation/override/override_wheel_steer")
throttle_ovrd = globalProperty("sim/operation/override/override_throttles")

set(fctl_ovrd, 1)
set(steer_ovrd, 1)
set(brk_ovrd, 1)
set(throttle_ovrd, 1)

components = {

	timers {},
	elec_main {},
	speed_calc {},
	hydraulics {},
	fbw_drefs {},
	ace_logic {},
	pfc_logic {},
	auto_calib {},
	fctl {},
	eec {},
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
	lights {},
	custom_commands {},
	failures {}
}

function onModuleDone()
	sasl.print("Shutting down")
	set(fctl_ovrd, 0)
	set(steer_ovrd, 0)
	set(brk_ovrd, 0)
	set(throttle_ovrd, 0)
end