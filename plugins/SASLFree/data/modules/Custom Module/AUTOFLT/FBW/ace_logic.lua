--[[
*****************************************************************************************
* Script Name: fbw_main
* Author Name: @bruh
* Script Description: Code for ace logic
*****************************************************************************************
--]]

include("misc_tools.lua")
include("thrust_asym_comp.lua")
include("fbw_bite.lua")

--Cockpit controls
yoke_pitch_ratio = globalPropertyf("sim/cockpit2/controls/yoke_pitch_ratio")
yoke_roll_ratio = globalPropertyf("sim/cockpit2/controls/yoke_roll_ratio")
yoke_heading_ratio = globalPropertyf("sim/cockpit2/controls/yoke_heading_ratio")
rud_pedals = globalPropertyf("Strato/777/cockpit/switches/rud_pedals")
stab_trim = globalPropertyf("sim/cockpit2/controls/elevator_trim")
spoiler_handle = globalPropertyf("sim/cockpit2/controls/speedbrake_ratio")
throttle_pos = globalPropertyf("sim/cockpit2/engine/actuators/throttle_ratio_all")
--Control surfaces
flaps = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 1)
ail_L_act = globalPropertyfae("sim/flightmodel2/wing/aileron2_deg", 5)
ail_R_act = globalPropertyfae("sim/flightmodel2/wing/aileron2_deg", 6)
flprn_L_act = globalPropertyfae("sim/flightmodel2/wing/aileron1_deg", 1)
flprn_R_act = globalPropertyfae("sim/flightmodel2/wing/aileron1_deg", 2)
spoiler_L1_act = globalPropertyfae("sim/flightmodel2/wing/spoiler1_deg", 3) --#4
spoiler_L2_act = globalPropertyfae("sim/flightmodel2/wing/spoiler2_deg", 3)
spoiler_R1_act = globalPropertyfae("sim/flightmodel2/wing/spoiler1_deg", 4) --#11
spoiler_R2_act = globalPropertyfae("sim/flightmodel2/wing/spoiler2_deg", 4)
elevator_L_act = globalPropertyfae("sim/flightmodel2/wing/elevator1_deg",9)
elevator_R_act = globalPropertyfae("sim/flightmodel2/wing/elevator1_deg",10)
rudder_act = globalPropertyfae("sim/flightmodel2/wing/rudder1_deg", 12)
--Engine datarefs
L_reverser_deployed = globalPropertyiae("sim/cockpit2/annunciators/reverser_on", 1)
thrust_engn_L = globalPropertyfae("sim/flightmodel/engine/POINT_thrust", 1)
R_reverser_deployed = globalPropertyiae("sim/cockpit2/annunciators/reverser_on", 2)
thrust_engn_R = globalPropertyfae("sim/flightmodel/engine/POINT_thrust", 2)
--Indicators
altitude_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/altitude_ft_pilot")
altitude_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/altitude_ft_copilot")
altitude_stdby = globalPropertyf("sim/cockpit2/gauges/indicators/altitude_ft_stby")
ra_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")
ra_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_copilot")
cas_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
tas_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/true_airspeed_kts_pilot")
pitch_pilot = globalPropertyf("sim/cockpit/gyros/the_ind_ahars_pilot_deg")
roll_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/roll_AHARS_deg_pilot")
cas_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_copilot")
tas_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/true_airspeed_kts_copilot")
pitch_copilot = globalPropertyf("sim/cockpit/gyros/the_ind_ahars_copilot_deg")
roll_copilot = globalPropertyf("sim/cockpit2/gauges/indicators/roll_AHARS_deg_copilot")
--Gear positions
nw_actual = globalPropertyfae("sim/aircraft/parts/acf_gear_deploy", 1)
mlg_actual_R = globalPropertyfae("sim/aircraft/parts/acf_gear_deploy", 2)
mlg_actual_L = globalPropertyfae("sim/aircraft/parts/acf_gear_deploy", 3)
--Ground collision
nw_onground = globalPropertyiae("sim/flightmodel2/gear/on_ground", 1)
rmw_onground = globalPropertyiae("sim/flightmodel2/gear/on_ground", 2)
lmw_onground = globalPropertyiae("sim/flightmodel2/gear/on_ground", 3)
on_ground = globalPropertyi("sim/flightmodel/failures/onground_any")
--Operation
f_time = globalPropertyf("sim/operation/misc/frame_rate_period")
c_time = globalPropertyf("Strato/777/time/current")
curr_g = globalPropertyf("sim/flightmodel/forces/g_nrml")
cg = globalPropertyf("sim/flightmodel/misc/cgz_ref_to_default")
total_mass = globalPropertyf("sim/flightmodel/weight/m_total")
yaw = globalPropertyf("sim/flightmodel/position/R")
slip = globalPropertyf("sim/cockpit2/gauges/indicators/slip_deg")
--Speeds
max_allowable = globalPropertyi("Strato/777/fctl/vmax")
stall_speed = globalPropertyi("Strato/777/fctl/vstall")
maneuver_speed = globalPropertyi("Strato/777/fctl/vmanuever")
--Stabilizer and rudder trim
stab_cutout_C = globalPropertyi("Strato/777/fctl/stab_cutout_C")
stab_cutout_R = globalPropertyi("Strato/777/fctl/stab_cutout_R")
pitch_trim_A = globalPropertyi("Strato/777/cockpit/switches/strim_A")
pitch_trim_B = globalPropertyi("Strato/777/cockpit/switches/strim_B")
pitch_trim_altn = globalPropertyi("Strato/777/cockpit/switches/strim_altn")
ths_degrees = globalPropertyf("sim/flightmodel2/controls/stabilizer_deflection_degrees")
tac_engage = globalPropertyi("Strato/777/fctl/ace/tac_eng")
tac_fail = globalPropertyi("Strato/777/fctl/ace/tac_fail")
rud_trim_reset = createGlobalPropertyi("Strato/777/fctl/ace/rud_trim_reset", 0)
rud_trim_man = createGlobalPropertyf("Strato/777/fctl/ace/rud_trim_man", 0)
rud_trim_auto = createGlobalPropertyf("Strato/777/fctl/ace/rud_trim_auto", 0)
--Hydraulics
hyd_pressure = globalProperty("Strato/777/hydraulics/press")
--Data bus
pfc_calc = globalPropertyi("Strato/777/fctl/databus/calc")
pfc_pilot_input = globalProperty("Strato/777/fctl/databus/pilot_input")
pfc_maneuver_speeds = globalProperty("Strato/777/fctl/databus/maneuver_speeds")
pfc_ra = globalPropertyf("Strato/777/fctl/databus/rad_alt")
pfc_alt_baro = globalPropertyf("Strato/777/fctl/databus/alt_baro")
pfc_cas = globalPropertyf("Strato/777/fctl/databus/cas")
pfc_flt_axes = globalProperty("Strato/777/fctl/databus/flt_axes") --pitch, roll, yaw
pfc_slip = globalPropertyf("Strato/777/fctl/databus/slip")
pfc_thrust = globalProperty("Strato/777/fctl/databus/thrust")
pfc_flaps = globalPropertyf("Strato/777/fctl/databus/flaps")
pfc_mass = globalPropertyf("Strato/777/fctl/databus/mass_total")
pfc_ths_current = globalPropertyf("Strato/777/fctl/databus/ths_current")
pfc_stab_trim_operative = globalPropertyi("Strato/777/fctl/databus/stab_trim_op")
--PFC input
fbw_trim_speed = globalPropertyf("Strato/777/fctl/trs")
--PFC output
fbw_mode = globalProperty("Strato/777/fctl/pfc/mode")
pfc_roll_command = globalPropertyf("Strato/777/fctl/pfc/roll")
pfc_elevator_command = globalPropertyf("Strato/777/fctl/pfc/elevator")
pfc_rudder_command = globalPropertyf("Strato/777/fctl/pfc/rudder")
pfc_stab_trim_cmd = globalPropertyf("Strato/777/fctl/pfc/stab_trim")

