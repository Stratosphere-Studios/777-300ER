--[[
*****************************************************************************************
* Program Script Name: manipulators
* Author Name: remenkemi (crazytimtimtim)
* Script Description: functions for cockpit switches
* Notes: 1. Information on default datarefs for some switches provided.
         2. Can't find probe/window heat switches, might always be on? If so will command them on on aircraft load.
*****************************************************************************************
--]]
-- RUDDER TRIM KNOB IS IN FLIGHT INSTRUMENTS
--replace create_command
function deferred_command(name,desc,realFunc)
	return replace_command(name,realFunc)
end

--replace create_dataref
function deferred_dataref(name,nilType,callFunction)
   if callFunction~=nil then
      print("WARN:" .. name .. " is trying to wrap a function to a dataref -> use xlua")
   end
   return find_dataref(name)
end


--*************************************************************************************--
--**                            XTLUA GLOBAL VARIABLES                               **--
--*************************************************************************************--

--[[
SIM_PERIOD - this contains the duration of the current frame in seconds (so it is alway a
fraction).  Use this to normalize rates,  e.g. to add 3 units of fuel per second in a
per-frame callback you’d do fuel = fuel + 3 * SIM_PERIOD.

IN_REPLAY - evaluates to 0 if replay is off, 1 if replay mode is on
--]]


--*************************************************************************************--
--**                                 CREATE VARIABLES                                **--
--*************************************************************************************--

local B777_ctr1_button_target = {0, 0, 0, 0, 0}
local ailTrimPos = 1

--*************************************************************************************--
--**                               FIND X-PLANE DATAREFS                             **--
--*************************************************************************************--

simDR_startup_running                     = find_dataref("sim/operation/prefs/startup_running")
simDR_yoke_pitch                          = find_dataref("sim/cockpit2/controls/total_pitch_ratio")
simDR_yoke_roll                           = find_dataref("sim/cockpit2/controls/total_roll_ratio")
simDR_ap_heading                          = find_dataref("sim/cockpit/autopilot/heading_mag")
simDR_landing_light_switches              = find_dataref("sim/cockpit2/switches/landing_lights_switch")
simDR_taxi_light_switch                   = find_dataref("sim/cockpit2/switches/taxi_light_on")
simDR_strobe_light_switch                 = find_dataref("sim/cockpit2/switches/strobe_lights_on")
simDR_nav_light_switch                    = find_dataref("sim/cockpit2/switches/navigation_lights_on")
simDR_beacon_light_switch                 = find_dataref("sim/cockpit2/switches/beacon_on")
simDR_bus_volts                           = find_dataref("sim/cockpit2/electrical/bus_volts")
simDR_at_armed                            = find_dataref("sim/cockpit2/autopilot/autothrottle_arm")
simDR_fd_enabled                          = find_dataref("sim/cockpit2/autopilot/flight_director_mode")
simDR_wiper_switch                        = find_dataref("sim/cockpit2/switches/wiper_speed_switch")

--*************************************************************************************--
--**                              FIND CUSTOM DATAREFS                               **--
--*************************************************************************************--
B777DR_primary_hyd_pump_sw                = find_dataref("Strato/777/hydraulics/pump/primary/state")
B777DR_demand_hyd_pump_sw                 = find_dataref("Strato/777/hydraulics/pump/demand/state")
B777DR_gear_altn_extnsn_target            = find_dataref("Strato/777/gear/altn_extnsn")
--B777DR_hdg_mode                           = find_dataref("Strato/777/displays/hdg_mode")
B777DR_prk_brk_target                     = find_dataref("Strato/777/gear/park_brake")
B777DR_grd_pwr_primary                    = find_dataref("Strato/B777/ext_pwr")
B777DR_stab_cutout_C                      = find_dataref("Strato/777/fctl/stab_cutout_C")
B777DR_stab_cutout_R                      = find_dataref("Strato/777/fctl/stab_cutout_R")
B777DR_ace_tac_eng                        = find_dataref("Strato/777/fctl/ace/tac_eng")
B777DR_pfc_disc                           = find_dataref("Strato/777/fctl/pfc/disc")

