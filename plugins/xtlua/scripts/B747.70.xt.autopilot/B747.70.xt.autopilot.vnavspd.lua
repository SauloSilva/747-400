local vnavSPD_conditions={}
vnavSPD_conditions["onground"]=0
vnavSPD_conditions["below"]=-1
vnavSPD_conditions["above"]=-1
vnavSPD_conditions["name"]="unknown"
local vnavSPD_state={}
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

function clb_src_next()
    return simDR_pressureAlt1+(200-simDR_radarAlt1) --400ft agl at current pressure alt
end
function clb_aptres_next()
    return tonumber(getFMSData("clbrestalt"))+100
end
function clb_spcres_next()
    return tonumber(getFMSData("spdtransalt"))+100
end
function clb_nores_next()
    return (tonumber(string.sub(getFMSData("crzalt"),3))*100)-1000
end
function clb_crz_next()
    return 320000
end
function des_src_next()
    return tonumber(getFMSData("desspdtransalt"))
end
function des_aptres_next()
    return tonumber(getFMSData("desrestalt"))
end
function des_spcres_next()
    return -100
end
local spd_states={}
spd_states["clb"]={}
spd_states["des"]={}
spd_states["clb"]["src"]={}
spd_states["clb"]["aptres"]={}
spd_states["clb"]["spcres"]={}
spd_states["clb"]["nores"]={}
spd_states["clb"]["crz"]={}
spd_states["des"]["src"]={}
spd_states["des"]["aptres"]={}
spd_states["des"]["spcres"]={}

spd_states["clb"]["src"]["nextfunc"]=clb_src_next
spd_states["clb"]["aptres"]["nextfunc"]=clb_aptres_next
spd_states["clb"]["spcres"]["nextfunc"]=clb_spcres_next
spd_states["clb"]["nores"]["nextfunc"]=clb_nores_next
spd_states["clb"]["crz"]["nextfunc"]=clb_crz_next
spd_states["des"]["src"]["nextfunc"]=des_src_next
spd_states["des"]["aptres"]["nextfunc"]=des_aptres_next
spd_states["des"]["spcres"]["nextfunc"]=des_spcres_next

spd_states["clb"]["src"]["nextstate"]="aptres"
spd_states["clb"]["aptres"]["nextstate"]="spcres"
spd_states["clb"]["spcres"]["nextstate"]="nores"
spd_states["clb"]["nores"]["nextstate"]="crz"
spd_states["clb"]["crz"]["nextstate"]=nil
spd_states["des"]["src"]["nextstate"]="aptres"
spd_states["des"]["aptres"]["nextstate"]="spcres"
spd_states["des"]["spcres"]["nextstate"]=nil

function clb_src_setSpd()
    if B747DR_airspeed_V2<999 then
        simDR_autopilot_airspeed_is_mach = 0  
        B747DR_ap_ias_dial_value = math.min(399.0, B747DR_airspeed_V2 + 10)
        B747DR_switchingIASMode=1
        B747DR_lastap_dial_airspeed=B747DR_ap_ias_dial_value
        run_after_time(B747_updateIAS, 0.25)
    end
end
function clb_aptres_setSpd()
    local spdval=tonumber(getFMSData("clbrestspd"))
    simDR_autopilot_airspeed_is_mach = 0
    print("convert to clb clbrestspd ".. spdval)
    B747DR_ap_ias_dial_value = math.min(399.0, spdval)
    B747DR_switchingIASMode=1
    B747DR_lastap_dial_airspeed=B747DR_ap_ias_dial_value
    run_after_time(B747_updateIAS, 0.25)

end
function clb_spcres_setSpd()
    local spdval=tonumber(getFMSData("clbspd"))
    B747DR_switchingIASMode=1
    local crzspdval=tonumber(getFMSData("crzspd"))/10
    if simDR_airspeed_mach > (crzspdval/100) then
      print("convert to cruise speed in clb ".. crzspdval)
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

