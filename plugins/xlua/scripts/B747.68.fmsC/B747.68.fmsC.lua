--[[
*****************************************************************************************
* Program Script Name	:	B747.68.fmsC

* Author Name			:	Mark Parker (mSparks(43))
*
*   Revisions:
*   -- DATE --	--- REV NO ---		--- DESCRIPTION ---
*   2020-04-22	1				Fix center CDU
*
*
*
*
*****************************************************************************************
*       derived from B747.68.fmsL
*****************************************************************************************
--]]



simDR_instrument_brightness_switch  = find_dataref("sim/cockpit2/switches/instrument_brightness_ratio")


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

function B747_fms3_display_brightness_DRhandler()
    simDR_instrument_brightness_switch[12] = B747DR_fms1_display_brightness
end




--*************************************************************************************--
--** 				             X-PLANE COMMAND HANDLERS               	    	 **--
--*************************************************************************************--

function sim_fms3_func_key_beforeCMDhandler(phase, duration)
    if phase == 0 then B747_set_FMS1_display_mode_norm() end
end
function sim_fms3_func_key_afterCMDhandler(phase, duration) end




--*************************************************************************************--
--** 				             CUSTOM COMMAND HANDLERS            			     **--
--*************************************************************************************--

-- LINE SELECT KEYS ---------------------------------------------------------------------
function B747_fms3_ls_key_L1_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_1L:once() end
end
function B747_fms3_ls_key_L2_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_2L:once() end
end
function B747_fms3_ls_key_L3_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_3L:once() end
end
function B747_fms3_ls_key_L4_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_4L:once() end
end
function B747_fms3_ls_key_L5_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_5L:once() end
end
function B747_fms3_ls_key_L6_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_6L:once() end
end
function B747_fms3_ls_key_R1_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_1R:once() end
end
function B747_fms3_ls_key_R2_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_2R:once() end
end
function B747_fms3_ls_key_R3_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_3R:once() end
end
function B747_fms3_ls_key_R4_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_4R:once() end
end
function B747_fms3_ls_key_R5_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_5R:once() end
end
function B747_fms3_ls_key_R6_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_ls_6R:once() end
end


-- FUNCTION KEYS ------------------------------------------------------------------------
function B747_fms3_func_key_index_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_index:once() end
end
function B747_fms3_func_key_fpln_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_fpln:once() end
end
function B747_fms3_func_key_clb_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_clb:once() end
end
function B747_fms3_func_key_crz_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_crz:once() end
end
function B747_fms3_func_key_des_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_des:once() end
end
function B747_fms3_func_key_dir_intc_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_dir_intc:once() end
end
function B747_fms3_func_key_legs_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_legs:once() end
end
function B747_fms3_func_key_dep_arr_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_dep_arr:once() end
end
function B747_fms3_func_key_hold_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_hold:once() end
end
function B747_fms3_func_key_prog_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_prog:once() end
end
function B747_fms3_key_execute_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_exec:once() end
end
function B747_fms3_func_key_fix_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_fix:once() end
end
function B747_fms3_func_key_nav_rad_CMDhandler(phase, duration)
    if phase == 0 then B747DR_fms1_display_mode = 1.0 end
end
function B747_fms3_func_key_prev_pg_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_prev:once() end
end
function B747_fms3_func_key_next_pg_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_next:once() end
end


