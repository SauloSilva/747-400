--[[
****************************************************************************************
* Program Script Name	:	B747.42.xt.EEC.RR.lua
* Author Name			:	Marauder28
*                           (with SIGNIFICANT contributions from @kudosi for aeronautic formulas)
*   Revisions:
*   -- DATE --	--- REV NO ---		--- DESCRIPTION ---
*   2021-01-11	0.01a				Start of Dev
*	2021-05-27	0.1				    Initial Release
*
*
*
*****************************************************************************************
]]

function RR(altitude_ft_in)
    
    for i = 0, 3 do
        B747DR_display_N1[i]=simDR_engine_N1_pct[i]
        B747DR_display_N2[i]=simDR_engine_N2_pct[i]
        B747DR_display_EPR[i]=simDR_engine_EPR[i]
        B747DR_display_EGT[i]=simDR_engn_EGT_c[i]
        B747DR_throttle_resolver_angle[i]=simDR_throttle_ratio[i]
    end
    --[[local EPR = 0.0

    EPR = (-0.0000232 * mach^2 + 0.0000147 * mach + 0.0000144) * (thrust_N_in / 1000)^2 + (0.000998 * mach^2 + 0.00272 * mach - 0.00165)
            * (thrust_N_in / 1000) + (-0.2565 * mach^2 - 0.3269 * mach + 1.1644)

    
    print("EPR - Thrust IN = ", thrust_N_in)
    print("EPR = ", EPR)

    return EPR]]
end