
function deferred_command(name,desc,nilFunc)
	c = XLuaCreateCommand(name,desc)
	--print("Deferred command: "..name)
	--XLuaReplaceCommand(c,null_command)
	return nil --make_command_obj(c)
end
B747CMD_VR_toPilot 				= deferred_command("laminar/B747/VR/pilotView", "Move to Pilot hotspot", B747CMD_VR_toPilot_CMDhandler)
B747CMD_VR_toFMC 				= deferred_command("laminar/B747/VR/fmcView", "Move to FMC hotspot", B747CMD_VR_toFMC_CMDhandler)
B747CMD_VR_toMCP 				= deferred_command("laminar/B747/VR/mcpView", "Move to MCP hotspot", B747CMD_VR_toMCP_CMDhandler)
B747CMD_VR_toOCP 				= deferred_command("laminar/B747/VR/ocpView", "Move to OCP hotspot", B747CMD_VR_toOCP_CMDhandler)