ace_fail = globalProperty("Strato/777/failures/fctl/ace") --L1, L2, C, R
--Commanded positions
ace_aileron = globalProperty("Strato/777/fctl/ace/ailrn_cmd")
ace_flaperon = globalProperty("Strato/777/fctl/ace/flprn_cmd")
ace_spoiler = globalProperty("Strato/777/fctl/ace/spoiler_cmd")
ace_elevator = globalProperty("Strato/777/fctl/ace/elevator_cmd")
ace_rudder = globalPropertyf("Strato/777/fctl/ace/rudder_cmd")
--Flight control status
ace_aileron_fail_L = globalPropertyi("Strato/777/fctl/ace/ailrn_fail_L")
ace_aileron_fail_R = globalPropertyi("Strato/777/fctl/ace/ailrn_fail_R")
ace_flaperon_fail_L = globalPropertyi("Strato/777/fctl/ace/flprn_fail_L")
ace_flaperon_fail_R = globalPropertyi("Strato/777/fctl/ace/flprn_fail_R")
ace_spoiler_fail_17 = globalPropertyi("Strato/777/fctl/ace/ace_spoiler_fail_17")
ace_spoiler_fail_2 = globalPropertyi("Strato/777/fctl/ace/ace_spoiler_fail_2")
ace_spoiler_fail_36 = globalPropertyi("Strato/777/fctl/ace/ace_spoiler_fail_36")
ace_spoiler_fail_4 = globalPropertyi("Strato/777/fctl/ace/ace_spoiler_fail_4")
ace_spoiler_fail_5 = globalPropertyi("Strato/777/fctl/ace/ace_spoiler_fail_5")
ace_elevator_fail_L = globalPropertyi("Strato/777/fctl/ace/elevator_fail_L")
ace_elevator_fail_R = globalPropertyi("Strato/777/fctl/ace/elevator_fail_R")
ace_rudder_fail = globalPropertyi("Strato/777/fctl/ace/rudder_fail")
--PCU modes
pcu_aileron = globalProperty("Strato/777/fctl/pcu/ail")
pcu_flaperon = globalProperty("Strato/777/fctl/pcu/flprn")
pcu_elevator = globalProperty("Strato/777/fctl/pcu/elev")
pcu_rudder = globalProperty("Strato/777/fctl/pcu/rudder")
pcu_sp = globalProperty("Strato/777/fctl/pcu/sp")

