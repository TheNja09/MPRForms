myCounter = 10
magicCounter = 30
function _OnFrame()
	World = ReadByte(Now + 0x00)
	Room = ReadByte(Now + 0x01)
	Place = ReadShort(Now + 0x00)
	Door = ReadShort(Now + 0x02)
	Map = ReadShort(Now + 0x04)
	Btl = ReadShort(Now + 0x06)
	Evt = ReadShort(Now + 0x08)
	Cheats()
end

function _OnInit()
	if GAME_ID == 0xF266B00B or GAME_ID == 0xFAF99301 and ENGINE_TYPE == "ENGINE" then--PCSX2
		Platform = 'PS2'
		Now = 0x032BAE0 --Current Location
		Save = 0x032BB30 --Save File
		Obj0 = 0x1C94100 --00objentry.bin
		Sys3 = 0x1CCB300 --03system.bin
		Btl0 = 0x1CE5D80 --00battle.bin
		Slot1 = 0x1C6C750 --Unit Slot 1
	elseif GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then--PC
		Platform = 'PC'
		Now = 0x0714DB8 - 0x56454E
		Save = 0x09A7070 - 0x56450E
		Obj0 = 0x2A22B90 - 0x56450E
    GamSpd = 0x07151D4 - 0x56454E
		Sys3 = 0x2A59DB0 - 0x56450E
		Btl0 = 0x2A74840 - 0x56450E
		Slot1 = 0x2A20C58 - 0x56450E
	end
end

function Events(M,B,E) --Check for Map, Btl, and Evt
	return ((Map == M or not M) and (Btl == B or not B) and (Evt == E or not E))
end

