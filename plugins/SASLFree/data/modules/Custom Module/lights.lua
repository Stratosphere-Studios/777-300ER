--[[
*****************************************************************************************
* Script Name: lights
* Author Name: @bruh
* Script Description: Code for cockpit lights.
*****************************************************************************************
--]]

include("misc_tools.lua")

--Light datarefs:

--FBW:

pfc_disc_light = globalPropertyi("Strato/777/cockpit/lights/pfc_disc")

--Hydraulics:

light_primary = globalProperty("Strato/777/hydraulics/pump/primary/fault")
light_demand = globalProperty("Strato/777/hydraulics/pump/demand/fault")

--System datarefs:

--FBW:

pfc_disc = globalPropertyi("Strato/777/fctl/pfc/disc")

--Hydraulics:

hyd_pressure = globalProperty("Strato/777/hydraulics/press")
--Primary pumps:
primary_switch = globalProperty("Strato/777/hydraulics/pump/primary/state")
primary_fail = globalProperty("Strato/777/hydraulics/pump/primary/fail") 
primary_temperature = globalProperty("Strato/777/hydraulics/pump/primary/ovht")
--Demand pumps:
demand_switch = globalProperty("Strato/777/hydraulics/pump/demand/state")
demand_fail = globalProperty("Strato/777/hydraulics/pump/demand/fail") 
demand_past = globalProperty("Strato/777/hydraulics/pump/demand/past")
demand_temperature = globalProperty("Strato/777/hydraulics/pump/demand/ovht")

--Time:

c_time = globalPropertyf("Strato/777/time/current")

--Global variables:

--Hydraulic light logic
--Primary pumps
primary_past  = {0, 0, 0, 0}
primary_shutdown = {0, 0, 0, 0}
primary_ovht = {0, 0, 0, 0}

--Demand pumps
demand_ovht = {0, 0, 0, 0}
demand_time = {0, 0, 0, 0}
demand_shutdown = {0, 0, 0, 0}
demand_was_working = {0, 0, 0, 0} --Was the demand pump working at time of shut down?

function UpdateHydLights()
	for i=1,4 do
        local s_idx = GetSysIdx(i)
		--Low pressure logic
		if get(primary_switch, i) ~= primary_past[i] then
			if get(primary_switch, i) == 0 then
				primary_shutdown[i] = get(c_time)
			end
			primary_past[i] = get(primary_switch, i)
		end
		--Overheat logic
		if get(primary_temperature, i) == 1 and primary_ovht[i] == 0 then
			primary_shutdown[i] = get(c_time)
			primary_ovht[i] = 1
		elseif get(primary_temperature, i) == 0 then
			primary_ovht[i] = 0
		end
		if get(primary_switch, i) == 0 and get(c_time) >= primary_shutdown[i] + 5 or 
           get(primary_fail, i) == 1 or get(hyd_pressure, s_idx) < 1200 then
			set(light_primary, 1, i)
		elseif get(c_time) >= primary_shutdown[i] + 5 and get(primary_temperature, i) == 1 then
			set(light_primary, 1, i)
		else
			set(light_primary, 0, i)
		end
		--Wait 5 seconds if a working demand pump was shut down
		if get(demand_past, i) == 1 and get(demand_switch, i) == 0 and demand_was_working[i] == 0 then
			demand_shutdown[i] = get(c_time)
			demand_was_working[i] = 1
		elseif get(demand_past, i) == 0 and get(demand_switch, i) == 0 and demand_was_working[i] == 0 then
			demand_shutdown[i] = get(c_time) - 5
		end
		--Demand pump overheat logic
		if get(demand_temperature, i) == 1 and demand_ovht[i] == 0 then
			demand_ovht[i] = 1
			demand_time[i] = get(c_time)
		elseif get(demand_temperature, i) == 0 then
			demand_ovht[i] = 0
		end
		if (get(c_time) >= demand_shutdown[i] + 5 and get(demand_switch, i) == 0) or 
           (get(c_time) >= demand_time[i] + 5 and demand_ovht[i] == 1) or 
           get(demand_fail, i) == 1 or get(hyd_pressure, s_idx) < 1200 then
			set(light_demand, 1, i)
		else
			set(light_demand, 0, i)
		end
	end
end

function update()
    set(pfc_disc_light, get(pfc_disc))
    UpdateHydLights()
end