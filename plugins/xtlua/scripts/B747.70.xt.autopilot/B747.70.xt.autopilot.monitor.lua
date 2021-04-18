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


function VNAV_NEXT_ALT(numAPengaged,fms)
    local began=false
    local targetAlt=simDR_autopilot_altitude_ft
    local targetIndex=0
    local currentIndex=0
    local dist_to_TOD=(B747BR_totalDistance-B747BR_tod)
    for i=1,table.getn(fms),1 do
      --print("FMS j="..fmsJSON)
      
      if fms[i][10]==true then
        began=true
        currentIndex=i
        local nextDistance=getDistance(simDR_latitude,simDR_longitude,fms[i][5],fms[i][6])
        if nextDistance>dist_to_TOD and dist_to_TOD>50 and B747BR_cruiseAlt>0 then
          targetAlt=B747BR_cruiseAlt
          targetIndex=i
          break 
        end
        if fms[i][9]>0 and fms[i][2] ~= 1 then 
          targetAlt=fms[i][9]
          targetIndex=i
          break 
        end
        elseif began==true then
          local nextDistance=getDistance(simDR_latitude,simDR_longitude,fms[i][5],fms[i][6])
          if nextDistance>dist_to_TOD and dist_to_TOD>50 and B747BR_cruiseAlt>0 then
          targetAlt=B747BR_cruiseAlt
          targetIndex=i
          break 
        end
        if B747BR_totalDistance>0 and dist_to_TOD>50 and (nextDistance)>dist_to_TOD then 
          break 
        end
        
        if fms[i][9]>0 and fms[i][2] ~= 1 then targetAlt=fms[i][9] targetIndex=i break end
      end
    end
    B747DR_fmstargetIndex=targetIndex
    B747DR_ap_vnav_target_alt=targetAlt
    return targetAlt
end

function VNAV_CLB_ALT(numAPengaged,fms)
    local targetAlt=VNAV_NEXT_ALT(numAPengaged,fms)
    local lastHold=simDRTime-B747DR_mcp_hold_pressed
    if targetAlt>B747DR_autopilot_altitude_ft and simDR_pressureAlt1<B747DR_autopilot_altitude_ft+100 and lastHold>30 then
        targetAlt=B747DR_autopilot_altitude_ft
    end
    local mcpDiff=simDR_pressureAlt1-B747DR_autopilot_altitude_ft
    if simDR_autopilot_alt_hold_status==2 and targetAlt==B747DR_autopilot_altitude_ft and (mcpDiff<1000 and mcpDiff>-1000)  and lastHold>30 and lastHold>30 and B747BR_cruiseAlt>B747DR_autopilot_altitude_ft+1000 then
        B747DR_mcp_hold=1
    end 
    if B747DR_mcp_hold==0 then simDR_autopilot_altitude_ft=targetAlt end

    --print("VNAV_CLB_ALT ".. simDR_autopilot_altitude_ft .. " "  .. targetAlt .. " ")
end

