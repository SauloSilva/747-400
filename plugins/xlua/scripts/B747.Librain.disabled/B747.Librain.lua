
-- IMPLEMENTATION OF LIBRAIN VIA XLUA
--
-- ILIAS TSELIOS - FEB 2020


----------------------------------- LOCATE DATAREFS OR COMMANDS -----------------------------------
rain_verbose                = find_dataref("librain/verbose")
rain_debug_draw             = find_dataref("librain/debug_draw")
rain_wipers                 = find_dataref("librain/wipers_visible")

frontGlass_slant            = find_dataref("librain/glass_0/slant_factor")
frontGlass_tp_x             = find_dataref("librain/glass_0/thrust_point/x")
frontGlass_tp_y             = find_dataref("librain/glass_0/thrust_point/y")
frontGlass_thrust_factor    = find_dataref("librain/glass_0/thrust_factor")
frontGlass_max_thrust       = find_dataref("librain/glass_0/max_thrust")
frontGlass_gp_x             = find_dataref("librain/glass_0/gravity_point/x")
frontGlass_gp_y             = find_dataref("librain/glass_0/gravity_point/y")
frontGlass_gravity_factor   = find_dataref("librain/glass_0/gravity_factor")
frontGlass_wp_x             = find_dataref("librain/glass_0/wind_point/x")
frontGlass_wp_y             = find_dataref("librain/glass_0/wind_point/y")
frontGlass_wind_factor      = find_dataref("librain/glass_0/wind_factor")
frontGlass_max_tas          = find_dataref("librain/glass_0/max_tas")
frontGlass_obj              = find_dataref("librain/glass_0/obj/filename")
frontGlass_obj_offX         = find_dataref("librain/glass_0/obj/pos_offset/x")
frontGlass_obj_offY         = find_dataref("librain/glass_0/obj/pos_offset/y")
frontGlass_obj_offZ         = find_dataref("librain/glass_0/obj/pos_offset/z")
frontGlass_load             = find_dataref("librain/glass_0/obj/load")
frontGlass_loaded           = find_dataref("librain/glass_0/obj/loaded")
frontGlass_wind_normal      = find_dataref("librain/glass_0/wind_normal")

frontGlass_wiper1_angle		= find_dataref("librain/glass_0/wiper_0/angle")
frontGlass_wiper1_moving	= find_dataref("librain/glass_0/wiper_0/moving")
frontGlass_wiper1_pvt_x		= find_dataref("librain/glass_0/wiper_0/pivot/x")
frontGlass_wiper1_pvt_y		= find_dataref("librain/glass_0/wiper_0/pivot/y")
frontGlass_wiper1_rad_in	= find_dataref("librain/glass_0/wiper_0/radius_inner")
frontGlass_wiper1_rad_out	= find_dataref("librain/glass_0/wiper_0/radius_outer")
frontGlass_wiper2_angle		= find_dataref("librain/glass_1/wiper_0/angle")
frontGlass_wiper2_moving	= find_dataref("librain/glass_1/wiper_0/moving")
frontGlass_wiper2_pvt_x		= find_dataref("librain/glass_1/wiper_0/pivot/x")
frontGlass_wiper2_pvt_y		= find_dataref("librain/glass_1/wiper_0/pivot/y")
frontGlass_wiper2_rad_in	= find_dataref("librain/glass_1/wiper_0/radius_inner")
frontGlass_wiper2_rad_out	= find_dataref("librain/glass_1/wiper_0/radius_outer")

