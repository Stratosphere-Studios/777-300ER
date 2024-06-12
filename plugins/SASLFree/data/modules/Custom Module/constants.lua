--[[
*****************************************************************************************
* Script Name: constants
* Author Name: @bruh
* Script Description: constants that are used in other files
*****************************************************************************************
--]]

--Colors

white = {1, 1, 1}
amber = {1, 0.741, 0.161}
green = {0, 1, 0}
dark_green = {0.02, 0.91, 0.07}
dark_blue = {0.01, 0.05, 0.15}
light_blue = {0, 0.808, 1}
magenta = {1, 0.451, 1}

--Cockpit

SPEEDBRK_HANDLE_ARMED = -0.13

--Flight controls

SEC_SPOILER_ACTIVATION = 0.96 --Value of the speedbrake handle dataref above which the #4 and #11 spoilers will be extended
SPOILER_4 = 1
SPOILER_1_5 = 2
SPOILER_11 = 3
SPOILER_10_14 = 4
SPOILER_6 = 5
SPOILER_7 = 6
SPOILER_8 = 7
SPOILER_9 = 8

PCU_BYPASS = 0
PCU_NML = 1
PCU_BLOCKING = 2

--ND

ND_POI_DISPLAYED_LIMIT = 70

--TCAS

TCAS_TEST = -1
TCAS_OFF = 0
TCAS_TA_ONLY = 1
TCAS_TA_RA = 2

TCAS_SW_STDBY = 0
TCAS_SW_ALT_OFF = 1
TCAS_SW_ALT_ON = 2
TCAS_SW_TA_ONLY = 3
TCAS_SW_TA_RA = 4

--XPLM

XPLM_CMD_START = 0
XPLM_CMD_CONTINUE = 1
XPLM_CMD_END = 2