--PCU modes:
--0 - bypass
--1 - normal
--2 - blocking

Ail_neutral = {0, 0, 5, 5, 5, 0, 0}
Flprn_neutral = {0, 0, 5, 14, 16, 29, 29}
rud_trim_auto_past = 0
Control_surface = {aces = {0, 0}, hyd_sys = {0, 0}, full_up = 18, full_dn = 18, mode = 0}

function Control_surface:new(tmp)
    tmp = tmp or {}
    setmetatable(tmp, self)
    self.__index = self
    return tmp
end

function getPosition(v, neutral, r1, r2)
    if v >= 0 then
        return neutral + (r2 - neutral) * v
    else
        return neutral + (r1 + neutral) * v
    end
end

function Control_surface:isHydLow()
    local max_psi = 0
    for i, v in ipairs(self.hyd_sys) do
        local tmp = get(hyd_pressure, v)
        if tmp > max_psi then
            max_psi = tmp
        end
    end
    if max_psi < 1200 then
        return true
    end
    return false
end

function Control_surface:isOperational()
    local n_failed = 0
    local idx_last = 1
    for i, v in ipairs(self.aces) do
        local tmp = get(ace_fail, v)
        if tmp == 1 then
            n_failed = n_failed + 1
        end
        idx_last = i
    end
    if n_failed >= idx_last then
        return false
    end
    return true
end

function Control_surface:setCmd(dref_nml, dref_fail, cmd, idx, fail_handler)
    if not self:isHydLow() and self:isOperational() then
        set(dref_nml, cmd, idx)
        set(dref_fail, 0)
        set(self.mode, 1, idx)
    else
        set(dref_fail, 1)
        fail_handler(self, idx)
    end
end

function isStabTrimOperative()
    if (get(hyd_pressure, 2) * (1 - get(stab_cutout_C)) > 900 or get(hyd_pressure, 3) * (1 - get(stab_cutout_R)) > 900) then
        return 1
    end
    return 0
end

