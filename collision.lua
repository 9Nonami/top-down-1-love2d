function checkCollision(r, rs, p, i, mp)
	if r.x < p.x then
		
		local tempx = r.x + r.s --simula ir para a direita
		local colliding = false

		for j = 1, #rs do
			if j ~= i then
				colliding = colliding or rectangleCollision(tempx, r.y, r.w, r.h, rs[j].x, rs[j].y, rs[j].w, rs[j].h)
			end
		end

		if not colliding and not rightCollide(mp, r) then
			r.x = tempx
		end

	elseif r.x > p.x then

		local tempx = r.x - r.s --simula ir para a esquerda
		local colliding = false

		for j = 1, #rs do
			if j ~= i then
				colliding = colliding or rectangleCollision(tempx, r.y, r.w, r.h, rs[j].x, rs[j].y, rs[j].w, rs[j].h)
			end
		end

		if not colliding and not leftCollide(mp, r) then
			r.x = tempx
		end

	end

	if r.y < p.y then

		local tempy = r.y + r.s --simula ir para baixo
		local colliding = false

		for j = 1, #rs do
			if j ~= i then
				colliding = colliding or rectangleCollision(r.x, tempy, r.w, r.h, rs[j].x, rs[j].y, rs[j].w, rs[j].h)
			end
		end

		if not colliding and not downCollide(mp, r) then
			r.y = tempy
		end

	elseif r.y > p.y then

		local tempy = r.y - r.s --simula ir para cima
		local colliding = false

		for j = 1, #rs do
			if j ~= i then
				colliding = colliding or rectangleCollision(r.x, tempy, r.w, r.h, rs[j].x, rs[j].y, rs[j].w, rs[j].h)
			end
		end

		if not colliding and not upCollide(mp, r) then
			r.y = tempy
		end

	end
end

function rectangleCollision(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and x1 + w1 > x2 and y1 < y2 + h2 and y1 + h1 > y2
end

function upCollide(map, entity)
	--ul
	local ulx = math.floor(entity.x)
	local uly = math.floor(entity.y)
	uly = uly - entity.s --simula o movimento para cima
	local res_ul = innerMapId(ulx, uly, map)
	res_ul = res_ul + 1 --pois o array comeca em 1

	--ur
	local urx = math.floor(entity.x) + entity.w - 1
	local ury = math.floor(entity.y)
	ury = ury - entity.s
	local res_ur = innerMapId(urx, ury, map)
	res_ur = res_ur + 1

	return map[res_ul] == 1 or map[res_ur] == 1
end

function downCollide(map, entity)
	--ll
	local llx = math.floor(entity.x)
	local lly = math.floor(entity.y) + entity.h - 1
	lly = lly + entity.s
	local res_ll = innerMapId(llx, lly, map)
	res_ll = res_ll + 1

	--lr
	local lrx = math.floor(entity.x) + entity.w - 1
	local lry = math.floor(entity.y) + entity.h - 1
	lry = lry + entity.s
	local res_lr = innerMapId(lrx, lry, map)
	res_lr = res_lr + 1

	return map[res_ll] == 1 or map[res_lr] == 1
end

function leftCollide(map, entity)
	--ul
	local ulx = math.floor(entity.x)
	local uly = math.floor(entity.y)
	ulx = ulx - entity.s
	local res_ul = innerMapId(ulx, uly, map)
	res_ul = res_ul + 1

	--ll
	local llx = math.floor(entity.x)
	local lly = math.floor(entity.y) + entity.h - 1
	llx = llx - entity.s
	local res_ll = innerMapId(llx, lly, map)
	res_ll = res_ll + 1

	return map[res_ul] == 1 or map[res_ll] == 1
end

function rightCollide(map, entity)
	--ur
	local urx = math.floor(entity.x) + entity.w - 1
	local ury = math.floor(entity.y)
	urx = urx + entity.s
	local res_ur = innerMapId(urx, ury, map)
	res_ur = res_ur + 1

	--lr
	local lrx = math.floor(entity.x) + entity.w - 1
	local lry = math.floor(entity.y) + entity.h - 1
	lrx = lrx + entity.s
	local res_lr = innerMapId(lrx, lry, map)
	res_lr = res_lr + 1

	return map[res_ur] == 1 or map[res_lr] == 1
end

function innerMapId(lx, ly, map)
	return math.floor((map.w * math.floor((ly - map.oy) / spriteSize)) + math.floor((lx - map.ox) / spriteSize))
end