function VNAV_CLB(numAPengaged,fmsO)
    VNAV_CLB_ALT(numAPengaged,fmsO)

    if B747DR_mcp_hold==1 then return end

    local start=B747DR_fmscurrentIndex
    local waypointAlt=fmsO[start][9]
    if waypointAlt==0 then waypointAlt=B747DR_autopilot_altitude_ft end
    local waypointDiff=waypointAlt-simDR_pressureAlt1
    local mcpDiff=simDR_pressureAlt1-B747DR_autopilot_altitude_ft

    --print("VNAV_CLB "..waypointDiff .. " " .. mcpDiff.. " " .. waypointAlt .. " " .. start.. " " .. fmsO[start][9].. " " .. simDR_pressureAlt1) 
    if simDR_autopilot_alt_hold_status==2 and (waypointDiff>1000 and (mcpDiff>1000 or mcpDiff<-1000)) then
        setVNAVState("vnavcalcwithTargetAlt",0)
		if getVNAVState("manualVNAVspd")==0 then
		    setVNAVState("gotVNAVSpeed",false)
		    B747_vnav_speed()    
		end
        B747DR_ap_vnav_state = 3 --resume
        --computeVNAVAlt(fmsO)
        print("UPDATE VNAV_CLB "..waypointDiff .. " " .. mcpDiff.. " " .. waypointAlt .. " " .. start.. " " .. fmsO[start][9].. " " .. simDR_pressureAlt1) 
    end
    if (simDR_pressureAlt1 < B747BR_cruiseAlt-300 or simDR_pressureAlt1 > B747BR_cruiseAlt+300) and simDR_radarAlt1>400 then 
        if simDR_autopilot_flch_status == 0 and 
        (simDR_autopilot_alt_hold_status == 0 or numAPengaged==0 or B747DR_ap_vnav_state == 1 or B747DR_ap_vnav_state == 3
           -- or (waypointDiff>1000 and (mcpDiff>1000 or mcpDiff<-1000))
        ) then
            --if (simDR_allThrottle>=0.94) then
                simCMD_autopilot_flch_mode:once()
                if B747DR_ap_vnav_state==0 then B747DR_ap_thrust_mode=2 end
                B747DR_engine_TOGA_mode = 0 
                B747DR_ap_autoland=-1
                print("flch > 1000 feet climb ")  
            --end 
        end
        if simDR_autopilot_flch_status > 0 or simDR_autopilot_alt_hold_status > 0 then
            --print("VNAV_CLB simDR_autopilot_flch_status > 0")  
            B747DR_ap_vnav_state=2
        end
    elseif (simDR_pressureAlt1 >= B747BR_cruiseAlt-300 or simDR_pressureAlt1 <= B747BR_cruiseAlt+300) and simDR_radarAlt1>400 then 
        if (simDR_autopilot_alt_hold_status == 0 and (numAPengaged==0 or B747DR_ap_vnav_state == 1 or B747DR_ap_vnav_state == 3)) then
            simCMD_autopilot_alt_hold_mode:once()
            print("alt hold +/-300 feet cruise")
        end 
        if simDR_autopilot_flch_status > 0 or simDR_autopilot_alt_hold_status > 0 then
            --print("at cruise")  
            B747DR_ap_vnav_state=2
        end
    end

    
end
function VNAV_CRZ(numAPengaged)
    print("VNAV_CRZ alt hold") 
    if simDR_autopilot_alt_hold_status == 0 and B747DR_ap_vnav_state == 1 then
        simCMD_autopilot_alt_hold_mode:once()
        print("alt hold < 50nm from TOD")
    end 
    if simDR_autopilot_alt_hold_status > 0 then
       -- print("VNAV_CRZ alt hold")  
        B747DR_ap_vnav_state=2
    end
    
end
function VNAV_DES_ALT(numAPengaged,fms)
    local targetAlt=VNAV_NEXT_ALT(numAPengaged,fms)
    local lastHold=simDRTime-B747DR_mcp_hold_pressed
    
    if targetAlt<B747DR_autopilot_altitude_ft and simDR_pressureAlt1>B747DR_autopilot_altitude_ft-100 and lastHold>30 then
        targetAlt=B747DR_autopilot_altitude_ft
    end
    local mcpDiff=simDR_pressureAlt1-B747DR_autopilot_altitude_ft
    if simDR_autopilot_alt_hold_status==2 and targetAlt==B747DR_autopilot_altitude_ft and (mcpDiff<1000 and mcpDiff>-1000)  then
        B747DR_mcp_hold=1
    end 
    if B747DR_mcp_hold==0 then simDR_autopilot_altitude_ft=targetAlt end