sideGlass_slant            = find_dataref("librain/glass_1/slant_factor")
sideGlass_tp_x             = find_dataref("librain/glass_1/thrust_point/x")
sideGlass_tp_y             = find_dataref("librain/glass_1/thrust_point/y")
sideGlass_thrust_factor    = find_dataref("librain/glass_1/thrust_factor")
sideGlass_max_thrust       = find_dataref("librain/glass_1/max_thrust")
sideGlass_gp_x             = find_dataref("librain/glass_1/gravity_point/x")
sideGlass_gp_y             = find_dataref("librain/glass_1/gravity_point/y")
sideGlass_gravity_factor   = find_dataref("librain/glass_1/gravity_factor")
sideGlass_wp_x             = find_dataref("librain/glass_1/wind_point/x")
sideGlass_wp_y             = find_dataref("librain/glass_1/wind_point/y")
sideGlass_wind_factor      = find_dataref("librain/glass_1/wind_factor")
sideGlass_max_tas          = find_dataref("librain/glass_1/max_tas")
sideGlass_obj              = find_dataref("librain/glass_1/obj/filename")
sideGlass_obj_offX         = find_dataref("librain/glass_1/obj/pos_offset/x")
sideGlass_obj_offY         = find_dataref("librain/glass_1/obj/pos_offset/y")
sideGlass_obj_offZ         = find_dataref("librain/glass_1/obj/pos_offset/z")
sideGlass_load             = find_dataref("librain/glass_1/obj/load")
sideGlass_loaded           = find_dataref("librain/glass_0/obj/loaded")
sideGlass_wind_normal      = find_dataref("librain/glass_0/wind_normal")

backGlass_slant            = find_dataref("librain/glass_2/slant_factor")
backGlass_tp_x             = find_dataref("librain/glass_2/thrust_point/x")
backGlass_tp_y             = find_dataref("librain/glass_2/thrust_point/y")
backGlass_thrust_factor    = find_dataref("librain/glass_2/thrust_factor")
backGlass_max_thrust       = find_dataref("librain/glass_2/max_thrust")
backGlass_gp_x             = find_dataref("librain/glass_2/gravity_point/x")
backGlass_gp_y             = find_dataref("librain/glass_2/gravity_point/y")
backGlass_gravity_factor   = find_dataref("librain/glass_2/gravity_factor")
backGlass_wp_x             = find_dataref("librain/glass_2/wind_point/x")
backGlass_wp_y             = find_dataref("librain/glass_2/wind_point/y")
backGlass_wind_factor      = find_dataref("librain/glass_2/wind_factor")
backGlass_max_tas          = find_dataref("librain/glass_2/max_tas")
backGlass_obj              = find_dataref("librain/glass_2/obj/filename")
backGlass_obj_offX         = find_dataref("librain/glass_2/obj/pos_offset/x")
backGlass_obj_offY         = find_dataref("librain/glass_2/obj/pos_offset/y")
backGlass_obj_offZ         = find_dataref("librain/glass_2/obj/pos_offset/z")
backGlass_load             = find_dataref("librain/glass_2/obj/load")
backGlass_loaded           = find_dataref("librain/glass_0/obj/loaded")
backGlass_wind_normal      = find_dataref("librain/glass_0/wind_normal")

z_obj_obj0_name             = find_dataref("librain/z_depth_obj_0/filename")
z_obj_obj0_load             = find_dataref("librain/z_depth_obj_0/load")
z_obj_obj0_loaded           = find_dataref("librain/z_depth_obj_0/loaded")
z_obj_obj0_offX             = find_dataref("librain/z_depth_obj_0/pos_offset/x")
z_obj_obj0_offY             = find_dataref("librain/z_depth_obj_0/pos_offset/y")
z_obj_obj0_offZ             = find_dataref("librain/z_depth_obj_0/pos_offset/z")

z_obj_obj1_name             = find_dataref("librain/z_depth_obj_1/filename")
z_obj_obj1_load             = find_dataref("librain/z_depth_obj_1/load")
z_obj_obj1_loaded           = find_dataref("librain/z_depth_obj_1/loaded")
z_obj_obj1_offX             = find_dataref("librain/z_depth_obj_1/pos_offset/x")
z_obj_obj1_offY             = find_dataref("librain/z_depth_obj_1/pos_offset/y")
z_obj_obj1_offZ             = find_dataref("librain/z_depth_obj_1/pos_offset/z")

z_obj_obj2_name             = find_dataref("librain/z_depth_obj_2/filename")
z_obj_obj2_load             = find_dataref("librain/z_depth_obj_2/load")
z_obj_obj2_loaded           = find_dataref("librain/z_depth_obj_2/loaded")
z_obj_obj2_offX             = find_dataref("librain/z_depth_obj_2/pos_offset/x")
z_obj_obj2_offY             = find_dataref("librain/z_depth_obj_2/pos_offset/y")
z_obj_obj2_offZ             = find_dataref("librain/z_depth_obj_2/pos_offset/z")

