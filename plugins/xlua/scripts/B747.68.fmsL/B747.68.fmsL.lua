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
function null_command(phase, duration)
end
function deferred_command(name,desc)
	c = XLuaCreateCommand(name,desc)
	print("Deffereed "..name)
	XLuaReplaceCommand(c,null_command)
	return make_command_obj(c)
end

B747DR_fms1_Line01_L                = XLuaCreateDataRef("laminar/B747/fms1/Line01_L", "string","yes",nil)
B747DR_fms1_Line02_L                = XLuaCreateDataRef("laminar/B747/fms1/Line02_L", "string","yes",nil)
B747DR_fms1_Line03_L                = XLuaCreateDataRef("laminar/B747/fms1/Line03_L", "string","yes",nil)
B747DR_fms1_Line04_L                = XLuaCreateDataRef("laminar/B747/fms1/Line04_L", "string","yes",nil)
B747DR_fms1_Line05_L                = XLuaCreateDataRef("laminar/B747/fms1/Line05_L", "string","yes",nil)
B747DR_fms1_Line06_L                = XLuaCreateDataRef("laminar/B747/fms1/Line06_L", "string","yes",nil)
B747DR_fms1_Line07_L                = XLuaCreateDataRef("laminar/B747/fms1/Line07_L", "string","yes",nil)
B747DR_fms1_Line08_L                = XLuaCreateDataRef("laminar/B747/fms1/Line08_L", "string","yes",nil)
B747DR_fms1_Line09_L                = XLuaCreateDataRef("laminar/B747/fms1/Line09_L", "string","yes",nil)
B747DR_fms1_Line10_L                = XLuaCreateDataRef("laminar/B747/fms1/Line10_L", "string","yes",nil)
B747DR_fms1_Line11_L                = XLuaCreateDataRef("laminar/B747/fms1/Line11_L", "string","yes",nil)
B747DR_fms1_Line12_L                = XLuaCreateDataRef("laminar/B747/fms1/Line12_L", "string","yes",nil)
B747DR_fms1_Line13_L                = XLuaCreateDataRef("laminar/B747/fms1/Line13_L", "string","yes",nil)
B747DR_fms1_Line14_L                = XLuaCreateDataRef("laminar/B747/fms1/Line14_L", "string","yes",nil)

B747DR_fms1_Line01_S                = XLuaCreateDataRef("laminar/B747/fms1/Line01_S", "string","yes",nil)
B747DR_fms1_Line02_S                = XLuaCreateDataRef("laminar/B747/fms1/Line02_S", "string","yes",nil)
B747DR_fms1_Line03_S                = XLuaCreateDataRef("laminar/B747/fms1/Line03_S", "string","yes",nil)
B747DR_fms1_Line04_S                = XLuaCreateDataRef("laminar/B747/fms1/Line04_S", "string","yes",nil)
B747DR_fms1_Line05_S                = XLuaCreateDataRef("laminar/B747/fms1/Line05_S", "string","yes",nil)
B747DR_fms1_Line06_S                = XLuaCreateDataRef("laminar/B747/fms1/Line06_S", "string","yes",nil)
B747DR_fms1_Line07_S                = XLuaCreateDataRef("laminar/B747/fms1/Line07_S", "string","yes",nil)
B747DR_fms1_Line08_S                = XLuaCreateDataRef("laminar/B747/fms1/Line08_S", "string","yes",nil)
B747DR_fms1_Line09_S                = XLuaCreateDataRef("laminar/B747/fms1/Line09_S", "string","yes",nil)
B747DR_fms1_Line10_S                = XLuaCreateDataRef("laminar/B747/fms1/Line10_S", "string","yes",nil)
B747DR_fms1_Line11_S                = XLuaCreateDataRef("laminar/B747/fms1/Line11_S", "string","yes",nil)
B747DR_fms1_Line12_S                = XLuaCreateDataRef("laminar/B747/fms1/Line12_S", "string","yes",nil)
B747DR_fms1_Line13_S                = XLuaCreateDataRef("laminar/B747/fms1/Line13_S", "string","yes",nil)
B747DR_fms1_Line14_S                = XLuaCreateDataRef("laminar/B747/fms1/Line14_S", "string","yes",nil)


