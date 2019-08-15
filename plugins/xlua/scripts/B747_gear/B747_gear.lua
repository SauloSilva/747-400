--[[
*****************************************************************************************
* Program Script Name	:	B747.10.gear
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
*        COPYRIGHT � 2016 JIM GREGORY / LAMINAR RESEARCH - ALL RIGHTS RESERVED	        *
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



--*************************************************************************************--
--** 					            GLOBAL VARIABLES                				 **--
--*************************************************************************************--



--*************************************************************************************--
--** 					            LOCAL VARIABLES                 				 **--
--*************************************************************************************--

local B747_gear_handle_lock_override = 0
local B747_gear_handle_lock = 0




--*************************************************************************************--
--** 				                X-PLANE DATAREFS            			    	 **--
--*************************************************************************************--

simDR_startup_running       = find_dataref("sim/operation/prefs/startup_running")
simDR_aircraft_on_ground    = find_dataref("sim/flightmodel/failures/onground_all")
simDR_gear_deploy_ratio     = find_dataref("sim/flightmodel2/gear/deploy_ratio")
simDR_tire_steer_deg        = find_dataref("sim/flightmodel2/gear/tire_steer_actual_deg")
simDR_gear_claw_angle       = find_dataref("sim/flightmodel2/gear/eagle_claw_angle_deg")
simDR_gear_handle_down      = find_dataref("sim/cockpit2/controls/gear_handle_down")
simDR_autobrakes_switch     = find_dataref("sim/cockpit2/switches/auto_brake_level")
simDR_OAT_degC              = find_dataref("sim/cockpit2/temperature/outside_air_temp_degc")
simDR_tire_rot_speed        = find_dataref("sim/flightmodel2/gear/tire_rotation_speed_rad_sec")
simDR_parking_brake_ratio   = find_dataref("sim/cockpit2/controls/parking_brake_ratio")
simDR_left_brake_ratio      = find_dataref("sim/cockpit2/controls/left_brake_ratio")
simDR_right_brake_ratio     = find_dataref("sim/cockpit2/controls/right_brake_ratio")



--*************************************************************************************--
--** 				              FIND CUSTOM DATAREFS             			    	 **--
--*************************************************************************************--

B747DR_CAS_memo_status          = find_dataref("laminar/B747/CAS/memo_status")



--*************************************************************************************--
--** 				        CREATE READ-ONLY CUSTOM DATAREFS               	         **--
--*************************************************************************************--

B747DR_gear_lock_override_pos   = create_dataref("laminar/B747/gear_lock_ovrd/position", "number")
B747DR_autobrakes_sel_dial_pos  = create_dataref("laminar/B747/gear/autobrakes/sel_dial_pos", "number")

B747DR_gear_annun_status        = create_dataref("laminar/B747/gear/gear_position/annun_status", "number")
B747DR_EICAS1_gear_display_status = create_dataref("laminar/B747/gear/EICAS1_display_status", "number")

B747DR_tire_pressure            = create_dataref("laminar/B747/gear/tire_pressure", "array[18]")
B747DR_brake_temp               = create_dataref("laminar/B747/gear/brake_temp", "array[18]")

B747DR_init_gear_CD             = create_dataref("laminar/B747/gear/init_CD", "number")



--*************************************************************************************--
--** 				       READ-WRITE CUSTOM DATAREF HANDLERS     	        	     **--
--*************************************************************************************--

----- GEAR HANDLE DATAREF HANDLER -------------------------------------------------------
function B747DR_gear_handle_DRhandler()

    -- GEAR HANDLE LOCK IS DISENGAGED
    if B747_gear_handle_lock == 0 then

        if B747DR_gear_handle <= 0.1 then
            B747DR_gear_handle = 0.0   -- DETENT (GEAR HANDLE "DOWN")
            simDR_gear_handle_down = 1
        elseif B747DR_gear_handle >= 0.9 and B747DR_gear_handle <= 1.1 then
            B747DR_gear_handle = 1.0   -- DETENT (GEAR HANDLE "OFF")
        elseif B747DR_gear_handle >= 1.9 then
            B747DR_gear_handle = 2.0   -- DETENT (GEAR HANDLE "UP")
            simDR_gear_handle_down = 0
        end
        
        
    -- GEAR HANDLE LOCK IS ENGAGED
    else

        if B747DR_gear_handle <= 0.1 then
            B747DR_gear_handle = 0.0   -- DETENT (GEAR HANDLE "DOWN")
            simDR_gear_handle_down = 1
        elseif B747DR_gear_handle >= 0.9 then
            B747DR_gear_handle = 1.0
        end

    end
    
end    



function B747DR_gear_handle_detent_DRhandler() end






--*************************************************************************************--
--** 				       CREATE READ-WRITE CUSTOM DATAREFS                         **--
--*************************************************************************************--

----- LANDING GEAR HANDLE ---------------------------------------------------------------
B747DR_gear_handle 			= create_dataref("laminar/B747/actuator/gear_handle", "number", B747DR_gear_handle_DRhandler)
B747DR_gear_handle_detent 	= create_dataref("laminar/B747/actuator/gear_handle_detent", "number", B747DR_gear_handle_detent_DRhandler)






--*************************************************************************************--
--** 				             X-PLANE COMMAND HANDLERS               	    	 **--
--*************************************************************************************--

function sim_landing_gear_up_CMDhandler(phase, duration)
    if phase == 0 then
        -- GEAR HANDLE LOCK IS DISENGAGED
        if B747_gear_handle_lock == 0 then
            B747DR_gear_handle = 2.0
            simDR_gear_handle_down = 0
        -- GEAR HANDLE LOCK IS ENGAGED
        else
            B747DR_gear_handle = 1.0            -- PREVENT MOVEMENT OF GEAR HANDLE TO 'UP' POSITION
        end
    end
end

function sim_landing_gear_down_CMDhandler(phase, duration)
    if phase == 0 then
        B747DR_gear_handle = 0.0
        simDR_gear_handle_down = 1
    end
end

function sim_landing_gear_toggle_CMDhandler(phase, duration)
    if phase == 0 then
        -- GEAR HANDLE LOCK IS DISENGAGED
        if B747_gear_handle_lock == 0 then
	        
            if simDR_gear_deploy_ratio[0] >= 0.5
                    and simDR_gear_deploy_ratio[1] >= 0.5
                    and simDR_gear_deploy_ratio[2] >= 0.5
                    and B747DR_gear_handle <= 1.0
            then
                B747DR_gear_handle = 2.0
                simDR_gear_handle_down = 0
            else
                B747DR_gear_handle = 0.0
                simDR_gear_handle_down = 1
            end
            
        -- GEAR HANDLE LOCK IS ENGAGED
        else
	        
            if simDR_gear_deploy_ratio[0] >= 0.5
                    and simDR_gear_deploy_ratio[1] >= 0.5
                    and simDR_gear_deploy_ratio[2] >= 0.5
                    and B747DR_gear_handle < 1.0
            then
                B747DR_gear_handle = 1.0        -- PREVENT MOVEMENT OF GEAR HANDLE TO 'UP' POSITION
            else
                B747DR_gear_handle = 0.0
                simDR_gear_handle_down = 1
            end
            
        end
    end
end






--*************************************************************************************--
--** 				                 X-PLANE COMMANDS                   	    	 **--
--*************************************************************************************--

simCMD_landing_gear_up = replace_command("sim/flight_controls/landing_gear_up", sim_landing_gear_up_CMDhandler)
simCMD_landing_gear_down = replace_command("sim/flight_controls/landing_gear_down", sim_landing_gear_down_CMDhandler)
simCMD_landing_gear_toggle = replace_command("sim/flight_controls/landing_gear_toggle", sim_landing_gear_toggle_CMDhandler)




--*************************************************************************************--
--** 				              CUSTOM COMMAND HANDLERS            			     **--
--*************************************************************************************--

function B747_gear_lock_override_CMDhandler(phase, duration)

    if phase == 0 then
        B747_gear_handle_lock_override = 1
        B747DR_gear_lock_override_pos = 1
    elseif phase == 1 then
        B747_gear_handle_lock_override = 1
        B747DR_gear_lock_override_pos = 1
    elseif phase == 2 then
        B747_gear_handle_lock_override = 0
        B747DR_gear_lock_override_pos = 0
    end
end




-- AUTOBRAKES SELECTOR DIAL
function B747_autobrakes_sel_dial_up_CMDhandler(phase, duration)
    if phase == 0 then
        B747DR_autobrakes_sel_dial_pos = math.min(B747DR_autobrakes_sel_dial_pos+1, 7)
        local simSwPos = 1
        if B747DR_autobrakes_sel_dial_pos == 0 then
            simSwPos = 0
        elseif B747DR_autobrakes_sel_dial_pos >= 3 then
            simSwPos = math.min(5, B747DR_autobrakes_sel_dial_pos - 1)
        end
        simDR_autobrakes_switch = simSwPos
    end
end
function B747_autobrakes_sel_dial_dn_CMDhandler(phase, duration)
    if phase == 0 then
        B747DR_autobrakes_sel_dial_pos = math.max(B747DR_autobrakes_sel_dial_pos-1, 0)
        local simSwPos = 1
        if B747DR_autobrakes_sel_dial_pos == 0 then
            simSwPos = 0
        elseif B747DR_autobrakes_sel_dial_pos >= 3 then
            simSwPos = math.min(5, B747DR_autobrakes_sel_dial_pos - 1)
        end
        simDR_autobrakes_switch = simSwPos
    end
end



-- AI
function B747_ai_gear_quick_start_CMDhandler(phase, duration)
    if phase == 0 then
		B747_set_gear_all_modes()
		B747_set_gear_CD()
		B747_set_gear_ER()    
	end    	
end	







--*************************************************************************************--
--** 				                 CUSTOM COMMANDS                			     **--
--*************************************************************************************--

-- GEAR LOCK OVERRIDE
B747CMD_gear_lock_override      = create_command("laminar/B747/gear_lock/override", "Gear Lock Override", B747_gear_lock_override_CMDhandler)



-- AUTOBRAKES SELECTOR DIAL
B747CMD_autobrakes_sel_dial_up  = create_command("laminar/B747/gear/autobrakes/sel_dial_up", "Autobrakes Sel Dial Up", B747_autobrakes_sel_dial_up_CMDhandler)
B747CMD_autobrakes_sel_dial_dn  = create_command("laminar/B747/gear/autobrakes/sel_dial_dn", "Autobrakes Sel Dial Down", B747_autobrakes_sel_dial_dn_CMDhandler)


-- AI
B747CMD_ai_gear_quick_start			= create_command("laminar/B747/ai/gear_quick_start", "number", B747_ai_gear_quick_start_CMDhandler)



--*************************************************************************************--
--** 					            OBJECT CONSTRUCTORS         		    		 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				               CREATE SYSTEM OBJECTS            				 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				                  SYSTEM FUNCTIONS           	    			 **--
--*************************************************************************************--

----- ANIMATION UTILITY -----------------------------------------------------------------
function B747_set_animation_position(current_value, target, min, max, speed)

    local fps_factor = math.min(1.0, speed * SIM_PERIOD)

    if target >= (max - 0.001) and current_value >= (max - 0.01) then
        return max
    elseif target <= (min + 0.001) and current_value <= (min + 0.01) then
       return min
    else
        return current_value + ((target - current_value) * fps_factor)
    end

end




----- RESCALE ---------------------------------------------------------------------------
function B747_rescale(in1, out1, in2, out2, x)

    if x < in1 then return out1 end
    if x > in2 then return out2 end
    return out1 + (out2 - out1) * (x - in1) / (in2 - in1)

end






----- SET GEAR HANDLE LOCK VALUE --------------------------------------------------------
function B747_set_gear_handle_lock()

    -- OVERRIDE LOCK BUTTON IS PRESSED
    if B747_gear_handle_lock_override == 1 then
        B747_gear_handle_lock = 0

    -- OVERRIDE LOCK BUTTON IS NOT PRESSED
    else

        -- AIRCRAFT WHEELS ARE ON THE GROUND
        if simDR_aircraft_on_ground == 1 then
            B747_gear_handle_lock = 1

        -- AIRCRAFT IS IN THE AIR
        else
            if (simDR_tire_steer_deg[1] == 0.0 and simDR_tire_steer_deg[1] == 0.0)          -- BODY GEAR "CENTERED" (STEERING)
                and (simDR_gear_claw_angle[3] > 0.0 and simDR_gear_claw_angle[4] > 0.0)     -- MAIN (WING) GEAR TILTED (CLAW)
            then
                B747_gear_handle_lock = 0
            end
        end
    end

end








----- PRIMARY EICAS GEAR STATUS DISPLAY -------------------------------------------------
function B747_primary_EICAS_gear_status()

    if simDR_gear_deploy_ratio[0] < 0.01
        and simDR_gear_deploy_ratio[1] < 0.01
        and simDR_gear_deploy_ratio[2] < 0.01
        and simDR_gear_deploy_ratio[3] < 0.01
        and simDR_gear_deploy_ratio[4] < 0.01
    then
        B747DR_gear_annun_status = 0                                                    -- GEAR RETRACTED

    elseif simDR_gear_deploy_ratio[0] > 0.99
        and simDR_gear_deploy_ratio[1] > 0.99
        and simDR_gear_deploy_ratio[2] > 0.99
        and simDR_gear_deploy_ratio[3] > 0.99
        and simDR_gear_deploy_ratio[4] > 0.99
    then
        B747DR_gear_annun_status = 1                                                    -- GEAR EXTENDED
    else
        B747DR_gear_annun_status = 2                                                    -- GEAR IN TRANSITION
    end

end






----- PRIMARY EICAS GEAR DISPLAY STATUS -------------------------------------------------
function B747_gear_display_shutoff()
    B747DR_EICAS1_gear_display_status = 0
end

function B747_primary_EICAS_gear_display()

    if B747DR_gear_annun_status == 0 then
        if B747DR_EICAS1_gear_display_status == 1 then
            if is_timer_scheduled(B747_gear_display_shutoff) == false then
                run_after_time(B747_gear_display_shutoff, 10.0)
            end
        end
    else
         if is_timer_scheduled(B747_gear_display_shutoff) == true then
            stop_timer(B747_gear_display_shutoff)
        end
        B747DR_EICAS1_gear_display_status = 1
    end

end






----- TIRE PRESSURE ---------------------------------------------------------------------
function B747_tire_pressure()

    math.randomseed(os.time())
    for i = 0, 17 do
        B747DR_tire_pressure[i] = math.random(198, 210)
    end

    --[[

        B747-400 TPIS (TIRE PRESSURE INDICATING SYSTEM) CHANNEL ASSIGNMENT:

        -- WING LEFT
        1 = OUTBOARD/FRONT (DR INDEX = 0)
        2 = INBOARD/FRONT (DR INDEX = 1)
        3 = OUTBOARD/REAR (DR INDEX = 2)
        4 = INBOARD/REAR (DR INDEX = 3)

        -- BODY LEFT
        5 = OUTBOARD/FRONT (DR INDEX = 4)
        6 = INBOARD/FRONT (DR INDEX = 5)
        7 = OUTBOARD/REAR (DR INDEX = 6)
        8 = INBOARD/REAR (DR INDEX = 7)

        -- BODY RIGHT
        9 = INBOARD/FRONT (DR INDEX = 8)
        10 = OUTBOARD/FRONT (DR INDEX = 9)
        11 = INBOARD/REAR (DR INDEX = 10)
        12 = OUTBOARD/REAR (DR INDEX = 11)

        -- WING RIGHT
        13 = INBOARD/FRONT (DR INDEX = 12)
        14 = OUTBOARD/FRONT (DR INDEX = 13)
        15 = INBOARD/REAR (DR INDEX = 14)
        16 = OUTBOARD/REAR (DR INDEX = 15)

        -- NOSE
        17 = LEFT (DR INDEX = 16)
        18 = RIGHT (DR INDEX = 17)

    --]]
end





----- BRAKE TEMPERATURE -----------------------------------------------------------------
function B747_brake_temp_init()

    for i = 0, 17 do
        B747DR_brake_temp[i] = simDR_OAT_degC
    end

end




function B747_brake_temp()

    -- DATAREF INDEXES SAME AS TIRE PRESSURE

    local brakingRatio_N = math.max(simDR_left_brake_ratio, simDR_right_brake_ratio, simDR_parking_brake_ratio)
    local brakingRatio_L = math.max(simDR_left_brake_ratio, simDR_parking_brake_ratio)
    local brakingRatio_R = math.max(simDR_right_brake_ratio, simDR_parking_brake_ratio)
    local tireSpeed = {}
    for i = 1, 5 do
        tireSpeed[i] = B747_rescale(0.0, 0.0, 200.0, 1.0, simDR_tire_rot_speed[i-1])
    end

    -- NOSE GEAR
    if tireSpeed[1] > 0 then
        if brakingRatio_N > 0 then
            local rate = brakingRatio_N * tireSpeed[1] * SIM_PERIOD * 40.0
            B747DR_brake_temp[17] = B747DR_brake_temp[17] + rate
            B747DR_brake_temp[18] = B747DR_brake_temp[17]
        end
    else
        local rate = 1.8 * SIM_PERIOD
        B747DR_brake_temp[17] = math.max(B747DR_brake_temp[17] - rate, simDR_OAT_degC)
        B747DR_brake_temp[18] = B747DR_brake_temp[17]
    end

    -- BODY RIGHT GEAR
    if tireSpeed[2] > 0 then
        if brakingRatio_R > 0 then
            local rate = brakingRatio_R * tireSpeed[2] * SIM_PERIOD * 40.0
            B747DR_brake_temp[8] = B747DR_brake_temp[8] + rate
            B747DR_brake_temp[9] = B747DR_brake_temp[8]
            B747DR_brake_temp[10] = B747DR_brake_temp[8]
            B747DR_brake_temp[11] = B747DR_brake_temp[8]
        end
    else
        local rate = 1.8 * SIM_PERIOD
        B747DR_brake_temp[8] = math.max(B747DR_brake_temp[8] - rate, simDR_OAT_degC)
        B747DR_brake_temp[9] = B747DR_brake_temp[8]
        B747DR_brake_temp[10] = B747DR_brake_temp[8]
        B747DR_brake_temp[11] = B747DR_brake_temp[8]
    end

    -- BODY LEFT GEAR
    if tireSpeed[3] > 0 then
        if brakingRatio_L > 0 then
            local rate = brakingRatio_L * tireSpeed[3] * SIM_PERIOD * 40.0
            B747DR_brake_temp[4] = B747DR_brake_temp[4] + rate
            B747DR_brake_temp[5] = B747DR_brake_temp[4]
            B747DR_brake_temp[6] = B747DR_brake_temp[4]
            B747DR_brake_temp[7] = B747DR_brake_temp[4]
        end
    else
        local rate = 1.8 * SIM_PERIOD
        B747DR_brake_temp[4] = math.max(B747DR_brake_temp[4] - rate, simDR_OAT_degC)
        B747DR_brake_temp[5] = B747DR_brake_temp[4]
        B747DR_brake_temp[6] = B747DR_brake_temp[4]
        B747DR_brake_temp[7] = B747DR_brake_temp[4]
    end

    -- WING RIGHT GEAR
    if tireSpeed[4] > 0 then
        if brakingRatio_R > 0 then
            local rate = brakingRatio_R * tireSpeed[4] * SIM_PERIOD * 40.0
            B747DR_brake_temp[12] = B747DR_brake_temp[12] + rate
            B747DR_brake_temp[13] = B747DR_brake_temp[12]
            B747DR_brake_temp[14] = B747DR_brake_temp[12]
            B747DR_brake_temp[15] = B747DR_brake_temp[12]
        end
    else
        local rate = 1.8 * SIM_PERIOD
        B747DR_brake_temp[12] = math.max(B747DR_brake_temp[12] - rate, simDR_OAT_degC)
        B747DR_brake_temp[13] = B747DR_brake_temp[12]
        B747DR_brake_temp[14] = B747DR_brake_temp[12]
        B747DR_brake_temp[15] = B747DR_brake_temp[12]
    end

    -- WING LEFT GEAR
    if tireSpeed[5] > 0 then
        if brakingRatio_L > 0 then
            local rate = brakingRatio_L * tireSpeed[5] * SIM_PERIOD * 40.0
            B747DR_brake_temp[0] = B747DR_brake_temp[0] + rate
            B747DR_brake_temp[1] = B747DR_brake_temp[0]
            B747DR_brake_temp[2] = B747DR_brake_temp[0]
            B747DR_brake_temp[3] = B747DR_brake_temp[0]
        end
    else
        local rate = 1.8 * SIM_PERIOD
        B747DR_brake_temp[0] = math.max(B747DR_brake_temp[0] - rate, simDR_OAT_degC)
        B747DR_brake_temp[1] = B747DR_brake_temp[0]
        B747DR_brake_temp[2] = B747DR_brake_temp[0]
        B747DR_brake_temp[3] = B747DR_brake_temp[0]
    end

    --
    -- level 0 = to 100c
    -- level 5 = 482c
    -- level 9 = 864c





end








----- EICAS MESSAGES --------------------------------------------------------------------
function B747_gear_EICAS_msg()

    -- AUTOBRAKES 1
    B747DR_CAS_memo_status[2] = 0
    if simDR_autobrakes_switch == 2 then B747DR_CAS_memo_status[2] = 1 end

    -- AUTOBRAKES 2
    B747DR_CAS_memo_status[3] = 0
    if simDR_autobrakes_switch == 3 then B747DR_CAS_memo_status[3] = 1 end

    -- AUTOBRAKES 3
    B747DR_CAS_memo_status[4] = 0
    if simDR_autobrakes_switch == 4 then B747DR_CAS_memo_status[4] = 1 end

    -- AUTOBRAKES 4
    B747DR_CAS_memo_status[5] = 0
    if simDR_autobrakes_switch == 5 then B747DR_CAS_memo_status[5] = 1 end

    -- AUTOBRAKES RTO
    B747DR_CAS_memo_status[7] = 0
    if simDR_autobrakes_switch == 0 then B747DR_CAS_memo_status[7] = 1 end

end






----- MONITOR AI FOR AUTO-BOARD CALL ----------------------------------------------------
function B747_gear_monitor_AI()

    if B747DR_init_gear_CD == 1 then
        B747_set_gear_all_modes()
        B747_set_gear_CD()
        B747DR_init_gear_CD = 2
    end

end





----- SET STATE FOR ALL MODES -----------------------------------------------------------
function B747_set_gear_all_modes()

	B747DR_init_gear_CD = 0
    B747DR_autobrakes_sel_dial_pos = 1                                                   -- INIT AUTOBRAKES TO "OFF
    simDR_autobrakes_switch = 1
    B747_tire_pressure()
    B747_brake_temp_init()
    B747DR_gear_handle = 0.0
    B747DR_gear_handle_DRhandler()

end





----- SET STATE TO COLD & DARK ----------------------------------------------------------
function B747_set_gear_CD()



end





----- SET STATE TO ENGINES RUNNING ------------------------------------------------------
function B747_set_gear_ER()
	
	
	
end





----- FLIGHT START ---------------------------------------------------------------------
function B747_flight_start_gear()

    -- ALL MODES ------------------------------------------------------------------------
    B747_set_gear_all_modes()


    -- COLD & DARK ----------------------------------------------------------------------
    if simDR_startup_running == 0 then

        B747_set_gear_CD()


    -- ENGINES RUNNING ------------------------------------------------------------------
    elseif simDR_startup_running == 1 then

		B747_set_gear_ER()


    end

end







--*************************************************************************************--
--** 				                  EVENT CALLBACKS           	    			 **--
--*************************************************************************************--

--function aircraft_load() end

--function aircraft_unload() end

function flight_start()

    B747_flight_start_gear()

end

--function flight_crash() end

--function before_physics() end

function after_physics()

    B747_set_gear_handle_lock()

    B747_primary_EICAS_gear_status()
    B747_primary_EICAS_gear_display()

    B747_gear_EICAS_msg()

    B747_brake_temp()

    B747_gear_monitor_AI()
    
end

--function after_replay() end



