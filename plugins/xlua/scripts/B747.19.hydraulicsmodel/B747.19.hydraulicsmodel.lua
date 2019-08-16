B747DR_button_switch_position   = find_dataref("laminar/B747/button_switch/position")
simDR_engine_N1_pct             = find_dataref("sim/cockpit2/engine/indicators/N1_percent")
B747DR_hyd_temp = find_dataref("sim/physics/earth_temp_c")
B747DR_hyd_sys_pressure_1      = create_dataref("laminar/B747/hydraulics/pressure_1", "number")
B747DR_hyd_sys_pressure_2      = create_dataref("laminar/B747/hydraulics/pressure_2", "number")
B747DR_hyd_sys_pressure_3      = create_dataref("laminar/B747/hydraulics/pressure_3", "number")
B747DR_hyd_sys_pressure_4      = create_dataref("laminar/B747/hydraulics/pressure_4", "number")

B747DR_hyd_sys_temp_1      = create_dataref("laminar/B747/hydraulics/temp_1", "number")
B747DR_hyd_sys_temp_2      = create_dataref("laminar/B747/hydraulics/temp_2", "number")
B747DR_hyd_sys_temp_3      = create_dataref("laminar/B747/hydraulics/temp_3", "number")
B747DR_hyd_sys_temp_4      = create_dataref("laminar/B747/hydraulics/temp_4", "number")

B747DR_hyd_sys_res_1      = create_dataref("laminar/B747/hydraulics/res_1", "number")
B747DR_hyd_sys_res_2      = create_dataref("laminar/B747/hydraulics/res_2", "number")
B747DR_hyd_sys_res_3      = create_dataref("laminar/B747/hydraulics/res_3", "number")
B747DR_hyd_sys_res_4      = create_dataref("laminar/B747/hydraulics/res_4", "number")

B747DR_hyd_sys_restotal_1      = create_dataref("laminar/B747/hydraulics/restotal_1", "number")
B747DR_hyd_sys_restotal_2      = create_dataref("laminar/B747/hydraulics/restotal_2", "number")
B747DR_hyd_sys_restotal_3      = create_dataref("laminar/B747/hydraulics/restotal_3", "number")
B747DR_hyd_sys_restotal_4      = create_dataref("laminar/B747/hydraulics/restotal_4", "number")

B747DR_hyd_dem_pressure_1      = create_dataref("laminar/B747/hydraulics/dem_pressure_1", "number")
B747DR_hyd_dem_pressure_2      = create_dataref("laminar/B747/hydraulics/dem_pressure_2", "number")
B747DR_hyd_dem_pressure_3      = create_dataref("laminar/B747/hydraulics/dem_pressure_3", "number")
B747DR_hyd_dem_pressure_4      = create_dataref("laminar/B747/hydraulics/dem_pressure_4", "number")

B747DR_hyd_edp_pressure_1      = create_dataref("laminar/B747/hydraulics/edp_pressure_1", "number")
B747DR_hyd_edp_pressure_2      = create_dataref("laminar/B747/hydraulics/edp_pressure_2", "number")
B747DR_hyd_edp_pressure_3      = create_dataref("laminar/B747/hydraulics/edp_pressure_3", "number")
B747DR_hyd_edp_pressure_4      = create_dataref("laminar/B747/hydraulics/edp_pressure_4", "number")
B747DR_hyd_aux_pressure      = create_dataref("laminar/B747/hydraulics/aux_pressure", "number")

B747DR_hyd_dem_mode_1      = create_dataref("laminar/B747/hydraulics/dem_mode_1", "number")
B747DR_hyd_dem_mode_2      = create_dataref("laminar/B747/hydraulics/dem_mode_2", "number")
B747DR_hyd_dem_mode_3      = create_dataref("laminar/B747/hydraulics/dem_mode_3", "number")
B747DR_hyd_dem_mode_4      = create_dataref("laminar/B747/hydraulics/dem_mode_4", "number")
-- CRT Displays/EICAS Lower/HYD/valve_on
B747DR_hyd_valve_1      = create_dataref("laminar/B747/hydraulics/valve_1", "number")
B747DR_hyd_valve_2      = create_dataref("laminar/B747/hydraulics/valve_2", "number")
B747DR_hyd_valve_3      = create_dataref("laminar/B747/hydraulics/valve_3", "number")
B747DR_hyd_valve_4      = create_dataref("laminar/B747/hydraulics/valve_4", "number")
simDR_hyd_press_1_2               = create_dataref("sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1_2_4", "number")
--simDR_hyd_press_2               = find_dataref("sim/cockpit2/hydraulics/indicators/hydraulic_pressure_2")
B747DR_engine1psi    = create_dataref("laminar/B747/air/engine1/bleed_air_psi", "number")
B747DR_engine4psi    = create_dataref("laminar/B747/air/engine4/bleed_air_psi", "number")

