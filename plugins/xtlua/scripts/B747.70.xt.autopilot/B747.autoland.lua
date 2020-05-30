--[[
*****************************************************************************************
*        COPYRIGHT � 2020 Mark Parker/mSparks CC-BY-NC4
*****************************************************************************************
]]

local active_land=false
local zerodThrottle=false
local pinThrottle=0;
local pinrudder=0;
local throttleAdjust=0.18
local rod=0
local lastAlt=0
local initElevator=0
local lastRod=0
local touchedGround=false
local inrollout=false
local pinRoll=0
local windCorrectAngle=0 
local maxPitch=0
local maxThrottle=1
function start_flare()
  local numAPengaged = B747DR_ap_cmd_L_mode + B747DR_ap_cmd_C_mode + B747DR_ap_cmd_R_mode
    print("autoland ".. simDR_radarAlt1 .. " "..B747DR_ap_FMA_active_roll_mode.. " "..B747DR_ap_FMA_active_pitch_mode.. " "..numAPengaged)
    --B747DR_ap_FMA_active_roll_mode = 4 --ROLLOUT
    B747DR_ap_FMA_armed_pitch_mode = 0
    B747DR_ap_FMA_active_pitch_mode = 3 --SHOW FLARE
    pinThrottle=simDR_allThrottle
    simCMD_autopilot_autothrottle_off:once() 
    windCorrectAngle=simDR_reqHeading-simDR_AHARS_heading_deg_pilot
    --simCMD_autopilot_fdir_servos_down_one:once()
    active_autoland=true
    active_land=false
    zerodThrottle=false
    touchedGround=false
    inrollout=false
    lastRod=0
    initElevator=0
    maxPitch=0
    simDR_overRideStab=1
    maxThrottle=simDR_allThrottle
    lastAlt=0
    pinThrottle=0;
end
local targetPitch
function doPitch()
  targetPitch=maxPitch
  --if simDR_radarAlt1 >50 and lastRod<0.3 then targetPitch=-2 -- if we are here > 50 feet, we are stopping a nose dive
  --elseif simDR_radarAlt1 >50 and lastRod>1.5 then targetPitch=10  --flare harder!
  --elseif simDR_radarAlt1 >50 and lastRod>=0.8 then targetPitch=simDR_AHARS_pitch_heading_deg_pilot 
  --local doRollout=maxPitch+4.5
  local doRollout=((4.8+lastRod*8)*(maxPitch/8))
  if simDR_radarAlt1 >50 then targetPitch=-0.5
  elseif simDR_radarAlt1 >40 then
    local thisPitch=9*lastRod
    if thisPitch<8 then thisPitch=8 end
    if simDR_radarAlt1 > doRollout then targetPitch=thisPitch end
  end 
  if simDR_radarAlt1 < doRollout then targetPitch=2 maxPitch=2 inrollout=true B747DR_ap_FMA_active_roll_mode=4 B747DR_ap_FMA_active_pitch_mode=0 end
  if simDR_radarAlt1 < 5.5 then targetPitch=1 maxPitch=1 inrollout=true B747DR_ap_FMA_active_roll_mode=4 B747DR_ap_FMA_active_pitch_mode=0 end
  if targetPitch>0 and targetPitch>maxPitch then maxPitch=targetPitch 
end
  if targetPitch>0 and targetPitch<maxPitch and simDR_radarAlt1 > doRollout then targetPitch=maxPitch 
  end
  if inrollout==true then targetPitch=2 end
  if simDR_AHARS_pitch_heading_deg_pilot>targetPitch+0.1 then
    initElevator=-0.1*(simDR_AHARS_pitch_heading_deg_pilot-targetPitch)
  elseif simDR_AHARS_pitch_heading_deg_pilot<targetPitch-0.1 then
    initElevator=0.1*(targetPitch-simDR_AHARS_pitch_heading_deg_pilot)
  end
end


