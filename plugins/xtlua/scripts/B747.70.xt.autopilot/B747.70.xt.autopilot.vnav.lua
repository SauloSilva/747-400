--[[
*****************************************************************************************
* Program Script Name	:	B747.70.autopilot.vnav
* Author Name			:	Mark Parker (mSparks)
*
*   Revisions:
*   -- DATE --	--- REV NO ---		--- DESCRIPTION ---
*   2021-01-27	0.01a				Start of Dev
*
*
*
*
--]]

local vnavSPD_conditions={}
local vnavSPD_state={}
vnavSPD_conditions["onground"]=0
vnavSPD_conditions["below"]=-1
vnavSPD_conditions["above"]=-1
vnavSPD_conditions["name"]="unknown"
vnavSPD_state["targetSpd"]=180
vnavSPD_state["targetAlt"]=5000
vnavSPD_state["targetVS"]=0 --descend, hold climb
vnavSPD_state["targetAltHold"]=false
vnavSPD_state["spdIsMach"]=false
vnavSPD_state["manualVNAVspd"]=0
vnavSPD_state["vnavcalcwithMCPAlt"]=0
vnavSPD_state["vnavcalcwithTargetAlt"]=0
vnavSPD_state["gotVNAVSpeed"]=false
vnavSPD_state["recalcAfter"]=0

function setVNAVState(name,value)
    vnavSPD_state[name]=value
end
function getVNAVState(name)
    return vnavSPD_state[name]
