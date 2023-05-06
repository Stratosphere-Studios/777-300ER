--checklist.lua
-- Language: lua
-- Path: Custom Module\EICASCHECK\checklists\checklist.lua
-- Stores all checklist information

checklisthome = {
    [1] = "PREFLIGHT",
    [2] = "BEFORE START",
    [3] = "BEFORE TAXI",
    [4] = "BEFORE TAKEOFF",
    [5] = "AFTER TAKEOFF",
    [6] = "DECENT",
    [7] = "APPROACH",
    [8] = "LANDING",
    [9] = "SHUT DOWN",
    [10] = 'SECURE'

}

preflightchecklist = {
    [1] = 'Oxygen......................Tested, 100%',
    [2] = 'Flight Inst...Heading ___, Altimeter ___',
    [3] = 'Parking brake........................Set',
    [4] = 'Fuel Control Switches.............CUTOFF'
}

bfrstartchecklist = {
    [1] = 'Supernumerary signs..................___',
    [2] = 'MCP.......V2___, HDG/TRK___, ALTITUDE___',
    [3] = 'Takeoff speeds.......V1___, VR___, V2___',
    [4] = 'CDU preflight...................completed',
    [5] = 'Trim......................___Units, 0, 0',
    [6] = 'Taxi and takeoff breifing......completed',
    [7] = 'Beacon................................on',
}

bfrtaxichecklist = {
    [1] = 'Anti-Ice.............................___',
    [2] = 'Recall...........................Checked',
    [3] = 'Autobrake............................RTO',
    [4] = 'Flight controls..................Checked',
    [5] = 'Ground equipment...................Clear'
}

bfrtakeoffchecklist = {
    [1] = 'Flaps................................___'
}

aftertakeoffchecklist = {
    [1] = 'Landing gear..........................UP',
}
decentchecklist = {
    [1] = 'Recall...........................Checked',
    [2] = 'Notes............................Checked',
    [3] = 'Autobrake............................___',
    [4] = 'Landing data........VREF___, Minimums___',
    [5] = 'Approach breifing..............Completed'
}
approachecklist = {
    [1] = 'Altimeters..........................___'
}
landingchecklist = {
    [1] = 'Speedbrake........................ARMED',
    [2] = 'Landing gear.......................DOWN',
    [3] = 'Flaps...............................___'
}
shutdownchecklist = {
    [1] = 'Hydraulic panel.....................SET',
    [2] = 'Fuel pumps..........................Off',
    [3] = 'Flaps................................UP',
    [4] = 'Parking brake.......................___',
    [5] = 'Fuel Control Switches............CUTOFF',
    [6] = 'Weather radar.......................OFF'
}
securechecklist = {
    [1] = 'ADIRU.................................OFF',
    [2] = 'Emergency lights......................OFF',
    [3] = 'Packs.................................OFF',
    [4] = 'BATTERY switch........................OFF'
}

--[[
VALUES MEANINGS:
    0 = not checked
    1 = manually checked
    2 = already checked
    3 = no check available
--]]
preflightchecklistvalues = { 0, 0, 3, 3 }
bfrstartchecklistvalues = { 0, 0, 0, 0, 0, 0, 3 }
bfrtaxichecklistvalues = { 0, 0, 3, 0, 0 }
bfrtakeoffchecklistvalues = { 3 }
aftertakeoffchecklistvalues = { [1] = 3 }
decentchecklistvalues = { 0, 0, 0, 0, 0 }
approachecklistvalues = { 0 }
landingchecklistvalues = { 3, 0, 3 }
shutdownchecklistvalues = { 3, 3, 0, 0, 3, 0 }
securechecklistvalues = { 0, 0, 0, 0 }