--*************************************************************************************--
--** 				        CREATE READ-WRITE CUSTOM DATAREFS                        **--
--*************************************************************************************--

-- CRT BRIGHTNESS DIAL ------------------------------------------------------------------
simDR_instrument_brightness_switch  = find_dataref("sim/cockpit2/switches/instrument_brightness_ratio")
function B747_fms1_display_brightness_DRhandler()
    simDR_instrument_brightness_switch[12] = B747DR_fms1_display_brightness
end
B747DR_fms1_display_brightness      = create_dataref("laminar/B747/fms1/display_brightness", "number", B747_fms1_display_brightness_DRhandler)




--*************************************************************************************--
--** 				              CREATE CUSTOM COMMANDS              			     **--
--*************************************************************************************--

-- LINE SELECT KEYS ---------------------------------------------------------------------
B747CMD_fms1_ls_key_L1              = deferred_command("laminar/B747/fms1/ls_key/L1", "FMS1 Line Select Key 1-Left")
B747CMD_fms1_ls_key_L2              = deferred_command("laminar/B747/fms1/ls_key/L2", "FMS1 Line Select Key 2-Left")--, B747_fms1_ls_key_L2_CMDhandler)
B747CMD_fms1_ls_key_L3              = deferred_command("laminar/B747/fms1/ls_key/L3", "FMS1 Line Select Key 3-Left")--, B747_fms1_ls_key_L3_CMDhandler)
B747CMD_fms1_ls_key_L4              = deferred_command("laminar/B747/fms1/ls_key/L4", "FMS1 Line Select Key 4-Left")--, B747_fms1_ls_key_L4_CMDhandler)
B747CMD_fms1_ls_key_L5              = deferred_command("laminar/B747/fms1/ls_key/L5", "FMS1 Line Select Key 5-Left")--, B747_fms1_ls_key_L5_CMDhandler)
B747CMD_fms1_ls_key_L6              = deferred_command("laminar/B747/fms1/ls_key/L6", "FMS1 Line Select Key 6-Left")--, B747_fms1_ls_key_L6_CMDhandler)

B747CMD_fms1_ls_key_R1              = deferred_command("laminar/B747/fms1/ls_key/R1", "FMS1 Line Select Key 1-Right")--, B747_fms1_ls_key_R1_CMDhandler)
B747CMD_fms1_ls_key_R2              = deferred_command("laminar/B747/fms1/ls_key/R2", "FMS1 Line Select Key 2-Right")--, B747_fms1_ls_key_R2_CMDhandler)
B747CMD_fms1_ls_key_R3              = deferred_command("laminar/B747/fms1/ls_key/R3", "FMS1 Line Select Key 3-Right")--, B747_fms1_ls_key_R3_CMDhandler)
B747CMD_fms1_ls_key_R4              = deferred_command("laminar/B747/fms1/ls_key/R4", "FMS1 Line Select Key 4-Right")--, B747_fms1_ls_key_R4_CMDhandler)
B747CMD_fms1_ls_key_R5              = deferred_command("laminar/B747/fms1/ls_key/R5", "FMS1 Line Select Key 5-Right")--, B747_fms1_ls_key_R5_CMDhandler)
B747CMD_fms1_ls_key_R6              = deferred_command("laminar/B747/fms1/ls_key/R6", "FMS1 Line Select Key 6-Right")--, B747_fms1_ls_key_R6_CMDhandler)