-- ALPHA-NUMERIC KEYS -------------------------------------------------------------------
function B747_fms3_alphanum_key_A_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_A:once() end
end
function B747_fms3_alphanum_key_B_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_B:once() end
end
function B747_fms3_alphanum_key_C_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_C:once() end
end
function B747_fms3_alphanum_key_D_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_D:once() end
end
function B747_fms3_alphanum_key_E_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_E:once() end
end
function B747_fms3_alphanum_key_F_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_F:once() end
end
function B747_fms3_alphanum_key_G_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_G:once() end
end
function B747_fms3_alphanum_key_H_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_H:once() end
end
function B747_fms3_alphanum_key_I_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_I:once() end
end
function B747_fms3_alphanum_key_J_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_J:once() end
end
function B747_fms3_alphanum_key_K_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_K:once() end
end
function B747_fms3_alphanum_key_L_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_L:once() end
end
function B747_fms3_alphanum_key_M_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_M:once() end
end
function B747_fms3_alphanum_key_N_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_N:once() end
end
function B747_fms3_alphanum_key_O_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_O:once() end
end
function B747_fms3_alphanum_key_P_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_P:once() end
end
function B747_fms3_alphanum_key_Q_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_Q:once() end
end
function B747_fms3_alphanum_key_R_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_R:once() end
end
function B747_fms3_alphanum_key_S_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_S:once() end
end
function B747_fms3_alphanum_key_T_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_T:once() end
end
function B747_fms3_alphanum_key_U_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_U:once() end
end
function B747_fms3_alphanum_key_V_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_V:once() end
end
function B747_fms3_alphanum_key_W_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_W:once() end
end
function B747_fms3_alphanum_key_X_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_X:once() end
end
function B747_fms3_alphanum_key_Y_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_Y:once() end
end
function B747_fms3_alphanum_key_Z_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_Z:once() end
end

function B747_fms3_alphanum_key_0_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_0:once() end
end
function B747_fms3_alphanum_key_1_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_1:once() end
end
function B747_fms3_alphanum_key_2_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_2:once() end
end
function B747_fms3_alphanum_key_3_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_3:once() end
end
function B747_fms3_alphanum_key_4_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_4:once() end
end
function B747_fms3_alphanum_key_5_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_5:once() end
end
function B747_fms3_alphanum_key_6_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_6:once() end
end
function B747_fms3_alphanum_key_7_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_7:once() end
end
function B747_fms3_alphanum_key_8_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_8:once() end
end
function B747_fms3_alphanum_key_9_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_9:once() end
end


-- MISC KEYS ----------------------------------------------------------------------------
function B747_fms3_key_period_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_period:once() end
end
function B747_fms3_key_minus_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_minus:once() end
end
function B747_fms3_key_space_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_space:once() end
end
function B747_fms3_key_del_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_delete:once() end
end
function B747_fms3_key_slash_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_slash:once() end
end
function B747_fms3_key_clear_CMDhandler(phase, duration)
    if phase == 0 then simCMD_FMS_key_clear:once() end
end







----- RADIO MANIPS ----------------------------------------------------------------------
-- VOR: 108.00-117.95
function B747_fms3_vorL_freq_coarse_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_Mhz[2] == 117 then
            simDR_radio_nav_freq_Mhz[2] = 108
        else
            simDR_radio_nav_freq_Mhz[2] = simDR_radio_nav_freq_Mhz[2] + 1
        end
    end
end
function B747_fms3_vorL_freq_coarse_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_Mhz[2] == 108 then
            simDR_radio_nav_freq_Mhz[2] = 117
        else
            simDR_radio_nav_freq_Mhz[2] = simDR_radio_nav_freq_Mhz[2] - 1
        end
    end
end
function B747_fms3_vorL_freq_fine_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_khz[2] == 95 then
            simDR_radio_nav_freq_khz[2] = 0
        else
            simDR_radio_nav_freq_khz[2] = simDR_radio_nav_freq_khz[2] + 5
        end
    end
end
function B747_fms3_vorL_freq_fine_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_khz[2] == 0 then
            simDR_radio_nav_freq_khz[2] = 95
        else
            simDR_radio_nav_freq_khz[2] = simDR_radio_nav_freq_khz[2] - 5
        end
    end
end

function B747_fms3_vorL_course_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_obs_deg[2] >= 359.0 then
            simDR_radio_nav_obs_deg[2] = 0.0
        else
            simDR_radio_nav_obs_deg[2] = simDR_radio_nav_obs_deg[2] + 1
        end
    end
end
function B747_fms3_vorL_course_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_obs_deg[2] <= 0.0 then
            simDR_radio_nav_obs_deg[2] = 359.0
        else
            simDR_radio_nav_obs_deg[2] = simDR_radio_nav_obs_deg[2] - 1
        end
    end
