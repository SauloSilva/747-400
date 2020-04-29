--[[
*****************************************************************************************
* Program Script Name	:	B747.40.engines
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

--NUM_THRUST_LEVERS = 5


function null_command(phase, duration)
end
--replace create command
function deferred_command(name,desc,nilFunc)
	c = XLuaCreateCommand(name,desc)
	print("Deffereed command: "..name)
	XLuaReplaceCommand(c,null_command)
	return make_command_obj(c)
end
--replace create dataref
function deferred_dataref(name,type,notifier)
	print("Deffered dataref: "..name)
	dref=XLuaCreateDataRef(name, type,"yes",notifier)
	return wrap_dref_any(dref,type) 
end




--*************************************************************************************--
--** 				        CREATE READ-ONLY CUSTOM DATAREFS               	         **--
--*************************************************************************************--

B747DR_thrust_mnp_show				= deferred_dataref("laminar/B747/engine/thrust_mnp_show", "array[4)")
B747DR_thrust_mnp_show_all			= deferred_dataref("laminar/B747/engine/thrust_mnp_show_all", "number")

B747DR_reverse_mnp_show				= deferred_dataref("laminar/B747/engine/rev_mnp_show", "array[4)")
B747DR_reverse_mnp_show_all			= deferred_dataref("laminar/B747/engine/rev_mnp_show_all", "number")

B747DR_engine_fuel_valve_pos        = deferred_dataref("laminar/B747/engines/fuel_valve_pos", "array[4)")
B747DR_EICAS2_fuel_on_ind_status    = deferred_dataref("laminar/B747/engines/fuel_on_indicator_status", "array[4)")
B747DR_EICAS2_oil_press_status      = deferred_dataref("laminar/B747/engines/EICAS2_oil_press_status", "array[4)")
B747DR_EICAS2_engine_vibration      = deferred_dataref("laminar/B747/engines/vibration", "array[4)")
B747DR_engine_oil_press_psi         = deferred_dataref("laminar/B747/engines/oil_press_psi", "array[4)")
B747DR_engine_oil_temp_degC         = deferred_dataref("laminar/B747/engines/oil_temp_degC", "array[4)")
B747DR_engine_oil_qty_liters        = deferred_dataref("laminar/B747/engines/oil_qty_liters", "array[4)")
B747DR_EPR_max_limit                = deferred_dataref("laminar/B747/engines/EPR/max_limit", "array[4)")
B747DR_EGT_amber_inhibit            = deferred_dataref("laminar/B747/engines/EGT/amber_inhibit", "array[4)")
B747DR_EGT_amber_on                 = deferred_dataref("laminar/B747/engines/EGT/amber_on", "array[4)")
B747DR_EGT_white_on                 = deferred_dataref("laminar/B747/engines/EGT/white_on", "array[4)")

B747DR_init_engines_CD              = deferred_dataref("laminar/B747/engines/init_CD", "number")

B747DR_engine_TOGA_mode             = deferred_dataref("laminar/B747/engines/TOGA_mode", "number")

B747DR_ref_thr_limit_mode           = deferred_dataref("laminar/B747/engines/ref_thr_limit_mode", "string")


	


-- AI
B747CMD_ai_engines_quick_start		= deferred_command("laminar/B747/ai/engines_quick_start", "number", B747_ai_engines_quick_start_CMDhandler)



B747DR_button_switch_position               = find_dataref("laminar/B747/button_switch/position")
B747DR_toggle_switch_position               = find_dataref("laminar/B747/toggle_switch/position")

B747DR_fuel_control_toggle_switch_pos       = find_dataref("laminar/B747/fuel/fuel_control/toggle_sw_pos")

B747DR_bleedAir_engine1_start_valve_pos     = find_dataref("laminar/B747/air/engine1/bleed_start_valve_pos")
B747DR_bleedAir_engine2_start_valve_pos     = find_dataref("laminar/B747/air/engine2/bleed_start_valve_pos")
B747DR_bleedAir_engine3_start_valve_pos     = find_dataref("laminar/B747/air/engine3/bleed_start_valve_pos")
B747DR_bleedAir_engine4_start_valve_pos     = find_dataref("laminar/B747/air/engine4/bleed_start_valve_pos")
simDR_engine_N2_pct             = find_dataref("sim/cockpit2/engine/indicators/N2_percent")
simDR_engine_fuel_mix_ratio     = find_dataref("sim/cockpit2/engine/actuators/mixture_ratio")
simDR_engine_starter_status     = find_dataref("sim/cockpit2/engine/actuators/ignition_key")
simDR_flap_deploy_ratio         = find_dataref("sim/flightmodel2/controls/flap_handle_deploy_ratio")
simDR_engine_nacelle_heat_on    = find_dataref("sim/cockpit2/ice/ice_inlet_heat_on_per_engine")
simDR_engine_igniter_on         = find_dataref("sim/cockpit2/annunciators/igniter_on")
simCMD_igniter_on_1         = find_command("sim/igniters/igniter_contin_on_1")
simCMD_igniter_on_2         = find_command("sim/igniters/igniter_contin_on_2")
simCMD_igniter_on_3         = find_command("sim/igniters/igniter_contin_on_3")
simCMD_igniter_on_4         = find_command("sim/igniters/igniter_contin_on_4")

simCMD_igniter_off_1        = find_command("sim/igniters/igniter_contin_off_1")
simCMD_igniter_off_2        = find_command("sim/igniters/igniter_contin_off_2")
simCMD_igniter_off_3        = find_command("sim/igniters/igniter_contin_off_3")
simCMD_igniter_off_4        = find_command("sim/igniters/igniter_contin_off_4")

simCMD_starter_on_1         = find_command("sim/starters/engage_starter_1")
simCMD_starter_on_2         = find_command("sim/starters/engage_starter_2")
simCMD_starter_on_3         = find_command("sim/starters/engage_starter_3")
simCMD_starter_on_4         = find_command("sim/starters/engage_starter_4")

simCMD_starter_off_1        = find_command("sim/starters/shut_down_1")
simCMD_starter_off_2        = find_command("sim/starters/shut_down_2")
simCMD_starter_off_3        = find_command("sim/starters/shut_down_3")
simCMD_starter_off_4        = find_command("sim/starters/shut_down_4")
B747CMD_engine_start_switch1        = find_command("laminar/B747/toggle_switch/engine_start1")
B747CMD_engine_start_switch2        = find_command("laminar/B747/toggle_switch/engine_start2")
B747CMD_engine_start_switch3        = find_command("laminar/B747/toggle_switch/engine_start3")
B747CMD_engine_start_switch4        = find_command("laminar/B747/toggle_switch/engine_start4")

B747CMD_engine_start_switch1_off    = find_command("laminar/B747/toggle_switch/engine_start1_off")
B747CMD_engine_start_switch2_off    = find_command("laminar/B747/toggle_switch/engine_start2_off")
B747CMD_engine_start_switch3_off    = find_command("laminar/B747/toggle_switch/engine_start3_off")
B747CMD_engine_start_switch4_off    = find_command("laminar/B747/toggle_switch/engine_start4_off")
local B747_igniter_status = {0, 0, 0, 0}
function B747_electronic_engine_control()


    -------------------------------------------------------------------------------------
    -----                         E N G I N E   S T A R T                           -----
    -------------------------------------------------------------------------------------

    -- ENGINE START SWITCH OFF
    local function B747_engine_start_sw_off(engine)

        if engine == 0 then
            if B747DR_toggle_switch_position[16] > 0 then B747CMD_engine_start_switch1_off:once() end
        end
        if engine == 1 then
            if B747DR_toggle_switch_position[17] > 0 then B747CMD_engine_start_switch2_off:once() end
        end
        if engine == 2 then
            if B747DR_toggle_switch_position[18] > 0 then B747CMD_engine_start_switch3_off:once() end
        end
        if engine == 3 then
            if B747DR_toggle_switch_position[19] > 0 then B747CMD_engine_start_switch4_off:once() end
        end

    end

    -- ENGINE STARTERS ON
    local function B747_engine_starter_on(engine)

        if engine == 0 then
            if simDR_engine_starter_status[0] < 4 then simCMD_starter_on_1:once() end
        end
        if engine == 1 then
            if simDR_engine_starter_status[1] < 4 then simCMD_starter_on_2:once() end
        end
        if engine == 2 then
            if simDR_engine_starter_status[2] < 4 then simCMD_starter_on_3:once() end
        end
        if engine == 3 then
            if simDR_engine_starter_status[3] < 4 then simCMD_starter_on_4:once() end
        end

    end

    -- ENGINE STARTERS OFF
    local function B747_engine_starter_off(engine)

        if engine == 0 then
            if simDR_engine_starter_status[0] > 3 then simCMD_starter_off_1:once() end
        end
        if engine == 1 then
            if simDR_engine_starter_status[1] > 3 then simCMD_starter_off_2:once() end
        end
        if engine == 2 then
            if simDR_engine_starter_status[2] > 3 then simCMD_starter_off_3:once() end
        end
        if engine == 3 then
            if simDR_engine_starter_status[3] > 3 then simCMD_starter_off_4:once() end
        end

    end



    --============================== ENGINE #1 ====================================--
    if simDR_engine_N2_pct[0] < 50.0 then

        if B747DR_bleedAir_engine1_start_valve_pos > 0.95 then                      -- START VALVE IS OPENED (START SWITCH PULLED) AND SUPPLYING BLEED AIR
            B747_engine_starter_on(0)                                               -- ENGAGE STARTER MOTOR
        else                                                                        -- START VALVE IS CLOSED - TERMNINATE MOTORING
            B747_engine_starter_off(0)                                              -- DISENGAGE STARTER MOTOR	-- TODO:  not needed??  starter is off automagically when not ON !!!!
        end

    -- STARTER CUTOUT @ N2 = 50.0%
    else
        B747_engine_start_sw_off(0)                                                 -- RESET START SWITCH
        B747_engine_starter_off(0)                                                  -- DISENGAGE STARTER MOTOR

    end


    --============================== ENGINE #2 ====================================--
    if simDR_engine_N2_pct[1] < 50.0 then

        if B747DR_bleedAir_engine2_start_valve_pos > 0.95 then                      -- START VALVE IS OPENED (START SWITCH PULLED) AND SUPPLYING BLEED AIR
            B747_engine_starter_on(1)                                               -- ENGAGE STARTER MOTOR
        else                                                                        -- START VALVE IS CLOSED - TERMNINATE MOTORING
            B747_engine_starter_off(1)                                              -- DISENGAGE STARTER MOTOR
        end

    -- STARTER CUTOUT @ N2 = 50.0%
    else
        B747_engine_start_sw_off(1)                                                 -- RESET START SWITCH
        B747_engine_starter_off(1)                                                  -- DISENGAGE STARTER MOTOR

    end


    --============================== ENGINE #3 ====================================--
    if simDR_engine_N2_pct[2] < 50.0 then

        if B747DR_bleedAir_engine3_start_valve_pos > 0.95 then                      -- START VALVE IS OPENED (START SWITCH PULLED) AND SUPPLYING BLEED AIR
            B747_engine_starter_on(2)                                               -- ENGAGE STARTER MOTOR
        else                                                                        -- START VALVE IS CLOSED - TERMNINATE MOTORING
            B747_engine_starter_off(2)                                              -- DISENGAGE STARTER MOTOR
        end

    -- STARTER CUTOUT @ N2 = 50.0%
    else
        B747_engine_start_sw_off(2)                                                 -- RESET START SWITCH
        B747_engine_starter_off(2)                                                  -- DISENGAGE STARTER MOTOR

    end


    --============================== ENGINE #4 ====================================--
    if simDR_engine_N2_pct[3] < 50.0 then

        if B747DR_bleedAir_engine4_start_valve_pos > 0.95 then                      -- START VALVE IS OPENED (START SWITCH PULLED) AND SUPPLYING BLEED AIR
            B747_engine_starter_on(3)                                               -- ENGAGE STARTER MOTOR
        else                                                                        -- START VALVE IS CLOSED - TERMNINATE MOTORING
            B747_engine_starter_off(3)                                              -- DISENGAGE STARTER MOTOR
        end

    -- STARTER CUTOUT @ N2 = 50.0%
    else
        B747_engine_start_sw_off(3)                                                 -- RESET START SWITCH
        B747_engine_starter_off(3)                                                  -- DISENGAGE STARTER MOTOR

    end








    -------------------------------------------------------------------------------------
    -----                             I G N I T E R S                               -----
    -------------------------------------------------------------------------------------

    ----- ENGINE #1 IGNITER STATUS ------------------------------------------------------
    if B747DR_button_switch_position[44] > 0.95                                         -- CONTINUOUS IGNITION SELECTED
        or simDR_flap_deploy_ratio > 0.0                                                -- FLAPS OUT OF "UP" POSITION
        or simDR_engine_nacelle_heat_on[0] == 1                                         -- ENGINE NACELLE HEAT IS ON

        -- MANUAL START
        or (B747DR_button_switch_position[45] < 0.05                                    -- AUTOSTART BUTTON SWITCH IS NOT DEPRESSED
            and B747DR_toggle_switch_position[16] == 1.0                                -- START SWITCH "PULLED"
            and B747DR_fuel_control_toggle_switch_pos[0] == 1.0)                        -- FUEL CONTROL SWITCH SET TO "RUN"

        -- AUTOSTART
        or (B747DR_button_switch_position[45] > 0.95                                    -- AUTOSTART BUTTON DEPRESSED
            and B747DR_toggle_switch_position[16] > 0.95                                -- ENGINE START SWITCH "PULLED"
            and B747DR_fuel_control_toggle_switch_pos[0] > 0.95                         -- FUEL CUTOFF SWITCH IS IN THE "RUN" POSITION
            and B747DR_engine_fuel_valve_pos[0] == 1)                                   -- SEQUENCE IGNITER AFTER FUEL INTRO

    then
        B747_igniter_status[1] = 1
    else
        B747_igniter_status[1] = 0
    end

    ----- ENGINE #2 IGNITER STATUS ------------------------------------------------------
    if B747DR_button_switch_position[44] > 0.95                                         -- CONTINUOUS IGNITION SELECTED
        or simDR_flap_deploy_ratio > 0.0                                                -- FLAPS OUT OF "UP" POSITION
        or simDR_engine_nacelle_heat_on[1] == 1                                         -- ENGINE NACELLE HEAT IS ON

        -- MANUAL START
        or (B747DR_button_switch_position[45] < 0.05                                    -- AUTOSTART BUTTON SWITCH IS NOT DEPRESSED
            and B747DR_toggle_switch_position[17] == 1.0                                -- START SWITCH "PULLED"
            and B747DR_fuel_control_toggle_switch_pos[1] == 1.0)                        -- FUEL CONTROL SWITCH SET TO "RUN"

        -- AUTOSTART
        or (B747DR_button_switch_position[45] > 0.95                                    -- AUTOSTART BUTTON DEPRESSED
            and B747DR_toggle_switch_position[17] > 0.95                                -- ENGINE START SWITCH "PULLED"
            and B747DR_fuel_control_toggle_switch_pos[1] > 0.95                         -- FUEL CUTOFF SWITCH IS IN THE "RUN" POSITION
            and B747DR_engine_fuel_valve_pos[1] == 1)                                   -- SEQUENCE IGNITER AFTER FUEL INTRO


    then
        B747_igniter_status[2] = 1
    else
        B747_igniter_status[2] = 0
    end

    ----- ENGINE #3 IGNITER STATUS ------------------------------------------------------
    if B747DR_button_switch_position[44] > 0.95                                         -- CONTINUOUS IGNITION SELECTED
        or simDR_flap_deploy_ratio > 0.0                                                -- FLAPS OUT OF "UP" POSITION
        or simDR_engine_nacelle_heat_on[2] == 1                                         -- ENGINE NACELLE HEAT IS ON

        -- MANUAL START
        or (B747DR_button_switch_position[45] < 0.05                                    -- AUTOSTART BUTTON SWITCH IS NOT DEPRESSED
            and B747DR_toggle_switch_position[18] == 1.0                                -- START SWITCH "PULLED"
            and B747DR_fuel_control_toggle_switch_pos[2] == 1.0)                        -- FUEL CONTROL SWITCH SET TO "RUN"

        -- AUTOSTART
        or (B747DR_button_switch_position[45] > 0.95                                    -- AUTOSTART BUTTON DEPRESSED
            and B747DR_toggle_switch_position[18] > 0.95                                -- ENGINE START SWITCH "PULLED"
            and B747DR_fuel_control_toggle_switch_pos[2] > 0.95                         -- FUEL CUTOFF SWITCH IS IN THE "RUN" POSITION
            and B747DR_engine_fuel_valve_pos[2] == 1)                                   -- SEQUENCE IGNITER AFTER FUEL INTRO


    then
        B747_igniter_status[3] = 1
    else
        B747_igniter_status[3] = 0
    end

    ----- ENGINE #4 IGNITER STATUS ------------------------------------------------------
    if B747DR_button_switch_position[44] > 0.95                                         -- CONTINUOUS IGNITION SELECTED
        or simDR_flap_deploy_ratio > 0.0                                                -- FLAPS OUT OF "UP" POSITION
        or simDR_engine_nacelle_heat_on[3] == 1                                         -- ENGINE NACELLE HEAT IS ON

        -- MANUAL START
        or (B747DR_button_switch_position[45] < 0.05                                    -- AUTOSTART BUTTON SWITCH IS NOT DEPRESSED
            and B747DR_toggle_switch_position[19] == 1.0                                -- START SWITCH "PULLED"
            and B747DR_fuel_control_toggle_switch_pos[3] == 1.0)                        -- FUEL CONTROL SWITCH SET TO "RUN"

        -- AUTOSTART
        or (B747DR_button_switch_position[45] > 0.95                                    -- AUTOSTART BUTTON DEPRESSED
            and B747DR_toggle_switch_position[19] > 0.95                                -- ENGINE START SWITCH "PULLED"
            and B747DR_fuel_control_toggle_switch_pos[3] > 0.95                         -- FUEL CUTOFF SWITCH IS IN THE "RUN" POSITION
            and B747DR_engine_fuel_valve_pos[3] == 1)                                   -- SEQUENCE IGNITER AFTER FUEL INTRO


    then
        B747_igniter_status[4] = 1
    else
        B747_igniter_status[4] = 0
    end




    ----- SET X-PLANE IGNITER STATE -----------------------------------------------------

    -- ENGINE 1
    if B747_igniter_status[1] == 1 and simDR_engine_igniter_on[0] == 0 then
        simCMD_igniter_on_1:once()
    elseif B747_igniter_status[1] == 0 and simDR_engine_igniter_on[0] == 1 then
        simCMD_igniter_off_1:once()
    end

    -- ENGINE 2
    if B747_igniter_status[2] == 1 and simDR_engine_igniter_on[1] == 0 then
        simCMD_igniter_on_2:once()
    elseif B747_igniter_status[2] == 0 and simDR_engine_igniter_on[1] == 1 then
        simCMD_igniter_off_2:once()
    end

    -- ENGINE 3
    if B747_igniter_status[3] == 1 and simDR_engine_igniter_on[2] == 0 then
        simCMD_igniter_on_3:once()
    elseif B747_igniter_status[3] == 0 and simDR_engine_igniter_on[2] == 1 then
        simCMD_igniter_off_3:once()
    end

    -- ENGINE 4
    if B747_igniter_status[4] == 1 and simDR_engine_igniter_on[3] == 0 then
        simCMD_igniter_on_4:once()
    elseif B747_igniter_status[4] == 0 and simDR_engine_igniter_on[3] == 1 then
        simCMD_igniter_off_4:once()
    end




    -------------------------------------------------------------------------------------
    -----                  E N G I N E   F U E L   V A L V E S                      -----   TODO:  ADD POWER REQUIREMENT FOR VALVE ACTUATION ?
    -------------------------------------------------------------------------------------

    ----- ENGINE #1 ---------------------------------------------------------------------
    B747DR_engine_fuel_valve_pos[0] = 0                                                     -- VALVE IS NORMALLY CLOSED

    -- MANUAL START
    if B747DR_button_switch_position[45] < 0.5                                              -- AUTOSTART BUTTON NOT DEPRESSED
        and B747DR_fuel_control_toggle_switch_pos[0] == 1.0                                 -- FUEL CONTROL SWITCH SET TO "RUN"
    then
        B747DR_engine_fuel_valve_pos[0] = 1                                                 -- OPEN THE VALVE

    -- AUTOSTART
    elseif B747DR_button_switch_position[45] > 0.5                                          -- AUTOSTART BUTTON DEPRESSED
        and simDR_engine_N2_pct[0] > 15.0
    then
        B747DR_engine_fuel_valve_pos[0] = 1                                                 -- OPEN THE VALVE
    end
    simDR_engine_fuel_mix_ratio[0] =  B747DR_engine_fuel_valve_pos[0]                       -- SET SIM MIXTURE RATIO



    ----- ENGINE #2 ---------------------------------------------------------------------
    B747DR_engine_fuel_valve_pos[1] = 0                                                     -- VALVE IS NORMALLY CLOSED

    -- MANUAL START
    if B747DR_button_switch_position[45] < 0.5                                              -- AUTOSTART BUTTON NOT DEPRESSED
        and B747DR_fuel_control_toggle_switch_pos[1] == 1.0                                 -- FUEL CONTROL SWITCH SET TO "RUN"
    then
        B747DR_engine_fuel_valve_pos[1] = 1                                                 -- OPEN THE VALVE

    -- AUTOSTART
    elseif B747DR_button_switch_position[45] > 0.5                                          -- AUTOSTART BUTTON DEPRESSED
        and simDR_engine_N2_pct[1] > 15.0
    then
        B747DR_engine_fuel_valve_pos[1] = 1                                                 -- OPEN THE VALVE
    end
    simDR_engine_fuel_mix_ratio[1] =  B747DR_engine_fuel_valve_pos[1]                       -- SET SIM MIXTURE RATIO



    ----- ENGINE #3 ---------------------------------------------------------------------
    B747DR_engine_fuel_valve_pos[2] = 0                                                     -- VALVE IS NORMALLY CLOSED

    -- MANUAL START
    if B747DR_button_switch_position[45] < 0.5                                              -- AUTOSTART BUTTON NOT DEPRESSED
        and B747DR_fuel_control_toggle_switch_pos[2] == 1.0                                 -- FUEL CONTROL SWITCH SET TO "RUN"
    then
        B747DR_engine_fuel_valve_pos[2] = 1                                                 -- OPEN THE VALVE

    -- AUTOSTART
    elseif B747DR_button_switch_position[45] > 0.5                                          -- AUTOSTART BUTTON DEPRESSED
        and simDR_engine_N2_pct[2] > 15.0
    then
        B747DR_engine_fuel_valve_pos[2] = 1                                                 -- OPEN THE VALVE
    end
    simDR_engine_fuel_mix_ratio[2] =  B747DR_engine_fuel_valve_pos[2]                       -- SET SIM MIXTURE RATIO



    ----- ENGINE #4 ---------------------------------------------------------------------
    B747DR_engine_fuel_valve_pos[3] = 0                                                     -- VALVE IS NORMALLY CLOSED

    -- MANUAL START
    if B747DR_button_switch_position[45] < 0.5                                              -- AUTOSTART BUTTON NOT DEPRESSED
        and B747DR_fuel_control_toggle_switch_pos[3] == 1.0                                 -- FUEL CONTROL SWITCH SET TO "RUN"
    then
        B747DR_engine_fuel_valve_pos[3] = 1                                                 -- OPEN THE VALVE

    -- AUTOSTART
    elseif B747DR_button_switch_position[45] > 0.5                                          -- AUTOSTART BUTTON DEPRESSED
        and simDR_engine_N2_pct[3] > 15.0
    then
        B747DR_engine_fuel_valve_pos[3] = 1                                                 -- OPEN THE VALVE
    end
    simDR_engine_fuel_mix_ratio[3] =  B747DR_engine_fuel_valve_pos[3]                       -- SET SIM MIXTURE RATIO

end

function before_physics()

    B747_electronic_engine_control()

end


