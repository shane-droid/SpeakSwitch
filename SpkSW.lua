-- copyright: shane-droid. Not public domain. Date 03 Feb 2022
-- not for use without author's permission
-- written for use on Edgetx 2.6, Transmitter Tx16s
-- requires Amber sound pack

--things to Note:
-- 	Switch SF: to Disarm is pull toward user.
-- 	Make sure radio is calibrated and 6POS switch is calibrated
-- 	using EDGETX campanion reuires 2.6 version and calibrated setting from PHYSICAL radio to use 6POS switch.

--Purpose:
--This script allows any button to play an audio file without effecting channel output.
-- i.e. You can test a switch to see what it does, before initiating the action.

--Usage:
--move any switch, and an adio notification will play. to activate that switch, Pull switch SH down [ toward user]

--installation:
--	copy this script to radio SD card SCRIPTS\FUNCTIONS\
--	install Amber sound pack
--		download link: http://hmvc.eu/Amber22.rar
--		use 7zip to open it: https://www.7-zip.org/download.html
--		place the contents on SDcard in sounds

--ModelSetup on radio: [ for plane][similar for other craft]
-- 	Create 4ch plane
--	create 27 logical switches [ starting from L01], type = Sticky,  V1 = points to same logic switch [ eg L01  sticky, V1 = L01, and V2 = --]
--	create 27 Special functions [ starting from SF1], set switch to corresponding logical switch [eg SF1 = L01]
--	create 1 special function at postion 64, set switch to ON[in the drop down, not the check box], set the action to LUA script, and select this script.


--Customsing the script:
--	generally, you can change the audio file to any other audio file in the sounds directory by replacing file name.
--		eg change "smokon.wav"  to "geardn.wav"
-- 	Subfolder in sound directory can be used by "\subDirName\someAudioFile.wav"


------ START CUSTOMISE----------------------------------------------------------------

-- AUDIO FILES: Customise: this audio plays when a switch has been engaged.
local activated = "actvd.wav"

--TOGGLE SWITCH: Customise: This is the switch used to toggle the activation  ON/OFF: only 2 postion switch: other possition is used for OFF.
--							("SH" .. CHAR_DOWN)  or ("SH" .. CHAR_UP): can change "SH" to any other 2 pos switch name.
local toggleActive       =  getSwitchIndex("SH" .. CHAR_DOWN)--SH pulled toward user
local toggleActivatedFlag = 1  -- don't touch.


