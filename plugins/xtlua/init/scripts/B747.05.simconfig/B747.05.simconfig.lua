--[[
*****************************************************************************************
* Program Script Name	:	B747.05.simconfig
* Author Name			:	Marauder28
*
*   Revisions:
*   -- DATE --	--- REV NO ---		--- DESCRIPTION ---
*   2020-11-19	0.01a				Start of Dev
*
*
*
*
*****************************************************************************************
*
*****************************************************************************************
--]]

--*************************************************************************************--
--** 					         EARLY FUNCTION DEFITIONS                            **--
--*************************************************************************************--
--replace create_command
function deferred_command(name,desc,nilFunc)
	c = XLuaCreateCommand(name,desc)
	--print("Deferred command: "..name)
	--XLuaReplaceCommand(c,null_command)
	return nil --make_command_obj(c)
end
--replace create_dataref
function deferred_dataref(name,type,notifier)
	--print("Deffereed dataref: "..name)
	dref=XLuaCreateDataRef(name, type,"yes",notifier)
	return wrap_dref_any(dref,type) 
end


--*************************************************************************************--
--** 				        CREATE READ-WRITE CUSTOM DATAREFS                        **--
--*************************************************************************************--
-- Holds all SimConfig options
B747DR_simconfig_data					= deferred_dataref("laminar/B747/simconfig", "string")
B747DR_pfd_style						= deferred_dataref("laminar/B747/pfd/style", "number")
B747DR_nd_style							= deferred_dataref("laminar/B747/nd/style", "number")
B747DR_thrust_ref						= deferred_dataref("laminar/B747/engines/thrust_ref", "number")

--[[B747DR_efis_baro_ref_capt_sel_dial_pos		= deferred_dataref("laminar/B747/efis/baro_ref/capt/sel_dial_pos", "number")
B747DR_efis_baro_ref_fo_sel_dial_pos		= deferred_dataref("laminar/B747/efis/baro_ref/fo/sel_dial_pos", "number")
B747DR_flt_inst_inbd_disp_capt_sel_dial_pos	= deferred_dataref("laminar/B747/flt_inst/capt_inbd_display/sel_dial_pos", "number")
B747DR_flt_inst_lwr_disp_capt_sel_dial_pos	= deferred_dataref("laminar/B747/flt_inst/capt_lwr_display/sel_dial_pos", "number")
B747DR_flt_inst_inbd_disp_fo_sel_dial_pos	= deferred_dataref("laminar/B747/flt_inst/fo_inbd_display/sel_dial_pos", "number")
B747DR_flt_inst_lwr_disp_fo_sel_dial_pos	= deferred_dataref("laminar/B747/flt_inst/fo_lwr_display/sel_dial_pos", "number")
]]--