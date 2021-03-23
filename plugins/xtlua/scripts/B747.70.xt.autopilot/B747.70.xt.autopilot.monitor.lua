--[[
*****************************************************************************************
* Program Script Name	:	B747.70.autopilot.monitor
* Author Name			:	Mark Parker (mSparks)
*
*   Revisions:
*   -- DATE --	--- REV NO ---		--- DESCRIPTION ---
*   2021-03-23	0.01a				Start of Dev
*
*
*
*
--]]

local lastmodeswitch=0

function VNAV_CLB(numAPengaged)
    if (simDR_pressureAlt1 < B747BR_cruiseAlt-300 or simDR_pressureAlt1 > B747BR_cruiseAlt+300) and simDR_radarAlt1>400 then 
        if simDR_autopilot_flch_status == 0 and (simDR_autopilot_alt_hold_status == 0 or numAPengaged==0 or B747DR_ap_vnav_state == 1 or B747DR_ap_vnav_state == 3) then
            simCMD_autopilot_flch_mode:once()
            print("flch > 1000 feet climb")
        end
        if simDR_autopilot_flch_status > 0 or simDR_autopilot_alt_hold_status > 0 then
            B747DR_ap_vnav_state=2
        end
    elseif (simDR_pressureAlt1 >= B747BR_cruiseAlt-300 or simDR_pressureAlt1 <= B747BR_cruiseAlt+300) and simDR_radarAlt1>400 then 
        if (simDR_autopilot_alt_hold_status == 0 and (numAPengaged==0 or B747DR_ap_vnav_state == 1 or B747DR_ap_vnav_state == 3)) then
            simCMD_autopilot_alt_hold_mode:once()
            print("alt hold +/-300 feet cruise")
        end 
        if simDR_autopilot_flch_status > 0 or simDR_autopilot_alt_hold_status > 0 then
            B747DR_ap_vnav_state=2
        end
    end

    
end
function VNAV_CRZ(numAPengaged)

    if simDR_autopilot_alt_hold_status == 0 and B747DR_ap_vnav_state == 1 then
        simCMD_autopilot_alt_hold_mode:once()
        print("alt hold < 50nm from TOD")
    end 
    if simDR_autopilot_alt_hold_status > 0 then
        B747DR_ap_vnav_state=2
    end
    
end
function VNAV_DES(numAPengaged)
    local diff2 = simDR_autopilot_altitude_ft - simDR_pressureAlt1
    local diff3 = B747DR_autopilot_altitude_ft- simDR_pressureAlt1
    --print("VNAV_DES " ..diff2.." "..diff3)
    B747DR_ap_vnav_state=2
end
function VNAV_modeSwitch()
    --if B747BR_cruiseAlt < 10 then return end --no cruise alt set, not needed because cant set to 1 without this
    if B747DR_ap_vnav_state == 0 then return end --not requested 
    local dist=B747BR_totalDistance-B747BR_tod
    if B747DR_ap_FMA_autothrottle_mode==5 and simDR_allThrottle<0.94 and dist>50 then
	    simCMD_ThrottleUp:once()--simDR_allThrottle = B747_set_animation_position(simDR_allThrottle,0.95,0,1,1)
    end
    local diff=simDRTime-lastmodeswitch
    if diff<0.5 then return end --mode switch at 0.5 second intervals
    
    local numAPengaged = B747DR_ap_cmd_L_mode + B747DR_ap_cmd_C_mode + B747DR_ap_cmd_R_mode

    

    if dist>50 then
        VNAV_CLB(numAPengaged) --climb to cruise
    elseif dist>0 and B747DR_ap_inVNAVdescent==0 then
        VNAV_CRZ(numAPengaged) --go to alt hold if not in descent
    else
        VNAV_DES(numAPengaged)
    end
    
    
    lastmodeswitch=simDRTime
    
