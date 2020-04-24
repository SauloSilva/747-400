--[[
*****************************************************************************************
* Program Script Name	:	B747.68.fmsL

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
simDR_instrument_brightness_ratio   = find_dataref("sim/cockpit2/electrical/instrument_brightness_ratio_manual")

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

simCMD_FMS_ls_1L            = find_command("sim/FMS/ls_1l")
simCMD_FMS_ls_2L            = find_command("sim/FMS/ls_2l")
simCMD_FMS_ls_3L            = find_command("sim/FMS/ls_3l")
simCMD_FMS_ls_4L            = find_command("sim/FMS/ls_4l")
simCMD_FMS_ls_5L            = find_command("sim/FMS/ls_5l")
simCMD_FMS_ls_6L            = find_command("sim/FMS/ls_6l")

simCMD_FMS_ls_1R            = find_command("sim/FMS/ls_1r")
simCMD_FMS_ls_2R            = find_command("sim/FMS/ls_2r")
simCMD_FMS_ls_3R            = find_command("sim/FMS/ls_3r")
simCMD_FMS_ls_4R            = find_command("sim/FMS/ls_4r")
simCMD_FMS_ls_5R            = find_command("sim/FMS/ls_5r")
simCMD_FMS_ls_6R            = find_command("sim/FMS/ls_6r")

simCMD_FMS_key_index        = find_command("sim/FMS/index")
simCMD_FMS_key_fpln         = find_command("sim/FMS/fpln")
simCMD_FMS_key_clb          = find_command("sim/FMS/clb")
simCMD_FMS_key_crz          = find_command("sim/FMS/crz")
simCMD_FMS_key_des          = find_command("sim/FMS/des")

simCMD_FMS_key_dir_intc     = find_command("sim/FMS/dir_intc")
simCMD_FMS_key_legs         = find_command("sim/FMS/legs")
simCMD_FMS_key_dep_arr      = find_command("sim/FMS/dep_arr")
simCMD_FMS_key_hold         = find_command("sim/FMS/hold")
simCMD_FMS_key_prog         = find_command("sim/FMS/prog")
simCMD_FMS_key_exec         = find_command("sim/FMS/exec")

simCMD_FMS_key_fix          = find_command("sim/FMS/fix")

simCMD_FMS_prev             = find_command("sim/FMS/prev")
simCMD_FMS_next             = find_command("sim/FMS/next")

simCMD_FMS_key_0            = find_command("sim/FMS/key_0")
simCMD_FMS_key_1            = find_command("sim/FMS/key_1")
simCMD_FMS_key_2            = find_command("sim/FMS/key_2")
simCMD_FMS_key_3            = find_command("sim/FMS/key_3")
simCMD_FMS_key_4            = find_command("sim/FMS/key_4")
simCMD_FMS_key_5            = find_command("sim/FMS/key_5")
simCMD_FMS_key_6            = find_command("sim/FMS/key_6")
simCMD_FMS_key_7            = find_command("sim/FMS/key_7")
simCMD_FMS_key_8            = find_command("sim/FMS/key_8")
simCMD_FMS_key_9            = find_command("sim/FMS/key_9")

simCMD_FMS_key_period       = find_command("sim/FMS/key_period")
simCMD_FMS_key_minus        = find_command("sim/FMS/key_minus")

simCMD_FMS_key_A            = find_command("sim/FMS/key_A")
simCMD_FMS_key_B            = find_command("sim/FMS/key_B")
simCMD_FMS_key_C            = find_command("sim/FMS/key_C")
simCMD_FMS_key_D            = find_command("sim/FMS/key_D")
simCMD_FMS_key_E            = find_command("sim/FMS/key_E")
simCMD_FMS_key_F            = find_command("sim/FMS/key_F")
simCMD_FMS_key_G            = find_command("sim/FMS/key_G")
simCMD_FMS_key_H            = find_command("sim/FMS/key_H")
simCMD_FMS_key_I            = find_command("sim/FMS/key_I")
simCMD_FMS_key_J            = find_command("sim/FMS/key_J")
simCMD_FMS_key_K            = find_command("sim/FMS/key_K")
simCMD_FMS_key_L            = find_command("sim/FMS/key_L")
simCMD_FMS_key_M            = find_command("sim/FMS/key_M")
simCMD_FMS_key_N            = find_command("sim/FMS/key_N")
simCMD_FMS_key_O            = find_command("sim/FMS/key_O")
simCMD_FMS_key_P            = find_command("sim/FMS/key_P")
simCMD_FMS_key_Q            = find_command("sim/FMS/key_Q")
simCMD_FMS_key_R            = find_command("sim/FMS/key_R")
simCMD_FMS_key_S            = find_command("sim/FMS/key_S")
simCMD_FMS_key_T            = find_command("sim/FMS/key_T")
simCMD_FMS_key_U            = find_command("sim/FMS/key_U")
simCMD_FMS_key_V            = find_command("sim/FMS/key_V")
simCMD_FMS_key_W            = find_command("sim/FMS/key_W")
simCMD_FMS_key_X            = find_command("sim/FMS/key_X")
simCMD_FMS_key_Y            = find_command("sim/FMS/key_Y")
simCMD_FMS_key_Z            = find_command("sim/FMS/key_Z")

simCMD_FMS_key_space        = find_command("sim/FMS/key_space")
simCMD_FMS_key_delete       = find_command("sim/FMS/key_delete")
simCMD_FMS_key_slash        = find_command("sim/FMS/key_slash")
simCMD_FMS_key_clear        = find_command("sim/FMS/key_clear")



--*************************************************************************************--
--** 				              FIND CUSTOM COMMANDS              			     **--
--*************************************************************************************--



--*************************************************************************************--
--** 				       READ-WRITE CUSTOM DATAREF HANDLERS     	        	     **--
--*************************************************************************************--

function B747_fms1_display_brightness_DRhandler()
    simDR_instrument_brightness_switch[12] = B747DR_fms1_display_brightness
end




--*************************************************************************************--
--** 				             X-PLANE COMMAND HANDLERS               	    	 **--
--*************************************************************************************--

function sim_fms1_func_key_beforeCMDhandler(phase, duration)
    if phase == 0 then B747_set_FMS1_display_mode_norm() end
end
function sim_fms1_func_key_afterCMDhandler(phase, duration) end




--*************************************************************************************--
--** 				             CUSTOM COMMAND HANDLERS            			     **--
--*************************************************************************************--

-- LINE SELECT KEYS ---------------------------------------------------------------------
function B747_fms1_ls_key_L1_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_1L:once() end
end
function B747_fms1_ls_key_L2_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_2L:once() end
end
function B747_fms1_ls_key_L3_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_3L:once() end
end
function B747_fms1_ls_key_L4_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_4L:once() end
end
function B747_fms1_ls_key_L5_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_5L:once() end
end
function B747_fms1_ls_key_L6_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_6L:once() end
end
function B747_fms1_ls_key_R1_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_1R:once() end
end
function B747_fms1_ls_key_R2_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_2R:once() end
end
function B747_fms1_ls_key_R3_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_3R:once() end
end
function B747_fms1_ls_key_R4_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_4R:once() end
end
function B747_fms1_ls_key_R5_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_5R:once() end
end
function B747_fms1_ls_key_R6_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_6R:once() end
end


-- FUNCTION KEYS ------------------------------------------------------------------------
function B747_fms1_func_key_index_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_index:once() end
end
function B747_fms1_func_key_fpln_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_fpln:once() end
end
function B747_fms1_func_key_clb_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_clb:once() end
end
function B747_fms1_func_key_crz_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_crz:once() end
end
function B747_fms1_func_key_des_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_des:once() end
end
function B747_fms1_func_key_dir_intc_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_dir_intc:once() end
end
function B747_fms1_func_key_legs_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_legs:once() end
end
function B747_fms1_func_key_dep_arr_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_dep_arr:once() end
end
function B747_fms1_func_key_hold_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_hold:once() end
end
function B747_fms1_func_key_prog_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_prog:once() end
end
function B747_fms1_key_execute_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_exec:once() end
end
function B747_fms1_func_key_fix_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_fix:once() end
end
function B747_fms1_func_key_nav_rad_CMDhandler(phase, duration)
    if phase == 0 then B747DR_fms1_display_mode = 1.0 end
end
function B747_fms1_func_key_prev_pg_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_prev:once() end
end
function B747_fms1_func_key_next_pg_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_next:once() end
end


-- ALPHA-NUMERIC KEYS -------------------------------------------------------------------
function B747_fms1_alphanum_key_A_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_A:once() end
end
function B747_fms1_alphanum_key_B_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_B:once() end
end
function B747_fms1_alphanum_key_C_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_C:once() end
end
function B747_fms1_alphanum_key_D_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_D:once() end
end
function B747_fms1_alphanum_key_E_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_E:once() end
end
function B747_fms1_alphanum_key_F_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_F:once() end
end
function B747_fms1_alphanum_key_G_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_G:once() end
end
function B747_fms1_alphanum_key_H_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_H:once() end
end
function B747_fms1_alphanum_key_I_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_I:once() end
end
function B747_fms1_alphanum_key_J_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_J:once() end
end
function B747_fms1_alphanum_key_K_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_K:once() end
end
function B747_fms1_alphanum_key_L_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_L:once() end
end
function B747_fms1_alphanum_key_M_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_M:once() end
end
function B747_fms1_alphanum_key_N_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_N:once() end
end
function B747_fms1_alphanum_key_O_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_O:once() end
end
function B747_fms1_alphanum_key_P_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_P:once() end
end
function B747_fms1_alphanum_key_Q_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_Q:once() end
end
function B747_fms1_alphanum_key_R_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_R:once() end
end
function B747_fms1_alphanum_key_S_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_S:once() end
end
function B747_fms1_alphanum_key_T_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_T:once() end
end
function B747_fms1_alphanum_key_U_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_U:once() end
end
function B747_fms1_alphanum_key_V_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_V:once() end
end
function B747_fms1_alphanum_key_W_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_W:once() end
end
function B747_fms1_alphanum_key_X_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_X:once() end
end
function B747_fms1_alphanum_key_Y_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_Y:once() end
end
function B747_fms1_alphanum_key_Z_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_Z:once() end
end

function B747_fms1_alphanum_key_0_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_0:once() end
end
function B747_fms1_alphanum_key_1_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_1:once() end
end
function B747_fms1_alphanum_key_2_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_2:once() end
end
function B747_fms1_alphanum_key_3_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_3:once() end
end
function B747_fms1_alphanum_key_4_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_4:once() end
end
function B747_fms1_alphanum_key_5_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_5:once() end
end
function B747_fms1_alphanum_key_6_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_6:once() end
end
function B747_fms1_alphanum_key_7_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_7:once() end
end
function B747_fms1_alphanum_key_8_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_8:once() end
end
function B747_fms1_alphanum_key_9_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_9:once() end
end


-- MISC KEYS ----------------------------------------------------------------------------
function B747_fms1_key_period_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_period:once() end
end
function B747_fms1_key_minus_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_minus:once() end
end
function B747_fms1_key_space_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_space:once() end
end
function B747_fms1_key_del_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_delete:once() end
end
function B747_fms1_key_slash_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_slash:once() end
end
function B747_fms1_key_clear_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_clear:once() end
end







----- RADIO MANIPS ----------------------------------------------------------------------
-- VOR: 108.00-117.95
function B747_fms1_vorL_freq_coarse_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_Mhz[2] == 117 then
            simDR_radio_nav_freq_Mhz[2] = 108
        else
            simDR_radio_nav_freq_Mhz[2] = simDR_radio_nav_freq_Mhz[2] + 1
        end
    end
end
function B747_fms1_vorL_freq_coarse_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_Mhz[2] == 108 then
            simDR_radio_nav_freq_Mhz[2] = 117
        else
            simDR_radio_nav_freq_Mhz[2] = simDR_radio_nav_freq_Mhz[2] - 1
        end
    end
end
function B747_fms1_vorL_freq_fine_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_khz[2] == 95 then
            simDR_radio_nav_freq_khz[2] = 0
        else
            simDR_radio_nav_freq_khz[2] = simDR_radio_nav_freq_khz[2] + 5
        end
    end
end
function B747_fms1_vorL_freq_fine_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_khz[2] == 0 then
            simDR_radio_nav_freq_khz[2] = 95
        else
            simDR_radio_nav_freq_khz[2] = simDR_radio_nav_freq_khz[2] - 5
        end
    end
end

function B747_fms1_vorL_course_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_obs_deg[2] >= 359.0 then
            simDR_radio_nav_obs_deg[2] = 0.0
        else
            simDR_radio_nav_obs_deg[2] = simDR_radio_nav_obs_deg[2] + 1
        end
    end
end
function B747_fms1_vorL_course_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_obs_deg[2] <= 0.0 then
            simDR_radio_nav_obs_deg[2] = 359.0
        else
            simDR_radio_nav_obs_deg[2] = simDR_radio_nav_obs_deg[2] - 1
        end
    end
end





function B747_fms1_vorR_freq_coarse_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_Mhz[3] == 117 then
            simDR_radio_nav_freq_Mhz[3] = 108
        else
            simDR_radio_nav_freq_Mhz[3] = simDR_radio_nav_freq_Mhz[3] + 1
        end
    end
end
function B747_fms1_vorR_freq_coarse_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_Mhz[3] == 108 then
            simDR_radio_nav_freq_Mhz[3] = 117
        else
            simDR_radio_nav_freq_Mhz[3] = simDR_radio_nav_freq_Mhz[3] - 1
        end
    end
end
function B747_fms1_vorR_freq_fine_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_khz[3] == 95 then
            simDR_radio_nav_freq_khz[3] = 0
        else
            simDR_radio_nav_freq_khz[3] = simDR_radio_nav_freq_khz[3] + 5
        end
    end
end
function B747_fms1_vorR_freq_fine_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_khz[3] == 0 then
            simDR_radio_nav_freq_khz[3] = 95
        else
            simDR_radio_nav_freq_khz[3] = simDR_radio_nav_freq_khz[3] - 5
        end
    end
end

function B747_fms1_vorR_course_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_obs_deg[3] >= 359.0 then
            simDR_radio_nav_obs_deg[3] = 0.0
        else
            simDR_radio_nav_obs_deg[3] = simDR_radio_nav_obs_deg[3] + 1
        end
    end
end
function B747_fms1_vorR_course_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_obs_deg[3] <= 0.0 then
            simDR_radio_nav_obs_deg[3] = 359.0
        else
            simDR_radio_nav_obs_deg[3] = simDR_radio_nav_obs_deg[3] - 1
        end
    end
end




function B747_fms1_ils_course_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_obs_deg[0] >= 359.0 then
            simDR_radio_nav_obs_deg[0] = 0.0
        else
            simDR_radio_nav_obs_deg[0] = simDR_radio_nav_obs_deg[0] + 1
        end
    end
end
function B747_fms1_ils_course_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_obs_deg[0] <= 0.0 then
            simDR_radio_nav_obs_deg[0] = 359.0
        else
            simDR_radio_nav_obs_deg[0] = simDR_radio_nav_obs_deg[0] - 1
        end
    end
end




function B747_ai_fmsL_quick_start_CMDhandler(phase, duration)
    if phase == 0 then
		B747_set_fmsL_all_modes()
		B747_set_fmsL_CD()
		B747_set_fmsL_ER()	
    end	
end	





--*************************************************************************************--
--** 				        CREATE READ-ONLY CUSTOM DATAREFS               	         **--
--*************************************************************************************--

B747DR_fms1_display_mode            = find_dataref("laminar/B747/fms1/display_mode")
--[[
    0 = NORMAL
    1 = NAV RAD
--]]


B747DR_fms1_Line01_L                = find_dataref("laminar/B747/fms1/Line01_L")
B747DR_fms1_Line02_L                = find_dataref("laminar/B747/fms1/Line02_L")
B747DR_fms1_Line03_L                = find_dataref("laminar/B747/fms1/Line03_L")
B747DR_fms1_Line04_L                = find_dataref("laminar/B747/fms1/Line04_L")
B747DR_fms1_Line05_L                = find_dataref("laminar/B747/fms1/Line05_L")
B747DR_fms1_Line06_L                = find_dataref("laminar/B747/fms1/Line06_L")
B747DR_fms1_Line07_L                = find_dataref("laminar/B747/fms1/Line07_L")
B747DR_fms1_Line08_L                = find_dataref("laminar/B747/fms1/Line08_L")
B747DR_fms1_Line09_L                = find_dataref("laminar/B747/fms1/Line09_L")
B747DR_fms1_Line10_L                = find_dataref("laminar/B747/fms1/Line10_L")
B747DR_fms1_Line11_L                = find_dataref("laminar/B747/fms1/Line11_L")
B747DR_fms1_Line12_L                = find_dataref("laminar/B747/fms1/Line12_L")
B747DR_fms1_Line13_L                = find_dataref("laminar/B747/fms1/Line13_L")
B747DR_fms1_Line14_L                = find_dataref("laminar/B747/fms1/Line14_L")

B747DR_fms1_Line01_S                = find_dataref("laminar/B747/fms1/Line01_S")
B747DR_fms1_Line02_S                = find_dataref("laminar/B747/fms1/Line02_S")
B747DR_fms1_Line03_S                = find_dataref("laminar/B747/fms1/Line03_S")
B747DR_fms1_Line04_S                = find_dataref("laminar/B747/fms1/Line04_S")
B747DR_fms1_Line05_S                = find_dataref("laminar/B747/fms1/Line05_S")
B747DR_fms1_Line06_S                = find_dataref("laminar/B747/fms1/Line06_S")
B747DR_fms1_Line07_S                = find_dataref("laminar/B747/fms1/Line07_S")
B747DR_fms1_Line08_S                = find_dataref("laminar/B747/fms1/Line08_S")
B747DR_fms1_Line09_S                = find_dataref("laminar/B747/fms1/Line09_S")
B747DR_fms1_Line10_S                = find_dataref("laminar/B747/fms1/Line10_S")
B747DR_fms1_Line11_S                = find_dataref("laminar/B747/fms1/Line11_S")
B747DR_fms1_Line12_S                = find_dataref("laminar/B747/fms1/Line12_S")
B747DR_fms1_Line13_S                = find_dataref("laminar/B747/fms1/Line13_S")
B747DR_fms1_Line14_S                = find_dataref("laminar/B747/fms1/Line14_S")

B747DR_init_fmsL_CD                 = find_dataref("laminar/B747/fmsL/init_CD")


--*************************************************************************************--
--** 				        CREATE READ-WRITE CUSTOM DATAREFS                        **--
--*************************************************************************************--

-- CRT BRIGHTNESS DIAL ------------------------------------------------------------------
--B747DR_fms1_display_brightness      = create_dataref("laminar/B747/fms1/display_brightness", "number", B747_fms1_display_brightness_DRhandler)




--*************************************************************************************--
--** 				              CREATE CUSTOM COMMANDS              			     **--
--*************************************************************************************--

-- LINE SELECT KEYS ---------------------------------------------------------------------
B747CMD_fms1_ls_key_L1              = replace_command("laminar/B747/fms1/ls_key/L1",  B747_fms1_ls_key_L1_CMDhandler)
B747CMD_fms1_ls_key_L2              = replace_command("laminar/B747/fms1/ls_key/L2",  B747_fms1_ls_key_L2_CMDhandler)
B747CMD_fms1_ls_key_L3              = replace_command("laminar/B747/fms1/ls_key/L3", B747_fms1_ls_key_L3_CMDhandler)
B747CMD_fms1_ls_key_L4              = replace_command("laminar/B747/fms1/ls_key/L4",  B747_fms1_ls_key_L4_CMDhandler)
B747CMD_fms1_ls_key_L5              = replace_command("laminar/B747/fms1/ls_key/L5",  B747_fms1_ls_key_L5_CMDhandler)
B747CMD_fms1_ls_key_L6              = replace_command("laminar/B747/fms1/ls_key/L6",  B747_fms1_ls_key_L6_CMDhandler)

B747CMD_fms1_ls_key_R1              = replace_command("laminar/B747/fms1/ls_key/R1",  B747_fms1_ls_key_R1_CMDhandler)
B747CMD_fms1_ls_key_R2              = replace_command("laminar/B747/fms1/ls_key/R2",  B747_fms1_ls_key_R2_CMDhandler)
B747CMD_fms1_ls_key_R3              = replace_command("laminar/B747/fms1/ls_key/R3",  B747_fms1_ls_key_R3_CMDhandler)
B747CMD_fms1_ls_key_R4              = replace_command("laminar/B747/fms1/ls_key/R4", B747_fms1_ls_key_R4_CMDhandler)
B747CMD_fms1_ls_key_R5              = replace_command("laminar/B747/fms1/ls_key/R5",  B747_fms1_ls_key_R5_CMDhandler)
B747CMD_fms1_ls_key_R6              = replace_command("laminar/B747/fms1/ls_key/R6",  B747_fms1_ls_key_R6_CMDhandler)


-- FUNCTION KEYS ------------------------------------------------------------------------
B747CMD_fms1_func_key_index         = replace_command("laminar/B747/fms1/func_key/index",  B747_fms1_func_key_index_CMDhandler)
B747CMD_fms1_func_key_fpln          = replace_command("laminar/B747/fms1/func_key/fpln",B747_fms1_func_key_fpln_CMDhandler)
B747CMD_fms1_func_key_clb           = replace_command("laminar/B747/fms1/func_key/clb",  B747_fms1_func_key_clb_CMDhandler)
B747CMD_fms1_func_key_crz           = replace_command("laminar/B747/fms1/func_key/crz",  B747_fms1_func_key_crz_CMDhandler)
B747CMD_fms1_func_key_des           = replace_command("laminar/B747/fms1/func_key/des",  B747_fms1_func_key_des_CMDhandler)
B747CMD_fms1_func_key_dir_intc      = replace_command("laminar/B747/fms1/func_key/dir_intc",  B747_fms1_func_key_dir_intc_CMDhandler)
B747CMD_fms1_func_key_legs          = replace_command("laminar/B747/fms1/func_key/legs",  B747_fms1_func_key_legs_CMDhandler)
B747CMD_fms1_func_key_dep_arr       = replace_command("laminar/B747/fms1/func_key/dep_arr",  B747_fms1_func_key_dep_arr_CMDhandler)
B747CMD_fms1_func_key_hold          = replace_command("laminar/B747/fms1/func_key/hold",  B747_fms1_func_key_hold_CMDhandler)
B747CMD_fms1_func_key_prog          = replace_command("laminar/B747/fms1/func_key/prog",  B747_fms1_func_key_prog_CMDhandler)
B747CMD_fms1_key_execute            = replace_command("laminar/B747/fms1/key/execute",  B747_fms1_key_execute_CMDhandler)
B747CMD_fms1_func_key_fix           = replace_command("laminar/B747/fms1/func_key/fix",  B747_fms1_func_key_fix_CMDhandler)
B747CMD_fms1_func_key_prev_pg       = replace_command("laminar/B747/fms1/func_key/prev_pg",  B747_fms1_func_key_prev_pg_CMDhandler)
B747CMD_fms1_func_key_next_pg       = replace_command("laminar/B747/fms1/func_key/next_pg",  B747_fms1_func_key_next_pg_CMDhandler)


-- ALPHA-NUMERIC KEYS -------------------------------------------------------------------
B747CMD_fms1_alphanum_key_0         = replace_command("laminar/B747/fms1/alphanum_key/0", B747_fms1_alphanum_key_0_CMDhandler)
B747CMD_fms1_alphanum_key_1         = replace_command("laminar/B747/fms1/alphanum_key/1",  B747_fms1_alphanum_key_1_CMDhandler)
B747CMD_fms1_alphanum_key_2         = replace_command("laminar/B747/fms1/alphanum_key/2",  B747_fms1_alphanum_key_2_CMDhandler)
B747CMD_fms1_alphanum_key_3         = replace_command("laminar/B747/fms1/alphanum_key/3",  B747_fms1_alphanum_key_3_CMDhandler)
B747CMD_fms1_alphanum_key_4         = replace_command("laminar/B747/fms1/alphanum_key/4", B747_fms1_alphanum_key_4_CMDhandler)
B747CMD_fms1_alphanum_key_5         = replace_command("laminar/B747/fms1/alphanum_key/5",  B747_fms1_alphanum_key_5_CMDhandler)
B747CMD_fms1_alphanum_key_6         = replace_command("laminar/B747/fms1/alphanum_key/6",  B747_fms1_alphanum_key_6_CMDhandler)
B747CMD_fms1_alphanum_key_7         = replace_command("laminar/B747/fms1/alphanum_key/7", B747_fms1_alphanum_key_7_CMDhandler)
B747CMD_fms1_alphanum_key_8         = replace_command("laminar/B747/fms1/alphanum_key/8",  B747_fms1_alphanum_key_8_CMDhandler)
B747CMD_fms1_alphanum_key_9         = replace_command("laminar/B747/fms1/alphanum_key/9",  B747_fms1_alphanum_key_9_CMDhandler)

B747CMD_fms1_key_period             = replace_command("laminar/B747/fms1/key/period", B747_fms1_key_period_CMDhandler)
B747CMD_fms1_key_minus              = replace_command("laminar/B747/fms1/key/minus",  B747_fms1_key_minus_CMDhandler)

B747CMD_fms1_alphanum_key_A         = replace_command("laminar/B747/fms1/alphanum_key/A",  B747_fms1_alphanum_key_A_CMDhandler)
B747CMD_fms1_alphanum_key_B         = replace_command("laminar/B747/fms1/alphanum_key/B",  B747_fms1_alphanum_key_B_CMDhandler)
B747CMD_fms1_alphanum_key_C         = replace_command("laminar/B747/fms1/alphanum_key/C",  B747_fms1_alphanum_key_C_CMDhandler)
B747CMD_fms1_alphanum_key_D         = replace_command("laminar/B747/fms1/alphanum_key/D",  B747_fms1_alphanum_key_D_CMDhandler)
B747CMD_fms1_alphanum_key_E         = replace_command("laminar/B747/fms1/alphanum_key/E",  B747_fms1_alphanum_key_E_CMDhandler)
B747CMD_fms1_alphanum_key_F         = replace_command("laminar/B747/fms1/alphanum_key/F",  B747_fms1_alphanum_key_F_CMDhandler)
B747CMD_fms1_alphanum_key_G         = replace_command("laminar/B747/fms1/alphanum_key/G",  B747_fms1_alphanum_key_G_CMDhandler)
B747CMD_fms1_alphanum_key_H         = replace_command("laminar/B747/fms1/alphanum_key/H",  B747_fms1_alphanum_key_H_CMDhandler)
B747CMD_fms1_alphanum_key_I         = replace_command("laminar/B747/fms1/alphanum_key/I",  B747_fms1_alphanum_key_I_CMDhandler)
B747CMD_fms1_alphanum_key_J         = replace_command("laminar/B747/fms1/alphanum_key/J",  B747_fms1_alphanum_key_J_CMDhandler)
B747CMD_fms1_alphanum_key_K         = replace_command("laminar/B747/fms1/alphanum_key/K",  B747_fms1_alphanum_key_K_CMDhandler)
B747CMD_fms1_alphanum_key_L         = replace_command("laminar/B747/fms1/alphanum_key/L",  B747_fms1_alphanum_key_L_CMDhandler)
B747CMD_fms1_alphanum_key_M         = replace_command("laminar/B747/fms1/alphanum_key/M",  B747_fms1_alphanum_key_M_CMDhandler)
B747CMD_fms1_alphanum_key_N         = replace_command("laminar/B747/fms1/alphanum_key/N",  B747_fms1_alphanum_key_N_CMDhandler)
B747CMD_fms1_alphanum_key_O         = replace_command("laminar/B747/fms1/alphanum_key/O",  B747_fms1_alphanum_key_O_CMDhandler)
B747CMD_fms1_alphanum_key_P         = replace_command("laminar/B747/fms1/alphanum_key/P",  B747_fms1_alphanum_key_P_CMDhandler)
B747CMD_fms1_alphanum_key_Q         = replace_command("laminar/B747/fms1/alphanum_key/Q",  B747_fms1_alphanum_key_Q_CMDhandler)
B747CMD_fms1_alphanum_key_R         = replace_command("laminar/B747/fms1/alphanum_key/R",  B747_fms1_alphanum_key_R_CMDhandler)
B747CMD_fms1_alphanum_key_S         = replace_command("laminar/B747/fms1/alphanum_key/S",  B747_fms1_alphanum_key_S_CMDhandler)
B747CMD_fms1_alphanum_key_T         = replace_command("laminar/B747/fms1/alphanum_key/T",  B747_fms1_alphanum_key_T_CMDhandler)
B747CMD_fms1_alphanum_key_U         = replace_command("laminar/B747/fms1/alphanum_key/U",  B747_fms1_alphanum_key_U_CMDhandler)
B747CMD_fms1_alphanum_key_V         = replace_command("laminar/B747/fms1/alphanum_key/V",  B747_fms1_alphanum_key_V_CMDhandler)
B747CMD_fms1_alphanum_key_W         = replace_command("laminar/B747/fms1/alphanum_key/W",  B747_fms1_alphanum_key_W_CMDhandler)
B747CMD_fms1_alphanum_key_X         = replace_command("laminar/B747/fms1/alphanum_key/X",  B747_fms1_alphanum_key_X_CMDhandler)
B747CMD_fms1_alphanum_key_Y         = replace_command("laminar/B747/fms1/alphanum_key/Y",  B747_fms1_alphanum_key_Y_CMDhandler)
B747CMD_fms1_alphanum_key_Z         = replace_command("laminar/B747/fms1/alphanum_key/Z",  B747_fms1_alphanum_key_Z_CMDhandler)

B747CMD_fms1_key_space              = replace_command("laminar/B747/fms1/key/space",  B747_fms1_key_space_CMDhandler)
B747CMD_fms1_key_del                = replace_command("laminar/B747/fms1/key/del",    B747_fms1_key_del_CMDhandler)
B747CMD_fms1_key_slash              = replace_command("laminar/B747/fms1/key/slash",  B747_fms1_key_slash_CMDhandler)
B747CMD_fms1_key_clear              = replace_command("laminar/B747/fms1/key/clear",  B747_fms1_key_clear_CMDhandler)


-- RADIO MANIPS -------------------------------------------------------------------------
B747CMD_fms1_vorL_freq_coarse_up    = replace_command("laminar/B747/fms1/radio/vorL_freq_coarse_up",   B747_fms1_vorL_freq_coarse_up_CMDhandler)
B747CMD_fms1_vorL_freq_coarse_dn    = replace_command("laminar/B747/fms1/radio/vorL_freq_coarse_dn",   B747_fms1_vorL_freq_coarse_dn_CMDhandler)
B747CMD_fms1_vorL_freq_fine_up      = replace_command("laminar/B747/fms1/radio/vorL_freq_fine_up",     B747_fms1_vorL_freq_fine_up_CMDhandler)
B747CMD_fms1_vorL_freq_fine_dn      = replace_command("laminar/B747/fms1/radio/vorL_freq_fine_dn",     B747_fms1_vorL_freq_fine_dn_CMDhandler)

B747CMD_fms1_vorL_course_up         = replace_command("laminar/B747/fms1/radio/vorL_course_up",        B747_fms1_vorL_course_up_CMDhandler)
B747CMD_fms1_vorL_course_dn         = replace_command("laminar/B747/fms1/radio/vorL_course_dn",        B747_fms1_vorL_course_dn_CMDhandler)


B747CMD_fms1_vorR_freq_coarse_up    = replace_command("laminar/B747/fms1/radio/vorR_freq_ccoarse_up",  B747_fms1_vorR_freq_coarse_up_CMDhandler)
B747CMD_fms1_vorR_freq_coarse_dn    = replace_command("laminar/B747/fms1/radio/vorR_freq_coarse_dn",   B747_fms1_vorR_freq_coarse_dn_CMDhandler)
B747CMD_fms1_vorR_freq_fine_up      = replace_command("laminar/B747/fms1/radio/vorR_freq_fine_up",     B747_fms1_vorR_freq_fine_up_CMDhandler)
B747CMD_fms1_vorR_freq_fine_dn      = replace_command("laminar/B747/fms1/radio/vorR_freq_fine_dn",     B747_fms1_vorR_freq_fine_dn_CMDhandler)

B747CMD_fms1_vorR_course_up         = replace_command("laminar/B747/fms1/radio/vorR_course_up",        B747_fms1_vorR_course_up_CMDhandler)
B747CMD_fms1_vorR_course_dn         = replace_command("laminar/B747/fms1/radio/vorR_course_dn",        B747_fms1_vorR_course_dn_CMDhandler)


B747CMD_fms1_ils_course_up          = replace_command("laminar/B747/fms1/radio/ils_course_up",         B747_fms1_ils_course_up_CMDhandler)
B747CMD_fms1_ils_course_dn          = replace_command("laminar/B747/fms1/radio/ils_course_dn",         B747_fms1_ils_course_dn_CMDhandler)


-- AI
B747CMD_ai_fmsL_quick_start	    = replace_command("laminar/B747/ai/fmsL_quick_start",              B747_ai_fmsL_quick_start_CMDhandler)



--*************************************************************************************--
--** 				             REPLACE X-PLANE COMMANDS                  	    	 **--
--*************************************************************************************--

B747CMD_fms1_func_key_nav_rad       = replace_command("sim/FMS/navrad", B747_fms1_func_key_nav_rad_CMDhandler)




--*************************************************************************************--
--** 				               WRAP X-PLANE COMMANDS                  	    	 **--
--*************************************************************************************--

simCMDwrap_fms1_func_key_index          = wrap_command("sim/FMS/index", sim_fms1_func_key_beforeCMDhandler, sim_fms1_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_fpln           = wrap_command("sim/FMS/fpln", sim_fms1_func_key_beforeCMDhandler, sim_fms1_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_clb            = wrap_command("sim/FMS/clb", sim_fms1_func_key_beforeCMDhandler, sim_fms1_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_crz            = wrap_command("sim/FMS/crz", sim_fms1_func_key_beforeCMDhandler, sim_fms1_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_des            = wrap_command("sim/FMS/des", sim_fms1_func_key_beforeCMDhandler, sim_fms1_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_dir_intc       = wrap_command("sim/FMS/dir_intc", sim_fms1_func_key_beforeCMDhandler, sim_fms1_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_legs           = wrap_command("sim/FMS/legs", sim_fms1_func_key_beforeCMDhandler, sim_fms1_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_dep_arr        = wrap_command("sim/FMS/dep_arr", sim_fms1_func_key_beforeCMDhandler, sim_fms1_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_hold           = wrap_command("sim/FMS/hold", sim_fms1_func_key_beforeCMDhandler, sim_fms1_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_prog           = wrap_command("sim/FMS/prog", sim_fms1_func_key_beforeCMDhandler, sim_fms1_func_key_afterCMDhandler)
simCMDwrap_fms1_key_execute             = wrap_command("sim/FMS/exec", sim_fms1_func_key_beforeCMDhandler, sim_fms1_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_fix            = wrap_command("sim/FMS/fix", sim_fms1_func_key_beforeCMDhandler, sim_fms1_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_prev_pg        = wrap_command("sim/FMS/prev", sim_fms1_func_key_beforeCMDhandler, sim_fms1_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_next_pg        = wrap_command("sim/FMS/next", sim_fms1_func_key_beforeCMDhandler, sim_fms1_func_key_afterCMDhandler)





--*************************************************************************************--
--** 					           OBJECT CONSTRUCTORS         		        		 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				                  CREATE OBJECTS                 				 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				                 SYSTEM FUNCTIONS           	    			 **--
--*************************************************************************************--

function B747_set_FMS1_display_mode_norm()
    B747DR_fms1_display_mode = 0
end

fms1_line0=find_dataref("sim/cockpit2/radios/indicators/fms_cdu1_text_line0")
fms1_line1=find_dataref("sim/cockpit2/radios/indicators/fms_cdu1_text_line1")
fms1_line2=find_dataref("sim/cockpit2/radios/indicators/fms_cdu1_text_line2")
fms1_line3=find_dataref("sim/cockpit2/radios/indicators/fms_cdu1_text_line3")
fms1_line4=find_dataref("sim/cockpit2/radios/indicators/fms_cdu1_text_line4")
fms1_line5=find_dataref("sim/cockpit2/radios/indicators/fms_cdu1_text_line5")
fms1_line6=find_dataref("sim/cockpit2/radios/indicators/fms_cdu1_text_line6")
fms1_line7=find_dataref("sim/cockpit2/radios/indicators/fms_cdu1_text_line7")
fms1_line8=find_dataref("sim/cockpit2/radios/indicators/fms_cdu1_text_line8")
fms1_line9=find_dataref("sim/cockpit2/radios/indicators/fms_cdu1_text_line9")
fms1_line10=find_dataref("sim/cockpit2/radios/indicators/fms_cdu1_text_line10")
fms1_line11=find_dataref("sim/cockpit2/radios/indicators/fms_cdu1_text_line11")
fms1_line12=find_dataref("sim/cockpit2/radios/indicators/fms_cdu1_text_line12")
fms1_line13=find_dataref("sim/cockpit2/radios/indicators/fms_cdu1_text_line13")
fms1_line14=find_dataref("sim/cockpit2/radios/indicators/fms_cdu1_text_line14")
fms1_line15=find_dataref("sim/cockpit2/radios/indicators/fms_cdu1_text_line15")
function B747_fms1_display_navrad()

        B747DR_fms1_Line01_L = string.format("        %9s      ", "NAV RADIO")
        B747DR_fms1_Line02_L = string.format("                        ", "")
        B747DR_fms1_Line03_L = string.format("%6.2f %4s  %4s %6.2f", simDR_radio_nav_freq_hz[2]*0.01, simDR_radio_nav03_ID, simDR_radio_nav04_ID, simDR_radio_nav_freq_hz[3]*0.01)
        B747DR_fms1_Line04_L = string.format("                        ", "")
        B747DR_fms1_Line05_L = string.format(" %03d     %3s  %3s    %03d", simDR_radio_nav_obs_deg[2], "---", "---", simDR_radio_nav_obs_deg[3])
        B747DR_fms1_Line06_L = string.format("                        ", "")
        B747DR_fms1_Line07_L = string.format("%06.1f         %06.1f   ", simDR_radio_adf1_freq_hz, simDR_radio_adf2_freq_hz)
        B747DR_fms1_Line08_L = string.format("                        ", "")
        B747DR_fms1_Line09_L = string.format("%6.2f/%03d%s             ", simDR_radio_nav_freq_hz[0]*0.01, simDR_radio_nav_obs_deg[0], "˚")
        B747DR_fms1_Line10_L = string.format("                        ", "")
        B747DR_fms1_Line11_L = string.format("                        ", "")
        B747DR_fms1_Line12_L = string.format("                        ", "")
        B747DR_fms1_Line13_L = string.format("                        ", "")
        B747DR_fms1_Line14_L = string.format("%s            %s", "------", "------")

        B747DR_fms1_Line01_S = string.format("                        ", "")
        B747DR_fms1_Line02_S = string.format(" %5s             %5s", "VOR L", "VOR R")
        B747DR_fms1_Line03_S = string.format("      %1s          %1s      ", "M", "M")
        B747DR_fms1_Line04_S = string.format(" %3s      %6s     %3s", "CRS", "RADIAL", "CRS")
        B747DR_fms1_Line05_S = string.format("                        ", "")
        B747DR_fms1_Line06_S = string.format(" %5s             %5s", "ADF L", "ADF R")
        B747DR_fms1_Line07_S = string.format("      %3s            %3s", "ANT", "ANT")
        B747DR_fms1_Line08_S = string.format(" %3s                    ", "ILS")
        B747DR_fms1_Line09_S = string.format("           %1s            ", "M")
        B747DR_fms1_Line10_S = string.format("                        ", "")
        B747DR_fms1_Line11_S = string.format("                        ", "")
        B747DR_fms1_Line12_S = string.format("                        ", "")
        B747DR_fms1_Line13_S = string.format("        %9s       ", "PRESELECT")
        B747DR_fms1_Line14_S = string.format("                        ", "")

end
function cleanFMSLine(line)
    local retval=line:gsub("☐","*")
    retval=retval:gsub("°","`")
    return retval
end 
function B747_fms1_display_fms()
      local page1=false
      if fms1_line0:find("INDEX") ~= nil then
	page1=true
      end
        B747DR_fms1_Line01_L = cleanFMSLine(fms1_line0) 
        B747DR_fms1_Line02_L = cleanFMSLine(fms1_line1)
        B747DR_fms1_Line03_L = cleanFMSLine(fms1_line2) 
        B747DR_fms1_Line04_L = cleanFMSLine(fms1_line3) 
        B747DR_fms1_Line05_L = cleanFMSLine(fms1_line4)
	B747DR_fms1_Line06_L = cleanFMSLine(fms1_line5)
	if page1 then
	  B747DR_fms1_Line07_L = "<ACARS"
	else
	  B747DR_fms1_Line07_L = cleanFMSLine(fms1_line6)
	end
        
        B747DR_fms1_Line08_L = cleanFMSLine(fms1_line7) 
        B747DR_fms1_Line09_L = cleanFMSLine(fms1_line8)
        B747DR_fms1_Line10_L = cleanFMSLine(fms1_line9)
        B747DR_fms1_Line11_L = cleanFMSLine(fms1_line10)
        B747DR_fms1_Line12_L = cleanFMSLine(fms1_line11)
        B747DR_fms1_Line13_L = cleanFMSLine(fms1_line12)
        B747DR_fms1_Line14_L = cleanFMSLine(fms1_line13)
	B747DR_fms1_Line01_S = ""
        B747DR_fms1_Line02_S = ""
        B747DR_fms1_Line03_S = ""
        B747DR_fms1_Line04_S = ""
        B747DR_fms1_Line05_S = ""
        B747DR_fms1_Line06_S = ""
        B747DR_fms1_Line07_S = ""
        B747DR_fms1_Line08_S = ""
        B747DR_fms1_Line09_S = ""
        B747DR_fms1_Line10_S = ""
        B747DR_fms1_Line11_S = ""
        B747DR_fms1_Line12_S = ""
        B747DR_fms1_Line13_S = ""
        B747DR_fms1_Line14_S = ""

end







----- MONITOR AI FOR AUTO-BOARD CALL ----------------------------------------------------
function B747_fmsL_monitor_AI()

    if B747DR_init_fmsL_CD == 1 then
        B747_set_fmsL_all_modes()
        B747_set_fmsL_CD()
        B747DR_init_fmsL_CD = 2
    end

end





----- SET STATE FOR ALL MODES -----------------------------------------------------------
function B747_set_fmsL_all_modes()

    B747DR_fms1_display_brightness = simDR_instrument_brightness_ratio[12]

end





----- SET STATE TO COLD & DARK ----------------------------------------------------------
function B747_set_fmsL_CD()

	B747DR_init_fmsL_CD = 0

end





----- SET STATE TO ENGINES RUNNING ------------------------------------------------------
function B747_set_fmsL_ER()
	

	
end









----- FLIGHT START ---------------------------------------------------------------------
function B747_flight_start_fms1()

    -- ALL MODES ------------------------------------------------------------------------
    B747_set_fmsL_all_modes()


    -- COLD & DARK ----------------------------------------------------------------------
    if simDR_startup_running == 0 then

        B747_set_fmsL_CD()


    -- ENGINES RUNNING ------------------------------------------------------------------
    elseif simDR_startup_running == 1 then

		B747_set_fmsL_ER()
		
    end

end




--*************************************************************************************--
--** 				                 EVENT CALLBACKS           	        			 **--
--*************************************************************************************--

--function aircraft_load() end

--function aircraft_unload() end

--[[function flight_start() 

    B747_flight_start_fms1()

end]]

--function flight_crash() end

--function before_physics() end

function after_physics()
    if B747DR_fms1_display_mode ==1 then
      B747_fms1_display_navrad()
    else
      B747_fms1_display_fms()
    end
    B747_fmsL_monitor_AI()

end

--function after_replay() end



--*************************************************************************************--
--** 				               SUB-MODULE PROCESSING       	        			 **--
--*************************************************************************************--

-- dofile("")
