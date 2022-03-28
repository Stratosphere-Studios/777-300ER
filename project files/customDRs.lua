--Custom DRs used by the fms that need to be redone

--B777DR_CAS_advisory_status      = find_dataref("strato/B777/CAS/advisory_status")
B777DR_ap_vnav_system           = find_dataref("strato/B777/autopilot/vnav_system")
B777DR_ap_vnav_pause            = find_dataref("strato/B777/autopilot/vnav_pause")

B777DR_rtp_C_off 		        = find_dataref("strato/B777/comm/rtp_C/off_status")
B777DR_ap_fpa	                = find_dataref("strato/B777/autopilot/navadata/fpa")
B777DR_ap_vb	                = find_dataref("strato/B777/autopilot/navadata/vb")
B777DR_airspeed_Vref            = find_dataref("strato/B777/airspeed/Vref")
B777DR_airspeed_VrefFlap        = find_dataref("strato/B777/airspeed/VrefFlap")
B777DR_altimter_ft_adjusted     = find_dataref("strato/B777/altimeter/ft_adjusted")
B777BR_eod_index 	            = find_dataref("strato/B777/autopilot/dist/eod_index")
B777DR_TAS_pilot			    = find_dataref("strato/B777/nd/TAS_pilot")
B777DR_engine_used_fuel         = find_dataref("strato/B777/fuel/totaliser")

local irs_align_time = string.format("%-2d", simConfigData["data"].SIM.irs_align_time / 60)  --Mins