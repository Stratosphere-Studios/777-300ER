--[[
*****************************************************************************************
* Script Name: lights
* Author Name: discord/bruh4096#4512(Tim G.)
* Script Description: Code for cockpit lights.
*****************************************************************************************
--]]

include("misc_tools.lua")
include("constants.lua")

--Light datarefs:

--ND

--mag_hdg_light = createGlobalPropertyi("Strato/777/cockpit/lights/mag_hdg", 0)

--FBW:

pfc_disc_light = globalPropertyi("Strato/777/cockpit/lights/pfc_disc")

--Hydraulics:

light_primary = globalProperty("Strato/777/hydraulics/pump/primary/fault")
light_demand = globalProperty("Strato/777/hydraulics/pump/demand/fault")

--Cabin lights:
lt_cab_ps = globalPropertyi("Strato/777/cabin/lights/pass_sgn")
lt_cab_ns = globalPropertyi("Strato/777/cabin/lights/no_smok")

--System datarefs:

--ND
--mag_hdg = globalPropertyi("Strato/777/cockpit/switches/mag_hdg")

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
--Cabin lights switches:
pass_sgn = globalPropertyi("Strato/777/overhead/pass_sgn")
no_smok = globalPropertyi("Strato/777/overhead/no_smok")
--Indicators:
alt_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/altitude_ft_pilot")
alt_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/altitude_ft_copilot")
--Flaps switches:
flap_handle = globalPropertyf("sim/cockpit2/controls/flap_ratio")
--Gear:
gear_pos_actual = globalProperty("sim/aircraft/parts/acf_gear_deploy")

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

function GetCabinLtStat(sw_cr, alt, gear_out, flap_hdl_pos)
	if sw_cr == PASS_SGN_ON then
		return 1
	elseif sw_cr == PASS_SGN_AUTO then
		if gear_out == 1 or alt <= PASS_AUTO_BARO_THR_FT or flap_hdl_pos > PASS_AUTO_FLP_HDL_THR then
			return 1
		end
	end
	return 0
end

function UpdateCabinLights()
	local avg_alt = (get(alt_pilot)+get(alt_copilot))/2
	local gear_out = 0
	local flap_hdl_pos = get(flap_handle)
	for i=1,3 do
		if get(gear_pos_actual, i) > PASS_AUTO_GEAR_THR then
			gear_out = 1
		end
	end
	local pass_sw = get(pass_sgn)
	local no_sm_sw = get(no_smok)
	set(lt_cab_ps, GetCabinLtStat(pass_sw, avg_alt, gear_out, flap_hdl_pos))
	set(lt_cab_ns, GetCabinLtStat(no_sm_sw, avg_alt, gear_out, flap_hdl_pos))
end

function update()
	--set(mag_hdg_light, 1 - get(mag_hdg))
    set(pfc_disc_light, get(pfc_disc))
    UpdateHydLights()
	UpdateCabinLights()
end