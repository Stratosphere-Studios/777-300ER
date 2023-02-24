--[[
*****************************************************************************************
* Script Name: fctl
* Author Name: @bruh
* Script Description: Code for flight controls.
*****************************************************************************************
--]]

addSearchPath(moduleDirectory .. "/Custom Module/")

include("misc_tools.lua")

--Finding sim datarefs

--Cockpit controls
speedbrake_handle = globalPropertyf("sim/cockpit2/controls/speedbrake_ratio")
yoke_roll_ratio = globalPropertyf("sim/cockpit2/controls/yoke_roll_ratio")
yoke_pitch_ratio = globalPropertyf("sim/cockpit2/controls/yoke_pitch_ratio")
yoke_heading_ratio = globalPropertyf("sim/cockpit2/controls/yoke_heading_ratio")
throttle_pos = globalPropertyf("sim/cockpit2/engine/actuators/throttle_jet_rev_ratio_all")
flap_handle = globalPropertyf("sim/cockpit2/controls/flap_ratio")
--Indicators
ra_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")
ra_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_copilot")
altitude_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/altitude_ft_pilot")
altitude_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/altitude_ft_copilot")
altitude_stdby = globalPropertyf("sim/cockpit2/gauges/indicators/altitude_ft_stby")
tas_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/true_airspeed_kts_pilot")
cas_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
tas_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/true_airspeed_kts_copilot")
cas_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_copilot")
--Weather and position
--Components of airspeed relative to l'avion.In SI units.
speed_x = globalPropertyf("sim/flightmodel/forces/vx_air_on_acf")
speed_y = globalPropertyf("sim/flightmodel/forces/vy_air_on_acf")
speed_z = globalPropertyf("sim/flightmodel/forces/vz_air_on_acf")
--Flight controls
outbd_ail_L = globalPropertyfae("sim/flightmodel2/wing/aileron2_deg", 5)
inbd_ail_L = globalPropertyfae("sim/flightmodel2/wing/aileron1_deg", 1)
outbd_ail_R = globalPropertyfae("sim/flightmodel2/wing/aileron2_deg", 6)
inbd_ail_R = globalPropertyfae("sim/flightmodel2/wing/aileron1_deg", 2)
spoiler_L1 = globalPropertyfae("sim/flightmodel2/wing/spoiler2_deg", 3)
spoiler_L2 = globalPropertyfae("sim/flightmodel2/wing/spoiler1_deg", 3)
spoiler_R1 = globalPropertyfae("sim/flightmodel2/wing/spoiler2_deg", 4)
spoiler_R2 = globalPropertyfae("sim/flightmodel2/wing/spoiler1_deg", 4)
flaps = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 2)
inbd_flap_L = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 1)
inbd_flap_R = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 2)
outbd_flap_L = globalPropertyfae("sim/flightmodel2/wing/flap2_deg", 3)
outbd_flap_R = globalPropertyfae("sim/flightmodel2/wing/flap2_deg", 4)
slat_1 = globalPropertyf("sim/flightmodel2/controls/slat1_deploy_ratio")
slat_2 = globalPropertyf("sim/flightmodel2/controls/slat2_deploy_ratio")
elevator_L = globalPropertyfae("sim/flightmodel2/wing/elevator1_deg",9)
elevator_R = globalPropertyfae("sim/flightmodel2/wing/elevator1_deg",10)
upper_rudder = globalPropertyfae("sim/flightmodel2/wing/rudder1_deg", 12)
bottom_rudder = globalPropertyfae("sim/flightmodel2/wing/rudder2_deg", 12)
--Reversers
L_reverser_deployed = globalPropertyiae("sim/cockpit2/annunciators/reverser_on", 1)
L_reverser_fail = globalPropertyi("sim/operation/failures/rel_revers0")
R_reverser_deployed = globalPropertyiae("sim/cockpit2/annunciators/reverser_on", 2)
R_reverser_fail = globalPropertyi("sim/operation/failures/rel_revers1")
--Operation
f_time = globalPropertyf("sim/operation/misc/frame_rate_period")
c_time = globalPropertyf("Strato/777/time/current")
on_ground = globalPropertyi("sim/flightmodel/failures/onground_any")