end
function clb_nores_setSpd()
    local spdval=tonumber(getFMSData("transpd"))
    B747DR_switchingIASMode=1
    local crzspdval=tonumber(getFMSData("crzspd"))/10
    if simDR_airspeed_mach > (crzspdval/100) then
      print("convert to cruise speed in clb".. crzspdval)
      simDR_autopilot_airspeed_is_mach = 1
      B747DR_ap_ias_dial_value = crzspdval
      B747DR_lastap_dial_airspeed=crzspdval*0.01
    else
      simDR_autopilot_airspeed_is_mach = 0
      print("convert to transpd speed ".. spdval)
      B747DR_ap_ias_dial_value = math.min(399.0, spdval)
      B747DR_lastap_dial_airspeed=B747DR_ap_ias_dial_value
    end
    run_after_time(B747_updateIAS, 0.25)

end
function clb_crz_setSpd()
    local spdval=tonumber(getFMSData("crzspd"))/10
    print("convert to cruise speed in clb_crz_setSpd ".. spdval)
    simDR_autopilot_airspeed_is_mach = 1
    B747DR_ap_ias_dial_value = spdval
    B747DR_lastap_dial_airspeed=spdval*0.01
    run_after_time(B747_updateIAS, 0.25)
end
function des_src_setSpd()
    
end
function des_aptres_setSpd()
    
end
function des_spcres_setSpd()
    
end
spd_states["clb"]["src"]["spdfunc"]=clb_src_setSpd
spd_states["clb"]["aptres"]["spdfunc"]=clb_aptres_setSpd
spd_states["clb"]["spcres"]["spdfunc"]=clb_spcres_setSpd
spd_states["clb"]["nores"]["spdfunc"]=clb_nores_setSpd
spd_states["clb"]["crz"]["spdfunc"]=clb_crz_setSpd
spd_states["des"]["src"]["spdfunc"]=des_src_setSpd
spd_states["des"]["aptres"]["spdfunc"]=des_aptres_setSpd
spd_states["des"]["spcres"]["spdfunc"]=des_spcres_setSpd

function setVNAVState(name,value)
    vnavSPD_state[name]=value
end
function getVNAVState(name)
    return vnavSPD_state[name]
end
function B747_update_vnav_speed()
    if simDR_onGround~=vnavSPD_conditions["onground"] then vnavSPD_state["gotVNAVSpeed"]=false end
    if vnavSPD_conditions["above"]>0 and vnavSPD_conditions["above"]<simDR_pressureAlt1 then 
      print("above "..vnavSPD_conditions["above"].. " " ..vnavSPD_conditions["name"])
      vnavSPD_state["gotVNAVSpeed"]=false 
    end
    if vnavSPD_conditions["descent"]==(B747DR_ap_inVNAVdescent>0) then 
       print("descent "..B747DR_ap_inVNAVdescent.. " " ..vnavSPD_conditions["name"])
       vnavSPD_state["gotVNAVSpeed"]=false 
    end
    if vnavSPD_conditions["below"]>0 and vnavSPD_conditions["below"]>simDR_pressureAlt1 then 
       print("below "..vnavSPD_conditions["below"].. " " ..vnavSPD_conditions["name"])
       vnavSPD_state["gotVNAVSpeed"]=false 
    end
    if vnavSPD_conditions["crzAlt"]~=B747BR_cruiseAlt then 
       print("new crzAlt")
       vnavSPD_state["gotVNAVSpeed"]=false 
    end
    if vnavSPD_conditions["crzSpd"]~=getFMSData("crzspd") then 
       print("new crzSpd")
       vnavSPD_state["gotVNAVSpeed"]=false 
    end
end
function B747_vnav_setClimbspeed()
    local lastAlt=simDR_pressureAlt1+(simDR_radarAlt1-400)
    local cState="src"
    local nextAlt=spd_states["clb"]["src"]["nextfunc"]()
    while simDR_pressureAlt1>nextAlt and spd_states["clb"][cState]["nextstate"]~=nil do
        lastAlt=nextAlt
        cState=spd_states["clb"][cState]["nextstate"]
        nextAlt=spd_states["clb"][cState]["nextfunc"]()
    end
    vnavSPD_conditions["name"]="clb_"..cState
    vnavSPD_conditions["onground"]=simDR_onGround
    vnavSPD_conditions["below"]=lastAlt
    vnavSPD_conditions["above"]=nextAlt
    vnavSPD_conditions["descent"]=true
    vnavSPD_conditions["crzAlt"]=B747BR_cruiseAlt
    vnavSPD_conditions["crzSpd"]=getFMSData("crzspd")
    vnavSPD_state["spdIsMach"]=simDR_autopilot_airspeed_is_mach
    vnavSPD_state["gotVNAVSpeed"]=true
    print("climb cState " .. cState .. " lastAlt "..lastAlt .. " nextAlt "..nextAlt)
    spd_states["clb"][cState]["spdfunc"]()
