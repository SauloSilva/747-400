--[[
Avitab Integration for Laminar's 747-400
By Ilias Tselios
]]--


avitabEnable				= find_dataref("avitab/panel_enabled")
avitabPower					= find_dataref("avitab/panel_powered")
avitabBrit					= find_dataref("avitab/brightness")
lowEICASpage				= find_dataref("laminar/B747/dsp/synoptic_display")
lowEICASbrit				= find_dataref("sim/cockpit2/electrical/instrument_brightness_ratio")

function avitabShow()

	if lowEICASpage == 5 then
		avitabEnable = 1
	else
		avitabEnable = 0
	end

	avitabBrit = lowEICASbrit[10]

end




local avitabInstalled=1
function after_physics()
if avitabInstalled==1 then
  if pcall(avitabShow()) ==false then
    avitabInstalled=0
  endif
endif
end
