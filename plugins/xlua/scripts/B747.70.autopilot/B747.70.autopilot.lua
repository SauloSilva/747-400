--[[
*****************************************************************************************
* Program Script Name	:	B747.70.autopilot
* Author Name			:	Jim Gregory
*
*   Revisions:
*   -- DATE --	--- REV NO ---		--- DESCRIPTION ---
*   2016-04-26	0.01a				Start of Dev
*
*
*
*
*****************************************************************************************
*        COPYRIGHT � 2016 JIM GREGORY / LAMINAR RESEARCH - ALL RIGHTS RESERVED
*****************************************************************************************
--]]



--*************************************************************************************--
--** 					              XLUA GLOBALS              				     **--
--*************************************************************************************--

--[[

SIM_PERIOD - this contains the duration of the current frame in seconds (so it is alway a
fraction).  Use this to normalize rates,  e.g. to add 3 units of fuel per second in a
per-frame callback you’d do fuel = fuel + 3 * SIM_PERIOD.

IN_REPLAY - evaluates to 0 if replay is off, 1 if replay mode is on

--]]


--*************************************************************************************--
--** 					               CONSTANTS                    				 **--
--*************************************************************************************--

NUM_AUTOPILOT_BUTTONS = 15




--*************************************************************************************--
--** 					            GLOBAL VARIABLES                				 **--
--*************************************************************************************--



--*************************************************************************************--
--** 					            LOCAL VARIABLES                 				 **--
--*************************************************************************************--

local B747_ap_button_switch_position_target = {}
for i = 0, NUM_AUTOPILOT_BUTTONS-1 do
    B747_ap_button_switch_position_target[i] = 0
end


local B747_ap_last_AFDS_status = 0
local B747_ap_last_FMA_autothrottle_mode = 0
local B747_ap_last_FMA_roll_mode = 0
local B747_ap_last_FMA_pitch_mode = 0



--*************************************************************************************--
--** 				             FIND X-PLANE DATAREFS           			    	 **--
--*************************************************************************************--

simDR_autopilot_flight_dir_mode     	= find_dataref("sim/cockpit2/autopilot/flight_director_mode")
simDR_autopilot_autothrottle_enabled	= find_dataref("sim/cockpit2/autopilot/autothrottle_enabled")
simDR_autopilot_autothrottle_on      	= find_dataref("sim/cockpit2/autopilot/autothrottle_on")
simDR_autopilot_bank_limit          	= find_dataref("sim/cockpit2/autopilot/bank_angle_mode")
simDR_autopilot_airspeed_is_mach		= find_dataref("sim/cockpit2/autopilot/airspeed_is_mach")
simDR_autopilot_altitude_ft    			= find_dataref("sim/cockpit2/autopilot/altitude_dial_ft")
simDR_autopilot_airspeed_kts   			= find_dataref("sim/cockpit2/autopilot/airspeed_dial_kts")
simDR_autopilot_airspeed_kts_mach   	= find_dataref("sim/cockpit2/autopilot/airspeed_dial_kts_mach")
simDR_autopilot_heading_deg         	= find_dataref("sim/cockpit2/autopilot/heading_dial_deg_mag_pilot")
simDR_autopilot_vs_fpm         			= find_dataref("sim/cockpit2/autopilot/vvi_dial_fpm")
simDR_autopilot_vs_status          		= find_dataref("sim/cockpit2/autopilot/vvi_status")
simDR_autopilot_flch_status         	= find_dataref("sim/cockpit2/autopilot/speed_status")
simDR_autopilot_TOGA_vert_status    	= find_dataref("sim/cockpit2/autopilot/TOGA_status")
simDR_autopilot_TOGA_lat_status     	= find_dataref("sim/cockpit2/autopilot/TOGA_lateral_status")
simDR_autopilot_heading_status      	= find_dataref("sim/cockpit2/autopilot/heading_status")  
simDR_autopilot_heading_hold_status     = find_dataref("sim/cockpit2/autopilot/heading_hold_status")
simDR_autopilot_alt_hold_status     	= find_dataref("sim/cockpit2/autopilot/altitude_hold_status")
simDR_autopilot_nav_status          	= find_dataref("sim/cockpit2/autopilot/nav_status")
simDR_autopilot_gs_status           	= find_dataref("sim/cockpit2/autopilot/glideslope_status")
simDR_autopilot_approach_status     	= find_dataref("sim/cockpit2/autopilot/approach_status")
simDR_autopilot_roll_sync_degrees   	= find_dataref("sim/cockpit2/autopilot/sync_hold_roll_deg")
simDR_autopilot_roll_status         	= find_dataref("sim/cockpit2/autopilot/roll_status")
simDR_autopilot_servos_on           	= find_dataref("sim/cockpit2/autopilot/servos_on")
simDR_autopilot_TOGA_pitch_deg      	= find_dataref("sim/cockpit2/autopilot/TOGA_pitch_deg")
simDR_autopilot_fms_vnav				= find_dataref("sim/cockpit2/autopilot/fms_vnav")
simDR_autopilot_gpss					= find_dataref("sim/cockpit2/autopilot/gpss_status")
simDR_autopilot_pitch					= find_dataref("sim/cockpit2/autopilot/pitch_status")

