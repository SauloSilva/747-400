--[[
*****************************************************************************************
* Program Script Name	:	B747.87.warning
* Author Name			:	Jim Gregory
*
*   Revisions:
*   -- DATE --	--- REV NO ---		--- DESCRIPTION ---
*   2016-04-26	0.01a				Start of Dev
*
*
*
*
*****************************************************************************************
*        COPYRIGHT � 2016 JIM GREGORY / LAMINAR RESEARCH - ALL RIGHTS RESERVED
*****************************************************************************************
--]]


--#####################################################################################--
--#                   EICAS MESSAGE FUNCTIONALITY & DESCRIPTION                       #--
--#####################################################################################--
--[[

IN ANY SCRIPT THE MESSAGE STATUS DATAREFS "B747DR_CAS_warning_status[X]", 'B747DR_CAS_caution_status[X]",
"B747DR_CAS_advisory_status[X]", OR "B747DR_CAS_memo_status[X]" SHOULD BE SET = 1 (ONE) OR 0 (ZERO),
WHICH INDICATES THAT THE EICAS MESSAGE SHOULD BE ACTIVATED OR DE-ACTIVATED.

THEN, THE SYSTEM AUTOMATICALLY COMPARES THE STATUS DATAREFS WITH THE APPROPRIATE MESSAGE
DATABASE TABLE AND DETERMINES IF THE MESSAGE HAS CHANGED.

IF THE MESSAGE HAS BEEN CHANGED IT IS ADDED OR REMOVED FROM THE DISPLAY "QUEUE" APPROPRIATELY.

FINALLY, THE DISPLAY QUEUE IS ITERATED AND THE DISPLAY PAGES ARE BUILT TO SET UP THE VALUES
FOR THE GENERIC TEXT INSTRUMENTS.

--]]



--*************************************************************************************--
--** 					              XLUA GLOBALS              				     **--
--*************************************************************************************--

--[[

SIM_PERIOD - this contains the duration of the current frame in seconds (so it is alway a
fraction).  Use this to normalize rates,  e.g. to add 3 units of fuel per second in a
per-frame callback you’d do fuel = fuel + 3 * SIM_PERIOD.

IN_REPLAY - evaluates to 0 if replay is off, 1 if replay mode is on

--]]


--*************************************************************************************--
--** 					               CONSTANTS                    				 **--
--*************************************************************************************--

local NUM_ALERT_MESSAGES = 109




--*************************************************************************************--
--** 					            GLOBAL VARIABLES                				 **--
--*************************************************************************************--



--*************************************************************************************--
--** 					            LOCAL VARIABLES                 				 **--
--*************************************************************************************--

local B747_CASwarning   = {}
local B747_CAScaution   = {}
local B747_CASadvisory  = {}
local B747_CASmemo      = {}



--*************************************************************************************--
--** 				                X-PLANE DATAREFS            			    	 **--
--*************************************************************************************--

simDR_startup_running               = find_dataref("sim/operation/prefs/startup_running")
simDR_all_wheels_on_ground          = find_dataref("sim/flightmodel/failures/onground_all")
simDR_ind_airspeed_kts_pilot        = find_dataref("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")




--*************************************************************************************--
--** 				              FIND CUSTOM DATAREFS             			    	 **--
--*************************************************************************************--

B747DR_airspeed_Vmc                 = find_dataref("laminar/B747/airspeed/Vmc")




--*************************************************************************************--
--** 				        CREATE READ-ONLY CUSTOM DATAREFS               	         **--
--*************************************************************************************--