-- FUNCTION KEYS ------------------------------------------------------------------------
B747CMD_fms1_func_key_index         = deferred_command("laminar/B747/fms1/func_key/index", "FMS1 Function Key INDEX")--, B747_fms1_func_key_index_CMDhandler)
B747CMD_fms1_func_key_fpln          = deferred_command("laminar/B747/fms1/func_key/fpln", "FMS1 Function Key FPLN")--, B747_fms1_func_key_fpln_CMDhandler)
B747CMD_fms1_func_key_clb           = deferred_command("laminar/B747/fms1/func_key/clb", "FMS1 Function Key CLB")--, B747_fms1_func_key_clb_CMDhandler)
B747CMD_fms1_func_key_crz           = deferred_command("laminar/B747/fms1/func_key/crz", "FMS1 Function Key CRZ")--, B747_fms1_func_key_crz_CMDhandler)
B747CMD_fms1_func_key_des           = deferred_command("laminar/B747/fms1/func_key/des", "FMS1 Function Key DES")--, B747_fms1_func_key_des_CMDhandler)
B747CMD_fms1_func_key_dir_intc      = deferred_command("laminar/B747/fms1/func_key/dir_intc", "FMS1 Function Key DIR/INTC")--, B747_fms1_func_key_dir_intc_CMDhandler)
B747CMD_fms1_func_key_legs          = deferred_command("laminar/B747/fms1/func_key/legs", "FMS1 Function Key LEGS")--, B747_fms1_func_key_legs_CMDhandler)
B747CMD_fms1_func_key_dep_arr       = deferred_command("laminar/B747/fms1/func_key/dep_arr", "FMS1 Function Key DEP/ARR")--, B747_fms1_func_key_dep_arr_CMDhandler)
B747CMD_fms1_func_key_hold          = deferred_command("laminar/B747/fms1/func_key/hold", "FMS1 Function Key HOLD")--, B747_fms1_func_key_hold_CMDhandler)
B747CMD_fms1_func_key_prog          = deferred_command("laminar/B747/fms1/func_key/prog", "FMS1 Function Key PROG")--, B747_fms1_func_key_prog_CMDhandler)
B747CMD_fms1_key_execute            = deferred_command("laminar/B747/fms1/key/execute", "FMS1 KEY EXEC")--, B747_fms1_key_execute_CMDhandler)
B747CMD_fms1_func_key_fix           = deferred_command("laminar/B747/fms1/func_key/fix", "FMS1 Function Key FIX")--, B747_fms1_func_key_fix_CMDhandler)
B747CMD_fms1_func_key_prev_pg       = deferred_command("laminar/B747/fms1/func_key/prev_pg", "FMS1 Function Key PREV PAGE")--, B747_fms1_func_key_prev_pg_CMDhandler)
B747CMD_fms1_func_key_next_pg       = deferred_command("laminar/B747/fms1/func_key/next_pg", "FMS1 Function Key NEXT PAGE")--, B747_fms1_func_key_next_pg_CMDhandler)


-- ALPHA-NUMERIC KEYS -------------------------------------------------------------------
B747CMD_fms1_alphanum_key_0         = deferred_command("laminar/B747/fms1/alphanum_key/0", "FMS1 Alpha/Numeric Key 0")--, B747_fms1_alphanum_key_0_CMDhandler)
B747CMD_fms1_alphanum_key_1         = deferred_command("laminar/B747/fms1/alphanum_key/1", "FMS1 Alpha/Numeric Key 1")--, B747_fms1_alphanum_key_1_CMDhandler)
B747CMD_fms1_alphanum_key_2         = deferred_command("laminar/B747/fms1/alphanum_key/2", "FMS1 Alpha/Numeric Key 2")--, B747_fms1_alphanum_key_2_CMDhandler)
B747CMD_fms1_alphanum_key_3         = deferred_command("laminar/B747/fms1/alphanum_key/3", "FMS1 Alpha/Numeric Key 3")--, B747_fms1_alphanum_key_3_CMDhandler)
B747CMD_fms1_alphanum_key_4         = deferred_command("laminar/B747/fms1/alphanum_key/4", "FMS1 Alpha/Numeric Key 4")--, B747_fms1_alphanum_key_4_CMDhandler)
B747CMD_fms1_alphanum_key_5         = deferred_command("laminar/B747/fms1/alphanum_key/5", "FMS1 Alpha/Numeric Key 5")--, B747_fms1_alphanum_key_5_CMDhandler)
B747CMD_fms1_alphanum_key_6         = deferred_command("laminar/B747/fms1/alphanum_key/6", "FMS1 Alpha/Numeric Key 6")--, B747_fms1_alphanum_key_6_CMDhandler)
B747CMD_fms1_alphanum_key_7         = deferred_command("laminar/B747/fms1/alphanum_key/7", "FMS1 Alpha/Numeric Key 7")--, B747_fms1_alphanum_key_7_CMDhandler)
B747CMD_fms1_alphanum_key_8         = deferred_command("laminar/B747/fms1/alphanum_key/8", "FMS1 Alpha/Numeric Key 8")--, B747_fms1_alphanum_key_8_CMDhandler)
B747CMD_fms1_alphanum_key_9         = deferred_command("laminar/B747/fms1/alphanum_key/9", "FMS1 Alpha/Numeric Key 9")--, B747_fms1_alphanum_key_9_CMDhandler)