--SwitchSettings : Customise : see comments for SA UP directly bellow
local switchSettings = {
					-- switch SA UP
					SAup = {audioFile = "lhtsof.wav", -- audio file name: change this to any other audio
					
							Channel = 5, -- channel you want this switch to control
							ChannelValue = 100, -- the value from -100 to +100
							
							LogicSwitchIndex = getSwitchIndex("L01"), 
							SpecialFuctionIndex = 0,
							switchIndex = getSwitchIndex("SA" .. CHAR_UP), 
							notSwitchIndex = getSwitchIndex("!SA" .. CHAR_UP),
							activatedFlag = 1, 
							testFlag = 1
							},
					SAmid = {audioFile = "lhtson.wav", 
					
							Channel = 5,
							ChannelValue = 0,
							
							LogicSwitchIndex = getSwitchIndex("L02"),
							SpecialFuctionIndex = 1,
							switchIndex = getSwitchIndex("sa-"), 
							notSwitchIndex = getSwitchIndex("!sa-"),
							activatedFlag = 0, 
							testFlag = 0
							},
					SAdown = {audioFile = "smokon.wav", 
							 
							Channel = 5,
							ChannelValue = -100,
							
							LogicSwitchIndex = getSwitchIndex("L03"),
							SpecialFuctionIndex = 2,
							switchIndex = getSwitchIndex("SA" .. CHAR_DOWN), 
							notSwitchIndex = getSwitchIndex("!SA" .. CHAR_DOWN),
							activatedFlag = 0, 
							testFlag = 0
							},
					SBup = {audioFile = "geardn.wav", 
							 
							Channel = 6,
							ChannelValue = 100,
							
							LogicSwitchIndex = getSwitchIndex("L04"),
							SpecialFuctionIndex = 3,
							switchIndex = getSwitchIndex("SB" .. CHAR_UP), 
							notSwitchIndex = getSwitchIndex("!SB" .. CHAR_UP),
							activatedFlag = 1, 
							testFlag = 1
							},
					SBmid = {audioFile = "bomrel.wav", 
							 
							Channel = 6,
							ChannelValue = 0,
							
							LogicSwitchIndex = getSwitchIndex("L05"),
							SpecialFuctionIndex = 4,
							switchIndex = getSwitchIndex("sb-"), 
							notSwitchIndex = getSwitchIndex("!sb-"),
							activatedFlag = 0, 
							testFlag = 0
							},
					SBdown = {audioFile = "gearup.wav", 
							 
							Channel = 6,
							ChannelValue = -100,
							
							LogicSwitchIndex = getSwitchIndex("L06"),
							SpecialFuctionIndex = 5,
							switchIndex = getSwitchIndex("SB" .. CHAR_DOWN), 
							notSwitchIndex = getSwitchIndex("!SB" .. CHAR_DOWN),
							activatedFlag = 0, 
							testFlag = 0
							},
					SCup = {audioFile = "off.wav", 
							
							Channel = 7,
							ChannelValue = 100,
							
							LogicSwitchIndex = getSwitchIndex("L07"), 
							SpecialFuctionIndex = 6,
							switchIndex = getSwitchIndex("SC" .. CHAR_UP), 
							notSwitchIndex = getSwitchIndex("!SC" .. CHAR_UP),
							activatedFlag = 1, 
							testFlag = 1
							},
					SCmid = {audioFile = "airmod.wav", 
							 
							Channel = 7,
							ChannelValue = 0,
							
							LogicSwitchIndex = getSwitchIndex("L08"),
							SpecialFuctionIndex = 7,
							switchIndex = getSwitchIndex("sc-"), 
							notSwitchIndex = getSwitchIndex("!sc-"),
							activatedFlag = 0, 
							testFlag = 0
							},
					SCdown = {audioFile = "turtle.wav", 
							 
							Channel = 7,
							ChannelValue = -100,
							
							LogicSwitchIndex = getSwitchIndex("L09"),
							SpecialFuctionIndex = 8,
							switchIndex = getSwitchIndex("SC" .. CHAR_DOWN), 
							notSwitchIndex = getSwitchIndex("!SC" .. CHAR_DOWN),
							activatedFlag = 0, 
							testFlag = 0
							},
					SDup = {audioFile = "angl.wav", 
							 
							Channel = 8,
							ChannelValue = 100,
							
							LogicSwitchIndex = getSwitchIndex("L10"),
							SpecialFuctionIndex = 9,
							switchIndex = getSwitchIndex("SD" .. CHAR_UP), 
							notSwitchIndex = getSwitchIndex("!SD" .. CHAR_UP),
							activatedFlag = 1, 
							testFlag = 1
							},
					SDmid = {audioFile = "hrznmd.wav", 
							 
							Channel = 8,
							ChannelValue = 0,
							
							LogicSwitchIndex = getSwitchIndex("L11"),
							SpecialFuctionIndex = 10,
							switchIndex = getSwitchIndex("sd-"), 
							notSwitchIndex = getSwitchIndex("!sd-"),
							activatedFlag = 0, 
							testFlag = 0
							},
					SDdown = {audioFile = "acromd.wav", 
							
							Channel = 8,
							ChannelValue = -100,
							
							LogicSwitchIndex = getSwitchIndex("L12"), 
							SpecialFuctionIndex = 11,
							switchIndex = getSwitchIndex("SD" .. CHAR_DOWN), 
							notSwitchIndex = getSwitchIndex("!SD" .. CHAR_DOWN),
							activatedFlag = 0, 
							testFlag = 0
							},		
					SEup = {audioFile = "flapdn.wav", 
							 
							Channel = 9,
							ChannelValue = 100,
							
							LogicSwitchIndex = getSwitchIndex("L13"),
							SpecialFuctionIndex = 12,
							switchIndex = getSwitchIndex("SE" .. CHAR_UP), 
							notSwitchIndex = getSwitchIndex("!SE" .. CHAR_UP),
							activatedFlag = 1, 
							testFlag = 1
							},
					SEmid = {audioFile = "flaphf.wav", 
							
							Channel = 9,
							ChannelValue = 0,
							
							LogicSwitchIndex = getSwitchIndex("L14"), 
							SpecialFuctionIndex = 13,
							switchIndex = getSwitchIndex("se-"), 
							notSwitchIndex = getSwitchIndex("!se-"),
							activatedFlag = 0, 
							testFlag = 0
							},
					SEdown = {audioFile = "flapup.wav", 
							
							Channel = 9,
							ChannelValue = -100,
							
							LogicSwitchIndex = getSwitchIndex("L15"), 
							SpecialFuctionIndex = 14,
							switchIndex = getSwitchIndex("SE" .. CHAR_DOWN), 
							notSwitchIndex = getSwitchIndex("!SE" .. CHAR_DOWN),
							activatedFlag = 0, 
							testFlag = 0
							},
					SFup = {audioFile = "armed.wav", 
							 
							Channel = 10,
							ChannelValue = 100,
							
							LogicSwitchIndex = getSwitchIndex("L16"),
							SpecialFuctionIndex = 15,
							switchIndex = getSwitchIndex("SF" .. CHAR_UP), 
							notSwitchIndex = getSwitchIndex("!SF" .. CHAR_UP),
							activatedFlag = 0, 
							testFlag = 0
							},
					SFdown = {audioFile = "darmed.wav", 
							 
							Channel = 10,
							ChannelValue = -100,
							
							LogicSwitchIndex = getSwitchIndex("L17"),
							SpecialFuctionIndex = 16,
							switchIndex = getSwitchIndex("SF" .. CHAR_DOWN), 
							notSwitchIndex = getSwitchIndex("!SF" .. CHAR_DOWN),
							activatedFlag = 1, 
							testFlag = 1
							},
					SGup = {audioFile = "lowrat.wav", 
							 
							Channel = 11,
							ChannelValue = 100,
							
							LogicSwitchIndex = getSwitchIndex("L18"),
							SpecialFuctionIndex = 17,
							switchIndex = getSwitchIndex("SG" .. CHAR_UP), 
							notSwitchIndex = getSwitchIndex("!SG" .. CHAR_UP),
							activatedFlag = 1, 
							testFlag = 1
							},
					SGmid = {audioFile = "midrat.wav", 
							 
							Channel = 11,
							ChannelValue = 0,
							
							LogicSwitchIndex = getSwitchIndex("L19"),
							SpecialFuctionIndex = 18,
							switchIndex = getSwitchIndex("sg-"), 
							notSwitchIndex = getSwitchIndex("!sg-"),
							activatedFlag = 0, 
							testFlag = 0
							},
					SGdown = {audioFile = "hirat.wav", 
							 
							Channel = 11,
							ChannelValue = -100,
							
							LogicSwitchIndex = getSwitchIndex("L20"),
							SpecialFuctionIndex = 19,
							switchIndex = getSwitchIndex("SG" .. CHAR_DOWN), 
							notSwitchIndex = getSwitchIndex("!SG" .. CHAR_DOWN),
							activatedFlag = 0, 
							testFlag = 0
							},
					SHup = {audioFile = "dseng", 
							 
							Channel = 12,
							ChannelValue = 100,
							
							LogicSwitchIndex = getSwitchIndex("L21"),
							SpecialFuctionIndex = 20,
							switchIndex = getSwitchIndex("SH" .. CHAR_UP), 
							notSwitchIndex = getSwitchIndex("!SH" .. CHAR_UP),
							activatedFlag = 1, 
							testFlag = 1
							},
					SHdown = {audioFile = "actv", 
							 
							Channel = 12,
							ChannelValue = -100,
							
							LogicSwitchIndex = getSwitchIndex("L22"),
							SpecialFuctionIndex = 21,
							switchIndex = getSwitchIndex("SH" .. CHAR_DOWN), 
							notSwitchIndex = getSwitchIndex("!SH" .. CHAR_DOWN),
							activatedFlag = 0, 
							testFlag = 0
							},
					_6P_1 = {audioFile = "manmd.wav", 
							 
							Channel = 13,
							ChannelValue = 100,
							
							LogicSwitchIndex = getSwitchIndex("L23"),
							SpecialFuctionIndex = 22,
							switchIndex = getSwitchIndex("\1386P1"), 
							notSwitchIndex = getSwitchIndex("!\1386P1"),
							activatedFlag = 1, 
							testFlag = 1
							},
					_6P_2 = {audioFile = "prelnc.wav", 
							
							Channel = 13,
							ChannelValue = 60,
							
							LogicSwitchIndex = getSwitchIndex("L24"), 
							SpecialFuctionIndex = 23,
							switchIndex = getSwitchIndex("\1386P2"), 
							notSwitchIndex = getSwitchIndex("!\1386P2"),
							activatedFlag = 0, 
							testFlag = 0
							},
					_6P_3 = {audioFile = "takoff.wav", 
							 
							Channel = 13,
							ChannelValue = 30,
							
							LogicSwitchIndex = getSwitchIndex("L25"),
							SpecialFuctionIndex = 24,
							switchIndex = getSwitchIndex("\1386P3"), 
							notSwitchIndex = getSwitchIndex("!\1386P3"),
							activatedFlag = 0, 
							testFlag = 0
							},
					_6P_4 = {audioFile = "normal.wav", 
							 
							Channel = 13,
							ChannelValue = -30,
							
							LogicSwitchIndex = getSwitchIndex("L26"),
							SpecialFuctionIndex = 25,
							switchIndex = getSwitchIndex("\1386P4"), 
							notSwitchIndex = getSwitchIndex("!\1386P4"),
							activatedFlag = 0, 
							testFlag = 0
							},
					_6P_5 = {audioFile = "lndgmd.wav", 
							 
							Channel = 13,
							ChannelValue = -60,
							
							LogicSwitchIndex = getSwitchIndex("L27"),
							SpecialFuctionIndex = 26,
							switchIndex = getSwitchIndex("\1386P5"), 
							notSwitchIndex = getSwitchIndex("!\1386P5"),
							activatedFlag = 0, 
							testFlag = 0
							},
					_6P_6 = {audioFile = "rtl.wav", 
							 
							Channel = 13,
							ChannelValue = -100,
							
							LogicSwitchIndex = getSwitchIndex("L28"),
							SpecialFuctionIndex = 27,
							switchIndex = getSwitchIndex("\1386P6"), 
							notSwitchIndex = getSwitchIndex("!\1386P6"),
							activatedFlag = 0, 
							testFlag = 0
							},
					

				}