--*************************************************************************************--
--**                              CUSTOM DATAREF HANDLERS                            **--
--*************************************************************************************--



--*************************************************************************************--
--**                              CREATE CUSTOM DATAREFS                             **--
--*************************************************************************************--

testNum                                   = deferred_dataref("testNum", "number")

B777DR_mcp_button_pos                     = deferred_dataref("Strato/777/cockpit/mcp/buttons/position", "array[18]")
B777DR_mcp_button_target                  = deferred_dataref("Strato/777/cockpit/mcp/buttons/target", "array[18]")

B777DR_ovhd_fwd_button_positions          = deferred_dataref("Strato/777/cockpit/ovhd/fwd/buttons/position", "array[20]")
B777DR_ovhd_ctr_button_positions          = deferred_dataref("Strato/777/cockpit/ovhd/ctr/buttons/position", "array[20]")
B777DR_ovhd_aft_button_positions          = deferred_dataref("Strato/777/cockpit/ovhd/aft/buttons/position", "array[20]")

B777DR_ovhd_ctr_button_target             = deferred_dataref("Strato/777/cockpit/ovhd/ctr/buttons/target", "array[46]")
B777DR_ovhd_aft_button_target             = deferred_dataref("Strato/777/cockpit/ovhd/aft/buttons/target", "array[24]")

B777DR_ctr1_button_pos                    = deferred_dataref("Strato/777/cockpit/ctr/fwd/buttons/position", "array[8]")

B777DR_ovhd_ctr_cover_positions           = deferred_dataref("Strato/777/cockpit/ovhd/ctr/button_cover/position", "array[5]")
B777DR_ovhd_aft_cover_positions           = deferred_dataref("Strato/777/cockpit/ovhd/aft/button_cover/position", "array[7]")
B777DR_main_cover_positions               = deferred_dataref("Strato/777/cockpit/main_pnl/button_cover/position", "array[5]")
B777DR_ctr_cover_positions                = deferred_dataref("Strato/777/cockpit/ctr/button_cover/position", "array[4]")

B777DR_ovhd_ctr_cover_target              = deferred_dataref("Strato/777/cockpit/ovhd/ctr/button_cover/target", "array[5]")
B777DR_ovhd_aft_cover_target              = deferred_dataref("Strato/777/cockpit/ovhd/aft/button_cover/target", "array[6]")
B777DR_main_cover_target                  = deferred_dataref("Strato/777/cockpit/main_pnl/button_cover/target", "array[5]")
B777DR_ctr_cover_target                   = deferred_dataref("Strato/777/cockpit/ctr/button_cover/target", "array[4]")

B777DR_cockpit_door_pos                   = deferred_dataref("Strato/777/cockpit_door_pos", "number")

B777DR_hyd_primary_switch_pos             = deferred_dataref("Strato/cockpit/ovhd/hyd/primary_pumps/button_pos", "array[4]")
B777DR_hyd_demand_switch_pos              = deferred_dataref("Strato/cockpit/ovhd/hyd/demand_pumps/button_pos", "array[4]")

B777DR_gear_altn_extnsn_pos               = deferred_dataref("Strato/777/gear_alt_extnsn_pos", "number")

B777DR_cockpit_panel_lights_brightness    = deferred_dataref("Strato/777/cockpit/cockpit_panel_lights", "array[6]")
B777DR_cockpit_panel_lights_knob_pos      = deferred_dataref("Strato/777/cockpit/cockpit_panel_lights_knob_pos", "array[6]")

B777DR_cockpit_door_target                = deferred_dataref("Strato/cockpit/door_target", "number")
B777DR_rudder_trim_ctr                    = deferred_dataref("Strato/777/cockpit/rudder_trim_ctr", "number")
B777DR_ail_trim                           = deferred_dataref("Strato/777/cockpit/ail_trim", "number")


--*************************************************************************************--
--**                              X-PLANE COMMAND HANDLERS                           **--
--*************************************************************************************--




