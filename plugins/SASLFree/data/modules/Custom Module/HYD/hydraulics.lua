--[[
*****************************************************************************************
* Script Name: Hydraulic
* Author Name: @bruh
* Script Description: Code for Hydraulic systems
*****************************************************************************************
--]]

addSearchPath(moduleDirectory .. "/Custom Module/HYD/graphics")

--finding sim datarefs

battery = globalPropertyiae("sim/cockpit2/electrical/battery_on", 1)
gen_1 = globalPropertyiae("sim/cockpit2/electrical/generator_on", 1)
gen_2 = globalPropertyiae("sim/cockpit2/electrical/generator_on", 2)
fctl_ovrd = globalPropertyf("sim/operation/override/override_control_surfaces") --for overriding default xp11 flight controls
on_ground = globalPropertyi("sim/flightmodel/failures/onground_any")
outbd_ail_L = globalPropertyfae("sim/flightmodel2/wing/aileron1_deg", 1) --make separate datarefs for inboard and outboard ailerons
outbd_ail_R = globalPropertyfae("sim/flightmodel2/wing/aileron2_deg", 1)
spoilers_L = globalPropertyfae("sim/flightmodel2/wing/spoiler1_deg", 1)
spoilers_R = globalPropertyfae("sim/flightmodel2/wing/spoiler2_deg", 1)
flaps = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 1)
elevator = globalPropertyfae("sim/flightmodel2/wing/elevator1_deg",1)
yoke_roll_ratio = globalPropertyf("sim/cockpit2/controls/yoke_roll_ratio")
yoke_pitch_ratio = globalPropertyf("sim/cockpit2/controls/yoke_pitch_ratio")
tas = globalPropertyf("sim/flightmodel/position/true_airspeed") --true airspeed in meters per second. Needed for accurate drooping
engine_1_n2 = globalPropertyfae("sim/flightmodel/engine/ENGN_N2_", 1)
engine_2_n2 = globalPropertyfae("sim/flightmodel/engine/ENGN_N2_", 2)

--creating datarefs

hyd_qty = createGlobalPropertyfa("Strato/777/hydraulics/qty", {0.98, 0.95, 0.97})
hyd_pressure = createGlobalPropertyia("Strato/777/hydraulics/press", {50, 50, 50})
demand_pumps_state = createGlobalPropertyia("Strato/777/hydraulics/pump/demand/state", {0, 0, 0, 0})
demand_pumps_past = createGlobalPropertyia("Strato/777/hydraulics/pump/demand/past", {0, 0, 0, 0}) --this is needed for accurate schematic update on the hydraulic page of eicas since it happens with a 2/3 second delay irl
--demand_pumps_rpm = createGlobalPropertyia("777/hydraulics/pump/demand/rpm", {0, 0, 0, 0})
primary_pumps_state = createGlobalPropertyia("Strato/777/hydraulics/pump/primary/state", {1, 0, 0, 1})
primary_pumps_past = createGlobalPropertyia("Strato/777/hydraulics/pump/primary/past", {0, 0, 0, 0})
--primary_pumps_rpm = createGlobalPropertyia("777/hydraulics/pump/primary/rpm", {0, 0, 0, 0})
flap_tgt = createGlobalPropertyf("Strato/777/flaps/tgt", 0)
flap_load_relief = createGlobalPropertyi("Strato/777/flaps/load_relief", 0) --set to 1 when load relief system is operating

set(fctl_ovrd, 1)
timer = sasl.createTimer()
sasl.startTimer(timer)

--loading font and images for drawing on eicas
font = loadFont("BoeingFont.ttf")
line_L = loadImage("line_L.png")
arrow_LR = loadImage("arrow_LR.png")
arrow_center = loadImage("arrow_center.png")
line_dc1 = loadImage("line_dc1.png")
line_dc2 = loadImage("line_dc2.png")
line_pc1 = loadImage("line_pc1.png")
line_pc2 = loadImage("line_pc2.png")
valve_open = loadImage("valve_open.png")

function round(number) --rounds everything behind the decimal
	return math.floor(number+0.5)
end

function Round(num, dp) --rounds evcerything until a certain point
    local mult = 10^(dp or 0)
    return math.floor(num * mult + 0.5)/mult
end

