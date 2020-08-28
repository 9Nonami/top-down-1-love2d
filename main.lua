require("collision")

spriteSize = 30
local rects = {}
local p = {}
local sprites = {}

local bs = 3 --bullet speed
local br = 5 --bullet radius

local map = {
	1,1,1,1,1,1,1,1,1,1,
	1,0,0,0,0,0,0,0,0,1,
	1,0,0,0,0,0,0,0,0,1,
	1,0,0,0,1,1,1,0,0,1,
	1,1,1,0,0,0,0,0,0,1,
	1,0,0,0,0,0,0,0,0,1,
	1,1,1,1,1,1,1,0,1,1,
	1,0,0,0,0,0,0,0,0,1,
	1,0,0,0,0,0,0,0,0,1,
	1,1,1,1,1,1,1,1,1,1
}


function love.load()
	p.x = 30
	p.y = 240
	p.w = 30
	p.h = 30
	p.s = 1
	p.bullets = {}

	map.ox = 0
	map.oy = 0
	map.w = 10
	map.h = 10
	
	sprites.wall = love.graphics.newImage("sprites/wall.png")
	sprites.grass = love.graphics.newImage("sprites/grass.png")
	
	createRect(90, 90, 30, 30)
	createRect(150, 30, 30, 30)
end

function createRect(x, y, w, h)
	local r = {}
	r.x = x
	r.y = y
	r.w = w
	r.h = h
	r.s = 1
	table.insert(rects, r)
end

function createBullet()
	local b = {}
	b.x = p.x + (p.w / 2)
	b.y = p.y + (p.h / 2)
	local mx = love.mouse.getX()
	local my = love.mouse.getY()
	local r = math.atan2(my - b.y, mx - b.x)
	b.cos = math.cos(r)
	b.sin = math.sin(r)
	table.insert(p.bullets, b)
end

function love.mousepressed(x, y, button, istouch)
	createBullet()
end

function love.update()
	updatePlayer()
	updateBullets()
	for i = 1, #rects do
		checkCollision(rects[i], rects, p, i, map)
	end
end

function updatePlayer()
	local up = love.keyboard.isDown("w")
	local down = love.keyboard.isDown("s")
	local left = love.keyboard.isDown("a")
	local right = love.keyboard.isDown("d")

	if up and not upCollide(map, p) then
		p.y = p.y - p.s
	end

	if down and not downCollide(map, p) then
        p.y = p.y + p.s
    end
	
	if left and not leftCollide(map, p) then
        p.x = p.x - p.s
    end

	if right and not rightCollide(map, p) then
        p.x = p.x + p.s
    end
end

function updateBullets()
	for i = #p.bullets, 1, -1 do
		updateBullet(p.bullets[i], i)
	end
end

function updateBullet(b, i)
	local tempId = (math.floor(b.y / spriteSize) * map.w) + (math.floor(b.x / spriteSize))
	tempId = tempId + 1 --pois eh base 1

	--colisao com a parede
	if map[tempId] == 0 then
		b.x = b.x + (b.cos * bs)
		b.y = b.y + (b.sin * bs)
	elseif map[tempId] == 1 then
		table.remove(p.bullets, i)
	end

	--colisao com inimigo
	for j = 1, #rects do
		if b.x > rects[j].x and b.x < rects[j].x + rects[j].w and b.y > rects[j].y and b.y < rects[j].y + rects[j].h then
			table.remove(p.bullets, i)
			table.remove(rects, j)
			goto continue
		end
	end

	::continue::
end

function love.draw()
	drawMap(map)
	drawPlayer()
	drawBullets()
	for i = 1, #rects do
		love.graphics.rectangle("fill", rects[i].x, rects[i].y, rects[i].w, rects[i].h)
	end
end

function drawMap(map)
	local lx = map.ox
	local ly = map.oy

	for i = 1, #map do

		if map[i] == 1 then
			love.graphics.draw(sprites.wall, lx, ly)
		elseif map[i] == 0 then
			love.graphics.draw(sprites.grass, lx, ly)
		end

		lx = lx + spriteSize

		if lx == ((map.w * spriteSize) + map.ox) then
			lx = map.ox
			ly = ly + spriteSize
		end

	end
end

function drawPlayer()
	love.graphics.rectangle("fill", p.x, p.y, p.w, p.h)
end

function drawBullets()
	for i = 1, #p.bullets do
		love.graphics.circle("fill", p.bullets[i].x, p.bullets[i].y, br)
	end
end