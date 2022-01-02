--[[
*****************************************************************************************
* Program Script Name: manipulators
* Author Name: crazytimtimtim
* Script Description: functions for cockpit switches
* Notes: 1. Information on default datarefs for some switched provided.
         2. Can't find probe/window heat switches, might always be on? If so will command them on on aircraft load.
         3. Need to figure out number of buses to do bus cross-ties.
         4. Need to know a bit more about different types of manipulators in X-Plane2Blender
         5. Need to figure out how to code knobs and dials
*****************************************************************************************
--]]

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

local B777_cockpit_door_target = 0

--*************************************************************************************--
--**                               FIND X-PLANE DATAREFS                             **--
--*************************************************************************************--

simDR_shadow			                     = find_dataref("sim/private/controls/shadow/total_fade_ratio")

--*************************************************************************************--
--**                              CUSTOM DATAREF HANDLERS                            **--
--*************************************************************************************--



--*************************************************************************************--
--**                              CREATE CUSTOM DATAREFS                             **--
--*************************************************************************************--

B777DR_mcp_button_pos                     = deferred_dataref("Strato/777/cockpit/mcp/buttons/position", "array[18]")
B777DR_mcp_button_target                  = deferred_dataref("Strato/777/cockpit/mcp/buttons/target", "array[18]")

B777DR_efis_button_positions              = deferred_dataref("Strato/777/cockpit/efis/buttons/position", "array[10]")

B777DR_ovhd_fwd_button_positions          = deferred_dataref("Strato/777/cockpit/ovhd/fwd/buttons/position", "array[20]")
B777DR_ovhd_ctr_button_positions          = deferred_dataref("Strato/777/cockpit/ovhd/ctr/buttons/position", "array[20]")
B777DR_ovhd_aft_button_positions          = deferred_dataref("Strato/777/cockpit/ovhd/aft/buttons/position", "array[20]")

B777DR_button_cover_positions             = deferred_dataref("Strato/777/cockpit/button_cover/position", "array[16]")

B777DR_cockpit_door_pos                   = deferred_dataref("Strato/777/cockpit_door_pos", "number")

--*************************************************************************************--
--**                              X-PLANE COMMAND HANDLERS                           **--
--*************************************************************************************--



--*************************************************************************************--
--**                               FIND X-PLANE COMMANDS                            **--
--*************************************************************************************--

---MCP----------
simCMD_ap_servos_on                      = find_command("sim/autopilot/servos_on")
simCMD_ap_servos_on_2                    = find_command("sim/autopilot/servos2_on")
simCMD_ap_approach                       = find_command("sim/autopilot/approach")
simCMD_ap_hdgHold                        = find_command("sim/autopilot/heading_hold")
simCMD_ap_hdgSel                         = find_command("sim/autopilot/heading")
simCMD_ap_altArm                         = find_command("sim/autopilot/altitude_arm")
simCMD_ap_flch                           = find_command("sim/autopilot/level_change")
simCMD_ap_vs                             = find_command("sim/autopilot/vertical_speed")
simCMD_ap_lnav                           = find_command("sim/autopilot/gpss")
simCMD_ap_vnav                           = find_command("sim/autopilot/FMS")
simCMD_ap_disco                          = find_command("sim/autopilot/disconnect")
simCMD_at_spd                            = find_command("sim/autopilot/autothrottle")
simCMD_at_clbcon                         = find_command("sim/autopilot/autothrottle_n1epr")
--[[simCMD_fd_capt_on                        = find_command("sim/autopilot/fdir_on")
simCMD_fd_capt_off                       = find_command("sim/autopilot/servos_fdir_off")
simCMD_fd_fo_on                          = find_command("sim/autopilot/fdir2_on")
simCMD_fd_fo_off                         = find_command("sim/autopilot/servos_fdir2_off")]]
simCMD_fd_capt                           = find_command("sim/autopilot/fdir_toggle")
simCMD_fd_fo                             = find_command("sim/autopilot/fdir2_toggle")

