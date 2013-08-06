function love.load()
   font = love.graphics.newImage("font.png")
   font:setFilter("nearest", "nearest")
   rfont = love.graphics.newImageFont(font, " help!.m")
   love.graphics.setFont(rfont)
   ship = love.graphics.newImage("ship.png")
   ship:setFilter("nearest", "nearest")

   sx = 392 -- not exactly middle so that we don't rotate around ship tip
   sy = 292

   angle = 0
   rotf = 40
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
      fire_laser = true
   end
end

function love.update(dt)
   if love.keyboard.isDown("left") then
      angle = angle + math.pi / rotf
   end
   if love.keyboard.isDown("right") then
      angle = angle - math.pi / rotf
   end
end

function love.draw()
   rotate_graphics(ship, angle, sx, sy)
   if fire_laser then draw_fire_laser(400,300,400,300-30)end
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
   local width = love.graphics.getWidth()
   local height = love.graphics.getHeight()
   love.graphics.push()
   love.graphics.translate(width/2, height/2)
   love.graphics.rotate(a)
   love.graphics.translate(-width/2, -height/2)
   love.graphics.draw(g, gx, gy)
   love.graphics.pop()
end

function draw_fire_laser(x1,y1,x2,y2)
   love.graphics.setColor(255, 0, 0)
   love.graphics.setLine(2, "smooth")
   local width = love.graphics.getWidth()
   local height = love.graphics.getHeight()
   love.graphics.push()
   love.graphics.translate(width/2, height/2)
   love.graphics.rotate(angle)
   love.graphics.translate(-width/2, -height/2)
   love.graphics.line(x1,y1,x2,y2)
   love.graphics.pop()
   love.graphics.reset()
   fire_laser = false
end