end
function VNAV_DES(numAPengaged,fms)
    VNAV_DES_ALT(numAPengaged,fms)
    local diff2 = simDR_autopilot_altitude_ft - simDR_pressureAlt1
    local diff3 = B747DR_autopilot_altitude_ft- simDR_pressureAlt1
    local lastHold=simDRTime-B747DR_mcp_hold_pressed
    --print("VNAV_DES B747DR_ap_inVNAVdescent=" .. " "..B747DR_ap_inVNAVdescent.. " "..diff2.. " "..diff3.. " "..B747DR_ap_vnav_state.. " " .. B747DR_mcp_hold)
    if simDR_autopilot_vs_status == 0 then
        B747DR_ap_inVNAVdescent = 0
    end

    if B747DR_mcp_hold==1 then return end
    --Past TOD and MCP ALT at current alt - activate VNAV ALT
    if B747DR_ap_inVNAVdescent ==0 and diff2<=0 and (diff3>=-500 and diff3<=500)
            and B747BR_totalDistance>0 and B747BR_totalDistance-B747BR_tod<=0
            and simDR_autopilot_vs_status == 0 
            and simDR_radarAlt1>1000 
            and lastHold>30 then
        B747DR_mcp_hold=1
        
        print("set B747DR_mcp_hold")
        return 
    end

    --Not started descent, not in VNAV ALT, past TOD, begin descending
    if B747DR_ap_inVNAVdescent ==0 and diff2<=0 and (diff3<=-500 or diff3>=500) 
            and B747BR_totalDistance>0 and B747BR_totalDistance-B747BR_tod<=0
            and simDR_autopilot_vs_status == 0 
            and simDR_radarAlt1>1000 
                 then
            B747DR_ap_inVNAVdescent =1
        print("Begin descent")
        getDescentTarget()
    end
    if B747DR_ap_inVNAVdescent ==1 and diff2<=0 and (diff3<=-500 or diff3>=500) and simDR_autopilot_vs_status == 0 and simDR_radarAlt1>1000 then
        if simDR_autopilot_gs_status < 1 then 
            simCMD_autopilot_vert_speed_mode:once()
            print("Resume descent")
        end
    end
    local spdval=tonumber(getFMSData("desspd"))
    local forceOn=false
    if B747DR_ap_ias_dial_value<=spdval and simDR_autopilot_airspeed_is_mach==0 then forceOn=true end

    if B747DR_ap_inVNAVdescent >0 and simDR_autopilot_autothrottle_enabled == 1 and simDR_allThrottle<0.02 and forceOn==false then							-- AUTOTHROTTLE IS "ON"
        simCMD_autopilot_autothrottle_off:once()									-- DEACTIVATE THE AUTOTHROTTLE
        B747DR_ap_inVNAVdescent =1
        print("fix idle throttle")
        return
    elseif simDR_autopilot_autothrottle_enabled == 0 and (simDR_ind_airspeed_kts_pilot<B747DR_airspeed_Vmc+15 or forceOn==true) and B747DR_toggle_switch_position[29] == 1 then
        simCMD_autopilot_autothrottle_on:once()
        print("fix idle throttle to climb/maintain")
        return
    end

    if simDR_autopilot_vs_status == 2 and B747DR_fmstargetIndex>2 then
        setDescentVSpeed()
    end

    B747DR_ap_vnav_state=2
end
local last_THR_REF=0

