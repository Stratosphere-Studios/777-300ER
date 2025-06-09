--[[
*****************************************************************************************
* Script Name: failures
* Author Name: discord/bruh4096#4512(Tim G.)
* Script Description: Code for the door menu and door logic.
*****************************************************************************************
--]]

include("misc_tools.lua")
include("constants.lua")

--Sim datarefs:
--Operation:
f_time = globalPropertyf("sim/operation/misc/frame_rate_period")
on_ground = globalPropertyi("sim/flightmodel/failures/onground_any")

--Own datarefs:
--Pax doors:
pax_drs_l_anim = globalProperty("Strato/777/doors/cabin_ent_L_anim")
pax_drs_r_anim = globalProperty("Strato/777/doors/cabin_ent_R_anim")
pax_drs_tgt_l = globalProperty("Strato/777/doors/cabin_ent_L_tgt")
pax_drs_tgt_r = globalProperty("Strato/777/doors/cabin_ent_R_tgt")
pax_drs_arm_l = globalProperty("Strato/777/doors/cabin_ent_L_arm")
pax_drs_arm_r = globalProperty("Strato/777/doors/cabin_ent_R_arm")
--Emergency slides:
pax_drs_slide_l_anim = globalProperty("Strato/777/doors/cabin_L_slide_anim")
pax_drs_slide_r_anim = globalProperty("Strato/777/doors/cabin_R_slide_anim")
pax_drs_slide_l_tgt = globalProperty("Strato/777/doors/cabin_L_slide_tgt")
pax_drs_slide_r_tgt = globalProperty("Strato/777/doors/cabin_R_slide_tgt")
--Cargo doors:
cargo_drs_anim = globalProperty("Strato/777/doors/cargo_anim")
cargo_drs_tgt = globalProperty("Strato/777/doors/cargo_tgt")
--Hatches:
hatch_anim = globalProperty("Strato/777/doors/hatch_anim")
hatch_tgt = globalProperty("Strato/777/doors/hatch_tgt")

doors_tg_allwd = 0
em_slide_rst_l = {0, 0, 0, 0, 0}
em_slide_rst_r = {0, 0, 0, 0, 0}

function closeAllDoors()
    for i=1,5 do
        set(pax_drs_tgt_l, 0, i)
        set(pax_drs_tgt_r, 0, i)
    end
    for i=1,3 do
        set(cargo_drs_tgt, 0, i)
        set(hatch_tgt, 0, i)
    end
end

function armAllDoors()
    for i=1,5 do
        set(pax_drs_arm_l, 1, i)
        set(pax_drs_arm_r, 1, i)
    end
end

function disarmAllDoors()
    for i=1,5 do
        set(pax_drs_arm_l, 0, i)
        set(pax_drs_arm_r, 0, i)
    end
end

function resetAllSlides()
    for i=1,5 do
        if get(pax_drs_slide_l_tgt, i) == 1 then
            em_slide_rst_l[i] = 1
        end
        if get(pax_drs_slide_r_tgt, i) == 1 then
            em_slide_rst_r[i] = 1
        end
    end
end

function updateDoorToggleSts()
    if get(on_ground) == 1 then
        doors_tg_allwd = 1
    else
        doors_tg_allwd = 0
    end
end

function updateSlideSd(idx, rst_arr, slide_tgt_dr, door_tgt_dr, door_arm_dr)
    if rst_arr[idx] == 1 then
        set(slide_tgt_dr, 0, idx)
        if get(door_tgt_dr, idx) == 0 then
            rst_arr[idx] = 0
        end
    else
        if get(door_tgt_dr, idx) == 1 and get(door_arm_dr, idx) == 1 then
            set(slide_tgt_dr, 1, idx)
        end
    end
end

function updateSlides()
    for i=1,5 do
        updateSlideSd(i, em_slide_rst_l, pax_drs_slide_l_tgt, pax_drs_tgt_l, pax_drs_arm_l)
        updateSlideSd(i, em_slide_rst_r, pax_drs_slide_r_tgt, pax_drs_tgt_r, pax_drs_arm_r)
    end
end

function toggleL1Door()
    if doors_tg_allwd == 1 then
        set(pax_drs_tgt_l, 1-get(pax_drs_tgt_l, 1), 1)
    end
end