B747DR_hyd_dmd_pmp_sel_pos      = create_dataref("laminar/B747/hydraulics/dmd_pump/sel_dial_pos", "array[4]")
function B747_animate_value(current_value, target, min, max, speed)

    local fps_factor = math.min(1.0, speed * SIM_PERIOD)

    if target >= (max - 0.001) and current_value >= (max - 0.01) then
        return max
    elseif target <= (min + 0.001) and current_value <= (min + 0.01) then
       return min
    else
        return current_value + ((target - current_value) * fps_factor)
    end

end

function B747_engine_hyd_valves()
-- ENGINE #1
    if B747DR_button_switch_position[30] > 0.95 then
        B747DR_hyd_valve_1 = 1
    elseif B747DR_button_switch_position[30] < 0.05 then
        B747DR_hyd_valve_1  = 0
    end


    -- ENGINE #2
    if B747DR_button_switch_position[31] > 0.95 then
        B747DR_hyd_valve_2  = 1
    elseif B747DR_button_switch_position[31] < 0.05 then
        B747DR_hyd_valve_2  = 0
    end


    -- ENGINE #3
    if B747DR_button_switch_position[32] > 0.95 then
        B747DR_hyd_valve_3  = 1
    elseif B747DR_button_switch_position[32] < 0.05 then
        B747DR_hyd_valve_3  = 0
    end


    -- ENGINE #4
    if B747DR_button_switch_position[33] > 0.95 then
        B747DR_hyd_valve_4  = 1
    elseif B747DR_button_switch_position[33] < 0.05 then
        B747DR_hyd_valve_4  = 0
    end
end
function B747_engine_dem_modes()
  B747DR_hyd_dem_mode_1=B747DR_hyd_dmd_pmp_sel_pos[0]
  B747DR_hyd_dem_mode_2=B747DR_hyd_dmd_pmp_sel_pos[1]
  B747DR_hyd_dem_mode_3=B747DR_hyd_dmd_pmp_sel_pos[2]
  B747DR_hyd_dem_mode_4=B747DR_hyd_dmd_pmp_sel_pos[3]
  
end
function B747_edp_pressures()
    if B747DR_hyd_valve_1==1 then
      B747DR_hyd_edp_pressure_1=30*simDR_engine_N1_pct[0]
    else
      B747DR_hyd_edp_pressure_1=0;
    end
    
    if B747DR_hyd_valve_2==1 then
      B747DR_hyd_edp_pressure_2=30*simDR_engine_N1_pct[1]
    else
      B747DR_hyd_edp_pressure_2=0;
    end
    
    if B747DR_hyd_valve_3==1 then
      B747DR_hyd_edp_pressure_3=30*simDR_engine_N1_pct[2]
    else
      B747DR_hyd_edp_pressure_3=0;
    end
    
    if B747DR_hyd_valve_4==1 then
      B747DR_hyd_edp_pressure_4=30*simDR_engine_N1_pct[3]
    else
      B747DR_hyd_edp_pressure_4=0;
    end
end

function B747_dem_pressures()
  if B747DR_hyd_dem_mode_1>0 then 
    if B747DR_hyd_dem_mode_1==2 then
      B747DR_hyd_dem_pressure_1=B747DR_engine1psi*75
    elseif B747DR_hyd_edp_pressure_1<2000 then
      B747DR_hyd_dem_pressure_1=B747DR_engine1psi*75
    else
      B747DR_hyd_dem_pressure_1=0
    end
  else
     B747DR_hyd_dem_pressure_1=0  
  end
  
  
  if B747DR_hyd_dem_mode_2>0 then
    if B747DR_hyd_dem_mode_2==2 then
      B747DR_hyd_dem_pressure_2=3000
    elseif B747DR_hyd_edp_pressure_2<2000 then
      B747DR_hyd_dem_pressure_2=3000
    else
      B747DR_hyd_dem_pressure_2=0
    end
   else
     B747DR_hyd_dem_pressure_2=0 
  end
 
  if B747DR_hyd_dem_mode_3>0 then
    if B747DR_hyd_dem_mode_3==2 then
      B747DR_hyd_dem_pressure_3=3000
    elseif B747DR_hyd_edp_pressure_3<2000 then
      B747DR_hyd_dem_pressure_3=3000
    else
      B747DR_hyd_dem_pressure_3=0
    end
   else
     B747DR_hyd_dem_pressure_3=0
  end
  
  if B747DR_hyd_dem_mode_4>0 then
    if B747DR_hyd_dem_mode_4==2 then
      B747DR_hyd_dem_pressure_4=B747DR_engine4psi*75
    elseif B747DR_hyd_edp_pressure_4<2000 then
      B747DR_hyd_dem_pressure_4=B747DR_engine4psi*75
    else
      B747DR_hyd_dem_pressure_4=0
    end
    elseif B747DR_hyd_dem_mode_4<0 then
     B747DR_hyd_aux_pressure=2950
     B747DR_hyd_dem_pressure_4=0
    else
     B747DR_hyd_dem_pressure_4=0
     B747DR_hyd_aux_pressure=0
  end
  