--*************************************************************************************--
--**                               FIND X-PLANE COMMANDS                            **--
--*************************************************************************************--

simCMD_rudder_trim_ctr                   = find_command("sim/flight_controls/rudder_trim_center")
simCMD_ail_trim_r                        = find_command("sim/flight_controls/aileron_trim_right")
simCMD_ail_trim_l                        = find_command("sim/flight_controls/aileron_trim_left")

---MCP----------
simCMD_ap_servos_on                      = find_command("sim/autopilot/servos_on")
simCMD_ap_servos_on_2                    = find_command("sim/autopilot/servos2_on")
simCMD_ap_approach                       = find_command("sim/autopilot/approach")
simCMD_ap_hdgHold                        = find_command("sim/autopilot/heading_hold")
simCMD_ap_hdgSel                         = find_command("sim/autopilot/heading")
simCMD_ap_altArm                         = find_command("sim/autopilot/altitude_hold")
simCMD_ap_flch                           = find_command("sim/autopilot/level_change")
simCMD_ap_vs                             = find_command("sim/autopilot/vertical_speed")
simCMD_ap_lnav                           = find_command("sim/autopilot/gpss")
simCMD_ap_fms_vnav                       = find_command("sim/autopilot/FMS")
simCMD_ap_disco                          = find_command("sim/autopilot/disconnect")
simCMD_ap_loc                            = find_command("sim/autopilot/NAV")
simCMD_at_spd                            = find_command("sim/autopilot/autothrottle")
simCMD_at_clbcon                         = find_command("sim/autopilot/autothrottle_n1epr")
simCMD_at_off                            = find_command("sim/autopilot/autothrottle_off")

---OVERHEAD----------

--Forward-----


--Center-----

simCMD_ovhd_apu_gen_on                  = find_command("sim/electrical/APU_generator_on")
simCMD_ovhd_apu_gen_off                 = find_command("sim/electrical/APU_generator_off")
simCMD_ovhd_gen_1_on                    = find_command("sim/electrical/generator_1_on")
simCMD_ovhd_gen_1_off                   = find_command("sim/electrical/generator_1_off")
simCMD_ovhd_gen_2_on                    = find_command("sim/electrical/generator_2_on")
simCMD_ovhd_gen_2_off                   = find_command("sim/electrical/generator_2_off")

--Aft-----


---MISC----------

---CENTER PED----------
simCMD_toga                             = find_command("sim/autopilot/take_off_go_around")

--*************************************************************************************--
--**                                CUSTOM COMMAND HANDLERS                          **--
--*************************************************************************************--

---MCP----------

function B777_ap_engage_switch_1_CMDhandler(phase, duration)   -- A/P ENGAGE BUTTON L
   if phase == 0 then
      B777DR_mcp_button_target[1] = 1
      if B777DR_mcp_button_target[12] == 0 and simDR_yoke_pitch <= 0.25 and simDR_yoke_roll <= 0.25 then
         simCMD_ap_servos_on:once()
      end
   elseif phase == 2 then
      B777DR_mcp_button_target[1] = 0
   end
end

function B777_ap_engage_switch_2_CMDhandler(phase, duration)   -- A/P ENGAGE BUTTON R
   if phase == 0 then
      B777DR_mcp_button_target[2] = 1
      if B777DR_mcp_button_target[12] == 0 and simDR_yoke_pitch <= 0.25 and simDR_yoke_roll <= 0.25 then
         simCMD_ap_servos_on2:once()
      end
   elseif phase == 2 then
      B777DR_mcp_button_target[2] = 0
   end
end

function B777_ap_loc_switch_CMDhandler(phase, duration)        -- A/P LOCALIZER BUTTON
   if phase == 0 then
      B777DR_mcp_button_target[3] = 1
      simCMD_ap_loc:once()
   elseif phase == 2 then
      B777DR_mcp_button_target[3] = 0
   end
end

function B777_ap_app_switch_CMDhandler(phase, duration)        -- A/P APPROACH BUTTON
   if phase == 0 then
      B777DR_mcp_button_target[4] = 1
      simCMD_ap_approach:once()
   elseif phase == 2 then
      B777DR_mcp_button_target[4] = 0
   end
