--[[
*****************************************************************************************
* Script Name: eicas_graphics
* Author Name: @bruh
* Script Description: Code for lower eicas graphics.
*****************************************************************************************
--]]

addSearchPath(moduleDirectory .. "/Custom Module/")
addSearchPath(moduleDirectory .. "/Custom Module/EICAS/LOWER/graphics")

include("misc_tools.lua")

--Finding simulator and own datarefs

battery = globalPropertyiae("sim/cockpit2/electrical/battery_on", 1)

c_time = globalPropertyf("Strato/777/time/current")
brake_acc_in_use = globalPropertyi("Strato/777/gear/brake_acc_in_use")
eicas_power_lower = globalPropertyi("Strato/777/elec/eicas_power_lower")

--Creating our own

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

t = 0 --For updating hydraulic pressure

--Generic

white = {1, 1, 1}
amber = {1, 0.741, 0.161}
green = {0, 1, 0}

--Hydraulics

pri_time = {-3, -3, -3, -3}
pri_set = {1, 1, 1, 1}
dem_time = {-3, -3, -3, -3}
dem_set = {1, 1, 1, 1}

--coordinates of the upper left corner of the rectangle for each pump
primary_coords = {40, 846, 418, 900, 821, 900, 1251, 846}
demand_coords = {200, 562, 564, 603, 667, 603, 1090, 562}
ovht_p = {185, 815, 555, 870, 760, 870, 1180, 815} --coordinates for the overheat message for each pump
ovht_d = {130, 460, 510, 505, 805, 505, 1235, 460}

--Gear

brake_pos = {216, 805, 460, 890, 1134}

door_s_pos = {568, 920, 230, 205, 903, 205}

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
		local primary_state = globalPropertyiae("Strato/777/hydraulics/pump/primary/actual", i)
		local demand_state = globalPropertyiae("Strato/777/hydraulics/pump/demand/actual", i)
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
					if get(demand_past) <= 0 then
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
					if get(demand_past) <= 0 then
						DrawArrowEICAS(sys_idx)
					end
				end
			elseif i == 3 then
				if get(demand_past) == 1 then
					local demand_2 = globalPropertyiae("Strato/777/hydraulics/pump/demand/past", 2)
					sasl.gl.drawTexture(line_dc2, 694, 330, 80, 640, {0, 1, 0})
					if get(demand_2) <= 0 then --this is done to prevent one arrow from being drawn multiple times
						DrawArrowEICAS(sys_idx)
					end
				end
				if get(primary_past) == 1 then
					local primary_2 = globalPropertyiae("Strato/777/hydraulics/pump/primary/past", 2)
					sasl.gl.drawTexture(line_pc2, 753, 329, 112, 640, {0, 1, 0})
					if get(demand_past) <= 0 and get(primary_2) <= 0 then
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
					if get(demand_past) <= 0 then
						DrawArrowEICAS(sys_idx)
					end
				end
			end
		end
		if get(demand_state) ~= get(demand_past) then
			if dem_set[i] == 0 then
				dem_time[i] = get(c_time)
				dem_set[i] = 1
			end
			if get(c_time) >= dem_time[i] + 3 then
				set(demand_past, get(demand_state))
			end
		else
			dem_set[i] = 0
		end
		if get(primary_state) ~= get(primary_past) then
			if pri_set[i] == 0 then
				pri_time[i] = get(c_time)
				pri_set[i] = 1
			end
			if get(c_time) >= pri_time[i] + 3 then
				set(primary_past, get(primary_state))
			end
		else
			pri_set[i] = 0
		end
	end
end

