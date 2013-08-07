function love.load()
   img_fn = {"ship", "alpha"}
   imgs = {}
   for _,v in ipairs(img_fn) do
      imgs[v] = love.graphics.newImage("assets/"..v..".png")
   end

   for _,v in ipairs(imgs) do
      v:setFilter("nearest", "nearest")
   end

   font = love.graphics.newImageFont(imgs["alpha"], " !aegmorstv0123456789")
   love.graphics.setFont(font)

   width = love.graphics.getWidth()
   height = love.graphics.getHeight()

   ship = {}
   ship.i = imgs["ship"]
   ship.x = width/2 
   ship.y = height/2
   ship.w = ship.i:getWidth()
   ship.h = ship.i:getHeight()

   shots = {}

   enemies = {}
end

function love.keypressed(key, unicode)
   if key == "escape" then
      love.event.push("quit")
   end
   if key == " " then
      shoot()
   end
   if key == "e" then
      spawn()
   end
end

function love.update(dt)
   local rem_shot = {}
   local rem_enemy = {}
   if love.keyboard.isDown("left") then
      if ship.x > 0 then
	 ship.x = ship.x - 1
      end
   end
   if love.keyboard.isDown("right") then
      if ship.x + ship.w < width then
	 ship.x = ship.x + 1
      end
   end
   if love.keyboard.isDown("up") then
      if ship.y > 0 then
	 ship.y = ship.y - 1
      end
   end
   if love.keyboard.isDown("down") then
      if ship.y + ship.h < height then
	 ship.y = ship.y + 1
      end
   end

   for i,v in ipairs(shots) do
      v.y = v.y - dt*100
      if v.y < 0 then
	 table.insert(rem_shot, i)
      end

      for ii,vv in ipairs(enemies) do
	 if check_collision(v.x,v.y,2,5,vv.x,vv.y,15,15) then
	    table.insert(rem_enemy, ii)
	    table.insert(rem_shot, i)
	 end
      end
   end

   for i,v in ipairs(rem_shot) do
      table.remove(shots, v)
   end
   for i,v in ipairs(rem_enemy) do
      table.remove(enemies, v)
   end

   for i,v in ipairs(enemies) do
      v.y = v.y + dt
   end
end

function love.draw()
   love.graphics.setBackgroundColor( 0, 0, 0 )
   love.graphics.draw(ship.i, ship.x, ship.y)
   
   love.graphics.setColor(255,0,0)
   for _,v in ipairs(shots) do
      love.graphics.rectangle("fill", v.x, v.y, 2, 5)
   end
   
   love.graphics.setColor(255,120,120)
   for _,v in ipairs(enemies) do
      love.graphics.rectangle("fill", v.x, v.y, 15, 15)
   end
   
   love.graphics.reset()
end

function draw_scaled_graphics(g, s, x, y)
   love.graphics.push()
   love.graphics.scale(s,s)
   love.graphics.draw(g, x, y)
   love.graphics.pop()
end

function print_scaled_graphics(t, s, x, y)
   love.graphics.push()
   love.graphics.scale(s,s)
   love.graphics.print(t, x, y)
   love.graphics.pop()
end

function shoot()
   local shot = {}
   shot.x = ship.x + ship.w/2
   shot.y = ship.y
   table.insert(shots, shot)
end

function spawn()
   local enemy = {}
   enemy.x = math.random(0, width)
   enemy.y = math.random(0, height/2)
   table.insert(enemies, enemy)
end

function check_collision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
   local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
   return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end