---EFIS----------
simCMD_efis_wxr                          = find_command("sim/instruments/EFIS_wxr")
simCMD_efis_tfc                          = find_command("sim/instruments/EFIS_tcas")
simCMD_efis_fix                          = find_command("sim/instruments/EFIS_fix")
simCMD_efis_vor                          = find_command("sim/instruments/EFIS_vor")
simCMD_efis_apt                          = find_command("sim/instruments/EFIS_apt")


---OVERHEAD----------

--Forward-----


--Center-----

simCMD_ovhd_bat_toggle                  = find_command("sim/electrical/batteries_toggle")
simCMD_ovhd_apu_gen_on                  = find_command("sim/electrical/APU_generator_on")
simCMD_ovhd_apu_gen_off                 = find_command("sim/electrical/APU_generator_off")
simCMD_ovhd_gen_1_on                    = find_command("sim/electrical/generator_1_on")
simCMD_ovhd_gen_1_off                   = find_command("sim/electrical/generator_1_off")
simCMD_ovhd_gen_2_on                    = find_command("sim/electrical/generator_2_on")
simCMD_ovhd_gen_2_off                   = find_command("sim/electrical/generator_2_off")

--Aft-----


---MISC----------


--*************************************************************************************--
--**                                CUSTOM COMMAND HANDLERS                          **--
--*************************************************************************************--

---MCP----------

function B777_ap_engage_switch_1_CMDhandler(phase, duration)   -- A/P ENGAGE BUTTON L
   if phase == 0 then
      B777DR_mcp_button_target[1] = 1
      if B777DR_mcp_button_target[12] == 0 then
         simCMD_ap_servos_on:once()
      end
   elseif phase == 2 then
      B777DR_mcp_button_target[1] = 0
   end
end

function B777_ap_engage_switch_2_CMDhandler(phase, duration)   -- A/P ENGAGE BUTTON R
   if phase == 0 then
      B777DR_mcp_button_target[2] = 1
      if B777DR_mcp_button_target[12] == 0 then
         simCMD_ap_servos_on2:once()
      end
   elseif phase == 2 then
      B777DR_mcp_button_target[2] = 0
   end
end

function B777_ap_loc_switch_CMDhandler(phase, duration)        -- A/P LOCALIZER BUTTON
   if phase == 0 then
      B777DR_mcp_button_target[3] = 1                       --TODO: FIND CMD
--      B777CMD_ap_servos_on:once()
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
      simCMD_ap_hdgHold:once()
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
      simCMD_ap_vnav:once()
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

function B777_fd_capt_CMDhandler(phase, duration)              -- CAPTAIN F/D SWITCH
   if phase == 0 then
      B777DR_mcp_button_target[13] = 1- B777DR_mcp_button_target[13]
      simCMD_fd_capt:once()
   end
end

--[[function B777_fd_capt_up_CMDhandler(phase, duration)              -- CAPTAIN F/D SWITCH
   if phase == 0 then
         simCMD_fd_capt_on:once()
         B777DR_mcp_button_target[13] = 1
   end
end]]

function B777_fd_fo_CMDhandler(phase, duration)              -- CAPTAIN F/D SWITCH
   if phase == 0 then
      B777DR_mcp_button_target[14] = 1 - B777DR_mcp_button_target[14]
      simCMD_fd_fo:once()
   end
end

--[[function B777_fd_fo_up_CMDhandler(phase, duration)              -- CAPTAIN F/D SWITCH
   if phase == 0 then
         simCMD_fd_fo_on:once()
         B777DR_mcp_button_target[14] = 1
   end
end]]

function B777_autothrottle_switch_CMDhandler(phase, duration)
   if phase == 0 then
      B777DR_mcp_button_target[15] = 1 - B777DR_mcp_button_target[15]
   end
end

function B777_autothrottle_spd_switch_CMDhandler(phase, duration)
   if phase == 0 then
      if B777DR_mcp_button_target[15] == 1 then
         simCMD_at_spd:once()
      end
      B777DR_mcp_button_target[16] = 1
   elseif phase == 2 then
      B777DR_mcp_button_target[16] = 0
   end
end