function sendFLTdata()
    --Sends flight data to PFCs
    if get(fbw_mode) ~= 3 and get(on_ground) == 0 then
        set(pfc_calc, 1)
        local avg_ra = (get(ra_pilot) + get(ra_pilot)) / 2
        local avg_alt_baro = (get(altitude_pilot) + get(altitude_stdby) + get(altitude_copilot)) / 3
        local avg_cas = (get(cas_pilot) + get(cas_copilot)) / 2
        local avg_pitch = (get(pitch_pilot) + get(pitch_copilot)) / 2
        local avg_roll = (get(roll_pilot) + get(roll_copilot)) / 2
        --Pilot input
        set(pfc_pilot_input, get(yoke_roll_ratio), 1)
        set(pfc_pilot_input, get(yoke_heading_ratio), 2)
        set(pfc_pilot_input, get(yoke_pitch_ratio), 3)
        --Maneuver speeds
        set(pfc_maneuver_speeds, get(max_allowable), 1)
        set(pfc_maneuver_speeds, get(maneuver_speed), 2)
        --Radio altimeters
        set(pfc_ra, avg_ra)
        --Baro altitude
        set(pfc_alt_baro, avg_alt_baro)
        --CAS
        set(pfc_cas, avg_cas)
        --Flight axes
        set(pfc_flt_axes, avg_pitch, 1)
        set(pfc_flt_axes, avg_roll, 2)
        set(pfc_flt_axes, get(yaw), 3)
        set(pfc_slip, get(slip))
        --Flaps
        set(pfc_flaps, get(flaps))
        --Stab trim
        set(pfc_ths_current, get(stab_trim))
        set(pfc_stab_trim_operative, isStabTrimOperative())
        --Thrust
        set(pfc_thrust, get(thrust_engn_L), 1)
        set(pfc_thrust, get(thrust_engn_R), 2)
        --Mass
        set(pfc_mass, get(total_mass))
    else
        set(pfc_calc, 0)
    end
end

function SetSpeedbrkHandle() --this is just some code for the speedbrake handle
    local all_onground = get(nw_onground) == 1 and get(lmw_onground) == 1 and get(rmw_onground) == 1
    local rev_deployed = (get(L_reverser_deployed) or get(R_reverser_deployed)) == 1
    if all_onground then
	    if rev_deployed and get(hyd_pressure, 2) > 1200 and get(fbw_mode) == 1 then --conditions for deployment
	    	set(spoiler_handle, 1)
	    elseif get(throttle_pos) > 0.5 and get(spoiler_handle) > 0.3 then --automatic retraction when too much thrust is applied
	    	set(spoiler_handle, 0)
	    end
    elseif get(lmw_onground) == 1 and get(rmw_onground) == 1 and get(nw_onground) == 0 then
        if rev_deployed and get(hyd_pressure, 2) > 1200 and get(fbw_mode) == 1 and get(spoiler_handle) < 0 then
            set(spoiler_handle, 1)
        end
    end
end

function GetFBWAilRatio(fctl_mode, avg_alt, avg_cas, flap_pos)
	if fctl_mode == 1 then
		--Speeds and altitudes for aileron lockout
		lockout_speeds = {280, 240, 240, 166}
		red_authority_speeds = {270, 230, 230, 152}
		lockout_alts = {11500, 19500, 26500, 43000}
		red_authority_alts = {9000, 17500, 25000, 43000}
		local tmp_idx_1 = 0 --limit after which we start decreasing aileron ratio
		local tmp_idx_2 = 0 --limit after which we start blocking
		--find below which altitude we are from the pre defined alts for max and min limits
		for i=4,1,-1 do
			if avg_alt < red_authority_alts[i] then
				tmp_idx_1 = i
			elseif avg_alt == red_authority_alts[i] then
				tmp_idx_1 = i
				break
			else
				break
			end
		end
		for i=4,1,-1 do
			if avg_alt < lockout_alts[i] then
				tmp_idx_2 = i
			elseif avg_alt == lockout_alts[i] then
				tmp_idx_2 = i
				break
			else
				break
			end
		end
		--Calculate the speed limits for given config
		local speed_lim_min = 0
		local speed_lim_max = 0
		if tmp_idx_1 > 1 then
			speed_lim_min = red_authority_speeds[tmp_idx_1 - 1] + (red_authority_speeds[tmp_idx_1] - red_authority_speeds[tmp_idx_1 - 1]) * (avg_alt - red_authority_alts[tmp_idx_1 - 1]) / (red_authority_alts[tmp_idx_1] - red_authority_alts[tmp_idx_1 - 1])
		else
			speed_lim_min = red_authority_speeds[1]
		end
		if tmp_idx_2 > 1 then
			speed_lim_max = lockout_speeds[tmp_idx_2 - 1] + (lockout_speeds[tmp_idx_2] - lockout_speeds[tmp_idx_2 - 1]) * (avg_alt - lockout_alts[tmp_idx_2 - 1]) / (lockout_alts[tmp_idx_2] - lockout_alts[tmp_idx_2 - 1])
		else
			speed_lim_max = lockout_speeds[1]
		end
		if avg_cas <= speed_lim_min then
			return 1
		elseif avg_cas > speed_lim_min and avg_cas < speed_lim_max then
			return (1 - ((avg_cas - speed_lim_min) / (speed_lim_max - speed_lim_min)))
		end
	else
		if flap_pos ~= 0 then
			return 1
		end
	end
    return 0