B747CMD_fms1_key_period             = deferred_command("laminar/B747/fms1/key/period", "FMS1 Key '.'")--, B747_fms1_key_period_CMDhandler)
B747CMD_fms1_key_minus              = deferred_command("laminar/B747/fms1/key/minus", "FMS1 Key '+/-'")--, B747_fms1_key_minus_CMDhandler)

B747CMD_fms1_alphanum_key_A         = deferred_command("laminar/B747/fms1/alphanum_key/A", "FMS1 Alpha/Numeric Key A")--, B747_fms1_alphanum_key_A_CMDhandler)
B747CMD_fms1_alphanum_key_B         = deferred_command("laminar/B747/fms1/alphanum_key/B", "FMS1 Alpha/Numeric Key B")--, B747_fms1_alphanum_key_B_CMDhandler)
B747CMD_fms1_alphanum_key_C         = deferred_command("laminar/B747/fms1/alphanum_key/C", "FMS1 Alpha/Numeric Key C")--, B747_fms1_alphanum_key_C_CMDhandler)
B747CMD_fms1_alphanum_key_D         = deferred_command("laminar/B747/fms1/alphanum_key/D", "FMS1 Alpha/Numeric Key D")--, B747_fms1_alphanum_key_D_CMDhandler)
B747CMD_fms1_alphanum_key_E         = deferred_command("laminar/B747/fms1/alphanum_key/E", "FMS1 Alpha/Numeric Key E")--, B747_fms1_alphanum_key_E_CMDhandler)
B747CMD_fms1_alphanum_key_F         = deferred_command("laminar/B747/fms1/alphanum_key/F", "FMS1 Alpha/Numeric Key F")--, B747_fms1_alphanum_key_F_CMDhandler)
B747CMD_fms1_alphanum_key_G         = deferred_command("laminar/B747/fms1/alphanum_key/G", "FMS1 Alpha/Numeric Key G")--, B747_fms1_alphanum_key_G_CMDhandler)
B747CMD_fms1_alphanum_key_H         = deferred_command("laminar/B747/fms1/alphanum_key/H", "FMS1 Alpha/Numeric Key H")--, B747_fms1_alphanum_key_H_CMDhandler)
B747CMD_fms1_alphanum_key_I         = deferred_command("laminar/B747/fms1/alphanum_key/I", "FMS1 Alpha/Numeric Key I")--, B747_fms1_alphanum_key_I_CMDhandler)
B747CMD_fms1_alphanum_key_J         = deferred_command("laminar/B747/fms1/alphanum_key/J", "FMS1 Alpha/Numeric Key J")--, B747_fms1_alphanum_key_J_CMDhandler)
B747CMD_fms1_alphanum_key_K         = deferred_command("laminar/B747/fms1/alphanum_key/K", "FMS1 Alpha/Numeric Key K")--, B747_fms1_alphanum_key_K_CMDhandler)
B747CMD_fms1_alphanum_key_L         = deferred_command("laminar/B747/fms1/alphanum_key/L", "FMS1 Alpha/Numeric Key L")--, B747_fms1_alphanum_key_L_CMDhandler)
B747CMD_fms1_alphanum_key_M         = deferred_command("laminar/B747/fms1/alphanum_key/M", "FMS1 Alpha/Numeric Key M")--, B747_fms1_alphanum_key_M_CMDhandler)
B747CMD_fms1_alphanum_key_N         = deferred_command("laminar/B747/fms1/alphanum_key/N", "FMS1 Alpha/Numeric Key N")--, B747_fms1_alphanum_key_N_CMDhandler)
B747CMD_fms1_alphanum_key_O         = deferred_command("laminar/B747/fms1/alphanum_key/O", "FMS1 Alpha/Numeric Key O")--, B747_fms1_alphanum_key_O_CMDhandler)
B747CMD_fms1_alphanum_key_P         = deferred_command("laminar/B747/fms1/alphanum_key/P", "FMS1 Alpha/Numeric Key P")--, B747_fms1_alphanum_key_P_CMDhandler)
B747CMD_fms1_alphanum_key_Q         = deferred_command("laminar/B747/fms1/alphanum_key/Q", "FMS1 Alpha/Numeric Key Q")--, B747_fms1_alphanum_key_Q_CMDhandler)
B747CMD_fms1_alphanum_key_R         = deferred_command("laminar/B747/fms1/alphanum_key/R", "FMS1 Alpha/Numeric Key R")--, B747_fms1_alphanum_key_R_CMDhandler)
B747CMD_fms1_alphanum_key_S         = deferred_command("laminar/B747/fms1/alphanum_key/S", "FMS1 Alpha/Numeric Key S")--, B747_fms1_alphanum_key_S_CMDhandler)
B747CMD_fms1_alphanum_key_T         = deferred_command("laminar/B747/fms1/alphanum_key/T", "FMS1 Alpha/Numeric Key T")--, B747_fms1_alphanum_key_T_CMDhandler)
B747CMD_fms1_alphanum_key_U         = deferred_command("laminar/B747/fms1/alphanum_key/U", "FMS1 Alpha/Numeric Key U")--, B747_fms1_alphanum_key_U_CMDhandler)
B747CMD_fms1_alphanum_key_V         = deferred_command("laminar/B747/fms1/alphanum_key/V", "FMS1 Alpha/Numeric Key V")--, B747_fms1_alphanum_key_V_CMDhandler)
B747CMD_fms1_alphanum_key_W         = deferred_command("laminar/B747/fms1/alphanum_key/W", "FMS1 Alpha/Numeric Key W")--, B747_fms1_alphanum_key_W_CMDhandler)
B747CMD_fms1_alphanum_key_X         = deferred_command("laminar/B747/fms1/alphanum_key/X", "FMS1 Alpha/Numeric Key X")--, B747_fms1_alphanum_key_X_CMDhandler)
B747CMD_fms1_alphanum_key_Y         = deferred_command("laminar/B747/fms1/alphanum_key/Y", "FMS1 Alpha/Numeric Key Y")--, B747_fms1_alphanum_key_Y_CMDhandler)
B747CMD_fms1_alphanum_key_Z         = deferred_command("laminar/B747/fms1/alphanum_key/Z", "FMS1 Alpha/Numeric Key Z")--, B747_fms1_alphanum_key_Z_CMDhandler)

