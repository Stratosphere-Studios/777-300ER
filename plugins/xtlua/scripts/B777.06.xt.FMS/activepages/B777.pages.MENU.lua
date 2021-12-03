--[[
*****************************************************************************************
* Script Name: Electrical
* Author Name: @nathroxer001
* Script Description: Code for fms
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

simDR_battery                          = find_dataref("sim/flightmodel2/electrical/battery1_on")
myLine                                 = find_dataref("laminar/B747/fms1/Line01_L")

--*************************************************************************************--
--**                             CUSTOM DATAREF HANDLERS                             **--
--*************************************************************************************--



--*************************************************************************************--
--**                              CREATE CUSTOM DATAREFS                             **--
--*************************************************************************************--

var = create_dataref("Strato/B777/cockpit/fmc_1", "string")

--*************************************************************************************--
--**                             X-PLANE COMMAND HANDLERS                            **--
--*************************************************************************************--



--*************************************************************************************--
--**                                 X-PLANE COMMANDS                                **--
--*************************************************************************************--



--*************************************************************************************--
--**                             CUSTOM COMMAND HANDLERS                             **--
--*************************************************************************************--

function B777_bat_CMDhandler(phase, duration)
  if simDR_battery == 1 then
      simDR_flaps = find_dataref("sim/flightmodel2/wing/flap1_deg")
      simDR_flaps = 30
      print("Flaps set")
  end
end

--*************************************************************************************--
--**                             CREATE CUSTOM COMMANDS                               **--
--*************************************************************************************--

B777CMD_bat           = deferred_command("Strato/B777/cockpit/bat_on", "External Power Switch", B777_bat_CMDhandler)

--*************************************************************************************--
--**                                      CODE                                       **--
--*************************************************************************************--



--*************************************************************************************--
--**                                  EVENT CALLBACKS                                **--
--*************************************************************************************--

function aircraft_load()

myLine= "hello world"


fmsPages["MENU"]=createPage("Menu")
fmsPages["MENU"]["template"]={

"          MENU          ",
"                        ",
"<FMC      <ACT>         ",
"                        ",
"                        ",
"                        ",
"                        ",
"                <CREDITS",
"                        ",
"                        ",
"                        ",
"                        ",
"                        "
}


fmsFunctionsDefs["MENU"]={}

fmsFunctionsDefs["MENU"]["L1"]={"setpage","FMC"}
fmsFunctionsDefs["MENU"]["R6"]={"setpage","CREDITS"}

laminar/B747/fms1/Line01_L = "I tried ._."