end

function GetRudderRatio(tas, flap_pos)
    local ratio = 54
    if get(fbw_mode) ~= 3 then
        if tas > 135 and tas <= 269 then
            return ratio - (tas - 135) * (36 / 115)
        elseif tas > 269 then
            return 12
        end
    else
        if Round(flap_pos, 2) == 0 then
            return ratio * 0.5
        end 
    end
    return ratio
end

function BasicFailHandler(sfc, idx, control_dref, dref_list)
    set(sfc.mode, 0, idx)
end

function AilFailHandler(sfc, idx)
    local ail_drefs = {ail_L_act, ail_R_act}
    set(sfc.mode, 2, idx)
end

function ElevatorFailHandler(sfc, idx)
    local elevator_datarefs = {elevator_L_act, elevator_R_act}
    if math.abs(get(elevator_datarefs[idx])) <= 2 then
        set(sfc.mode, 2, idx)
    else
        set(sfc.mode, 0, idx)
    end
end

function RudderFailHandler(sfc, idx)
    BasicFailHandler(sfc, idx, ace_rudder, {rudder_act})
end

function FlprnFailHandler(sfc, idx)
    local flprn_drefs = {flprn_L_act, flprn_R_act}
    BasicFailHandler(sfc, idx, ace_flaperon, flprn_drefs)
end

function FlprnTOHandler(sfc, idx)
    local flprn_drefs = {flprn_L_act, flprn_R_act}
    local avg_cas = (get(cas_pilot) + get(cas_copilot)) / 2
    if Round(get(flprn_drefs[idx]), 2) == sfc.full_dn or avg_cas > 100 then
        set(sfc.mode, 0, idx)
    else
        local flprn_command = EvenChange(get(ace_flaperon, idx), sfc.full_dn, 0.2)
        set(ace_flaperon, flprn_command, idx)
    end
end

function GetRollNeutral(flap_pos, neutral)
    local flap_settings = {0, 1, 5, 15, 20, 25, 30}
    local idx = getGreaterThan(flap_settings, flap_pos)
    if idx ~= 1 then
        local tmp = (neutral[idx] - neutral[idx - 1]) / (flap_settings[idx] - flap_settings[idx - 1])
        return tmp * (flap_pos - flap_settings[idx - 1]) + neutral[idx - 1]
    end
    return neutral[1]
end

