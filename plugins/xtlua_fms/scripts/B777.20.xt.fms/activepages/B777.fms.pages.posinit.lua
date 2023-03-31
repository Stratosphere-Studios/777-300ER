fmsPages["POSINIT"]=createPage("POSINIT")
fmsPages["POSINIT"].getPage=function(self,pgNo,fmsID)
  if pgNo == 1 then

    fmsFunctionsDefs["POSINIT"]["R1"]={"getdata","lastpos"}
    --fmsFunctionsDefs["POSINIT"]["R5"]={"setdata","irspos"}
    fmsFunctionsDefs["POSINIT"]["L2"]={"setdata","airportpos"}
    fmsFunctionsDefs["POSINIT"]["L3"]={"setdata","airportgate"}
    fmsFunctionsDefs["POSINIT"]["R6"]={"setpage", "RTE1"}
    fmsFunctionsDefs["POSINIT"]["R4"]={"getdata","gpspos"}
    fmsFunctionsDefs["POSINIT"]["R2"]={"getdata","lastpos"}

    local hrs, mins = hh < 10 and "0"..hh or hh, mm < 10 and "0"..mm or mm

    --fmsModules["data"].pos = toDMS(simDR_latitude, true).." "..toDMS(simDR_longitude, false)
    return {
      "      POS INIT          ",
      "                        ",
      "      "..fmsModules["data"].lastpos,
      "                        ",
      fmsModules["data"].airportpos.."  "..fmsModules["data"].aptLat.." "..fmsModules["data"].aptLon,
      "                        ",
      fmsModules["data"].airportgate.."                    ",
      "                        ",
      hrs..mins.."  "..fmsModules["data"].pos,
      "                        ",
      "      ***`**.* ****`**.*",
      "                        ",
      "<INDEX            ROUTE>"
    }

  elseif pgNo==2 then

    --[[local rnav_type="NAV STA"
    local rnav_id="**** ****"
    local rnav_accuracy="2.00/**.** "
    if simDR_radio_nav_horizontal[2]==1 and simDR_radio_nav_horizontal[3]==1 and simDR_radio_nav_hasDME[2]==1 and simDR_radio_nav_hasDME[3]==1 then 
      rnav_type="DME-DME"
      rnav_id=string.format("%4s %4s",simDR_radio_nav03_ID,simDR_radio_nav04_ID)
      rnav_accuracy="2.00/0.05"
    elseif (simDR_radio_nav_horizontal[2]==1 and simDR_radio_nav_hasDME[2]==1) then
      rnav_type="VOR-DME"
      rnav_id=string.format("%4s %4s",simDR_radio_nav03_ID,simDR_radio_nav03_ID)
      rnav_accuracy="2.00/0.15  "
    elseif (simDR_radio_nav_horizontal[3]==1 and simDR_radio_nav_hasDME[3]==1)  then
      rnav_type="VOR-DME"
      rnav_accuracy="2.00/0.15"
      rnav_id=string.format("%4s %4s",simDR_radio_nav04_ID,simDR_radio_nav04_ID)
    end
    if simDR_radio_nav_horizontal[3]==1 then vorR_radial=string.format("%03d",simDR_radio_nav_radial[3]) end
]]
    return {
      "      POS REF           ",
      "                        ",
      "                        ", --irsSystem.getLine("gpsL"),
      "                        ",
      "                        ", --irsSystem.calcLatA().." ".. irsSystem.calcLonA() .."      ",
      "                        ", --"                 "..rnav_type,
      "                        ", --rnav_accuracy.."NM    "..rnav_id,
      "                        ",
      "                        ",
      "                        ",
      "                        ",
      "                        ",
      "<INDEX         BRG/DIST>"
    }

  elseif pgNo==3 then

    return {
      "      POS REF           ",
      "                        ",
      "                        ", --irsSystem.getLine("irsL"),
      "                        ",
      "                        ", --irsSystem.getLine("irsC"),
      "                        ",
      "                        ", --irsSystem.getLine("irsR"),
      "                        ",
      "                        ", --irsSystem.getLine("gpsL"),
      "                        ",
      "                        ", --irsSystem.getLine("gpsR"),
      "                        ",
      "<INDEX         BRG/DIST>"
    }
  end
end

fmsPages["POSINIT"].getSmallPage=function(self,pgNo,fmsID)
  if pgNo==1 then

    local setIRS=""
    --if B777DR_iru_status[0]==4 or B777DR_iru_status[1]==4 or B777DR_iru_status[2]==4 or irsSystem["setPos"]==false then
      setIRS="SET INERTIAL POS"
    --end

    return {
      "                    1/3 ",
      "                LAST POS",
      "                        ",
      " REF AIRPORT            ",
      "                        ",
      " GATE                   ",
      "                        ",
      " UTC             GPS POS",
      "    Z                   ",
      "        "..setIRS,
      "                        ",
      "------------------------",
      "                        "
    }
  elseif pgNo==2 then
    return {
      "                    2/3 ",
      " FMC (GPS)        UPDATE",
      "                        ",
      " INERTIAL  ACTUAL     NM",
      "                        ",
      " GPS       ACTUAL     NM",
      "                        ",
      " RADIO     ACTUAL     NM",
      "                        ",
      " RNP/ACTUAL      DME DME",
      "                        ",
      "------------------------",
      "                        "
    }
  elseif pgNo==3 then
    return {
      "                    3/3 ",
      " GPS L                  ",
      "                        ",
      " GPS R                  ",
      "                        ",
      " FMC L (PRI)            ",
      "                        ",
      " FMC R                  ",
      "                        ",
      "                 GPS NAV",
      "                        ",
      "------------------------",
      "                        "
    }
  end
end

fmsPages["POSINIT"].getNumPages=function(self)
  return 3
end

fmsFunctionsDefs["POSINIT"]={}
fmsFunctionsDefs["POSINIT"]["L6"]={"setpage","INITREF"}