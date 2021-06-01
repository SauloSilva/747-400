--[[
*****************************************************************************************
* Program Script Name	:	B747.42.EEC
* Author Name			:	Marauder28
*
*   Revisions:
*   -- DATE --	--- REV NO ---		--- DESCRIPTION ---
*   2020-11-19	0.01a				Start of Dev
*	2021-05-27	0.1					Initial Release
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
--THRUST CALC
--B747DR_packs 			= deferred_dataref("laminar/B747/air/pack_ctrl/sel_dial_pos", "array[3]")
B747DR_TO_throttle		= deferred_dataref("laminar/B747/engines/thrustref_throttle", "number")
B747DR_display_N1		= deferred_dataref("laminar/B747/engines/display_N1", "array[4]")
B747DR_display_N1_ref	= deferred_dataref("laminar/B747/engines/display_N1_ref", "array[4]")
B747DR_display_N1_max	= deferred_dataref("laminar/B747/engines/display_N1_max", "array[4]")
B747DR_display_EPR		= deferred_dataref("laminar/B747/engines/display_EPR", "array[4]")