tmp = Round(sasl.getElapsedSeconds(timer), 1)
t = tmp

function indexOf(array, value, round_)
	if round_ == 1 then
		value = Round(value, 2)
	end
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

function GetSysIdx(num) --matches pump index with system index
	if num == 1 then
		return 1
	elseif num == 4 then
		return 3
	else
		return 2
	end
end

function GetMaxHydPress() --since some things are driven by all 3 hydraulic systems, we need to know the maximum pressure
	local pressure_L = globalPropertyiae("Strato/777/hydraulics/press", 1)
	local pressure_C = globalPropertyiae("Strato/777/hydraulics/press", 2)
	local pressure_R = globalPropertyiae("Strato/777/hydraulics/press", 3)
	return math.max(get(pressure_L), get(pressure_C), get(pressure_R))
end

function GetFltState() --this is needed for demand pump activation during takeoff/landing/ 
	local gear_pos = globalPropertyi("sim/cockpit2/controls/gear_handle_down")
	local flap_pos = globalPropertyf("sim/cockpit2/controls/flap_ratio")
	local throttle_pos = globalPropertyf("sim/cockpit2/engine/actuators/throttle_ratio_all")
	if get(gear_pos) == 1 and get(flap_pos) < 0.8 and get(throttle_pos) >= 0.6 and get(flap_pos) > 0 then
		return 1
	elseif get(gear_pos) == 1 and get(flap_pos) >= 0.5 and get(on_ground) == 0 then
		return 2
	else
		return 0
	end
end

function GetDemandPumpState(idx, primary_state)
	if get(gen_1) == 1 or get(gen_2) == 1 then
		local demand_state = globalPropertyiae("Strato/777/hydraulics/pump/demand/state", idx)
		if get(demand_state) == 2 then --if the pump is on, it's on
			if idx ~= 3 then 
				return 1
			else
				local demand_2 = globalPropertyiae("Strato/777/hydraulics/pump/demand/state", 2)
				if get(demand_2) == 2 then
					return 0
				else
					return 1
				end
			end
		elseif get(demand_state) == 1 then
			local sys_idx = GetSysIdx(idx)
			local pressure = globalPropertyiae("Strato/777/hydraulics/press", sys_idx)
			if get(pressure) < 2700 or GetFltState() ~= 0 or primary_state == 0 then --if the pump is in auto, turn it on only if the plane is landing/taking off or if there isn't enough pressure
				if idx ~= 3 then
					return 1
				else
					if get(globalPropertyiae("Strato/777/hydraulics/pump/demand/state", 2)) == 2 or get(globalPropertyiae("777/hydraulics/pump/demand/state", 2)) == 1 and GetFltState() == 0 then
						return 0
					else
						return 1
					end
				end
			else
				return 0
			end
		else
			return 0
		end
	else
		return 0
	end
end

function GetPrimaryPumpState(idx) --this function defines primary pump logic.
	local pump_state = globalPropertyiae("Strato/777/hydraulics/pump/primary/state", idx)
	local apu_running = globalPropertyi("sim/cockpit2/electrical/APU_running")
	if idx == 1 then
		if get(pump_state) == 1 and get(engine_1_n2) >= 50 then
			return 1
		end
	elseif idx == 2 then
		if get(gen_1) == 1 and get(pump_state) == 1 or get(gen_2) == 1 and get(pump_state) == 1 then
			return 1
		end
	elseif idx == 3 then 
		if get(globalPropertyi("sim/flightmodel/failures/onground_any")) == 1 and get(pump_state) == 1 then
			if get(engine_1_n2) < 68 and get(engine_2_n2) < 68 then
				if get(apu_running) == 1 and get(gen_1) == 1 or get(gen_2) == 1 and get(apu_running) == 1 then
					return 1
				end
			elseif get(engine_1_n2) > 68 and get(engine_2_n2) > 68 and get(gen_1) == 1 and get(gen_2) == 1 then
				return 1
			end
		elseif get(on_ground) == 0 and get(engine_1_n2) > 68 and get(engine_2_n2) > 68 and get(pump_state) == 1 then
			if get(globalPropertyiae("Strato/777/hydraulics/pump/primary/state", 2)) == 0 or GetDemandPumpState(1) == 0 or GetDemandPumpState(4) == 0 then
				if get(gen_1) == 1 and get(gen_2) == 1 then
					return 1
				end
			end
		end
	else
		if get(pump_state) == 1 and get(engine_2_n2) >= 50 then
			return 1
		end
	end
	return 0