end





function B747_fms3_vorR_freq_coarse_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_Mhz[3] == 117 then
            simDR_radio_nav_freq_Mhz[3] = 108
        else
            simDR_radio_nav_freq_Mhz[3] = simDR_radio_nav_freq_Mhz[3] + 1
        end
    end
end
function B747_fms3_vorR_freq_coarse_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_Mhz[3] == 108 then
            simDR_radio_nav_freq_Mhz[3] = 117
        else
            simDR_radio_nav_freq_Mhz[3] = simDR_radio_nav_freq_Mhz[3] - 1
        end
    end
end
function B747_fms3_vorR_freq_fine_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_khz[3] == 95 then
            simDR_radio_nav_freq_khz[3] = 0
        else
            simDR_radio_nav_freq_khz[3] = simDR_radio_nav_freq_khz[3] + 5
        end
    end
end
function B747_fms3_vorR_freq_fine_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_freq_khz[3] == 0 then
            simDR_radio_nav_freq_khz[3] = 95
        else
            simDR_radio_nav_freq_khz[3] = simDR_radio_nav_freq_khz[3] - 5
        end
    end
end

function B747_fms3_vorR_course_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_obs_deg[3] >= 359.0 then
            simDR_radio_nav_obs_deg[3] = 0.0
        else
            simDR_radio_nav_obs_deg[3] = simDR_radio_nav_obs_deg[3] + 1
        end
    end
end
function B747_fms3_vorR_course_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_obs_deg[3] <= 0.0 then
            simDR_radio_nav_obs_deg[3] = 359.0
        else
            simDR_radio_nav_obs_deg[3] = simDR_radio_nav_obs_deg[3] - 1
        end
    end
end




function B747_fms3_ils_course_up_CMDhandler(phase, duration)
    if phase == 0 then
        if simDR_radio_nav_obs_deg[0] >= 359.0 then
            simDR_radio_nav_obs_deg[0] = 0.0
        else
            simDR_radio_nav_obs_deg[0] = simDR_radio_nav_obs_deg[0] + 1
        end
    end
end
function B747_fms3_ils_course_dn_CMDhandler(phase, duration)
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
B747DR_fms1_display_mode            = create_dataref("laminar/B747/fms1/display_mode", "number")

--[[
    0 = NORMAL
    1 = NAV RAD
--]]



B747DR_init_fmsL_CD                 = create_dataref("laminar/B747/fmsL/init_CD", "number")



--*************************************************************************************--
--** 				        CREATE READ-WRITE CUSTOM DATAREFS                        **--
--*************************************************************************************--

-- CRT BRIGHTNESS DIAL ------------------------------------------------------------------
B747DR_fms1_display_brightness      = find_dataref("laminar/B747/fms1/display_brightness")




--*************************************************************************************--
--** 				              CREATE CUSTOM COMMANDS              			     **--
--*************************************************************************************--

-- LINE SELECT KEYS ---------------------------------------------------------------------
B747CMD_fms3_ls_key_L1              = create_command("laminar/B747/fms3/ls_key/L1", "FMS1 Line Select Key 1-Left", B747_fms3_ls_key_L1_CMDhandler)
B747CMD_fms3_ls_key_L2              = create_command("laminar/B747/fms3/ls_key/L2", "FMS1 Line Select Key 2-Left", B747_fms3_ls_key_L2_CMDhandler)
B747CMD_fms3_ls_key_L3              = create_command("laminar/B747/fms3/ls_key/L3", "FMS1 Line Select Key 3-Left", B747_fms3_ls_key_L3_CMDhandler)
B747CMD_fms3_ls_key_L4              = create_command("laminar/B747/fms3/ls_key/L4", "FMS1 Line Select Key 4-Left", B747_fms3_ls_key_L4_CMDhandler)
B747CMD_fms3_ls_key_L5              = create_command("laminar/B747/fms3/ls_key/L5", "FMS1 Line Select Key 5-Left", B747_fms3_ls_key_L5_CMDhandler)
B747CMD_fms3_ls_key_L6              = create_command("laminar/B747/fms3/ls_key/L6", "FMS1 Line Select Key 6-Left", B747_fms3_ls_key_L6_CMDhandler)