function doYaw()
  pinRoll= 0.0
  --if touchedGround==true then  pinRoll= 0 end
  if touchedGround==false then 
    local roll=simDR_AHARS_roll_deg_pilot
    local tRoll=0
    if roll>pinRoll then
      tRoll=-0.2*(roll)
  elseif roll<pinRoll then
      tRoll=0.2*(roll)
  end
  if tRoll>0.5 then tRoll=0.5 end
  if tRoll<-0.5 then tRoll=-0.5 end
  
  simDR_roll=B747_set_ap_animation_position(simDR_roll,tRoll,-1,1,5)
  
 
   
  end 
  if inrollout==true then
   local diff=simDR_reqHeading-simDR_AHARS_heading_deg_pilot
  if diff>0 then
      pinrudder=-0.3*(diff)
  elseif diff<0 then
      pinrudder=0.3*(diff)
  end
  if pinrudder>1 then pinrudder=1 end
  if pinrudder<-1 then pinrudder=-1 end
  --if zerodThrottle then pinrudder=0 end
  
    simDR_rudder=B747_set_ap_animation_position(simDR_rudder,pinrudder,-1,1,3)
  end

    
    --pTrint("yaw " .. diff .." ".. simDR_rudder .. " " .. simDR_roll .. " " .. simDR_AHARS_roll_deg_pilot)
end
function controlYaw()
  local diff=simDR_reqHeading-simDR_AHARS_heading_deg_pilot
  if simDR_radarAlt1 <13 or touchedGround==true then --align runway
    doYaw()
  end
end
local targetAirspeed
function doThrottle()
  targetAirspeed=169
  lastAlt=simDR_radarAlt1
  if touchedGround==true then pinThrottle=0 return end
  if simDR_touchGround>0 then touchedGround=true pinThrottle=0 return end

  if simDR_radarAlt1 < 50 then
    targetAirspeed=169-(50+simDR_radarAlt1)/10
  end
  
  local diff=targetAirspeed-simDR_ind_airspeed_kts_pilot
  
  if diff>0 then
      pinThrottle=1
  elseif diff<0 then
      pinThrottle=0
  end
  if pinThrottle>1 then pinThrottle=1 end
  if pinThrottle<-1 then pinThrottle=-1 end
  
end
function during_Flare()
  local altdiff=lastAlt-simDR_radarAlt1
  if altdiff~=0 and lastRod==0 and lastAlt~=0 then lastRod=altdiff
  elseif altdiff~=0 then lastRod=(altdiff+lastRod)/2 end
  if lastRod<0 then lastRod=0 end
  doThrottle()
  doPitch()
  controlYaw()
  simDR_allThrottle=B747_set_ap_animation_position(simDR_allThrottle,pinThrottle,0,1,10)
  simDR_elevator=B747_set_ap_animation_position(simDR_elevator,initElevator,-1,1,1)
  --simDR_rudder=B747_set_ap_animation_position(simDR_rudder,pinrudder,-1,1,2)
  print("autoland flare ".. simDR_radarAlt1 .. " "..altdiff.. " ".. B744_fpm .." : "..targetAirspeed.." ".. simDR_ind_airspeed_kts_pilot .." ".. simDR_allThrottle .." : ".. simDR_AHARS_heading_deg_pilot.." ".. simDR_AHARS_pitch_heading_deg_pilot .." " ..targetPitch)
end
function end_Flare()
--print("autoland stop".. simDR_radarAlt1 .. " "..B747DR_ap_FMA_autothrottle_mode .." "..B747DR_ap_FMA_active_pitch_mode)
        --pinThrottle=simDR_allThrottle
        print("autoland stop".. simDR_radarAlt1 .. " ".. pinThrottle .." "..B747DR_ap_FMA_active_pitch_mode)
        --simCMD_autopilot_fdir_servos_down_one:once()
        B747DR_ap_FMA_active_pitch_mode = 0 --no pitch
       -- simDR_elevator=initElevator-0.05--B747_set_ap_animation_position(simDR_elevator,initElevator-0.05,0,1,5)
        simDR_pitch  =0.0
        active_land=true
        zerodThrottle=false
end
function touchdown_elevator()
      if simDR_AHARS_pitch_heading_deg_pilot>2 then targetPitch=1
      elseif simDR_AHARS_pitch_heading_deg_pilot>1 then targetPitch=0
      else targetPitch=-2 end
      if simDR_AHARS_pitch_heading_deg_pilot>targetPitch+0.1 then
	initElevator=-0.2*(simDR_AHARS_pitch_heading_deg_pilot-targetPitch)
      elseif simDR_AHARS_pitch_heading_deg_pilot<targetPitch-0.1 then
	initElevator=0.2*(targetPitch-simDR_AHARS_pitch_heading_deg_pilot)
      end
      simDR_elevator=B747_set_ap_animation_position(simDR_elevator,initElevator,-1,1,1)