function Cheats()
    local _shortSpeed = ReadFloat(GamSpd)
    myCounter = myCounter - 1
    magicCounter = magicCounter - 1
    if ReadByte(Save+0x3524) == 3 and ReadLong(0x24AA2CA) == 0 and ReadByte(Slot1+0x180) <= ReadByte(Slot1+0x184) and ReadByte(Slot1+0x180) > 0 and _shortSpeed > 0.2 then -- If in limit form, Sora's MP is less than or equal to max MP, MP is not 0
        if ReadLong(0x2494573) > 500000 then --If any combination of L2 is pressed
            if myCounter <= 0 then -- If the counter is 0 or less
                do
                    if _shortSpeed > 0.2 and _shortSpeed < 1.5 then
                        WriteFloat(GamSpd, 0.25)
                        WriteByte(Slot1+0x180, (ReadByte(Slot1+0x180) - 1)) -- Reduce Sora's MP by 1
                        myCounter = 10 -- Set the counter to 10
                    end
                end
            end
        elseif ReadLong(0x24AA2CA) == 0 and _shortSpeed > 0.2 and _shortSpeed < 1.5 then
            WriteFloat(GamSpd, 1)
        end
    elseif ReadLong(0x24AA2CA) == 0 and _shortSpeed > 0.2 and _shortSpeed < 1.5 then
        WriteFloat(GamSpd, 1)
    end
    if ReadByte(Save+0x3524) == 1 and ReadByte(Slot1+0x180) <= ReadByte(Slot1+0x184) and ReadByte(Slot1+0x180) > 0 and ReadByte(Slot1+0x0) < ReadByte(Slot1+0x4) and ReadByte(Slot1+0x0) > 0 then -- If in valor form, current MP >= MAX MP, current HP > max HP, current HP > 0
        if ReadLong(0x2494573) > 500000 then --If any combination of L2 is pressed
            if myCounter <= 0 then -- If the counter is 0 or less
                do
                    WriteByte(Slot1+0x0, (ReadByte(Slot1+0x0) + 1)) -- +1 HP
                    WriteByte(Slot1+0x180, (ReadByte(Slot1+0x180) - 1)) -- Reduce Sora's MP by 1
                    myCounter = 1 -- Set the counter to 1
                end
            end
        end
    end
    local animpointer=ReadLong(0x1B2512)+0x2A8
    if ReadByte(Save+0x3524) == 2 then --If in wisdom form
        if ReadShort(Now+0) == 0x0310 and ReadShort(Now+8) == 0x38 then -- Port Royal Barrels
            WriteFloat(animpointer, 1, true)
		elseif ReadShort(Now+0) == 0x0505 and ReadShort(Now+8) == 0x4F then -- Dark Thorn
			WriteFloat(animpointer, 1, true)
		elseif ReadShort(Now+0) == 0x1C12 and ReadShort(Now+8) == 0x44 then -- TWTNW Buildings
			WriteFloat(animpointer, 1, true)
		elseif ReadShort(Now+0) == 0x2202 and ReadShort(Now+8) == 0x9D then -- Twilight Thorn
			WriteFloat(animpointer, 1, true)
		elseif ReadShort(Now+0) == 0x1A12 and ReadShort(Now+8) == 0x45 then -- TWTNW Outside Core
			WriteFloat(animpointer, 1, true)
        else WriteFloat(animpointer, 3, true)
        end
        WriteFloat(0x250D32E, 3) --QR1 iFrames
        WriteFloat(0x250D322, 250) --QR1 Speed
        WriteFloat(0x250D31E, 3) --QR1 Slide Time
        WriteFloat(0x250D326, 1) --QR1 Acceleration
        WriteFloat(0x250D32A, 0) --QR1 Deceleration
        WriteFloat(0x250D372, 3) --QR2 iFrames
        WriteFloat(0x250D366, 350) --QR2 Speed
        WriteFloat(0x250D362, 3) --QR2 Slide Time
        WriteFloat(0x250D36A, 1) --QR2 Acceleration
        WriteFloat(0x250D36E, 0) --QR2 Deceleration
        WriteFloat(0x250D3B6, 3) --QR3 iFrames
        WriteFloat(0x250D3AA, 450) --QR3 Speed
        WriteFloat(0x250D3A6, 3) --QR3 Slide Time
        WriteFloat(0x250D3AE, 1) --QR3 Acceleration
        WriteFloat(0x250D3B2, 0) --QR3 Deceleration
        WriteFloat(0x250D3FA, 3) --QR4 iFrames
        WriteFloat(0x250D3EE, 550) --QR4 Speed
        WriteFloat(0x250D3EA, 3) --QR4 Slide Time
        WriteFloat(0x250D3F2, 1) --QR4 Acceleration
        WriteFloat(0x250D3F6, 0) --QR4 Deceleration
        WriteFloat(0x250D43E, 3) --AX2 QR iFrames
        WriteFloat(0x250D432, 1000) --AX2 QR Speed
        WriteFloat(0x250D42E, 3) --AX2 QR Slide Time
        WriteFloat(0x250D436, 1) --AX2 QR Acceleration
        WriteFloat(0x250D43A, 0) --AX2 QR Deceleration
    elseif ReadByte(Save+0x3524) == 5 then --if in final form
        if ReadShort(Now+0) == 0x0310 and ReadShort(Now+8) == 0x38 then -- Port Royal Barrels
            WriteFloat(animpointer, 1, true)
		elseif ReadShort(Now+0) == 0x0505 and ReadShort(Now+8) == 0x4F then -- Dark Thorn
			WriteFloat(animpointer, 1, true)
		elseif ReadShort(Now+0) == 0x1C12 and ReadShort(Now+8) == 0x44 then -- TWTNW Buildings
			WriteFloat(animpointer, 1, true)
		elseif ReadShort(Now+0) == 0x2202 and ReadShort(Now+8) == 0x9D then -- Twilight Thorn
			WriteFloat(animpointer, 1, true)
		elseif ReadShort(Now+0) == 0x1A12 and ReadShort(Now+8) == 0x45 then -- TWTNW Outside Core
			WriteFloat(animpointer, 1, true)
        else WriteFloat(animpointer, 2, true)
        end
        WriteFloat(0x250D33E, -0.00001)
        WriteFloat(0x250D34A, -0.00001)
        WriteFloat(0x250D336, -0.00001)
        WriteFloat(0x250D402, -0.00001)
        WriteFloat(0x250D37E, -0.00001)
        WriteFloat(0x250D37A, -0.00001)
        WriteFloat(0x25136BA, -0.00001)
        WriteFloat(0x250D38E, -0.00001)
        WriteFloat(0x250D3BE, -0.00001)
        WriteFloat(0x251374A, -0.00001)
        WriteFloat(0x250D3D2, -0.00001)
        WriteFloat(0x250D3C2, -0.00001)
        WriteFloat(0x250D022, -0.00001)
        WriteFloat(0x250D416, -0.00001)
        WriteFloat(0x250D406, -0.00001)
        WriteFloat(0x250D342, 0)
        WriteFloat(0x250D386, 0)
        WriteFloat(0x250D3CA, 0)
        WriteFloat(0x250D40E, 0)
        WriteFloat(0x250D452, 0)
        WriteFloat(0x250D332, 40) --Glide 1 Speed (Default: 16)
        WriteFloat(0x250D376, 50) --Glide 2 Speed (Default: 20)
        WriteFloat(0x250D3BA, 60) --Glide 3 Speed (Default: 24)
        WriteFloat(0x250D3FE, 80) --Glide MAX Speed (Default: 32)
        WriteFloat(0x250D442, 160) --Glide AX2 Speed (Default: 64)
        --Glide Turn Speeds: Default is 0.05235987902
        WriteFloat(0x250D34E, 0.1)
        WriteFloat(0x250D392, 0.2)
        WriteFloat(0x250D3D6, 0.3)
        WriteFloat(0x250D41A, 0.4)
        WriteFloat(0x250D45E, 0.5)
    elseif ReadByte(Save+0x3524) == 3 then --if in limit form
        WriteFloat(0x250D352, 42) --DR1 iFrames
        WriteFloat(0x250D396, 42) --DR2 iFrames
        WriteFloat(0x250D3DA, 42) --DR3 iFrames
        WriteFloat(0x250D41E, 42) --DR4 iFrames
        WriteFloat(0x250D462, 42) --AX2 DR iFrames
    elseif ReadByte(Save+0x3524) == 4 then --if in master form
        WriteByte(Sys3+0x9E0,6) -- Fire Cost: 15
        WriteByte(Sys3+0x15E0,6) -- Fira Cost: 15
        WriteByte(Sys3+0x1610,6) -- Firaga Cost: 15
        WriteByte(Sys3+0xA40,7) -- Blizzard Cost: 15
        WriteByte(Sys3+0x1640,7) -- Blizzara Cost: 15
        WriteByte(Sys3+0x1670,7) -- Blizzaga Cost: 15
        WriteByte(Sys3+0xA10,9) -- Thunder Cost: 15
        WriteByte(Sys3+0x16A0,9) -- Thundara Cost: 15
        WriteByte(Sys3+0x16D0,9) -- Thundaga Cost: 15
        WriteByte(Sys3+0xA70,100) -- Cure Cost: 3
        WriteByte(Sys3+0x1700,100) -- Cura Cost: 2
        WriteByte(Sys3+0x1730,100) -- Curaga Cost: 2
        WriteByte(Sys3+0x1F40,15) -- Magnet Cost: 15
        WriteByte(Sys3+0x1F70,15) -- Magnera Cost: 15
        WriteByte(Sys3+0x1FA0,15) -- Magnega Cost: 15
        WriteByte(Sys3+0x1FD0,5) -- Reflect Cost: 3
        WriteByte(Sys3+0x2000,5) -- Reflera Cost: 2
        WriteByte(Sys3+0x2030,5) -- Reflega Cost: 1
    elseif ReadByte(Save+0x3524) == 1 then --if in valor form
        WriteFloat(0x250D312, 800)
        WriteFloat(0x250D356, 1000) -- Sora High Jump 2
        WriteFloat(0x250D39A, 1200) -- Sora High Jump 3
        WriteFloat(0x250D3DE, 1400) -- Sora High Jump MAX
        WriteFloat(0x250D422, 3000) -- Sora High Jump AX2
    else
        WriteFloat(animpointer, 1, true) --if in base form
        WriteFloat(0x250D32E, 0) --QR1 iFrames
        WriteFloat(0x250D322, 30) --QR1 Speed
        WriteFloat(0x250D31E, 14) --QR1 Slide Time
        WriteFloat(0x250D326, 0.93) --QR1 Acceleration
        WriteFloat(0x250D32A, 0.93) --QR1 Deceleration
        WriteFloat(0x250D372, 8) --QR2 iFrames
        WriteFloat(0x250D366, 34) --QR2 Speed
        WriteFloat(0x250D362, 18) --QR2 Slide Time
        WriteFloat(0x250D36A, 0.95) --QR2 Acceleration
        WriteFloat(0x250D36E, 0.93) --QR2 Deceleration
        WriteFloat(0x250D3B6, 12) --QR3 iFrames
        WriteFloat(0x250D3AA, 38) --QR3 Speed
        WriteFloat(0x250D3A6, 40) --QR3 Slide Time
        WriteFloat(0x250D3AE, 0.96) --QR3 Acceleration
        WriteFloat(0x250D3B2, 0.93) --QR3 Deceleration
        WriteFloat(0x250D3FA, 16) --QR4 iFrames
        WriteFloat(0x250D3EE, 38) --QR4 Speed
        WriteFloat(0x250D3EA, 40) --QR4 Slide Time
        WriteFloat(0x250D3F2, 0.98) --QR4 Acceleration
        WriteFloat(0x250D3F6, 0.93) --QR4 Deceleration
        WriteFloat(0x250D43E, 40) --AX2 QR iFrames
        WriteFloat(0x250D432, 38) --AX2 QR Speed
        WriteFloat(0x250D42E, 40) --AX2 QR Slide Time
        WriteFloat(0x250D436, 0.98) --AX2 QR Acceleration
        WriteFloat(0x250D43A, 0.93) --AX2 QR Deceleration
        WriteByte(Sys3+0x9E0,12) -- Fire Cost: 15
        WriteByte(Sys3+0x15E0,12) -- Fira Cost: 15
        WriteByte(Sys3+0x1610,12) -- Firaga Cost: 15
        WriteByte(Sys3+0xA40,15) -- Blizzard Cost: 15
        WriteByte(Sys3+0x1640,15) -- Blizzara Cost: 15
        WriteByte(Sys3+0x1670,15) -- Blizzaga Cost: 15
        WriteByte(Sys3+0xA10,18) -- Thunder Cost: 15
        WriteByte(Sys3+0x16A0,18) -- Thundara Cost: 15
        WriteByte(Sys3+0x16D0,18) -- Thundaga Cost: 15
        WriteByte(Sys3+0xA70,255) -- Cure Cost: 3
        WriteByte(Sys3+0x1700,255) -- Cura Cost: 2
        WriteByte(Sys3+0x1730,255) -- Curaga Cost: 2
        WriteByte(Sys3+0x1F40,30) -- Magnet Cost: 15
        WriteByte(Sys3+0x1F70,30) -- Magnera Cost: 15
        WriteByte(Sys3+0x1FA0,30) -- Magnega Cost: 15
        WriteByte(Sys3+0x1FD0,10) -- Reflect Cost: 3
        WriteByte(Sys3+0x2000,10) -- Reflera Cost: 2
        WriteByte(Sys3+0x2030,10) -- Reflega Cost: 1
        WriteFloat(0x250D352, 10) --DR1 iFrames
        WriteFloat(0x250D396, 16) --DR2 iFrames
        WriteFloat(0x250D3DA, 24) --DR3 iFrames
        WriteFloat(0x250D41E, 32) --DR4 iFrames
        WriteFloat(0x250D462, 36) --AX2 DR iFrames
        --Glide Variables below!!! Good luck!!!
        WriteFloat(0x250D33E, 3)
        WriteFloat(0x250D34A, 10)
        WriteFloat(0x250D336, 0.015)
        WriteFloat(0x250D402, 0.01147)
        WriteFloat(0x250D37E, 30)
        WriteFloat(0x250D37A, 0.015)
        WriteFloat(0x25136BA, 0.01147)
        WriteFloat(0x250D38E, 10)
        WriteFloat(0x250D3BE, 30)
        WriteFloat(0x251374A, 0.015)
        WriteFloat(0x250D3D2, 0.01147)
        WriteFloat(0x250D3C2, 10)
        WriteFloat(0x250D022, 30)
        WriteFloat(0x250D416, 10)
        WriteFloat(0x250D406, 30)
        --Acceleration Values
        WriteFloat(0x250D342, 0.91)
        WriteFloat(0x250D386, 0.93)
        WriteFloat(0x250D3CA, 0.95)
        WriteFloat(0x250D40E, 0.97)
        WriteFloat(0x250D452, 0.98)
        --Speed Values
        WriteFloat(0x250D332, 16) --Glide 1 Speed (Default: 16)
        WriteFloat(0x250D376, 20) --Glide 2 Speed (Default: 20)
        WriteFloat(0x250D3BA, 24) --Glide 3 Speed (Default: 24)
        WriteFloat(0x250D3FE, 32) --Glide MAX Speed (Default: 32)
        WriteFloat(0x250D442, 64) --Glide AX2 Speed (Default: 64)
        --Glide Turn Speeds: Default is 0.05235987902
        WriteFloat(0x250D34E, 0.05235987902)
        WriteFloat(0x250D392, 0.05235987902)
        WriteFloat(0x250D3D6, 0.05235987902)
        WriteFloat(0x250D41A, 0.05235987902)
        WriteFloat(0x250D45E, 0.05235987902)
        WriteFloat(0x250D312, 235)
        WriteFloat(0x250D356, 310) -- Sora High Jump 2
        WriteFloat(0x250D39A, 385) -- Sora High Jump 3
        WriteFloat(0x250D3DE, 585) -- Sora High Jump MAX
        WriteFloat(0x250D422, 585) -- Sora High Jump AX2
    end