end

function B777_ap_altHold_switch_CMDhandler(phase, duration)    -- A/P ALTITUDE HOLD BUTTON
   if phase == 0 then
      B777DR_mcp_button_target[5] = 1
      simCMD_ap_altArm:once()
   elseif phase == 2 then
      B777DR_mcp_button_target[5] = 0
   end
end

function B777_ap_vs_switch_CMDhandler(phase, duration)         -- A/P VERTICAL SPEED BUTTON
   if phase == 0 then
      B777DR_mcp_button_target[6] = 1
      simCMD_ap_vs:once()
   elseif phase == 2 then
      B777DR_mcp_button_target[6] = 0
   end
end

function B777_ap_hdgHold_switch_CMDhandler(phase, duration)    -- A/P HEADING HOLD BUTTON
   if phase == 0 then
      B777DR_mcp_button_target[7] = 1
      if B777DR_hdg_mode == 0 then
         simCMD_ap_hdgHold:once()
      end
   elseif phase == 2 then
      B777DR_mcp_button_target[7] = 0
   end
end

function B777_ap_hdgSel_switch_CMDhandler(phase, duration)     -- A/P HEADING SELECT BUTTON
   if phase == 0 then
      B777DR_mcp_button_target[8] = 1
      simCMD_ap_hdgSel:once()
   elseif phase == 2 then
      B777DR_mcp_button_target[8] = 0
   end
end

function B777_ap_lnav_switch_CMDhandler(phase, duration)       -- A/P LNAV BUTTON
   if phase == 0 then
      B777DR_mcp_button_target[9] = 1
      simCMD_ap_lnav:once()
   elseif phase == 2 then
      B777DR_mcp_button_target[9] = 0
   end
end

function B777_ap_vnav_switch_CMDhandler(phase, duration)       -- A/P  VNAV BUTTON
   if phase == 0 then
      B777DR_mcp_button_target[10] = 1
      simCMD_ap_fms_vnav:once()
   elseif phase == 2 then
      B777DR_mcp_button_target[10] = 0
   end
end

function B777_ap_flch_switch_CMDhandler(phase, duration)       -- A/P FLCH (LEVEL CHANGE) BUTTON
   if phase == 0 then
      B777DR_mcp_button_target[11] = 1
      simCMD_ap_flch:once()
   elseif phase == 2 then
      B777DR_mcp_button_target[11] = 0
   end
end

function B777_ap_disengage_switch_CMDhandler(phase, duration)  -- A/P DISENGAGE BAR
   if phase == 0 then
      if B777DR_mcp_button_target[12] == 0 then
         simCMD_ap_disco:once()
      end
      B777DR_mcp_button_target[12] = 1 - B777DR_mcp_button_target[12]
   end
end

function B777_autothrottle_spd_switch_CMDhandler(phase, duration)
   if phase == 0 then
      simCMD_at_spd:once()
      B777DR_mcp_button_target[16] = 1
   elseif phase == 2 then
      B777DR_mcp_button_target[16] = 0
   end
end

function B777_autothrottle_clbcon_switch_CMDhandler(phase, duration)
   if phase == 0 then
      simCMD_at_clbcon:once()
      B777DR_mcp_button_target[17] = 1
   elseif phase == 2 then
      B777DR_mcp_button_target[17] = 0
   end
end

---OVERHEAD----------


--Forward-----


--Center-----


--Aft-----


---OTHER---------------

function B777_cockpit_door_CMDhandler(phase, duration)
   if phase == 0 then
      B777DR_cockpit_door_target = 1 - B777DR_cockpit_door_target
   end
end



---CENTER PEDESTAL FWD----------

function B777_ctr1_toga_CMDhandler(phase, duration)
   if phase == 0 then
      B777_ctr1_button_target[2] = 1
      simCMD_toga:once()
   elseif phase == 2 then
      B777_ctr1_button_target[2] = 0
   end
end