pfc_roll_command = globalPropertyf("Strato/777/fctl/pfc/roll")
pfc_elevator_command = globalPropertyf("Strato/777/fctl/pfc/elevator")
pfc_rudder_command = globalPropertyf("Strato/777/fctl/pfc/rudder")
fbw_ail_ratio = globalPropertyf("Strato/777/fctl/ail_ratio")
fbw_flprn_ratio_l = globalPropertyf("Strato/777/fctl/flprn_ratio_l")
fbw_flprn_ratio_u = globalPropertyf("Strato/777/fctl/flprn_ratio_u")
--ACE command datarefs
ace_aileron = globalProperty("Strato/777/fctl/ace/ailrn_cmd")
ace_flaperon = globalProperty("Strato/777/fctl/ace/flprn_cmd")
ace_spoiler = globalProperty("Strato/777/fctl/ace/spoiler_cmd")
ace_elevator = globalProperty("Strato/777/fctl/ace/elevator_cmd")
ace_rudder = globalPropertyf("Strato/777/fctl/ace/rudder_cmd")
--PCU modes
pcu_aileron = globalProperty("Strato/777/fctl/pcu/ail")
pcu_flaperon = globalProperty("Strato/777/fctl/pcu/flprn")
pcu_elevator = globalProperty("Strato/777/fctl/pcu/elev")
pcu_rudder = globalProperty("Strato/777/fctl/pcu/rudder")
pcu_sp = globalProperty("Strato/777/fctl/pcu/sp")

--creating our own datarefs

--PCU modes: 
--0 - bypass
--1 - normal
--2 - blocking

--load indexation:
--1, 2 - spoilers
--3, 4 - ailerons
--5 - elevators
--6 - rudder
--7 - flaps
--8 - gear steering
--9 - gear deployment/retraction
--10, 11 - left and right reversers respectively