B747CMD_fms3_ls_key_R1              = create_command("laminar/B747/fms3/ls_key/R1", "FMS1 Line Select Key 1-Right", B747_fms3_ls_key_R1_CMDhandler)
B747CMD_fms3_ls_key_R2              = create_command("laminar/B747/fms3/ls_key/R2", "FMS1 Line Select Key 2-Right", B747_fms3_ls_key_R2_CMDhandler)
B747CMD_fms3_ls_key_R3              = create_command("laminar/B747/fms3/ls_key/R3", "FMS1 Line Select Key 3-Right", B747_fms3_ls_key_R3_CMDhandler)
B747CMD_fms3_ls_key_R4              = create_command("laminar/B747/fms3/ls_key/R4", "FMS1 Line Select Key 4-Right", B747_fms3_ls_key_R4_CMDhandler)
B747CMD_fms3_ls_key_R5              = create_command("laminar/B747/fms3/ls_key/R5", "FMS1 Line Select Key 5-Right", B747_fms3_ls_key_R5_CMDhandler)
B747CMD_fms3_ls_key_R6              = create_command("laminar/B747/fms3/ls_key/R6", "FMS1 Line Select Key 6-Right", B747_fms3_ls_key_R6_CMDhandler)


-- FUNCTION KEYS ------------------------------------------------------------------------
B747CMD_fms3_func_key_index         = create_command("laminar/B747/fms3/func_key/index", "FMS1 Function Key INDEX", B747_fms3_func_key_index_CMDhandler)
B747CMD_fms3_func_key_fpln          = create_command("laminar/B747/fms3/func_key/fpln", "FMS1 Function Key FPLN", B747_fms3_func_key_fpln_CMDhandler)
B747CMD_fms3_func_key_clb           = create_command("laminar/B747/fms3/func_key/clb", "FMS1 Function Key CLB", B747_fms3_func_key_clb_CMDhandler)
B747CMD_fms3_func_key_crz           = create_command("laminar/B747/fms3/func_key/crz", "FMS1 Function Key CRZ", B747_fms3_func_key_crz_CMDhandler)
B747CMD_fms3_func_key_des           = create_command("laminar/B747/fms3/func_key/des", "FMS1 Function Key DES", B747_fms3_func_key_des_CMDhandler)
B747CMD_fms3_func_key_dir_intc      = create_command("laminar/B747/fms3/func_key/dir_intc", "FMS1 Function Key DIR/INTC", B747_fms3_func_key_dir_intc_CMDhandler)
B747CMD_fms3_func_key_legs          = create_command("laminar/B747/fms3/func_key/legs", "FMS1 Function Key LEGS", B747_fms3_func_key_legs_CMDhandler)
B747CMD_fms3_func_key_dep_arr       = create_command("laminar/B747/fms3/func_key/dep_arr", "FMS1 Function Key DEP/ARR", B747_fms3_func_key_dep_arr_CMDhandler)
B747CMD_fms3_func_key_hold          = create_command("laminar/B747/fms3/func_key/hold", "FMS1 Function Key HOLD", B747_fms3_func_key_hold_CMDhandler)
B747CMD_fms3_func_key_prog          = create_command("laminar/B747/fms3/func_key/prog", "FMS1 Function Key PROG", B747_fms3_func_key_prog_CMDhandler)
B747CMD_fms3_key_execute            = create_command("laminar/B747/fms3/key/execute", "FMS1 KEY EXEC", B747_fms3_key_execute_CMDhandler)
B747CMD_fms3_func_key_fix           = create_command("laminar/B747/fms3/func_key/fix", "FMS1 Function Key FIX", B747_fms3_func_key_fix_CMDhandler)
B747CMD_fms3_func_key_prev_pg       = create_command("laminar/B747/fms3/func_key/prev_pg", "FMS1 Function Key PREV PAGE", B747_fms3_func_key_prev_pg_CMDhandler)
B747CMD_fms3_func_key_next_pg       = create_command("laminar/B747/fms3/func_key/next_pg", "FMS1 Function Key NEXT PAGE", B747_fms3_func_key_next_pg_CMDhandler)