function B777_ctr1_at_disco_CMDhandler(phase, duration)
   if phase == 0 then
      B777_ctr1_button_target[1] = 1
      simCMD_at_off:once()
   elseif phase == 2 then
      B777_ctr1_button_target[1] = 0
   end
end

function ail_trim_r_CMDhandler(phase, duration)
   if phase ~= 2 then
      simCMD_ail_trim_r:once()
      ailTrimPos = 2
   else
      ailTrimPos = 1
   end
end

function ail_trim_l_CMDhandler(phase, duration)
   if phase ~= 2 then
      simCMD_ail_trim_l:once()
      ailTrimPos = 0
   else
      ailTrimPos = 1
   end
end
--*************************************************************************************--
--**                              CREATE CUSTOM COMMANDS                             **--
--*************************************************************************************--

---MCP----------

B777CMD_mcp_ap_engage_1                   = deferred_command("Strato/B777/button_switch/mcp/ap/engage_1", "Engage A/P 1", B777_ap_engage_switch_1_CMDhandler)
B777CMD_mcp_ap_engage_2                   = deferred_command("Strato/B777/button_switch/mcp/ap/engage_2", "Engage A/P 2", B777_ap_engage_switch_2_CMDhandler)
B777CMD_mcp_ap_disengage_switch           = deferred_command("Strato/B777/button_switch/mcp/ap/disengage", "Disengage A/P", B777_ap_disengage_switch_CMDhandler)

B777CMD_mcp_autothrottle_spd_mode         = deferred_command("Strato/B777/button_switch/mcp/autothrottle/spd", "Autothrottle Speed Mode", B777_autothrottle_spd_switch_CMDhandler)
B777CMD_mcp_autothrottle_clbcon_mode      = deferred_command("Strato/B777/button_switch/mcp/autothrottle/clbcon", "CLB/CON Mode", B777_autothrottle_clbcon_switch_CMDhandler)
--B777CMD_mcp_autothrottle_switch_2         = deferred_command("Strato/B777/button_switch/mcp/autothrottle/switch_2", "Autothrottle Switch 2", B777_autothrottle_switch_2_CMDhandler)

B777CMD_mcp_ap_loc                        = deferred_command("Strato/B777/button_switch/mcp/ap/loc", "Localizer A/P Mode", B777_ap_loc_switch_CMDhandler)
B777CMD_mcp_ap_app                        = deferred_command("Strato/B777/button_switch/mcp/ap/app", "Approach A/P Mode", B777_ap_app_switch_CMDhandler)
B777CMD_mcp_ap_altHold                    = deferred_command("Strato/B777/button_switch/mcp/ap/altHold", "Altitude Hold A/P Mode", B777_ap_altHold_switch_CMDhandler)
B777CMD_mcp_ap_vs                         = deferred_command("Strato/B777/button_switch/mcp/ap/vs", "Vertical Speed A/P Mode", B777_ap_vs_switch_CMDhandler)
B777CMD_mcp_ap_hdgHold                    = deferred_command("Strato/B777/button_switch/mcp/ap/hdgHold", "Heading Hold A/P Mode", B777_ap_hdgHold_switch_CMDhandler)
B777CMD_mcp_ap_hdgSel                     = deferred_command("Strato/B777/button_switch/mcp/ap/hdgSel", "Heading Select A/P Mode", B777_ap_hdgSel_switch_CMDhandler)
B777CMD_mcp_ap_lnav                       = deferred_command("Strato/B777/button_switch/mcp/ap/lnav", "LNAV A/P Mode", B777_ap_lnav_switch_CMDhandler)
B777CMD_mcp_ap_vnav                       = deferred_command("Strato/B777/button_switch/mcp/ap/vnav", "VNAV A/P Mode", B777_ap_vnav_switch_CMDhandler)
B777CMD_mcp_ap_flch                       = deferred_command("Strato/B777/button_switch/mcp/ap/flch", "FLCH A/P Mode", B777_ap_flch_switch_CMDhandler)

---OVERHEAD----------

--FORWARD-----

--LIGHT SWITCHES USE THEIR RESPECTIVE DEFAULT DATAREFS

