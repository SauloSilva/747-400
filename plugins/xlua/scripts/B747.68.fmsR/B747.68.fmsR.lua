--[[
*****************************************************************************************
* Program Script Name	:	B747.68.fmsR

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



--*************************************************************************************--
--** 					            GLOBAL VARIABLES                				 **--
--*************************************************************************************--



--*************************************************************************************--
--** 					            LOCAL VARIABLES                 				 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				             FIND X-PLANE DATAREFS           			    	 **--
--*************************************************************************************--

simDR_startup_running               = find_dataref("sim/operation/prefs/startup_running")

simDR_instrument_brightness_switch  = find_dataref("sim/cockpit2/switches/instrument_brightness_ratio")

simDR_radio_nav_freq_Mhz            = find_dataref("sim/cockpit2/radios/actuators/nav_frequency_Mhz")
simDR_radio_nav_freq_khz            = find_dataref("sim/cockpit2/radios/actuators/nav_frequency_khz")
simDR_radio_nav_freq_hz             = find_dataref("sim/cockpit2/radios/actuators/nav_frequency_hz")
simDR_radio_nav_course_deg          = find_dataref("sim/cockpit2/radios/actuators/nav_course_deg_mag_pilot")
simDR_radio_nav_obs_deg             = find_dataref("sim/cockpit2/radios/actuators/nav_obs_deg_mag_pilot")
simDR_radio_nav03_ID                = find_dataref("sim/cockpit2/radios/indicators/nav3_nav_id")
simDR_radio_nav04_ID                = find_dataref("sim/cockpit2/radios/indicators/nav4_nav_id")

simDR_radio_adf1_freq_hz            = find_dataref("sim/cockpit2/radios/actuators/adf1_frequency_hz")
simDR_radio_adf2_freq_hz            = find_dataref("sim/cockpit2/radios/actuators/adf2_frequency_hz")





--*************************************************************************************--
--** 				              FIND CUSTOM DATAREFS             			    	 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				              FIND X-PLANE COMMANDS                   	    	 **--
--*************************************************************************************--

simCMD_FMS2_ls_1L            = find_command("sim/FMS2/ls_1l")
simCMD_FMS2_ls_2L            = find_command("sim/FMS2/ls_2l")
simCMD_FMS2_ls_3L            = find_command("sim/FMS2/ls_3l")
simCMD_FMS2_ls_4L            = find_command("sim/FMS2/ls_4l")
simCMD_FMS2_ls_5L            = find_command("sim/FMS2/ls_5l")
simCMD_FMS2_ls_6L            = find_command("sim/FMS2/ls_6l")

simCMD_FMS2_ls_1R            = find_command("sim/FMS2/ls_1r")
simCMD_FMS2_ls_2R            = find_command("sim/FMS2/ls_2r")
simCMD_FMS2_ls_3R            = find_command("sim/FMS2/ls_3r")
simCMD_FMS2_ls_4R            = find_command("sim/FMS2/ls_4r")
simCMD_FMS2_ls_5R            = find_command("sim/FMS2/ls_5r")
simCMD_FMS2_ls_6R            = find_command("sim/FMS2/ls_6r")

simCMD_FMS2_key_index        = find_command("sim/FMS2/index")
simCMD_FMS2_key_fpln         = find_command("sim/FMS2/fpln")
simCMD_FMS2_key_clb          = find_command("sim/FMS2/clb")
simCMD_FMS2_key_crz          = find_command("sim/FMS2/crz")
simCMD_FMS2_key_des          = find_command("sim/FMS2/des")

simCMD_FMS2_key_dir_intc     = find_command("sim/FMS2/dir_intc")
simCMD_FMS2_key_legs         = find_command("sim/FMS2/legs")
simCMD_FMS2_key_dep_arr      = find_command("sim/FMS2/dep_arr")
simCMD_FMS2_key_hold         = find_command("sim/FMS2/hold")
simCMD_FMS2_key_prog         = find_command("sim/FMS2/prog")
simCMD_FMS2_key_exec         = find_command("sim/FMS2/exec")

simCMD_FMS2_key_fix          = find_command("sim/FMS2/fix")

simCMD_FMS2_prev             = find_command("sim/FMS2/prev")
simCMD_FMS2_next             = find_command("sim/FMS2/next")

simCMD_FMS2_key_0            = find_command("sim/FMS2/key_0")
simCMD_FMS2_key_1            = find_command("sim/FMS2/key_1")
simCMD_FMS2_key_2            = find_command("sim/FMS2/key_2")
simCMD_FMS2_key_3            = find_command("sim/FMS2/key_3")
simCMD_FMS2_key_4            = find_command("sim/FMS2/key_4")
simCMD_FMS2_key_5            = find_command("sim/FMS2/key_5")
simCMD_FMS2_key_6            = find_command("sim/FMS2/key_6")
simCMD_FMS2_key_7            = find_command("sim/FMS2/key_7")
simCMD_FMS2_key_8            = find_command("sim/FMS2/key_8")
simCMD_FMS2_key_9            = find_command("sim/FMS2/key_9")

simCMD_FMS2_key_period       = find_command("sim/FMS2/key_period")
simCMD_FMS2_key_minus        = find_command("sim/FMS2/key_minus")

simCMD_FMS2_key_A            = find_command("sim/FMS2/key_A")
simCMD_FMS2_key_B            = find_command("sim/FMS2/key_B")
simCMD_FMS2_key_C            = find_command("sim/FMS2/key_C")
simCMD_FMS2_key_D            = find_command("sim/FMS2/key_D")
simCMD_FMS2_key_E            = find_command("sim/FMS2/key_E")
simCMD_FMS2_key_F            = find_command("sim/FMS2/key_F")
simCMD_FMS2_key_G            = find_command("sim/FMS2/key_G")
simCMD_FMS2_key_H            = find_command("sim/FMS2/key_H")
simCMD_FMS2_key_I            = find_command("sim/FMS2/key_I")
simCMD_FMS2_key_J            = find_command("sim/FMS2/key_J")
simCMD_FMS2_key_K            = find_command("sim/FMS2/key_K")
simCMD_FMS2_key_L            = find_command("sim/FMS2/key_L")
simCMD_FMS2_key_M            = find_command("sim/FMS2/key_M")
simCMD_FMS2_key_N            = find_command("sim/FMS2/key_N")
simCMD_FMS2_key_O            = find_command("sim/FMS2/key_O")
simCMD_FMS2_key_P            = find_command("sim/FMS2/key_P")
simCMD_FMS2_key_Q            = find_command("sim/FMS2/key_Q")
simCMD_FMS2_key_R            = find_command("sim/FMS2/key_R")
simCMD_FMS2_key_S            = find_command("sim/FMS2/key_S")
simCMD_FMS2_key_T            = find_command("sim/FMS2/key_T")
simCMD_FMS2_key_U            = find_command("sim/FMS2/key_U")
simCMD_FMS2_key_V            = find_command("sim/FMS2/key_V")
simCMD_FMS2_key_W            = find_command("sim/FMS2/key_W")
simCMD_FMS2_key_X            = find_command("sim/FMS2/key_X")
simCMD_FMS2_key_Y            = find_command("sim/FMS2/key_Y")
simCMD_FMS2_key_Z            = find_command("sim/FMS2/key_Z")

simCMD_FMS2_key_space        = find_command("sim/FMS2/key_space")
simCMD_FMS2_key_delete       = find_command("sim/FMS2/key_delete")
simCMD_FMS2_key_slash        = find_command("sim/FMS2/key_slash")
simCMD_FMS2_key_clear        = find_command("sim/FMS2/key_clear")





--*************************************************************************************--
--** 				              FIND CUSTOM COMMANDS              			     **--
--*************************************************************************************--



--*************************************************************************************--
--** 				       READ-WRITE CUSTOM DATAREF HANDLERS     	        	     **--
--*************************************************************************************--

function B747_fms2_display_brightness_DRhandler()
    simDR_instrument_brightness_switch[13] = B747DR_fms2_display_brightness
end




--*************************************************************************************--
--** 				             X-PLANE COMMAND HANDLERS               	    	 **--
--*************************************************************************************--

function sim_fms2_func_key_beforeCMDhandler(phase, duration)
    if phase == 0 then B747_set_FMS2_display_mode_norm() end
end
function sim_fms2_func_key_afterCMDhandler(phase, duration) end




--*************************************************************************************--
--** 				             CUSTOM COMMAND HANDLERS            			     **--
--*************************************************************************************--

-- LINE SELECT KEYS ---------------------------------------------------------------------
function B747_fms2_ls_key_L1_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_ls_1L:once() end
end
function B747_fms2_ls_key_L2_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_ls_2L:once() end
end
function B747_fms2_ls_key_L3_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_ls_3L:once() end
end
function B747_fms2_ls_key_L4_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_ls_4L:once() end
end
function B747_fms2_ls_key_L5_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_ls_5L:once() end
end
function B747_fms2_ls_key_L6_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_ls_6L:once() end
end
function B747_fms2_ls_key_R1_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_ls_1R:once() end
end
function B747_fms2_ls_key_R2_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_ls_2R:once() end
end
function B747_fms2_ls_key_R3_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_ls_3R:once() end
end
function B747_fms2_ls_key_R4_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_ls_4R:once() end
end
function B747_fms2_ls_key_R5_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_ls_5R:once() end
end
function B747_fms2_ls_key_R6_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_ls_6R:once() end
end


-- FUNCTION KEYS ------------------------------------------------------------------------
function B747_fms2_func_key_index_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_index:once() end
end
function B747_fms2_func_key_fpln_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_fpln:once() end
end
function B747_fms2_func_key_clb_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_clb:once() end
end
function B747_fms2_func_key_crz_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_crz:once() end
end
function B747_fms2_func_key_des_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_des:once() end
end
function B747_fms2_func_key_dir_intc_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_dir_intc:once() end
end
function B747_fms2_func_key_legs_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_legs:once() end
end
function B747_fms2_func_key_dep_arr_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_dep_arr:once() end
end
function B747_fms2_func_key_hold_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_hold:once() end
end
function B747_fms2_func_key_prog_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_prog:once() end
end
function B747_fms2_key_execute_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_exec:once() end
end
function B747_fms2_func_key_fix_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_fix:once() end
end
function B747_fms2_func_key_nav_rad_CMDhandler(phase, duration)
    if phase == 0 then B747DR_fms2_display_mode = 1 end
end
function B747_fms2_func_key_prev_pg_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_prev:once() end
end
function B747_fms2_func_key_next_pg_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_next:once() end
end


-- ALPHA-NUMERIC KEYS -------------------------------------------------------------------
function B747_fms2_alphanum_key_A_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_A:once() end
end
function B747_fms2_alphanum_key_B_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_B:once() end
end
function B747_fms2_alphanum_key_C_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_C:once() end
end
function B747_fms2_alphanum_key_D_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_D:once() end
end
function B747_fms2_alphanum_key_E_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_E:once() end
end
function B747_fms2_alphanum_key_F_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_F:once() end
end
function B747_fms2_alphanum_key_G_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_G:once() end
end
function B747_fms2_alphanum_key_H_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_H:once() end
end
function B747_fms2_alphanum_key_I_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_I:once() end
end
function B747_fms2_alphanum_key_J_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_J:once() end
end
function B747_fms2_alphanum_key_K_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_K:once() end
end
function B747_fms2_alphanum_key_L_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_L:once() end
end
function B747_fms2_alphanum_key_M_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_M:once() end
end
function B747_fms2_alphanum_key_N_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_N:once() end
end
function B747_fms2_alphanum_key_O_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_O:once() end
end
function B747_fms2_alphanum_key_P_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_P:once() end
end
function B747_fms2_alphanum_key_Q_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_Q:once() end
end
function B747_fms2_alphanum_key_R_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_R:once() end
end
function B747_fms2_alphanum_key_S_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_S:once() end
end
function B747_fms2_alphanum_key_T_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_T:once() end
end
function B747_fms2_alphanum_key_U_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_U:once() end
end
function B747_fms2_alphanum_key_V_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_V:once() end
end
function B747_fms2_alphanum_key_W_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_W:once() end
end
function B747_fms2_alphanum_key_X_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_X:once() end
end
function B747_fms2_alphanum_key_Y_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_Y:once() end
end
function B747_fms2_alphanum_key_Z_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_Z:once() end
end

function B747_fms2_alphanum_key_0_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_0:once() end
end
function B747_fms2_alphanum_key_1_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_1:once() end
end
function B747_fms2_alphanum_key_2_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_2:once() end
end
function B747_fms2_alphanum_key_3_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_3:once() end
end
function B747_fms2_alphanum_key_4_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_4:once() end
end
function B747_fms2_alphanum_key_5_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_5:once() end
end
function B747_fms2_alphanum_key_6_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_6:once() end
end
function B747_fms2_alphanum_key_7_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_7:once() end
end
function B747_fms2_alphanum_key_8_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_8:once() end
end
function B747_fms2_alphanum_key_9_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_9:once() end
end


-- MISC KEYS ----------------------------------------------------------------------------
function B747_fms2_key_period_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_period:once() end
end
function B747_fms2_key_minus_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_minus:once() end
end
function B747_fms2_key_space_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_space:once() end
end
function B747_fms2_key_del_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_delete:once() end
end
function B747_fms2_key_slash_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_slash:once() end
end
function B747_fms2_key_clear_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS2_key_clear:once() end
end







----- RADIO MANIPS ----------------------------------------------------------------------
-- VOR: 108.00-117.95
function B747_fms2_vorL_freq_coarse_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_Mhz[2] == 117 then
            simDR_radio_nav_freq_Mhz[2] = 108
        else
            simDR_radio_nav_freq_Mhz[2] = simDR_radio_nav_freq_Mhz[2] + 1
        end
    end
end
function B747_fms2_vorL_freq_coarse_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_Mhz[2] == 108 then
            simDR_radio_nav_freq_Mhz[2] = 117
        else
            simDR_radio_nav_freq_Mhz[2] = simDR_radio_nav_freq_Mhz[2] - 1
        end
    end
end
function B747_fms2_vorL_freq_fine_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_khz[2] == 95 then
            simDR_radio_nav_freq_khz[2] = 0
        else
            simDR_radio_nav_freq_khz[2] = simDR_radio_nav_freq_khz[2] + 5
        end
    end
end
function B747_fms2_vorL_freq_fine_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_khz[2] == 0 then
            simDR_radio_nav_freq_khz[2] = 95
        else
            simDR_radio_nav_freq_khz[2] = simDR_radio_nav_freq_khz[2] - 5
        end
    end
end

function B747_fms2_vorL_course_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_obs_deg[2] >= 359.0 then
            simDR_radio_nav_obs_deg[2] = 0.0
        else
            simDR_radio_nav_obs_deg[2] = simDR_radio_nav_obs_deg[2] + 1
        end
    end
end
function B747_fms2_vorL_course_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_obs_deg[2] <= 0.0 then
            simDR_radio_nav_obs_deg[2] = 359.0
        else
            simDR_radio_nav_obs_deg[2] = simDR_radio_nav_obs_deg[2] - 1
        end
    end
end





function B747_fms2_vorR_freq_coarse_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_Mhz[3] == 117 then
            simDR_radio_nav_freq_Mhz[3] = 108
        else
            simDR_radio_nav_freq_Mhz[3] = simDR_radio_nav_freq_Mhz[3] + 1
        end
    end
end
function B747_fms2_vorR_freq_coarse_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_Mhz[3] == 108 then
            simDR_radio_nav_freq_Mhz[3] = 117
        else
            simDR_radio_nav_freq_Mhz[3] = simDR_radio_nav_freq_Mhz[3] - 1
        end
    end
end
function B747_fms2_vorR_freq_fine_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_khz[3] == 95 then
            simDR_radio_nav_freq_khz[3] = 0
        else
            simDR_radio_nav_freq_khz[3] = simDR_radio_nav_freq_khz[3] + 5
        end
    end
end
function B747_fms2_vorR_freq_fine_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_khz[3] == 0 then
            simDR_radio_nav_freq_khz[3] = 95
        else
            simDR_radio_nav_freq_khz[3] = simDR_radio_nav_freq_khz[3] - 5
        end
    end
end

function B747_fms2_vorR_course_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_obs_deg[3] >= 359.0 then
            simDR_radio_nav_obs_deg[3] = 0.0
        else
            simDR_radio_nav_obs_deg[3] = simDR_radio_nav_obs_deg[3] + 1
        end
    end
end
function B747_fms2_vorR_course_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_obs_deg[3] <= 0.0 then
            simDR_radio_nav_obs_deg[3] = 359.0
        else
            simDR_radio_nav_obs_deg[3] = simDR_radio_nav_obs_deg[3] - 1
        end
    end
end




function B747_fms2_ils_course_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_obs_deg[1] >= 359.0 then
            simDR_radio_nav_obs_deg[1] = 0.0
        else
            simDR_radio_nav_obs_deg[1] = simDR_radio_nav_obs_deg[1] + 1
        end
    end
end
function B747_fms2_ils_course_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_obs_deg[1] <= 0.0 then
            simDR_radio_nav_obs_deg[1] = 359.0
        else
            simDR_radio_nav_obs_deg[1] = simDR_radio_nav_obs_deg[1] - 1
        end
    end
end




function B747_ai_fmsR_quick_start_CMDhandler(phase, duration)
    if phase == 0 then
		B747_set_fmsR_all_modes()
		B747_set_fmsR_CD()
		B747_set_fmsR_ER()
    end
end







--*************************************************************************************--
--** 				        CREATE READ-ONLY CUSTOM DATAREFS               	         **--
--*************************************************************************************--

B747DR_fms2_display_mode            = create_dataref("laminar/B747/fms2/display_mode", "number")
--[[
    0 = NORMAL
    1 = NAV RAD
--]]


B747DR_fms2_Line01_L                = create_dataref("laminar/B747/fms2/Line01_L", "string")
B747DR_fms2_Line02_L                = create_dataref("laminar/B747/fms2/Line02_L", "string")
B747DR_fms2_Line03_L                = create_dataref("laminar/B747/fms2/Line03_L", "string")
B747DR_fms2_Line04_L                = create_dataref("laminar/B747/fms2/Line04_L", "string")
B747DR_fms2_Line05_L                = create_dataref("laminar/B747/fms2/Line05_L", "string")
B747DR_fms2_Line06_L                = create_dataref("laminar/B747/fms2/Line06_L", "string")
B747DR_fms2_Line07_L                = create_dataref("laminar/B747/fms2/Line07_L", "string")
B747DR_fms2_Line08_L                = create_dataref("laminar/B747/fms2/Line08_L", "string")
B747DR_fms2_Line09_L                = create_dataref("laminar/B747/fms2/Line09_L", "string")
B747DR_fms2_Line10_L                = create_dataref("laminar/B747/fms2/Line10_L", "string")
B747DR_fms2_Line11_L                = create_dataref("laminar/B747/fms2/Line11_L", "string")
B747DR_fms2_Line12_L                = create_dataref("laminar/B747/fms2/Line12_L", "string")
B747DR_fms2_Line13_L                = create_dataref("laminar/B747/fms2/Line13_L", "string")
B747DR_fms2_Line14_L                = create_dataref("laminar/B747/fms2/Line14_L", "string")

B747DR_fms2_Line01_S                = create_dataref("laminar/B747/fms2/Line01_S", "string")
B747DR_fms2_Line02_S                = create_dataref("laminar/B747/fms2/Line02_S", "string")
B747DR_fms2_Line03_S                = create_dataref("laminar/B747/fms2/Line03_S", "string")
B747DR_fms2_Line04_S                = create_dataref("laminar/B747/fms2/Line04_S", "string")
B747DR_fms2_Line05_S                = create_dataref("laminar/B747/fms2/Line05_S", "string")
B747DR_fms2_Line06_S                = create_dataref("laminar/B747/fms2/Line06_S", "string")
B747DR_fms2_Line07_S                = create_dataref("laminar/B747/fms2/Line07_S", "string")
B747DR_fms2_Line08_S                = create_dataref("laminar/B747/fms2/Line08_S", "string")
B747DR_fms2_Line09_S                = create_dataref("laminar/B747/fms2/Line09_S", "string")
B747DR_fms2_Line10_S                = create_dataref("laminar/B747/fms2/Line10_S", "string")
B747DR_fms2_Line11_S                = create_dataref("laminar/B747/fms2/Line11_S", "string")
B747DR_fms2_Line12_S                = create_dataref("laminar/B747/fms2/Line12_S", "string")
B747DR_fms2_Line13_S                = create_dataref("laminar/B747/fms2/Line13_S", "string")
B747DR_fms2_Line14_S                = create_dataref("laminar/B747/fms2/Line14_S", "string")

B747DR_init_fmsR_CD                 = create_dataref("laminar/B747/fmsR/init_CD", "number")



--*************************************************************************************--
--** 				        CREATE READ-WRITE CUSTOM DATAREFS                        **--
--*************************************************************************************--

-- CRT BRIGHTNESS DIAL ------------------------------------------------------------------
B747DR_fms2_display_brightness      = create_dataref("laminar/B747/fms2/display_brightness", "number", B747_fms2_display_brightness_DRhandler)




--*************************************************************************************--
--** 				              CREATE CUSTOM COMMANDS              			     **--
--*************************************************************************************--

-- LINE SELECT KEYS ---------------------------------------------------------------------
B747CMD_fms2_ls_key_L1              = create_command("laminar/B747/fms2/ls_key/L1", "FMS2 Line Select Key 1-Left", B747_fms2_ls_key_L1_CMDhandler)
B747CMD_fms2_ls_key_L2              = create_command("laminar/B747/fms2/ls_key/L2", "FMS2 Line Select Key 2-Left", B747_fms2_ls_key_L2_CMDhandler)
B747CMD_fms2_ls_key_L3              = create_command("laminar/B747/fms2/ls_key/L3", "FMS2 Line Select Key 3-Left", B747_fms2_ls_key_L3_CMDhandler)
B747CMD_fms2_ls_key_L4              = create_command("laminar/B747/fms2/ls_key/L4", "FMS2 Line Select Key 4-Left", B747_fms2_ls_key_L4_CMDhandler)
B747CMD_fms2_ls_key_L5              = create_command("laminar/B747/fms2/ls_key/L5", "FMS2 Line Select Key 5-Left", B747_fms2_ls_key_L5_CMDhandler)
B747CMD_fms2_ls_key_L6              = create_command("laminar/B747/fms2/ls_key/L6", "FMS2 Line Select Key 6-Left", B747_fms2_ls_key_L6_CMDhandler)

B747CMD_fms2_ls_key_R1              = create_command("laminar/B747/fms2/ls_key/R1", "FMS2 Line Select Key 1-Right", B747_fms2_ls_key_R1_CMDhandler)
B747CMD_fms2_ls_key_R2              = create_command("laminar/B747/fms2/ls_key/R2", "FMS2 Line Select Key 2-Right", B747_fms2_ls_key_R2_CMDhandler)
B747CMD_fms2_ls_key_R3              = create_command("laminar/B747/fms2/ls_key/R3", "FMS2 Line Select Key 3-Right", B747_fms2_ls_key_R3_CMDhandler)
B747CMD_fms2_ls_key_R4              = create_command("laminar/B747/fms2/ls_key/R4", "FMS2 Line Select Key 4-Right", B747_fms2_ls_key_R4_CMDhandler)
B747CMD_fms2_ls_key_R5              = create_command("laminar/B747/fms2/ls_key/R5", "FMS2 Line Select Key 5-Right", B747_fms2_ls_key_R5_CMDhandler)
B747CMD_fms2_ls_key_R6              = create_command("laminar/B747/fms2/ls_key/R6", "FMS2 Line Select Key 6-Right", B747_fms2_ls_key_R6_CMDhandler)


-- FUNCTION KEYS ------------------------------------------------------------------------
B747CMD_fms2_func_key_index         = create_command("laminar/B747/fms2/func_key/index", "FMS2 Function Key INDEX", B747_fms2_func_key_index_CMDhandler)
B747CMD_fms2_func_key_fpln          = create_command("laminar/B747/fms2/func_key/fpln", "FMS2 Function Key FPLN", B747_fms2_func_key_fpln_CMDhandler)
B747CMD_fms2_func_key_clb           = create_command("laminar/B747/fms2/func_key/clb", "FMS2 Function Key CLB", B747_fms2_func_key_clb_CMDhandler)
B747CMD_fms2_func_key_crz           = create_command("laminar/B747/fms2/func_key/crz", "FMS2 Function Key CRZ", B747_fms2_func_key_crz_CMDhandler)
B747CMD_fms2_func_key_des           = create_command("laminar/B747/fms2/func_key/des", "FMS2 Function Key DES", B747_fms2_func_key_des_CMDhandler)
B747CMD_fms2_func_key_dir_intc      = create_command("laminar/B747/fms2/func_key/dir_intc", "FMS2 Function Key DIR/INTC", B747_fms2_func_key_dir_intc_CMDhandler)
B747CMD_fms2_func_key_legs          = create_command("laminar/B747/fms2/func_key/legs", "FMS2 Function Key LEGS", B747_fms2_func_key_legs_CMDhandler)
B747CMD_fms2_func_key_dep_arr       = create_command("laminar/B747/fms2/func_key/dep_arr", "FMS2 Function Key DEP/ARR", B747_fms2_func_key_dep_arr_CMDhandler)
B747CMD_fms2_func_key_hold          = create_command("laminar/B747/fms2/func_key/hold", "FMS2 Function Key HOLD", B747_fms2_func_key_hold_CMDhandler)
B747CMD_fms2_func_key_prog          = create_command("laminar/B747/fms2/func_key/prog", "FMS2 Function Key PROG", B747_fms2_func_key_prog_CMDhandler)
B747CMD_fms2_key_execute            = create_command("laminar/B747/fms2/key/execute", "FMS2 KEY EXEC", B747_fms2_key_execute_CMDhandler)
B747CMD_fms2_func_key_fix           = create_command("laminar/B747/fms2/func_key/fix", "FMS2 Function Key FIX", B747_fms2_func_key_fix_CMDhandler)
B747CMD_fms2_func_key_prev_pg       = create_command("laminar/B747/fms2/func_key/prev_pg", "FMS2 Function Key PREV PAGE", B747_fms2_func_key_prev_pg_CMDhandler)
B747CMD_fms2_func_key_next_pg       = create_command("laminar/B747/fms2/func_key/next_pg", "FMS2 Function Key NEXT PAGE", B747_fms2_func_key_next_pg_CMDhandler)


-- ALPHA-NUMERIC KEYS -------------------------------------------------------------------
B747CMD_fms2_alphanum_key_0         = create_command("laminar/B747/fms2/alphanum_key/0", "FMS2 Alpha/Numeric Key 0", B747_fms2_alphanum_key_0_CMDhandler)
B747CMD_fms2_alphanum_key_1         = create_command("laminar/B747/fms2/alphanum_key/1", "FMS2 Alpha/Numeric Key 1", B747_fms2_alphanum_key_1_CMDhandler)
B747CMD_fms2_alphanum_key_2         = create_command("laminar/B747/fms2/alphanum_key/2", "FMS2 Alpha/Numeric Key 2", B747_fms2_alphanum_key_2_CMDhandler)
B747CMD_fms2_alphanum_key_3         = create_command("laminar/B747/fms2/alphanum_key/3", "FMS2 Alpha/Numeric Key 3", B747_fms2_alphanum_key_3_CMDhandler)
B747CMD_fms2_alphanum_key_4         = create_command("laminar/B747/fms2/alphanum_key/4", "FMS2 Alpha/Numeric Key 4", B747_fms2_alphanum_key_4_CMDhandler)
B747CMD_fms2_alphanum_key_5         = create_command("laminar/B747/fms2/alphanum_key/5", "FMS2 Alpha/Numeric Key 5", B747_fms2_alphanum_key_5_CMDhandler)
B747CMD_fms2_alphanum_key_6         = create_command("laminar/B747/fms2/alphanum_key/6", "FMS2 Alpha/Numeric Key 6", B747_fms2_alphanum_key_6_CMDhandler)
B747CMD_fms2_alphanum_key_7         = create_command("laminar/B747/fms2/alphanum_key/7", "FMS2 Alpha/Numeric Key 7", B747_fms2_alphanum_key_7_CMDhandler)
B747CMD_fms2_alphanum_key_8         = create_command("laminar/B747/fms2/alphanum_key/8", "FMS2 Alpha/Numeric Key 8", B747_fms2_alphanum_key_8_CMDhandler)
B747CMD_fms2_alphanum_key_9         = create_command("laminar/B747/fms2/alphanum_key/9", "FMS2 Alpha/Numeric Key 9", B747_fms2_alphanum_key_9_CMDhandler)

B747CMD_fms2_key_period             = create_command("laminar/B747/fms2/key/period", "FMS2 Key '.'", B747_fms2_key_period_CMDhandler)
B747CMD_fms2_key_minus              = create_command("laminar/B747/fms2/key/minus", "FMS2 Key '+/-'", B747_fms2_key_minus_CMDhandler)

B747CMD_fms2_alphanum_key_A         = create_command("laminar/B747/fms2/alphanum_key/A", "FMS2 Alpha/Numeric Key A", B747_fms2_alphanum_key_A_CMDhandler)
B747CMD_fms2_alphanum_key_B         = create_command("laminar/B747/fms2/alphanum_key/B", "FMS2 Alpha/Numeric Key B", B747_fms2_alphanum_key_B_CMDhandler)
B747CMD_fms2_alphanum_key_C         = create_command("laminar/B747/fms2/alphanum_key/C", "FMS2 Alpha/Numeric Key C", B747_fms2_alphanum_key_C_CMDhandler)
B747CMD_fms2_alphanum_key_D         = create_command("laminar/B747/fms2/alphanum_key/D", "FMS2 Alpha/Numeric Key D", B747_fms2_alphanum_key_D_CMDhandler)
B747CMD_fms2_alphanum_key_E         = create_command("laminar/B747/fms2/alphanum_key/E", "FMS2 Alpha/Numeric Key E", B747_fms2_alphanum_key_E_CMDhandler)
B747CMD_fms2_alphanum_key_F         = create_command("laminar/B747/fms2/alphanum_key/F", "FMS2 Alpha/Numeric Key F", B747_fms2_alphanum_key_F_CMDhandler)
B747CMD_fms2_alphanum_key_G         = create_command("laminar/B747/fms2/alphanum_key/G", "FMS2 Alpha/Numeric Key G", B747_fms2_alphanum_key_G_CMDhandler)
B747CMD_fms2_alphanum_key_H         = create_command("laminar/B747/fms2/alphanum_key/H", "FMS2 Alpha/Numeric Key H", B747_fms2_alphanum_key_H_CMDhandler)
B747CMD_fms2_alphanum_key_I         = create_command("laminar/B747/fms2/alphanum_key/I", "FMS2 Alpha/Numeric Key I", B747_fms2_alphanum_key_I_CMDhandler)
B747CMD_fms2_alphanum_key_J         = create_command("laminar/B747/fms2/alphanum_key/J", "FMS2 Alpha/Numeric Key J", B747_fms2_alphanum_key_J_CMDhandler)
B747CMD_fms2_alphanum_key_K         = create_command("laminar/B747/fms2/alphanum_key/K", "FMS2 Alpha/Numeric Key K", B747_fms2_alphanum_key_K_CMDhandler)
B747CMD_fms2_alphanum_key_L         = create_command("laminar/B747/fms2/alphanum_key/L", "FMS2 Alpha/Numeric Key L", B747_fms2_alphanum_key_L_CMDhandler)
B747CMD_fms2_alphanum_key_M         = create_command("laminar/B747/fms2/alphanum_key/M", "FMS2 Alpha/Numeric Key M", B747_fms2_alphanum_key_M_CMDhandler)
B747CMD_fms2_alphanum_key_N         = create_command("laminar/B747/fms2/alphanum_key/N", "FMS2 Alpha/Numeric Key N", B747_fms2_alphanum_key_N_CMDhandler)
B747CMD_fms2_alphanum_key_O         = create_command("laminar/B747/fms2/alphanum_key/O", "FMS2 Alpha/Numeric Key O", B747_fms2_alphanum_key_O_CMDhandler)
B747CMD_fms2_alphanum_key_P         = create_command("laminar/B747/fms2/alphanum_key/P", "FMS2 Alpha/Numeric Key P", B747_fms2_alphanum_key_P_CMDhandler)
B747CMD_fms2_alphanum_key_Q         = create_command("laminar/B747/fms2/alphanum_key/Q", "FMS2 Alpha/Numeric Key Q", B747_fms2_alphanum_key_Q_CMDhandler)
B747CMD_fms2_alphanum_key_R         = create_command("laminar/B747/fms2/alphanum_key/R", "FMS2 Alpha/Numeric Key R", B747_fms2_alphanum_key_R_CMDhandler)
B747CMD_fms2_alphanum_key_S         = create_command("laminar/B747/fms2/alphanum_key/S", "FMS2 Alpha/Numeric Key S", B747_fms2_alphanum_key_S_CMDhandler)
B747CMD_fms2_alphanum_key_T         = create_command("laminar/B747/fms2/alphanum_key/T", "FMS2 Alpha/Numeric Key T", B747_fms2_alphanum_key_T_CMDhandler)
B747CMD_fms2_alphanum_key_U         = create_command("laminar/B747/fms2/alphanum_key/U", "FMS2 Alpha/Numeric Key U", B747_fms2_alphanum_key_U_CMDhandler)
B747CMD_fms2_alphanum_key_V         = create_command("laminar/B747/fms2/alphanum_key/V", "FMS2 Alpha/Numeric Key V", B747_fms2_alphanum_key_V_CMDhandler)
B747CMD_fms2_alphanum_key_W         = create_command("laminar/B747/fms2/alphanum_key/W", "FMS2 Alpha/Numeric Key W", B747_fms2_alphanum_key_W_CMDhandler)
B747CMD_fms2_alphanum_key_X         = create_command("laminar/B747/fms2/alphanum_key/X", "FMS2 Alpha/Numeric Key X", B747_fms2_alphanum_key_X_CMDhandler)
B747CMD_fms2_alphanum_key_Y         = create_command("laminar/B747/fms2/alphanum_key/Y", "FMS2 Alpha/Numeric Key Y", B747_fms2_alphanum_key_Y_CMDhandler)
B747CMD_fms2_alphanum_key_Z         = create_command("laminar/B747/fms2/alphanum_key/Z", "FMS2 Alpha/Numeric Key Z", B747_fms2_alphanum_key_Z_CMDhandler)

B747CMD_fms2_key_space              = create_command("laminar/B747/fms2/key/space", "FMS2 KEY SP", B747_fms2_key_space_CMDhandler)
B747CMD_fms2_key_del                = create_command("laminar/B747/fms2/key/del", "FMS2 KEY DEL", B747_fms2_key_del_CMDhandler)
B747CMD_fms2_key_slash              = create_command("laminar/B747/fms2/key/slash", "FMS2 Key '/'", B747_fms2_key_slash_CMDhandler)
B747CMD_fms2_key_clear              = create_command("laminar/B747/fms2/key/clear", "FMS2 KEY CLR", B747_fms2_key_clear_CMDhandler)


-- RADIO MANIPS -------------------------------------------------------------------------
B747CMD_fms2_vorL_freq_coarse_up    = create_command("laminar/B747/fms2/radio/vorL_freq_coarse_up", "FMS2 Radio VOR L Frequency Coarse Up", B747_fms2_vorL_freq_coarse_up_CMDhandler)
B747CMD_fms2_vorL_freq_coarse_dn    = create_command("laminar/B747/fms2/radio/vorL_freq_coarse_dn", "FMS2 Radio VOR L Frequency Coarse Down", B747_fms2_vorL_freq_coarse_dn_CMDhandler)
B747CMD_fms2_vorL_freq_fine_up      = create_command("laminar/B747/fms2/radio/vorL_freq_fine_up", "FMS2 Radio VOR L Frequency Fine Up", B747_fms2_vorL_freq_fine_up_CMDhandler)
B747CMD_fms2_vorL_freq_fine_dn      = create_command("laminar/B747/fms2/radio/vorL_freq_fine_dn", "FMS2 Radio VOR L Frequency Fine Down", B747_fms2_vorL_freq_fine_dn_CMDhandler)

B747CMD_fms2_vorL_course_up         = create_command("laminar/B747/fms2/radio/vorL_course_up", "FMS2 Radio VOR L Course Up", B747_fms2_vorL_course_up_CMDhandler)
B747CMD_fms2_vorL_course_dn         = create_command("laminar/B747/fms2/radio/vorL_course_dn", "FMS2 Radio VOR L Course Down", B747_fms2_vorL_course_dn_CMDhandler)


B747CMD_fms2_vorR_freq_coarse_up    = create_command("laminar/B747/fms2/radio/vorR_freq_ccoarse_up", "FMS2 Radio VOR R Frequency Coarse Up", B747_fms2_vorR_freq_coarse_up_CMDhandler)
B747CMD_fms2_vorR_freq_coarse_dn    = create_command("laminar/B747/fms2/radio/vorR_freq_coarse_dn", "FMS2 Radio VOR R Frequency Coarse Down", B747_fms2_vorR_freq_coarse_dn_CMDhandler)
B747CMD_fms2_vorR_freq_fine_up      = create_command("laminar/B747/fms2/radio/vorR_freq_fine_up", "FMS2 Radio VOR R Frequency Fine Up", B747_fms2_vorR_freq_fine_up_CMDhandler)
B747CMD_fms2_vorR_freq_fine_dn      = create_command("laminar/B747/fms2/radio/vorR_freq_fine_dn", "FMS2 Radio VOR R Frequency Fine Down", B747_fms2_vorR_freq_fine_dn_CMDhandler)

B747CMD_fms2_vorR_course_up         = create_command("laminar/B747/fms2/radio/vorR_course_up", "FMS2 Radio VOR R Course Up", B747_fms2_vorR_course_up_CMDhandler)
B747CMD_fms2_vorR_course_dn         = create_command("laminar/B747/fms2/radio/vorR_course_dn", "FMS2 Radio VOR R Course Down", B747_fms2_vorR_course_dn_CMDhandler)


B747CMD_fms2_ils_course_up          = create_command("laminar/B747/fms2/radio/ils_course_up", "FMS2 Radio ILS Course Up", B747_fms2_ils_course_up_CMDhandler)
B747CMD_fms2_ils_course_dn          = create_command("laminar/B747/fms2/radio/ils_course_dn", "FMS2 Radio ILS Course Down", B747_fms2_ils_course_dn_CMDhandler)


-- AI
B747CMD_ai_fmsR_quick_start			= create_command("laminar/B747/ai/fmsR_quick_start", "number", B747_ai_fmsR_quick_start_CMDhandler)





--*************************************************************************************--
--** 				             REPLACE X-PLANE COMMANDS                  	    	 **--
--*************************************************************************************--

B747CMD_fms2_func_key_nav_rad       = replace_command("sim/FMS2/navrad", B747_fms2_func_key_nav_rad_CMDhandler)




--*************************************************************************************--
--** 				               WRAP X-PLANE COMMANDS                  	    	 **--
--*************************************************************************************--

simCMDwrap_fms2_func_key_index          = wrap_command("sim/FMS2/index", sim_fms2_func_key_beforeCMDhandler, sim_fms2_func_key_afterCMDhandler)
simCMDwrap_fms2_func_key_fpln           = wrap_command("sim/FMS2/fpln", sim_fms2_func_key_beforeCMDhandler, sim_fms2_func_key_afterCMDhandler)
simCMDwrap_fms2_func_key_clb            = wrap_command("sim/FMS2/clb", sim_fms2_func_key_beforeCMDhandler, sim_fms2_func_key_afterCMDhandler)
simCMDwrap_fms2_func_key_crz            = wrap_command("sim/FMS2/crz", sim_fms2_func_key_beforeCMDhandler, sim_fms2_func_key_afterCMDhandler)
simCMDwrap_fms2_func_key_des            = wrap_command("sim/FMS2/des", sim_fms2_func_key_beforeCMDhandler, sim_fms2_func_key_afterCMDhandler)
simCMDwrap_fms2_func_key_dir_intc       = wrap_command("sim/FMS2/dir_intc", sim_fms2_func_key_beforeCMDhandler, sim_fms2_func_key_afterCMDhandler)
simCMDwrap_fms2_func_key_legs           = wrap_command("sim/FMS2/legs", sim_fms2_func_key_beforeCMDhandler, sim_fms2_func_key_afterCMDhandler)
simCMDwrap_fms2_func_key_dep_arr        = wrap_command("sim/FMS2/dep_arr", sim_fms2_func_key_beforeCMDhandler, sim_fms2_func_key_afterCMDhandler)
simCMDwrap_fms2_func_key_hold           = wrap_command("sim/FMS2/hold", sim_fms2_func_key_beforeCMDhandler, sim_fms2_func_key_afterCMDhandler)
simCMDwrap_fms2_func_key_prog           = wrap_command("sim/FMS2/prog", sim_fms2_func_key_beforeCMDhandler, sim_fms2_func_key_afterCMDhandler)
simCMDwrap_fms2_key_execute             = wrap_command("sim/FMS2/exec", sim_fms2_func_key_beforeCMDhandler, sim_fms2_func_key_afterCMDhandler)
simCMDwrap_fms2_func_key_fix            = wrap_command("sim/FMS2/fix", sim_fms2_func_key_beforeCMDhandler, sim_fms2_func_key_afterCMDhandler)
simCMDwrap_fms2_func_key_prev_pg        = wrap_command("sim/FMS2/prev", sim_fms2_func_key_beforeCMDhandler, sim_fms2_func_key_afterCMDhandler)
simCMDwrap_fms2_func_key_next_pg        = wrap_command("sim/FMS2/next", sim_fms2_func_key_beforeCMDhandler, sim_fms2_func_key_afterCMDhandler)





--*************************************************************************************--
--** 					           OBJECT CONSTRUCTORS         		        		 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				                  CREATE OBJECTS                 				 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				                 SYSTEM FUNCTIONS           	    			 **--
--*************************************************************************************--

function B747_set_FMS2_display_mode_norm()
    B747DR_fms2_display_mode = 0
end




function B747_fms2_display_navrad()

        B747DR_fms2_Line01_L = string.format("        %9s      ", "NAV RADIO")
        B747DR_fms2_Line02_L = string.format("                        ", "")
        B747DR_fms2_Line03_L = string.format("%6.2f %4s  %4s %6.2f", simDR_radio_nav_freq_hz[2]*0.01, simDR_radio_nav03_ID, simDR_radio_nav04_ID, simDR_radio_nav_freq_hz[3]*0.01)
        B747DR_fms2_Line04_L = string.format("                        ", "")
        B747DR_fms2_Line05_L = string.format(" %03d     %3s  %3s    %03d", simDR_radio_nav_obs_deg[2], "---", "---", simDR_radio_nav_obs_deg[3])
        B747DR_fms2_Line06_L = string.format("                        ", "")
        B747DR_fms2_Line07_L = string.format("%06.1f         %06.1f   ", simDR_radio_adf1_freq_hz, simDR_radio_adf2_freq_hz)
        B747DR_fms2_Line08_L = string.format("                        ", "")
        B747DR_fms2_Line09_L = string.format("%6.2f/%03d%s             ", simDR_radio_nav_freq_hz[1]*0.01, simDR_radio_nav_obs_deg[1], "˚")
        B747DR_fms2_Line10_L = string.format("                        ", "")
        B747DR_fms2_Line11_L = string.format("                        ", "")
        B747DR_fms2_Line12_L = string.format("                        ", "")
        B747DR_fms2_Line13_L = string.format("                        ", "")
        B747DR_fms2_Line14_L = string.format("%s            %s", "------", "------")

        B747DR_fms2_Line01_S = string.format("                        ", "")
        B747DR_fms2_Line02_S = string.format(" %5s             %5s", "VOR L", "VOR R")
        B747DR_fms2_Line03_S = string.format("      %1s          %1s      ", "M", "M")
        B747DR_fms2_Line04_S = string.format(" %3s      %6s     %3s", "CRS", "RADIAL", "CRS")
        B747DR_fms2_Line05_S = string.format("                        ", "")
        B747DR_fms2_Line06_S = string.format(" %5s             %5s", "ADF L", "ADF R")
        B747DR_fms2_Line07_S = string.format("      %3s            %3s", "ANT", "ANT")
        B747DR_fms2_Line08_S = string.format(" %3s                    ", "ILS")
        B747DR_fms2_Line09_S = string.format("           %1s            ", "M")
        B747DR_fms2_Line10_S = string.format("                        ", "")
        B747DR_fms2_Line11_S = string.format("                        ", "")
        B747DR_fms2_Line12_S = string.format("                        ", "")
        B747DR_fms2_Line13_S = string.format("        %9s       ", "PRESELECT")
        B747DR_fms2_Line14_S = string.format("                        ", "")

end







----- MONITOR AI FOR AUTO-BOARD CALL ----------------------------------------------------
function B747_fmsR_monitor_AI()

    if B747DR_init_fmsR_CD == 1 then
        B747_set_fmsR_all_modes()
        B747_set_fmsR_CD()
        B747DR_init_fmsR_CD = 2
    end

end





----- SET STATE FOR ALL MODES -----------------------------------------------------------
function B747_set_fmsR_all_modes()

	B747DR_init_fmsR_CD = 0
    B747DR_fms2_display_brightness = simDR_instrument_brightness_switch[13]

end





----- SET STATE TO COLD & DARK ----------------------------------------------------------
function B747_set_fmsR_CD()



end





----- SET STATE TO ENGINES RUNNING ------------------------------------------------------
function B747_set_fmsR_ER()
	

	
end











----- FLIGHT START ----------------------------------------------------------------------
function B747_flight_start_fms2()

    -- ALL MODES ------------------------------------------------------------------------
    B747_set_fmsR_all_modes()



    -- COLD & DARK ----------------------------------------------------------------------
    if simDR_startup_running == 0 then

        B747_set_fmsR_CD()


    -- ENGINES RUNNING ------------------------------------------------------------------
    elseif simDR_startup_running == 1 then

		B747_set_fmsR_ER()

    end

end




--*************************************************************************************--
--** 				                 EVENT CALLBACKS           	        			 **--
--*************************************************************************************--

--function aircraft_load() end

--function aircraft_unload() end

function flight_start()

    B747_flight_start_fms2()

end

--function flight_crash() end

--function before_physics() end

function after_physics()

    B747_fms2_display_navrad()

    B747_fmsR_monitor_AI()

end

--function after_replay() end



--*************************************************************************************--
--** 				               SUB-MODULE PROCESSING       	        			 **--
--*************************************************************************************--

-- dofile("")