-- ALPHA-NUMERIC KEYS -------------------------------------------------------------------
B747CMD_fms3_alphanum_key_0         = create_command("laminar/B747/fms3/alphanum_key/0", "FMS1 Alpha/Numeric Key 0", B747_fms3_alphanum_key_0_CMDhandler)
B747CMD_fms3_alphanum_key_1         = create_command("laminar/B747/fms3/alphanum_key/1", "FMS1 Alpha/Numeric Key 1", B747_fms3_alphanum_key_1_CMDhandler)
B747CMD_fms3_alphanum_key_2         = create_command("laminar/B747/fms3/alphanum_key/2", "FMS1 Alpha/Numeric Key 2", B747_fms3_alphanum_key_2_CMDhandler)
B747CMD_fms3_alphanum_key_3         = create_command("laminar/B747/fms3/alphanum_key/3", "FMS1 Alpha/Numeric Key 3", B747_fms3_alphanum_key_3_CMDhandler)
B747CMD_fms3_alphanum_key_4         = create_command("laminar/B747/fms3/alphanum_key/4", "FMS1 Alpha/Numeric Key 4", B747_fms3_alphanum_key_4_CMDhandler)
B747CMD_fms3_alphanum_key_5         = create_command("laminar/B747/fms3/alphanum_key/5", "FMS1 Alpha/Numeric Key 5", B747_fms3_alphanum_key_5_CMDhandler)
B747CMD_fms3_alphanum_key_6         = create_command("laminar/B747/fms3/alphanum_key/6", "FMS1 Alpha/Numeric Key 6", B747_fms3_alphanum_key_6_CMDhandler)
B747CMD_fms3_alphanum_key_7         = create_command("laminar/B747/fms3/alphanum_key/7", "FMS1 Alpha/Numeric Key 7", B747_fms3_alphanum_key_7_CMDhandler)
B747CMD_fms3_alphanum_key_8         = create_command("laminar/B747/fms3/alphanum_key/8", "FMS1 Alpha/Numeric Key 8", B747_fms3_alphanum_key_8_CMDhandler)
B747CMD_fms3_alphanum_key_9         = create_command("laminar/B747/fms3/alphanum_key/9", "FMS1 Alpha/Numeric Key 9", B747_fms3_alphanum_key_9_CMDhandler)

B747CMD_fms3_key_period             = create_command("laminar/B747/fms3/key/period", "FMS1 Key '.'", B747_fms3_key_period_CMDhandler)
B747CMD_fms3_key_minus              = create_command("laminar/B747/fms3/key/minus", "FMS1 Key '+/-'", B747_fms3_key_minus_CMDhandler)

