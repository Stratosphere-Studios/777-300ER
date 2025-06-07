--[[
*****************************************************************************************
* Script Name: constants
* Author Name: discord/bruh4096#4512(Tim G.)
* Script Description: constants that are used in other files
*****************************************************************************************
--]]

--Colors

CL_WHITE = {1, 1, 1}
CL_AMBER = {1, 0.741, 0.161}
CL_GREEN = {0, 1, 0}
CL_BLACK = {0, 0, 0}
CL_DARK_GREEN = {0.02, 0.91, 0.07}
CL_DARK_BLUE = {0.01, 0.05, 0.15}
CL_LIGHT_BLUE = {0, 0.808, 1}
CL_MAGENTA = {1, 0.451, 1}

MPS_TO_KTS = 1.944

--Autopilot
--Vertical
VERT_MODE_OFF = 0
VERT_MODE_VSHOLD = 1
VERT_MODE_FPAHOLD = 2
VERT_MODE_ALTHOLD = 3
VERT_MODE_FLC_CLB = 4
VERT_MODE_FLC_DES = 5

--Lateral
LAT_MODE_OFF = 0
LAT_MODE_HDG_HOLD = 1
LAT_MODE_HDG_SEL = 2
LAT_MODE_TRK_HOLD = 3
LAT_MODE_TRK_SEL = 4

--Autothrottle
AT_MODE_OFF = 0
AT_MODE_IAS_HOLD = 1
AT_MODE_RETARD = 2
AT_MODE_HOLD = 3
AT_MODE_THR_REF = 4
AT_MODE_FLC_RETARD = 5
AT_MODE_FLC_REF = 6
--Autobrake
ABRK_MD_RTO = -2
ABRK_MD_OFF = -1
ABRK_MD_DISARM = 0
ABRK_MD_1 = 1
ABRK_MD_2 = 2
ABRK_MD_3 = 3
ABRK_MD_4 = 4
ABRK_MD_MAX = 5
ABRK_RTO_LIM_KTS = 85
ABRK_THR_DISARM_MIN = 0.05
ABRK_SYS_C_MIN_PSI = 1000
SB_THRESH = 0.015
ABRK_MODE_STRS = {"RTO", "", "", "1", "2", "3", "4", "MAX"}
ABRK_SW_DELAY_SEC = 1

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

--Flaps&slats:
FLAP_MD_PRI = 1
FLAP_MD_SEC = 2
FLAP_MD_ALTN = 3
FLAP_MD_SEC_LOCK = 4
--FLAP_MAX_LK_DEV is the maximum allowable
--difference between left and right sides of flaps before
--they are locked out(FLAP_MD_SEC_LOCK) by FSEU
FLAP_MAX_LK_DEV = 0.07 
SLAT_ALTN_RT = 0.1 * 0.004
SLAT_NML_RT = 0.4 * 0.004
FLAP_RE_SW_RETR = -1
FLAP_RE_SW_EXT = 1
FLAP_RE_SW_OFF = 0
FLAP_ALTN_EXT_MAX = 20
SLAT_SEC_TO_MID_KTS = 239 --Above this speed slats will be retracted to 0.5
AUTOSLAT_HO_SEC = 3 --Autoslats will retract this many seconds after out of stall

FLAP_STGS_DSP = {0, 1, 5, 15, 20, 25, 30}
FLAP_STGS = {0, 1, 9, 15, 20, 25, 30}
FLAP_HDL_DTTS = {0, 0.17, 0.33, 0.5, 0.67, 0.83, 1}

--Passenger stuff
PASS_SGN_OFF = 0
PASS_SGN_AUTO = 1
PASS_SGN_ON = 2
PASS_AUTO_FLP_HDL_THR = 0.02 --If flap handle is more than this, pass signs on when auto
PASS_AUTO_GEAR_THR = 0.01
PASS_AUTO_BARO_THR_FT = 10000

--XPLM

XPLM_CMD_START = 0
XPLM_CMD_CONTINUE = 1
XPLM_CMD_END = 2
