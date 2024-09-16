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
    [9] = "SHUTDOWN",
    [10] = 'SECURE'
}

preflightchecklist = {
    [1] = 'Oxygen.....................Tested, 100%',
    [2] = 'Flight Inst..Heading ___, Altimeter ___',
    [3] = 'Parking brake.......................Set',
    [4] = 'Fuel Control Switches............CUTOFF'
}

bfrstartchecklist = {
    [1] = 'Flight deck door......Closed and locked',
    [2] = 'Passenger signs..................... __',
    [3] = 'MCP......V2___, HDG/TRK___, ALTITUDE___',
    [4] = 'Takeoff speeds......V1___, VR___, V2___',
    [5] = 'CDU preflight.................Completed',
    [6] = 'Trim.....................___Units, 0, 0',
    [7] = 'Taxi and takeoff briefing.....Completed',
    [8] = 'Beacon...............................on'
}

bfrtaxichecklist = {
    [1] = 'Anti-Ice............................ __',
    [2] = 'Recall..........................Checked',
    [3] = 'Autobrake...........................RTO',
    [4] = 'Flight controls.................Checked',
    [5] = 'Ground equipment..................Clear'
}

bfrtakeoffchecklist = {
    [1] = 'Flaps............................... __'
}

aftertakeoffchecklist = {
    [1] = 'Landing gear.........................UP',
    [2] = 'Flaps................................UP'
}
descentchecklist = {
    [1] = 'Recall..........................Checked',
    [2] = 'Notes...........................Checked',
    [3] = 'Autobrake........................... __',
    [4] = 'Landing data.......VREF___, Minimums___',
    [5] = 'Approach breifing.............Completed'
}
approachecklist = {
    [1] = 'Altimeters.......................... __'
}
landingchecklist = {
    [1] = 'Speedbrake........................ARMED',
    [2] = 'Landing gear.......................DOWN',
    [3] = 'Flaps............................... __'
}
shutdownchecklist = {
    [1] = 'Fuel pumps..........................Off',
    [2] = 'Flaps................................UP',
    [3] = 'Parking brake....................... __',
    [4] = 'Fuel control switches............CUTOFF',
    [5] = 'Weather radar.......................Off'
}
securechecklist = {
    [1] = 'ADIRU...............................OFF',
    [2] = 'Emergency lights....................OFF',
    [3] = 'Packs...............................OFF'
}

--[[
VALUES MEANINGS:
    0 = not checked
    1 = manually checked
    2 = already checked
    3 = no check available
    4 = no check available checked
    5, 6, 7 = do not perfrom step
--]]
preflightchecklistvalues = { 0, 0, 3, 3 }
bfrstartchecklistvalues = { 0, 0, 0, 0, 0, 0, 0, 3 }
bfrtaxichecklistvalues = { 0, 0, 3, 0, 0 }
bfrtakeoffchecklistvalues = { 3 }
aftertakeoffchecklistvalues = { 3, 3 }
descentchecklistvalues = { 0, 0, 0, 0, 0 }
approachecklistvalues = { 0 }
landingchecklistvalues = { 3, 3, 3 }
shutdownchecklistvalues = { 3, 0, 0, 3, 0 }
securechecklistvalues = { 0, 0, 0 }


