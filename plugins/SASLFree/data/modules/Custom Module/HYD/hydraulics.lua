--[[
*****************************************************************************************
* Script Name: Hydraulic
* Author Name: @bruh
* Script Description: Code for Hydraulic systems. P.S. code for flight controls will be ported over to xtlua soon™
*****************************************************************************************
--]]

addSearchPath(moduleDirectory .. "/Custom Module/HYD/graphics")
addSearchPath(moduleDirectory .. "/Custom Module/")

include("misc_tools.lua")

--finding sim datarefs

battery = globalPropertyiae("sim/cockpit2/electrical/battery_on", 1)
gen_1 = globalPropertyiae("sim/cockpit2/electrical/generator_on", 1)
gen_2 = globalPropertyiae("sim/cockpit2/electrical/generator_on", 2)
on_ground = globalPropertyi("sim/flightmodel/failures/onground_any")
tas = globalPropertyf("sim/flightmodel/position/true_airspeed") --true airspeed in meters per second. Needed for accurate drooping
engine_1_n2 = globalPropertyfae("sim/flightmodel/engine/ENGN_N2_", 1)
engine_2_n2 = globalPropertyfae("sim/flightmodel/engine/ENGN_N2_", 2)

--creating datarefs

hyd_qty = createGlobalPropertyfa("Strato/777/hydraulics/qty", {0.98, 0.95, 0.97})
hyd_pressure = createGlobalPropertyia("Strato/777/hydraulics/press", {50, 50, 50}) --this dataref is shared bc we need it to be readable from xtlua smh
demand_pumps_state = createGlobalPropertyia("Strato/777/hydraulics/pump/demand/state", {0, 0, 0, 0})
demand_pumps_past = createGlobalPropertyia("Strato/777/hydraulics/pump/demand/past", {0, 0, 0, 0}) --this is needed for accurate schematic update on the hydraulic page of eicas since it happens with a 2/3 second delay irl
--demand_pumps_lf = createGlobalPropertyfa("777/hydraulics/pump/demand/rpm", {0, 0, 0, 0}) --load factor of demand pumps
primary_pumps_state = createGlobalPropertyia("Strato/777/hydraulics/pump/primary/state", {1, 0, 0, 1})
primary_pumps_past = createGlobalPropertyia("Strato/777/hydraulics/pump/primary/past", {0, 0, 0, 0})
--primary_pumps_lf = createGlobalPropertyfa("777/hydraulics/pump/primary/rpm", {0, 0, 0, 0})

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

tmp = Round(sasl.getElapsedSeconds(timer), 1)
t = tmp

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
	if IsAcConnected() == 1 then
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
					if get(globalPropertyiae("Strato/777/hydraulics/pump/demand/state", 2)) == 2 or get(globalPropertyiae("Strato/777/hydraulics/pump/demand/state", 2)) == 1 and GetFltState() == 0 then
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
		if IsAcConnected() == 1 and get(pump_state) == 1 then
			return 1
		end
	elseif idx == 3 then 
		if get(globalPropertyi("sim/flightmodel/failures/onground_any")) == 1 and get(pump_state) == 1 then
			if get(engine_1_n2) < 68 and get(engine_2_n2) < 68 then
				if get(apu_running) == 1 and IsAcConnected() == 1 then
					return 1
				end
			elseif get(engine_1_n2) > 68 and get(engine_2_n2) > 68 and IsAcConnected() == 1 then
				return 1
			end
		elseif get(on_ground) == 0 and get(engine_1_n2) > 68 and get(engine_2_n2) > 68 and get(pump_state) == 1 then
			if get(globalPropertyiae("Strato/777/hydraulics/pump/primary/state", 2)) == 0 or GetDemandPumpState(1) == 0 or GetDemandPumpState(4) == 0 then
				if IsAcConnected() == 1 then
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
	--print(IsAcConnected())
	UpdatePressure(0.5)
end

function onAirportLoaded() --set all the pressures and pumps to normal if engines are running
	local mixture = globalPropertyf("sim/cockpit2/engine/actuators/mixture_ratio_all")
	if get(mixture) == 1 then
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
	if get(battery) == 1 or IsAcConnected == 1 then
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