WriteFloat(Sys3+0x17CE4, 8) -- Base Speed: DS = 8
WriteFloat(Sys3+0x17D18, 60) -- Valor Form: DS = 12
WriteFloat(Sys3+0x17D4C, 12) -- Wisdom Form: DS = 12
WriteFloat(Sys3+0x17D80, 20) -- Master Form: DS = 10
WriteFloat(Sys3+0x17DB4, 16) -- Final Form: DS = 16
WriteFloat(Sys3+0x17E1C, 18) -- Lion Sora: DS = 18
WriteFloat(Sys3+0x17E50, 7) -- Mermaid Sora: DS = 7
WriteFloat(Sys3+0x18190, 20) -- Carpet Sora: DS = 20
WriteFloat(Sys3+0x181F8, 8) -- Dice Sora: DS = 8
WriteFloat(Sys3+0x1822C, 8) -- Card Sora: DS = 8
WriteFloat(Sys3+0x18364, 8) -- Limit Form: DS = 8
--Change Drive/Summon Costs
--WriteByte(Sys3+0x03E0,2) -- Valor
--WriteByte(Sys3+0x0410,4) -- Wisdom
--WriteByte(Sys3+0x7A30,3) -- Limit
--WriteByte(Sys3+0x04A0,4) -- Master
--WriteByte(Sys3+0x04D0,6) -- Final
--WriteByte(Sys3+0x0500,1) -- Anti
--WriteByte(Sys3+0x5180,3) -- Chicken
--WriteByte(Sys3+0x1070,5) -- Stitch
--WriteByte(Sys3+0x10A0,3) -- Genie
--WriteByte(Sys3+0x37A0,3) -- Pan
end