function UpdateSpoilers(avg_cas, spoilers, sp_fail_drefs, sp_cmd_dref, activation_limit)
    sp_main_avail = false
    sp_sec_avail = false
    local pri_spoiler_command_L = lim(get(spoiler_handle), 1, 0)
    local pri_spoiler_command_R = pri_spoiler_command_L
    local sec_spoiler_command_L = pri_spoiler_command_L
    local sec_spoiler_command_R = pri_spoiler_command_L
    --Getting states of the spoilers
    for i=1,5 do
        local state = spoilers[i]:isOperational() and not spoilers[i]:isHydLow()
        set(sp_fail_drefs[i], bool2num(not state))
        if i ~= 4 and state then
            sp_main_avail = true
        elseif i == 4 and state then
            sp_sec_avail = true
        end
    end
    --Checking control wheel
    if math.abs(get(yoke_roll_ratio)) >= activation_limit then
        local tmp = -0.3
        local pri_coeff = 1
        if get(spoiler_handle) <= 0 then
            pri_coeff = 0.9
        end
        if get(yoke_roll_ratio) < 0 then
            tmp = tmp * -1
        end
        local cw_component = (get(yoke_roll_ratio) + tmp) / 0.7
        pri_spoiler_command_L = pri_spoiler_command_L - getPosition(cw_component * pri_coeff, 0, 1 - pri_spoiler_command_L, pri_spoiler_command_L)
        pri_spoiler_command_R = pri_spoiler_command_R - getPosition(-cw_component * pri_coeff, 0, 1 - pri_spoiler_command_R, pri_spoiler_command_R)
        sec_spoiler_command_L = sec_spoiler_command_L - getPosition(cw_component, 0, 1 - sec_spoiler_command_L, sec_spoiler_command_L)
        sec_spoiler_command_R = sec_spoiler_command_R - getPosition(-cw_component, 0, 1 - sec_spoiler_command_R, sec_spoiler_command_R)
    end
    --Setting Commands
    if sp_main_avail then
        set(sp_cmd_dref, pri_spoiler_command_L * spoilers[1].full_up - (1 / 16) * avg_cas, 2)
        set(sp_cmd_dref, pri_spoiler_command_R * spoilers[1].full_up - (1 / 16) * avg_cas, 4)
        set(pcu_sp, 1, 2)
        set(pcu_sp, 1, 4)
    else
        set(sp_cmd_dref, 0, 2)
        set(sp_cmd_dref, 0, 4)
        set(pcu_sp, 0, 2)
        set(pcu_sp, 0, 4)
    end
    if sp_sec_avail then
        set(sp_cmd_dref, sec_spoiler_command_L * spoilers[4].full_up, 1)
        set(sp_cmd_dref, sec_spoiler_command_R * spoilers[4].full_up, 3)
        set(pcu_sp, 1, 1)
        set(pcu_sp, 1, 3)
    else
        set(sp_cmd_dref, 0, 1)
        set(sp_cmd_dref, 0, 3)
        set(pcu_sp, 0, 1)
        set(pcu_sp, 0, 3)
    end
end

function UpdateRoll(avg_cas, avg_alt, ail_L, ail_R, flp_L, flp_R)
    local ail_ratio = GetFBWAilRatio(get(fbw_mode), avg_alt, avg_cas, get(flaps))
    local ail_neutral = GetRollNeutral(get(flaps), Ail_neutral)
    local flprn_neutral = GetRollNeutral(get(flaps), Flprn_neutral) * (1 - lim(get(spoiler_handle), 1, 0))
    local roll_command = 0
    local flprn_command = 0
    if get(fbw_mode) == 1 and get(on_ground) == 0 then
        roll_command = get(pfc_roll_command)
    else
        roll_command = get(yoke_roll_ratio)
    end
    local ail_pos_L = getPosition(roll_command, ail_neutral, ail_ratio * ail_L.full_up, ail_ratio * ail_L.full_dn)
    local ail_pos_R = getPosition(-roll_command, ail_neutral, ail_ratio * ail_R.full_up, ail_ratio * ail_R.full_dn)
    local ail_fail = AilFailHandler
    local flp_fail = FlprnFailHandler
    ail_L:setCmd(ace_aileron, ace_aileron_fail_L, ail_pos_L, 1, ail_fail)
    ail_R:setCmd(ace_aileron, ace_aileron_fail_R, ail_pos_R, 2, ail_fail)
    if avg_cas < 100 and (get(thrust_engn_L) > 215000 or get(thrust_engn_R) > 215000) then
        FlprnTOHandler(flp_L, 1)
        FlprnTOHandler(flp_R, 2)
    else
        local flp_pos_L = getPosition(roll_command, flprn_neutral, flp_L.full_up, flp_L.full_dn)
        local flp_pos_R = getPosition(-roll_command, flprn_neutral, flp_R.full_up, flp_R.full_dn)
        flp_L:setCmd(ace_flaperon, ace_flaperon_fail_L, flp_pos_L, 1, flp_fail)
        flp_R:setCmd(ace_flaperon, ace_flaperon_fail_R, flp_pos_R, 2, flp_fail)
    end
