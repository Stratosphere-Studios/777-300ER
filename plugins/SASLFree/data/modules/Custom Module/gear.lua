include("misc_tools.lua")

f_time = globalPropertyf("sim/operation/misc/frame_rate_period")
yoke_heading_ratio = globalPropertyf("sim/cockpit2/controls/yoke_heading_ratio")
steer_ovrd = globalPropertyi("sim/operation/override/override_wheel_steer")
brk_ovrd = globalProperty("sim/operation/override/override_gearbrake")
nw_strg = globalPropertyfae("sim/flightmodel/parts/tire_steer_cmd", 1) -- 140
nw_speed = globalPropertyfae("sim/flightmodel2/gear/tire_rotation_speed_rad_sec", 1)
ground_speed = globalPropertyf("sim/flightmodel/position/groundspeed")
r_w_strg = globalPropertyfae("sim/flightmodel/parts/tire_steer_cmd", 2) -- 20
r_wheel_brake = globalPropertyf("sim/cockpit2/controls/right_brake_ratio")
l_w_strg = globalPropertyfae("sim/flightmodel/parts/tire_steer_cmd", 3)
l_wheel_brake = globalPropertyf("sim/cockpit2/controls/left_brake_ratio")
t_phi = globalPropertyf("sim/flightmodel/position/true_phi") --bank angle
t_theta = globalPropertyf("sim/flightmodel/position/true_theta") --pitch
gear_handle = globalPropertyi("sim/cockpit2/controls/gear_handle_down")
sys_C_press = globalPropertyfae("Strato/777/hydraulics/press", 2)

gear_tgt = createGlobalPropertyfa("Strato/777/gear/tgt", {1, 1, 1})
lock_factor = createGlobalPropertyia("Strato/777/gear/lock_f", {1, 1, 1})
actuator_press = createGlobalPropertyia("Strato/777/gear/actuator_press", {0, 0, 0})
doors = createGlobalPropertyfa("Strato/777/gear/doors", {0, 0, 0, 0})
skid_ratio = createGlobalPropertyfa("Strato/777/gear/wheel_skid_ratio", {0, 0, 0})

set(steer_ovrd, 1)
set(brk_ovrd, 1)

function UpdateGearStrg(r_time)
	local h_load = globalPropertyfae("Strato/777/hydraulics/load", 8) 
	local nw_ratio = 70
	local w_tgt = 0 --steering target for the main wheels
	local l_all = 0 --total load created by steering 0.1 max
	if Round(get(nw_speed), 2) / 6.28 >= 1.5 then
		nw_ratio = 13
	end
	if get(sys_C_press) > 200 then
		set(nw_strg, get(nw_strg) + (nw_ratio * get(yoke_heading_ratio) - get(nw_strg)) * r_time * get(f_time))
		l_all = 0.05 * math.abs(get(yoke_heading_ratio))
		if math.abs(get(nw_strg)) > 13 then
			local steer_dir = 1 --steering vector for the main wheels
			if get(nw_strg) < 0 then
				steer_dir = -1
			end
			w_tgt = steer_dir * (steer_dir * Round(get(yoke_heading_ratio), 3) - 0.185) / 0.815 * 14
		end
	end
	l_all = l_all + 0.05 * (w_tgt / 14)
	set(h_load, l_all)
	set(r_w_strg, get(r_w_strg) + (w_tgt - get(r_w_strg)) * r_time * get(f_time))
	set(l_w_strg, get(l_w_strg) + (w_tgt - get(l_w_strg)) * r_time * get(f_time))
end

function MoveGear(interruptions, tgt)
	local int_dist = Round(1/interruptions, 2)
	local gear_time = 0.1
	for i=2,3 do
		local gear_actual = globalPropertyfae("sim/aircraft/parts/acf_gear_deploy", i)
		if get(gear_actual) ~= tgt then
			if get(gear_actual) % int_dist <= 0.06 then
				gear_time = 0.0001
			else
				gear_time = 0.1
			end
			set(get(gear_actual) + (tgt - get(gear_actual)) * get(f_time) * gear_time)
		end
	end
end

function update()
	--UpdateActPress()
	--UpdateGearPos()
	--Smoooth()
	UpdateGearStrg(0.8)
	MoveGear(5, get(gear_handle))
end
