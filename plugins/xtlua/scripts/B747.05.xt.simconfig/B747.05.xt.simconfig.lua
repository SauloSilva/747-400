--[[
*****************************************************************************************
* Program Script Name	:	B747.05.xt.simconfig
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
function deferred_command(name,desc,realFunc)
	return replace_command(name,realFunc)
end
--replace deferred_dataref
function deferred_dataref(name,nilType,callFunction)
  if callFunction~=nil then
    print("WARN:" .. name .. " is trying to wrap a function to a dataref -> use xlua")
    end
    return find_dataref(name)
end

dofile("json/json.lua")

--*************************************************************************************--
--** 				        CREATE READ-WRITE CUSTOM DATAREFS                        **--
--*************************************************************************************--
-- Holds all SimConfig options
B747DR_simconfig_data					= deferred_dataref("laminar/B747/simconfig", "string")

--*************************************************************************************--
--** 				        MAIN PROGRAM LOGIC                                       **--
--*************************************************************************************--
simConfig = {}

function simconfig_values()
	return {
			SIM = {
					 kgs_to_lbs = 2.2046226218488,
					 lbs_to_kgs = 0.45359237,
					 weight_display_units = "KGS",  --KGS, LBS
					 irs_align_time = 600,  --Seconds
					 std_pax_weight = 120.0,  --KGS
					 barometric_indicator = 0,  --0 = IN, 1 = HPA
					 barometric_sync = "NO",  --Sync to CAPT
					 auto_fuel_mgmt = "NO",
					 capt_inbd_crt = 1,  --0 = EICAS, 1 = NORM, 2 = PFD
					 capt_lwr_crt = 1,  --0 = EICAS PRI, 1 = NORM, 2 = ND
					 fo_inbd_crt = 1,  --0 = PFD, 1 = NORM, 2 = EICAS
					 fo_lwr_crt = 1,  --0 = ND, 1 = NORM, 2 = EICAS PRI
			},
			PLANE = {
						model = "747-400",  --747-400, 747-400ER, 747-400F
						aircraft_type = "Passenger", --Passenger, Freighter
						engines = "CF6-80C2-B5F",  --PW4056, PW4060, PW4062, CF6-80C2-B1F, CF6-80C2-B5F, CF6-80C2-B1F1, RB211-524G, RB211-524H, RB211-524H8T
						engine_epr = "YES",  --Should be NO for GE engines which use N1 for thrust reference
						airline = "",
						tail_nbr = "",
			},
			FMC = {
					  INIT = {				
								nav_data = "",
								active = "",
								op_program = "",
								drag_ff = "+0.0/-0.0",
					  },
			},
	}
end

--simConfig=simconfig_values()
simConfig["data"]=simconfig_values()

function flight_start()
	B747DR_simconfig_data=json.encode(simConfig["data"]["values"]) --make the simConfig data available to other modules
end