-- END CUSTOMISATION--------------------------------------------------------------------





-- The LUA function setStickySwitch() uses logic switch numer 0-64, not a Switch index id or not a switch name like "L01"
-- This fuction returns TRUE if the logic switch buffer is Full
local function SetStickySwitchBySwitchIndex(switchIndex, bool)

	lsName = getSwitchName(switchIndex)
    lsnameSub = string.gsub(lsName,"L","")
	LsNum = tonumber(lsnameSub) -1 
	
	setStickySwitch(LsNum, bool)
	 
	 return setStickySwitch(LsNum, bool)
end

--MAIN Function: 	if physical switch is changed when toggle active: turns loggical switch on
--					if phys. switch changed  & toggle OFF : logicval switch maintains state
local function CheckSwitchPosition(switchInList)
	--ACTIVE TOGGLE
	if getSwitchValue(toggleActive) == true then
	
				if toggleActivatedFlag == 0 then
					playFile("actv.wav")
					toggleActivatedFlag = 1
				end
				--switch ACTIVE //turn on LS01 if not on.
				if	switchInList.activatedFlag == 0 and getSwitchValue(switchInList.switchIndex) == true then 
						SetStickySwitchBySwitchIndex(switchInList.LogicSwitchIndex, true)
						playFile(switchInList.audioFile)
						playFile(activated)
						switchInList.activatedFlag = 1
						switchInList.testFlag = 1
				--switch ! SA Up //Turn off LS01
				elseif 	switchInList.activatedFlag == 1 and getSwitchValue(switchInList.notSwitchIndex) == true then 
						SetStickySwitchBySwitchIndex(switchInList.LogicSwitchIndex, false)
						switchInList.activatedFlag = 0
						switchInList.testFlag = 0
				end
				
	-- DEActive
	elseif	getSwitchValue(switchInList.switchIndex) == true and switchInList.testFlag == 0 then--switch SA Up
				if toggleActivatedFlag == 1 then
					playFile("dseng.wav")
					toggleActivatedFlag = 0
				end
				playFile(switchInList.audioFile)
				switchInList.testFlag = 1
				
	elseif 	getSwitchValue(switchInList.notSwitchIndex) == true then 
				if toggleActivatedFlag == 1 then
					playFile("dseng.wav")
					toggleActivatedFlag = 0
				end
				switchInList.testFlag = 0
	end	
