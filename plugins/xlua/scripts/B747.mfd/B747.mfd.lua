--[[
*****************************************************************************************
* Program Script Name	:	B747.75.MFD
* Author Name			:	Ilias Tselios
*
*   Revisions:
*   -- DATE --	--- REV NO ---		--- DESCRIPTION ---
*   2020-04-03	 	0.01				Start of Dev
*
*
*
*
*****************************************************************************************
*        Copyright 2020 Ilias Tselios
*Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
*associated documentation files (the "Software"), to deal in the Software without restriction, 
*including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
*and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
*subject to the following conditions:
*
*The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
*
*THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
*INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
*IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
*WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
*OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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

MFD_PIXELS = 5.3125
deltaAlt = 0
time_to_tgt = 0
distance_to_tgt = 0

--*************************************************************************************--
--** 				                X-PLANE DATAREFS            			    	 **--
--*************************************************************************************--
altitude_indicated_plt		= find_dataref("sim/cockpit2/gauges/indicators/altitude_ft_pilot")
autopilot_alt_dial 			= find_dataref("sim/cockpit2/autopilot/altitude_dial_ft")
autopilot_alt_vnav_tgt 		= find_dataref("sim/cockpit2/autopilot/altitude_vnav_ft")
vert_speed_indicated_plt	= find_dataref("sim/cockpit2/gauges/indicators/vvi_fpm_pilot")  -- fpm
acf_groundSpeed				= find_dataref("sim/flightmodel/position/groundspeed")	-- m/s
map_range					= find_dataref("sim/cockpit2/EFIS/map_range")	-- 1->6



--*************************************************************************************--
--** 				       READ-WRITE CUSTOM DATAREF HANDLERS     	        	     **--
--*************************************************************************************--



--*************************************************************************************--
--** 				                CUSTOM DATAREFS            			    	     **--
--*************************************************************************************--

B747DR_arc_movement			= create_dataref("laminar/B747/mfd/elements/banana_arc", "number")--, B747DR_arc_movement_DRhandler)


--function calcDist_to_tgtAlt()

--deltaAlt = altitude_indicated_plt - autopilot_alt_dial

--time_to_tgt = (deltaAlt / vert_speed_indicated_plt) / 60			-- hours

--distance_to_tgt = (acf_groundSpeed * 1.944012‬‬) * time_to_tgt

--B747DR_arc_movement = distance_to_tgt * MFD_PIXELS

--log("[B744_DEBUG]: " .. deltaAlt)

--end
function calcDist_to_tgtAlt() 
deltaAlt = altitude_indicated_plt - autopilot_alt_dial

time_to_tgt = (deltaAlt / vert_speed_indicated_plt) / 60			-- hours

distance_to_tgt = (acf_groundSpeed * 1.944012‬‬) * time_to_tgt

B747DR_arc_movement = distance_to_tgt * MFD_PIXELS

log("[B744_DEBUG]: " .. deltaAlt)
end


function after_physics()

 --B747DR_arc_movement_DRhandler

   calcDist_to_tgtAlt()

end





