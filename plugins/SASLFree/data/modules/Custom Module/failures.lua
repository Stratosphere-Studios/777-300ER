--[[
*****************************************************************************************
* Script Name: failures
* Author Name: @bruh
* Script Description: Code for some basic faults. Don't blame me for writing this garbage.
This is the only way to get the menu stuff working with sasl. There will be a proper GUI eventually. 
*****************************************************************************************
--]]

fbw_secondary_fail = globalPropertyi("Strato/777/failures/fctl/secondary")
fbw_direct_fail = globalPropertyi("Strato/777/failures/fctl/direct")

ace_fail = globalProperty("Strato/777/failures/fctl/ace") --L1, L2, C, R

function UpdateCheckMark(dref, idx, menu, item, value)
    if get(dref, idx) == value then
        sasl.setMenuItemState(menu, item, MENU_CHECKED)
    else
        sasl.setMenuItemState(menu, item, MENU_UNCHECKED)
    end
end

function ResetFailures()
    set(fbw_secondary_fail, 0)
    set(fbw_direct_fail, 0)
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

failures_btn = sasl.appendMenuItem(PLUGINS_MENU_ID, "Failures")
failures_menu = sasl.createMenu("", PLUGINS_MENU_ID, failures_btn)
reset_failures = sasl.appendMenuItem(failures_menu, "Reset all", ResetFailures)
flight_controls = sasl.appendMenuItem(failures_menu, "ATA 27 Flight Controls")
fctl_failures_menu = sasl.createMenu("", failures_menu, flight_controls)
secondary_mode = sasl.appendMenuItem(fctl_failures_menu, "PFC to Secondary Mode", toSecondary)
direct_mode = sasl.appendMenuItem(fctl_failures_menu, "PFC to Direct Mode", toDirect)
l1fail = sasl.appendMenuItem(fctl_failures_menu, "ACE L1 fail", ACEL1Fail)
l2fail = sasl.appendMenuItem(fctl_failures_menu, "ACE L2 fail", ACEL2Fail)
cfail = sasl.appendMenuItem(fctl_failures_menu, "ACE C fail", ACECFail)
rfail = sasl.appendMenuItem(fctl_failures_menu, "ACE R fail", ACERFail)

function update()
    UpdateCheckMark(fbw_secondary_fail, 1, fctl_failures_menu, secondary_mode, 1)
    UpdateCheckMark(fbw_direct_fail, 1, fctl_failures_menu, direct_mode, 1)
    UpdateCheckMark(ace_fail, 1, fctl_failures_menu, l1fail, 1)
    UpdateCheckMark(ace_fail, 2, fctl_failures_menu, l2fail, 1)
    UpdateCheckMark(ace_fail, 3, fctl_failures_menu, cfail, 1)
    UpdateCheckMark(ace_fail, 4, fctl_failures_menu, rfail, 1)
end