B747CMD_fms1_key_space              = deferred_command("laminar/B747/fms1/key/space", "FMS1 KEY SP")--, B747_fms1_key_space_CMDhandler)
B747CMD_fms1_key_del                = deferred_command("laminar/B747/fms1/key/del", "FMS1 KEY DEL")--, B747_fms1_key_del_CMDhandler)
B747CMD_fms1_key_slash              = deferred_command("laminar/B747/fms1/key/slash", "FMS1 Key '/'")--, B747_fms1_key_slash_CMDhandler)
B747CMD_fms1_key_clear              = deferred_command("laminar/B747/fms1/key/clear", "FMS1 KEY CLR")--, B747_fms1_key_clear_CMDhandler)


-- RADIO MANIPS -------------------------------------------------------------------------
B747CMD_fms1_vorL_freq_coarse_up    = deferred_command("laminar/B747/fms1/radio/vorL_freq_coarse_up", "FMS1 Radio VOR L Frequency Coarse Up")--, B747_fms1_vorL_freq_coarse_up_CMDhandler)
B747CMD_fms1_vorL_freq_coarse_dn    = deferred_command("laminar/B747/fms1/radio/vorL_freq_coarse_dn", "FMS1 Radio VOR L Frequency Coarse Down")--, B747_fms1_vorL_freq_coarse_dn_CMDhandler)
B747CMD_fms1_vorL_freq_fine_up      = deferred_command("laminar/B747/fms1/radio/vorL_freq_fine_up", "FMS1 Radio VOR L Frequency Fine Up")--, B747_fms1_vorL_freq_fine_up_CMDhandler)
B747CMD_fms1_vorL_freq_fine_dn      = deferred_command("laminar/B747/fms1/radio/vorL_freq_fine_dn", "FMS1 Radio VOR L Frequency Fine Down")--, B747_fms1_vorL_freq_fine_dn_CMDhandler)