z_obj_obj3_name             = find_dataref("librain/z_depth_obj_3/filename")
z_obj_obj3_load             = find_dataref("librain/z_depth_obj_3/load")
z_obj_obj3_loaded           = find_dataref("librain/z_depth_obj_3/loaded")
z_obj_obj3_offX             = find_dataref("librain/z_depth_obj_3/pos_offset/x")
z_obj_obj3_offY             = find_dataref("librain/z_depth_obj_3/pos_offset/y")
z_obj_obj3_offZ             = find_dataref("librain/z_depth_obj_3/pos_offset/z")

z_obj_obj4_name             = find_dataref("librain/z_depth_obj_4/filename")
z_obj_obj4_load             = find_dataref("librain/z_depth_obj_4/load")
z_obj_obj4_loaded           = find_dataref("librain/z_depth_obj_4/loaded")
z_obj_obj4_offX             = find_dataref("librain/z_depth_obj_4/pos_offset/x")
z_obj_obj4_offY             = find_dataref("librain/z_depth_obj_4/pos_offset/y")
z_obj_obj4_offZ             = find_dataref("librain/z_depth_obj_4/pos_offset/z")

--z_obj_obj5_name             = find_dataref("librain/z_depth_obj_5/filename")
--z_obj_obj5_load             = find_dataref("librain/z_depth_obj_5/load")
--z_obj_obj5_loaded           = find_dataref("librain/z_depth_obj_5/loaded")
--z_obj_obj5_offX             = find_dataref("librain/z_depth_obj_5/pos_offset/x")
--z_obj_obj5_offY             = find_dataref("librain/z_depth_obj_5/pos_offset/y")
--z_obj_obj5_offZ             = find_dataref("librain/z_depth_obj_5/pos_offset/z")
--
--z_obj_obj6_name             = find_dataref("librain/z_depth_obj_6/filename")
--z_obj_obj6_load             = find_dataref("librain/z_depth_obj_6/load")
--z_obj_obj6_loaded           = find_dataref("librain/z_depth_obj_6/loaded")
--z_obj_obj6_offX             = find_dataref("librain/z_depth_obj_6/pos_offset/x")
--z_obj_obj6_offY             = find_dataref("librain/z_depth_obj_6/pos_offset/y")
--z_obj_obj6_offZ             = find_dataref("librain/z_depth_obj_6/pos_offset/z")


rain_numglass               = find_dataref("librain/num_glass_use")
rain_init                   = find_dataref("librain/initialize")



--------------------------------- DO THIS EACH FLIGHT START ---------------------------------
function flight_start()

