--networking test
netRequestDataref=find_dataref("autoatc/networking/url")
netdataDataref=find_dataref("autoatc/networking/data")
netstatusDataref=find_dataref("autoatc/networking/urlstatus")
local hoppielogon=""

local file = io.open("Resources/plugins/AutoATC/hoppieconfig.txt", "r")
local started=false
if file ~= nil then
	io.input(file)
	hoppielogon = io.read()
	io.close(file)
end

local lastNetCheck=0
local lastNetPoll=0
function checkNet()
    local currentData=netRequestDataref
    local diff=(simDRTime-lastNetCheck)
    if diff<2 then return end
    print("current status="..netstatusDataref)
    lastNetCheck=simDRTime
    if netstatusDataref==200 then
      print("Got URL Data")
      print(currentData)
      netdataDataref=" "
      netstatusDataref=0
    end

    -- peek
    --ok {9979886 BAW1234 cpdlc {/data2/1//N/SPARKY744 HOPPIE TEST}} {9979890 BAW1234 cpdlc {/data2/1//N/SPARKY744 HOPPIE TEST}} {9979897 BAW1234 cpdlc {/data2/2//N/NEW SPARKY744 HOPPIE TEST}} 
    -- ok {9979964 LYBE cpdlc {/data2/2//NE/LOGON ACCEPTED}}
    -- /data2/35/1/NE/LOGON ACCEPTED
    -- error {illegal logon code}
  end
  function checkPoll()
    local from="BAW1234"
    local to="LYBE"
    netstatusDataref=2
    netRequestDataref="{'url':'https://www.hoppie.nl/acars/system/connect.html?from="..from..
        "&type=POLL"..
        "&to="..to..
        "','logon':'"..hoppielogon.."'" ..
        "}"
  end
  function netTest(phase, duration)
    if phase == 0 then
        if netstatusDataref==nil then return end
        if string.len(hoppielogon)==0 then return end
        print("Do netTest")
        netstatusDataref=2
        lastNetPoll=simDRTime
        local from="BAW1234"
        local to="LYBE"
        local packet="/data2/1//Y/REQUEST LOGON"
        netRequestDataref="{'url':'https://www.hoppie.nl/acars/system/connect.html?from="..from..
        "&type=cpdlc"..
        "&to="..to..
        "','packet':'"..packet..
        "','logon':'"..hoppielogon.."'" ..
        "}"
        started=true
    end
  end
  B747CMD_netTest  = deferred_command("laminar/B747/networking/nettest", "Networking Test", netTest)


  acarsSystem.remote={
    receive=function()
        if netstatusDataref==nil then return end
        if netstatusDataref~=0 then
            checkNet()
        end
        if started then
            local diff=(simDRTime-lastNetPoll)
            if diff>75 then
                lastNetPoll=simDRTime
                checkPoll()
            end
        end
    end,
    send=function()
        if netstatusDataref==nil then return end
    end,
    hasLogonDetails=function()
      return string.len(hoppielogon)==0
    end
  }