B747CMD_fms1_vorL_course_up         = deferred_command("laminar/B747/fms1/radio/vorL_course_up", "FMS1 Radio VOR L Course Up")--, B747_fms1_vorL_course_up_CMDhandler)
B747CMD_fms1_vorL_course_dn         = deferred_command("laminar/B747/fms1/radio/vorL_course_dn", "FMS1 Radio VOR L Course Down")--, B747_fms1_vorL_course_dn_CMDhandler)


B747CMD_fms1_vorR_freq_coarse_up    = deferred_command("laminar/B747/fms1/radio/vorR_freq_ccoarse_up", "FMS1 Radio VOR R Frequency Coarse Up")--, B747_fms1_vorR_freq_coarse_up_CMDhandler)
B747CMD_fms1_vorR_freq_coarse_dn    = deferred_command("laminar/B747/fms1/radio/vorR_freq_coarse_dn", "FMS1 Radio VOR R Frequency Coarse Down")--, B747_fms1_vorR_freq_coarse_dn_CMDhandler)
B747CMD_fms1_vorR_freq_fine_up      = deferred_command("laminar/B747/fms1/radio/vorR_freq_fine_up", "FMS1 Radio VOR R Frequency Fine Up")--, B747_fms1_vorR_freq_fine_up_CMDhandler)
B747CMD_fms1_vorR_freq_fine_dn      = deferred_command("laminar/B747/fms1/radio/vorR_freq_fine_dn", "FMS1 Radio VOR R Frequency Fine Down")

B747CMD_fms1_vorR_course_up         = deferred_command("laminar/B747/fms1/radio/vorR_course_up", "FMS1 Radio VOR R Course Up")
B747CMD_fms1_vorR_course_dn         = deferred_command("laminar/B747/fms1/radio/vorR_course_dn", "FMS1 Radio VOR R Course Down")


B747CMD_fms1_ils_course_up          = deferred_command("laminar/B747/fms1/radio/ils_course_up", "FMS1 Radio ILS Course Up")
B747CMD_fms1_ils_course_dn          = deferred_command("laminar/B747/fms1/radio/ils_course_dn", "FMS1 Radio ILS Course Down")


-- AI
B747CMD_ai_fmsL_quick_start	    = deferred_command("laminar/B747/ai/fmsL_quick_start", "left FMS quick start")--, B747_ai_fmsL_quick_start_CMDhandler)