end
function B747_system_pressures()
B747_animate_value(B747DR_hyd_sys_pressure_1,math.max(B747DR_hyd_dem_pressure_1,B747DR_hyd_edp_pressure_1),0,3000,1)
  B747DR_hyd_sys_pressure_1=B747_animate_value(B747DR_hyd_sys_pressure_1,math.max(B747DR_hyd_dem_pressure_1,B747DR_hyd_edp_pressure_1),0,3000,1)--math.max(B747DR_hyd_dem_pressure_1,B747DR_hyd_edp_pressure_1)
  B747DR_hyd_sys_pressure_2=B747_animate_value(B747DR_hyd_sys_pressure_2,math.max(B747DR_hyd_dem_pressure_2,B747DR_hyd_edp_pressure_2),0,3000,1)--math.max(B747DR_hyd_dem_pressure_2,B747DR_hyd_edp_pressure_2)
  B747DR_hyd_sys_pressure_3=B747_animate_value(B747DR_hyd_sys_pressure_3,math.max(B747DR_hyd_dem_pressure_3,B747DR_hyd_edp_pressure_3),0,3000,1)--math.max(B747DR_hyd_dem_pressure_3,B747DR_hyd_edp_pressure_3)
  B747DR_hyd_sys_pressure_4=B747_animate_value(B747DR_hyd_sys_pressure_4,math.max(B747DR_hyd_dem_pressure_4,B747DR_hyd_edp_pressure_4,B747DR_hyd_aux_pressure),0,3000,1)--math.max(B747DR_hyd_dem_pressure_4,B747DR_hyd_edp_pressure_4,B747DR_hyd_aux_pressure)

  B747DR_hyd_sys_res_1=B747DR_hyd_sys_restotal_1-(B747DR_hyd_sys_pressure_1/3000)*0.3
  B747DR_hyd_sys_res_2=B747DR_hyd_sys_restotal_2-(B747DR_hyd_sys_pressure_2/3000)*0.3
  B747DR_hyd_sys_res_3=B747DR_hyd_sys_restotal_3-(B747DR_hyd_sys_pressure_3/3000)*0.3
  B747DR_hyd_sys_res_4=B747DR_hyd_sys_restotal_4-(B747DR_hyd_sys_pressure_4/3000)*0.3
simDR_hyd_press_1_2 = math.max(B747DR_hyd_sys_pressure_1,B747DR_hyd_sys_pressure_2,B747DR_hyd_sys_pressure_4)

  B747DR_hyd_sys_temp_1=B747DR_hyd_temp+(1-B747DR_hyd_sys_res_1)*20
  B747DR_hyd_sys_temp_2=B747DR_hyd_temp+(1-B747DR_hyd_sys_res_2)*20
    B747DR_hyd_sys_temp_3=B747DR_hyd_temp+(1-B747DR_hyd_sys_res_3)*20
    B747DR_hyd_sys_temp_4=B747DR_hyd_temp+(1-B747DR_hyd_sys_res_4)*20
end
--*************************************************************************************--
--**                          EVENT CALLBACKS                        **--
--*************************************************************************************--

--function aircraft_load() end

--function aircraft_unload() end

function flight_start() 
B747DR_hyd_sys_restotal_1=math.random()*0.4+0.55
B747DR_hyd_sys_restotal_2=math.random()*0.4+0.55
B747DR_hyd_sys_restotal_3=math.random()*0.4+0.55
B747DR_hyd_sys_restotal_4=math.random()*0.4+0.55
B747DR_hyd_sys_res_1=B747DR_hyd_sys_restotal_1
B747DR_hyd_sys_res_2=B747DR_hyd_sys_restotal_2
B747DR_hyd_sys_res_3=B747DR_hyd_sys_restotal_3
B747DR_hyd_sys_res_4=B747DR_hyd_sys_restotal_4
    B747DR_hyd_dmd_pmp_sel_pos[0] = 0
    B747DR_hyd_dmd_pmp_sel_pos[1] = 0
    B747DR_hyd_dmd_pmp_sel_pos[2] = 0
    B747DR_hyd_dmd_pmp_sel_pos[3] = 0
    B747DR_hyd_sys_temp_1=B747DR_hyd_temp
    B747DR_hyd_sys_temp_2=B747DR_hyd_temp
    B747DR_hyd_sys_temp_3=B747DR_hyd_temp
    B747DR_hyd_sys_temp_4=B747DR_hyd_temp
end

--function flight_crash() end

--function before_physics() end

function after_physics()
   B747_engine_hyd_valves()
   B747_engine_dem_modes()
   B747_edp_pressures()
   B747_dem_pressures()
   B747_system_pressures()
end

--function after_replay() end