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
addSearchPath(moduleDirectory.."/Custom Module/ND")
addSearchPath(moduleDirectory.."/Custom Module/TCAS")
addSearchPath(moduleDirectory.."/Custom Module/AUTOFLT/FBW")
addSearchPath(moduleDirectory.."/Custom Module/AUTOFLT/")
addSearchPath(moduleDirectory.."/Custom Module/EICAS/UPPER")
addSearchPath(moduleDirectory.."/Custom Module/EICAS/LOWER")

time_elapsed = createGlobalPropertyf("Strato/777/time/current", 0)


--Data Ref registering/finding:

--Switches

gear_lever = createGlobalPropertyi("Strato/777/cockpit/switches/gear_tgt", 0)
speedbrake_handle = createGlobalPropertyf("Strato/777/cockpit/switches/sb_handle", 0)
pitch_trim_A = createGlobalPropertyi("Strato/777/cockpit/switches/strim_A", 0)
pitch_trim_B = createGlobalPropertyi("Strato/777/cockpit/switches/strim_B", 0)
pitch_trim_altn = createGlobalPropertyi("Strato/777/cockpit/switches/strim_altn", 0)
rud_pedals = createGlobalPropertyf("Strato/777/cockpit/switches/rud_pedals", 0)
caut_cap_anim = createGlobalPropertyf("Strato/777/cockpit/switches/caut_cap", 0)
caut_fo_anim = createGlobalPropertyf("Strato/777/cockpit/switches/caut_fo", 0)
--ap_engaged = createGlobalPropertyi("Strato/777/mcp/ap_on", 0)
-- 0 off, 1 auto, 2 on
pass_sgn_anim = createGlobalPropertyf("Strato/777/cockpit/switches/pass_sgn", 0)
no_smok_anim = createGlobalPropertyf("Strato/777/cockpit/switches/no_smok", 0)
--0 off 1 on
flap_altn_anim = createGlobalPropertyf("Strato/777/cockpit/switches/altn_flaps", 0)
autothr_arm_l_anim = createGlobalPropertyf("Strato/777/cockpit/switches/autothr_arm_l", 0)
autothr_arm_r_anim = createGlobalPropertyf("Strato/777/cockpit/switches/autothr_arm_r", 0)
-- -1 retract 0 off 1 extend
flap_altn_re_anim = createGlobalPropertyf("Strato/777/cockpit/switches/altn_re", 0)


show_fpv = createGlobalPropertyi("Strato/777/EFIS/fpv_on", 0)

autothr_arm = createGlobalPropertyi("Strato/777/mcp/at_arm", 1)
spd_hold = createGlobalPropertyi("Strato/777/mcp/spd_hold", 0)
flch = createGlobalPropertyi("Strato/777/mcp/flch", 0)
toga = createGlobalPropertyi("Strato/777/mcp/toga", 0)
at_disc = createGlobalPropertyi("Strato/777/mcp/at_disc", 0)
ap_disc_bar = createGlobalPropertyi("Strato/777/mcp/ap_disc_bar", 0)

flt_dir_pilot = createGlobalPropertyi("Strato/777/mcp/flt_dir_pilot", 0)
flt_dir_copilot = createGlobalPropertyi("Strato/777/mcp/flt_dir_copilot", 0)

caut_cap = createGlobalPropertyi("Strato/777/glareshield/caut_cap", 0)
caut_fo = createGlobalPropertyi("Strato/777/glareshield/caut_fo", 0)
flap_altn = createGlobalPropertyi("Strato/777/pedestal/flap_altn", 0)
flap_altn_re = createGlobalPropertyi("Strato/777/pedestal/flap_altn_re", 0)

pass_sgn = createGlobalPropertyi("Strato/777/overhead/pass_sgn", 0)
no_smok = createGlobalPropertyi("Strato/777/overhead/no_smok", 0)