hyd_load = createGlobalPropertyfa("Strato/777/hydraulics/load", {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
flap_tgt = globalPropertyf("Strato/777/flaps/tgt")
flap_load_relief = createGlobalPropertyi("Strato/777/flaps/load_relief", 0) --set to 1 when load relief system is operating
flap_handle_used = createGlobalPropertyf("Strato/777/flaps/handle_used", 0)

flap_settings = {0, 1, 5, 15, 20, 25, 30}  

vec3d = {x = 0, y = 0, z = 0}

function vec3d:new(tmp)
    tmp = tmp or {}
    setmetatable(tmp, self)
    self.__index = self
    return tmp
end

--Control_sfc description:
--dref_ace - dataref for ACE command, NOT ACE status
--rt stands for response time
--vab, vab are velocity airborne begin and velocity airborne done respectively
--rt_coeff_damped - coefficient for calculation of response time as function of airspeed

Control_sfc = {full_up = 0, full_dn = 0, dref_pos = 0, dref_ace = 0, dref_pcu = 0, rt_nml = 0, rt_damped = 0, rt_coeff_damped = 0, vab = 0, vad = 0, load_idx = 1, load_max = 0.1} 

function ResetLoad()
	for i=1,6 do
		set(hyd_load, 0, i)
	end
end

function Control_sfc:new(tmp)
    tmp = tmp or {}
    setmetatable(tmp, self)
    self.__index = self
    return tmp
end

function Control_sfc:setPosForNegativeSpeed(cmpval, rt)
	if get(self.dref_pos) > cmpval then
		EvenAnim(self.dref_pos, self.full_dn, rt)
	elseif get(self.dref_pos) < -cmpval then
		EvenAnim(self.dref_pos, self.full_up, rt)
	else
		EvenAnim(self.dref_pos, 0, rt)
	end
end

function Control_sfc:updateLoad()
	if get(self.dref_pos) >= 0 then
		local tmp_pos = self.full_dn
		if self.full_dn == 0 then
			tmp_pos = self.full_up
		end
		set(hyd_load, get(hyd_load, self.load_idx) + self.load_max * get(self.dref_pos) / tmp_pos, self.load_idx)
	else
		set(hyd_load, get(hyd_load, self.load_idx) + self.load_max * get(self.dref_pos) / self.full_up, self.load_idx)
	end
end

function Control_sfc:updatePositionAil(airspeed, idx)
	if get(self.dref_pcu, idx) == 0 then
		if math.abs(airspeed.z) < self.vab then
			EvenAnim(self.dref_pos, self.full_dn, self.rt_damped)
		elseif math.abs(airspeed.z) >= self.vab and math.abs(airspeed.z) < self.vad then
			local rt = self.rt_damped + self.rt_coeff_damped * (math.abs(airspeed.z) - self.vab) ^ 2
			if airspeed.z >= 0 then
				local pos = self.full_dn - (airspeed.z - self.vab) * self.full_dn / (self.vad - self.vab)
				EvenAnim(self.dref_pos, pos, rt)
			else
				self:setPosForNegativeSpeed(1, rt)
			end
		else
			local rt = self.rt_damped + self.rt_coeff_damped * (self.vad - self.vab) ^ 2
			if airspeed.z >= 0 then
				EvenAnim(self.dref_pos, 0, rt)
			else
				self:setPosForNegativeSpeed(1, rt)
			end
		end
	elseif get(self.dref_pcu, idx) == 1 then
		EvenAnim(self.dref_pos, get(self.dref_ace, idx), self.rt_nml)
	elseif get(self.dref_pcu, idx) == 2 then
		EvenAnim(self.dref_pos, 0, self.rt_damped)
	end
	self:updateLoad()
end

function Control_sfc:updatePositionRud(airspeed)
	if get(self.dref_pcu) == 0 then
		local mov_x = 0
		local rt = self.rt_damped
		if math.abs(airspeed.x) >= self.vab then
			if airspeed.x < 0 then
				mov_x = self.full_up
			elseif airspeed.x > 0 then
				mov_x = self.full_dn
			end
		end
		if airspeed.z >= self.vab and airspeed.z < self.vad then
			local tmp = 1 - (airspeed.z - self.vab) / (self.vad - self.vab)
			mov_x = mov_x * tmp
		end
		local airspeed_sum = math.sqrt(airspeed.x^2 + airspeed.z^2)
		if airspeed_sum >= self.vab and airspeed_sum < self.vad then
			rt = self.rt_damped + self.rt_coeff_damped * (math.abs(airspeed_sum) - self.vab) ^ 2
		elseif airspeed_sum >= self.vad then
			rt = self.rt_damped + self.rt_coeff_damped * (self.vad - self.vab) ^ 2
		end
		EvenAnim(self.dref_pos, mov_x, rt)
	elseif get(self.dref_pcu) == 1 then
		EvenAnim(self.dref_pos, get(self.dref_ace), self.rt_nml)
	end
	self:updateLoad()
end

function GetClosestFlapSetting()
	local tmp = 1
	for i=1,7 do
		tmp = tmp + 1
		if flap_settings[i] >= get(flaps) then
			return i
		end
	end
	return tmp
end

function UpdateReversers()
	local pressure_L = globalPropertyiae("Strato/777/hydraulics/press", 1)
	local h_load_L = globalPropertyfae("Strato/777/hydraulics/load", 10)
	local pressure_R = globalPropertyiae("Strato/777/hydraulics/press", 3)
	local h_load_R = globalPropertyfae("Strato/777/hydraulics/load", 11)
	set(L_reverser_fail, 6 * bool2num(get(pressure_L) < 300 or get(on_ground) == 0))
	set(h_load_L, 0.2 * bool2num(get(pressure_L) > 300) * get(L_reverser_deployed))
	set(R_reverser_fail, 6 * bool2num(get(pressure_R) < 300 or get(on_ground) == 0))
	set(h_load_R, 0.2 * bool2num(get(pressure_R) > 300) * get(R_reverser_deployed))
end

--Flaps

function SetFlapTarget()
	detents = {0, 0.17, 0.33, 0.5, 0.67, 0.83, 1}
	cas_limits = {-1, 265, 245, 230, 225, 200, 180} --limits in meters per second for load relief system
	local sys_C_press = globalPropertyiae("Strato/777/hydraulics/press", 2)
	local h_load = globalPropertyfae("Strato/777/hydraulics/load", 7)
	if get(sys_C_press) >= 1000 then
		local flap_pos = get(flaps)
		local index = indexOf(detents, get(flap_handle), 1)
		local avg_cas = (get(cas_pilot) + get(cas_copilot)) / 2
		if index ~= nil then
			if avg_cas > cas_limits[index] and get(flap_handle) >= 0.5 or (get(flap_handle) > 0 and flap_pos == 0 and avg_cas > 140 and (get(altitude_pilot) >= 20000 or get(altitude_copilot) >= 20000 or get(altitude_stdby) >= 20000)) then --load relief system only triggers with flaps 15 or below
				if get(flap_load_relief) ~= 1 then
					set(flap_load_relief, 1)
				end
				if get(flap_pos) > 5 then
					for i = index,3,-1 do
						if cas_limits[i] > avg_cas or i == 3 then --load relief retraction is limited to flap 5 idk why but the fcom says it
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
	if get(flap_tgt) ~= get(flaps) then --update load dataref
		set(h_load, 0.2)
	else
		set(h_load, 0)
	end
end

function GetFlapCurrent()
	flap_times = {0.4, 1.4, 8, 4.8, 1.9, 3.17}
	local target = get(flap_tgt)
	local actual = get(flaps)
	local closest = lim(GetClosestFlapSetting(), 7, 2)
	local step = flap_times[closest - 1] * 0.004
	if math.abs(target - actual) <= step then
		return target
	else
		return actual + step * (-bool2num(target < actual) + bool2num(target > actual)) * get(f_time) / 0.0166
	end
end

--these functions set a bunch of datarefs for flight controls to the same value. I guess this is needed because of something in plane maker
function UpdateRudder(value)
	set(upper_rudder, value)
	set(bottom_rudder, value)
end

function UpdateSlats()
	local flap_target = get(flap_tgt)
	local flap_actual = get(flaps)
	if flap_actual < 1 then
		set(slat_1, flap_actual / 2)
		set(slat_2, flap_actual / 2)
	elseif flap_actual >= 1 and flap_actual <= 20 then
		set(slat_1, 0.5)
		set(slat_2, 0.5)
	elseif flap_actual > 20 and flap_actual < 25 then
		set(slat_1, 0.5 + (flap_actual - 20) * 0.1)
		set(slat_2, 0.5 + (flap_actual - 20) * 0.1)
	elseif flap_actual >= 25 then
		set(slat_1, 1)
		set(slat_2, 1)
	else
		set(slat_1, 0)
		set(slat_2, 0)
	end
end

function UpdateFlaps(value)
	--set(flaps, value)
	set(inbd_flap_L, value)
	set(outbd_flap_L, value)
	set(inbd_flap_R, value)
	set(outbd_flap_R, value)
end

airspeed_vec = vec3d:new{x = 0, y = 0, z = 0}
sp_L1 = Control_sfc:new{full_up = 60, full_dn = 0, dref_pos = spoiler_L1, dref_ace = ace_spoiler, dref_pcu = pcu_sp, rt_nml = 1.4, rt_damped = 0.01, rt_coeff_damped = 0.001, vab = 0, vad = 0, load_idx = 1, load_max = 0.025}
sp_L2 = Control_sfc:new{full_up = 45, full_dn = 0, dref_pos = spoiler_L2, dref_ace = ace_spoiler, dref_pcu = pcu_sp, rt_nml = 0.47, rt_damped = 0.01, rt_coeff_damped = 0.001, vab = 0, vad = 0, load_idx = 1, load_max = 0.025}
sp_R1 = Control_sfc:new{full_up = 60, full_dn = 0, dref_pos = spoiler_R1, dref_ace = ace_spoiler, dref_pcu = pcu_sp, rt_nml = 1.4, rt_damped = 0.01, rt_coeff_damped = 0.001, vab = 0, vad = 0, load_idx = 2, load_max = 0.025}
sp_R2 = Control_sfc:new{full_up = 45, full_dn = 0, dref_pos = spoiler_R2, dref_ace = ace_spoiler, dref_pcu = pcu_sp, rt_nml = 0.47, rt_damped = 0.01, rt_coeff_damped = 0.001, vab = 0, vad = 0, load_idx = 2, load_max = 0.025}
ail_L = Control_sfc:new{full_up = -33, full_dn = 19, dref_pos = outbd_ail_L, dref_ace = ace_aileron, dref_pcu = pcu_aileron, rt_nml = 0.45, rt_damped = 0.008, rt_coeff_damped = 0.001, vab = 30, vad = 50, load_idx = 3, load_max = 0.08}
ail_R = Control_sfc:new{full_up = -33, full_dn = 19, dref_pos = outbd_ail_R, dref_ace = ace_aileron, dref_pcu = pcu_aileron, rt_nml = 0.45, rt_damped = 0.008, rt_coeff_damped = 0.001, vab = 10, vad = 20, load_idx = 3, load_max = 0.08}
flprn_L = Control_sfc:new{full_up = -11, full_dn = 37, dref_pos = inbd_ail_L, dref_ace = ace_flaperon, dref_pcu = pcu_flaperon, rt_nml = 0.4, rt_damped = 0.008, rt_coeff_damped = 0.001, vab = 20, vad = 41, load_idx = 4, load_max = 0.07}
flprn_R = Control_sfc:new{full_up = -11, full_dn = 37, dref_pos = inbd_ail_R, dref_ace = ace_flaperon, dref_pcu = pcu_flaperon, rt_nml = 0.4, rt_damped = 0.008, rt_coeff_damped = 0.001, vab = 20, vad = 41, load_idx = 4, load_max = 0.07}
elev_L = Control_sfc:new{full_up = -33, full_dn = 27, dref_pos = elevator_L, dref_ace = ace_elevator, dref_pcu = pcu_elevator, rt_nml = 0.6, rt_damped = 0.008, rt_coeff_damped = 0.001, vab = 15, vad = 34, load_idx = 5, load_max = 0.1}
elev_R = Control_sfc:new{full_up = -33, full_dn = 27, dref_pos = elevator_R, dref_ace = ace_elevator, dref_pcu = pcu_elevator, rt_nml = 0.6, rt_damped = 0.008, rt_coeff_damped = 0.001, vab = 15, vad = 34, load_idx = 5, load_max = 0.1}
rudder_top = Control_sfc:new{full_up = -27, full_dn = 27, dref_pos = upper_rudder, dref_ace = ace_rudder, dref_pcu = pcu_rudder, rt_nml = 0.5, rt_damped = 0.008, rt_coeff_damped = 0.001, vab = 1, vad = 4, load_idx = 6, load_max = 0.1}

function update()
	airspeed_vec.x = get(speed_x)
	airspeed_vec.z = get(speed_z)
	ResetLoad()
	--Move flight controls in sim
	sp_L1:updatePositionAil(airspeed_vec, 2)
	sp_L2:updatePositionAil(airspeed_vec, 1)
	sp_R1:updatePositionAil(airspeed_vec, 4)
	sp_R2:updatePositionAil(airspeed_vec, 3)
	ail_L:updatePositionAil(airspeed_vec, 1)
	ail_R:updatePositionAil(airspeed_vec, 2)
	flprn_L:updatePositionAil(airspeed_vec, 1)
	flprn_R:updatePositionAil(airspeed_vec, 2)
	elev_L:updatePositionAil(airspeed_vec, 1)
	elev_R:updatePositionAil(airspeed_vec, 2)
	rudder_top:updatePositionRud(airspeed_vec)
	UpdateReversers()
	SetFlapTarget()
	UpdateFlaps(GetFlapCurrent())
	UpdateSlats()
	set(bottom_rudder, get(upper_rudder))
end

function onAirportLoaded()
	if get(ra_pilot) > 100 or get(ra_copilot) > 100 then
		UpdateFlaps(5)
		set(flap_tgt, 5)
		UpdateSlats()
	end
end

onAirportLoaded()