function B777_autothrottle_clbcon_switch_CMDhandler(phase, duration)
   if phase == 0 then
      if B777DR_mcp_button_target[15] == 1 then
         simCMD_at_clbcon:once()
      end
      B777DR_mcp_button_target[17] = 1
   elseif phase == 2 then
      B777DR_mcp_button_target[17] = 0
   end
end

---EFIS----------

function B777_efis_wxr_switch_CMDhandler(phase, duration)
   if phase == 0 then
      B777DR_efis_button_positions[1] = 1
      simCMD_efis_wxr:once()
   elseif phase == 2 then
      B777DR_efis_button_positions[1] = 0
   end
end

--TODO: GET THESE DONE, ALONG WITH AUTOTHROTTLE

function B777_efis_sta_switch_CMDhandler(phase, duration)
   if phase == 0 then
      B777DR_efis_button_positions[2] = 1
      simCMD_efis_vor:once()
   elseif phase == 2 then
      B777DR_efis_button_positions[2] = 0
   end
end

function B777_efis_wpt_switch_CMDhandler(phase, duration)
   if phase == 0 then
      B777DR_efis_button_positions[3] = 1
      simCMD_efis_fix:once()
   elseif phase == 2 then
      B777DR_efis_button_positions[3] = 0
   end
end

function B777_efis_tfc_switch_CMDhandler(phase, duration)
   if phase == 0 then
      B777DR_efis_button_positions[4] = 1
      simCMD_EFIS_tcas:once()
   elseif phase == 2 then
      B777DR_efis_button_positions[4] = 0
   end
end

function B777_efis_apt_switch_CMDhandler(phase, duration)
   if phase == 0 then
      B777DR_efis_button_positions[6] = 1
      simCMD_efis_apt:once()
   elseif phase == 2 then
      B777DR_efis_button_positions[6] = 0
   end
end


---OVERHEAD----------


--Forward-----


--Center-----

function B777_ovhd_c_batt_switch_CMDhandler(phase, duration)
   if phase == 0 then
      B777DR_ovhd_ctr_button_positions[1] = 1 - B777DR_ovhd_ctr_button_positions[1]
      simCMD_ovhd_bat_toggle:once()
   end
end

function B777_ovhd_c_apu_gen_switch_CMDhandler(phase, duration)
   if phase == 0 then
      if B777DR_ovhd_ctr_button_positions[2] == 0 then
         simCMD_ovhd_apu_gen_on:once()
         B777DR_ovhd_ctr_button_positions[2] = 1
      elseif B777DR_ovhd_ctr_button_positions[2] == 1 then
         simCMD_ovhd_apu_gen_off:once()
         B777DR_ovhd_ctr_button_positions[2] = 0
      end
   end
end

--TODO: FIX BUS TIES
-- a = 1 - a trick not used because switch could be inverted

function B777_ovhd_c_bus_tie_l_switch_CMDhandler(phase, duration)
   if phase == 0 then
      B777DR_ovhd_ctr_button_positions[3] = 1 - B777DR_ovhd_ctr_button_positions[3]
      if B777DR_ovhd_ctr_button_positions[3] == 0 then
         B777DR_ovhd_ctr_button_positions[3] = 1
      elseif B777DR_ovhd_ctr_button_positions[3] == 1 then
         B777DR_ovhd_ctr_button_positions[3] = 0
      end
   end
end

function B777_ovhd_c_bus_tie_r_switch_CMDhandler(phase, duration)
   if phase == 0 then
      if B777DR_ovhd_ctr_button_positions[4] == 0 then
         B777DR_ovhd_ctr_button_positions[4] = 1
      elseif B777DR_ovhd_ctr_button_positions[4] == 1 then
         B777DR_ovhd_ctr_button_positions[4] = 0
      end
   end
end


function B777_ovhd_c_eng_gen_l_switch_CMDhandler(phase, duration)
   if phase == 0 then
      if B777DR_ovhd_ctr_button_positions[5] == 0 then
         simCMD_ovhd_gen_1_on:once()
         B777DR_ovhd_ctr_button_positions[5] = 1
      elseif B777DR_ovhd_ctr_button_positions[5] == 1 then
         simCMD_ovhd_gen_1_off:once()
         B777DR_ovhd_ctr_button_positions[5] = 0
      end
   end
