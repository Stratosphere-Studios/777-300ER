--[[
*****************************************************************************************
* Script Name: elec_main
* Author Name: @bruh
* Script Description: Code for electrical system.
*****************************************************************************************
--]]

main_bat = globalProperty("sim/cockpit/electrical/battery_array_on[0]")
apu_bat = globalProperty("sim/cockpit/electrical/battery_array_on[1]")
L_engn_n2 = globalProperty("sim/flightmodel/engine/ENGN_N2_[0]")
R_engn_n2 = globalProperty("sim/flightmodel/engine/ENGN_N2_[1]")
L_engn_off = globalProperty("sim/cockpit2/engine/actuators/mixture_ratio[0]")
R_engn_off = globalProperty("sim/cockpit2/engine/actuators/mixture_ratio[1]")
--Switches
L_bus_tie = createGlobalPropertyi("Strato/777/elec/L_bus_tie", 1)
R_bus_tie = createGlobalPropertyi("Strato/777/elec/R_bus_tie", 1)
apu_gen = createGlobalPropertyi("Strato/777/elec/apu_gen", 1)
L_eng_gen = createGlobalPropertyi("Strato/777/elec/L_eng_gen", 1)
R_eng_gen = createGlobalPropertyi("Strato/777/elec/R_eng_gen", 1)
L_eng_gen_disc = createGlobalPropertyi("Strato/777/elec/L_eng_gen_disc", 0)
R_eng_gen_disc = createGlobalPropertyi("Strato/777/elec/R_eng_gen_disc", 0)
L_backup_gen = createGlobalPropertyi("Strato/777/elec/L_backup_gen", 1)
R_backup_gen = createGlobalPropertyi("Strato/777/elec/R_backup_gen", 1)
--Datarefs for actual system logic
primary_gpu_connected = createGlobalPropertyi("Strato/777/elec/primary_gpu_connected", 0)
secondary_gpu_connected = createGlobalPropertyi("Strato/777/elec/secondary_gpu_connected", 0)
L_bus_tie_isln = createGlobalPropertyi("Strato/777/elec/L_bus_tie_isln", 0)
R_bus_tie_isln = createGlobalPropertyi("Strato/777/elec/R_bus_tie_isln", 0)
L_idg_on = createGlobalPropertyi("Strato/777/elec/L_idg_on", 0)
R_idg_on = createGlobalPropertyi("Strato/777/elec/R_idg_on", 0)
L_idg_cutout = createGlobalPropertyi("Strato/777/elec/L_idg_cutout", 0)
R_idg_cutout = createGlobalPropertyi("Strato/777/elec/R_idg_cutout", 0)
apu_gen_avail = createGlobalPropertyi("Strato/777/elec/apu_gen_avail", 0)
--gen_1 = globalProperty
pfd_power_capt = createGlobalPropertyi("Strato/777/elec/pfd_power_capt", 1)
pfd_power_fo = createGlobalPropertyi("Strato/777/elec/pfd_power_fo", 0)
nd_power_capt = createGlobalPropertyi("Strato/777/elec/nd_power_capt", 1)
nd_power_fo = createGlobalPropertyi("Strato/777/elec/nd_power_fo", 0)
eicas_power_upper = createGlobalPropertyi("Strato/777/elec/eicas_power_upper", 1)
eicas_power_lower = createGlobalPropertyi("Strato/777/elec/eicas_power_lower", 1)
mcp_power = createGlobalPropertyi("Strato/777/elec/mcp_power", 1)

main_bat_volts = createGlobalPropertyf("Strato/777/elec/main_bat_volts", 25)
main_bat_amps = createGlobalPropertyf("Strato/777/elec/main_bat_amps", 16)

function getIDGstatus(status, n2, mixture, cutoff)
    if status * mixture == 1 and cutoff == 0 and n2 > 60 then
        return 1
    end
    return 0
end

function setIDGs()
    set(L_idg_on, getIDGstatus(get(L_eng_gen), get(L_engn_n2), get(L_engn_off), get(L_idg_cutout)))
    set(R_idg_on, getIDGstatus(get(R_eng_gen), get(R_engn_n2), get(R_engn_off), get(R_idg_cutout)))
end

function updateBusTies()
    local l_idg_avail = get(L_idg_on)
    local r_idg_avail = get(R_idg_on)
    local apu_avail = get(apu_gen)
    local pri_avail = get(primary_gpu_connected)
    local sec_avail = get(secondary_gpu_connected)
    if l_idg_avail * r_idg_avail == 1 then
    end
end