function B747_monitor_THR_REF_AT()
    
    if B747DR_ap_FMA_autothrottle_mode~=5 or B747DR_toggle_switch_position[29] ~= 1 then return end
    
    local n1_pct=math.max(simDR_engine_N1_pct[0],simDR_engine_N1_pct[1],simDR_engine_N1_pct[2],simDR_engine_N1_pct[3])
    local lastChange=simDRTime-last_THR_REF

    

    --[[if lastChange>1 or lastChange<-1 then return end --wait for engines to stabilise
    if lastChange==0 and needNew==true then return end --wait for engines to stabilise, wait for update N1]]
    local ref_throttle=100
    local altDiff = simDR_autopilot_altitude_ft - simDR_pressureAlt1
    local timediff=simDRTime-B747DR_ap_lastCommand
    if B747DR_ap_thrust_mode==2 and altDiff<0 then
        ref_throttle=math.floor(20+B747_rescale(-10000,0,0,30,altDiff))
        print("THR REF descend at ref_throttle "..ref_throttle.." altDiff "..altDiff)
    elseif simDR_radarAlt1<1000 and B747DR_ap_thrust_mode<3 then
        if toderate==1 then ref_throttle=96
        elseif toderate==2 then ref_throttle=86  
        end      
    else
        if B747DR_ap_thrust_mode==0 and timediff>0.5 then 
            print("B747DR_ap_thrust_mode =1 @ "..timediff)
            B747DR_ap_thrust_mode=1 
        end
        if clbderate==1 then ref_throttle=96
        elseif clbderate==2 then ref_throttle=86
        end 
    end
    
    
    local wait=0
    local thrustDiff=ref_throttle-n1_pct
    if (thrustDiff<0) then
        thrustDiff=thrustDiff*-1
    end
    if thrustDiff<2 then wait=0.2
    elseif thrustDiff<10 then wait=0.1
    elseif thrustDiff<20 then wait=0.05 end
    --print("THR REF="..ref_throttle.. " simDR_allThrottle="..n1_pct.. " wait="..wait.. " B747DR_ap_thrust_mode="..B747DR_ap_thrust_mode)
    if lastChange<wait then return end --wait for engines to stabilise
    if simDR_autopilot_autothrottle_enabled == 1 and timediff>0.5 then B747DR_ap_thrust_mode=0 return end
    if (n1_pct < (ref_throttle-0.2)) and simDR_allThrottle<1.0 then
	    simCMD_ThrottleUp:once()
    elseif (n1_pct > (ref_throttle+0.2)) and simDR_allThrottle>0.0 then
        simCMD_ThrottleDown:once()
    end
    last_THR_REF=simDRTime