end

function UpdatePressure(delay) --Updates hydraulic pressure based on quantity, working pumps, etc
	for i=1,4,1 do
		local increase = 0
		local pumps_on = 0
		local primary_state = GetPrimaryPumpState(i)
		local demand_state = GetDemandPumpState(i, primary_state)
		local sys_idx = GetSysIdx(i)
		local pressure = globalPropertyiae("Strato/777/hydraulics/press", sys_idx)
		local quantity = globalPropertyfae("Strato/777/hydraulics/qty", sys_idx)
		if get(pressure) < 2700 then
			increase = 80
		else
			increase = 20
		end
		if demand_state == 1 or primary_state == 1 then
			if demand_state == 1 and primary_state == 1 then --the more pumps working per system, the faster the pressure will change
				pumps_on = 2
			else
				pumps_on = 1
			end
			local desired_pressure = (3000 + 200 * (pumps_on - 1)) * round(get(quantity))
			if get(pressure) < desired_pressure then
				if Round(sasl.getElapsedSeconds(timer), 1) == tmp + delay then
					if round(get(pressure)+increase*pumps_on) <= desired_pressure then
						set(pressure, get(pressure)+increase*pumps_on)
					else
						set(pressure, desired_pressure)
					end
				end
			else
				if Round(sasl.getElapsedSeconds(timer), 1) == tmp + delay then
					if get(pressure) - 15 >= desired_pressure then
						set(pressure, get(pressure)-15)
					else
						set(pressure, desired_pressure)
					end
				end
			end
		else
			local desired_pressure = 50 * round(get(quantity)) --default pressure is 50 psi unless more than half of the fluid leaks out
			if get(pressure) > desired_pressure and tmp + delay == Round(sasl.getElapsedSeconds(timer), 1) then
				if i == 1 or i == 4 then
					if get(pressure)-95 >= desired_pressure then
						set(pressure, get(pressure)-95)
					else
						set(pressure, desired_pressure)
					end
				elseif i == 2 then
					local primary_state_3 = GetPrimaryPumpState(3)
					local demand_state_3 = GetDemandPumpState(3, primary_state_3)
					if demand_state_3 == 0 and primary_state_3 == 0 then
						if get(pressure)-95 >= desired_pressure then
							set(pressure, get(pressure)-95)
						else
							set(pressure, desired_pressure)
						end
					end
				else
					local primary_state_2 = GetPrimaryPumpState(2)
					local demand_state_2 = GetDemandPumpState(2, primary_state_2)
					if demand_state_2 == 0 and primary_state_2 == 0 then
						if get(pressure)-95 >= desired_pressure then
							set(pressure, get(pressure)-95)
						else
							set(pressure, desired_pressure)
						end
					end
				end
			end
		end
	end
	if tmp + delay == Round(sasl.getElapsedSeconds(timer), 1) then
		tmp = tmp + delay
	end
end

function GetAilRatio(ratio) --Aileron ratio gets smaller with hydraulic pressure. This is needed for morer precise simulation when the pressure is low.
	local max_press = GetMaxHydPress()
	if max_press <= 500 then
		return 0
	elseif max_press >= 2500 then
		return ratio
	else
		return ratio * (max_press - 500) / 2000
	end
end

function GetAilNeutral(side, ratio)
	if get(tas) < 25.7 and GetMaxHydPress() < 2500 then
		return side * (-(ratio * get(tas) / 51.4) + 18 - ratio / 2)
	else
		return 0
	end
end

function GetAilResponseTime() --aileron response time based on pressure
	local pressure = GetMaxHydPress()
	if pressure > 2000 then
		return pressure * 7 / 3200
	else
		return 1
	end
end

