game = {}

function love.load()
   -- graphics
   img_fn = {"ship", "ship_2", "ship_3", "ship_4", "shot", "monster", "background"}
   imgs = {}
   for _,v in ipairs(img_fn) do
      imgs[v] = love.graphics.newImage("assets/"..v..".png")
   end

   for _,v in pairs(imgs) do
      v:setFilter("nearest", "nearest")
   end

   -- setup
   width = love.graphics.getWidth()
   height = love.graphics.getHeight()

   ship = {}
   ship.i = {imgs["ship"], imgs["ship_4"], imgs["ship_3"], imgs["ship_2"]}
   ship.x = width/2 
   ship.y = height/2
   ship.idx = 1

   shots = {}
   enemies = {}

   score = 0
   fired = 0

   game.clock = 0
   game.enemy_dt = 0
   game.enemy_rate = 2
   game.enemy_size = imgs["monster"]:getWidth()
   game.player_size = imgs["ship"]:getWidth()
   game.shot_size = imgs["shot"]:getWidth()

   debug = false

   -- sounds
   shot_sound = love.audio.newSource("assets/shot.ogg", "static")
   hit_sound = love.audio.newSource("assets/hit.ogg", "static")
end

function love.keypressed(key, unicode)
   if key == "escape" then
      love.event.push("quit")
   end
   if key == " " then
      fired = fired + 1
      shoot()
   end
   if key == "e" then
      spawn()
   end
   if key == "`" then
      debug = not debug
   end
end

function love.update(dt)
   game.clock = game.clock + dt
   game.enemy_dt = game.enemy_dt + dt

   if game.enemy_dt > game.enemy_rate then
      spawn()
      game.enemy_dt = 0
   end

   local rem_shot = {}
   local rem_enemy = {}
   if love.keyboard.isDown("left") then
      if ship.x > 0 then
	 ship.x = ship.x - 100*dt*scale
      end
   end
   if love.keyboard.isDown("right") then
      if ship.x + game.player_size < 160*scale then
	 ship.x = ship.x + 100*dt*scale
      end
   end
   if love.keyboard.isDown("up") then
      if ship.y > 0 then
	 ship.y = ship.y - 100*dt*scale
      end
   end
   if love.keyboard.isDown("down") then
      if ship.y + game.player_size < 144*scale then
	 ship.y = ship.y + 100*dt*scale
      end
   end

   for i,v in ipairs(shots) do
      v.y = v.y - dt*50*scale
      if v.y < 0 then
	 table.insert(rem_shot, i)
      end

      for ii,vv in ipairs(enemies) do
	 if distance(v.x,v.y, vv.x, vv.y) < 10*scale then
	    love.audio.play(hit_sound)
	    table.insert(rem_enemy, ii)
	    table.insert(rem_shot, i)
	    score = score + 1
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
      v.y = v.y + 20*dt*scale
   end
end

function love.draw()
   for i = 0,4 do
    for j = -1,4 do
      love.graphics.draw(imgs["background"],
                           i*32*scale,
                           (j+game.clock%1)*32*scale,
                           0,scale,scale)
    end
   end

   for _,v in ipairs(enemies) do
      love.graphics.draw(imgs["monster"], v.x, v.y, 0, scale, scale, game.enemy_size/2, game.enemy_size/2)
      if debug then love.graphics.circle("line",v.x,v.y,game.enemy_size/2*scale) end
   end

   local ship_image = ship.i[ship.idx]
   love.graphics.draw(ship_image, ship.x, ship.y, 0, scale, scale, game.player_size/2, game.player_size/2)
   ship.idx = ship.idx + 1
   if ship.idx > table.getn(ship.i) then
      ship.idx = 1
   end

   for _,v in ipairs(shots) do
      love.graphics.draw(imgs["shot"], v.x, v.y, 0, scale, scale, game.shot_size/2, game.shot_size/2)
      if debug then love.graphics.circle("line",v.x,v.y,game.shot_size/2*scale) end
   end
   
   love.graphics.setColor(255,215,0)
   love.graphics.printf("score: "..score.." shots: "..fired, 0,0, width, "center")
   love.graphics.setColor(255,255,255)
end

function shoot()
   local shot = {}
   love.audio.play(shot_sound)
   shot.x = ship.x - game.player_size / 2 
   shot.y = ship.y - game.player_size * 2
   table.insert(shots, shot)
end

function spawn()
   local enemy = {}
   enemy.x = math.random(0, width)
   enemy.y = math.random(0, height/2)
   table.insert(enemies, enemy)
end

function distance(x1,y1,x2,y2)
   return math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
end