--CENTER-----

-- RAM AIR TURBINE USES DEFAULT DATAREF: sim/cockpit2/switches/ram_air_turbine_on

--AFT-----

B777CMD_ail_trim_r                        = deferred_command("Strato/777/cockpit/ail_trim_r", "Aileron Trim ", ail_trim_r_CMDhandler)
B777CMD_ail_trim_l                        = deferred_command("Strato/777/cockpit/ail_trim_l", "Aileron Trim ", ail_trim_l_CMDhandler)

---MAIN PANEL----------

--GEAR LEVER USES DEFAULT DATAREF: sim/cockpit/switches/gear_handle_status

---CENTER PED 1 (FWD)----------

B777CMD_ctr1_at_disco                     = deferred_command("Strato/B777/button_switch/ctr1/at_disco", "Autothrottle Disconnect", B777_ctr1_at_disco_CMDhandler)
B777CMD_ctr1_toga                         = deferred_command("Strato/B777/button_switch/ctr1/toga", "TOGA switch", B777_ctr1_toga_CMDhandler)

---OTHER---------------

B777CMD_cockpit_door                      = deferred_command("Strato/B777/knob_switch/cockpit_door", "Cockpit Door Knob", B777_cockpit_door_CMDhandler)

--*************************************************************************************--
--**                                       CODE                                      **--
--*************************************************************************************--

----- ANIMATION UTILITY -----------------------------------------------------------------
function B777_animate(target, variable, speed)
   if math.abs(target - variable) < 0.1 then return target end
   variable = variable + ((target - variable) * (speed * SIM_PERIOD))
   return variable
end

function coverPhysics() -- moves switches under switch covers when switch covers are closed
   if B777DR_main_cover_positions[4] < 0.1 then -- manual gear extension
      B777DR_gear_altn_extnsn_target = 0
   end

   if B777DR_ctr_cover_positions[0] < 0.1 then
      B777DR_stab_cutout_C = 0
   end

   if B777DR_ctr_cover_positions[1] < 0.1 then
      B777DR_stab_cutout_R = 0
   end

   if B777DR_ovhd_aft_cover_target[0] < 0.1 then
      B777DR_pfc_disc = 0
   end
end

--*************************************************************************************--
--**                                    EVENT CALLBACKS                              **--
--*************************************************************************************--

function aircraft_load()
   print("manipulators loaded")
end

--function aircraft_unload()

function flight_start()
	if simDR_startup_running == 1 then
		B777DR_ovhd_ctr_button_target[1] = 1
      B777DR_ovhd_aft_button_target[1] = 1
	end
   simDR_at_armed = 0
end

--function flight_crash()

--function livery_load()

--function before_physics()