simDR_airspeed_mach                 	= find_dataref("sim/flightmodel/misc/machno")
simDR_vvi_fpm_pilot                 	= find_dataref("sim/cockpit2/gauges/indicators/vvi_fpm_pilot")
simDR_ind_airspeed_kts_pilot        	= find_dataref("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
simDR_autopilot_nav_source          	= find_dataref("sim/cockpit2/radios/actuators/HSI_source_select_pilot")
simDR_AHARS_roll_deg_pilot          	= find_dataref("sim/cockpit2/gauges/indicators/roll_AHARS_deg_pilot")
simDR_AHARS_heading_deg_pilot       	= find_dataref("sim/cockpit2/gauges/indicators/heading_AHARS_deg_mag_pilot")
simDR_nav1_radio_course_deg         	= find_dataref("sim/cockpit2/radios/actuators/nav1_course_deg_mag_pilot")

simDR_nav1_radio_nav_type           	= find_dataref("sim/cockpit2/radios/indicators/nav1_type")
--[[
    0 = UNKNONW
    4 = VOR
    8 = ILS WITHOUT GLIDESLOPE
   16 = LOCALIZER (ONLY)
   32 = GLIDESLOPE
   40 = ILS WITH GLIDESLOPE
-]]








--*************************************************************************************--
--** 				              FIND CUSTOM DATAREFS             			    	 **--
--*************************************************************************************--

B747DR_toggle_switch_position       	= find_dataref("laminar/B747/toggle_switch/position")
B747DR_CAS_caution_status       		= find_dataref("laminar/B747/CAS/caution_status")



--*************************************************************************************--
--** 				             FIND X-PLANE COMMANDS                   	    	 **--
--*************************************************************************************--

simCMD_autopilot_autothrottle_on		= find_command("sim/autopilot/autothrottle_on")
simCMD_autopilot_autothrottle_off		= find_command("sim/autopilot/autothrottle_off")
--simCMD_autopilot_toggle_knots_mach  	= find_command("sim/autopilot/knots_mach_toggle")
simCMD_autopilot_roll_right_sync_mode	= find_command("sim/autopilot/override_right")
simCMD_autopilot_servos_on              = find_command("sim/autopilot/servos_on")
simCMD_autopilot_servos_fdir_off        = find_command("sim/autopilot/servos_fdir_off")
simCMD_autopilot_fdir_off        		= find_command("sim/autopilot/servos_fdir_off")
simCMD_autopilot_fdir_servos_down_one   = find_command("sim/autopilot/fdir_servos_down_one")
simCMD_autopilot_pitch_sync             = find_command("sim/autopilot/pitch_sync")
simCMD_autopilot_set_nav1_as_nav_source = find_command("sim/autopilot/hsi_select_nav_1")
simCMD_autopilot_nav_mode               = find_command("sim/autopilot/NAV")
simCMD_autopilot_wing_leveler           = find_command("sim/autopilot/wing_leveler")
simCMD_autopilot_heading_hold           = find_command("sim/autopilot/heading")
simCMD_autopilot_vert_speed_mode    	= find_command("sim/autopilot/vertical_speed")
simCMD_autopilot_alt_hold_mode			= find_command("sim/autopilot/altitude_hold")
simCMD_autopilot_glideslope_mode		= find_command("sim/autopilot/glide_slope")
simCMD_autopilot_flch_mode				= find_command("sim/autopilot/level_change")




--*************************************************************************************--
--** 				              FIND CUSTOM COMMANDS              			     **--
--*************************************************************************************--

B747DR_engine_TOGA_mode             	= find_dataref("laminar/B747/engines/TOGA_mode")



--*************************************************************************************--
--** 				        CREATE READ-ONLY CUSTOM DATAREFS               	         **--
--*************************************************************************************--

B747DR_ap_button_switch_position    	= create_dataref("laminar/B747/autopilot/button_switch/position", "array[" .. tostring(NUM_AUTOPILOT_BUTTONS) .. "]")
B747DR_ap_bank_limit_sel_dial_pos   	= create_dataref("laminar/B747/autopilot/bank_limit/sel_dial_pos", "number")
B747DR_ap_ias_mach_window_open      	= create_dataref("laminar/B747/autopilot/ias_mach/window_open", "number")
B747DR_ap_vs_window_open            	= create_dataref("laminar/B747/autopilot/vert_spd/window_open", "number")
B747DR_ap_vs_show_thousands         	= create_dataref("laminar/B747/autopilot/vert_speed/show_thousands", "number")
--B747DR_ap_hdg_hold_mode             	= create_dataref("laminar/B747/autopilot/heading_hold_mode", "number")
--B747DR_ap_hdg_sel_mode              	= create_dataref("laminar/B747/autopilot/heading_sel_mode", "number")
B747DR_ap_heading_deg               	= create_dataref("laminar/B747/autopilot/heading/degrees", "number")
B747DR_ap_ias_dial_value            	= create_dataref("laminar/B747/autopilot/ias_dial_value", "number")
B747DR_ap_vvi_fpm						= create_dataref("laminar/B747/autopilot/vvi_fpm", "number")
B747DR_ap_alt_show_thousands      		= create_dataref("laminar/B747/autopilot/altitude/show_thousands", "number")
B747DR_ap_alt_show_tenThousands			= create_dataref("laminar/B747/autopilot/altitude/show_tenThousands", "number")
B747DR_ap_cmd_L_mode         			= create_dataref("laminar/B747/autopilot/cmd_L_mode/status", "number")
B747DR_ap_cmd_C_mode         			= create_dataref("laminar/B747/autopilot/cmd_C_mode/status", "number")
B747DR_ap_cmd_R_mode         			= create_dataref("laminar/B747/autopilot/cmd_R_mode/status", "number")
B747DR_ap_autothrottle_armed        	= create_dataref("laminar/B747/autothrottle/armed", "number")
B747DR_ap_mach_decimal_visibiilty	    = create_dataref("laminar/B747/autopilot/mach_dec_vis", "number")





B747DR_ap_FMA_autothrottle_mode_box_status  = create_dataref("laminar/B747/autopilot/FMA/autothrottle/mode_box_status", "number")
B747DR_ap_roll_mode_box_status         	= create_dataref("laminar/B747/autopilot/FMA/roll/mode_box_status", "number")
B747DR_ap_pitch_mode_box_status        	= create_dataref("laminar/B747/autopilot/FMA/pitch/mode_box_status", "number")

B747DR_ap_FMA_autothrottle_mode     	= create_dataref("laminar/B747/autopilot/FMA/autothrottle_mode", "number")
--[[
    0 = NONE
    1 = HOLD
    2 = IDLE
    3 = SPD
    4 = THR
    5 = THR REF
--]]

B747DR_ap_FMA_armed_roll_mode       	= create_dataref("laminar/B747/autopilot/FMA/armed_roll_mode", "number")
--[[
    0 = NONE
    1 = TOGA
    2 = LNAV
    3 = LOC
    4 = ROLLOUT
    5 = ATT
    6 = HDG SEL
    7 = HDG HOLD
--]]

B747DR_ap_FMA_active_roll_mode      	= create_dataref("laminar/B747/autopilot/FMA/active_roll_mode", "number")
--[[
    0 = NONE
    1 = TOGA
    2 = LNAV
    3 = LOC
    4 = ROLLOUT
    5 = ATT
    6 = HDG SEL
    7 = HDG HOLD
--]]

B747DR_ap_FMA_armed_pitch_mode      	= create_dataref("laminar/B747/autopilot/FMA/armed_pitch_mode", "number")
--[[
    0 = NONE
    1 = TOGA
    2 = G/S
    3 = FLARE
    4 = VNAV
    7 = V/S
    8 = FLCH SPD
    9 = ALT
--]]

B747DR_ap_FMA_active_pitch_mode     	= create_dataref("laminar/B747/autopilot/FMA/active_pitch_mode", "number")
--[[
    0 = NONE
    1 = TOGA
    2 = G/S
    3 = FLARE
    4 = VNAV SPD
    5 = VNAV ALT
    6 = VNAV PATH
    7 = V/S
    8 = FLCH SPD
    9 = ALT
--]]




B747DR_ap_AFDS_mode_box_status      	= create_dataref("laminar/B747/autopilot/AFDS/mode_box_status", "number")
B747DR_ap_AFDS_mode_box2_status     	= create_dataref("laminar/B747/autopilot/AFDS/mode_box2_status", "number")

B747DR_ap_AFDS_status_annun            	= create_dataref("laminar/B747/autopilot/AFDS/status_annun", "number")
--[[
    0 = NONE
    1 = FD
    2 = CMD
    3 = LAND 2
    4 = LAND 3
    5 = NO AUTOLAND
--]]



--*************************************************************************************--
--** 				       READ-WRITE CUSTOM DATAREF HANDLERS     	        	     **--
--*************************************************************************************--



--*************************************************************************************--
--** 				       CREATE READ-WRITE CUSTOM DATAREFS                         **--
--*************************************************************************************--




--*************************************************************************************--
--** 				             CUSTOM COMMAND HANDLERS            			     **--
--*************************************************************************************--

function B747_ap_thrust_mode_CMDhandler(phase, duration)								-- INOP, NO CORRESPONDING FUNCTIONALITY IN X-PLANE 
	if phase == 0 then
		B747_ap_button_switch_position_target[0] = 1
	elseif phase == 2 then
		B747_ap_button_switch_position_target[0] = 0				
	end
end	




function B747_ap_switch_speed_mode_CMDhandler(phase, duration)
	if phase == 0 then
		B747_ap_button_switch_position_target[1] = 1									-- SET THE SPEED SWITCH ANIMATION TO "IN"
		if B747DR_toggle_switch_position[29] == 1 then									-- AUTOTHROTTLE ""ARM" SWITCH IS "ON"
			--B747DR_ap_ias_mach_window_open = 1											-- OPEN THE IAS/MACH WINDOW
			if simDR_autopilot_autothrottle_enabled == 0 then							-- AUTOTHROTTLE IS "OFF"
				simCMD_autopilot_autothrottle_on:once()									-- ACTIVATE THE AUTOTHROTTLE
				if B747DR_engine_TOGA_mode == 1 then B747DR_engine_TOGA_mode = 0 end	-- CANX ENGINE TOGA IF ACTIVE
			end	
		end		
	elseif phase == 2 then
		B747_ap_button_switch_position_target[1] = 0									-- SET THE SPEED SWITCH ANIMATION TO "OUT"				
	end
end	



function B747_ap_ias_mach_sel_button_CMDhandler(phase, duration) 						-- INOP, NO CORRESPONDING FUNCTIONALITY IN X-PLANE
	if phase == 0 then 
	    -- TODO: IN VNAV THIS ALTERNATELY OPENS AND CLOSES IAS/MACH WINDOW AND CONTROLS VNAV INTERACTION (FCOM Pg 643)
	    -- TODO: CURRENTLY INOP - THE CURRENT XP FMS DOES NOT ALLOW THIS OPTION				
	end
end



function B747_ap_switch_flch_mode_CMDhandler(phase, duration)
	if phase == 0 then 
		B747_ap_button_switch_position_target[4] = 1
		simCMD_autopilot_flch_mode:once()
		--if simDR_autopilot_flch_status == 0 then
		--	B747DR_ap_ias_mach_window_open = 1	
		--end	
	elseif phase == 2 then
		B747_ap_button_switch_position_target[4] = 0		
	end	
end	



function B747_ap_switch_vs_mode_CMDhandler(phase, duration)
	if phase == 0 then 
		B747_ap_button_switch_position_target[6] = 1
		simCMD_autopilot_vert_speed_mode:once()
		--if simDR_autopilot_vs_status < 1 then
		--	B747DR_ap_ias_mach_window_open = 1											-- OPEN THE IAS/MACH WINDOW
		--end					
	end
end



function B747_ap_alt_hold_mode_CMDhandler(phase, duration)
	if phase == 0 then
		B747DR_ap_ias_mach_window_open = 1	
		B747_ap_button_switch_position_target[7] = 1
		simCMD_autopilot_alt_hold_mode:once()
		--if simDR_autopilot_alt_hold_status < 2 then
			--simCMD_autopilot_alt_hold_mode:once()	
			--B747DR_ap_ias_mach_window_open = 1
		--end
	elseif phase == 2 then
		B747_ap_button_switch_position_target[7] = 0					
	end
end


--[[
function B747_ap_switch_hdg_sel_mode_CMDhandler(phase, duration)						-- CURRENTLY SET TO HEADING HOLD UNTIL NEW HOLD FEATURE IS IMPLEMENTED BY PHILIPP
	if phase == 0 then
		B747DR_ap_hdg_sel_mode = 1			
		B747DR_ap_hdg_hold_mode = 0
		simCMD_autopilot_heading_hold:once()
	end
end	




function B747_ap_switch_hdg_hold_mode_CMDhandler(phase, duration)						-- TODO:  HEADING HOLD MODE IS PENDING A NEW FEATURE FROM PHILIPP
	if phase == 0 then
		B747_ap_button_switch_position_target[5] = 1
		B747DR_ap_hdg_hold_mode = 1
		B747DR_ap_hdg_sel_mode = 0
	elseif phase == 2 then
		B747_ap_button_switch_position_target[5] = 0				
	end
end	
--]]



function B747_ap_switch_loc_mode_CMDhandler(phase, duration)
	if phase == 0 then
		B747_ap_button_switch_position_target[8] = 1									-- SET THE LOC SWITCH ANIMATION TO "IN"
		
		----- APPROACH MODE IS ARMED
		if simDR_autopilot_nav_status == 1 
			and simDR_autopilot_gs_status == 1
		then
			simCMD_autopilot_glideslope_mode:once()										-- CANX GLIDESLOPE MODE
			
			if B747DR_ap_cmd_L_mode == 1 then											-- LEFT AUTOPILOT IS ON
				B747_ap_all_cmd_modes_off()	
				B747DR_ap_cmd_L_mode = 1
	        end	       	
			
		----- LOC MODE (ONLY) IS ARMED
		elseif simDR_autopilot_nav_status == 1 
			and simDR_autopilot_gs_status == 0
		then
			simCMD_autopilot_nav_mode:once()											-- DISARM LOC MODE		
			
		----- LOC MODE IS OFF	 			 		
		elseif simDR_autopilot_nav_status == 0 
			and simDR_autopilot_gs_status == 0
		then	
			if simDR_nav1_radio_nav_type == 8											-- NAV1 RADIO TYPE IS "ILS WITHOUT GLIDESLOPE" 	|
	        	or simDR_nav1_radio_nav_type == 16 										-- NAV1 RADIO TYPE IS "LOC" (ONLY)				|-- ONLY VALID MODES TO SET A/P TO "LOC" MODE
	        	or simDR_nav1_radio_nav_type == 40										-- NAV1 RADIO TYPE IS "ILS WITH GLIDESLOPE"		|
			then
		    	simCMD_autopilot_nav_mode:once()										-- ARM/ACTIVATE LOC MODE
		    end	   
	    end 
	    				
	elseif phase == 2 then
		B747_ap_button_switch_position_target[8] = 0									-- SET THE LOC SWITCH ANIMATION TO "OUT"				
	end
end	



function B747_ap_switch_cmd_L_CMDhandler(phase, duration)
	if phase == 0 then
		B747_ap_button_switch_position_target[10] = 1									-- SET THE BUTTON ANIMATION TO "DOWN"
		if B747DR_ap_button_switch_position[14] == 0 then								-- DISENGAGE BAR IS "UP/OFF"		
			if B747DR_ap_cmd_L_mode == 0 then											-- LEFT CMD AP MODE IS "OFF"
				if simDR_autopilot_servos_on == 0 then									-- AUTOPILOT IS NOT ENGAGED
					if B747DR_toggle_switch_position[23] == 0 							-- LEFT FLIGHT DIRECTOR SWITCH IS "OFF"
						and B747DR_toggle_switch_position[24] == 0 						-- RIGHT FLIGHT DIRECTOR SWITCH IS "OFF"
					then	
						simCMD_autopilot_vert_speed_mode:once()							-- ACTIVATE "VS" MODE
						if math.abs(simDR_AHARS_roll_deg_pilot) < 5.0 then				-- BANK ANGLE LESS THAN 5 DEGREES
							simCMD_autopilot_heading_hold:once()						-- ACTIVATE "HEADING HOLD" MODE
						else
							B747CMD_ap_att_mode:once()									-- ACTIVATE "ATT" MODE		
						end
					end
				simCMD_autopilot_servos_on:once()										-- TURN THE AP SERVOS "ON"	
				end
			B747DR_ap_cmd_L_mode = 1													-- SET AP CMD L MODE TO "ON"	
			end
		end
	elseif phase == 2 then
		B747_ap_button_switch_position_target[10] = 0									-- SET THE BUTTON ANIMATION TO "UP"			
	end
end	




function B747_ap_switch_cmd_C_CMDhandler(phase, duration)
	if phase == 0 then
		B747_ap_button_switch_position_target[11] = 1									-- SET THE BUTTON ANIMATION TO "DOWN"
		if B747DR_ap_button_switch_position[14] == 0 then								-- DISENGAGE BAR IS "UP/OFF"		
			if B747DR_ap_cmd_C_mode == 0 then											-- CENTER CMD AP MODE IS "OFF"
				if simDR_autopilot_servos_on == 0 then									-- AUTOPILOT IS NOT ENGAGED
					if B747DR_toggle_switch_position[23] == 0 							-- LEFT FLIGHT DIRECTOR SWITCH IS "OFF"
						and B747DR_toggle_switch_position[24] == 0 						-- RIGHT FLIGHT DIRECTOR SWITCH IS "OFF"
					then	
						simCMD_autopilot_vert_speed_mode:once()							-- ACTIVATE "VS" MODE
						if math.abs(simDR_AHARS_roll_deg_pilot) < 5.0 then				-- BANK ANGLE LESS THAN 5 DEGREES
							simCMD_autopilot_heading_hold:once()						-- ACTIVATE "HEADING HOLD" MODE
						else
							B747CMD_ap_att_mode:once()									-- ACTIVATE "ATT" MODE		
						end
					end
				simCMD_autopilot_servos_on:once()										-- TURN THE AP SERVOS "ON"	
				end
			B747DR_ap_cmd_C_mode = 1													-- SET AP CMD C MODE TO "ON"	
			end
		end
	elseif phase == 2 then
		B747_ap_button_switch_position_target[11] = 0									-- SET THE BUTTON ANIMATION TO "UP"			
	end
end	




function B747_ap_switch_cmd_R_CMDhandler(phase, duration)
	if phase == 0 then
		B747_ap_button_switch_position_target[12] = 1									-- SET THE BUTTON ANIMATION TO "DOWN"
		if B747DR_ap_button_switch_position[14] == 0 then								-- DISENGAGE BAR IS "UP/OFF"		
			if B747DR_ap_cmd_R_mode == 0 then											-- RIGHT CMD AP MODE IS "OFF"
				if simDR_autopilot_servos_on == 0 then									-- AUTOPILOT IS NOT ENGAGED
					if B747DR_toggle_switch_position[23] == 0 							-- LEFT FLIGHT DIRECTOR SWITCH IS "OFF"
						and B747DR_toggle_switch_position[24] == 0 						-- RIGHT FLIGHT DIEECTOR SWITCH IS "OFF"
					then	
						simCMD_autopilot_vert_speed_mode:once()							-- ACTIVATE "VS" MODE
						if math.abs(simDR_AHARS_roll_deg_pilot) < 5.0 then				-- BANK ANGLE LESS THAN 5 DEGREES
							simCMD_autopilot_heading_hold:once()						-- ACTIVATE "HEADING HOLD" MODE
						else
							B747CMD_ap_att_mode:once()									-- ACTIVATE "ATT" MODE		
						end
					end
				simCMD_autopilot_servos_on:once()										-- TURN THE AP SERVOS "ON"	
				end
			B747DR_ap_cmd_R_mode = 1													-- SET AP CMD R MODE TO "ON"	
			end
		end
	elseif phase == 2 then
		B747_ap_button_switch_position_target[12] = 0									-- SET THE BUTTON ANIMATION TO "UP"			
	end
end	




function B747_ap_switch_disengage_bar_CMDhandler(phase, duration)
	if phase == 0 then
		B747_ap_button_switch_position_target[14] = 1.0 - B747_ap_button_switch_position_target[14]	
		if B747_ap_button_switch_position_target[14] == 1.0	then						-- DISENGAGE
			if B747DR_toggle_switch_position[23] == 0 									-- LEFT FLIGHT DIRECTOR SWITCH IS "OFF"
				and B747DR_toggle_switch_position[24] == 0 								-- RIGHT FLIGHT DIRECTOR SWITCH IS "OFF"
			then				
				if simDR_autopilot_flight_dir_mode > 0 then								-- FLIGHT DIRECTOR IS ON OR F/D AND SERVOS ARE "ON"
					B747CMD_ap_reset:once()												-- TURN FLIGHT DIRECTOR AND SERVOS "OFF"	
				end
			else																		-- ONE OF THE FLIGHT DIRECTOR SWITCHES IS "ON"
				if simDR_autopilot_flight_dir_mode == 2 then							-- FLIGHT DIRECTOR AND SERVOS ARE "ON"
					simCMD_autopilot_fdir_servos_down_one:once()						-- TURN ONLY THE SERVOS "OFF", LEAVE FLIGHT DIRECTOR "ON"
					B747_ap_all_cmd_modes_off()								
				end								
			end			
		end	
	end
end	




function B747_ap_switch_yoke_disengage_capt_CMDhandler(phase, duration)
	if phase == 0 then
		if B747DR_toggle_switch_position[23] == 0 										-- LEFT FLIGHT DIRECTOR SWITCH IS "OFF"
			and B747DR_toggle_switch_position[24] == 0 									-- RIGHT FLIGHT DIRECTOR SWITCH IS "OFF"
		then				
			if simDR_autopilot_flight_dir_mode == 0 then								-- FLIGHT DIRECTOR AND SERVOS ARE "OFF"
				-- if A/P DISCO AURAL WARNING IS ON										-- TODO:  CANX AURAL WARNING, NEED FMOD AUDIO CONTROL OF A/P DISCO AURAL WARNING
					-- TURN AURAL WARNING OFF
					-- SET CAS MASSAGE TO OFF
			else																		-- FLIGHT DIRECTOR IS ON OR F/D AND SERVOS ARE "ON"
				B747CMD_ap_reset:once()													-- TURN FLIGHT DIRECTOR AND SERVOS "OFF"	
			end
		else																			-- ONE OF THE FLIGHT DIRECTOR SWITCHES IS "ON"	
			if simDR_autopilot_flight_dir_mode == 0 then								-- FLIGHT DIRECTOR AND SERVOS ARE "OFF"	(NOTE:  THIS CONDITION SHOULD ACTUALLY _NEVER_ EXIST !!)			
				-- if A/P DISCO AURAL WARNING IS ON										-- TODO:  NEED FMOD AUDIO CONTROL OF A/P DISCO AURAL WARNING
					-- TURN AURAL WARNING OFF
					-- SET CAS MASSAGE TO OFF
			elseif simDR_autopilot_flight_dir_mode == 1 then							-- FLIGHT DIRECTOR IS ON, SERVOS ARE OFF
				-- if A/P DISCO AURAL WARNING IS ON										-- TODO:  CANX AURAL WARNING, NEED FMOD AUDIO CONTROL OF A/P DISCO AURAL WARNING
					-- TURN AURAL WARNING OFF
					-- SET CAS MASSAGE TO OFF							
			elseif simDR_autopilot_flight_dir_mode == 2 then							-- FLIGHT DIRECTOR AND SERVOS ARE "ON"
				simCMD_autopilot_fdir_servos_down_one:once()							-- TURN ONLY THE SERVOS OFF, LEAVE FLIGHT DIRECTOR ON	
				B747_ap_all_cmd_modes_off()			
			end								
		end	
	end
end	




function B747_ap_switch_yoke_disengage_fo_CMDhandler(phase, duration)
	if phase == 0 then
		if B747DR_toggle_switch_position[23] == 0 										-- LEFT FLIGHT DIRECTOR SWITCH IS "OFF"
			and B747DR_toggle_switch_position[24] == 0 									-- RIGHT FLIGHT DIRECTOR SWITCH IS "OFF"
		then				
			if simDR_autopilot_flight_dir_mode == 0 then								-- FLIGHT DIRECTOR AND SERVOS ARE "OFF"
				-- if A/P DISCO AURAL WARNING IS ON										-- TODO:  CANX AURAL WARNING, NEED FMOD AUDIO CONTROL OF A/P DISCO AURAL WARNING
					-- TURN AURAL WARNING OFF
					-- SET CAS MASSAGE TO OFF
			else																		-- FLIGHT DIRECTOR IS ON OR F/D AND SERVOS ARE "ON"
				B747CMD_ap_reset:once()													-- TURN FLIGHT DIRECTOR AND SERVOS "OFF"	
			end
		else																			-- ONE OF THE FLIGHT DIRECTOR SWITCHES IS "ON"	
			if simDR_autopilot_flight_dir_mode == 0 then								-- FLIGHT DIRECTOR AND SERVOS ARE "OFF"	(NOTE:  THIS CONDITION SHOULD ACTUALLY _NEVER_ EXIST !!)			
				-- if A/P DISCO AURAL WARNING IS ON										-- TODO:  NEED FMOD AUDIO CONTROL OF A/P DISCO AURAL WARNING
					-- TURN AURAL WARNING OFF
					-- SET CAS MASSAGE TO OFF
			elseif simDR_autopilot_flight_dir_mode == 1 then							-- FLIGHT DIRECTOR IS ON, SERVOS ARE OFF
				-- if A/P DISCO AURAL WARNING IS ON										-- TODO:  CANX AURAL WARNING, NEED FMOD AUDIO CONTROL OF A/P DISCO AURAL WARNING
					-- TURN AURAL WARNING OFF
					-- SET CAS MASSAGE TO OFF							
			elseif simDR_autopilot_flight_dir_mode == 2 then							-- FLIGHT DIRECTOR AND SERVOS ARE "ON"
				simCMD_autopilot_fdir_servos_down_one:once()							-- TURN ONLY THE SERVOS OFF, LEAVE FLIGHT DIRECTOR ON	
				B747_ap_all_cmd_modes_off()			
			end								
		end	
	end
end	




function B747_ap_switch_autothrottle_disco_L_CMDhandler(phase, duration)
	if phase == 0 then
		if simDR_autopilot_autothrottle_enabled == 1 then
			simCMD_autopilot_autothrottle_off:once()
			B747DR_engine_TOGA_mode = 0
		end					
	end
end	




function B747_ap_switch_autothrottle_disco_R_CMDhandler(phase, duration)
	if phase == 0 then
		if simDR_autopilot_autothrottle_enabled == 1 then
			simCMD_autopilot_autothrottle_off:once()
			B747DR_engine_TOGA_mode = 0
		end					
	end
end	



function B747_ap_att_mode_CMDhandler(phase, duration)
	if phase == 0 then
        if simDR_AHARS_roll_deg_pilot > 30.0 then
            simDR_autopilot_roll_sync_degrees = 30.0                                    -- LIMIT TO 30 DEGREES
            simCMD_autopilot_roll_right_sync_mode:once()                                -- ACTIVATE ROLL SYNC (RIGHT) MODE
        elseif simDR_AHARS_roll_deg_pilot < -30.0 then
            simDR_autopilot_roll_sync_degrees = -30.0                                   -- LIMIT TO 30 DEGREES
            simCMD_autopilot_roll_left_sync_mode:once()                                 -- ACTIVATE ROLL SYNC (LEFT) MODE
        end						
	end
end	



function B747_ap_reset_CMDhandler(phase, duration)
	if phase == 0 then
		simCMD_autopilot_pitch_sync:once()
		simCMD_autopilot_servos_fdir_off:once()	
		simDR_autopilot_fms_vnav = 0
		B747_ap_all_cmd_modes_off()
		B747DR_ap_ias_mach_window_open = 0
	end
end	









function B747_ai_ap_quick_start_CMDhandler(phase, duration)
    if phase == 0 then
    	B747_set_ap_all_modes()
    	B747_set_ap_CD()
    	B747_set_ap_ER()	
    end
end




--*************************************************************************************--
--** 				             CREATE CUSTOM COMMANDS              			     **--
--*************************************************************************************--

B747CMD_ap_thrust_mode              	= create_command("laminar/B747/autopilot/button_switch/thrust_mode", "Autopilot THR Mode", B747_ap_thrust_mode_CMDhandler)
B747CMD_ap_switch_speed_mode			= create_command("laminar/B747/autopilot/button_switch/speed_mode", "A/P Speed Mode Switch", B747_ap_switch_speed_mode_CMDhandler)
B747CMD_ap_ias_mach_sel_button      	= create_command("laminar/B747/autopilot/ias_mach/sel_button", "Autopilot IAS/Mach Selector Button", B747_ap_ias_mach_sel_button_CMDhandler)
B747CMD_ap_switch_flch_mode				= create_command("laminar/B747/autopilot/button_switch/flch_mode", "Autopilot Fl CH Mode Switch", B747_ap_switch_flch_mode_CMDhandler)
B747CMD_ap_switch_vs_mode				= create_command("laminar/B747/autopilot/button_switch/vs_mode", "A/P V/S Mode Switch", B747_ap_switch_vs_mode_CMDhandler)
B747CMD_ap_switch_alt_hold_mode			= create_command("laminar/B747/autopilot/button_switch/alt_hold_mode", "A/P Altitude Hold Mode Switch", B747_ap_alt_hold_mode_CMDhandler)
--B747CMD_ap_switch_hdg_sel_mode			= create_command("laminar/B747/autopilot/button_switch/hdg_sel_mode", "A/P Heading Select Mode Switch", B747_ap_switch_hdg_sel_mode_CMDhandler)
--B747CMD_ap_switch_hdg_hold_mode			= create_command("laminar/B747/autopilot/button_switch/hdg_hold_mode", "A/P Heading Hold Mode Switch", B747_ap_switch_hdg_hold_mode_CMDhandler)
B747CMD_ap_switch_loc_mode				= create_command("laminar/B747/autopilot/button_switch/loc_mode", "A/P Localizer Mode Switch", B747_ap_switch_loc_mode_CMDhandler)

B747CMD_ap_switch_cmd_L					= create_command("laminar/B747/autopilot/button_switch/cmd_L", "A/P CMD L Switch", B747_ap_switch_cmd_L_CMDhandler)
B747CMD_ap_switch_cmd_C					= create_command("laminar/B747/autopilot/button_switch/cmd_C", "A/P CMD C Switch", B747_ap_switch_cmd_C_CMDhandler)
B747CMD_ap_switch_cmd_R					= create_command("laminar/B747/autopilot/button_switch/cmd_R", "A/P CMD R Switch", B747_ap_switch_cmd_R_CMDhandler)

B747CMD_ap_switch_disengage_bar			= create_command("laminar/B747/autopilot/slide_switch/disengage_bar", "A/P Disenage Bar", B747_ap_switch_disengage_bar_CMDhandler)
B747CMD_ap_switch_yoke_disengage_capt	= create_command("laminar/B747/autopilot/button_switch/yoke_disengage_capt", "A/P Capt Yoke Disengage Switch", B747_ap_switch_yoke_disengage_capt_CMDhandler)
B747CMD_ap_switch_yoke_disengage_fo		= create_command("laminar/B747/autopilot/button_switch/yoke_disengage_fo", "A/P F/O Yoke Disengage Switch", B747_ap_switch_yoke_disengage_fo_CMDhandler)
B747CMD_ap_switch_autothrottle_disco_L	= create_command("laminar/B747/autopilot/button_switch/autothrottle_disco_L", "A/P Autothrottle Disco Left", B747_ap_switch_autothrottle_disco_L_CMDhandler)
B747CMD_ap_switch_autothrottle_disco_R	= create_command("laminar/B747/autopilot/button_switch/autothrottle_disco_R", "A/P Autothrottle Disco Right", B747_ap_switch_autothrottle_disco_R_CMDhandler)

B747CMD_ap_att_mode						= create_command("laminar/B747/autopilot/att_mode", "Set Autopilot ATT Mode", B747_ap_att_mode_CMDhandler)
B747CMD_ap_reset 						= create_command("laminar/B747/autopilot/mode_reset", "Autopilot Mode Reset", B747_ap_reset_CMDhandler)



-- AI
B747CMD_ai_ap_quick_start				= create_command("laminar/B747/ai/autopilot_quick_start", "Autopilot Quick Start", B747_ai_ap_quick_start_CMDhandler)



--*************************************************************************************--
--** 				          REPLACE X-PLANE COMMAND HANDLERS             	    	 **--
--*************************************************************************************--

function B747_ap_knots_mach_toggle_CMDhandler(phase, duration)
	if phase == 0 then
		B747_ap_button_switch_position_target[13] = 1
		if B747DR_ap_ias_mach_window_open == 1 then
			if simDR_airspeed_mach > 0.4 then
				local ap_dial_airspeed = simDR_autopilot_airspeed_kts							-- READ THE CURRENT AIRSPEED SETTING					
				simDR_autopilot_airspeed_is_mach = 1 - simDR_autopilot_airspeed_is_mach			-- SWAP THE MACH/KNOTS STATE
				simDR_autopilot_airspeed_kts = ap_dial_airspeed									-- WRITE THE NEW VALUE TO FORCE CONVERSION TO CORRECT UNITS
			end
		end
	elseif phase == 2 then
		B747_ap_button_switch_position_target[13] = 0				
	end
end



	
function B747_ap_airspeed_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B747DR_ap_ias_mach_window_open == 1 then
			if simDR_autopilot_airspeed_is_mach == 0 then  
				simDR_autopilot_airspeed_kts_mach = math.min(399.0, simDR_autopilot_airspeed_kts_mach + 1)
			elseif simDR_autopilot_airspeed_is_mach == 1 then
				simDR_autopilot_airspeed_kts_mach = math.min(0.950, simDR_autopilot_airspeed_kts_mach + 0.01)		
			end	
		end	
	elseif phase == 1 then
		if duration > 0.5 then
			if B747DR_ap_ias_mach_window_open == 1 then
				if simDR_autopilot_airspeed_is_mach == 0 then  
					simDR_autopilot_airspeed_kts_mach = math.min(399.0, simDR_autopilot_airspeed_kts_mach + 1)
				elseif simDR_autopilot_airspeed_is_mach == 1 then
					simDR_autopilot_airspeed_kts_mach = math.min(0.950, simDR_autopilot_airspeed_kts_mach + 0.01)		
				end	
			end				
		end				
	end
end	

function B747_ap_airspeed_down_CMDhandler(phase, duration)
	if phase == 0 then	
		if B747DR_ap_ias_mach_window_open == 1 then
			if simDR_autopilot_airspeed_is_mach == 0 then  
				simDR_autopilot_airspeed_kts_mach = math.max(100.0, simDR_autopilot_airspeed_kts_mach - 1)
			elseif simDR_autopilot_airspeed_is_mach == 1 then
				simDR_autopilot_airspeed_kts_mach = math.max(0.400, simDR_autopilot_airspeed_kts_mach - 0.01)		
			end	
		end
	elseif phase == 1 then		
		if duration > 0.5 then
			if B747DR_ap_ias_mach_window_open == 1 then
				if simDR_autopilot_airspeed_is_mach == 0 then  
					simDR_autopilot_airspeed_kts_mach = math.max(100.0, simDR_autopilot_airspeed_kts_mach - 1)
				elseif simDR_autopilot_airspeed_is_mach == 1 then
					simDR_autopilot_airspeed_kts_mach = math.max(0.400, simDR_autopilot_airspeed_kts_mach - 0.01)		
				end	
			end			
		end						
	end
end	



--[[
function B747_ap_heading_up_CMDhandler(phase, duration)
	if phase == 0 then
		B747DR_ap_heading_deg =	math.fmod((B747DR_ap_heading_deg + 1), 360.0)	
		if B747DR_ap_hdg_sel_mode == 1 then simDR_autopilot_heading_deg = B747DR_ap_heading_deg end	
	elseif phase == 1 then
		if duration > 0.5 then
			B747DR_ap_heading_deg =	math.fmod((B747DR_ap_heading_deg + 1), 360.0)	
			if B747DR_ap_hdg_sel_mode == 1 then simDR_autopilot_heading_deg = B747DR_ap_heading_deg end				
		end		
	end
end	

function B747_ap_heading_down_CMDhandler(phase, duration)
	if phase == 0 then
		B747DR_ap_heading_deg =	math.fmod((B747DR_ap_heading_deg - 1), 360.0)	
		if B747DR_ap_heading_deg < 0.0 then B747DR_ap_heading_deg = B747DR_ap_heading_deg + 360.0 end
		if B747DR_ap_hdg_sel_mode == 1 then simDR_autopilot_heading_deg = B747DR_ap_heading_deg end	
	elseif phase == 1 then
		if duration > 0.5 then
			B747DR_ap_heading_deg =	math.fmod((B747DR_ap_heading_deg - 1), 360.0)	
			if B747DR_ap_heading_deg < 0.0 then B747DR_ap_heading_deg = B747DR_ap_heading_deg + 360.0 end
			if B747DR_ap_hdg_sel_mode == 1 then simDR_autopilot_heading_deg = B747DR_ap_heading_deg end				
		end			
	end
end	
--]]



function B747_ap_bank_limit_up_CMDhandler(phase, duration)
	if phase == 0 then
        B747DR_ap_bank_limit_sel_dial_pos = math.min(B747DR_ap_bank_limit_sel_dial_pos+1, 5)
        if B747DR_ap_bank_limit_sel_dial_pos == 0 then 
	        simDR_autopilot_bank_limit = 4 
	    else
		  	simDR_autopilot_bank_limit = B747DR_ap_bank_limit_sel_dial_pos      
        end
	end
end	

function B747_ap_bank_limit_down_CMDhandler(phase, duration)
	if phase == 0 then
        B747DR_ap_bank_limit_sel_dial_pos = math.max(B747DR_ap_bank_limit_sel_dial_pos-1, 0)
        if B747DR_ap_bank_limit_sel_dial_pos == 0 then 
	        simDR_autopilot_bank_limit = 4 
	    else
		  	simDR_autopilot_bank_limit = B747DR_ap_bank_limit_sel_dial_pos      
        end
    end    
end	




function B747_ap_vertical_speed_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B747DR_ap_vs_window_open == 1 then simDR_autopilot_vs_fpm = math.min(6000.0, simDR_autopilot_vs_fpm + 100.0)	end	
	elseif phase == 1 then	
		if duration > 0.5 then
			if B747DR_ap_vs_window_open == 1 then simDR_autopilot_vs_fpm = math.min(6000.0, simDR_autopilot_vs_fpm + 100.0)	end		
		end				
	end
end	
function B747_ap_vertical_speed_down_CMDhandler(phase, duration)
	if phase == 0 then
		if B747DR_ap_vs_window_open == 1 then simDR_autopilot_vs_fpm = math.max(-8000.0, simDR_autopilot_vs_fpm - 100.0) end
	elseif phase == 1 then
		if duration > 0.5 then
			if B747DR_ap_vs_window_open == 1 then simDR_autopilot_vs_fpm = math.max(-8000.0, simDR_autopilot_vs_fpm - 100.0) end
		end						
	end
end	




function B747_ap_altitude_up_CMDhandler(phase, duration)
	if phase == 0 then
		simDR_autopilot_altitude_ft = math.min(50000.0, simDR_autopilot_altitude_ft + 100)
	end
end	

function B747_ap_altitude_down_CMDhandler(phase, duration)
	if phase == 0 then
		simDR_autopilot_altitude_ft = math.max(0.0, simDR_autopilot_altitude_ft - 100)		
	end
end	





--*************************************************************************************--
--** 				            REPLACE X-PLANE COMMANDS                  	    	 **--
--*************************************************************************************--

simCMD_ap_knots_mach_toggle			= replace_command("sim/autopilot/knots_mach_toggle", B747_ap_knots_mach_toggle_CMDhandler)
--simCMD_ap_heading					= replace_command("sim/autopilot/heading", B747_ap_heading_hold_CMDhandler)					

simCMD_ap_airspeed_up				= replace_command("sim/autopilot/airspeed_up", B747_ap_airspeed_up_CMDhandler)
simCMD_ap_airspeed_down				= replace_command("sim/autopilot/airspeed_down", B747_ap_airspeed_down_CMDhandler)
--simCMD_ap_heading_up				= replace_command("sim/autopilot/heading_up",B747_ap_heading_up_CMDhandler) 
--simCMD_ap_heading_down				= replace_command("sim/autopilot/heading_down", B747_ap_heading_down_CMDhandler)
simCMD_ap_bank_limit_up				= replace_command("sim/autopilot/bank_limit_up", B747_ap_bank_limit_up_CMDhandler)
simCMD_ap_bank_limit_down			= replace_command("sim/autopilot/bank_limit_down", B747_ap_bank_limit_down_CMDhandler)
simCMD_ap_vertical_speed_up			= replace_command("sim/autopilot/vertical_speed_up", B747_ap_vertical_speed_up_CMDhandler)
simCMD_ap_vertical_speed_down		= replace_command("sim/autopilot/vertical_speed_down", B747_ap_vertical_speed_down_CMDhandler)
simCMD_ap_altitude_up				= replace_command("sim/autopilot/altitude_up", B747_ap_altitude_up_CMDhandler)
simCMD_ap_altitude_down				= replace_command("sim/autopilot/altitude_down", B747_ap_altitude_down_CMDhandler)




--*************************************************************************************--
--** 				          WRAP X-PLANE COMMAND HANDLERS               	    	 **--
--*************************************************************************************-

function B747_ap_gpss_mode_beforeCMDhandler(phase, duration) end
function B747_ap_gpss_mode_afterCMDhandler(phase, duration)
	if phase == 0 then
		B747_ap_button_switch_position_target[2] = 1
	elseif phase == 2 then
		B747_ap_button_switch_position_target[2] = 0						
	end
end




function B747_ap_FMS_mode_beforeCMDhandler(phase, duration) end
function B747_ap_FMS_mode_afterCMDhandler(phase, duration)
	if phase == 0 then
		B747_ap_button_switch_position_target[3] = 1
	elseif phase == 2 then
		B747_ap_button_switch_position_target[3] = 0						
	end
end




function B747_ap_heading_hold_mode_beforeCMDhandler(phase, duration) end
function B747_ap_heading_hold_mode_afterCMDhandler(phase, duration) 
	if phase == 0 then
		B747_ap_button_switch_position_target[5] = 1
	elseif phase == 2 then
		B747_ap_button_switch_position_target[5] = 0	
	end			
end




function B747_ap_appr_mode_beforeCMDhandler(phase, duration) 
	if phase == 0 then
		if simDR_autopilot_nav_status == 1 
			and simDR_autopilot_gs_status == 1	
		then
			if B747DR_ap_cmd_L_mode == 1 then											-- LEFT AUTOPILOT IS ON
				B747_ap_all_cmd_modes_off()	
				B747DR_ap_cmd_L_mode = 1
	        end	 			
		end		
	end
end
function B747_ap_appr_mode_afterCMDhandler(phase, duration)
	if phase == 0 then
		B747DR_ap_ias_mach_window_open = 1
		B747_ap_button_switch_position_target[9] = 1
	elseif phase == 2 then
		B747_ap_button_switch_position_target[9] = 0									
	end
end





--*************************************************************************************--
--** 				              WRAP X-PLANE COMMANDS                  	    	 **--
--*************************************************************************************--

simCMD_autopilot_gpss_mode					= wrap_command("sim/autopilot/gpss", B747_ap_gpss_mode_beforeCMDhandler, B747_ap_gpss_mode_afterCMDhandler)
simCMD_autopilot_FMS_mode					= wrap_command("sim/autopilot/FMS", B747_ap_FMS_mode_beforeCMDhandler, B747_ap_FMS_mode_afterCMDhandler)	
simCMD_autopilot_heading_hold_mode			= wrap_command("sim/autopilot/heading_hold", B747_ap_heading_hold_mode_beforeCMDhandler, B747_ap_heading_hold_mode_afterCMDhandler)	
simCMD_autopilot_appr_mode					= wrap_command("sim/autopilot/approach", B747_ap_appr_mode_beforeCMDhandler, B747_ap_appr_mode_afterCMDhandler)




--*************************************************************************************--
--** 					           OBJECT CONSTRUCTORS         	    	    		 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				                 CREATE OBJECTS        	         				 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				                SYSTEM FUNCTIONS             	    			 **--
--*************************************************************************************--

----- TERNARY CONDITIONAL ---------------------------------------------------------------
function B747_ternary(condition, ifTrue, ifFalse)
    if condition then return ifTrue else return ifFalse end
end




----- ROUND TO INCREMENT ----------------------------------------------------------------
function roundToIncrement(numberToRound, increment)

    local y = numberToRound / increment
    local q = math.floor(y + 0.5)
    local z = q * increment

    return z

end




----- ANIMATION UNILITY -----------------------------------------------------------------
function B747_set_ap_animation_position(current_value, target, min, max, speed)

    if target >= (max - 0.001) and current_value >= (max - 0.01) then
        return max
    elseif target <= (min + 0.001) and current_value <= (min + 0.01) then
        return min
    else
        return current_value + ((target - current_value) * (speed * SIM_PERIOD))
    end

end










---- BUTTON SWITCH POSITION ANIMATION ---------------------------------------------------
function B747_ap_button_switch_animation()

    for i = 0, NUM_AUTOPILOT_BUTTONS-1 do
        B747DR_ap_button_switch_position[i] = B747_set_ap_animation_position(B747DR_ap_button_switch_position[i], B747_ap_button_switch_position_target[i], 0.0, 1.0, 30.0)
    end

end





----- VERTICAL SPEED MODE ---------------------------------------------------------------
function B747_ap_vs_mode()
	
    ----- WINDOW
	B747DR_ap_vs_window_open = B747_ternary(simDR_autopilot_vs_status >= 1, 1, 0)
    
    
    ----- VVI FOR ANIMATION 
    B747DR_ap_vvi_fpm = math.abs(simDR_autopilot_vs_fpm)
    
    
    ----- THOUSANDS DIGIT HIDE/SHOW
    B747DR_ap_vs_show_thousands = B747_ternary(B747DR_ap_vs_window_open == 1 and B747DR_ap_vvi_fpm >= 1000, 1, 0)

end	





----- IAS/MACH MODE ---------------------------------------------------------------------
function B747_ap_ias_mach_mode()
	
	----- SET THE IAS/MACH WINDOW STATUS
	if simDR_autopilot_autothrottle_enabled > 0
		or simDR_autopilot_flch_status > 1
		or simDR_autopilot_vs_status > 1
		or simDR_autopilot_TOGA_vert_status > 0
		or simDR_autopilot_alt_hold_status > 1
		or simDR_autopilot_gs_status > 0
	then	
		B747DR_ap_ias_mach_window_open = 1
	else
		B747DR_ap_ias_mach_window_open = 0
	end		



	----- AUTO-SWITCH AUTOPILOT IAS/MACH WINDOW AIRSPEED MODE
    if simDR_ind_airspeed_kts_pilot < 310.0 then
    	if simDR_vvi_fpm_pilot < -250.0 then
	    	if simDR_autopilot_airspeed_is_mach == 1 then
		    	local ap_dial_airspeed = simDR_autopilot_airspeed_kts						-- READ THE CURRENT AIRSPEED SETTING
				simDR_autopilot_airspeed_is_mach = 0										-- CHANGE TO KNOTS
				simDR_autopilot_airspeed_kts = ap_dial_airspeed								-- WRITE THE NEW VALUE TO FORCE CONVERSION TO CORRECT UNITS
		    end
		end
	end
	
	if simDR_airspeed_mach > 0.84 then
		if simDR_vvi_fpm_pilot > 250.0 then
			if simDR_autopilot_airspeed_is_mach == 0 then
		    	local ap_dial_airspeed = simDR_autopilot_airspeed_kts						-- READ THE CURRENT AIRSPEED SETTING
				simDR_autopilot_airspeed_is_mach = 1										-- CHANGE TO KNOTS
				simDR_autopilot_airspeed_kts = ap_dial_airspeed								-- WRITE THE NEW VALUE TO FORCE CONVERSION TO CORRECT UNITS
			end
		end
	end					 	    
		    		  
    
    
    ----- SET THE IAS/MACH TUMBLER VALUE
	if B747DR_ap_ias_mach_window_open == 1
		and simDR_autopilot_airspeed_is_mach == 1
	then
		B747DR_ap_mach_decimal_visibiilty = 1
	else
		B747DR_ap_mach_decimal_visibiilty = 0		
	end
		
    if simDR_autopilot_airspeed_is_mach == 0 then
        B747DR_ap_ias_dial_value = roundToIncrement(simDR_autopilot_airspeed_kts_mach, 1)
    elseif simDR_autopilot_airspeed_is_mach == 1 then
        B747DR_ap_ias_dial_value = roundToIncrement(simDR_autopilot_airspeed_kts_mach, 0.01) * 100.0
    end
	
end	




----- ALTITUDE SELECTED -----------------------------------------------------------------
function B747_ap_altitude()

	B747DR_ap_alt_show_thousands = B747_ternary(simDR_autopilot_altitude_ft > 999.9, 1.0, 0.0)
	B747DR_ap_alt_show_tenThousands = B747_ternary(simDR_autopilot_altitude_ft > 9999.99, 1.0, 0.0)
	
end	





----- APPROACH MODE ---------------------------------------------------------------------
function B747_ap_appr_mode()
	
	if simDR_autopilot_approach_status > 0 then
		
        -- TURN ON ALL AUTOPILOTS
        if B747DR_ap_cmd_L_mode == 0 then
            B747CMD_ap_switch_cmd_L:once()
        end

        if B747DR_ap_cmd_C_mode == 0 then
            B747CMD_ap_switch_cmd_C:once()
        end

        if B747DR_ap_cmd_R_mode == 0 then
            B747CMD_ap_switch_cmd_R:once()
        end	
	     
    end    		
	
end	




--[[
----- HEADING HOLD MODE -----------------------------------------------------------------
function B747_ap_heading_hold_mode()
	
	if B747_ap_heading_hold_status == 1 then

        simCMD_autopilot_wing_leveler:once()                                        -- ROLL TO WINGS LEVEL
        simDR_autopilot_roll_sync_degrees = 0                                       -- SYNC ROLL DEGREES TO ZERO
        B747_ap_heading_hold_status = 2  
                                                       								-- INCREMENT THE FLAG
    elseif B747_ap_heading_hold_status == 2 then                                    -- WING LEVEL IN PROGRESS
	    
        if math.abs(simDR_AHARS_roll_deg_pilot) < 3.0 then                          -- MONITOR FOR AIRCRAFT ROLL DEGREES < 3.0
            simDR_autopilot_heading_deg = roundToIncrement(simDR_AHARS_heading_deg_pilot, 1)
            if simDR_autopilot_heading_status == 0 then                             -- VERIFY SIM AP HEADING MODE IS "OFF"
                simCMD_autopilot_heading_mode:once()                                -- ACTIVATE SIM HEADING MODE
            end
            B747DR_ap_hdg_hold_mode = 9                                             -- HEADING HOLD MODE ACTIVE
        end
    end
        	
end	
--]]



----- FLIGHT MODE ANNUNCIATORS ----------------------------------------------------------
function B747_ap_fma()


    -- AUTOTHROTTLE
    -------------------------------------------------------------------------------------
    if simDR_autopilot_autothrottle_on == 0 then                                        
        B747DR_ap_FMA_autothrottle_mode = 0
    elseif simDR_autopilot_autothrottle_on == 1 then
        B747DR_ap_FMA_autothrottle_mode = 3
    end



    -- ROLL MODES: ARMED
    -- ----------------------------------------------------------------------------------

    -- (NONE) --
    B747DR_ap_FMA_armed_roll_mode = 0

    -- (TOGA) --
    if simDR_autopilot_TOGA_lat_status == 1 then
        B747DR_ap_FMA_armed_roll_mode = 1

    -- (LNAV) --
    elseif simDR_autopilot_gpss == 1 then
        B747DR_ap_FMA_armed_roll_mode = 2

    -- (LOC) --
    elseif simDR_autopilot_nav_status == 1 then
        B747DR_ap_FMA_armed_roll_mode = 3

    -- (ROLLOUT) --
    -- TODO: AUTOLAND LOGIC


    end
    
    
    
    -- ROLL MODES: ACTIVE
    -- ----------------------------------------------------------------------------------

	-- (NONE) --
	B747DR_ap_FMA_active_roll_mode = 0

    -- (TOGA) --
    if simDR_autopilot_TOGA_lat_status == 2 then
        B747DR_ap_FMA_active_roll_mode = 1

    -- (LNAV) --
    elseif simDR_autopilot_gpss == 2 then
        B747DR_ap_FMA_active_roll_mode = 2

    -- (LOC) --
    elseif simDR_autopilot_nav_status == 2 then
        B747DR_ap_FMA_active_roll_mode = 3
        B747DR_ap_heading_deg = roundToIncrement(simDR_nav1_radio_course_deg, 1)            -- SET THE SELECTED HEADING VALUE TO THE LOC COURSE


    -- (ROLLOUT) --
    -- TODO: AUTOLAND LOGIC
    

    -- (HDG SEL) --
    elseif simDR_autopilot_heading_status == 2 then
        B747DR_ap_FMA_active_roll_mode = 6

    -- (HDG HLD) --
    elseif simDR_autopilot_heading_hold_status == 2 then
        B747DR_ap_FMA_active_roll_mode = 7
        
     -- (ATT) --
    elseif simDR_autopilot_roll_status == 2 
    	and simDR_autopilot_flight_dir_mode > 0
    	and math.abs(simDR_AHARS_roll_deg_pilot) > 5.0
    then
        B747DR_ap_FMA_active_roll_mode = 5       

	end



    -- PITCH MODES: ARMED
    -- ----------------------------------------------------------------------------------

    -- (NONE) --
    B747DR_ap_FMA_armed_pitch_mode = 0

    -- (TOGA) --
    if simDR_autopilot_TOGA_vert_status == 1 then
        B747DR_ap_FMA_armed_pitch_mode = 1

    -- (G/S) --
    elseif simDR_autopilot_gs_status == 1 then
        B747DR_ap_FMA_armed_pitch_mode = 2

    -- (FLARE) --
    -- TODO: AUTOLAND LOGIC
    
	end

    -- PITCH MODES: ACTIVE
    -- ----------------------------------------------------------------------------------

	-- (NONE) --
	B747DR_ap_FMA_active_pitch_mode = 0
	
    -- (TOGA) --
    if simDR_autopilot_TOGA_vert_status == 2 then
        B747DR_ap_FMA_active_pitch_mode = 1

    -- (G/S) --
    elseif simDR_autopilot_gs_status == 2 then
        B747DR_ap_FMA_active_pitch_mode = 2

    -- (FLARE) --
    -- TODO: AUTOLAND LOGIC

    -- (VNAV SPD) --
    elseif simDR_autopilot_fms_vnav == 1 
    	and simDR_autopilot_flch_status == 2
    then
        B747DR_ap_FMA_active_pitch_mode = 4

    -- (VNAV ALT) --
    elseif simDR_autopilot_fms_vnav == 1 
    	and simDR_autopilot_alt_hold_status == 2
    then
        B747DR_ap_FMA_active_pitch_mode = 5
            
    -- (VNAV PATH) --
   	elseif simDR_autopilot_fms_vnav == 1
   		and simDR_autopilot_vs_status == 2
   	then
	   	B747DR_ap_FMA_active_pitch_mode = 6	 

    -- (V/S) --
    elseif simDR_autopilot_vs_status == 2 
    	and simDR_autopilot_fms_vnav == 0
    then
        B747DR_ap_FMA_active_pitch_mode = 7

    -- (FLCH SPD) --
    elseif simDR_autopilot_flch_status == 2 
    	and simDR_autopilot_fms_vnav == 0
    then
        B747DR_ap_FMA_active_pitch_mode = 8

    -- (ALT) --
    elseif simDR_autopilot_alt_hold_status == 2 
    	and simDR_autopilot_fms_vnav == 0
    then
        B747DR_ap_FMA_active_pitch_mode = 9

    -- (NONE) --
    elseif simDR_autopilot_pitch > 1 then
        B747DR_ap_FMA_active_pitch_mode = 0
    end
	
end	





---- AFDS STATUS -------------------------------------------------------------------------
function B747_ap_afds()

	local numAPengaged = B747DR_ap_cmd_L_mode + B747DR_ap_cmd_C_mode + B747DR_ap_cmd_R_mode
	
	if simDR_autopilot_servos_on == 0 then
		if numAPengaged > 0 then	
			B747CMD_ap_reset:once()
		end	
		
	elseif simDR_autopilot_servos_on == 1 then
		if numAPengaged == 0 then
			B747DR_ap_cmd_L_mode = 1
		end
	end		
    
    B747DR_ap_AFDS_status_annun = 0
    
    if numAPengaged >= 1 then                                                           	-- TODO:  CHANGE TO "==" WHEN AUTOLAND LOGIC (BELOW) IS IMPLEMENTED
        B747DR_ap_AFDS_status_annun = 2                                                    	-- AFDS MODE = "CMD"

        
        --if B747_AFDS_land2_EICAS_status == 1 or B747_AFDS_land3_EICAS_status == 1 then
        --    B747DR_ap_AFDS_status_annun = 5                                              	-- AFDS MODE = "NO AUTOLAND" (NOT MODELED)
        --end

    -- TODO: IF LOC OR APP CAPTURED ? THEN...
    --elseif numAPengaged == 2 then
        --B747DR_ap_AFDS_status_annun = 3                                                  	-- AFDS MODE = "LAND 2"
        --B747_AFDS_land2_EICAS_status = 1

    --elseif numAPengaged == 3 then
        --B747DR_ap_AFDS_status_annun = 4                                                  	-- AFDS MODE = "LAND 3"
        --B747_AFDS_land3_EICAS_status = 1



    else
        if B747DR_toggle_switch_position[23] > 0.95
            or B747DR_toggle_switch_position[24] > 0.95
        then
            B747DR_ap_AFDS_status_annun = 1                                                	-- AFDS MODE = "FD"
        end
    end

end





----- FLIGHT MODE ANNUNCIATORS MODE CHANGE BOX ------------------------------------------
function B747_AFDS_status_mode_chg_timeout()
    B747DR_ap_AFDS_mode_box_status = 0
end

function B747_AFDS_status_mode_chg2_timeout()
    B747DR_ap_AFDS_mode_box2_status = 0
end

function B747_at_mode_chg_timeout()
    B747DR_ap_FMA_autothrottle_mode_box_status = 0
end

function B747_roll_mode_chg_timeout()
    B747DR_ap_roll_mode_box_status = 0
end

function B747_pitch_mode_chg_timeout()
    B747DR_ap_pitch_mode_box_status = 0
end

function B747_ap_afds_fma_mode_change()

    -- AFDS STATUS
    if B747DR_ap_AFDS_status_annun ~= B747_ap_last_AFDS_status then
        if B747DR_ap_AFDS_status_annun == 0 then                                            -- MODE IS "NONE"
            if is_timer_scheduled(B747_AFDS_status_mode_chg2_timeout) == true then          -- TEST IF TIMER IS RUNNING
                stop_timer(B747_AFDS_status_mode_chg2_timeout)                              -- KILL THE TIMER
            end
            B747DR_ap_AFDS_mode_box_status = 0
            B747DR_ap_AFDS_mode_box2_status = 0
        elseif B747DR_ap_AFDS_status_annun > 0 and B747DR_ap_AFDS_status_annun < 5 then     -- MODE IS NOT "NONE" AND NOT "NO AUTOLAND"
            B747DR_ap_AFDS_mode_box2_status = 0
            B747DR_ap_AFDS_mode_box_status = 1                                              -- SHOW THE MODE CHANGE BOX
            if is_timer_scheduled(B747_AFDS_status_mode_chg_timeout) == false then          -- CHECK TIMEOUT STATUS
                run_after_time(B747_AFDS_status_mode_chg_timeout, 10.0)                     -- SET TO TIMEOUT IN 10 SECONDS
            else
                stop_timer(B747_AFDS_status_mode_chg_timeout)                               -- STOP PREVIOUS TIMER
                run_after_time(B747_AFDS_status_mode_chg_timeout, 10.0)                     -- SET TO TIMEOUT IN 10 SECONDS
            end
        elseif B747DR_ap_AFDS_status_annun == 5 then                                        -- MODE IS "NO AUTOLAND"
            B747DR_ap_AFDS_mode_box_status = 0
            B747DR_ap_AFDS_mode_box2_status = 1                                             -- SHOW THE MODE CHANGE BOX
            if is_timer_scheduled(B747_AFDS_status_mode_chg2_timeout) == false then         -- CHECK TIMEOUT STATUS
                run_after_time(B747_AFDS_status_mode_chg2_timeout, 10.0)                    -- SET TO TIMEOUT IN 10 SECONDS
            else
                stop_timer(B747_AFDS_status_mode_chg2_timeout)                              -- STOP PREVIOUS TIMER
                run_after_time(B747_AFDS_status_mode_chg2_timeout, 10.0)                    -- SET TO TIMEOUT IN 10 SECONDS
            end
        end
    end
    B747_ap_last_AFDS_status = B747DR_ap_AFDS_status_annun                                  -- RESET LAST MODE


    -- AUTOTHROTTLE MODE
    if B747DR_ap_FMA_autothrottle_mode ~= B747_ap_last_FMA_autothrottle_mode then           -- THE MODE HAS CHANGED
        if B747DR_ap_FMA_autothrottle_mode == 0 then                                        -- MODE IS "NONE"
            if is_timer_scheduled(B747_at_mode_chg_timeout) == true then                    -- TEST IF TIMER IS RUNNING
                stop_timer(B747_at_mode_chg_timeout)                                        -- KILL THE TIMER
            end
            B747DR_ap_FMA_autothrottle_mode_box_status = 0
        elseif B747DR_ap_FMA_autothrottle_mode > 0 then                                     -- MODE IS NOT "NONE"
            B747DR_ap_FMA_autothrottle_mode_box_status = 1                                  -- SHOW THE MODE CHANGE BOX
            if is_timer_scheduled(B747_at_mode_chg_timeout) == false then                   -- CHECK TIMEOUT STATUS
                run_after_time(B747_at_mode_chg_timeout, 10.0)                              -- SET TO TIMEOUT IN 10 SECONDS
            else
                stop_timer(B747_at_mode_chg_timeout)                                        -- STOP PREVIOUS TIMER
                run_after_time(B747_at_mode_chg_timeout, 10.0)                              -- SET TO TIMEOUT IN 10 SECONDS
            end
        end
    end
    B747_ap_last_FMA_autothrottle_mode = B747DR_ap_FMA_autothrottle_mode                    -- RESET LAST MODE


    -- ROLL MODE
    if B747DR_ap_FMA_active_roll_mode ~= B747_ap_last_FMA_roll_mode then                    -- THE MODE HAS CHANGED
        if B747DR_ap_FMA_active_roll_mode == 0 then                                         -- MODE IS "NONE"
            if is_timer_scheduled(B747_roll_mode_chg_timeout) == true then                  -- TEST IF TIMER IS RUNNING
                stop_timer(B747_roll_mode_chg_timeout)                                      -- KILL THE TIMER
            end
            B747DR_ap_roll_mode_box_status = 0
        elseif B747DR_ap_FMA_active_roll_mode > 0 then                                      -- MODE IS NOT "NONE"
            B747DR_ap_roll_mode_box_status = 1                                              -- SHOW THE MODE CHANGE BOX
            if is_timer_scheduled(B747_roll_mode_chg_timeout) == false then                 -- CHECK TIMEOUT STATUS
                run_after_time(B747_roll_mode_chg_timeout, 10.0)                            -- SET TO TIMEOUT IN 10 SECONDS
            else
                stop_timer(B747_roll_mode_chg_timeout)                                      -- STOP PREVIOUS TIMER
                run_after_time(B747_roll_mode_chg_timeout, 10.0)                            -- SET TO TIMEOUT IN 10 SECONDS
            end
        end
    end
    B747_ap_last_FMA_roll_mode = B747DR_ap_FMA_active_roll_mode                             -- RESET LAST MODE


    -- PITCH MODE
    if B747DR_ap_FMA_active_pitch_mode ~= B747_ap_last_FMA_pitch_mode then                  -- THE MODE HAS CHANGED
        if B747DR_ap_FMA_active_pitch_mode == 0 then                                        -- MODE IS "NONE"
            if is_timer_scheduled(B747_pitch_mode_chg_timeout) == true then                 -- TEST IF TIMER IS RUNNING
                stop_timer(B747_pitch_mode_chg_timeout)                                     -- KILL THE TIMER
            end
            B747DR_ap_pitch_mode_box_status = 0
        elseif B747DR_ap_FMA_active_pitch_mode > 0 then                                     -- MODE IS NOT "NONE"
            B747DR_ap_pitch_mode_box_status = 1                                             -- SHOW THE MODE CHANGE BOX
            if is_timer_scheduled(B747_pitch_mode_chg_timeout) == false then                -- CHECK TIMEOUT STATUS
                run_after_time(B747_pitch_mode_chg_timeout, 10.0)                           -- SET TO TIMEOUT IN 10 SECONDS
            else
                stop_timer(B747_pitch_mode_chg_timeout)                                     -- STOP PREVIOUS TIMER
                run_after_time(B747_pitch_mode_chg_timeout, 10.0)                           -- SET TO TIMEOUT IN 10 SECONDS
            end
        end
    end
    B747_ap_last_FMA_pitch_mode = B747DR_ap_FMA_active_pitch_mode                           -- RESET LAST MODE

end








----- TURN AUTOPILOT COMMAND MODES OFF --------------------------------------------------
function B747_ap_all_cmd_modes_off()

	B747DR_ap_cmd_L_mode = 0	
	B747DR_ap_cmd_C_mode = 0	
	B747DR_ap_cmd_R_mode = 0	

end





----- EICAS MESSAGES --------------------------------------------------------------------
function B747_ap_EICAS_msg()

    -- >AUTOPILOT
    B747DR_CAS_caution_status[4] = 0
    if simDR_autopilot_fail == 6 then
        B747DR_CAS_caution_status[4] = 1
    end

    -- >AUTOTHROT DISC


end












----- MONITOR AI FOR AUTO-BOARD CALL ----------------------------------------------------
function B747_ap_monitor_AI()

    if B747DR_init_autopilot_CD == 1 then
        B747_set_ap_all_modes()
        B747_set_ap_CD()
        B747DR_init_autopilot_CD = 2
    end

end





----- SET STATE FOR ALL MODES -----------------------------------------------------------
function B747_set_ap_all_modes()

	B747DR_init_autopilot_CD = 0
	
	simDR_autopilot_airspeed_is_mach	= 0
	B747DR_ap_alt_show_thousands		= 1
	
	simDR_autopilot_airspeed_kts_mach	= 200.0
	simDR_autopilot_heading_deg			= 0.0
	simDR_autopilot_vs_fpm 				= 0.0
	simDR_autopilot_altitude_ft			= 10000.0
	
	simDR_autopilot_TOGA_pitch_deg      = 8.0
	
end





----- SET STATE TO COLD & DARK ----------------------------------------------------------
function B747_set_ap_CD()



end





----- SET STATE TO ENGINES RUNNING ------------------------------------------------------
function B747_set_ap_ER()
	

	
end









----- FLGHT START -----------------------------------------------------------------------
function B747_flight_start_autopilot()

    -- ALL MODES ------------------------------------------------------------------------
    B747_set_ap_all_modes()
    simCMD_autopilot_set_nav1_as_nav_source:once()
    simDR_autopilot_bank_limit = 4 


    -- COLD & DARK ----------------------------------------------------------------------
    if simDR_startup_running == 0 then

        B747_set_ap_CD()


    -- ENGINES RUNNING ------------------------------------------------------------------
    elseif simDR_startup_running == 1 then

		B747_set_ap_ER()

    end

end




--*************************************************************************************--
--** 				                 EVENT CALLBACKS           	        			 **--
--*************************************************************************************--

--function aircraft_load() end

--function aircraft_unload() end

function flight_start()

    B747_flight_start_autopilot()

end

--function flight_crash() end

--function before_physics() end

function after_physics()

    B747_ap_button_switch_animation()
    
    B747_ap_vs_mode()
	B747_ap_ias_mach_mode()
	B747_ap_altitude()
	B747_ap_appr_mode()
	
	B747_ap_fma()
	B747_ap_afds()
	B747_ap_afds_fma_mode_change()
	
	B747_ap_EICAS_msg()
	
    B747_ap_monitor_AI()

end

--function after_replay() end




--*************************************************************************************--
--** 				               SUB-MODULE PROCESSING       	        			 **--
--*************************************************************************************--

-- dofile("")