autothr_arm_l = createGlobalPropertyi("Strato/777/mcp/autothr_arm_l", 1)
autothr_arm_r = createGlobalPropertyi("Strato/777/mcp/autothr_arm_r", 1)

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
man_brakes_L = createGlobalPropertyf("Strato/777/gear/manual_braking_L", 0)
man_brakes_R = createGlobalPropertyf("Strato/777/gear/manual_braking_R", 0)

autobrk_sw_pos = createGlobalPropertyf("Strato/777/gear/autobrake_pos", 0)
autobrk_mode = createGlobalPropertyi("Strato/777/gear/autobrake_mode", -1)
autobrk_act = createGlobalPropertyf("Strato/777/gear/autobrk_cmd", 0)
autobrk_apply = createGlobalPropertyi("Strato/777/gear/autobrk_apply", 0)
autobrk_inop = createGlobalPropertyi("Strato/777/gear/autobrk_inop", 0)

stab_cutout_C = createGlobalPropertyi("Strato/777/fctl/stab_cutout_C", 0)
stab_cutout_R = createGlobalPropertyi("Strato/777/fctl/stab_cutout_R", 0)

ap_disc = createGlobalPropertyi("Strato/777/autopilot/disc", 0)
alt_alert = createGlobalPropertyi("Strato/777/autopilot/alt_alert", 0)

fpv_pitch = createGlobalPropertyf("Strato/777/autopilot/fpv_pitch", 0)
fpv_roll = createGlobalPropertyf("Strato/777/autopilot/fpv_roll", 0)
--Flaps&slats
flap_mode = createGlobalPropertyi("Strato/777/flaps/mode", 0)
slat_mode = createGlobalPropertyi("Strato/777/slats/mode", 0)
slat_tgt = createGlobalPropertyf("Strato/777/flaps/slat_tgt", 0)

--Lights:
lt_caut_cap = createGlobalPropertyi("Strato/777/cockpit/lights/caut_cap", 0)
lt_warn_cap = createGlobalPropertyi("Strato/777/cockpit/lights/warn_cap", 0)
lt_caut_fo = createGlobalPropertyi("Strato/777/cockpit/lights/caut_fo", 0)
lt_warn_fo = createGlobalPropertyi("Strato/777/cockpit/lights/warn_fo", 0)
lt_cab_ps = createGlobalPropertyi("Strato/777/cabin/lights/pass_sgn", 0)
lt_cab_ns = createGlobalPropertyi("Strato/777/cabin/lights/no_smok", 0)
--Door values: 1 open, 0 closed. 1 armed, 0 disarmed. Emergency slides: 1 deployed, 0 stowed
--Pax doors:
pax_drs_l_anim = createGlobalPropertyfa("Strato/777/doors/cabin_ent_L_anim", {0, 0, 0, 0, 0})
pax_drs_r_anim = createGlobalPropertyfa("Strato/777/doors/cabin_ent_R_anim", {0, 0, 0, 0, 0})
pax_drs_tgt_l = createGlobalPropertyia("Strato/777/doors/cabin_ent_L_tgt", {0, 0, 0, 0, 0})
pax_drs_tgt_r = createGlobalPropertyia("Strato/777/doors/cabin_ent_R_tgt", {0, 0, 0, 0, 0})
pax_drs_arm_l = createGlobalPropertyia("Strato/777/doors/cabin_ent_L_arm", {1, 1, 1, 1, 1})
pax_drs_arm_r = createGlobalPropertyia("Strato/777/doors/cabin_ent_R_arm", {1, 1, 1, 1, 1})
pax_drs_slide_l_anim = createGlobalPropertyfa("Strato/777/doors/cabin_L_slide_anim", {0, 0, 0, 0, 0})
pax_drs_slide_r_anim = createGlobalPropertyfa("Strato/777/doors/cabin_R_slide_anim", {0, 0, 0, 0, 0})
pax_drs_slide_l_tgt = createGlobalPropertyia("Strato/777/doors/cabin_L_slide_tgt", {0, 0, 0, 0, 0})
pax_drs_slide_r_tgt = createGlobalPropertyia("Strato/777/doors/cabin_R_slide_tgt", {0, 0, 0, 0, 0})