end
function VNAV_modeSwitch(fmsO)
    --if B747BR_cruiseAlt < 10 then return end --no cruise alt set, not needed because cant set to 1 without this
    if B747DR_ap_vnav_state == 0 then  
        B747_monitor_THR_REF_AT() 
        return 
    end --not requested 
    local dist=B747BR_totalDistance-B747BR_tod
    
    if B747DR_ap_inVNAVdescent >0 and simDR_autopilot_autothrottle_enabled == 0 and B747DR_toggle_switch_position[29] == 1 and simDR_allThrottle>0 and simDR_radarAlt1>1000 then
        simCMD_ThrottleDown:once()
    else
        B747_monitor_THR_REF_AT()
    end

    local diff=simDRTime-B747DR_ap_lastCommand
    if diff<0.5 then return end --mode switch at 0.5 second intervals
    
    local numAPengaged = B747DR_ap_cmd_L_mode + B747DR_ap_cmd_C_mode + B747DR_ap_cmd_R_mode

    

    if dist>50 then
        VNAV_CLB(numAPengaged,fmsO) --climb to cruise
    elseif dist>0 and B747DR_ap_inVNAVdescent==0 then
        VNAV_CRZ(numAPengaged) --go to alt hold if not in descent
    else
        VNAV_DES(numAPengaged,fmsO)
    end
    B747DR_ap_lastCommand=simDRTime
    
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
function toBits(num)
    -- returns a table of bits, least significant first.
    local t={} -- will contain the bits
    while num>0 do
        rest=math.fmod(num,2)
        t[#t+1]=rest
        num=(num-rest)/2
    end
    return t
end
--custom autothrottle for THR REF

function B747_monitorAT()
    local diff=simDRTime-B747DR_ap_lastCommand
    if diff<0.5 then return end --mode switch at 0.5 second intervals
    --make sure autothrottle is in the correct mode for the FMA
    --[[local ap_state=toBits(simDR_autopilot_state)
    local fmsArm=0
    local fmsactive=0
    if table.getn(ap_state) >=13 then fmsArm=ap_state[13] end 
    if table.getn(ap_state) >=14 then fmsactive=ap_state[14] end ]]
    --[[print("A/T " .. simDR_autopilot_autothrottle_enabled.. " ap_state "..simDR_autopilot_state
    .. " FMS ARM "..fmsArm
    .. " FMS ACTIVE "..fmsactive
    .. " course "..simDR_autopilot_course
    .. " type "..simDR_autopilot_destination_type
    .. " index "..simDR_autopilot_destination_index)]]
    --disconnects if 2 more more (more than one) engine inop
    local numRun=0;
    if simDR_engine_N1_pct[0]>15.0 then numRun=numRun+1 end
    if simDR_engine_N1_pct[1]>15.0 then numRun=numRun+1 end
    if simDR_engine_N1_pct[2]>15.0 then numRun=numRun+1 end
    if simDR_engine_N1_pct[3]>15.0 then numRun=numRun+1 end

    if numRun<3 or B747DR_autothrottle_fail==1 then 
        if simDR_autopilot_autothrottle_enabled==1 then
            print("2+ engines inop or fail AT")
            simCMD_autopilot_autothrottle_off:once()
        end
        B747DR_autothrottle_fail=1
        B747DR_engine_TOGA_mode = 0 
        B747DR_ap_lastCommand=simDRTime
        return 
    end

    --AT OFF
    if B747DR_toggle_switch_position[29] == 0 then 
        if simDR_autopilot_autothrottle_enabled==1 then
            print("AT off")
            simCMD_autopilot_autothrottle_off:once()
        end
        B747DR_ap_lastCommand=simDRTime
        return 
    end

    --ALT/VS/GS
    if simDR_autopilot_alt_hold_status == 2 then
        
        if simDR_autopilot_autothrottle_enabled==0 then
            print("simDR_autopilot_alt_hold_status")
            B747DR_ap_thrust_mode=0
            simCMD_autopilot_autothrottle_on:once()
            
        end
        B747DR_ap_lastCommand=simDRTime
        return 
    end
    if (B747DR_ap_FMA_active_pitch_mode == 9 
    or B747DR_ap_FMA_active_pitch_mode == 7) and B747DR_ap_vnav_state > 0
    or B747DR_ap_FMA_active_pitch_mode == 2 then
        if simDR_autopilot_autothrottle_enabled==0 then
            print("B747DR_ap_FMA_active_pitch_mode")
            simCMD_autopilot_autothrottle_on:once()
        end
        B747DR_ap_thrust_mode=0
        B747DR_ap_lastCommand=simDRTime
        return 
    end
    if B747DR_ap_FMA_autothrottle_mode == 3 then -- SPD
        B747DR_ap_lastCommand=simDRTime
        return 
    end
    --otherwise off  (VNAV ONLY)
    if simDR_autopilot_autothrottle_enabled==1 and B747DR_ap_inVNAVdescent == 0 and (B747DR_ap_vnav_state>0 or B747DR_ap_FMA_autothrottle_mode == 5) then
        print("Off with B747DR_ap_FMA_active_pitch_mode="..B747DR_ap_FMA_active_pitch_mode)
        simCMD_autopilot_autothrottle_off:once()
    end
    B747DR_ap_lastCommand=simDRTime
    
    
    

end
function B747_updateApproachHeading(fmsO)
    
    local start=B747DR_fmscurrentIndex
    if fmsO[start]==nil then
        --print("empty data "..start)
        return
      end
    local ap2Heading=getHeading(simDR_latitude,simDR_longitude,fmsO[start][5],fmsO[start][6])
    if B747DR_ap_approach_mode==1 and B747DR_ap_lnav_state>0 then
        simDR_autopilot_heading_deg =	ap2Heading+simDR_variation
    end
end

function B747_monitorAP(fmsO)
    --refresh
    local autothrottlemode=simDR_autopilot_autothrottle_enabled
    local flch_status=simDR_autopilot_flch_status
    local vs_status=simDR_autopilot_vs_status
    VNAV_modeSwitch(fmsO)
    LNAV_modeSwitch()
    aileronTrim()
    B747_monitorAT()
    B747_updateApproachHeading(fmsO)
end