function deferred_dataref(name,type,notifier)
	--print("Deffereed dataref: "..name)
	dref=XLuaCreateDataRef(name, type,"yes",notifier)
	return wrap_dref_any(dref,type) 
end

manipulators     = deferred_dataref("laminar/B747/debug/manipulators", "number")
electrical     = deferred_dataref("laminar/B747/debug/electrical", "number")
gear     = deferred_dataref("laminar/B747/debug/gear", "number")
com     = deferred_dataref("laminar/B747/debug/com", "number")
hydro     = deferred_dataref("laminar/B747/debug/hydro", "number")
fuel     = deferred_dataref("laminar/B747/debug/fuel", "number")
fltmgmt     = deferred_dataref("laminar/B747/debug/fltmgmt", "number")
fire     = deferred_dataref("laminar/B747/debug/fire", "number")
engines     = deferred_dataref("laminar/B747/debug/engines", "number")
fltctrls     = deferred_dataref("laminar/B747/debug/fltctrls", "number")
antiice     = deferred_dataref("laminar/B747/debug/antiice", "number")
air     = deferred_dataref("laminar/B747/debug/air", "number")
fltinst     = deferred_dataref("laminar/B747/debug/fltinst", "number")
fms     = deferred_dataref("laminar/B747/debug/fms", "number")
autopilot     = deferred_dataref("laminar/B747/debug/autopilot", "number")
safety     = deferred_dataref("laminar/B747/debug/safety", "number")
warning     = deferred_dataref("laminar/B747/debug/warning", "number")
lighting     = deferred_dataref("laminar/B747/debug/lighting", "number")
ai     = deferred_dataref("laminar/B747/debug/ai", "number")