--Cargo doors&misc
--Indexing: 1 front 2 aft, 3 bulk
cargo_drs_anim = createGlobalPropertyfa("Strato/777/doors/cargo_anim", {0, 0, 0})
cargo_drs_tgt = createGlobalPropertyia("Strato/777/doors/cargo_tgt", {0, 0, 0})
--Hatches:
--Indexing: 1 left engine cowl, 2 right engine cowl, 3 apu maint doors
hatch_anim = createGlobalPropertyfa("Strato/777/doors/hatch_anim", {0, 0, 0})
hatch_tgt = createGlobalPropertyia("Strato/777/doors/hatch_tgt", {0, 0, 0})

--Failure datarefs

fbw_secondary_fail = createGlobalPropertyi("Strato/777/failures/fctl/secondary", 0)
fbw_direct_fail = createGlobalPropertyi("Strato/777/failures/fctl/direct", 0)
autobrk_fail = createGlobalPropertyi("Strato/777/failures/gear/autobrake", 0)
goofy_fault_haha = createGlobalPropertyi("Strato/777/failures/737max", 1)
--Flaps
flaps_jam_all_lt = createGlobalPropertyi("Strato/777/failures/fctl/flap_jam_l", 0)
flaps_jam_all_rt = createGlobalPropertyi("Strato/777/failures/fctl/flap_jam_r", 0)
--Slats
slats_jam_all_inn = createGlobalPropertyi("Strato/777/failures/fctl/slat_jam_inn", 0)
slats_jam_all_out = createGlobalPropertyi("Strato/777/failures/fctl/slat_jam_out", 0)
-- Use the devmode dataref for a more comprehensive overview of what's happening
devmode = createGlobalPropertyi("Strato/777/goku_area/devmode", 0)

--test

--input_icao = globalPropertys("Strato/777/FMC/FMC_R/REF_NAV/input_icao")

--apt_lat = globalPropertys("Strato/777/FMC/FMC_R/REF_NAV/apt_lat")
--apt_lon = globalPropertys("Strato/777/FMC/FMC_R/REF_NAV/apt_lon")
--apt_elev = globalPropertys("Strato/777/FMC/FMC_R/REF_NAV/apt_elev")

--ui_1 = globalProperty("Strato/777/UI/messages/creating_databases")

--Overrides

fctl_ovrd = globalPropertyf("sim/operation/override/override_control_surfaces") --for overriding default xp flight controls
brk_ovrd = globalPropertyi("sim/operation/override/override_gearbrake")
steer_ovrd = globalPropertyi("sim/operation/override/override_wheel_steer")
throttle_ovrd = globalProperty("sim/operation/override/override_throttles")

set(fctl_ovrd, 1)
set(steer_ovrd, 1)
set(brk_ovrd, 1)
set(throttle_ovrd, 1)

components = {
	--test{
	--	position = {20 , 1384, 1337, 1337},
	--	visible = true,
	--	fpsLimit = 50
	--},
	timers {},
	doors {},
	tcas_main {},
	speed_calc {},
	hydraulics {},
	fbw_drefs {},
	ace_logic {},
	pfc_logic {},
	auto_calib {},
	fctl {},
	auto_thr {},
	eec {},
	autobrk {},
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
		position = {2730 , 0, 1337, 1337},
		visible = true,
		fpsLimit = 50
	},
	eicas {
		position = {2730 , 1400, 1365, 1365},
		visible = true,
		fpsLimit = 50
	},
	--nd_fo {
	--	position = {1380 , 15, 1337, 1337},
	--	visible = true,
	--	fpsLimit = 50
	--},
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