function toggleL2Door()
    if doors_tg_allwd == 1 then
        set(pax_drs_tgt_l, 1-get(pax_drs_tgt_l, 2), 2)
    end
end

function toggleL3Door()
    if doors_tg_allwd == 1 then
        set(pax_drs_tgt_l, 1-get(pax_drs_tgt_l, 3), 3)
    end
end

function toggleL4Door()
    if doors_tg_allwd == 1 then
        set(pax_drs_tgt_l, 1-get(pax_drs_tgt_l, 4), 4)
    end
end

function toggleL5Door()
    if doors_tg_allwd == 1 then
        set(pax_drs_tgt_l, 1-get(pax_drs_tgt_l, 5), 5)
    end
end

function toggleR1Door()
    if doors_tg_allwd == 1 then
        set(pax_drs_tgt_r, 1-get(pax_drs_tgt_r, 1), 1)
    end
end

function toggleR2Door()
    if doors_tg_allwd == 1 then
        set(pax_drs_tgt_r, 1-get(pax_drs_tgt_r, 2), 2)
    end
end

function toggleR3Door()
    if doors_tg_allwd == 1 then
        set(pax_drs_tgt_r, 1-get(pax_drs_tgt_r, 3), 3)
    end
end

function toggleR4Door()
    if doors_tg_allwd == 1 then
        set(pax_drs_tgt_r, 1-get(pax_drs_tgt_r, 4), 4)
    end
end

function toggleR5Door()
    if doors_tg_allwd == 1 then
        set(pax_drs_tgt_r, 1-get(pax_drs_tgt_r, 5), 5)
    end
end

function toggleFrontCargo()
    if doors_tg_allwd == 1 then
        set(cargo_drs_tgt, 1-get(cargo_drs_tgt, 1), 1)
    end
end

function toggleAftCargo()
    if doors_tg_allwd == 1 then
        set(cargo_drs_tgt, 1-get(cargo_drs_tgt, 2), 2)
    end
end

function toggleBulkCargo()
    if doors_tg_allwd == 1 then
        set(cargo_drs_tgt, 1-get(cargo_drs_tgt, 3), 3)
    end
end

function toggleLeftCowl()
    if doors_tg_allwd == 1 then
        set(hatch_tgt, 1-get(hatch_tgt, 1), 1)
    end
end

function toggleRightCowl()
    if doors_tg_allwd == 1 then
        set(hatch_tgt, 1-get(hatch_tgt, 2), 2)
    end
end

function toggleApuAcc()
    if doors_tg_allwd == 1 then
        set(hatch_tgt, 1-get(hatch_tgt, 3), 3)
    end
end

doors_btn = sasl.appendMenuItem(PLUGINS_MENU_ID, "Doors")
doors_menu = sasl.createMenu("", PLUGINS_MENU_ID, doors_btn)

close_all = sasl.appendMenuItem(doors_menu, "Close all doors", closeAllDoors)
pax_doors = sasl.appendMenuItem(doors_menu, "Passenger doors")
cargo_doors = sasl.appendMenuItem(doors_menu, "Cargo doors")
hatches = sasl.appendMenuItem(doors_menu, "Maintenance access doors")
pax_doors_menu = sasl.createMenu("", doors_menu, pax_doors)
cargo_doors_menu = sasl.createMenu("", doors_menu, cargo_doors)
hatch_menu = sasl.createMenu("", doors_menu, hatches)

arm_all = sasl.appendMenuItem(pax_doors_menu, "Arm all doors", armAllDoors)
disarm_all = sasl.appendMenuItem(pax_doors_menu, "Disarm all doors", disarmAllDoors)
reset_slides = sasl.appendMenuItem(pax_doors_menu, "Reset all slides", resetAllSlides)

