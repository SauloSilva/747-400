-- mSparks 2022/01/07

--sim/operation/override/override_wheel_steer
--
--sim/operation/override/override_control_surfaces
--sim/multiplayer/controls/yoke_pitch_ratio	float[20]	y	[-1..1]	The deflection of the axis controlling pitch.
--sim/multiplayer/controls/yoke_roll_ratio	float[20]	y	[-1..1]	The deflection of the axis controlling roll.
--sim/multiplayer/controls/yoke_heading_ratio	float[20]	y	[-1..1]	The deflection of the axis controlling yaw.
--sim/operation/override/override_joystick_roll
--sim/operation/override/override_joystick_pitch
--sim/operation/override/override_joystick_heading
--sim/flightmodel2/wing/aileron2_deg[]
--sim/flightmodel2/wing/aileron1_deg[]
--sim/flightmodel2/wing/flap1_deg[]
--sim/flightmodel2/wing/flap2_deg[]
--sim/flightmodel2/controls/slat2_deploy_ratio
--sim/flightmodel2/controls/slat1_deploy_ratio
lastBraking=0
lastPitch=0
lastRoll=0
lastYaw=0
lastFlaps=0

lastControlValue={}
lastControlValue[0]=0
lastControlValue[1]=0
lastControlValue[2]=0
lastControlValue[3]=0
lastControlValue[4]=0
lastControlValue[5]=0
lastControlValue[6]=0
lastControlValue[7]=0
lastControlValue[8]=0
lastControlValue[9]=0
lastControlValue[10]=0
-- 1 rudder lower 2,4
-- 2 rudder upper 1,2
-- 3 l elev inner
-- 4 r elev inner
-- 5 l elev outer
-- 6 r elev outer
-- 7 l ail inner sim/flightmodel/controls/wing2l_ail1def[0]
-- 8 r ail inner sim/flightmodel/controls/wing4r_ail1def[0]
-- 9 l ail outer sim/flightmodel/controls/wing4l_ail2def[0]
-- 10 r ail outer sim/flightmodel/controls/wing2r_ail2def[0]
brakeConsumption=0
local B747_pressureDRs={}
local controlRatios={}
controlRatios[0]=0
controlRatios[1]=0
controlRatios[2]=0
B747_pressureDRs[0]=0
function pressure_input()
    B747_pressureDRs[1]=B747DR_hyd_sys_pressure_1
    B747_pressureDRs[2]=B747DR_hyd_sys_pressure_2
    B747_pressureDRs[3]=B747DR_hyd_sys_pressure_3
    B747_pressureDRs[4]=B747DR_hyd_sys_pressure_4
    
    --controlRatios[1]=simDR_rudder[10]

    --controlRatios[2]=simDR_rudder[10]

    controlRatios[3]=simDR_elevator[0]
    controlRatios[4]=simDR_elevator[0]
    controlRatios[5]=simDR_elevator[0]
    controlRatios[6]=simDR_elevator[0]

    controlRatios[7]=simDR_left_aileron_inner
    controlRatios[8]=simDR_right_aileron_inner
    controlRatios[9]=simDR_left_aileron_outer
    controlRatios[10]=simDR_right_aileron_outer
end

function pressure_output()
    B747DR_hyd_sys_pressure_1=B747_pressureDRs[1]
    B747DR_hyd_sys_pressure_2=B747_pressureDRs[2]
    B747DR_hyd_sys_pressure_3=B747_pressureDRs[3]
    B747DR_hyd_sys_pressure_4=B747_pressureDRs[4]

    B747DR_rudder_lwr_pos=controlRatios[1]
    B747DR_rudder_upr_pos=controlRatios[2]

    B747DR_l_elev_inner   = controlRatios[3]
    B747DR_r_elev_inner   = controlRatios[4]
    B747DR_l_elev_outer   = controlRatios[5]
    B747DR_r_elev_outer   = controlRatios[6]

    B747DR_l_aileron_inner   = controlRatios[7]
    B747DR_r_aileron_inner   = controlRatios[8]
    B747DR_l_aileron_outer   = controlRatios[9]
    B747DR_r_aileron_outer   = controlRatios[10]
end


function hydraulics_consumer(src,consumption)
    local take_index=0
    print("consume "..src[1].." "..src[2].." "..src[3].." "..src[4].." "..consumption)
    for i=1,4,1 do
        if src[i]==1 and B747_pressureDRs[i]>consumption and B747_pressureDRs[i]>B747_pressureDRs[take_index] and B747_pressureDRs[i]>900 then
            take_index=i
        end

    end
    if take_index>0 then
        B747_pressureDRs[take_index]=B747_pressureDRs[take_index]-consumption
        return consumption
    else
        return 0
    end