function GetSpoilerTarget(side, yoke_cmd) --behavior for spoilers
	local actual = 0
	if side == -1 then
		actual = get(spoilers_L)
	else
		actual = get(spoilers_R)
	end
	local handle_pos = globalPropertyf("sim/cockpit2/controls/speedbrake_ratio")
	local true_airspeed = get(tas)
	local max_press = GetMaxHydPress()
	local neutral = 0
	if get(handle_pos) > 0 and max_press >= 570 then
		neutral = get(handle_pos) * 20
	elseif max_press < 570 then
		if true_airspeed >= 61 then
			neutral = 0
		elseif true_airspeed < 51 and true_airspeed >= 41 then --this is for transition when the airflow becomes fast enough to move spoilers
			neutral = actual * math.abs(61 - true_airspeed) / 20
		else
			neutral = actual
		end
	end
	if yoke_cmd * side > 0.4 and max_press >= 570 and true_airspeed < 430 then
		return neutral + ((yoke_cmd * side - 0.4) / 0.6) * (20 - neutral)
	else
		return neutral
	end
end

function GetSpoilerResponseTime()
	local pressure = GetMaxHydPress()
	local speed = get(tas)
	if pressure > 2000 and speed < 149 then
		return pressure * 7 / 3200
	elseif pressure >= 570 and pressure <= 2000 then
		return pressure * 2 / 3200
	else
		return 1
	end
end

function GetFlapTarget()
	flap_settings = {0, 1, 5, 15, 20, 25, 30}
	detents = {0, 0.17, 0.33, 0.5, 0.67, 0.83, 1}
	tas_limits = {-1, 136, 126, 118, 115, 102, 93} --limits in meters per second for load relief system
	local sys_C_press = globalPropertyiae("Strato/777/hydraulics/press", 2)
	if get(sys_C_press) >= 1000 then
		local handle_pos = globalPropertyf("sim/cockpit2/controls/flap_ratio")
		local flap_pos = get(flaps)
		local index = indexOf(detents, get(handle_pos), 1)
		if index ~= nil then
			if get(tas) > tas_limits[index] and tas_limits[index] ~= -1 then --load relief system only triggers with flaps 15 or below
				if get(flap_load_relief) ~= 1 then
					set(flap_load_relief, 1)
				end
				if get(flap_pos) > 5 then
					for i = index,3,-1 do
						if tas_limits[i] > get(tas) or i == 3 then --load relief retraction is limited to flap 5 idk why but the fcom says it
							set(flap_tgt, flap_settings[i])
							break
						end
					end
				end
			else
				if get(flap_load_relief) ~= 0 then
					set(flap_load_relief, 0)
				end
				set(flap_tgt, flap_settings[index])
			end
		else
			set(flap_tgt, get(flaps))
		end
	else
		set(flap_tgt, get(flaps))
	end
end

function GetFlapResponseTime()
	flap_settings = {0, 1, 5, 15, 20, 25, 30}
	local target = get(flap_tgt)
	local actual = get(flaps)
	local sys_C_press = globalPropertyiae("Strato/777/hydraulics/press", 2)
	if target ~= actual then
		if math.abs(target-actual) < 0.1 then
			return 30
		else
			return 1 * (get(sys_C_press) / 3200) / math.abs(target - actual)
		end
	else
		return 1
	end
end

function UpdateElevator(value)
	for i=1,10 do
		local elev = globalPropertyfae("sim/flightmodel2/wing/elevator1_deg", i)
		set(elev, value)
	end
end

function UpdateAileron(value, side)
	local ail = globalPropertyfae("sim/flightmodel2/wing/aileron1_deg", 1)
	for i=1,10 do
		if side == -1 then
			ail = globalPropertyfae("sim/flightmodel2/wing/aileron1_deg", i)
		else
			ail = globalPropertyfae("sim/flightmodel2/wing/aileron2_deg", i)
		end
		if i % 2 ~= 0 then
			set(ail, value)
		else
			set(ail, -value)
		end
	end
end

function UpdateFlaps(value)
	for i=1,10 do
		local flap = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", i)
		set(flap, value)
	end
end

function DrawRect(x, y, width, height, thickness, color)
	sasl.gl.drawWideLine(x, y, x + width, y, thickness, color)
	sasl.gl.drawWideLine(x + width, y, x + width, y - height, thickness, color)
	sasl.gl.drawWideLine(x + width, y - height, x, y - height, thickness, color)
	sasl.gl.drawWideLine(x, y - height, x, y, thickness, color)
end

