--[[
B777DR_airspeed_V1                              = deferred_dataref("Strato/B777/airspeed/V1", "number")
B777DR_airspeed_Vr                              = deferred_dataref("Strato/B777/airspeed/Vr", "number")
B777DR_airspeed_V2                              = deferred_dataref("Strato/B777/airspeed/V2", "number")
cg_lineLg	= ""
cg_lineSm	= ""
clbF_Sm = ""

function roundToIncrement(number, increment)

    local y = number / increment
    local q = math.floor(y + 0.5)
    local z = q * increment

    return z

end
--simDR_wing_flap1_deg                = find_dataref("sim/flightmodel2/wing/flap1_deg")
B777DR_airspeed_flapsRef                              = find_dataref("Strato/B777/airspeed/flapsRef")
fmsPages["TAKEOFF"]=createPage("TAKEOFF")
fmsPages["TAKEOFF"].getPage=function(self,pgNo,fmsID)--dynamic pages need to be this way
  local flaps = string.format("%02d",roundToIncrement(B777DR_airspeed_flapsRef, 5))
  if B777DR_airspeed_flapsRef==0 then flaps="**" end
  local v1="---"
  local vr="---"
  local v2="---"
  local clbV=" "
  --local clbF="FLAPS 5 "
  --local clbF=string.format("%-8s", "1500FT")
  --local clbF=string.format("%-8s", "FLAPS 5")
  local clbF=string.format("%-8s", "")
  if clbderate>0 then
    clbV=""..clbderate
  end
	--Marauder28
	if string.len(cg_lineLg) == 0 then
		if fmsModules["data"].cg_mac == "--" then
			cg_lineSm = string.format("%s%%", fmsModules["data"].cg_mac)
		else
			cg_lineSm = string.format("%2.0f%%>", fmsModules["data"].cg_mac)
		end
	else
		cg_lineLg = string.format("%2.0f%%", tonumber(fmsModules["data"].cg_mac))
		cg_lineSm = ""
	end
	--Marauder28

  if B777DR_airspeed_V1<998 then
    v1=B777DR_airspeed_V1
    vr=B777DR_airspeed_Vr
    v2=B777DR_airspeed_V2
  
      return{

  "      TAKEOFF REF       ",
  "                        ",
  flaps.. string.format("                   %3d", v1),
  "                        ",
  string.format("                     %3d", vr),
  "                        ",
  string.format("%s CLB %1s       %3d",clbF,clbV, v2),
  "                        ",
  "                     "..cg_lineLg,
  "                        ",
  "            RW***       ", 
  "-----------------       ",
  "<INDEX         POS INIT>"
      }
  else
    return{

  "      TAKEOFF REF       ",
  "                        ",
  flaps..string.format("                   ---"),
  "                        ",
  string.format("                     ---"),
  "                        ",
  string.format("%s CLB %1s       ---",clbF,clbV),
  "                        ",
  "                     "..cg_lineLg,
  "                        ",
  "            RW***       ", 
  "-----------------       ",
  "<INDEX         POS INIT>"}
    end
  
end

fmsPages["TAKEOFF"].getSmallPage=function(self,pgNo,fmsID)

  --Marauder28
  local stab_trim = ""
  
  if string.len(cg_lineLg) > 0 then
	  if fmsModules["data"].stab_trim ~= "    " then
			stab_trim = string.format("%3.1f", tonumber(fmsModules["data"].stab_trim))
	  else
			stab_trim = fmsModules["data"].stab_trim
	  end
  end
  --Marauder28

  clbF_Sm = string.format("%-8s", "FLAPS 5")
  
    return{

"                        ",
" FLAP/ACCEL HT    REF V1",
"  /1500FT               ",
" E/O ACCEL HT     REF VR",
"1500FT                  ",
" THR REDUCTION    REF V2",
clbF_Sm.."                 ",
--"                        ",
"               TRIM   CG",
--"                        ",
"                "..stab_trim.."     "..cg_lineSm,
"               POS SHIFT",
"                   --00M", 
"-----------------PRE-FLT",
"                        "
    }
end


fmsFunctionsDefs["TAKEOFF"]={}

fmsFunctionsDefs["TAKEOFF"]["R1"]={"setDref","V1"}
fmsFunctionsDefs["TAKEOFF"]["R2"]={"setDref","VR"}
fmsFunctionsDefs["TAKEOFF"]["R3"]={"setDref","V2"}
fmsFunctionsDefs["TAKEOFF"]["R4"]={"setdata","cg_mac"}
fmsFunctionsDefs["TAKEOFF"]["L1"]={"setDref","flapsRef"}]]

fmsPages["TAKEOFF"]=createPage("TAKEOFF")
fmsPages["TAKEOFF"].getPage=function(self,pgNo,fmsID)
  if pgNo == 1 then
    return{
      "      TAKEOFF REF       ",
      "                        ",
      "**                   ---",
      "                        ",
      "                     ---",
      "                        ",
      "**%                  ---",
      "                        ",
      "                        ",
      "                        ",
      "                     ON;g2>",
      "                        ",
      "<INDEX         POS INIT>"
    }
  end
end

fmsPages["TAKEOFF"].getSmallPage=function(self,pgNo,fmsID)
  return{
    "                    1/2 ",
    " FLAPS                V1",
    "                        ",
    " THRUST               VR",
    "                        ",
    " CG                   V2",
    "                        ",
    " RWY/POS    GR WT   TOGW",
    "                        ",
    " TAKEOFF DATA   REF SPDS",
    "               OFF<->   ",
    "------------------------",
    "                        "
  }
end

fmsPages["TAKEOFF"].getNumPages=function(self)
	return 1
end

fmsFunctionsDefs["TAKEOFF"]={}
fmsFunctionsDefs["TAKEOFF"]["L6"]={"setpage","INITREF"}
fmsFunctionsDefs["TAKEOFF"]["R6"]={"setpage","POSINIT"}