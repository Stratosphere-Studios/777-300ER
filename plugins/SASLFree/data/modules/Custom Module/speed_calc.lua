--[[
*****************************************************************************************
* Script Name: speed_calc
* Author Name: discord/bruh4096#4512(Tim G.)
* Script Description: Code for calculation of critical flight speeds
*****************************************************************************************
--]]

include("misc_tools.lua")

--Getting handles to sim datarefs

--Controls
tas = globalPropertyf("sim/flightmodel/position/true_airspeed")
cas_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
flaps = globalPropertyfae("sim/flightmodel2/wing/flap1_deg", 1)
--Indicators
vspeed = globalPropertyf("sim/cockpit2/gauges/indicators/vvi_fpm_pilot")
gs_dref = globalPropertyf("sim/cockpit2/gauges/indicators/ground_speed_kt")

track_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/ground_track_mag_copilot")
mag_heading_pilot = globalPropertyf("sim/cockpit2/gauges/indicators/heading_AHARS_deg_mag_copilot")
--Physics
curr_pressure = globalPropertyf("sim/physics/earth_pressure_p")
--Weights
total_weight = globalPropertyf("sim/flightmodel/weight/m_total")
total_fuel = globalPropertyf("sim/flightmodel/weight/m_fuel_total")
--Weather
air_density = globalPropertyf("sim/weather/rho")
sound_speed = globalPropertyf("sim/weather/speed_sound_ms")
--Operation
on_ground = globalPropertyi("sim/flightmodel/failures/onground_any")

--Finding own datarefs

max_allowable = globalPropertyi("Strato/777/fctl/vmax")
stall_speed = globalPropertyi("Strato/777/fctl/vstall")
manuever_speed = globalPropertyi("Strato/777/fctl/vmanuever")

fpv_pitch = globalPropertyf("Strato/777/autopilot/fpv_pitch")
fpv_roll = globalPropertyf("Strato/777/autopilot/fpv_roll")

--Creating own datarefs

vs_indicated = createGlobalPropertyi("Strato/777/displays/pfd/vspeed", 0)

flap_settings = {0, 1, 5, 15, 20, 25, 30}
cas_limits = {330, 265, 245, 230, 225, 200, 180}
flap_drag_coeff = {1.18, 1.75, 2, 2.1, 2.23, 2.44, 2.56}


FPV_PITCH_ABS_LIM_DEG = 20
FPV_ROLL_ABS_LIM_DEG = 30


function toCAS(speed)
    local speed_ms = get(sound_speed) * math.sqrt(5 * (((0.5 * get(air_density) * speed ^ 2) / get(curr_pressure) + 1) ^ (2/7) - 1))
    return speed_ms
end

function updateFPV()
    local fpv_pitch_deg = 0
    if get(on_ground) == 0 then
        fpv_pitch_deg = getFPA(get(gs_dref), get(vspeed))
    end
    local fpv_roll_deg = get(track_pilot) - get(mag_heading_pilot)
    set(fpv_pitch, lim(fpv_pitch_deg, FPV_PITCH_ABS_LIM_DEG, -FPV_PITCH_ABS_LIM_DEG))
    set(fpv_roll, lim(fpv_roll_deg, FPV_ROLL_ABS_LIM_DEG, -FPV_ROLL_ABS_LIM_DEG))
end

function update()
    updateFPV()

    local tmp = get(vspeed) % 50
    set(vs_indicated, get(vspeed) - tmp + 50 * round(tmp / 50))
    if get(on_ground) == 0 then
        cas_p_ms = get(cas_pilot) / 1.944
        cas_tmp = toCAS(get(tas))
        local correction = cas_p_ms - cas_tmp
        local curr_gw = get(total_weight) - get(total_fuel)
        local curr_cl = 0
        local curr_max = 0
        for i=1,7 do
            if flap_settings[i] >= get(flaps) then
                curr_cl = flap_drag_coeff[i]
                curr_max = cas_limits[i]
                break
            end
        end
        local vs = math.sqrt((curr_gw * 9.8) / (0.5 * curr_cl * get(air_density) * 428.8))
        local red_band_si = vs * 1.05
        local amber_band_si = vs * 1.3
        local red_band_conv = (toCAS(red_band_si) + correction) * 1.944
        local amber_band_conv = (toCAS(amber_band_si) + correction) * 1.944
        set(max_allowable, curr_max)
        set(stall_speed, red_band_conv)
        if amber_band_conv-10 > red_band_conv then
            amber_band_conv = amber_band_conv - 10
        end
        set(manuever_speed, amber_band_conv-10)
    end
end