function DrawArrowEICAS(idx) --draws arrow for each system on eicas hydraulic page
	if idx == 1 then
		sasl.gl.drawTexture(arrow_LR, 128, 966, 60, 133, {0, 1, 0})
	elseif idx == 2 then
		sasl.gl.drawTexture(arrow_center, 281, 937, 714, 160, {0, 1, 0})
	else
		sasl.gl.drawTexture(arrow_LR, 1178, 966, 60, 133, {0, 1, 0})
	end
end

function DrawLinesEICAS()
	for i=1,4 do
		local primary_state = GetPrimaryPumpState(i)
		local demand_state = GetDemandPumpState(i, primary_state)
		local demand_past = globalPropertyiae("Strato/777/hydraulics/pump/demand/past", i)
		local primary_past = globalPropertyiae("Strato/777/hydraulics/pump/primary/past", i)
		local sys_idx = GetSysIdx(i)
		if get(demand_past) == 1 or get(primary_past) == 1 then
			if i == 1 then
				if get(demand_past) == 1 then
					sasl.gl.drawTexture(line_L, 152, 330, 90, 643, {0, 1, 0})
					DrawArrowEICAS(sys_idx)
				end
				if get(primary_past) == 1 then --this is so that lines for both primary and demand pumps can be drawn at the same time
					sasl.gl.drawTexture(line_L, 157, 330, -90, 643, {0, 1, 0})
					if get(demand_past) == 0 then
						DrawArrowEICAS(sys_idx)
					end
				end
			elseif i == 2 then
				if get(demand_past) == 1 then
					sasl.gl.drawTexture(line_dc1, 591, 330, 180, 642, {0, 1, 0})
					DrawArrowEICAS(sys_idx)
				end
				if get(primary_past) == 1 then
					sasl.gl.drawTexture(line_pc1, 446, 328, 167, 643, {0, 1, 0})
					if get(demand_past) == 0 then
						DrawArrowEICAS(sys_idx)
					end
				end
			elseif i == 3 then
				if get(demand_past) == 1 then
					sasl.gl.drawTexture(line_dc2, 694, 330, 80, 640, {0, 1, 0})
					if get(globalPropertyiae("Strato/777/hydraulics/pump/demand/past", 2)) == 0 then --this is done to prevent one arrow from being drawn multiple times
						DrawArrowEICAS(sys_idx)
					end
				end
				if get(primary_past) == 1 then
					sasl.gl.drawTexture(line_pc2, 753, 329, 112, 640, {0, 1, 0})
					if get(demand_past) == 0 and get(globalPropertyiae("Strato/777/hydraulics/pump/primary/past", 2)) == 0 then
						DrawArrowEICAS(sys_idx)
					end
				end
			else
				if get(demand_past) == 1 then
					sasl.gl.drawTexture(line_L, 1209, 330, -90, 643, {0, 1, 0})
					DrawArrowEICAS(sys_idx)
				end
				if get(primary_past) == 1 then
					sasl.gl.drawTexture(line_L, 1205, 330, 90, 643, {0, 1, 0})
					if get(demand_past) == 0 then
						DrawArrowEICAS(sys_idx)
					end
				end
			end
		end
		if demand_state ~= get(demand_past) and round(sasl.getElapsedSeconds(timer)) == t + 2 then
			set(demand_past, demand_state)
		end
		if primary_state ~= get(primary_past) and round(sasl.getElapsedSeconds(timer)) == t + 2 then
			set(primary_past, primary_state)
		end
	end
	if round(sasl.getElapsedSeconds(timer)) >= t + 2 then
		t = round(sasl.getElapsedSeconds(timer))
	end
end