end
function B747_update_vnav_speed()
    if simDR_onGround~=vnavSPD_conditions["onground"] then gotVNAVSpeed=false end
    if vnavSPD_conditions["above"]>0 and vnavSPD_conditions["above"]<simDR_pressureAlt1 then 
      print("above "..vnavSPD_conditions["above"].. " " ..vnavSPD_conditions["name"])
      gotVNAVSpeed=false 
    end
    if vnavSPD_conditions["descent"]==(B747DR_ap_inVNAVdescent>0) then 
       print("descent "..B747DR_ap_inVNAVdescent.. " " ..vnavSPD_conditions["name"])
      gotVNAVSpeed=false 
    end
    if vnavSPD_conditions["below"]>0 and vnavSPD_conditions["below"]>simDR_pressureAlt1 then 
       print("below "..vnavSPD_conditions["below"].. " " ..vnavSPD_conditions["name"])
      gotVNAVSpeed=false 
    end
    if vnavSPD_conditions["crzAlt"]~=B747BR_cruiseAlt then 
       print("new crzAlt")
      gotVNAVSpeed=false 
    end
    if vnavSPD_conditions["crzSpd"]~=getFMSData("crzspd") then 
       print("new crzSpd")
      gotVNAVSpeed=false 
    end
  end
  function B747_vnav_speed()
    if B747DR_ap_vnav_state==0 then return end
    if manualVNAVspd==1 then return end
    B747_update_vnav_speed()
    if gotVNAVSpeed==true then return end
    --print("updating speed")
  
    if simDR_onGround==1 then
      
      if B747DR_airspeed_V2<999 then
        simDR_autopilot_airspeed_is_mach = 0  
        B747DR_ap_ias_dial_value = math.min(399.0, B747DR_airspeed_V2 + 10)
        B747DR_switchingIASMode=1
        B747DR_lastap_dial_airspeed=B747DR_ap_ias_dial_value
        run_after_time(B747_updateIAS, 0.25)
        
        vnavSPD_conditions["onground"]=1
        vnavSPD_conditions["descent"]=true
        vnavSPD_conditions["name"]="on ground"
        vnavSPD_conditions["crzAlt"]=B747BR_cruiseAlt
        vnavSPD_conditions["crzSpd"]=getFMSData("crzspd")
        gotVNAVSpeed=true
        vnavSPD_state["targetSpd"]=B747DR_ap_ias_dial_value
        vnavSPD_state["targetAlt"]=B747BR_cruiseAlt
        vnavSPD_state["targetVS"]=1 --descend, hold climb
        vnavSPD_state["targetAltHold"]=false
        vnavSPD_state["spdIsMach"]=false
        print("updated speed simDR_onGround")
      end
    else --not on the ground
      local altval=tonumber(getFMSData("clbrestalt"))
      local spdval=tonumber(getFMSData("clbrestspd"))
     
      if B747DR_ap_inVNAVdescent ==0 and altval~=nil and spdval~=nil and simDR_pressureAlt1<=altval  then 
        vnavSPD_conditions["above"]=altval+500
        vnavSPD_conditions["below"]=-1
        vnavSPD_conditions["descent"]=true
        vnavSPD_conditions["onground"]=simDR_onGround
        simDR_autopilot_airspeed_is_mach = 0
        print("convert to clb clbrestspd ".. spdval)
        B747DR_ap_ias_dial_value = math.min(399.0, spdval)
        B747DR_switchingIASMode=1
        B747DR_lastap_dial_airspeed=B747DR_ap_ias_dial_value
        run_after_time(B747_updateIAS, 0.25)
        vnavSPD_conditions["name"]="<clbrestalt"
        vnavSPD_conditions["crzAlt"]=B747BR_cruiseAlt
        vnavSPD_conditions["crzSpd"]=getFMSData("crzspd")
        vnavSPD_state["targetSpd"]=B747DR_ap_ias_dial_value
        vnavSPD_state["targetAlt"]=B747BR_cruiseAlt
        vnavSPD_state["targetVS"]=1 --descend, hold climb
        vnavSPD_state["targetAltHold"]=false
        vnavSPD_state["spdIsMach"]=false
        gotVNAVSpeed=true
        return
      end
      
      spdval=tonumber(getFMSData("clbspd"))
      local spdtransalt=tonumber(getFMSData("spdtransalt"))
      local above = spdtransalt
      local transalt=tonumber(getFMSData("transalt"))
      if transalt<spdtransalt then above= transalt end
      
      local altval3=tonumber(getFMSData("desrestalt"))
      if B747DR_ap_inVNAVdescent ==0 and altval~=nil and spdval~=nil and spdtransalt~=nil and simDR_pressureAlt1>=altval and simDR_pressureAlt1<above  then 
        
        vnavSPD_conditions["above"]=above
        vnavSPD_conditions["below"]=altval3
        vnavSPD_conditions["descent"]=true
        vnavSPD_conditions["onground"]=simDR_onGround
        vnavSPD_conditions["name"]=">clbrestalt <spdtransalt"
        vnavSPD_conditions["crzAlt"]=B747BR_cruiseAlt
        vnavSPD_conditions["crzSpd"]=getFMSData("crzspd")
        B747DR_switchingIASMode=1
        crzspdval=tonumber(getFMSData("crzspd"))/10
        if simDR_airspeed_mach > (crzspdval/100) then
      print("convert to cruise speed in clb".. crzspdval)
      simDR_autopilot_airspeed_is_mach = 1
      B747DR_ap_ias_dial_value = crzspdval
      B747DR_lastap_dial_airspeed=crzspdval*0.01
        else
      simDR_autopilot_airspeed_is_mach = 0
      print("convert to clb speed ".. spdval)
      B747DR_ap_ias_dial_value = math.min(399.0, spdval)
      B747DR_lastap_dial_airspeed=B747DR_ap_ias_dial_value
        end
        run_after_time(B747_updateIAS, 0.25)
        gotVNAVSpeed=true
        return
      end
      
      
      altval3=tonumber(getFMSData("desspdtransalt"))
      spdval=tonumber(getFMSData("transpd"))
      
      if tonumber(string.sub(getFMSData("crzalt"),3))~=nil then
        altval=tonumber(getFMSData("transalt"))
        
        altval2=(tonumber(string.sub(getFMSData("crzalt"),3))*100)-1000
        local above=altval2
        
        if B747DR_ap_inVNAVdescent ==0 and spdval~=nil and altval~=nil and simDR_pressureAlt1>=altval and (B747DR_efis_baro_std_capt_switch_pos==0 or B747DR_efis_baro_std_fo_switch_pos==0)  then 
      if simDR_pressureAlt1<=spdtransalt then above=spdtransalt end
      vnavSPD_conditions["above"]=simDR_pressureAlt1+500
      if simDR_pressureAlt1<=altval3 then 
        vnavSPD_conditions["below"]=simDR_pressureAlt1-1000
      else
        vnavSPD_conditions["below"]=altval3
      end
      vnavSPD_conditions["descent"]=true
      vnavSPD_conditions["onground"]=simDR_onGround
      vnavSPD_conditions["name"]=">standard baro"
      vnavSPD_conditions["crzAlt"]=B747BR_cruiseAlt
      vnavSPD_conditions["crzSpd"]=getFMSData("crzspd")
      B747DR_efis_baro_std_capt_switch_pos = 1
      --B747DR_efis_baro_capt_preselect  = 29.92
      simDR_altimeter_baro_inHg = 29.92
      B747DR_efis_baro_std_fo_switch_pos = 1
      --B747DR_efis_baro_fo_preselect = 29.92
      simDR_altimeter_baro_inHg_fo = 29.92
      print("standard baro")
  
      gotVNAVSpeed=true
      return
        end
        
        if B747DR_ap_inVNAVdescent ==0 and altval~=nil and spdval~=nil and simDR_pressureAlt1>=spdtransalt and simDR_pressureAlt1<above  then 
        if simDR_pressureAlt1<=transalt then above=transalt end
        vnavSPD_conditions["above"]=above
        
        vnavSPD_conditions["below"]=altval3
        vnavSPD_conditions["descent"]=true
        vnavSPD_conditions["onground"]=simDR_onGround 
        vnavSPD_conditions["name"]=">spdtransalt <".. above
        vnavSPD_conditions["crzAlt"]=B747BR_cruiseAlt
        vnavSPD_conditions["crzSpd"]=getFMSData("crzspd")
       
        print("convert to clb transpd ".. spdval)
        B747DR_switchingIASMode=1
        crzspdval=tonumber(getFMSData("crzspd"))/10
        if simDR_airspeed_mach > (crzspdval/100) then
      print("convert to cruise speed in clb".. crzspdval)
      simDR_autopilot_airspeed_is_mach = 1
      B747DR_ap_ias_dial_value = crzspdval
      B747DR_lastap_dial_airspeed=crzspdval*0.01
        else
      simDR_autopilot_airspeed_is_mach = 0
      B747DR_ap_ias_dial_value = math.min(399.0, spdval)
      B747DR_lastap_dial_airspeed=B747DR_ap_ias_dial_value
        end
        run_after_time(B747_updateIAS, 0.25)
        gotVNAVSpeed=true
        return
      end
        
      spdval=tonumber(getFMSData("crzspd"))
      if B747DR_ap_inVNAVdescent ==0 and spdval~=nil and altval2~=nil and simDR_pressureAlt1>=altval2  then 
        vnavSPD_conditions["above"]=-1
        vnavSPD_conditions["below"]=altval3
        vnavSPD_conditions["descent"]=true
        vnavSPD_conditions["onground"]=simDR_onGround
        vnavSPD_conditions["name"]="crzspd"
        vnavSPD_conditions["crzAlt"]=B747BR_cruiseAlt
        vnavSPD_conditions["crzSpd"]=getFMSData("crzspd")
        print("approaching cruise speed")
        gotVNAVSpeed=true
        return
      end
      end
      spdval=tonumber(getFMSData("desspdmach"))
      altval=tonumber(getFMSData("desspdtransalt"))
      if tonumber(string.sub(getFMSData("crzalt"),3))~=nil then 
        altval2=(tonumber(string.sub(getFMSData("crzalt"),3))*100)-1000
      else
        altval2=40000
      end
      if B747DR_ap_inVNAVdescent >0 and spdval~=nil and altval~=nil and simDR_pressureAlt1>=altval then 
      vnavSPD_conditions["above"]=-1
      vnavSPD_conditions["below"]=altval
      vnavSPD_conditions["descent"]=false
      vnavSPD_conditions["onground"]=simDR_onGround
      vnavSPD_conditions["name"]=">desspdtransalt"
      vnavSPD_conditions["crzAlt"]=B747BR_cruiseAlt
      B747DR_switchingIASMode=1
      simDR_autopilot_airspeed_is_mach = 1
      B747DR_ap_ias_dial_value = spdval/10
      B747DR_lastap_dial_airspeed=spdval*0.01
      run_after_time(B747_updateIASSpeed, 0.25)
      --simCMD_autopilot_alt_hold_mode:once()
      gotVNAVSpeed=true
      return
      end
      altval2=tonumber(getFMSData("desrestalt"))
      spdval=tonumber(getFMSData("destranspd"))
      if B747DR_ap_inVNAVdescent >0 and spdval~=nil and altval~=nil and simDR_pressureAlt1>=altval2 and simDR_pressureAlt1<altval then 
      vnavSPD_conditions["above"]=altval+200
      vnavSPD_conditions["below"]=altval2
      vnavSPD_conditions["descent"]=false
      vnavSPD_conditions["onground"]=simDR_onGround
      vnavSPD_conditions["name"]=">desrestalt <desspdtransalt"
      vnavSPD_conditions["crzAlt"]=B747BR_cruiseAlt
      B747DR_switchingIASMode=1
      simDR_autopilot_airspeed_is_mach = 0
      simCMD_autopilot_alt_hold_mode:once()
      B747DR_ap_ias_dial_value = spdval
      B747DR_lastap_dial_airspeed=B747DR_ap_ias_dial_value
      run_after_time(B747_updateIAS, 0.25)
      gotVNAVSpeed=true
      return
      end
      spdval=tonumber(getFMSData("desrestspd"))
      if B747DR_ap_inVNAVdescent >0 and spdval~=nil and altval~=nil and simDR_pressureAlt1<=altval2 then 
      vnavSPD_conditions["above"]=altval2+200
      vnavSPD_conditions["below"]=-1
      vnavSPD_conditions["descent"]=false
      vnavSPD_conditions["onground"]=simDR_onGround
      vnavSPD_conditions["name"]="<desrestalt"
      vnavSPD_conditions["crzAlt"]=B747BR_cruiseAlt
      B747DR_switchingIASMode=1
      simDR_autopilot_airspeed_is_mach = 0
      simCMD_autopilot_alt_hold_mode:once()
      B747DR_ap_ias_dial_value = spdval
      B747DR_lastap_dial_airspeed=B747DR_ap_ias_dial_value
      run_after_time(B747_updateIAS, 0.25)
      gotVNAVSpeed=true
      return
      end
      print("VNAV missing definition" .. B747DR_ap_inVNAVdescent .. " ".. simDR_pressureAlt1 .. " "..  vnavSPD_conditions["below"] .. " ".. vnavSPD_conditions["above"] )
      vnavSPD_conditions["above"]=-1
        vnavSPD_conditions["below"]=-1
        vnavSPD_conditions["descent"]=(B747DR_ap_inVNAVdescent==0)
        vnavSPD_conditions["onground"]=simDR_onGround
        vnavSPD_conditions["crzAlt"]=B747BR_cruiseAlt
       gotVNAVSpeed=true
      --ifsimDR_pressureAlt1
    end
    
    
  end

  function computeVNAVAlt(fms)


    local numAPengaged = B747DR_ap_cmd_L_mode + B747DR_ap_cmd_C_mode + B747DR_ap_cmd_R_mode
    local dist_to_TOD=(B747BR_totalDistance-B747BR_tod)
    for i=1,table.getn(fms),1 do
      if fms[i][10]==true and i<=vnavSPD_state["recalcAfter"] and 
      vnavSPD_state["vnavcalcwithMCPAlt"]==B747DR_autopilot_altitude_ft
      and
      vnavSPD_state["vnavcalcwithTargetAlt"]==simDR_autopilot_altitude_ft
      and (dist_to_TOD>50 or dist_to_TOD<49) and (simDR_autopilot_alt_hold_status < 2 or dist_to_TOD>0) then
        --print("simDR_autopilot_altitude_ft=".. simDR_autopilot_altitude_ft)
        return 
      end
    end
    if simDR_autopilot_alt_hold_status < 2 or dist_to_TOD>0 or numAPengaged==0 then --force a recalc after hold ends to set to B747DR_autopilot_altitude_ft if required
        vnavSPD_state["vnavcalcwithMCPAlt"]=B747DR_autopilot_altitude_ft
    else
        vnavSPD_state["vnavcalcwithMCPAlt"]=simDR_autopilot_altitude_ft
    end 
    vnavSPD_state["vnavcalcwithTargetAlt"]=simDR_autopilot_altitude_ft
    local began=false
    local targetAlt=simDR_autopilot_altitude_ft
    local targetIndex=0
    local currentIndex=0
    
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
        
        --print("FMS current i=" .. i.. ":" .. fms[i][1] .. ":" .. fms[i][2] .. ":" .. fms[i][3] .. ":" .. fms[i][4] .. ":" .. fms[i][5] .. ":" .. fms[i][6] .. ":" .. fms[i][7] .. ":" .. fms[i][8].. ":" .. fms[i][9])
        if B747BR_totalDistance>0 and dist_to_TOD>50 and (nextDistance)>dist_to_TOD then 
      break 
        end
        if fms[i][9]>0 and fms[i][2] ~= 1 then targetAlt=fms[i][9] targetIndex=i break end
      
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
    --if (targetAlt~=simDR_autopilot_altitude_ft or simDR_autopilot_altitude_ft~=B747DR_autopilot_altitude_ft) or (targetIndex>0 and  targetIndex~=fmstargetIndex) then
        
    if targetAlt>B747BR_cruiseAlt then targetAlt=B747BR_cruiseAlt end --lower cruise alt set than in fmc waypoints
    
    --if targetAlt ~= simDR_autopilot_altitude_ft then 
        if targetAlt>simDR_pressureAlt1+300 then
      --print("FMS use climb i=" .. targetIndex.. "@" .. currentIndex .. ":" ..fms[targetIndex][1] .. ":" .. fms[targetIndex][2] .. ":" .. fms[targetIndex][3] .. ":" .. fms[targetIndex][4] .. ":" .. fms[targetIndex][5] .. ":" .. fms[targetIndex][6] .. ":" .. fms[targetIndex][7] .. ":" .. fms[targetIndex][8].. ":" .. fms[targetIndex][9])
      B747DR_ap_vnav_target_alt=targetAlt
      if targetAlt > B747DR_autopilot_altitude_ft and B747DR_autopilot_altitude_ft>simDR_pressureAlt1+150 and (simDR_autopilot_alt_hold_status < 2 or numAPengaged==0) then 
        targetAlt=B747DR_autopilot_altitude_ft 
      end
      simDR_autopilot_altitude_ft=targetAlt
      
      B747DR_fmstargetIndex=targetIndex
      B747DR_fmscurrentIndex=currentIndex
      if simDR_autopilot_autothrottle_enabled == 0 and B747DR_engine_TOGA_mode == 0 and B747DR_ap_inVNAVdescent > 0 and B747DR_toggle_switch_position[29] == 1 then							-- AUTOTHROTTLE IS "OFF"
          simCMD_autopilot_autothrottle_on:once()									-- ACTIVATE THE AUTOTHROTTLE
      end
      
      if simDR_autopilot_flch_status==0 and B747DR_engine_TOGA_mode == 0 and B747DR_ap_inVNAVdescent > 0 then
        simCMD_autopilot_flch_mode:once()
        --print("computeVNAVAlt badness")
      end
      B747DR_ap_inVNAVdescent =0
        elseif targetAlt<simDR_pressureAlt1-300 then
      --print("FMS use descend i=" .. targetIndex.. "@" .. currentIndex .. ":" ..fms[targetIndex][1] .. ":" .. fms[targetIndex][2] .. ":" .. fms[targetIndex][3] .. ":" .. fms[targetIndex][4] .. ":" .. fms[targetIndex][5] .. ":" .. fms[targetIndex][6] .. ":" .. fms[targetIndex][7] .. ":" .. fms[targetIndex][8].. ":" .. fms[targetIndex][9])
      
      B747DR_ap_vnav_target_alt=targetAlt
      if targetAlt < B747DR_autopilot_altitude_ft and B747DR_autopilot_altitude_ft<simDR_pressureAlt1-150 and (simDR_autopilot_alt_hold_status < 2 or numAPengaged==0) then 
        targetAlt=B747DR_autopilot_altitude_ft 
      end
      simDR_autopilot_altitude_ft=targetAlt
      
      B747DR_fmstargetIndex=targetIndex
      B747DR_fmscurrentIndex=currentIndex
      if simDR_autopilot_altitude_ft> simDR_pressureAlt1+500 and (simDR_autopilot_alt_hold_status < 2 or numAPengaged==0) then
        simCMD_autopilot_alt_hold_mode:once()
        if simDR_autopilot_autothrottle_enabled == 0 and B747DR_toggle_switch_position[29] == 1 then							-- AUTOTHROTTLE IS "OFF"
          simCMD_autopilot_autothrottle_on:once()									-- ACTIVATE THE AUTOTHROTTLE
          if B747DR_engine_TOGA_mode >0 then B747DR_engine_TOGA_mode = 0 end	-- CANX ENGINE TOGA IF ACTIVE
        end	
      end
      --[[if simDR_autopilot_vs_status == 0 then
        simCMD_autopilot_vert_speed_mode:once()
        --simDR_autopilot_vs_fpm = vspeed 
      
      end]]
        else
          B747DR_fmstargetIndex=targetIndex
          B747DR_fmscurrentIndex=currentIndex
        end 
        --print("targetAlt=".. targetAlt .. " simDR_autopilot_altitude_ft=".. simDR_autopilot_altitude_ft .. " simDR_pressureAlt1=" .. simDR_pressureAlt1.. " vnavcalcwithMCPAlt=" .. vnavcalcwithMCPAlt .. " fmscurrentIndex=" .. fmscurrentIndex .. " targetIndex=" .. targetIndex .. " B747DR_autopilot_altitude_ft="..B747DR_autopilot_altitude_ft)
        vnavSPD_state["recalcAfter"]=B747DR_fmstargetIndex
    --end
  end
  
  function getDescentTarget()
    B747DR_target_descentSpeed=tonumber(getFMSData("destranspd"))
    B747DR_target_descentAlt=tonumber(getFMSData("desspdtransalt"))
    if B747DR_target_descentAlt>simDR_pressureAlt1 
      or simDR_autopilot_airspeed_kts<B747DR_target_descentSpeed 
      then 
      B747DR_descentSpeedGradient=0 
      return 
    end
    B747DR_descentSpeedGradient=(simDR_autopilot_airspeed_kts-B747DR_target_descentSpeed)/(simDR_pressureAlt1-B747DR_target_descentAlt)
    print("set descentSpeedGradient to " .. B747DR_descentSpeedGradient)
  end
  
  function vnavDescent()
    local diff = simDR_ind_airspeed_kts_pilot - simDR_autopilot_airspeed_kts
    local numAPengaged = B747DR_ap_cmd_L_mode + B747DR_ap_cmd_C_mode + B747DR_ap_cmd_R_mode
    if B747DR_ap_inVNAVdescent >0 and simDR_autopilot_autothrottle_enabled == 0 and diff>0 and simDR_allThrottle>0 and simDR_radarAlt1>1000 then
          simCMD_ThrottleDown:once()
          print("go idle")
    elseif B747DR_ap_inVNAVdescent ==2 and simDR_autopilot_autothrottle_enabled == 1 and simDR_autopilot_airspeed_is_mach==1 and simDR_allThrottle<0.02 then							-- AUTOTHROTTLE IS "ON"
          simCMD_autopilot_autothrottle_off:once()									-- DEACTIVATE THE AUTOTHROTTLE
          B747DR_ap_inVNAVdescent =1
          print("fix idle throttle")
    elseif B747DR_ap_inVNAVdescent >0 and simDR_autopilot_autothrottle_enabled == 0 and (simDR_ind_airspeed_kts_pilot<B747DR_airspeed_Vmc+15) and B747DR_toggle_switch_position[29] == 1 then
          simCMD_autopilot_autothrottle_on:once()
          --B747DR_ap_inVNAVdescent =1
          print("fix idle throttle to climb/maintain")
    end
    local diff2 = simDR_autopilot_altitude_ft - simDR_pressureAlt1
    local diff3 = B747DR_autopilot_altitude_ft- simDR_pressureAlt1
    if B747DR_ap_inVNAVdescent ==0 and diff2<=0 and diff3<=-2000 
          and B747BR_totalDistance>0 and B747BR_totalDistance-B747BR_tod<=0
          and simDR_autopilot_vs_status == 0 
          and simDR_radarAlt1>1000 
          and simDR_autopilot_autothrottle_enabled>-1 then
          B747DR_ap_inVNAVdescent =1
          print("Begin descent")
          getDescentTarget()
    end
    print("in vnav descent "..diff.." "..diff2.. " "..B747DR_ap_inVNAVdescent)    
    if B747DR_ap_inVNAVdescent ==1 and diff<5 and diff2<-200 and simDR_autopilot_vs_status == 0 and simDR_radarAlt1>1000 then
          if simDR_autopilot_gs_status < 1 then 
            simCMD_autopilot_vert_speed_mode:once()
            simDR_autopilot_vs_status =1
            if simDR_autopilot_autothrottle_enabled == 1 and diff2<-2000 and diff3<-2000 and (simDR_ind_airspeed_kts_pilot>B747DR_airspeed_Vmc+15) then							-- AUTOTHROTTLE IS "ON"
              --simDR_autopilot_autothrottle_enabled=0
              simCMD_autopilot_autothrottle_off:once()									-- DEACTIVATE THE AUTOTHROTTLE
            end
              B747DR_ap_inVNAVdescent =2 -- stop on/off, resume below
              print("Resume descent")
  -- 	    else
  -- 	      print("Ended descent")
          end
        --elseif B747DR_ap_inVNAVdescent ==1 and simDR_autopilot_vs_status == 0 and simDR_radarAlt1>1000 then
         -- print("waiting to resume descent "..diff.." "..diff2.." "..simDR_radarAlt1.. " " .. simDR_autopilot_altitude_ft)
    end
    if B747DR_ap_inVNAVdescent == 2 and ((simDR_autopilot_alt_hold_status == 2 or numAPengaged==0 or simDR_autopilot_vs_status == 0) and inVnavAlt<1) and (diff2<-1000) and (diff3<-1000) then 
        B747DR_ap_inVNAVdescent =1 --has simDR_autopilot_alt_hold_status == 2 in condition
    end
        
    if simDR_autopilot_vs_status == 2 and B747DR_fmstargetIndex>2 then
        setDescentVSpeed()
    end
  end
  function doAltChange()
    local diff2 = simDR_autopilot_altitude_ft - simDR_pressureAlt1
    if diff2>-100 and diff2<100 then return end
    if simDR_autopilot_vs_status == 0 then
        simCMD_autopilot_vert_speed_mode:once()
        simDR_autopilot_vs_status =1
        
    end 
    simDR_autopilot_vs_fpm = -1000
  end
  
  function vnavCruise()
    --if simDR_autopilot_alt_hold_status == 2 then return end
    if B747DR_switchingIASMode==1 then return end -- if we are in an airspeed mode switch just go away
    if B747DR_ap_vnav_state<2 then return end -- not in VNAV just go away
    --not called in descent anyway
    local numAPengaged = B747DR_ap_cmd_L_mode + B747DR_ap_cmd_C_mode + B747DR_ap_cmd_R_mode
    local diff2 = simDR_autopilot_altitude_ft - simDR_pressureAlt1
    local diff = simDR_autopilot_hold_altitude_ft - simDR_pressureAlt1
    print("in vnav cruise "..diff.." "..diff2.. " "..numAPengaged)
    --if diff2>100 and simDR_autopilot_flch_status > 0 then return end
    --if diff2<-100 and simDR_autopilot_vs_status == 2 then return end
    if diff2>1000 then --and simDR_autopilot_altitude_ft==B747BR_cruiseAlt - dont care, we are vnav climb, make sure we do
        if simDR_autopilot_flch_status == 0 and (simDR_autopilot_alt_hold_status == 0 or numAPengaged==0 )then
          simCMD_autopilot_flch_mode:once()
          simDR_autopilot_flch_status =1
          print("flch > 1000 feet climb")
        end 
        spdval=tonumber(getFMSData("crzspd"))/10
        
        if simDR_airspeed_mach > (spdval/100) and B747DR_ap_ias_mach_window_open == 0 and B747DR_switchingIASMode==0 and simDR_autopilot_airspeed_is_mach ==0 then
          print("convert to cruise speed "..spdval)
          B747DR_switchingIASMode=1
          simDR_autopilot_airspeed_is_mach = 1
          B747DR_ap_ias_dial_value = spdval
          B747DR_lastap_dial_airspeed=spdval*0.01
          
          run_after_time(B747_updateIASSpeed, 0.25)
        end
        
    elseif diff2>100 and simDR_autopilot_altitude_ft==B747BR_cruiseAlt then
      return --print("last 1000 feet climb")
    elseif diff2<-1000 and simDR_autopilot_altitude_ft==B747BR_cruiseAlt then
        if simDR_autopilot_vs_status == 0 then
      simCMD_autopilot_vert_speed_mode:once()
      simDR_autopilot_vs_status =1
        end 
        simDR_autopilot_vs_fpm = -1000
    elseif (diff2<-100 or diff<-1000) and simDR_autopilot_altitude_ft==B747BR_cruiseAlt then
      if simDR_autopilot_vs_status == 0 and is_timer_scheduled(doAltChange) == false then
        run_after_time(doAltChange, 15.0)
      end
    end
    
    if diff2>-100 and diff2<100 and simDR_autopilot_altitude_ft==B747BR_cruiseAlt then
      print("at cruise altitude")
      local ci = tonumber( getFMSData("costindex") )
      local ci_mach = 850
      if(ci == nil or ci == "****") then
        spdval=tonumber(getFMSData("crzspd"))/10
        if(spdval == nil) then
          spdval = 85
        end
      else
        -- mach numbers in thousands...
        local lrcMach = 388.2356 + 0.6203 * gwtKG/1000 + 7.8061 * simDR_pressureAlt1/1000
        local mrcMach = lrcMach -  20
        local maxMach = 920 - 20
        local ci_mach = lrcMach --default

        if(ci <= 230) then --LRC or less  (CI 230 corresponds to LRC - ref Boeing)
          ci_mach = mrcMach + 20 * (ci / 230)
        else
          ci_mach = lrcMach + (maxMach - lrcMach) * ((ci-230)/(9999-230)) -- interpolate LRC to Mmo wrt. CI=230 to CI=9999, respectively.
        end

        -- Faster with headwind, slower with tailwind (cf., LRC which does not adjust for wind)
        -- Source: https://mediawiki.ivao.aero/index.php?title=Cost_Index and https://www.pprune.org/tech-log/248931-use-cost-index-winds.html
        local tas = simDR_TAS_mps * 1.94384 -- true airspeed in knots
        local gs = simDR_GS_mps * 1.94384 -- ground speed in knots
        local relWind = tas - gs  -- headwind positive, tailwind negative
        local adjWind = 0
        if(relWind > 0) then
          adjWind = 10 * relWind/50 -- plus M0.01 per 50 knots of headwind
        else
          adjWind = 20 * relWind/50 -- minus M0.02 per 50 knots of tailwind
        end
        ci_mach = ci_mach + adjWind

        if(ci_mach < mrcMach) then ci_mach = mrcMach end
        if(ci_mach > maxMach) then ci_mach = maxMach end

        ci_mach = math.floor(ci_mach)
        spdval = ci_mach/10
        
      end 
      print("at cruise altitude for "..spdval)
      if (B747DR_ap_ias_dial_value ~=  spdval) and B747DR_ap_ias_mach_window_open == 0 and B747DR_switchingIASMode==0 then 
        B747DR_switchingIASMode=1
        simDR_autopilot_airspeed_is_mach = 1
        B747DR_ap_ias_dial_value = spdval
        B747DR_lastap_dial_airspeed=spdval*0.01
        
        run_after_time(B747_updateIASSpeed, 0.25)
        
        print("set cruise speed "..B747DR_ap_ias_dial_value)
      end	
      
      if simDR_autopilot_alt_hold_status == 2 and simDR_autopilot_autothrottle_enabled == 0 and B747DR_toggle_switch_position[29] == 1 then							-- AUTOTHROTTLE IS "OFF"
        simDR_autopilot_autothrottle_enabled = 1
        print("A/T on")-- ACTIVATE THE AUTOTHROTTLE  
      end
    end
    
  end