end

function UpdateYaw(rudder)
    local avg_tas = (get(tas_pilot) + get(tas_copilot)) / 2
    local rud_ratio = GetRudderRatio(avg_tas, get(flaps)) * 0.5
    local rud_neutral = lim((get(rud_trim_auto) + get(rud_trim_man)) * rud_ratio / 27, rud_ratio, -rud_ratio)
    local yaw_cmd = 0
    local rud_fail = RudderFailHandler
    if get(fbw_mode) < 3 and get(on_ground) == 0 then
        yaw_cmd = get(pfc_rudder_command)
    else
        yaw_cmd = get(yoke_heading_ratio)
    end
    local yaw_out = getPosition(yaw_cmd, rud_neutral, rud_ratio, rud_ratio)
    rudder:setCmd(ace_rudder, ace_rudder_fail, yaw_out, 1, RudderFailHandler)
end

function UpdatePitch(elev_L, elev_R)
    local direct_coefficients = {{0.21, 0.3}, {0.27, 0.33}} --{push, pull}
    local elevator_cmd = 0
    local fail_handler = ElevatorFailHandler
    if get(fbw_mode) == 1 and get(on_ground) == 0 then
        elevator_cmd = lim(-get(pfc_elevator_command), 27, -33) 
    else
        local upper_ratio = 0
        local lower_rato = 0
        if get(on_ground) == 0 then
            lower_rato = (direct_coefficients[1][1] + get(flaps) * (direct_coefficients[2][1] - direct_coefficients[1][1]) / 30) * 100
            upper_ratio = (direct_coefficients[1][2] + get(flaps) * (direct_coefficients[2][2] - direct_coefficients[1][2]) / 30) * 100
        else
            upper_ratio = elev_L.full_up
            lower_rato = elev_L.full_dn
        end
        elevator_cmd = getPosition(-get(yoke_pitch_ratio), 0, upper_ratio, lower_rato)
    end
    elev_L:setCmd(ace_elevator, ace_elevator_fail_L, elevator_cmd, 1, ElevatorFailHandler)
    elev_R:setCmd(ace_elevator, ace_elevator_fail_R, elevator_cmd, 2, ElevatorFailHandler)
end

function UpdateRudderTrim()
    if get(rud_trim_reset) == 1 and get(rud_trim_man) ~= 0 then
        EvenAnim(rud_trim_man, 0, 0.2)
    elseif get(rud_trim_reset) == 1 and get(rud_trim_man) == 0 then
        set(rud_trim_reset, 0)
    end
    if get(fbw_mode) == 1 and get(ace_fail, 4) == 0 and get(tac_engage) == 1 then
        set(tac_fail, 0)
        local avg_cas = (get(cas_pilot) + get(cas_copilot)) / 2
        local rev_deployed = (get(L_reverser_deployed) or get(R_reverser_deployed)) == 1
        local thrust_fac_L = (get(thrust_engn_L) - 16000) / 334000
		local thrust_fac_R = (get(thrust_engn_R) - 16000) / 334000
        local tac_input = GetRudderTrim(thrust_fac_L, thrust_fac_R, rev_deployed, avg_cas, get(rud_trim_auto))
        if math.abs(tac_input - get(rud_trim_auto)) > 0.06 then
            set(rud_trim_auto, lim(tac_input, 17.8, -17.8))
        end
    else
        set(tac_fail, 1)
    end
end