end

function B747_vnav_setDescendspeed()
    local lastAlt=simDR_pressureAlt1+1000
    local cState="src"
    local nextAlt=spd_states["des"]["src"]["nextfunc"]()
    while simDR_pressureAlt1<nextAlt and spd_states["des"][cState]["nextstate"]~=nil do
        lastAlt=nextAlt
        cState=spd_states["des"][cState]["nextstate"]
        nextAlt=spd_states["des"][cState]["nextfunc"]()
    end
    
    vnavSPD_conditions["name"]="des_"..cState
    vnavSPD_conditions["onground"]=simDR_onGround
    vnavSPD_conditions["below"]=lastAlt
    vnavSPD_conditions["above"]=nextAlt
    vnavSPD_conditions["descent"]=false
    vnavSPD_conditions["crzAlt"]=B747BR_cruiseAlt
    vnavSPD_conditions["crzSpd"]=getFMSData("crzspd")
    vnavSPD_state["spdIsMach"]=simDR_autopilot_airspeed_is_mach
    vnavSPD_state["gotVNAVSpeed"]=true
    print("des cState " .. cState .. " lastAlt "..lastAlt .. " nextAlt "..nextAlt)
end
function B747_vnav_speed()
    if B747DR_ap_vnav_state==0 then return end
    if getVNAVState("manualVNAVspd")==1 then return end
    B747_update_vnav_speed()
    if vnavSPD_state["gotVNAVSpeed"]==true then return end
    if B747DR_ap_inVNAVdescent ==0 then
        B747_vnav_setClimbspeed()
    else
        B747_vnav_setDescendspeed()
    end

end
  
function B747_vnav_speed_old()
    if B747DR_ap_vnav_state==0 then return end
    if getVNAVState("manualVNAVspd")==1 then return end
    B747_update_vnav_speed()
    if vnavSPD_state["gotVNAVSpeed"]==true then return end
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
        vnavSPD_state["gotVNAVSpeed"]=true
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
        vnavSPD_state["gotVNAVSpeed"]=true
        return
      end
      
      spdval=tonumber(getFMSData("clbspd"))
      local spdtransalt=tonumber(getFMSData("spdtransalt"))
      local above = spdtransalt
      local transalt=tonumber(getFMSData("transalt"))
      if transalt<spdtransalt then above= transalt end
      
      local altval3=tonumber(getFMSData("desrestalt"))
      if B747DR_ap_inVNAVdescent ==0 and altval~=nil and spdval~=nil and spdtransalt~=nil and simDR_pressureAlt1>=altval and simDR_pressureAlt1<above then 
        
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
        vnavSPD_state["gotVNAVSpeed"]=true
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
        
        vnavSPD_state["gotVNAVSpeed"]=true
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
        vnavSPD_state["gotVNAVSpeed"]=true
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
        vnavSPD_state["gotVNAVSpeed"]=true
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
      vnavSPD_state["gotVNAVSpeed"]=true
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
      vnavSPD_state["gotVNAVSpeed"]=true
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
      vnavSPD_state["gotVNAVSpeed"]=true
      return
      end
      print("VNAV missing definition" .. B747DR_ap_inVNAVdescent .. " ".. simDR_pressureAlt1 .. " "..  vnavSPD_conditions["below"] .. " ".. vnavSPD_conditions["above"] )
      vnavSPD_conditions["above"]=-1
        vnavSPD_conditions["below"]=-1
        vnavSPD_conditions["descent"]=(B747DR_ap_inVNAVdescent==0)
        vnavSPD_conditions["onground"]=simDR_onGround
        vnavSPD_conditions["crzAlt"]=B747BR_cruiseAlt
        vnavSPD_state["gotVNAVSpeed"]=true
      --ifsimDR_pressureAlt1
    end
    
    
end