function DrawBrakes()   
	local max_temp_L = globalPropertyf("Strato/777/gear/truck_L_max")
	local max_temp_R = globalPropertyf("Strato/777/gear/truck_R_max")
	--Drawing PSI of front tires
	drawText(font, 615, 1130, 202, 38, false, false, TEXT_ALIGN_CENTER, white)
	drawText(font, 750, 1130, 200, 38, false, false, TEXT_ALIGN_CENTER, white)
	for i=1,3 do
		--brake temperature colors
		local temp_color_L = white
		local temp_color_R = white
		--tire psi colors
		local psi_color_L = white
		local psi_color_LL = white
		local psi_color_R = white
		local psi_color_RR = white 
		--Brake temperatures
		local truck_t_L = globalPropertyfae("Strato/777/gear/truck_L_temp", i)
		local truck_t_R = globalPropertyfae("Strato/777/gear/truck_R_temp", i)
		--Tire pressure
		local psi_L = globalPropertyfae("Strato/777/gear/truck_L_psi", i)
		local psi_LL = globalPropertyfae("Strato/777/gear/truck_L_psi", i + 3)
		local psi_R = globalPropertyfae("Strato/777/gear/truck_R_psi", i)
		local psi_RR = globalPropertyfae("Strato/777/gear/truck_R_psi", i + 3)
		local output_L = Round(get(truck_t_L) * 0.0101 - 0.5051, 1)
		--Modifying output temperature
		if output_L >= 5 then
			temp_color_L = amber
		end
		if output_L < 0 then
			output_L = 0
		elseif output_L > 9.9 then
			output_L = 9.9
		end
		local draw_temp_L = output_L
		local output_R = Round(get(truck_t_R) * 0.0101 - 0.5051, 1)
		if output_R >= 5 then
			temp_color_R = amber
		end
		if output_R < 0 then
			output_R = 0
		elseif output_R > 9.9 then
			output_R = 9.9
		end
		local draw_temp_R = output_R
		if output_L % 1 == 0 then
			draw_temp_L = tostring(output_L) .. ".0"
		end
		if output_R % 1 == 0 then
			draw_temp_R = tostring(output_R) .. ".0"
		end
		--Configuring psi that we'll draw
		if get(psi_L) < 100 then
			psi_color_L = amber
		end
		if get(psi_LL) < 100 then
			psi_color_LL = amber
		end
		if get(psi_R) < 100 then
			psi_color_R = amber
		end
		if get(psi_RR) < 100 then
			psi_color_RR = amber
		end
		--Draw tire PSI
		drawText(font, brake_pos[1] + 61, brake_pos[2] + 22 - 196 * (i - 1), round(get(psi_L)), 38, false, false, TEXT_ALIGN_CENTER, psi_color_L)
		drawText(font, brake_pos[3] - 45, brake_pos[2] + 22 - 196 * (i - 1), round(get(psi_LL)), 38, false, false, TEXT_ALIGN_CENTER, psi_color_LL)
		drawText(font, brake_pos[4] + 61, brake_pos[2] + 22 - 196 * (i - 1), round(get(psi_R)), 38, false, false, TEXT_ALIGN_CENTER, psi_color_R)
		drawText(font, brake_pos[5] - 45, brake_pos[2] + 22 - 196 * (i - 1), round(get(psi_RR)), 38, false, false, TEXT_ALIGN_CENTER, psi_color_RR)
		--Draw brake temperatures
		drawText(font, brake_pos[1] - 13, brake_pos[2] - 196 * (i - 1), draw_temp_L, 38, false, false, TEXT_ALIGN_RIGHT, temp_color_L)
		drawText(font, brake_pos[3] + 89, brake_pos[2] - 196 * (i - 1), draw_temp_L, 38, false, false, TEXT_ALIGN_RIGHT, temp_color_L)
		drawText(font, brake_pos[4] - 13, brake_pos[2] - 196 * (i - 1), draw_temp_R, 38, false, false, TEXT_ALIGN_RIGHT, temp_color_R)
		drawText(font, brake_pos[5] + 89, brake_pos[2] - 196 * (i - 1), draw_temp_R, 38, false, false, TEXT_ALIGN_RIGHT, temp_color_R)
		if i == 3 and get(brake_acc_in_use) == 1 then
			drawText(font, brake_pos[1] - 13, brake_pos[2] - 196 * (i - 1) + 46, "ASKID", 38, false, false, TEXT_ALIGN_RIGHT, amber)
			drawText(font, brake_pos[3] + 124, brake_pos[2] - 196 * (i - 1) + 46, "ASKID", 38, false, false, TEXT_ALIGN_RIGHT, amber)
			drawText(font, brake_pos[4] - 13, brake_pos[2] - 196 * (i - 1) + 46, "ASKID", 38, false, false, TEXT_ALIGN_RIGHT, amber)
			drawText(font, brake_pos[5] + 124, brake_pos[2] - 196 * (i - 1) + 46, "ASKID", 38, false, false, TEXT_ALIGN_RIGHT, amber)
		end
		if output_L < 5 and get(truck_t_L) ~= get(max_temp_L) or output_L < 3 then
			DrawRect(brake_pos[1], brake_pos[2] - 196 * (i - 1), 15, 77, 3, white, true)
			DrawRect(brake_pos[3], brake_pos[2] - 196 * (i - 1), 15, 77, 3, white, true)
		elseif output_L < 5 and get(truck_t_L) == get(max_temp_L) and output_L > 2.9 then
			sasl.gl.drawRectangle(brake_pos[1], brake_pos[2] - 196 * (i - 1), 15, 77, white)
			sasl.gl.drawRectangle(brake_pos[3], brake_pos[2] - 196 * (i - 1), 15, 77, white)
		else
			sasl.gl.drawRectangle(brake_pos[1], brake_pos[2] - 196 * (i - 1), 15, 77, amber)
			sasl.gl.drawRectangle(brake_pos[3], brake_pos[2] - 196 * (i - 1), 15, 77, amber)
		end
		if output_R < 5 and get(truck_t_R) ~= get(max_temp_R) or output_R < 3 then
			DrawRect(brake_pos[4], brake_pos[2] - 196 * (i - 1), 15, 77, 3, white, true)
			DrawRect(brake_pos[5], brake_pos[2] - 196 * (i - 1), 15, 77, 3, white, true)
		elseif output_R < 5 and get(truck_t_R) == get(max_temp_R) and output_R > 2.9 then
			sasl.gl.drawRectangle(brake_pos[4], brake_pos[2] - 196 * (i - 1), 15, 77, white)
			sasl.gl.drawRectangle(brake_pos[5], brake_pos[2] - 196 * (i - 1), 15, 77, white)
		else                                                 
			sasl.gl.drawRectangle(brake_pos[4], brake_pos[2] - 196 * (i - 1), 15, 77, amber)
			sasl.gl.drawRectangle(brake_pos[5], brake_pos[2] - 196 * (i - 1), 15, 77, amber)
		end
	end