B747CMD_fms3_alphanum_key_A         = create_command("laminar/B747/fms3/alphanum_key/A", "FMS1 Alpha/Numeric Key A", B747_fms3_alphanum_key_A_CMDhandler)
B747CMD_fms3_alphanum_key_B         = create_command("laminar/B747/fms3/alphanum_key/B", "FMS1 Alpha/Numeric Key B", B747_fms3_alphanum_key_B_CMDhandler)
B747CMD_fms3_alphanum_key_C         = create_command("laminar/B747/fms3/alphanum_key/C", "FMS1 Alpha/Numeric Key C", B747_fms3_alphanum_key_C_CMDhandler)
B747CMD_fms3_alphanum_key_D         = create_command("laminar/B747/fms3/alphanum_key/D", "FMS1 Alpha/Numeric Key D", B747_fms3_alphanum_key_D_CMDhandler)
B747CMD_fms3_alphanum_key_E         = create_command("laminar/B747/fms3/alphanum_key/E", "FMS1 Alpha/Numeric Key E", B747_fms3_alphanum_key_E_CMDhandler)
B747CMD_fms3_alphanum_key_F         = create_command("laminar/B747/fms3/alphanum_key/F", "FMS1 Alpha/Numeric Key F", B747_fms3_alphanum_key_F_CMDhandler)
B747CMD_fms3_alphanum_key_G         = create_command("laminar/B747/fms3/alphanum_key/G", "FMS1 Alpha/Numeric Key G", B747_fms3_alphanum_key_G_CMDhandler)
B747CMD_fms3_alphanum_key_H         = create_command("laminar/B747/fms3/alphanum_key/H", "FMS1 Alpha/Numeric Key H", B747_fms3_alphanum_key_H_CMDhandler)
B747CMD_fms3_alphanum_key_I         = create_command("laminar/B747/fms3/alphanum_key/I", "FMS1 Alpha/Numeric Key I", B747_fms3_alphanum_key_I_CMDhandler)
B747CMD_fms3_alphanum_key_J         = create_command("laminar/B747/fms3/alphanum_key/J", "FMS1 Alpha/Numeric Key J", B747_fms3_alphanum_key_J_CMDhandler)
B747CMD_fms3_alphanum_key_K         = create_command("laminar/B747/fms3/alphanum_key/K", "FMS1 Alpha/Numeric Key K", B747_fms3_alphanum_key_K_CMDhandler)
B747CMD_fms3_alphanum_key_L         = create_command("laminar/B747/fms3/alphanum_key/L", "FMS1 Alpha/Numeric Key L", B747_fms3_alphanum_key_L_CMDhandler)
B747CMD_fms3_alphanum_key_M         = create_command("laminar/B747/fms3/alphanum_key/M", "FMS1 Alpha/Numeric Key M", B747_fms3_alphanum_key_M_CMDhandler)
B747CMD_fms3_alphanum_key_N         = create_command("laminar/B747/fms3/alphanum_key/N", "FMS1 Alpha/Numeric Key N", B747_fms3_alphanum_key_N_CMDhandler)
B747CMD_fms3_alphanum_key_O         = create_command("laminar/B747/fms3/alphanum_key/O", "FMS1 Alpha/Numeric Key O", B747_fms3_alphanum_key_O_CMDhandler)
B747CMD_fms3_alphanum_key_P         = create_command("laminar/B747/fms3/alphanum_key/P", "FMS1 Alpha/Numeric Key P", B747_fms3_alphanum_key_P_CMDhandler)
B747CMD_fms3_alphanum_key_Q         = create_command("laminar/B747/fms3/alphanum_key/Q", "FMS1 Alpha/Numeric Key Q", B747_fms3_alphanum_key_Q_CMDhandler)
B747CMD_fms3_alphanum_key_R         = create_command("laminar/B747/fms3/alphanum_key/R", "FMS1 Alpha/Numeric Key R", B747_fms3_alphanum_key_R_CMDhandler)
B747CMD_fms3_alphanum_key_S         = create_command("laminar/B747/fms3/alphanum_key/S", "FMS1 Alpha/Numeric Key S", B747_fms3_alphanum_key_S_CMDhandler)
B747CMD_fms3_alphanum_key_T         = create_command("laminar/B747/fms3/alphanum_key/T", "FMS1 Alpha/Numeric Key T", B747_fms3_alphanum_key_T_CMDhandler)
B747CMD_fms3_alphanum_key_U         = create_command("laminar/B747/fms3/alphanum_key/U", "FMS1 Alpha/Numeric Key U", B747_fms3_alphanum_key_U_CMDhandler)
B747CMD_fms3_alphanum_key_V         = create_command("laminar/B747/fms3/alphanum_key/V", "FMS1 Alpha/Numeric Key V", B747_fms3_alphanum_key_V_CMDhandler)
B747CMD_fms3_alphanum_key_W         = create_command("laminar/B747/fms3/alphanum_key/W", "FMS1 Alpha/Numeric Key W", B747_fms3_alphanum_key_W_CMDhandler)
B747CMD_fms3_alphanum_key_X         = create_command("laminar/B747/fms3/alphanum_key/X", "FMS1 Alpha/Numeric Key X", B747_fms3_alphanum_key_X_CMDhandler)
B747CMD_fms3_alphanum_key_Y         = create_command("laminar/B747/fms3/alphanum_key/Y", "FMS1 Alpha/Numeric Key Y", B747_fms3_alphanum_key_Y_CMDhandler)
B747CMD_fms3_alphanum_key_Z         = create_command("laminar/B747/fms3/alphanum_key/Z", "FMS1 Alpha/Numeric Key Z", B747_fms3_alphanum_key_Z_CMDhandler)