end
function LNAV_modeSwitch()
    --[[print("Nav status "..simDR_autopilot_nav_status)
    print("Heading status "..simDR_autopilot_heading_status)
    print("Roll status "..simDR_autopilot_roll_status)
    print("sync_degrees "..simDR_autopilot_roll_sync_degrees)
    print("ap_state "..simDR_autopilot_state)]]
end 
function aileronTrim()
    local numAPengaged = B747DR_ap_cmd_L_mode + B747DR_ap_cmd_C_mode + B747DR_ap_cmd_R_mode
    if numAPengaged==0 then return end
    --Flight envelope protection
    if math.abs(B747DR_capt_ap_roll)>15 and math.abs(simDR_capt_roll)>15 then
        simDR_ap_aileron_trim=B747_animate_value(simDR_ap_aileron_trim,B747DR_capt_ap_roll/5,-6,6,1)
    else
        simDR_ap_aileron_trim=B747_animate_value(simDR_ap_aileron_trim,0,-6,6,5)
    end
    --print("trim " .. B747DR_capt_ap_roll .. " " .. simDR_ap_aileron_trim)

end
function B747_monitorAT()
    local diff=simDRTime-lastatmodeswitch
    if diff<0.5 then return end --mode switch at 0.5 second intervals
    --make sure autothrottle is in the correct mode for the FMA
    print("A/T " .. simDR_autopilot_autothrottle_enabled)
    --disconnects if 2 more more (more than one) engine inop
    local numRun=0;
    if simDR_engine_N1_pct[0]>15.0 then numRun=numRun+1 end
    if simDR_engine_N1_pct[1]>15.0 then numRun=numRun+1 end
    if simDR_engine_N1_pct[2]>15.0 then numRun=numRun+1 end
    if simDR_engine_N1_pct[3]>15.0 then numRun=numRun+1 end

    if numRun<3 then 
        if simDR_autopilot_autothrottle_enabled==1 then
            print("2+ engines imop")
            simCMD_autopilot_autothrottle_off:once()
        end
        lastatmodeswitch=simDRTime
        return 
    end

    --AT OFF
    if B747DR_toggle_switch_position[29] == 0 then 
        if simDR_autopilot_autothrottle_enabled==1 then
            print("AT off")
            simCMD_autopilot_autothrottle_off:once()
        end
        lastatmodeswitch=simDRTime
        return 
    end

    --ALT/VS/GS
    if simDR_autopilot_alt_hold_status == 2 then
        
        if simDR_autopilot_autothrottle_enabled==0 then
            print("simDR_autopilot_alt_hold_status")
            simCMD_autopilot_autothrottle_on:once()
        end
        lastatmodeswitch=simDRTime
        return 
    end
    if (B747DR_ap_FMA_active_pitch_mode == 9 
    or B747DR_ap_FMA_active_pitch_mode == 7 
    or B747DR_ap_FMA_active_pitch_mode == 2) then
        if simDR_autopilot_autothrottle_enabled==0 then
            print("B747DR_ap_FMA_active_pitch_mode")
            simCMD_autopilot_autothrottle_on:once()
        end
        lastatmodeswitch=simDRTime
        return 
    end
    if B747DR_ap_FMA_autothrottle_mode == 3 then -- SPD
        lastatmodeswitch=simDRTime
        return 
    end
    --otherwise off
    if simDR_autopilot_autothrottle_enabled==1 then
        print("Off with B747DR_ap_FMA_active_pitch_mode="..B747DR_ap_FMA_active_pitch_mode)
        simCMD_autopilot_autothrottle_off:once()
    end
    lastatmodeswitch=simDRTime
    
    
    

end
function B747_monitorAP()
    --refresh
    local autothrottlemode=simDR_autopilot_autothrottle_enabled
    local flch_status=simDR_autopilot_flch_status

    VNAV_modeSwitch()
    LNAV_modeSwitch()
    aileronTrim()
    B747_monitorAT()
end