function after_physics()
   B777DR_kill_cabin = 1 - B777DR_cockpit_door_target
   B777DR_cockpit_door_pos = B777_animate(B777DR_cockpit_door_target, B777DR_cockpit_door_pos, 3)

   --[[for i = 1, 18 do
      if i ~= 15 or i ~= 13 then
         B777DR_mcp_button_pos[i] = B777_animate(B777DR_mcp_button_target[i], B777DR_mcp_button_pos[i], 20)
      end
   end]]
   B777DR_mcp_button_pos[15] = B777_animate(simDR_at_armed, B777DR_mcp_button_pos[15], 20)
   B777DR_mcp_button_pos[13] = B777_animate(simDR_fd_enabled, B777DR_mcp_button_pos[13], 20)

   for i = 1, 18 do
      if i ~= 15 or i ~= 13 then
         B777DR_mcp_button_pos[i] = B777DR_mcp_button_target[i]
      end
   end

   for i = 1, 5 do
      B777DR_ctr1_button_pos[i] = B777_animate(B777_ctr1_button_target[i], B777DR_ctr1_button_pos[i], 20)
   end
   B777DR_ctr1_button_pos[6] = B777_animate(B777DR_stab_cutout_C, B777DR_ctr1_button_pos[6], 20)
   B777DR_ctr1_button_pos[7] = B777_animate(B777DR_stab_cutout_R, B777DR_ctr1_button_pos[7], 20)

   B777DR_ovhd_aft_button_positions[1] = B777_animate(B777DR_ovhd_aft_button_target[1], B777DR_ovhd_aft_button_positions[1], 15)
   B777DR_ovhd_aft_button_positions[2] = B777_animate(B777DR_ace_tac_eng,  B777DR_ovhd_aft_button_positions[2], 15)
   B777DR_ovhd_aft_button_positions[3] = B777_animate(B777DR_pfc_disc,  B777DR_ovhd_aft_button_positions[3], 15)

   for i = 1, 5 do
      B777DR_ovhd_fwd_button_positions[i] = B777_animate(simDR_landing_light_switches[i], B777DR_ovhd_fwd_button_positions[i], 20)
   end
   B777DR_ovhd_fwd_button_positions[6] = B777_animate(simDR_taxi_light_switch, B777DR_ovhd_fwd_button_positions[6], 20)
   B777DR_ovhd_fwd_button_positions[7] = B777_animate(simDR_nav_light_switch, B777DR_ovhd_fwd_button_positions[7], 20)
   B777DR_ovhd_fwd_button_positions[8] = B777_animate(simDR_strobe_light_switch, B777DR_ovhd_fwd_button_positions[8], 20)
   B777DR_ovhd_fwd_button_positions[9] = B777_animate(simDR_beacon_light_switch, B777DR_ovhd_fwd_button_positions[9], 20)

   B777DR_ovhd_fwd_button_positions[10] = B777_animate(simDR_wiper_switch[0], B777DR_ovhd_fwd_button_positions[10], 20)
   B777DR_ovhd_fwd_button_positions[11] = B777_animate(simDR_wiper_switch[1], B777DR_ovhd_fwd_button_positions[11], 20)

   for i = 0, 3 do
      B777DR_hyd_primary_switch_pos[i] = B777_animate(B777DR_primary_hyd_pump_sw[i], B777DR_hyd_primary_switch_pos[i], 20)
   end

   for i = 0, 3 do
      B777DR_hyd_demand_switch_pos[i] = B777_animate(B777DR_demand_hyd_pump_sw[i], B777DR_hyd_demand_switch_pos[i], 20)
   end

   for i = 0, 5 do
      B777DR_ovhd_ctr_cover_positions[i] = B777_animate(B777DR_ovhd_ctr_cover_target[i], B777DR_ovhd_ctr_cover_positions[i], 15)
   end
   for i = 0, 6 do
         B777DR_ovhd_aft_cover_positions[i] = B777_animate(B777DR_ovhd_aft_cover_target[i], B777DR_ovhd_aft_cover_positions[i], 15)
   end
   for i = 0, 5 do
      B777DR_main_cover_positions[i] = B777_animate(B777DR_main_cover_target[i], B777DR_main_cover_positions[i], 15)
   end
   for i = 0, 4 do
      B777DR_ctr_cover_positions[i] = B777_animate(B777DR_ctr_cover_target[i], B777DR_ctr_cover_positions[i], 15)
   end

   B777DR_gear_altn_extnsn_pos = B777_animate(B777DR_gear_altn_extnsn_target, B777DR_gear_altn_extnsn_pos, 20)

   for i = 0, 5 do
      if simDR_bus_volts[0] >=5 or simDR_bus_volts[1] >=5 or simDR_bus_volts[2] >=5 then
         B777DR_cockpit_panel_lights_brightness[i] = B777DR_cockpit_panel_lights_knob_pos[i]
      else
         B777DR_cockpit_panel_lights_brightness[i] = 0
      end
   end

   B777DR_ail_trim = B777_animate(ailTrimPos, B777DR_ail_trim, 15)

   B777DR_ovhd_ctr_button_positions[0] = B777_animate(B777DR_grd_pwr_primary, B777DR_ctr_cover_positions[0], 10)

	coverPhysics()

   if B777DR_rudder_trim_ctr == 1 then
      simCMD_rudder_trim_ctr:once()
   end

end

--function after_replay()