end
function preFlare_elevator()
      targetPitch=2
      if simDR_AHARS_pitch_heading_deg_pilot>targetPitch+0.1 then
	initElevator=-0.2*(simDR_AHARS_pitch_heading_deg_pilot-targetPitch)
      elseif simDR_AHARS_pitch_heading_deg_pilot<targetPitch-0.1 then
	initElevator=0.2*(targetPitch-simDR_AHARS_pitch_heading_deg_pilot)
      end
      simDR_elevator=B747_set_ap_animation_position(simDR_elevator,initElevator,-1,1,1)
end
function do_touchdown()
     touchdown_elevator()
     if simDR_onGround==1 then
	simDR_rudder=B747_set_ap_animation_position(simDR_rudder,0,-1,1,3)
     else
	doYaw()
     end
      --print("autoland touchdown".. simDR_radarAlt1 .. " ".. initElevator .." ".. simDR_AHARS_pitch_heading_deg_pilot)
      --[[if simDR_radarAlt1 >5 then
         simDR_allThrottle=B747_set_ap_animation_position(simDR_allThrottle,0,0,1,5)
         --print("autoland calming ".. simDR_radarAlt1 .. " ".. simDR_allThrottle .." "..B747DR_ap_FMA_active_pitch_mode)
	 
      else]]
	if simDR_allThrottle>0 and not zerodThrottle then 
         simDR_allThrottle=B747_set_ap_animation_position(simDR_allThrottle,0,0,1,10)
         --print("autoland zeroing ".. simDR_radarAlt1 .. " ".. simDR_allThrottle .." "..B747DR_ap_FMA_active_pitch_mode)
      elseif active_land and not zerodThrottle  then 
         zerodThrottle=true--allow thrust reversors
	 --simDR_pitch2=-1
         print("autoland zero ".. simDR_radarAlt1 .. " "..B747DR_ap_FMA_autothrottle_mode .." "..B747DR_ap_FMA_active_pitch_mode)
      end
      if simDR_onGround==1 and simDR_rudder==0 then 
	active_autoland=false 
	simDR_overRideStab=0
	B747DR_ap_FMA_active_roll_mode=0
      end --we done!
end

function runAutoland()
  local numAPengaged = B747DR_ap_cmd_L_mode + B747DR_ap_cmd_C_mode + B747DR_ap_cmd_R_mode
  local diff=simDR_reqHeading-simDR_AHARS_heading_deg_pilot
    
    if numAPengaged<1 then 
      active_autoland=false 
      simDR_overRideStab=0
      return false
    end
    
    if active_autoland then
      if active_land  then
        do_touchdown()
	return true
      end
     
      if simDR_radarAlt1 < 5 and not active_land then -- watch the bounce! 
        end_Flare()
	return true
      end
      during_Flare()
     return true 
    
  end
  if simDR_touchGround>0 then return false end
   -- print("prep autoland ".. simDR_radarAlt1 .. " "..B747DR_ap_FMA_active_roll_mode.. " "..B747DR_ap_FMA_active_pitch_mode.. " "..numAPengaged)
  pinThrottle=simDR_allThrottle
  if simDR_radarAlt1>0 and simDR_radarAlt1 < 50 and numAPengaged>2 then --and B747DR_ap_FMA_active_roll_mode==3 and B747DR_ap_FMA_active_pitch_mode == 2 and (always autoland >2 aps)
    lastAlt=simDR_radarAlt1 --begin alt tracking
    start_flare()
    return true
   end
   --no nose dives in the last 100 feet
    if simDR_radarAlt1 < 100 and numAPengaged>2 then 
      preFlare_elevator()
      B747DR_ap_FMA_armed_pitch_mode=3
	print("autoland preflare ".. simDR_radarAlt1.. " " .. simDR_AHARS_pitch_heading_deg_pilot .." " ..targetPitch)
      return true
    end
   --[[
    if simDR_radarAlt1>0 and simDR_radarAlt1 < 100 and simDR_AHARS_pitch_heading_deg_pilot < -3 and B744_fpm < -1500  and numAPengaged>2 then --and B747DR_ap_FMA_active_roll_mode==3 and B747DR_ap_FMA_active_pitch_mode == 2 
    doPitch()
    print("clamp pitch")
    simDR_elevator=B747_set_ap_animation_position(simDR_elevator,initElevator,-3,1,3)
    return true
   end
   if simDR_radarAlt1>0 and simDR_radarAlt1 < 100 and B744_fpm < -1900 and numAPengaged>2 then -- and B747DR_ap_FMA_active_roll_mode==3 and B747DR_ap_FMA_active_pitch_mode == 2
    doPitch()
    print("clamp pitch 2")
    simDR_elevator=B747_set_ap_animation_position(simDR_elevator,initElevator,-3,1,3)
    return true
   end]]
   touchedGround=false
   pinRoll=0
   return false