B747CMD_fms3_key_space              = create_command("laminar/B747/fms3/key/space", "FMS1 KEY SP", B747_fms3_key_space_CMDhandler)
B747CMD_fms3_key_del                = create_command("laminar/B747/fms3/key/del", "FMS1 KEY DEL", B747_fms3_key_del_CMDhandler)
B747CMD_fms3_key_slash              = create_command("laminar/B747/fms3/key/slash", "FMS1 Key '/'", B747_fms3_key_slash_CMDhandler)
B747CMD_fms3_key_clear              = create_command("laminar/B747/fms3/key/clear", "FMS1 KEY CLR", B747_fms3_key_clear_CMDhandler)





--*************************************************************************************--
--** 				             REPLACE X-PLANE COMMANDS                  	    	 **--
--*************************************************************************************--

B747CMD_fms3_func_key_nav_rad       = wrap_command("sim/FMS/navrad", B747_fms3_func_key_nav_rad_CMDhandler, B747_fms3_func_key_nav_rad_CMDhandler)




--*************************************************************************************--
--** 				               WRAP X-PLANE COMMANDS                  	    	 **--
--*************************************************************************************--

simCMDwrap_fms1_func_key_index          = wrap_command("sim/FMS/index", sim_fms3_func_key_beforeCMDhandler, sim_fms3_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_fpln           = wrap_command("sim/FMS/fpln", sim_fms3_func_key_beforeCMDhandler, sim_fms3_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_clb            = wrap_command("sim/FMS/clb", sim_fms3_func_key_beforeCMDhandler, sim_fms3_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_crz            = wrap_command("sim/FMS/crz", sim_fms3_func_key_beforeCMDhandler, sim_fms3_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_des            = wrap_command("sim/FMS/des", sim_fms3_func_key_beforeCMDhandler, sim_fms3_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_dir_intc       = wrap_command("sim/FMS/dir_intc", sim_fms3_func_key_beforeCMDhandler, sim_fms3_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_legs           = wrap_command("sim/FMS/legs", sim_fms3_func_key_beforeCMDhandler, sim_fms3_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_dep_arr        = wrap_command("sim/FMS/dep_arr", sim_fms3_func_key_beforeCMDhandler, sim_fms3_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_hold           = wrap_command("sim/FMS/hold", sim_fms3_func_key_beforeCMDhandler, sim_fms3_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_prog           = wrap_command("sim/FMS/prog", sim_fms3_func_key_beforeCMDhandler, sim_fms3_func_key_afterCMDhandler)
simCMDwrap_fms1_key_execute             = wrap_command("sim/FMS/exec", sim_fms3_func_key_beforeCMDhandler, sim_fms3_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_fix            = wrap_command("sim/FMS/fix", sim_fms3_func_key_beforeCMDhandler, sim_fms3_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_prev_pg        = wrap_command("sim/FMS/prev", sim_fms3_func_key_beforeCMDhandler, sim_fms3_func_key_afterCMDhandler)
simCMDwrap_fms1_func_key_next_pg        = wrap_command("sim/FMS/next", sim_fms3_func_key_beforeCMDhandler, sim_fms3_func_key_afterCMDhandler)




function B747_set_FMS1_display_mode_norm()
    B747DR_fms1_display_mode = 0
end