end

function brake_accumulator()
    if simDR_parking_brake_ratio>lastBraking then
        brakeDiff=(simDR_parking_brake_ratio-lastBraking)*400
    else
        brakeDiff=0
    end
    if brakeDiff<simDR_hyd_press_1_2 then
        simDR_hyd_press_1_2=simDR_hyd_press_1_2-brakeDiff
    else
        simDR_hyd_press_1_2=0
    end
    brakeConsumption=brakeConsumption+brakeDiff
    lastBraking=simDR_parking_brake_ratio

    brakeConsumption=brakeConsumption-hydraulics_consumer({1,1,0,1},brakeConsumption)  
end
numSurfaces=10
function flight_controls_consumption()
    controlDiff={}
    for i=1,numSurfaces,1 do
        print(i.." getting")
        print(controlRatios[i])
        print(lastControlValue[i])
        if controlRatios[i]>lastControlValue[i] then
            controlDiff[i]=(controlRatios[i]-lastControlValue[i])
        else
            controlDiff[i]=(lastControlValue[i]-controlRatios[i])
        end
        
    end

    -- steering 
    hydraulics_consumer({1,0,0,0},controlDiff[1]*2.5)
    hydraulics_consumer({1,0,0,0},controlDiff[2]*2.5)
    --rudder lower 
    if hydraulics_consumer({0,1,0,1},controlDiff[1]*3)==0 then
        controlRatios[1]=B747_animate_value(lastControlValue[1],0,-100,100,1)
    else
        controlRatios[1]=simDR_rudder[10]
    end

    --[[if hydraulics_consumer({0,1,0,1},controlDiff[1]*3)==0 then
        controlRatios[1]=B747_animate_value(lastControlValue[1],0,-100,100,1)
    end]]
    -- rudder upper 
    if hydraulics_consumer({1,1,0,0},controlDiff[2]*3)==0 then
        controlRatios[2]=B747_animate_value(lastControlValue[2],0,-100,100,1)
    else
        controlRatios[2]=simDR_rudder[10]
    end
    
    --1,2 L inboard elev
    if hydraulics_consumer({1,1,0,0},controlDiff[3]*3)==0 then
        controlRatios[3]=B747_animate_value(lastControlValue[3],0,-100,100,1)
    end
    --2,3,4 R inboard elev
    if hydraulics_consumer({0,1,1,1},controlDiff[4]*3)==0 then
        controlRatios[4]=B747_animate_value(lastControlValue[4],0,-100,100,1)
    end
    --1 L outboard elev
    if hydraulics_consumer({1,0,0,0},controlDiff[5]*3)==0 then
        controlRatios[5]=B747_animate_value(lastControlValue[5],0,-100,100,1)
    end
    --4 R outboard elev
    if hydraulics_consumer({0,0,0,1},controlDiff[6]*3)==0 then
        controlRatios[6]=B747_animate_value(lastControlValue[6],0,-100,100,1)
    end


    --1,2 L inboard aileron
    if hydraulics_consumer({1,1,0,0},controlDiff[7]*3)==0 then
        controlRatios[7]=B747_animate_value(lastControlValue[7],0,-100,100,1)
    end
    --2,4 R inboard aileron
    if hydraulics_consumer({0,1,0,1},controlDiff[8]*3)==0 then
        controlRatios[8]=B747_animate_value(lastControlValue[8],0,-100,100,1)
    end
    --1,2 L outboard aileron
    if hydraulics_consumer({1,1,0,0},controlDiff[9]*3)==0 then
        controlRatios[9]=B747_animate_value(lastControlValue[9],0,-100,100,1)
    end
    --2,3,4 R outboard aileron
    if hydraulics_consumer({0,1,1,1},controlDiff[10]*3)==0 then
        controlRatios[10]=B747_animate_value(lastControlValue[10],0,-100,100,1)
    end
    for i=1,numSurfaces,1 do
        lastControlValue[i]=controlRatios[i]
    end
end

function flight_controls_override()
    override=1
    for i=1,4,1 do
        if B747_pressureDRs[i]>800 then
            override=0
        end
    end
    simDR_override_control_surfaces=override
    if B747_pressureDRs[1]>1000 then
        simDR_override_steering=0
    else
        simDR_override_steering=1
    end

end