rain_init = 0

	log("[B744_DEBUG]: " .. path())   -- write in the log.txt the path for debugging
	
	--obj_path						= "../../../objects/librain/"
	librain_path    				= acfFolder .. "/objects/librain/"	--"Aircraft/Laminar Research/Cessna 172SP/objects/librain/"
	mask_path						= acfFolder .. "/objects/"		--"Aircraft/Laminar Research/Cessna 172SP/objects/"
	
	local frontGlass	             = librain_path .. "frontGlass.obj"
	--local sideGlass	            	 = librain_path .. "sideGlass.obj"
	--local backGlass		             = librain_path .. "backGlass.obj"
	local mask0_obj                  = mask_path .. "747_cockpit/Cockpit_main.obj"
	local mask1_obj                  = mask_path .. "747_cockpit/Cockpit_GS.obj"
	local mask2_obj                  = mask_path .. "747_cockpit/Cockpit_MCP.obj"
	local mask3_obj                  = mask_path .. "747_cockpit/Cockpit_Seats.obj"
	local mask4_obj                  = mask_path .. "747_cockpit/Cockpit_Panel.obj"
	-- local mask5_obj                  = mask_path .. "cockpit_seats_rear.obj"

	local off_set = {x = 0.0, y = 0.18, z = 0.0}
	
	rain_numglass = 1
	
	rain_verbose = 1
	rain_debug_draw = 0
	rain_wipers = 0
	
	frontGlass_slant = 0.8
	frontGlass_tp_x = 0
	frontGlass_tp_y = 0
	frontGlass_thrust_factor = 0
	frontGlass_max_thrust = 0
	frontGlass_gp_x = 0.5
	frontGlass_gp_y = 1.3
	frontGlass_gravity_factor = 0.98
	frontGlass_wp_x = 0.5
	frontGlass_wp_y = -2.0
	frontGlass_wind_factor = 1.0
	frontGlass_wind_normal = 1.0
	frontGlass_max_tas = 300
	frontGlass_obj = frontGlass
	frontGlass_obj_offX = off_set.x
	frontGlass_obj_offY = off_set.y
	frontGlass_obj_offZ = off_set.z
	frontGlass_load = 1
	
	frontGlass_wiper1_pvt_x = 0.65
	frontGlass_wiper1_pvt_y = -0.15
	frontGlass_wiper1_rad_in = 0.2
	frontGlass_wiper1_rad_out = 0.72
			
	-- frontGlass_wiper2_pvt_x = 0.8
	-- frontGlass_wiper2_pvt_y = -0.05
	-- frontGlass_wiper2_rad_in = 0.15
	-- frontGlass_wiper2_rad_out = 0.63
	
	
	-- sideGlass_slant = 0.95
	-- sideGlass_tp_x = 0.0
	-- sideGlass_tp_y = 0.0
	-- sideGlass_thrust_factor = 0.0
	-- sideGlass_max_thrust = 1800
	-- sideGlass_gp_x = 0.5
	-- sideGlass_gp_y = 2.0
	-- sideGlass_gravity_factor = 0.7
	-- sideGlass_wp_x = 0.5
	-- sideGlass_wp_y = -1.1
	-- sideGlass_wind_factor = 1.0
	-- sideGlass_wind_normal = 0.0
	-- sideGlass_max_tas = 60
	-- sideGlass_obj = sideGlass
	-- sideGlass_obj_offX = 0.0
	-- sideGlass_obj_offY = 0.0
	-- sideGlass_obj_offZ = 0.0
	-- sideGlass_load = 1



	z_obj_obj0_name = mask0_obj
	z_obj_obj0_offX = off_set.x
	z_obj_obj0_offY = off_set.y
	z_obj_obj0_offZ = off_set.z
	z_obj_obj0_load = 1
	
	z_obj_obj1_name = mask1_obj
	z_obj_obj1_offX = off_set.x
	z_obj_obj1_offY = off_set.y
	z_obj_obj1_offZ = off_set.z
	z_obj_obj1_load = 1
	
	z_obj_obj2_name = mask2_obj
	z_obj_obj2_offX = off_set.x
	z_obj_obj2_offY = off_set.y
	z_obj_obj2_offZ = off_set.z
	z_obj_obj2_load = 1
	
	z_obj_obj3_name = mask3_obj
	z_obj_obj3_offX = off_set.x
	z_obj_obj3_offY = off_set.y
	z_obj_obj3_offZ = off_set.z
	z_obj_obj3_load = 1
	
	
	z_obj_obj4_name = mask4_obj
	z_obj_obj4_offX = off_set.x
	z_obj_obj4_offY = off_set.y
	z_obj_obj4_offZ = off_set.z
	z_obj_obj4_load = 1
	
	-- z_obj_obj5_name = mask5_obj
	-- z_obj_obj5_offY = 0
	-- z_obj_obj5_offX = 0
	-- z_obj_obj5_offZ = 0
	-- z_obj_obj5_load = 1

	--z_obj_obj6_name = mask6_obj
	--z_obj_obj6_offY = 0
	--z_obj_obj6_offX = 0
	--z_obj_obj6_offZ = 0
	--z_obj_obj6_load = 1

	rain_init = 1
	

end



--------------------------------- REGULAR RUNTIME ---------------------------------




function flight_crash()
	
	rain_init = 0
end



function aircraft_unload()
	
	rain_init = 0
	
end