end

function B777_ovhd_c_eng_gen_r_switch_CMDhandler(phase, duration)
   if phase == 0 then
      if B777DR_ovhd_ctr_button_positions[6] == 0 then
         simCMD_ovhd_gen_2_on:once()
         B777DR_ovhd_ctr_button_positions[6] = 1
      elseif B777DR_ovhd_ctr_button_positions[6] == 1 then
         simCMD_ovhd_gen_2_off:once()
         B777DR_ovhd_ctr_button_positions[6] = 0
      end
   end
end

--Aft-----

---OTHER---------------

function B777_cockpit_door_CMDhandler(phase, duration)
   if phase == 0 then
      B777_cockpit_door_target = 1 - B777DR_cockpit_door_pos
   end
end

--*************************************************************************************--
--**                              CREATE CUSTOM COMMANDS                             **--
--*************************************************************************************--

---MCP----------

B777CMD_mcp_ap_engage_1                   = deferred_command("Strato/B777/button_switch/mcp/ap/engage_1", "Engage A/P 1", B777_ap_engage_switch_1_CMDhandler)
B777CMD_mcp_ap_engage_2                   = deferred_command("Strato/B777/button_switch/mcp/ap/engage_2", "Engage A/P 2", B777_ap_engage_switch_2_CMDhandler)
B777CMD_mcp_ap_disengage_switch           = deferred_command("Strato/B777/button_switch/mcp/ap/disengage", "Disengage A/P", B777_ap_disengage_switch_CMDhandler)

B777CMD_mcp_flightdirector_capt           = deferred_command("Strato/B777/button_switch/mcp/fd/capt", "Captain Flight Director Switch", B777_fd_capt_CMDhandler)
--B777CMD_mcp_flightdirector_capt_off       = deferred_command("Strato/B777/button_switch/mcp/fd/capt/off", "Captain Flight Director Switch Off", B777_fd_capt_dn_CMDhandler)

B777CMD_mcp_flightdirector_fo             = deferred_command("Strato/B777/button_switch/mcp/fd/fo", "F/O Flight Director Switch", B777_fd_fo_CMDhandler)
--B777CMD_mcp_flightdirector_fo_off         = deferred_command("Strato/B777/button_switch/mcp/fd/fo/off", "F/O Flight Director Switch Off", B777_fd_fo_dn_CMDhandler)

B777CMD_mcp_autothrottle_switch           = deferred_command("Strato/B777/button_switch/mcp/autothrottle/switch_1", "Autothrottle Switch 1", B777_autothrottle_switch_CMDhandler)
B777CMD_mcp_autothrottle_spd_mode         = deferred_command("Strato/B777/button_switch/mcp/autothrottle/spd", "Autothrottle Speed Mode", B777_autothrottle_spd_switch_CMDhandler)
B777CMD_mcp_autothrottle_spd_mode         = deferred_command("Strato/B777/button_switch/mcp/autothrottle/clbcon", "CLB/CON Mode", B777_autothrottle_clbcon_switch_CMDhandler)
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


---EFIS CONTROL----------

B777CMD_efis_wxr_button                   = deferred_command("Strato/B777/button_switch/efis/wxr", "ND Weather Radar Button", B777_efis_wxr_switch_CMDhandler)
B777CMD_efis_sta_button                   = deferred_command("Strato/B777/button_switch/efis/sta", "ND STA Button", B777_efis_sta_switch_CMDhandler)
B777CMD_efis_wpt_button                   = deferred_command("Strato/B777/button_switch/efis/wpt", "ND Waypoint Button", B777_efis_wpt_switch_CMDhandler)
B777CMD_efis_tfc_button                   = deferred_command("Strato/B777/button_switch/efis/tfc", "ND Traffic Button", B777_efis_tfc_switch_CMDhandler)
B777CMD_efis_apt_button                   = deferred_command("Strato/B777/button_switch/efis/apt", "ND Airport Button", B777_efis_apt_switch_CMDhandler)

---OVERHEAD----------

--FORWARD-----