end

--[[
function doPitch()
  targetPitch=maxPitch
  if simDR_radarAlt1 >50 and lastRod<0.8 then targetPitch=-2 -- if we are here > 50 feet, we are stopping a nose dive
  elseif simDR_radarAlt1 >50 and lastRod>1.5 then targetPitch=10  --flare harder!
  elseif simDR_radarAlt1 >50 and lastRod>=0.8 then targetPitch=simDR_AHARS_pitch_heading_deg_pilot  
  elseif simDR_radarAlt1 >14 and lastRod >=1.0 then targetPitch=8  --flare harder! 
  elseif simDR_radarAlt1 >14 and lastRod >=0.8 then targetPitch=6  --flare harder! 
  elseif  simDR_radarAlt1 <14 and lastRod >=0.8 then targetPitch=2 maxPitch=2
  elseif  simDR_radarAlt1 <11 and lastRod >=0.6 then targetPitch=2 maxPitch=2 -- and lastRod <0.2
  elseif  simDR_radarAlt1 <8 then targetPitch=2 maxPitch=2 -- and lastRod <0.2
  elseif  simDR_radarAlt1 <50 and lastRod >=0.5  then targetPitch=8 maxPitch=8
  elseif  simDR_radarAlt1 <50 and lastRod >=0.3  then targetPitch=7
  elseif lastRod <0.1 and simDR_radarAlt1 >20 then targetPitch=-1 end
  
  if targetPitch>0 and targetPitch>maxPitch then maxPitch=targetPitch end
  if targetPitch>0 and targetPitch<maxPitch and simDR_radarAlt1 > 6 then targetPitch=maxPitch end
  print("Pitching "..targetPitch)
  
  if simDR_AHARS_pitch_heading_deg_pilot>targetPitch+0.1 then
    initElevator=-0.1*(simDR_AHARS_pitch_heading_deg_pilot-targetPitch)
  elseif simDR_AHARS_pitch_heading_deg_pilot<targetPitch-0.1 then
    initElevator=0.1*(targetPitch-simDR_AHARS_pitch_heading_deg_pilot)
  end
end
]]
--[[
  function doThrottle()
  local altdiff=lastAlt-simDR_radarAlt1
  
  
  
  lastAlt=simDR_radarAlt1
  
  if touchedGround==true then pinThrottle=0 return end
  if simDR_touchGround>0 then touchedGround=true pinThrottle=0 return end
  --if simDR_radarAlt1>40 and B744_fpm>-1000 then pinThrottle=0 return end
  if lastRod < 0.10 and simDR_radarAlt1 < 15 then pinThrottle=0 return end --less than 15 feet to go and not falling - just sink
  if simDR_AHARS_pitch_heading_deg_pilot<3 and simDR_touchGround==false and lastRod>0.8 then pinThrottle=simDR_allThrottle return end --more throttle only works above this
  if simDR_AHARS_pitch_heading_deg_pilot<3 and simDR_touchGround==false and lastRod<0.5 then pinThrottle=0 return end --rollout
  --if altdiff==0 then return end -- we are faster than the sim
  
  if lastRod>0.15 and simDR_radarAlt1<7 then
    pinThrottle=maxThrottle --nearly at the ground but to high sink rate, take the edge off  
  elseif lastRod>0.20 and simDR_AHARS_pitch_heading_deg_pilot>4 then 
    --falling to fast, throttle up
    pinThrottle=maxThrottle
  elseif lastRod<0.25 then
    --falling just right, try and float
    pinThrottle=0
  else
    pinThrottle=simDR_allThrottle --just hold it
  end
  
end]]