function update()
	UpdatePressure(0.5)
	local f_time = globalPropertyf("sim/operation/misc/frame_rate_period")
	local ail_ratio = GetAilRatio(36)
	local elevator_ratio = GetAilRatio(40)
	local c_L_ail_neutral = GetAilNeutral(-1, ail_ratio)
	local c_R_ail_neutral = GetAilNeutral(1, ail_ratio)
	local elevator_target = (elevator_ratio / 2) * get(yoke_pitch_ratio) * -1
	local L_ail_target = c_L_ail_neutral + (ail_ratio / 2) * get(yoke_roll_ratio)
	local R_ail_target = c_R_ail_neutral + (ail_ratio / 2) * get(yoke_roll_ratio)
	local ail_response_time = GetAilResponseTime()
	local spoiler_response_time = GetSpoilerResponseTime()
	local L_spoiler_target = GetSpoilerTarget(-1, get(yoke_roll_ratio))
	local R_spoiler_target = GetSpoilerTarget(1, get(yoke_roll_ratio))
	GetFlapTarget()
	local flap_time = GetFlapResponseTime()
	UpdateAileron(get(outbd_ail_L)+(L_ail_target - get(outbd_ail_L))*get(f_time)*ail_response_time, -1)
	UpdateAileron(get(outbd_ail_R)+(R_ail_target - get(outbd_ail_R))*get(f_time)*ail_response_time, 1)
	set(spoilers_L, get(spoilers_L)+(L_spoiler_target - get(spoilers_L))*get(f_time)*spoiler_response_time)
	set(spoilers_R, get(spoilers_R)+(R_spoiler_target - get(spoilers_R))*get(f_time)*spoiler_response_time)
	UpdateFlaps(get(flaps)+(get(flap_tgt) - get(flaps)) * get(f_time) * flap_time)
	UpdateElevator(get(elevator)+(elevator_target - get(elevator)) * get(f_time) * ail_response_time)
end

function onAirportLoaded() --set all the pressures and pumps to normal if engines are running
	local mixture = globalPropertyf("sim/cockpit2/engine/actuators/mixture_ratio_all")
	if get(engine_1_n2) > 68 and get(engine_2_n2) > 68 and get(mixture) == 1 then
		for i=1,4 do
			local demand = globalPropertyiae("Strato/777/hydraulics/pump/demand/state", i)
			local primary = globalPropertyiae("Strato/777/hydraulics/pump/primary/state", i)
			local sys_idx = GetSysIdx(i)
			local pressure = globalPropertyiae("Strato/777/hydraulics/press", sys_idx)
			set(pressure, 3000)
			set(demand, 1)
			set(primary, 1)
		end
	end
end

function draw()
	if get(battery) == 1 or get(gen_1) == 1 or get(gen_2) == 1 then
		local white = {1, 1, 1}
		local amber = {1, 0.49, 0.15}
		local green = {0, 1, 0}
		--coordinates of the upper left corner of the rectangle for each pump
		primary_coords = {40, 846, 418, 900, 821, 900, 1251, 846}
		demand_coords = {200, 562, 564, 603, 667, 603, 1090, 562}
		local eicas_mode = globalPropertyi("Strato/777/displays/eicas_mode")
		if get(eicas_mode) == 8 then 
			--drawing the valves. For now they are just static
			sasl.gl.drawTexture(valve_open, 41, 374, 68, 68, {0, 1, 0})
			sasl.gl.drawTexture(valve_open, 1255, 374, 68, 68, {0, 1, 0})
			sasl.gl.drawRotatedTexture(valve_open, 90, 491, 930, 68, 68, {0, 1, 0})
			sasl.gl.drawRotatedTexture(valve_open, 90, 341, 930, 68, 68, {0, 1, 0})
			for i=1,3 do
				local color = white 
				local pressure = globalPropertyiae("Strato/777/hydraulics/press", i)
				local quantity = globalPropertyfae("Strato/777/hydraulics/qty", i)
				if get(pressure) < 2500 then
					color = amber
				else
					color = white
				end
				drawText(font, 113 + 527 * (i - 1), 256, tostring(Round(get(quantity), 2)), 45, false, false, TEXT_ALIGN_LEFT, white)
				drawText(font, 150 + 527 * (i - 1), 140, tostring(get(pressure)), 45, false, false, TEXT_ALIGN_CENTER, color)
			end
			for i=1,4 do
				local primary_state = GetPrimaryPumpState(i)
				local demand_state = GetDemandPumpState(i, primary_state)
				if primary_state == 1 then
					DrawRect(primary_coords[1 + 2 * (i - 1)], primary_coords[2 + 2 * (i - 1)], 74, 99, 7, green)
				end
				if demand_state == 1 then
					DrawRect(demand_coords[1 + 2 * (i - 1)], demand_coords[2 + 2 * (i - 1)], 74, 99, 7, green)
				end
			end
			DrawLinesEICAS()
		end
	end
end

onAirportLoaded()

function onModuleDone()
	sasl.print("Shutting down")
	sasl.stopTimer(timer)
end