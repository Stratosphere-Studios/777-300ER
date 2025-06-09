--[[
*****************************************************************************************
* Script Name: failures
* Author Name: discord/bruh4096#4512(Tim G.)
* Script Description: Code for the custom failure menu
*****************************************************************************************
--]]

include("misc_tools.lua")

fbw_secondary_fail = globalPropertyi("Strato/777/failures/fctl/secondary")
fbw_direct_fail = globalPropertyi("Strato/777/failures/fctl/direct")
autobrk_fail = globalPropertyi("Strato/777/failures/gear/autobrake")
flaps_jam_all_lt = globalPropertyi("Strato/777/failures/fctl/flap_jam_l")
flaps_jam_all_rt = globalPropertyi("Strato/777/failures/fctl/flap_jam_r")
slats_jam_all_inn = globalPropertyi("Strato/777/failures/fctl/slat_jam_inn")
slats_jam_all_out = globalPropertyi("Strato/777/failures/fctl/slat_jam_out")

ace_fail = globalProperty("Strato/777/failures/fctl/ace") --L1, L2, C, R

function ResetFailures()
    set(fbw_secondary_fail, 0)
    set(fbw_direct_fail, 0)
    set(autobrk_fail, 0)
    set(flaps_jam_all_lt, 0)
    set(flaps_jam_all_rt, 0)
    set(slats_jam_all_inn, 0)
    set(slats_jam_all_out, 0)
    for i=1,4 do
        set(ace_fail, 0, i)
    end
end

function toSecondary()
    set(fbw_secondary_fail, 1 - get(fbw_secondary_fail))
end

function toDirect()
    set(fbw_direct_fail, 1 - get(fbw_direct_fail))
end

function ACEL1Fail()
    set(ace_fail, 1 - get(ace_fail, 1), 1)
end

function ACEL2Fail()
    set(ace_fail, 1 - get(ace_fail, 2), 2)
end

function ACECFail()
    set(ace_fail, 1 - get(ace_fail, 3), 3)
end

function ACERFail()
    set(ace_fail, 1 - get(ace_fail, 4), 4)
end

function autoBrakeFail()
    set(autobrk_fail, 1 - get(autobrk_fail))
end

function flapLtJam()
    set(flaps_jam_all_lt, 1 - get(flaps_jam_all_lt))
end

function flapRtJam()
    set(flaps_jam_all_rt, 1 - get(flaps_jam_all_rt))
end

function slatInnJam()
    set(slats_jam_all_inn, 1 - get(slats_jam_all_inn))
end

function slatOutJam()
    set(slats_jam_all_out, 1 - get(slats_jam_all_out))
end

failures_btn = sasl.appendMenuItem(PLUGINS_MENU_ID, "Failures")
failures_menu = sasl.createMenu("", PLUGINS_MENU_ID, failures_btn)
reset_failures = sasl.appendMenuItem(failures_menu, "Reset all", ResetFailures)
flight_controls = sasl.appendMenuItem(failures_menu, "ATA 27 Flight Controls")
landing_gear = sasl.appendMenuItem(failures_menu, "ATA 32 Landing Gear")
fctl_failures_menu = sasl.createMenu("", failures_menu, flight_controls)
ldgr_failures_menu = sasl.createMenu("", failures_menu, landing_gear)
secondary_mode = sasl.appendMenuItem(fctl_failures_menu, "PFC to Secondary Mode", toSecondary)
direct_mode = sasl.appendMenuItem(fctl_failures_menu, "PFC to Direct Mode", toDirect)
l1fail = sasl.appendMenuItem(fctl_failures_menu, "ACE L1 fail", ACEL1Fail)
l2fail = sasl.appendMenuItem(fctl_failures_menu, "ACE L2 fail", ACEL2Fail)
cfail = sasl.appendMenuItem(fctl_failures_menu, "ACE C fail", ACECFail)
rfail = sasl.appendMenuItem(fctl_failures_menu, "ACE R fail", ACERFail)
abrk_fail = sasl.appendMenuItem(ldgr_failures_menu, "Autobrake fail", autoBrakeFail)
fjal = sasl.appendMenuItem(fctl_failures_menu, "Flaps jam(all left side)", flapLtJam)
fjar = sasl.appendMenuItem(fctl_failures_menu, "Flaps jam(all right side)", flapRtJam)
sjinn = sasl.appendMenuItem(fctl_failures_menu, "Slats jam(all inner)", slatInnJam)
sjout = sasl.appendMenuItem(fctl_failures_menu, "Slats jam(all outer)", slatOutJam)

function update()
    UpdateCheckMark(fbw_secondary_fail, 1, fctl_failures_menu, secondary_mode, 1)
    UpdateCheckMark(fbw_direct_fail, 1, fctl_failures_menu, direct_mode, 1)
    UpdateCheckMark(ace_fail, 1, fctl_failures_menu, l1fail, 1)
    UpdateCheckMark(ace_fail, 2, fctl_failures_menu, l2fail, 1)
    UpdateCheckMark(ace_fail, 3, fctl_failures_menu, cfail, 1)
    UpdateCheckMark(ace_fail, 4, fctl_failures_menu, rfail, 1)
    UpdateCheckMark(flaps_jam_all_lt, 1, fctl_failures_menu, fjal, 1)
    UpdateCheckMark(flaps_jam_all_rt, 1, fctl_failures_menu, fjar, 1)
    UpdateCheckMark(slats_jam_all_inn, 1, fctl_failures_menu, sjinn, 1)
    UpdateCheckMark(slats_jam_all_out, 1, fctl_failures_menu, sjout, 1)
    UpdateCheckMark(autobrk_fail, 1, ldgr_failures_menu, abrk_fail, 1)
end