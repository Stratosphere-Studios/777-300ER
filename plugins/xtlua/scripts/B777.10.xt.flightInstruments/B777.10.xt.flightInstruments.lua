--[[
*****************************************************************************************
* Script Name: flightInstruments
* Author Name: Crazytimtimtim
* Script Description: Code for cockpit instruments
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
 --**                             XTLUA GLOBAL VARIABLES                              **--
 --*************************************************************************************--
 
 --[[
 SIM_PERIOD - this contains the duration of the current frame in seconds (so it is alway a
 fraction).  Use this to normalize rates,  e.g. to add 3 units of fuel per second in a
 per-frame callback you’d do fuel = fuel + 3 * SIM_PERIOD.

 IN_REPLAY - evaluates to 0 if replay is off, 1 if replay mode is on
 --]]

--*************************************************************************************--
--**                                CREATE VARIABLES                                 **--
--*************************************************************************************--



--*************************************************************************************--
--**                              FIND X-PLANE DATAREFS                              **--
--*************************************************************************************--

simDR_magHDG                           = find_dataref("sim/cockpit/autopilot/heading_mag")
simDR_trueHDG                          = find_dataref("sim/cockpit/autopilot/heading")

simDR_com1_stby_khz                    = find_dataref("sim/cockpit2/radios/actuators/com1_standby_frequency_khz")
simDR_com1_act_khz                     = find_dataref("sim/cockpit2/radios/actuators/com1_frequency_khz")

simDR_com2_stby_khz                    = find_dataref("sim/cockpit2/radios/actuators/com2_standby_frequency_khz")
simDR_com2_act_khz                     = find_dataref("sim/cockpit2/radios/actuators/com2_frequency_khz")


--*************************************************************************************--
--**                             CUSTOM DATAREF HANDLERS                             **--
--*************************************************************************************--



--*************************************************************************************--
--**                              CREATE CUSTOM DATAREFS                             **--
--*************************************************************************************--

B777DR_displayed_hdg                   = deferred_dataref("Strato/777/displays/hdg", "number") -- what the MCP heading display actually shows
B777DR_hdg_mode                        = deferred_dataref("Strato/777/displays/hdg_mode", "number") -- whether it is showing the magnetic heading or true heading

B777DR_eicas_mode                      = deferred_dataref("Strato/777/displays/eicas_mode", "number") -- what pages the lower eicas is on

B777DR_displayed_com1_act_khz          = deferred_dataref("Strato/777/displays/com1_act_khz", "number") -- COM1 Radio Active Display
B777DR_displayed_com1_stby_khz         = deferred_dataref("Strato/777/displays/com1_stby_khz", "number") -- COM1 Radio Standby Display

B777DR_displayed_com2_act_khz          = deferred_dataref("Strato/777/displays/com2_act_khz", "number") -- COM2 Radio Active Display
B777DR_displayed_com2_stby_khz         = deferred_dataref("Strato/777/displays/com2_stby_khz", "number") -- COM2 Radio Standby Display

--*************************************************************************************--
--**                             X-PLANE COMMAND HANDLERS                            **--
--*************************************************************************************--



--*************************************************************************************--
--**                                 X-PLANE COMMANDS                                **--
--*************************************************************************************--



--*************************************************************************************--
--**                             CUSTOM COMMAND HANDLERS                             **--
--*************************************************************************************--

function B777_mcp_magTRK_CMDhandler(phase, duration)
	if phase == 1 then
		B777_hdg_mode = 1 - B777DR_hdg_mode
	end
end

 --*************************************************************************************--
 --**                             CREATE CUSTOM COMMANDS                               **--
 --*************************************************************************************--

 B777CMD_mcp_MAGtrk                   = deferred_command("Strato/B777/button_switch/mcp/MAGtrk", "Switch between true and magnetic heading", B777_mcp_magTRK_CMDhandler)


 --*************************************************************************************--
 --**                                      CODE                                       **--
 --*************************************************************************************--

--Clocks

--Lower Eicas


 --*************************************************************************************--
 --**                                  EVENT CALLBACKS                                **--
 --*************************************************************************************--

function aircraft_load()
	print("flightIinstruments loaded")
end

--function aircraft_unload()

function flight_start()
	B777DR_eicas_mode = 4
end

--function flight_crash()

--function before_physics()

function after_physics()
	if B777DR_hdg_mode == 0 then
		B777DR_displayed_hdg = simDR_magHDG
	elseif B777DR_hdg_mode == 1 then
		B777DR_displayed_hdg = math.floor(simDR_trueHDG)
	end

	B777DR_displayed_com1_act_khz = simDR_com1_act_khz / 1000
	B777DR_displayed_com1_stby_khz = simDR_com1_stby_khz / 1000

	B777DR_displayed_com2_act_khz = simDR_com2_act_khz / 1000
	B777DR_displayed_com2_stby_khz = simDR_com2_stby_khz / 1000

end

--function after_replay()