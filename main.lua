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
   ship.x = width/2  -- not exactly middle so that we don't rotate around ship tip
   ship.y = height/2
   ship.w = ship.i:getWidth()
   ship.h = ship.i:getHeight()

   shots = {}
end

function love.keypressed(key, unicode)
   if key == "escape" then
      love.event.push("quit")
   end
   if key == " " then
      shoot()
   end
end

function love.update(dt)
   local rem_shot = {}
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
   end

   for i,v in ipairs(rem_shot) do
      table.remove(shots, v)
   end
end

function love.draw()
   love.graphics.setBackgroundColor( 0, 0, 0 )
   love.graphics.draw(ship.i, ship.x, ship.y)
--   rotate_graphics(ship.i, angle, ship.x, ship.y)
   love.graphics.setColor(255,0,0)
   for i,v in ipairs(shots) do
      love.graphics.rectangle("fill", v.x, v.y, 2, 5)
      --draw_fire_laser(v.x, v.y, v.x, v.y-10, v.a)
   end
   love.graphics.reset()
   --if fire_laser then draw_fire_laser(400,300,400,300-30)end
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