end

--used for initialising logical switches
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

--used for initialising logical switches
--creates list of active logical switches
local initalActiveSwitchesList = {}
local function SetInitalActiveSwitchesList()
	for index, value in pairs(switchSettings) do
		if value.activatedFlag == 1	then
			table.insert(initalActiveSwitchesList,value.LogicSwitchIndex)
		end	
			
	end
	
end

--used for initialising logical switches
-- sets the inital logical switches to active
-- manages logical switch buffer as can only activate 8 logical switches in one pass
local stickySwitchBufferCounter = 1
local function initStickySwitches()
		 
	if stickySwitchBufferCounter <= tablelength(initalActiveSwitchesList) then --may need to add +1
		for i = stickySwitchBufferCounter, tablelength(initalActiveSwitchesList) do
				if SetStickySwitchBySwitchIndex(initalActiveSwitchesList[i], true) ~= false then  
					stickySwitchBufferCounter = stickySwitchBufferCounter + 1
				end
		end
	end

end

----set special functions on transmitter to values in table switchSettings
---- binds the logical switch to channel on the radio
local function setSpeacialFunctions()
	for index, value in pairs(switchSettings) do
		model.setCustomFunction(value.SpecialFuctionIndex,
							{switch= value.LogicSwitchIndex; 
							["func"]=0 ; 
							param=value.Channel ; 
							value=value.ChannelValue ; 
							mode=0 ; 
							active=1})
	
	end
end


-- loop though settings list and acces variables with value.variablename
local function SwitchPositionLoop()

	for index, value in pairs(switchSettings) do
			CheckSwitchPosition(value)
	end

end



-- the radio runs this function 1st and once
local function init_func()
	SetInitalActiveSwitchesList()
	setSpeacialFunctions()
end

--the radio runs this function 2nd, then 10x per second
local function run_func()
	initStickySwitches()
	SwitchPositionLoop()
end


return { run=run_func, init=init_func }