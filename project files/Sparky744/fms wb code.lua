--Marauder28
--[[ @BRUHegg you might want to take a look at this and see if any of it is of any use. I think X-Plane 12 has most of this built in though so it's not necessary.
--Marauder28
--Weight & Balance data
wb = {
	--Weights
	OEW_weight				= 0,
	fuel_CTR_0_weight		= 0,
	fuel_L_main1_weight		= 0,
	fuel_L_main2_weight		= 0,
	fuel_R_main3_weight		= 0,
	fuel_R_main4_weight		= 0,
	fuel_L_rsv5_weight		= 0,
	fuel_R_rsv6_weight		= 0,
	fuel_stab7_weight		= 0,
	-- Passenger Zones are defined A - E, A=First, B=Business, C-D-E=Economy split in 3 zones
	passenger_zoneA_weight	= 0,  --defined via FMC passenger loading function
	passenger_zoneB_weight	= 0,  --defined via FMC passenger loading function
	passenger_zoneC_weight	= 0,  --defined via FMC passenger loading function
	passenger_zoneD_weight	= 0,  --defined via FMC passenger loading function
	passenger_zoneE_weight	= 0,  --defined via FMC passenger loading function

	--Payload/Cargo Zones
	fwd_lower_cargo_weight	= 0,  --defined via FMC cargo loading function
	aft_lower_cargo_weight	= 0,  --defined via FMC cargo loading function
	bulk_lower_cargo_weight	= 0,  --defined via FMC cargo loading function
	freight_zoneA_weight	= 0,  --defined via FMC cargo loading function
	freight_zoneB_weight	= 0,  --defined via FMC cargo loading function
	freight_zoneC_weight	= 0,  --defined via FMC cargo loading function
	freight_zoneD_weight	= 0,  --defined via FMC cargo loading function
	freight_zoneE_weight	= 0,  --defined via FMC cargo loading function

	--Moment Arm Distances (inches from reference point [aircraft nose] stored in feet in aircraft .acf file)
	OEW_distance				= 1243.32, --103.61 feet
	fuel_CTR_0_distance			= 1008.00, --84.00 feet
	fuel_L_main1_distance		= 1383.60, --115.30 feet
	fuel_L_main2_distance		= 1140.00, --95.00 feet
	fuel_R_main3_distance		= 1140.00, --95.00 feet
	fuel_R_main4_distance		= 1383.60, --115.30 feet
	fuel_L_rsv5_distance		= 1596.00, --133.00 feet
	fuel_R_rsv6_distance		= 1596.00, --133.00 feet
	fuel_stab7_distance			= 2412.00, --201.00 feet
	-- Passenger Zone moment arm distances are an approximation using the middle of the Zone as a reference
	passenger_zoneA_distance	= 285.00, --23.75 feet (23 First Class seats in the nose)
	passenger_zoneB_distance	= 735.00, --61.25 feet (80 Business Class seats behind First Class, including the Upper Deck Business Class seats)
	passenger_zoneC_distance	= 1060.00, --88.33 feet (77 Economy Class seats)
	passenger_zoneD_distance	= 1405.00, --117.08 feet (104 Economy Class seats)
	passenger_zoneE_distance	= 1950.00, --162.5 feet (132 Economy Class seats)

	--Payload/Cargo Zone moment arm distances are an approximation using the middle of the Zone as a reference
	fwd_lower_cargo_distance	= 650.00,  --54.16 feet (5 pallets [5035 KGS] or 16 LD1/LD3 [1588 KGS] containers or combination totalling 26,490 KGS).
	aft_lower_cargo_distance	= 1675.00,  --139.58 feet (4 pallets or 14 LD1/LD3 containers or combination totalling 22,938 KGS).
	bulk_lower_cargo_distance	= 1935.00,  --161.25 feet (6,749 KGS).  In the tail of the aircraft beneath the rear galley.
	freight_zoneA_distance		= 290.00,  --24.16 feet (3 pallets [3763 KGS] or equivalent totalling 11,289 KGS).
	freight_zoneB_distance		= 690.00,  --57.50 feet (8 pallets [3763 KGS] or equivalent totalling 30,104 KGS).
	freight_zoneC_distance		= 1135.00,  --94.58 feet (6 pallets [3763 KGS] or equivalent totalling 22,578 KGS).
	freight_zoneD_distance		= 1750.00,  --145.83 feet (12 pallets [3763 KGS] or equivalent totalling 45,156 KGS).
	freight_zoneE_distance		= 2220.00,  --185.00 feet (1 pallet [3763 KGS] or equivalent totalling 3763 KGS).
	--Calculated Results
	stab_trim = 0,
	cg_mac = 0
}

--Calculate CG %MAC & Trim
function calc_stab_trim(GW, CG_MAC)
	local stab_trim = 0

	GW = GW * simConfigData["data"].SIM.kgs_to_lbs  --Formula uses LBS to calculate Stab TRIM.  GW passed in should always be in KGS.
	--print("GWin = "..GW.." MACin = "..CG_MAC)

	if GW > 1000 then
		GW = GW / 1000  --GW must be in 1000s of LBS
	end

	stab_trim = (0.000000717 * GW^2 - 0.001217 * GW + 0.24) * CG_MAC + (-0.0000309 * GW^2 + 0.05558 * GW - 12.24)  --GW must be in 1000s of LBS

	--Stab Trim can never be less than zero
	if stab_trim < 0 then
		stab_trim = 0
	end

	wb.stab_trim	= stab_trim
	fmsModules["data"].stab_trim 	= string.format("%4.1f", wb.stab_trim)
	B777DR_elevator_trim = fmsModules["data"].stab_trim  --Set STAB TRIM for green band calculation
	--print("Setting trim_mid = "..B777DR_elevator_trim)
	--print("Trim = "..fmsModules["data"].stab_trim)
end

function calc_CGMAC()

	local inch_to_meters	= 39.3700787

	--Setup initial weights
	wb.OEW_weight				= simDR_empty_weight
	wb.fuel_CTR_0_weight		= simDR_fuel_qty[0]
	wb.fuel_L_main1_weight		= simDR_fuel_qty[1]
	wb.fuel_L_main2_weight		= simDR_fuel_qty[2]
	wb.fuel_R_main3_weight		= simDR_fuel_qty[3]
	wb.fuel_R_main4_weight		= simDR_fuel_qty[4]
	wb.fuel_L_rsv5_weight		= simDR_fuel_qty[5]
	wb.fuel_R_rsv6_weight		= simDR_fuel_qty[6]
	wb.fuel_stab7_weight		= simDR_fuel_qty[7]

	--CG variables (in inches from reference point)
	local GW				= wb.OEW_weight + wb.fuel_CTR_0_weight + wb.fuel_L_main1_weight + wb.fuel_L_main2_weight + wb.fuel_R_main3_weight + wb.fuel_R_main4_weight
								+ wb.fuel_L_rsv5_weight + wb.fuel_R_rsv6_weight + wb.fuel_stab7_weight + wb.passenger_zoneA_weight + wb.passenger_zoneB_weight
								+ wb.passenger_zoneC_weight + wb.passenger_zoneD_weight + wb.passenger_zoneE_weight
								+ wb.fwd_lower_cargo_weight + wb.aft_lower_cargo_weight + wb.bulk_lower_cargo_weight
								+ wb.freight_zoneA_weight + wb.freight_zoneB_weight + wb.freight_zoneC_weight
								+ wb.freight_zoneD_weight + wb.freight_zoneE_weight
	local total_moment		= (wb.OEW_weight * wb.OEW_distance) + (wb.fuel_CTR_0_weight * wb.fuel_CTR_0_distance) + (wb.fuel_L_main1_weight * wb.fuel_L_main1_distance)
								+ (wb.fuel_L_main2_weight * wb.fuel_L_main2_distance) + (wb.fuel_R_main3_weight * wb.fuel_R_main3_distance)
								+ (wb.fuel_R_main4_weight * wb.fuel_R_main4_distance) + (wb.fuel_L_rsv5_weight * wb.fuel_L_rsv5_distance)
								+ (wb.fuel_R_rsv6_weight * wb.fuel_R_rsv6_distance) + (wb.fuel_stab7_weight * wb.fuel_stab7_distance)
								+ (wb.passenger_zoneA_weight * wb.passenger_zoneA_distance) + (wb.passenger_zoneB_weight * wb.passenger_zoneB_distance)
								+ (wb.passenger_zoneC_weight * wb.passenger_zoneC_distance) + (wb.passenger_zoneD_weight * wb.passenger_zoneD_distance)
								+ (wb.passenger_zoneE_weight * wb.passenger_zoneE_distance) + (wb.fwd_lower_cargo_weight * wb.fwd_lower_cargo_distance)
								+ (wb.aft_lower_cargo_weight * wb.aft_lower_cargo_distance) + (wb.bulk_lower_cargo_weight * wb.bulk_lower_cargo_distance)
								+ (wb.freight_zoneA_weight * wb.freight_zoneA_distance) + (wb.freight_zoneB_weight * wb.freight_zoneB_distance)
								+ (wb.freight_zoneC_weight * wb.freight_zoneC_distance) + (wb.freight_zoneD_weight * wb.freight_zoneD_distance)
								+ (wb.freight_zoneE_weight * wb.freight_zoneE_distance)
	local CG				= total_moment / GW
	local wing_root_chord	= 648.99996  --54.10 feet (from the aircraft .acf file)
	local wing_tip_chord	= 159.99996  --13.40 feet (from the aircraft .acf file)
	local wing_taper		= wing_tip_chord / wing_root_chord
	local MAC				= (2/3) * wing_root_chord * ((1 + wing_taper + wing_taper^2) / (1 + wing_taper))
	local LEMAC				= 1129.87932  --Approximately 94.18 feet as measured by where the default XP CG hits the 25% chord line at MAC and subtracting the 25% from the
										  --default CG reference point of 1243.32 inches (103.61 feet)
	local dist_default_CG	= 1243.32  --103.61 feet (from the aircraft .acf file)
	local dist_aft_LEMAC	= CG - LEMAC
	local CG_shift			= (dist_default_CG - CG) / inch_to_meters  --determine how far ahead or behind the OEW CG we are
	local CG_MAC			= (dist_aft_LEMAC / MAC) * 100
		
	wb.cg_mac 				= CG_MAC
	
	fmsModules["data"].cg_mac 		= string.format("%2.0f", wb.cg_mac)
	calc_stab_trim(GW, CG_MAC)

	simDR_cg_adjust = CG_shift * -1  --Value is flipped from what is in the XP slider
	
	--print("Dist = "..dist_default_CG.." - "..CG)
	--print("CG Shift = "..CG_shift)
	--print("OEW weight = "..wb.OEW_weight)
	--print("OEW distance = "..wb.OEW_distance)
	--print("Fuel = "..simDR_fuel_qty[0])
	--print("Fuel = "..wb.fuel_CTR_0_weight)
	--print("CG %MAC = "..wb.cg_mac)
	--print("Stab Trim = "..wb.stab_trim)
	--print("GW = "..GW)
end

function inflight_update_CG()

	local inch_to_meters	= 39.3700787
	
	--Setup initial weights
	wb.OEW_weight				= simDR_empty_weight
	wb.fuel_CTR_0_weight		= simDR_fuel_qty[0]
	wb.fuel_L_main1_weight		= simDR_fuel_qty[1]
	wb.fuel_L_main2_weight		= simDR_fuel_qty[2]
	wb.fuel_R_main3_weight		= simDR_fuel_qty[3]
	wb.fuel_R_main4_weight		= simDR_fuel_qty[4]
	wb.fuel_L_rsv5_weight		= simDR_fuel_qty[5]
	wb.fuel_R_rsv6_weight		= simDR_fuel_qty[6]
	wb.fuel_stab7_weight		= simDR_fuel_qty[7]

	--CG variables (in inches from reference point)
	local GW				= wb.OEW_weight + wb.fuel_CTR_0_weight + wb.fuel_L_main1_weight + wb.fuel_L_main2_weight + wb.fuel_R_main3_weight + wb.fuel_R_main4_weight
								+ wb.fuel_L_rsv5_weight + wb.fuel_R_rsv6_weight + wb.fuel_stab7_weight + wb.passenger_zoneA_weight + wb.passenger_zoneB_weight
								+ wb.passenger_zoneC_weight + wb.passenger_zoneD_weight + wb.passenger_zoneE_weight
								+ wb.fwd_lower_cargo_weight + wb.aft_lower_cargo_weight + wb.bulk_lower_cargo_weight
								+ wb.freight_zoneA_weight + wb.freight_zoneB_weight + wb.freight_zoneC_weight
								+ wb.freight_zoneD_weight + wb.freight_zoneE_weight
	local total_moment		= (wb.OEW_weight * wb.OEW_distance) + (wb.fuel_CTR_0_weight * wb.fuel_CTR_0_distance) + (wb.fuel_L_main1_weight * wb.fuel_L_main1_distance)
								+ (wb.fuel_L_main2_weight * wb.fuel_L_main2_distance) + (wb.fuel_R_main3_weight * wb.fuel_R_main3_distance)
								+ (wb.fuel_R_main4_weight * wb.fuel_R_main4_distance) + (wb.fuel_L_rsv5_weight * wb.fuel_L_rsv5_distance)
								+ (wb.fuel_R_rsv6_weight * wb.fuel_R_rsv6_distance) + (wb.fuel_stab7_weight * wb.fuel_stab7_distance)
								+ (wb.passenger_zoneA_weight * wb.passenger_zoneA_distance) + (wb.passenger_zoneB_weight * wb.passenger_zoneB_distance)
								+ (wb.passenger_zoneC_weight * wb.passenger_zoneC_distance) + (wb.passenger_zoneD_weight * wb.passenger_zoneD_distance)
								+ (wb.passenger_zoneE_weight * wb.passenger_zoneE_distance) + (wb.fwd_lower_cargo_weight * wb.fwd_lower_cargo_distance)
								+ (wb.aft_lower_cargo_weight * wb.aft_lower_cargo_distance) + (wb.bulk_lower_cargo_weight * wb.bulk_lower_cargo_distance)
								+ (wb.freight_zoneA_weight * wb.freight_zoneA_distance) + (wb.freight_zoneB_weight * wb.freight_zoneB_distance)
								+ (wb.freight_zoneC_weight * wb.freight_zoneC_distance) + (wb.freight_zoneD_weight * wb.freight_zoneD_distance)
								+ (wb.freight_zoneE_weight * wb.freight_zoneE_distance)

	local CG				= total_moment / GW
	local dist_default_CG	= 1243.32  --103.61 feet (from the aircraft .acf file)
	local cg_shift			= (dist_default_CG - CG) / inch_to_meters  --determine how far ahead or behind the OEW CG we are

	simDR_cg_adjust = cg_shift * -1  --Value is flipped from what is in the XP slider

	--print("Dist = "..dist_default_CG.." - "..CG)
	--print("CG Shift = "..cg_shift)
end
--Marauder28
--744 WB end
]]