toggleL1 = sasl.appendMenuItem(pax_doors_menu, "Toggle L1 Door", toggleL1Door)
toggleL2 = sasl.appendMenuItem(pax_doors_menu, "Toggle L2 Door", toggleL2Door)
toggleL3 = sasl.appendMenuItem(pax_doors_menu, "Toggle L3 Door", toggleL3Door)
toggleL4 = sasl.appendMenuItem(pax_doors_menu, "Toggle L4 Door", toggleL4Door)
toggleL5 = sasl.appendMenuItem(pax_doors_menu, "Toggle L5 Door", toggleL5Door)
toggleR1 = sasl.appendMenuItem(pax_doors_menu, "Toggle R1 Door", toggleR1Door)
toggleR2 = sasl.appendMenuItem(pax_doors_menu, "Toggle R2 Door", toggleR2Door)
toggleR3 = sasl.appendMenuItem(pax_doors_menu, "Toggle R3 Door", toggleR3Door)
toggleR4 = sasl.appendMenuItem(pax_doors_menu, "Toggle R4 Door", toggleR4Door)
toggleR5 = sasl.appendMenuItem(pax_doors_menu, "Toggle R5 Door", toggleR5Door)

togglefrontcargo = sasl.appendMenuItem(cargo_doors_menu, "Toggle front cargo door", toggleFrontCargo)
toggleaftcargo = sasl.appendMenuItem(cargo_doors_menu, "Toggle aft cargo door", toggleAftCargo)
togglebulkcargo = sasl.appendMenuItem(cargo_doors_menu, "Toggle bulk cargo door", toggleBulkCargo)

togglelefteng = sasl.appendMenuItem(hatch_menu, "Toggle left cowl", toggleLeftCowl)
togglerighteng = sasl.appendMenuItem(hatch_menu, "Toggle right cowl", toggleRightCowl)
togggleapu = sasl.appendMenuItem(hatch_menu, "Toggle apu access doors", toggleApuAcc)

function update()
    updateDoorToggleSts()
    updateSlides()

    for i=1,5 do
        set(pax_drs_l_anim, EvenChange(get(pax_drs_l_anim, i), get(pax_drs_tgt_l, i), PAX_DRS_RESP), i)
        set(pax_drs_r_anim, EvenChange(get(pax_drs_r_anim, i), get(pax_drs_tgt_r, i), PAX_DRS_RESP), i)

        set(pax_drs_slide_l_anim, EvenChange(get(pax_drs_slide_l_anim, i), get(pax_drs_slide_l_tgt, i), EMER_SLIDE_RESP), i)
        set(pax_drs_slide_r_anim, EvenChange(get(pax_drs_slide_r_anim, i), get(pax_drs_slide_r_tgt, i), EMER_SLIDE_RESP), i)
    end

    for i=1,3 do
        set(cargo_drs_anim, EvenChange(get(cargo_drs_anim, i), get(cargo_drs_tgt, i), CARGO_DRS_RESP), i)

        set(hatch_anim, EvenChange(get(hatch_anim, i), get(hatch_tgt, i), HATCH_RESP), i)
    end

    UpdateCheckMark(pax_drs_tgt_l, 1, pax_doors_menu, toggleL1, 1)
    UpdateCheckMark(pax_drs_tgt_l, 2, pax_doors_menu, toggleL2, 1)
    UpdateCheckMark(pax_drs_tgt_l, 3, pax_doors_menu, toggleL3, 1)
    UpdateCheckMark(pax_drs_tgt_l, 4, pax_doors_menu, toggleL4, 1)
    UpdateCheckMark(pax_drs_tgt_l, 5, pax_doors_menu, toggleL5, 1)

    UpdateCheckMark(pax_drs_tgt_r, 1, pax_doors_menu, toggleR1, 1)
    UpdateCheckMark(pax_drs_tgt_r, 2, pax_doors_menu, toggleR2, 1)
    UpdateCheckMark(pax_drs_tgt_r, 3, pax_doors_menu, toggleR3, 1)
    UpdateCheckMark(pax_drs_tgt_r, 4, pax_doors_menu, toggleR4, 1)
    UpdateCheckMark(pax_drs_tgt_r, 5, pax_doors_menu, toggleR5, 1)

    UpdateCheckMark(cargo_drs_tgt, 1, cargo_doors_menu, togglefrontcargo, 1)
    UpdateCheckMark(cargo_drs_tgt, 2, cargo_doors_menu, toggleaftcargo, 1)
    UpdateCheckMark(cargo_drs_tgt, 3, cargo_doors_menu, togglebulkcargo, 1)

    UpdateCheckMark(hatch_tgt, 1, hatch_menu, togglelefteng, 1)
    UpdateCheckMark(hatch_tgt, 2, hatch_menu, togglerighteng, 1)
    UpdateCheckMark(hatch_tgt, 3, hatch_menu, togggleapu, 1)
end