B747DR_CAS_warning_status       = create_dataref("laminar/B747/CAS/warning_status", string.format("array[%s]", #B747_CASwarningMsg))
B747DR_CAS_caution_status       = create_dataref("laminar/B747/CAS/caution_status", string.format("array[%s]", #B747_CAScautionMsg))
B747DR_CAS_advisory_status      = create_dataref("laminar/B747/CAS/advisory_status", string.format("array[%s]", #B747_CASadvisoryMsg))
B747DR_CAS_memo_status          = create_dataref("laminar/B747/CAS/memo_status", string.format("array[%s]", #B747_CASmemoMsg))


B747DR_CAS_gen_warning_msg = {}
for i = 0, NUM_ALERT_MESSAGES do
    B747DR_CAS_gen_warning_msg[i] = create_dataref(string.format("laminar/B747/CAS/gen_warning_msg_%03d", i), "string")
end

B747DR_CAS_gen_caution_msg = {}
for i = 0, NUM_ALERT_MESSAGES do
    B747DR_CAS_gen_caution_msg[i] = create_dataref(string.format("laminar/B747/CAS/gen_caution_msg_%03d", i), "string")
end

B747DR_CAS_gen_advisory_msg = {}
for i = 0, NUM_ALERT_MESSAGES do
    B747DR_CAS_gen_advisory_msg[i] = create_dataref(string.format("laminar/B747/CAS/gen_advisory_msg_%03d", i), "string")
end

B747DR_CAS_gen_memo_msg = {}
for i = 0, NUM_ALERT_MESSAGES do
    B747DR_CAS_gen_memo_msg[i] = create_dataref(string.format("laminar/B747/CAS/gen_memo_msg_%03d", i), "string")
end


B747DR_CAS_recall_ind           = create_dataref("laminar/B747/CAS/recall_ind", "number")
B747DR_CAS_sec_eng_exceed_cue   = create_dataref("laminar/B747/CAS/sec_eng_exceed_cue", "number")
B747DR_CAS_status_cue           = create_dataref("laminar/B747/CAS/status_cue", "number")
B747DR_CAS_msg_page             = create_dataref("laminar/B747/CAS/msg_page", "number")
B747DR_CAS_num_msg_pages        = create_dataref("laminar/B747/CAS/num_msg_pages", "number")
B747DR_CAS_caut_adv_display     = create_dataref("laminar/B747/CAS/caut_adv_display", "number")


B747DR_master_warning           = create_dataref("laminar/B747/warning/master_warning", "number")
B747DR_master_caution           = create_dataref("laminar/B747/warning/master_caution", "number")

B747DR_init_warning_CD          = create_dataref("laminar/B747/warning/init_CD", "number")



--*************************************************************************************--
--** 				       READ-WRITE CUSTOM DATAREF HANDLERS     	        	     **--
--*************************************************************************************--



--*************************************************************************************--
--** 				       CREATE READ-WRITE CUSTOM DATAREFS                         **--
--*************************************************************************************--



--*************************************************************************************--
--** 				             X-PLANE COMMAND HANDLERS               	    	 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				                 X-PLANE COMMANDS                   	    	 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				              CUSTOM COMMAND HANDLERS            			     **--
--*************************************************************************************--

function B747_ai_warning_quick_start_CMDhandler(phase, duration)
    if phase == 0 then
		B747_set_warning_all_modes()
		B747_set_warning_CD()
		B747_set_warning_ER()	
	end 	
end	




--*************************************************************************************--
--** 				              CREATE CUSTOM COMMANDS              			     **--
--*************************************************************************************--

-- AI
B747CMD_ai_warning_quick_start			= create_command("laminar/B747/ai/warning_quick_start", "number", B747_ai_warning_quick_start_CMDhandler)



--*************************************************************************************--
--** 					            OBJECT CONSTRUCTORS         		    		 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				               CREATE SYSTEM OBJECTS            				 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				                  SYSTEM FUNCTIONS           	    			 **--
--*************************************************************************************--

----- RESCALE FLOAT AND CLAMP TO OUTER LIMITS -------------------------------------------
function B747_rescale(in1, out1, in2, out2, x)

    if x < in1 then return out1 end
    if x > in2 then return out2 end
    return out1 + (out2 - out1) * (x - in1) / (in2 - in1)

end




----- TERNARY CONDITIONAL ---------------------------------------------------------------
function B747_ternary(condition, ifTrue, ifFalse)
    if condition then return ifTrue else return ifFalse end
end












----- CREW ALERT MESSAGE TABLE REMOVE ---------------------------------------------------
function B747_removeWarning(message)

    for i = #B747_CASwarning, 1, -1 do
        if B747_CASwarning[i] == message then
            table.remove(B747_CASwarning, i)
            break
        end
    end

end

function B747_removeCaution(message)

    for i = #B747_CAScaution, 1, -1 do
        if B747_CAScaution[i] == message then
            table.remove(B747_CAScaution, i)
            break
        end
    end

end

function B747_removeAdvisory(message)

    for i = #B747_CASadvisory, 1, -1 do
        if B747_CASadvisory[i] == message then
            table.remove(B747_CASadvisory, i)
            break
        end
    end

end

function B747_removeMemo(message)

    for i = #B747_CASmemo, 1, -1 do
        if B747_CASmemo[i] == message then
            table.remove(B747_CASmemo, i)
            break
        end
    end

end






----- BUILD THE ALERT QUEUE -------------------------------------------------------------
function B747_CAS_queue() 

    ----- WARNINGS
    for i = 1, #B747_CASwarningMsg do                                                                   -- ITERATE THE WARNINGS DATA TABLE

        if B747_CASwarningMsg[i].status ~= B747DR_CAS_warning_status[B747_CASwarningMsg[i].DRindex] then -- THE WARNING STATUS HAS CHANGED

            if B747DR_CAS_warning_status[B747_CASwarningMsg[i].DRindex] == 1 then                       -- WARNING IS ACTIVE
                table.insert(B747_CASwarning, B747_CASwarningMsg[i].name)                               -- ADD TO THE WARNING QUEUE
                B747DR_master_warning = 1                                                               -- SET THE MASTER WARNING
            elseif B747DR_CAS_warning_status[B747_CASwarningMsg[i].DRindex] == 0 then                   -- WARNING IS INACTIVE
                B747_removeWarning(B747_CASwarningMsg[i].name)                                          -- REMOVE FROM THE WARNING QUEUE
            end
            B747_CASwarningMsg[i].status = B747DR_CAS_warning_status[B747_CASwarningMsg[i].DRindex]     -- RESET WARNING STATUS

        end

    end


    ----- CAUTIONS
    for i = 1, #B747_CAScautionMsg do                                                      -- ITERATE THE CAUTIONS DATA TABLE

        if B747_CAScautionMsg[i].status ~= B747DR_CAS_caution_status[B747_CAScautionMsg[i].DRindex] then -- THE CAUTION STATUS HAS CHANGED

            if B747DR_CAS_caution_status[B747_CAScautionMsg[i].DRindex] == 1 then                 -- CAUTION IS ACTIVE
                table.insert(B747_CAScaution, B747_CAScautionMsg[i].name)                  -- ADD TO THE CAUTION QUEUE
                B747DR_master_caution = 1                                                   -- SET THE MASTER CAUTION
            elseif B747DR_CAS_caution_status[B747_CAScautionMsg[i].DRindex] == 0 then             -- CAUTION IS INACTIVE
                B747_removeCaution(B747_CAScautionMsg[i].name)                             -- REMOVE FROM THE CAUTION QUEUE
            end
            B747_CAScautionMsg[i].status = B747DR_CAS_caution_status[B747_CAScautionMsg[i].DRindex]  -- RESET CAUTION STATUS

        end

    end


    ----- ADVISORIES
    for i = 1, #B747_CASadvisoryMsg do                                                      -- ITERATE THE CAUTIONS DATA TABLE

        if B747_CASadvisoryMsg[i].status ~= B747DR_CAS_advisory_status[B747_CASadvisoryMsg[i].DRindex] then -- THE CAUTION STATUS HAS CHANGED

            if B747DR_CAS_advisory_status[B747_CASadvisoryMsg[i].DRindex] == 1 then                 -- CAUTION IS ACTIVE
                table.insert(B747_CASadvisory, B747_CASadvisoryMsg[i].name)                  -- ADD TO THE CAUTION QUEUE
            elseif B747DR_CAS_advisory_status[B747_CASadvisoryMsg[i].DRindex] == 0 then             -- CAUTION IS INACTIVE
                B747_removeAdvisory(B747_CASadvisoryMsg[i].name)                             -- REMOVE FROM THE CAUTION QUEUE
            end
            B747_CASadvisoryMsg[i].status = B747DR_CAS_advisory_status[B747_CASadvisoryMsg[i].DRindex]  -- RESET CAUTION STATUS

        end

    end


    ----- MEMOS
    for i = 1, #B747_CASmemoMsg do                                                          -- ITERATE THE CAUTIONS DATA TABLE

        if B747_CASmemoMsg[i].status ~= B747DR_CAS_memo_status[B747_CASmemoMsg[i].DRindex] then    -- THE CAUTION STATUS HAS CHANGED

            if B747DR_CAS_memo_status[B747_CASmemoMsg[i].DRindex] == 1 then                        -- CAUTION IS ACTIVE
                table.insert(B747_CASmemo, B747_CASmemoMsg[i].name)                         -- ADD TO THE CAUTION QUEUE
            elseif B747DR_CAS_memo_status[B747_CASmemoMsg[i].DRindex] == 0 then                    -- CAUTION IS INACTIVE
                B747_removeMemo(B747_CASmemoMsg[i].name)                                -- REMOVE FROM THE CAUTION QUEUE
            end
            B747_CASmemoMsg[i].status = B747DR_CAS_memo_status[B747_CASmemoMsg[i].DRindex]         -- RESET CAUTION STATUS

        end

    end

end






----- BUILD THE CAS DISPLAY PAGES -------------------------------------------------------
function B747_CAS_display()

    B747DR_CAS_num_msg_pages = #B747_CASwarning
    if #B747_CASwarning < 11 then
        B747DR_CAS_num_msg_pages = math.ceil(math.max(10, (#B747_CASwarning + #B747_CAScaution + #B747_CASadvisory + #B747_CASmemo)) / 11)
    end
    local numAlertPages = 10 --math.ceil((#B747_CASwarning + #B747_CAScaution + #B747_CASadvisory + #B747_CASmemo) / 11)  -- TODO:  CHANGE TO FIXED NUMBER OF PAGES (GENERIC MESSAGES)
    local genIndex = 0
    local lastGenIndex = 0

    -- RESET ALL MESSAGES
    for x = 0, NUM_ALERT_MESSAGES do
        B747DR_CAS_gen_warning_msg[x] = ""
        B747DR_CAS_gen_caution_msg[x] = ""
        B747DR_CAS_gen_advisory_msg[x] = ""
        B747DR_CAS_gen_memo_msg[x] = ""
    end

    ----- WARNINGS ----------------------------------------------------------------------

    for i = #B747_CASwarning, 1, -1 do                                                      -- REVERSE ITERATE THE TABLE (GET MOST RECENT FIRST)

        B747DR_CAS_gen_warning_msg[genIndex] = B747_CASwarning[i]                               -- ASSIGN ALERT TO WARNING GENERIC
        lastGenIndex = genIndex
        if #B747_CASwarning < 11 then                                                       -- NUM WARNINGS FILLS OR EXCEEDS ONE PAGE
            for page = 2, numAlertPages  do                                                 -- ITERATE ALL OTHER ALERT PAGES
                B747DR_CAS_gen_warning_msg[((page*11)-11) + genIndex] = B747DR_CAS_gen_warning_msg[genIndex]    -- DUPLICATE THE WARNING FOR ALL PAGES
            end
        end
        genIndex = genIndex + 1                                                             -- INCREMENT THE GENERIC INDEX

    end


    if #B747_CASwarning < 11 then                                                           -- FIRST PAGE NOT FULL OF WARNINGS - OK TO PROCEED

        if B747DR_CAS_caut_adv_display == 1 then

            ----- CAUTIONS --------------------------------------------------------------
            for i = #B747_CAScaution, 1, -1 do                                                      -- REVERSE ITERATE THE TABLE (MOST RECENT MESSAGE FIRST)

                B747DR_CAS_gen_caution_msg[genIndex] = B747_CAScaution[i]                           -- ASSIGN ALERT TO CAUTION GENERIC
                lastGenIndex = genIndex
                genIndex = genIndex + 1                                                             -- INCREMENT THE GENERIC INDEX
                if math.fmod(genIndex, 11) == 0 then                                                -- END OF PAGE
                    genIndex = genIndex + #B747_CASwarning                                          -- INCREMENT THE INDEX BY THE NUM OF WARNINGS DISPLAYED (FOR NEXT PAGE)
                end


            end


            ----- ADVISORIES ------------------------------------------------------------
            for i = #B747_CASadvisory, 1, -1 do                                                     -- REVERSE ITERATE THE TABLE (MOST RECENT MESSAGE FIRST)

                B747DR_CAS_gen_advisory_msg[genIndex] = B747_CASadvisory[i]                             -- ASSIGN ALERT TO ADVISORY GENERIC
                lastGenIndex = genIndex
                genIndex = genIndex + 1                                                             -- INCREMENT THE GENERIC INDEX
                if math.fmod(genIndex, 11) == 0 then                                                -- END OF PAGE
                    genIndex = genIndex + #B747_CASwarning                                          -- INCREMENT THE INDEX BY THE NUM OF WARNINGS DISPLAYED (FOR NEXT PAGE)
                end

            end

        end


        ----- MEMOS ---------------------------------------------------------------------
        local memoPageCheck = 1                                                                 -- FIST MEMO PAGE CHECK FLAG
        local increment = -1                                                                    -- INITIAL DISPLAY DIRECTION IS BOTTOM UP
        --local lastIndex = genIndex                                                              -- SAVE THE LAST GENERIC INDEX
        local page = math.ceil((genIndex+1) / 11)                                               -- GET CURRENT PAGE #
        local memoStartPage = page                                                              -- ASSIGN START PAGE FOR MEMO MESSAGES

        genIndex = ((memoStartPage * 10) + (memoStartPage - 1))                                 -- START DISPLAY AT BOTTOM OF CURRENT PAGE

        for i = #B747_CASmemo, 1, -1 do                                                         -- REVERSE ITERATE THE TABLE (MOST RECENT MESSAGE FIRST)

            -- FIRST PAGE IS FILLED
            if memoPageCheck == 1                                                               -- OK TO PERFORM CHECK
                and page == memoStartPage                                                       -- STILL ON START PAGE
                and genIndex == lastGenIndex                                                    -- WE ARE AT THE LAST ADVISORY MESSAGE POSITION - START PAGE IS FILLED

            -- START NEXT PAGE
            then
                page = page + 1                                                                 -- INCREMENT PAGE # TO STOP PAGE CHECK
                genIndex = page * 11                                                            -- SET THE GENERIC INDEX TO BEGINNING OF NEXT PAGE
                increment = 1                                                                   -- CHANGE DISPLAY DIRECTION TO TOP DOWM
                memoPageCheck = 0                                                               -- SET THE FLAG TO STOP PAGE CHECK
            end

            B747DR_CAS_gen_memo_msg[genIndex] = B747_CASmemo[i]                                     -- ASSIGN MEMO TO GENERIC
            genIndex = genIndex + increment                                                     -- ADJUST THE GENERIC INDEX
            if math.fmod(genIndex, 10) == 0 then                                                -- END OF PAGE
                genIndex = genIndex + #B747_CASwarning                                          -- INCREMENT THE INDEX BY THE NUM OF WARNINGS DISPLAYED (FOR NEXT PAGE)
            end

        end
    end

end








----- EICAS MESSAGES --------------------------------------------------------------------
function B747_warnings_EICAS_msg()



end







----- MONITOR AI FOR AUTO-BOARD CALL ----------------------------------------------------
function B747_warning_monitor_AI()

    if B747DR_init_warning_CD == 1 then
        B747_set_warning_all_modes()
        B747_set_warning_CD()
        B747DR_init_warning_CD = 2
    end

end





----- SET STATE FOR ALL MODES -----------------------------------------------------------
function B747_set_warning_all_modes()

	B747DR_init_warning_CD = 0
    B747DR_CAS_msg_page = 1
    B747DR_CAS_caut_adv_display = 1

end





----- SET STATE TO COLD & DARK ----------------------------------------------------------
function B747_set_warning_CD()



end





----- SET STATE TO ENGINES RUNNING ------------------------------------------------------
function B747_set_warning_ER()
	
    B747DR_sfty_no_smoke_sel_dial_pos = 1
    B747DR_sfty_seat_belts_sel_dial_pos = 1
	
end






----- FLIGHT START ----------------------------------------------------------------------
function B747_flight_start_warning()

    -- ALL MODES ------------------------------------------------------------------------
    B747_set_warning_all_modes()


    -- COLD & DARK ----------------------------------------------------------------------
    if simDR_startup_running == 0 then

        B747_set_warning_CD()


    -- ENGINES RUNNING ------------------------------------------------------------------
    elseif simDR_startup_running == 1 then

		B747_set_warning_ER()

    end

end







--*************************************************************************************--
--** 				                  EVENT CALLBACKS           	    			 **--
--*************************************************************************************--

--function aircraft_load() end

--function aircraft_unload() end

function flight_start() 

    B747_flight_start_warning()

end

--function flight_crash() end

--function before_physics() end

function after_physics()

    B747_CAS_queue()
    B747_CAS_display()

    B747_warnings_EICAS_msg()

    B747_warning_monitor_AI()

end

--function after_replay() end