function UpdateManPitchTrim()
    local avg_input = (get(pitch_trim_A) + get(pitch_trim_B)) / 2
    if math.abs(get(pitch_trim_altn)) == 1 then
        avg_input = get(pitch_trim_altn)
    end
    if math.abs(avg_input) == 1 then
        if get(on_ground) == 1 or get(fbw_mode) ~= 1 then
	    	if get(hyd_pressure, 2) * (1 - get(stab_cutout_C)) > 900 or get(hyd_pressure, 3) * (1 - get(stab_cutout_R)) > 900 then
	    		local tmp_val = lim(get(stab_trim) + 0.25 * get(f_time) * avg_input, 1, -1)
                set(stab_trim, tmp_val)
	    	end
	    else
            local tmp_val = lim(get(fbw_trim_speed) - 2 * get(f_time) * avg_input, 
                                get(max_allowable), get(maneuver_speed))
            set(fbw_trim_speed, tmp_val)
	    end
    end
end

function UpdateRudPedals()
    local trim_ratio = get(rud_trim_man) / 27
    local pedal_pos = getPosition(get(yoke_heading_ratio), trim_ratio, 1, 1)
    set(rud_pedals, pedal_pos)
end

function UpdateStabTrim()
    if isStabTrimOperative() == 1 and get(on_ground) == 0 and get(fbw_mode) == 1 then
        set(stab_trim, get(pfc_stab_trim_cmd))
    end
    set(ths_degrees, get(stab_trim) * -11)
end

ail_L = Control_surface:new{aces = {2, 3}, hyd_sys = {1, 2}, full_up = 33, full_dn = 19, mode = pcu_aileron}
ail_R = Control_surface:new{aces = {1, 4}, hyd_sys = {1, 2}, full_up = 33, full_dn = 19, mode = pcu_aileron}
flp_L = Control_surface:new{aces = {1, 4}, hyd_sys = {1, 3}, full_up = 11, full_dn = 37, mode = pcu_flaperon}
flp_R = Control_surface:new{aces = {2, 3}, hyd_sys = {2, 3}, full_up = 11, full_dn = 37, mode = pcu_flaperon}
sp_1 = Control_surface:new{aces = {3}, hyd_sys = {2}, full_up = 60, full_dn = 0, mode = pcu_sp}
sp_2 = Control_surface:new{aces = {1}, hyd_sys = {1}, full_up = 60, full_dn = 0, mode = pcu_sp}
sp_3 = Control_surface:new{aces = {4}, hyd_sys = {3}, full_up = 60, full_dn = 0, mode = pcu_sp}
sp_4 = Control_surface:new{aces = {2}, hyd_sys = {1}, full_up = 45, full_dn = 0, mode = pcu_sp}
sp_5 = Control_surface:new{aces = {2}, hyd_sys = {2}, full_up = 60, full_dn = 0, mode = pcu_sp}
elev_L = Control_surface:new{aces = {1, 3}, hyd_sys = {1, 2}, full_up = 33, full_dn = 27, mode = pcu_elevator}
elev_R = Control_surface:new{aces = {2, 4}, hyd_sys = {1, 3}, full_up = 33, full_dn = 27, mode = pcu_elevator}
rudder = Control_surface:new{aces = {1, 3, 4}, hyd_sys = {1, 2, 3}, full_up = 27, full_dn = 27, mode = pcu_rudder}

spoilers = {sp_1, sp_2, sp_3, sp_4, sp_5}
spoiler_fail = {ace_spoiler_fail_17, ace_spoiler_fail_2, ace_spoiler_fail_36, ace_spoiler_fail_4, ace_spoiler_fail_5}

function update()
    local avg_alt_baro = (get(altitude_pilot) + get(altitude_stdby) + get(altitude_copilot)) / 3
    local avg_cas = lim((get(cas_pilot) + get(cas_copilot)) / 2, 1000, 0)
    SetSpeedbrkHandle()
    UpdateSelfTest()
	DoSelfTest()
    sendFLTdata()
    UpdateSpoilers(avg_cas, spoilers, spoiler_fail, ace_spoiler, 0.32)
    UpdateRoll(avg_cas, avg_alt_baro, ail_L, ail_R, flp_L, flp_R)
    UpdateYaw(rudder)
    UpdatePitch(elev_L, elev_R)
    UpdateRudderTrim()
    UpdateRudPedals()
    UpdateManPitchTrim()
    UpdateStabTrim()
end

function onAirportLoaded()
    set(stab_trim, -0.46)
    --Disable pfc self test
	self_test_init = false
end

onAirportLoaded()