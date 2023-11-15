fmsPages["EICASMODES"]=createPage("EICASMODES")
fmsPages["EICASMODES"].getPage=function(self,pgNo,fmsID)
    return {
        "     DISPLAY MODES      ",
        "                        ",
        "<L INBD;r07            CHKL>",
        "                        ",
        "<LWR CTR<SEL>      COMM>;r05",
        "                        ",
        "<R INBD             NAV>;r04",
        "                        ",
        "<ENG                    ",
        "                        ",
        "<STAT          CANC/RCL>",
        "------------------------",
        "              SYNOPTICS>"
    }
end

fmsPages["EICASMODES"].getSmallPage=function(self,pgNo,fmsID)
    return {
        "                        ",
        " SEL DISPLAY        MODE",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        " EICAS                  ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        }
end

fmsFunctionsDefs["EICASMODES"]={}
fmsFunctionsDefs["EICASMODES"]["L4"]={"setEicasPage",4}
fmsFunctionsDefs["EICASMODES"]["L5"]={"setDisetEicasPagesp",9}
fmsFunctionsDefs["EICASMODES"]["R1"]={"ssetEicasPageetDisp",10}
fmsFunctionsDefs["EICASMODES"]["R5"]={"doCMD","Strato/777/commands/glareshield/recall"}
fmsFunctionsDefs["EICASMODES"]["R6"]={"setpage","EICASSYN"}

fmsPages["EICASSYN"]=createPage("EICASSYN")
fmsPages["EICASSYN"].getPage=function(self,pgNo,fmsID)
    return {
        "   DISPLAY SYNOPTICS    ",
        "                        ",
        "<L INBD;r07            ELEC>",
        "                        ",
        "<LWR CTR<SEL>     	 HYD>",
        "                        ",
        "<R INBD;r07            FUEL>",
        "                        ",
        "<DOOR               AIR>",
        "                        ",
        "<GEAR              FCTL>",
        "------------------------",
        "                  MODES>"
    }
end

fmsPages["EICASSYN"].getSmallPage=function(self,pgNo,fmsID)
    return {
        "                        ",
        " SEL DISPLAY            ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
        "                        ",
    }
end

fmsFunctionsDefs["EICASSYN"]={}
fmsFunctionsDefs["EICASSYN"]["L4"]={"setEicasPage",2}
fmsFunctionsDefs["EICASSYN"]["L5"]={"setEicasPage",7}
fmsFunctionsDefs["EICASSYN"]["R1"]={"setEicasPage",3}
fmsFunctionsDefs["EICASSYN"]["R2"]={"setEicasPage",8}
fmsFunctionsDefs["EICASSYN"]["R3"]={"setEicasPage",6}
fmsFunctionsDefs["EICASSYN"]["R4"]={"setEicasPage",1}
fmsFunctionsDefs["EICASSYN"]["R5"]={"setEicasPage",5}
fmsFunctionsDefs["EICASSYN"]["R6"]={"setpage","EICASMODES"}