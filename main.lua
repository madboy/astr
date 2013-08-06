function love.load()
   font = love.graphics.newImage("font.png")
   font:setFilter("nearest", "nearest")
   rfont = love.graphics.newImageFont(font, " help!.m")
   love.graphics.setFont(rfont)
   ship = love.graphics.newImage("ship.png")
   ship:setFilter("nearest", "nearest")

   width = love.graphics.getWidth()
   height = love.graphics.getHeight()

   sx = 392 -- not exactly middle so that we don't rotate around ship tip
   sy = 292

   angle = 0
   rotf = 40

   shots = {}
end

function love.keypressed(key, unicode)
   if key == "escape" then
      love.event.push("quit")
   end
   if key == "left" then
      angle = angle + math.pi / rotf
   end
   if key == "right" then
      angle = angle - math.pi / rotf
   end
   if key == " " then
      shoot()
   end
end

function love.update(dt)
   local rem_shot = {}
   if love.keyboard.isDown("left") then
      angle = angle + math.pi / rotf
   end
   if love.keyboard.isDown("right") then
      angle = angle - math.pi / rotf
   end

   for i,v in ipairs(shots) do
      v.y = v.y - dt*100
      --if v.y < 0 or v.y > height or v.x < 0 or v.x > width then
      if v.y < -200 then -- since we are rotating and x is larger than y this have to be negative atm
	 table.insert(rem_shot, i)
      end
   end

   for i,v in ipairs(rem_shot) do
      table.remove(shots, v)
   end
end

function love.draw()
   rotate_graphics(ship, angle, sx, sy)
   love.graphics.setColor(255,255,255,255)
   for i,v in ipairs(shots) do
      --love.graphics.rectangle("fill", v.x, v.y, 2, 5)
      draw_fire_laser(v.x, v.y, v.x, v.y-10, v.a)
   end
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

function rotate_graphics(g, a, gx, gy)
   love.graphics.push()
   love.graphics.translate(width/2, height/2)
   love.graphics.rotate(a)
   love.graphics.translate(-width/2, -height/2)
   love.graphics.draw(g, gx, gy)
   love.graphics.pop()
end

function draw_fire_laser(x1,y1,x2,y2,a)
   love.graphics.setColor(255, 0, 0)
   love.graphics.setLine(2, "smooth")
   love.graphics.push()
   love.graphics.translate(width/2, height/2)
   love.graphics.rotate(a)
   love.graphics.translate(-width/2, -height/2)
   --love.graphics.line(x1,y1,x2,y2)
   love.graphics.rectangle("fill",x1,y1,2,5)
   love.graphics.pop()
   love.graphics.reset()
   --fire_laser = false
end

function shoot()
   local shot = {}
   shot.x = sx
   shot.y = sy
   shot.a = angle
   table.insert(shots, shot)
end