--LIGHT SWITCHES USE THEIR RESPECTIVE DEFAULT DATAREFS

--CENTER-----

B777CMD_ovhd_c_batt_button                = deferred_command("Strato/B777/button_switch/ovhd_c/batt", "Battery Switch", B777_ovhd_c_batt_switch_CMDhandler)
B777CMD_ovhd_c_apu_gen_button             = deferred_command("Strato/B777/button_switch/ovhd_c/apu_gen", "APU Generator Switch", B777_ovhd_c_apu_gen_switch_CMDhandler)

B777CMD_ovhd_c_eng_gen_l_button           = deferred_command("Strato/B777/button_switch/ovhd_c/eng_gen1", "L Engine Generator Switch", B777_ovhd_c_eng_gen_l_switch_CMDhandler)
B777CMD_ovhd_c_eng_gen_r_button           = deferred_command("Strato/B777/button_switch/ovhd_c/eng_gen2", "R Engine Generator Switch", B777_ovhd_c_eng_gen_r_switch_CMDhandler)
--B777CMD_ovhd_c_bus_tie_l_button           = deferred_command("Strato/B777/button_switch/ovhd_c/apu_gen", "L Bus Tie Switch", B777_ovhd_c_bus_tie_l_switch_CMDhandler)
--B777CMD_ovhd_c_bus_tie_r_button           = deferred_command("Strato/B777/button_switch/ovhd_c/apu_gen", "R Bus Tie Switch", B777_ovhd_c_bus_tie_r_switch_CMDhandler)
--B777CMD_ovhd_c_ext_pwr_button             = deferred_command("Strato/B777/button_switch/ovhd_c/apu_gen", "External Power Switch", B777_ovhd_c_ext_pwr_switch_CMDhandler)
--EXTERNAL POWER IS IN ELECTRICAL MODULE

-- RAM AIR TURBINE USES DEFAULT DATAREF: sim/cockpit2/switches/ram_air_turbine_on

--AFT-----


---MAIN PANEL----------

--GEAR LEVER USES DEFAULT DATAREF: sim/cockpit/switches/gear_handle_status

---OTHER---------------

B777CMD_cockpit_door                      = deferred_command("Strato/B777/knob_switch/cockpit_door", "Cockpit Door Knob", B777_cockpit_door_CMDhandler)

--*************************************************************************************--
--**                                       CODE                                      **--
--*************************************************************************************--

----- ANIMATION UTILITY -----------------------------------------------------------------
function B777_set_animation_position(current_value, target, min, max, speed)

   local fps_factor = math.min(1.0, speed * SIM_PERIOD)

   if target >= (max - 0.001) and current_value >= (max - 0.01) then
      return max
   elseif target <= (min + 0.001) and current_value <= (min + 0.01) then
      return min
   else
      return current_value + ((target - current_value) * fps_factor)
   end

end


----- TERNARY CONDITIONAL ---------------------------------------------------------------
function B777_ternary(condition, ifTrue, ifFalse)
   if condition then return ifTrue else return ifFalse end
end

----- RESCALE ---------------------------------------------------------------------------
function B777_rescale(in1, out1, in2, out2, x)

   if x < in1 then return out1 end
   if x > in2 then return out2 end
   return out1 + (out2 - out1) * (x - in1) / (in2 - in1)

end

--*************************************************************************************--
--**                                    EVENT CALLBACKS                              **--
--*************************************************************************************--

function aircraft_load()
   print("manipulators loaded")
end

--function aircraft_unload()

function flight_start()
   print("Lua Loaded")
   simDR_shadow = 0.8
end

function flight_crash()
   print("Bruh, why did you crash? Noob. Learn to fly.")
end

--function before_physics()

function after_physics()
   B777DR_cockpit_door_pos = B777_set_animation_position(B777DR_cockpit_door_pos, B777_cockpit_door_target, 0.0, 1.0, 4)

   for i = 1, 18 do
      B777DR_mcp_button_pos[i] = B777_set_animation_position(B777DR_mcp_button_pos[i], B777DR_mcp_button_target[i], 0.0, 1.0, 10)
   end

end

--function after_replay()