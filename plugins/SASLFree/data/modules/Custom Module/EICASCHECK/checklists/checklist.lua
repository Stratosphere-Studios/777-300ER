--checklist.lua
-- Language: lua
-- Path: Custom Module\EICASCHECK\checklists\checklist.lua
-- Stores all checklist information
--[[
VALUES MEANINGS:
    0 = not checked
    1 = manually checked
    2 = already checked
    3 = no check available
--]]


checklisthome = {

    [1] = "PREFLIGHT",
    [2] = "BEFORE START",
    [3] = "BEFORE TAXI",
    [4] = "BEFORE TAKEOFF",
    [5] = "AFTER TAKEOFF",
    [6] = "PRE-DECENT",
    [7] = "APPROACH",
    [8] = "LANDING",
    [9] = "SHUT DOWN",
    [10] = 'SECURE'

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


bfrstartchecklistvalues = {0, 0, 0, 0, 0, 0, 3}