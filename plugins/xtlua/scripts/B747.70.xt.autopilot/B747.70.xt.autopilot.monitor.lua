
local lastmodeswitch=0

function VNAV_CLB(numAPengaged)
    if (simDR_pressureAlt1 < B747BR_cruiseAlt-300 or simDR_pressureAlt1 > B747BR_cruiseAlt+300) and simDR_radarAlt1>400 then 
        if simDR_autopilot_flch_status == 0 and (simDR_autopilot_alt_hold_status == 0 or numAPengaged==0 or B747DR_ap_vnav_state == 1 or B747DR_ap_vnav_state == 3)then
            simCMD_autopilot_flch_mode:once()
            print("flch > 1000 feet climb")
        end 
        if simDR_autopilot_flch_status > 0 or simDR_autopilot_alt_hold_status > 0 then
            B747DR_ap_vnav_state=2
        end
    end
end
function VNAV_CRZ(numAPengaged)

    if (simDR_autopilot_alt_hold_status == 0 and (B747DR_ap_vnav_state == 1)then
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
    print("VNAV_DES " ..diff2.." "..diff3)
end
function VNAV_modeSwitch()
    --if B747BR_cruiseAlt < 10 then return end --no cruise alt set, not needed because cant set to 1 without this
    if B747DR_ap_vnav_state == 0 then return end --not requested 
    local diff=simDRTime-lastmodeswitch
    if diff<0.5 then return end --mode switch at 0.5 second intervals
    
    local numAPengaged = B747DR_ap_cmd_L_mode + B747DR_ap_cmd_C_mode + B747DR_ap_cmd_R_mode

    local dist=B747BR_totalDistance-B747BR_tod

    if dist>50 then
        VNAV_CLB(numAPengaged) --climb to cruise
    elseif dist>0 and B747DR_ap_inVNAVdescent==0 then
        VNAV_CRZ(numAPengaged) --go to alt hold if not in descent
    else
        VNAV_DES(numAPengaged)
    end
    
    
    lastmodeswitch=simDRTime
    
end

function aileronTrim()
    local numAPengaged = B747DR_ap_cmd_L_mode + B747DR_ap_cmd_C_mode + B747DR_ap_cmd_R_mode
    if numAPengaged==0 then return end
    if math.abs(B747DR_capt_ap_roll)>15 then
        simDR_ap_aileron_trim=B747_animate_value(simDR_ap_aileron_trim,B747DR_capt_ap_roll/5,-6,6,1)
    else
        simDR_ap_aileron_trim=B747_animate_value(simDR_ap_aileron_trim,0,-6,6,5)
    end
    print("trim " .. B747DR_capt_ap_roll .. " " .. simDR_ap_aileron_trim)

end

function B747_monitorAP()
    --refresh
    local autothrottlemode=simDR_autopilot_autothrottle_enabled
    local flch_status=simDR_autopilot_flch_status

    VNAV_modeSwitch()
    aileronTrim()
end