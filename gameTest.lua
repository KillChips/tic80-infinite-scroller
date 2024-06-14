---@diagnostic disable: undefined-global, lowercase-global, trailing-space
-- title:   game titlez
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua


-- [[ Variables and Classes ]] --
local p = {
	id = 16,
	x = 2,
	y = 11,
	vel_y = 0,
	width = 1,
	height = 2,
}

local unit = {
	id = 44,
	x = 31,
	y = 11,

	-- arguments in care of the collisions
	width = 0,
	height = 0,
	w = 0,
	h = 0,
}

local units = {}

local gameState = "startMenu"
local bit_size = 8
local scroll_x = 0
local t = 0
local score = 0



-- [[ Methods ]] --
-- Creates a new instance of unit
function unit:new (o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o

end

-- Spawns the type of unit
function unit:spawn (type)

	type = type or math.random(0,1)
	trace(type)

	if type == 0 then
		self.id = 40
		
		self.width = 4
		self.height = 1
		self.w = 4
		self.h = 2
		
		
	elseif type == 1 then
		self.id = 44

		self.width = 2
		self.height = 2
		self.w = 3
		self.h = 3
		

	end

end



function TIC()

	if gameState == "startMenu" then
		startMenu()
	elseif gameState == "gameRunning" then
		t = t + 1
		score = t // 20
		gameRunning()
	elseif  gameState == "gameOver" then
		gameOver()
	end

end

-- [[ Menus ]] --
function startMenu()
		cls(0)
		print("Press Z to start", 84, 84)
		if btn(4) then
			gameState = "gameRunning"
		end
end

function gameOver()
	cls(0)
	print("gameOver", 84, 84)
	print("Score: " .. score, 84, 94)
end

-- Function to draw the things on the screen
function draw()
	cls(0)
	map(scroll_x, 0)
	spr(p.id, p.x * bit_size, p.y * bit_size, 0, 1, 0, 0, 1, 2)

	-- Draw enemy units
	-- Add a new unit to the table
	for _, v in ipairs(units) do
		--if v.id == 40 then
			spr(v.id, v.x * bit_size, v.y * bit_size, 0, 1, 0, 0, v.w, v.h)
		--elseif v.id == 44 then
		--	spr(v.id, v.x * bit_size, v.y * bit_size, 0, 1, 0, 0, 2, 2)

	end

--spr(unit.id_1, unit.x * bit_size, unit.y * bit_size, 0, 1, 0, 0, 8, 8)  -- Adjust these values to change the range of unit positions
end

-- Mangage creation, movement and deletion of units
function unitManager()
	-- Spawn unit
	if t % 60 == 0 then	
		local unit = unit:new()
		unit:spawn()
		table.insert(units, unit)
	end
	-- Move the unit and reset it when it goes off screen
	for i, v in ipairs(units) do
		v.x = v.x - 0.25
		-- Check for collision with the obstacle
		if checkCollision(p.x, p.y, p.width, p.height, v.x, v.y, v.width, v.height) then
			-- Handle the collision
			print("Collision detected!")
			gameState = "gameOver"
		
		end
		-- Remove the unit if it goes off screen
		if v.x < -30 then
			table.remove(units, i)
		end
	end
	
end

-- Define a function to check if two rectangles overlap
function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and
		   x2 < x1 + w1 and
		   y1 < y2 + h2 and
		   y2 < y1 + h1
end

-- Function of th main game loop
function gameRunning()

	cls(0)
	gameState = "gameRunning"

	-- Map Scrolling
	scroll_x = scroll_x + 0.075
	if scroll_x > 30 then
		scroll_x = 0
	end

	-- [[ Player Movement ]] --
	-- Jump Up
	-- if arrow up is pressed and player is on the ground
	if btnp(0) and p.vel_y == 0 then

			p.vel_y =- 1.2 			-- jump up value
	end

	do
		p.y = p.y + p.vel_y			-- add the jump value to the player's y position
		p.vel_y = p.vel_y + 0.1		-- decrease the jump value to simulate gravity


		if p.y >= 11 then			-- checks if player is back on the ground
			p.y = 11
			p.vel_y = 0				-- if yes then set the jump value to 0
		end

	end

	unitManager()
	draw()


end

-- <TILES>
-- 001:aaaaaaaaaaaaaaaaaaccaaaaaccccccaaaacccaaaaaaaaaaaaaaaaaaaaaaaacc
-- 002:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaccaccaaacccaaaaa
-- 003:6666666666666666662666266222622262222202222022222022202222222222
-- 004:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 005:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 006:2222222222222222222222222222222222220222222222222222222222222222
-- 007:2222222222222222222222222222220222222222222222222022222222222222
-- 016:0000000000111000001110000001000000111000010101001001001010011001
-- 017:aaaaaaaaaaaacaaaaaacccaaacccccccaaaccccaaaaaaaaaaaaaaaaaaaaaaaaa
-- 018:caacaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaccaaaaaccccaaaaaaaaaaaaaaaaa
-- 020:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 021:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 022:2222222222222222222222222220222222222222222222222222222222222222
-- 023:2222222222222222022222222222222222222222222220222222222222222222
-- 030:0000000000000000000000000000000000000000000000000e000000eee00000
-- 032:00100100001000100001000100100010b10001b00bbbbb000040400000000000
-- 040:0000000000000000000000000000000000000000000000000000000000000666
-- 041:0000000000000000000000000000000000000000000000006600000066660000
-- 042:0000000000000000000000000000000000000000000000000000000000666600
-- 045:000000000000000e0000000e0000000e0000000e0000000e000000ee000000ed
-- 046:eeee0000eeeee000deeee000deeee000eeedd000eedee000eedee000deeee000
-- 056:0000555500055555005555560555665566666555655555555555556655555556
-- 057:5555555555556666556666665565666655666666566666666665555565555555
-- 058:5656666066666666666666666666666666665666666665565555566555555655
-- 059:0000000000000000600000006660000066666600666556606665556056665566
-- 061:00000eed0000eeed000eeddd000eddee00eedddd00eedddd0eeeddddeeedddde
-- 062:ddede000dddeee00dddeee00dddeeee0ddddedeeedddeedeeddddedeeddddded
-- 063:000000000000000000000000000000000000000000000000e0000000ee000000
-- </TILES>

-- <MAP>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:405040504050405040504050405040504050405040504050405040504050514050405040504050405040504041415040504050405040504050405040405040504050405040504050405040504050405040504050405040504050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:415141514151415141514151102041514151415141514151415110204151514151415141514151415141511020415141514151415141514151102041415141514151415141514151102041514151415141514151415110204151000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:405040102050405040504050112140504050102040504050405011214050514050401020504050405040501121405040501020405040504050112140405040102050405040504050112140504050102040504050405011214050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:415141112151415141514151415141514151112141514151415050514151514151411121514151415141514151415141511121415141514150505141415141112151415141514151415141514151112141514151415050514151000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:405040504050405010204050405040504050405040504050405050504050514050405040504050102040504050405040504050405040504050505040405040504050405010204050405040504050405040504050405050504050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:415141514151415111214151415141514151415141514110205141514151514151415141514151112141514151415141514151415141102051415141415141514151415111214151415141514151415141514110205141514151000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:405040504050405040504050401020504050405040504011215040504050514050405040504050405040504010205040504050405040112150405040405040504050405040504050401020504050405040504011215040504050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:415141511020415141514151411121514151415141514151415141514151514151415110204151415141514111215141514151415141514151415141415141511020415141514151411121514151415141514151415141514151000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:405040501121405040504050405040504050405040504050405040504050514050405011214050405040504050405040504050405040504050405040405040501121405040504050405040504050405040504050405040504050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:415141514151415141514151415141514151415141514151415141514151514151415141514151415141514151415141514151415141514151415141415141514151415141514151415141514151415141514151415141514151000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:405040504050405040504041405040504050405040504050405040504050514050405040504050405040414050405040504050405040504050405040405040504050405040504041405040504050405040504050405040504050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:415141514141414141414141415141514151415141514151415141514151514151415141414141414141414151415141514151415141514151415141415141514141414141414141415141514151415141514151415141514151000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:607060706070607060706070607060706070607060706070607060706070607070607060706070607060706070607060706070607060706070607060607060706070607060706070607060706070607060706070607060706070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:617161716171617160706171617161607071617161716171617161716171617171617161716171607061716171616070716171617161716171617161617161716171617160706171617161607071617161716171617161716171000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:607060706070607061716070607060616070607060706070607060706070607060706070607060706070607060706070607060706070607060706070607060706070607061716070607060616070607060706070607060706070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 017:617161716171617100006171617161716171617161716171617161716171617161716171617161716171617161716171617161716171617161716171617161710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 135:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