end

function DrawDoorStatus()
	for i=1,6,2 do
		DrawRect(door_s_pos[i], door_s_pos[i+1], 230, 80, 4, white, true)
		local door_pos = globalPropertyfae("Strato/777/gear/doors", 1 + (i + 1) / 2)
		if get(door_pos) == 0 then
			drawText(font, door_s_pos[i] + 115, door_s_pos[i+1] + 20, "CLOSED", 60, false, false, TEXT_ALIGN_CENTER, white)
		else
			Stripify(door_s_pos[i], door_s_pos[i+1], 230, 80, 11, 4, white)
		end
	end
end

function draw()
	if get(eicas_power_lower) == 1 then
		local eicas_mode = globalPropertyi("Strato/777/displays/eicas_mode")
		if get(eicas_mode) == 8 then 
			--drawing the valves. For now they are just static
			sasl.gl.drawTexture(valve_open, 41, 374, 68, 68, {0, 1, 0})
			sasl.gl.drawTexture(valve_open, 1255, 374, 68, 68, {0, 1, 0})
			sasl.gl.drawRotatedTexture(valve_open, 90, 491, 930, 68, 68, {0, 1, 0})
			sasl.gl.drawRotatedTexture(valve_open, 90, 341, 930, 68, 68, {0, 1, 0})
			--Drawing pressure and quantity
			for i=1,3 do
				local color = white 
				local pressure = globalPropertyiae("Strato/777/hydraulics/press", i)
				local quantity = globalPropertyfae("Strato/777/hydraulics/qty", i)
				if get(pressure) < 1200 then
					color = amber
				else
					color = white
				end
				local qty = Round(get(quantity), 2)
				local qty_displayed = tostring(qty)
				if qty % 1 == 0 then
					qty_displayed = qty_displayed .. ".00"
				elseif qty % 0.1 == 0 then
					qty_displayed = qty_displayed .. "0"
				end
				drawText(font, 113 + 527 * (i - 1), 256, qty_displayed, 45, false, false, TEXT_ALIGN_LEFT, white)
				--Making pressure output rounded.
				drawText(font, 150 + 527 * (i - 1), 140, tostring(round(get(pressure) * 0.1) * 10), 45, false, false, TEXT_ALIGN_CENTER, color)
			end
			for i=1,4 do
				local primary_pump_ovht = globalPropertyfae("Strato/777/hydraulics/pump/primary/ovht", i)
				local demand_pump_ovht = globalPropertyfae("Strato/777/hydraulics/pump/demand/ovht", i)
				local primary_state = globalPropertyiae("Strato/777/hydraulics/pump/primary/actual", i)
				local demand_state = globalPropertyiae("Strato/777/hydraulics/pump/demand/actual", i)
				local sys_idx = GetSysIdx(i)
				if get(primary_state) == 1 then
					DrawRect(primary_coords[1 + 2 * (i - 1)], primary_coords[2 + 2 * (i - 1)], 74, 99, 7, green, false)
				elseif get(primary_state) == -1 then --Draw crossed rectangle if pump is inop
					DrawCrossedRect(primary_coords[1 + 2 * (i - 1)], primary_coords[2 + 2 * (i - 1)], 74, 99, 7, amber)
				end
				if get(demand_state) == 1 then
					DrawRect(demand_coords[1 + 2 * (i - 1)], demand_coords[2 + 2 * (i - 1)], 74, 99, 7, green, false)
				elseif get(demand_state) == -1 then --Draw crossed rectangle if pump is inop
					DrawCrossedRect(demand_coords[1 + 2 * (i - 1)], demand_coords[2 + 2 * (i - 1)], 74, 99, 7, amber)	
				end
				if get(demand_pump_ovht) == 1 then
					drawText(font, ovht_d[1 + 2 * (i - 1)], ovht_d[2 + 2 * (i - 1)], "OVHT", 38, false, false, TEXT_ALIGN_CENTER, amber)
				end
				if get(primary_pump_ovht) == 1 then
					drawText(font, ovht_p[1 + 2 * (i - 1)], ovht_p[2 + 2 * (i - 1)], "OVHT", 38, false, false, TEXT_ALIGN_CENTER, amber)
				end
			end
			DrawLinesEICAS()
		elseif get(eicas_mode) == 7 then --Updating gear synoptic page
			DrawBrakes()
			DrawDoorStatus()
		end
	end
end