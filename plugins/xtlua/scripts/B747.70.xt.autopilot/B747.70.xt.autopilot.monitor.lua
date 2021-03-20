
local lastmodeswitch=0
function VNAV_modeSwitch()
    --if B747BR_cruiseAlt < 10 then return end --no cruise alt set, not needed because cant set to 1 without this
    if B747DR_ap_vnav_state == 0 then return end --not requested 
    local diff=simDRTime-lastmodeswitch
    if diff<0.5 then return end --mode switch at 0.5 second intervals
    
    local numAPengaged = B747DR_ap_cmd_L_mode + B747DR_ap_cmd_C_mode + B747DR_ap_cmd_R_mode

    if simDR_pressureAlt1 < B747BR_cruiseAlt-1000 and simDR_radarAlt1>400 then 
        if simDR_autopilot_flch_status == 0 and (simDR_autopilot_alt_hold_status == 0 or numAPengaged==0 or B747DR_ap_vnav_state == 1 or B747DR_ap_vnav_state == 3)then
            simCMD_autopilot_flch_mode:once()
            print("flch > 1000 feet climb")
        end 
        if simDR_autopilot_flch_status > 0 or simDR_autopilot_alt_hold_status > 0 then
            B747DR_ap_vnav_state=2
        end
    end
    
    lastmodeswitch=simDRTime
    
end

function B747_monitorAP()
    --refresh
    local autothrottlemode=simDR_autopilot_autothrottle_enabled
    local flch_status=simDR_autopilot_flch_status

    VNAV_modeSwitch()

end