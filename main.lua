--[[
LD36
Theme: Ancient Technology
Title: ????
--]]

function love.load()
   print("Loading...")

   love.window.setFullscreen( true )

   -- Game state
   Game = {}
   Game.state = "Menu"
   Game.num_games = 0
   Game.splashscreen = love.graphics.newImage( "data/gfx/Splash.jpg" )
   Game.tutorialscreen = love.graphics.newImage( "data/gfx/Tutorial.jpg" )
   Game.IsPaused = false
   Game.cDeathDuration = 5

   -- Map params
   Map = {}
   Map.width, Map.height = love.graphics.getDimensions()
   Map.rows, Map.cols = 9, 16 -- 16/9 ratio
   -- Map.cell_sizes = { Map.width / Map.cols, Map.height / Map.rows }
   Map.background = love.graphics.newImage( "data/gfx/Background.jpg" )
   Map.cGravity = -150
   print("Window " .. Map.width .."x".. Map.height)

   ---- Heap params
   -- Fire params
   Fire = {}
   Fire.class = "Fire"
   Fire.image = love.graphics.newImage( "data/gfx/Fire.png" )
   Fire.vec_frames = { love.graphics.newImage( "data/gfx/Fire.png" ), love.graphics.newImage( "data/gfx/Fire-2.png" ) }
   Fire.hs_x = Fire.image:getWidth() / 2
   Fire.hs_y = Fire.image:getHeight() / 2
   Fire.cInitialEnergy = 20 --10
   Fire.cTimeoutEnergy = 5
   Fire.cRadius = 0.95*Map.height/2

   -- Cereal params
   Cereal = {}
   Cereal.class = "Cereal"
   Cereal.image = love.graphics.newImage( "data/gfx/Cereal.png" )
   Cereal.hs_x = Cereal.image:getWidth() / 2
   Cereal.hs_y = Cereal.image:getHeight() / 2
   Cereal.cInitialEnergy = 50 --9
   Cereal.cTimeoutEnergy = 5

   -- Meat params
   Meat = {}
   Meat.class = "Meat"
   Meat.image = love.graphics.newImage( "data/gfx/Meat.png" )
   Meat.hs_x = Meat.image:getWidth() / 2
   Meat.hs_y = Meat.image:getHeight() / 2
   Meat.cInitialEnergy = 50 --9
   Meat.cTimeoutEnergy = 5

   Heaps = {}
   Heaps.table = { Fire, Cereal, Meat }

   ---- Resources
   -- Plant Class
   A_Plant = {}
   A_Plant.class = "Plant"
   A_Plant.image = love.graphics.newImage( "data/gfx/Plant.png" )
   A_Plant.hs_x = A_Plant.image:getWidth() / 2
   A_Plant.hs_y = A_Plant.image:getHeight() / 2
   A_Plant.cInitialNum = 4 --10

   -- Wood Class
   A_Wood = {}
   A_Wood.class = "Wood"
   A_Wood.image = love.graphics.newImage( "data/gfx/Wood.png" )
   A_Wood.hs_x = A_Wood.image:getWidth() / 2
   A_Wood.hs_y = A_Wood.image:getHeight() / 2
   A_Wood.cInitialNum = 4 -- 8

   -- Carcass Class
   A_Carcass = {}
   A_Carcass.class = "Carcass"
   A_Carcass.image = love.graphics.newImage( "data/gfx/Carcass.png" )
   A_Carcass.hs_x = A_Carcass.image:getWidth() / 2
   A_Carcass.hs_y = A_Carcass.image:getHeight() / 2
   A_Carcass.cInitialNum = 1 --0

   Resources = {}
   Resources.table = {}

   -- Character params
   -- Hunter
   Hunter = {}
   Hunter.archetype = Hunter
   Hunter.class = "Hunter"
   Hunter.resource_archetype = A_Carcass
   Hunter.image = love.graphics.newImage( "data/gfx/Hunter.png" )
   Hunter.hs_x = Hunter.image:getWidth() / 2
   Hunter.hs_y = Hunter.image:getHeight() / 2
   Hunter.cSpeed = 200
   Hunter.cDamageHalfsize = Hunter.hs_x
   Hunter.animations = {}
   Hunter.animations["Idle"] = { duration = 0.5,
                                 vec_frames = { love.graphics.newImage( "data/gfx/Hunter-Idle-1.png" ),
                                                love.graphics.newImage( "data/gfx/Hunter-Idle-2.png" ) } }
   Hunter.animations["GoToPoint"] = { duration = 0.5,
                                      vec_frames = { love.graphics.newImage( "data/gfx/Hunter-Walk-1.png" ),
                                                     love.graphics.newImage( "data/gfx/Hunter-Walk-2.png" ) } }
   Hunter.animations["Dead"] = { duration = 10000,
                                 vec_frames = { love.graphics.newImage( "data/gfx/Skeleton.png" ) } }
   Hunter.animations["Shoot"] = { duration = 0.5,
                                  vec_frames = { love.graphics.newImage( "data/gfx/Hunter-Walk-1.png" ),
                                                 love.graphics.newImage( "data/gfx/Hunter-Walk-2.png" ) } }
   -- Gatherer
   Gatherer = {}
   Gatherer.archetype = Gatherer
   Gatherer.class = "Gatherer"
   Gatherer.resource_archetype = A_Plant
   Gatherer.image = love.graphics.newImage( "data/gfx/Gatherer.png" )
   Gatherer.hs_x = Gatherer.image:getWidth() / 2
   Gatherer.hs_y = Gatherer.image:getHeight() / 2
   Gatherer.cSpeed = 150
   Gatherer.cDamageHalfsize = Gatherer.hs_x
   Gatherer.animations = {}
   Gatherer.animations["Idle"] = { duration = 0.5,
                                   vec_frames = { love.graphics.newImage( "data/gfx/Gatherer-Idle-1.png" ),
                                                  love.graphics.newImage( "data/gfx/Gatherer-Idle-2.png" ) } }
   Gatherer.animations["GoToPoint"] = { duration = 0.5,
                                        vec_frames = { love.graphics.newImage( "data/gfx/Gatherer-Walk-1.png" ),
                                                       love.graphics.newImage( "data/gfx/Gatherer-Walk-2.png" ) } }
   Gatherer.animations["Dead"] = { duration = 10000,
                                   vec_frames = { love.graphics.newImage( "data/gfx/Skeleton.png" ) } }

   -- Scout
   Scout = {}
   Scout.archetype = Scout
   Scout.class = "Scout"
   Scout.resource_archetype = A_Wood
   Scout.image = love.graphics.newImage( "data/gfx/Scout.png" )
   Scout.hs_x = Scout.image:getWidth() / 2
   Scout.hs_y = Scout.image:getHeight() / 2
   Scout.cSpeed = 250
   Scout.cDamageHalfsize = Scout.hs_x
   Scout.animations = {}
   Scout.animations["Idle"] = { duration = 0.5,
                                vec_frames = { love.graphics.newImage( "data/gfx/Scout-Idle-1.png" ),
                                               love.graphics.newImage( "data/gfx/Scout-Idle-2.png" ) } }
   Scout.animations["GoToPoint"] = { duration = 0.5,
                                     vec_frames = { love.graphics.newImage( "data/gfx/Scout-Walk-1.png" ),
                                                    love.graphics.newImage( "data/gfx/Scout-Walk-2.png" ) } }
   Scout.animations["Dead"] = { duration = 10000,
                                vec_frames = { love.graphics.newImage( "data/gfx/Skeleton.png" ) } }

   Characters = {}
   Characters.table = { Hunter, Gatherer, Scout }
   Characters.cStarvingTimeout = 3
   Characters.vec_death_sounds = { KILLED = love.audio.newSource("data/sound/Death0.ogg", "static"),
                                   STARVED = love.audio.newSource("data/sound/Death0.ogg", "static"),
                                   ARROWED = love.audio.newSource("data/sound/Wilhelm.ogg", "static") }
   Characters.vec_aura_frames = { love.graphics.newImage( "data/gfx/Aura-1.png" ),
                                  love.graphics.newImage( "data/gfx/Aura-2.png" ) }

   ---- Wildlife
   -- A_Wolf
   A_Wolf = {}
   A_Wolf.class = "A_Wolf"
   A_Wolf.resource_archetype = A_Carcass
   A_Wolf.image = love.graphics.newImage( "data/gfx/Wolf.png" )
   A_Wolf.hs_x = A_Wolf.image:getWidth() / 2
   A_Wolf.hs_y = A_Wolf.image:getHeight() / 2
   A_Wolf.cSpeed = 250
   A_Wolf.cActionTimeout = 2
   A_Wolf.cHungerTimeout = 6
   A_Wolf.cAttackHalfsize = A_Wolf.hs_y / 2
   A_Wolf.cDamageHalfsize = A_Wolf.hs_y
   A_Wolf.cCarcassNum = 1
   A_Wolf.animations = {}
   A_Wolf.animations["Idle"] = { duration = 0.5,
                                 vec_frames = { love.graphics.newImage( "data/gfx/Wolf-Idle-1.png" ),
                                                love.graphics.newImage( "data/gfx/Wolf-Idle-2.png" ) } }
   A_Wolf.animations["GoToPoint"] = { duration = 0.5,
                                      vec_frames = { love.graphics.newImage( "data/gfx/Wolf-Walk-1.png" ),
                                                     love.graphics.newImage( "data/gfx/Wolf-Walk-2.png" ) } }
   A_Wolf.cInitialNum = 1

   -- A_Bird
   A_Bird = {}
   A_Bird.class = "A_Bird"
   A_Bird.resource_archetype = A_Carcass
   A_Bird.image = love.graphics.newImage( "data/gfx/Bird.png" )
   A_Bird.hs_x = A_Bird.image:getWidth() / 2
   A_Bird.hs_y = A_Bird.image:getHeight() / 2
   A_Bird.cSpeed = 250
   A_Bird.cActionTimeout = 2
   A_Bird.cHungerTimeout = 6
   A_Bird.cAttackHalfsize = A_Bird.hs_y / 2
   A_Bird.cDamageHalfsize = A_Bird.hs_y
   A_Bird.cCarcassNum = 1
   A_Bird.animations = {}
   A_Bird.animations["Idle"] = { duration = 0.5,
                                 vec_frames = { love.graphics.newImage( "data/gfx/Bird-Fly-1.png" ),
                                                love.graphics.newImage( "data/gfx/Bird-Fly-2.png" ) } }
   A_Bird.animations["GoToPoint"] = { duration = 0.5,
                                      vec_frames = { love.graphics.newImage( "data/gfx/Bird-Fly-1.png" ),
                                                     love.graphics.newImage( "data/gfx/Bird-Fly-2.png" ) } }
   A_Bird.cInitialNum = 1


   -- A_Bison
   A_Bison = {}
   A_Bison.class = "A_Bison"
   A_Bison.resource_archetype = A_Carcass
   A_Bison.image = love.graphics.newImage( "data/gfx/Bison.png" )
   A_Bison.hs_x = A_Bison.image:getWidth() / 2
   A_Bison.hs_y = A_Bison.image:getHeight() / 2
   A_Bison.cSpeed = 250
   A_Bison.cActionTimeout = 2
   A_Bison.cHungerTimeout = 6
   A_Bison.cAttackHalfsize = A_Bison.hs_y / 2
   A_Bison.cDamageHalfsize = A_Bison.hs_y / 2
   A_Bison.cCarcassNum = 3
   A_Bison.animations = {}
   A_Bison.animations["Idle"] = { duration = 0.5,
                                 vec_frames = { love.graphics.newImage( "data/gfx/Bison-Idle-1.png" ),
                                                love.graphics.newImage( "data/gfx/Bison-Idle-2.png" ) } }
   A_Bison.animations["GoToPoint"] = { duration = 0.5,
                                      vec_frames = { love.graphics.newImage( "data/gfx/Bison-Walk-1.png" ),
                                                     love.graphics.newImage( "data/gfx/Bison-Walk-2.png" ) } }
   A_Bison.cInitialNum = 1

   Wildlife = {}
   Wildlife.table = {}

   ---- Projectiles
   -- Arrow
   A_Arrow = {}
   A_Arrow.archetype = A_Arrow
   A_Arrow.class = "Arrow"
   A_Arrow.image = love.graphics.newImage( "data/gfx/Arrow.png" )
   A_Arrow.hs_x = A_Arrow.image:getWidth() / 2
   A_Arrow.hs_y = A_Arrow.image:getHeight() / 2
   A_Arrow.cSpeed = 250
   A_Arrow.cAttackHalfsize = A_Arrow.hs_x / 2

   Projectiles = {}
   Projectiles.table = {}

   -- Generator
   Generator = {}
   Generator.cTimeouts = NewGeneratorTimeouts()
   Generator.cMaxWildlife = 5
   Generator.cMaxResources = 15

   -- Global params
   hud_font = love.graphics.newFont( 45 )
   message_font = love.graphics.newFont( 60 )
   love.graphics.setFont( hud_font )

   -- Music
   Music = {}
   Music.vec_music = {}
   Music.vec_music[1] = love.audio.newSource("data/sound/Krakatoa.ogg")
   -- Music.vec_music[2] = love.audio.newSource("TEMPORAL/CarnivalRides-Long-Mono-T18.ogg")
   -- Music.vec_music[3] = love.audio.newSource("TEMPORAL/CarnivalRides-Long-Mono-T12.ogg")
   Music.vec_duration = {}
   Music.vec_duration[1] = 72
   --Music.vec_duration[2] = 21
   -- Music.vec_duration[2] = 18
   -- --Music.vec_duration[4] = 15
   -- Music.vec_duration[3] = 12
   for i,m in ipairs(Music.vec_music) do
      m:setLooping( true )
      m:setVolume( 0.5 )
   end

   -- Start main menu music
   Music.type = 1
   Music.lifetime = Music.vec_duration[ Music.type ]
   Music.current = Music.vec_music[ Music.type ]
   Music.current:play()

   love.math.setRandomSeed( 666666.666666 )
   print("...Loaded")

   -- Debug
   IsEnabledDebugMode = false

   -- TEMP: go direct to game
   -- Game.state = "Playing"
   -- NewGame()

end

function NewGame()
   collectgarbage()

   -- Game state
   Game.IsPaused = false
   Game.death_time = 0
   Game.num_games = Game.num_games + 1

   -- Map state
   Map.time = 0

   -- Heap states
   -- Fire state
   Fire.pos_x = Map.width/2
   Fire.pos_y = Map.height/2
   Fire.energy = Fire.cInitialEnergy
   Fire.timeout = Fire.cTimeoutEnergy

   -- Cereal state
   Cereal.pos_x = Map.width/3
   Cereal.pos_y = 2*Map.height/3
   Cereal.energy = Cereal.cInitialEnergy
   Cereal.timeout = Cereal.cTimeoutEnergy

   -- Meat state
   Meat.pos_x = 2*Map.width/3
   Meat.pos_y = 2*Map.height/3
   Meat.energy = Meat.cInitialEnergy
   Meat.timeout = Meat.cTimeoutEnergy

   -- Character states
   -- Hunter state
   Hunter.state = "Alive"
   Hunter.pos_x = Map.width / 2
   Hunter.pos_y = Map.height / 6
   Hunter.candy_count = 0
   Hunter.combo_timeout = 0
   Hunter.combo_count = 0
   Hunter.starving_timeout = 0

   -- Gatherer state
   Gatherer.state = "Alive"
   Gatherer.pos_x = Map.width / 3
   Gatherer.pos_y = Map.height / 3
   Gatherer.candy_count = 0
   Gatherer.combo_timeout = 0
   Gatherer.combo_count = 0
   Gatherer.starving_timeout = 0

   -- Scout state
   Scout.state = "Alive"
   Scout.pos_x = 2 * Map.width / 3
   Scout.pos_y = Map.height / 3
   Scout.candy_count = 0
   Scout.combo_timeout = 0
   Scout.combo_count = 0
   Scout.starving_timeout = 0

   -- Character Actions
   Characters.num_alive = table.getn( Characters.table )
   for i,c in ipairs( Characters.table ) do
      c.action = NewAction_Idle()
      c.facing = 1
   end

   -- MainCharacter
   MainCharacter = Scout

   -- Generate initial resources
   Resources.table = {}
   for i=1,A_Plant.cInitialNum do
      local x,y = FindEmptyPos( A_Plant.hs_x, A_Plant.hs_y )
      local r = NewResource( A_Plant, x, y )
      table.insert( Resources.table, r )
   end
   for i=1,A_Wood.cInitialNum do
      local x,y = FindEmptyPos( A_Wood.hs_x, A_Wood.hs_y )
      local r = NewResource( A_Wood, x, y )
      table.insert( Resources.table, r )
   end
   for i=1,A_Carcass.cInitialNum do
      local x,y = FindEmptyPos( A_Carcass.hs_x, A_Carcass.hs_y )
      local r = NewResource( A_Carcass, x, y )
      table.insert( Resources.table, r )
   end

   -- Generate initial wildlife
   Wildlife.table = {}
   for i=1,A_Wolf.cInitialNum do
      local x,y = FindEmptyPos( A_Wolf.hs_x, A_Wolf.hs_y )
      local w = NewWildlife( A_Wolf, x, y )
      table.insert( Wildlife.table, w )
   end
   for i=1,A_Bird.cInitialNum do
      local x,y = FindEmptyPos( A_Bird.hs_x, A_Bird.hs_y )
      local w = NewWildlife( A_Bird, x, y )
      table.insert( Wildlife.table, w )
   end
   for i=1,A_Bison.cInitialNum do
      local x,y = Map.width - A_Bison.hs_x, 2 * Map.height / 3
      local w = NewWildlife( A_Bison, x, y )
      table.insert( Wildlife.table, w )
   end

   -- Generator
   Generator.timeouts = NewGeneratorTimeouts()

   -- Projectiles
   Projectiles.table = {}
   -- Messages
   Messages = {}
   -- Music
   Music.current:stop()
   Music.type = 1
   Music.lifetime = Music.vec_duration[ Music.type ]
   Music.current = Music.vec_music[ Music.type ]
   Music.current:play()
end

function love.focus(f)
   Game.IsPaused = not f
   -- if not Game.IsPaused then
   --    if Game.state == "Playing" and not f then
   --       Game.state = "Pause"
   --    elseif Game.state == "Death" and not f then
   --       Game.state = "Pause"
   --    elseif Game.state == "Pause" and f then
   --       if MainCharacter.state == "Alive" or then
   --          Game.state = "Playing"
   --       else
   --          Game.state = "Death"
   --       end
   --    end
end

-- Standard random is INTEGER, thus random(-1,1) results only in -1,+1 values
function love.math.random_float( min, max )
   return min + (max-min) * (love.math.random(1000000) / 1000000)
end

function NewMessage_Centered( text, duration, scale, color )
   message = {}
   message.class = "Centered"
   message.text = text
   message.duration = duration
   message.time = 0
   message.scale = scale
   message.color = color
   table.insert( Messages, message )
end

function NewMessage_Upwards( text, duration, scale, pos_x, pos_y, speed_y, color )
   message = {}
   message.class = "Upwards"
   message.text = text
   message.duration = duration
   message.time = 0
   message.scale = scale
   message.pos_x = pos_x
   message.pos_y = pos_y
   message.speed_y = speed_y
   message.color = color
   table.insert( Messages, message )
end

function love.keypressed(key)
   -- Global keys
   if key == "escape" then -- Quit
      love.event.quit()
   elseif key == "p" then -- Quit
      Game.IsPaused = not Game.IsPaused
   elseif key == "d" then -- Debug
      IsEnabledDebugMode = not IsEnabledDebugMode
   elseif key == '1' then -- Fullscreen
      love.window.setFullscreen( not love.window.getFullscreen() )
   end

   -- Game states
   if Game.state == "Menu" then
      if Game.num_games == 0 then
         Game.state = "Tutorial"
      else
         Game.state = "Playing"
         NewGame()
      end
   elseif Game.state == "Tutorial" then
      Game.state = "Playing"
      NewGame()
   elseif Game.state == "Playing" then
      -- Nothing
   elseif Game.state == "Game Over" then
      Game.state = "Menu" --Any key to menu
      Music.type = 1
   elseif Game.state == "Death" then
     -- Nothing...
   else --Game.state == "Pause"
      --Should not happen...
   end
end

function love.mousepressed( x, y, button, istouch )
   if Game.state == "Menu" then
      Game.state = "Playing"
      NewGame()
   elseif Game.state == "Playing" then
      -- Select MainCharacter
      if Hunter.state ~= "Dead" and TestPointInBox( x, y, Hunter.pos_x, Hunter.pos_y, Hunter.hs_x, Hunter.hs_y ) then
         MainCharacter = Hunter
      elseif Gatherer.state ~= "Dead" and TestPointInBox( x, y, Gatherer.pos_x, Gatherer.pos_y, Gatherer.hs_x, Gatherer.hs_y ) then
         MainCharacter = Gatherer
      elseif Gatherer.state ~= "Scout" and TestPointInBox( x, y, Scout.pos_x, Scout.pos_y, Scout.hs_x, Scout.hs_y ) then
         MainCharacter = Scout
      else -- Otherwise, Select Target
         -- TEMP: Can only receive orders whem Idle
         if MainCharacter.action.name == "Idle" then
            -- GoToPoint or Shoot if Hunter
            if MainCharacter == Hunter then
               local w = TryToSelectWildlife( x, y )
               if w ~= nil then
                  MainCharacter.action = NewAction_Shoot( MainCharacter.pos_x, MainCharacter.pos_y, x, y )
               else
                  MainCharacter.action = NewAction_GoToPoint( MainCharacter, ApplyBorders( x, y, MainCharacter.archetype.hs_x, MainCharacter.archetype.hs_y ) )
               end
            else -- If none selected, move to point and wait
               MainCharacter.action = NewAction_GoToPoint( MainCharacter, ApplyBorders( x, y, MainCharacter.archetype.hs_x, MainCharacter.archetype.hs_y ) )
            end
         end
      end
   end
end

function TryToSelectResource( a, x, y )
   for i,r in ipairs(Resources.table) do
      if r.archetype == a then
         if TestPointInBox(x,y,r.pos_x,r.pos_y,r.archetype.hs_x,r.archetype.hs_y) then
            return r
         end
      end
   end
   return nil
end

function TryToSelectWildlife( x, y )
   for i,w in ipairs(Wildlife.table) do
      if TestPointInBox(x,y,w.pos_x,w.pos_y,w.archetype.hs_x,w.archetype.hs_y) then
         return w
      end
   end
   return nil
end

function ApplyBorders( px, py, hsx, hsy )
   local x = px
   local y = py
   if( x-hsx < 0 ) then x = hsx end
   if( x+hsx > Map.width ) then x = Map.width-hsx end
   if( y-hsy < 0 ) then y = hsy end
   if( y+hsy > Map.height ) then y = Map.height-hsy end
   return x,y
end

function IsInsideBorders( px, py, hsx, hsy )
   local x = px
   local y = py
   if( x-hsx < 0 ) then return false end
   if( x+hsx > Map.width ) then return false end
   if( y-hsy < 0 ) then return false end
   if( y+hsy > Map.height ) then return false end
   return true
end

function TestOverlapBox( px1, py1, hsx1, hsy1, px2, py2, hsx2, hsy2 )
   return math.abs(px1 - px2) < (hsx1 + hsx2) and math.abs(py1 - py2) < (hsy1 + hsy2)
end

function TestPointInCircle( px, py, cx, cy, r )
   return (px-cx)*(px-cx) + (py-cy)*(py-cy) < r*r
end

function TestPointInBox( px, py, cx, cy, hsx, hsy )
   return math.abs(px - cx) < hsx and math.abs(py - cy) < hsy
end

function FindEmptyPos( hs_x, hs_y )
   -- TODO: Find EMPTY
   while true do
      local target_x, target_y = love.math.random_float(0,Map.width) , love.math.random_float(0,Map.height)
      target_x, target_y = ApplyBorders( target_x, target_y, hs_x, hs_y )
      if ( IsAlive(Hunter) or not TestOverlapBox( target_x, target_y, hs_x, hs_y, Hunter.pos_x, Hunter.pos_y, Hunter.hs_x, Hunter.hs_y ) )
         and ( IsAlive(Gatherer) or not TestOverlapBox( target_x, target_y, hs_x, hs_y, Gatherer.pos_x, Gatherer.pos_y, Gatherer.hs_x, Gatherer.hs_y ))
         and ( IsAlive(Scout) or not TestOverlapBox( target_x, target_y, hs_x, hs_y, Scout.pos_x, Scout.pos_y, Scout.hs_x, Scout.hs_y ) )
      then
         return target_x, target_y
      end
   end
end

function love.update(dt)

   -- Exit if paused
   if Game.IsPaused then return end

   -- Update/loop music
   Music.lifetime = Music.lifetime - dt
   if Music.lifetime < 0 then
      Music.current:stop()
      Music.lifetime = Music.vec_duration[ Music.type ]
      Music.current = Music.vec_music[ Music.type ]
      Music.current:play()
   end

   if Game.state == "Menu" then
      -- TODO
   elseif Game.state == "Playing" then
      Map.time = Map.time + dt
      Generate(dt)
      UpdateCharacters(dt)
      UpdateProjectiles(dt)
      UpdateHeaps(dt)
      UpdateWildlife(dt)
      UpdateMessages(dt)
   elseif Game.state == "Death" then
      Game.death_time = Game.death_time + dt
      if Game.death_time > Game.cDeathDuration then
         Game.state = "Game Over"
         Music.type = 1
      end
   elseif Game.state == "Game Over" then
      -- Nothin
   else --Game.state == "Paused"
      -- Nothing
   end
end

function NewGeneratorTimeouts()
   return { plant = 7, wood = 13, wolf = 23, bird = 17, bison = 29 }
--   return { plant = 7, wood = 13, wolf = 1, bird = 1, bison = 1 }
end

function Generate( dt )
   -- Generate Resources
   if table.getn(Resources.table) < Generator.cMaxResources then
      Generator.timeouts.plant = Generator.timeouts.plant - dt
      if Generator.timeouts.plant < 0 then
         Generator.timeouts.plant = Generator.cTimeouts.plant
         local x,y = FindEmptyPos( A_Plant.hs_x, A_Plant.hs_y )
         local r = NewResource( A_Plant, x, y )
         table.insert( Resources.table, r )
      end
      Generator.timeouts.wood = Generator.timeouts.wood - dt
      if Generator.timeouts.wood < 0 then
         Generator.timeouts.wood = Generator.cTimeouts.wood
         local x,y = FindEmptyPos( A_Wood.hs_x, A_Wood.hs_y )
         local r = NewResource( A_Wood, x, y )
         table.insert( Resources.table, r )
      end
   end
   -- Generate Wildlife
   if table.getn(Wildlife.table) < Generator.cMaxWildlife then
      Generator.timeouts.wolf = Generator.timeouts.wolf - dt
      if Generator.timeouts.wolf < 0 then
         Generator.timeouts.wolf = Generator.cTimeouts.wolf
         local x,y = FindEmptyPos( A_Wolf.hs_x, A_Wolf.hs_y ) --TODO: OUTSIDE FIRE RADIUS
         local w = NewWildlife( A_Wolf, x, y )
         table.insert( Wildlife.table, w )
      end
      Generator.timeouts.bird = Generator.timeouts.bird - dt
      if Generator.timeouts.bird < 0 then
         Generator.timeouts.bird = Generator.cTimeouts.bird
         local x,y = FindEmptyPos( A_Bird.hs_x, A_Bird.hs_y )  --TODO: OUTSIDE FIRE RADIUS
         local w = NewWildlife( A_Bird, x, y )
         table.insert( Wildlife.table, w )
      end
      Generator.timeouts.bison = Generator.timeouts.bison - dt
      if Generator.timeouts.bison < 0 then
         Generator.timeouts.bison = Generator.cTimeouts.bison
         local x,y = FindEmptyPos( A_Bison.hs_x, A_Bison.hs_y ) --TODO: IN LEFT OR RIGHT BORDER
         local w = NewWildlife( A_Bison, x, y )
         table.insert( Wildlife.table, w )
      end
   end
end

----------------------------------------------------------------
-- Heaps
----------------------------------------------------------------
function UpdateHeaps( dt )
   -- Consume resources on timeout
   for i,h in ipairs(Heaps.table) do
      h.timeout = h.timeout - dt
      if h.energy > 0 and h.timeout < 0 then
         local decrease = Characters.num_alive
         if h.class == "Fire" then
            decrease = 1
         end
         decrease = math.min( decrease, h.energy )
         h.energy = h.energy - decrease
         h.timeout = h.cTimeoutEnergy
         NewMessage_Upwards( "-"..decrease, 0.5, 0.66, h.pos_x, h.pos_y - h.hs_y, 100, {255,0,0,255} )
      end
   end
   -- Death if Fire extinguishes
   if Fire.energy == 0 then
      Game.state = "Death"
      Game.death_time = 0
   end
   -- Starving if run out of Food
   if Cereal.energy == 0 and Cereal.energy == 0 then
      for i,c in ipairs(Characters.table) do
         if c.state == "Alive" then
            c.state = "Starving"
            c.starving_timeout = Characters.cStarvingTimeout
            NewMessage_Upwards( "Starving in "..c.starving_timeout.."s", 0.5, 0.66, c.pos_x, c.pos_y - c.hs_y, 100, {255,0,0,255} )
         end
      end
   end
end

----------------------------------------------------------------
-- Actions
----------------------------------------------------------------
function NewAction_Idle()
   return { name = "Idle", time = 0 }
end

function NewAction_GoToPoint( e, x, y )
   if e.pos_x > x then
      e.facing = -1
   else
      e.facing = 1
   end
   return { name = "GoToPoint", time = 0, pos_x = x, pos_y = y, halfsize = 10 }
end

function NewAction_Dead()
   return { name = "Dead", time = 0 }
end

function NewAction_Shoot( x, y, t_x, t_y )
   local diff_x = t_x - x
   local diff_y = t_y - y
   local dist = math.sqrt( diff_x*diff_x + diff_y*diff_y )
   local d_x = diff_x / dist
   local d_y = diff_y / dist
   table.insert( Projectiles.table,
                 NewProjectile( A_Arrow,
                                MainCharacter.pos_x, MainCharacter.pos_y,
                                d_x, d_y ) )
   return { name = "Shoot", time = 0, pos_x = x, pos_y = y, dir_x = d_x, dir_y = d_y }
end

----------------------------------------------------------------
-- Characters
----------------------------------------------------------------
function UpdateCharacters( dt )
   for i,c in ipairs(Characters.table) do
      local a = c.archetype
      -- Starving
      if c.state == "Starving" then
         c.starving_timeout = c.starving_timeout - dt
         if c.starving_timeout < 0 then
            c.state = "Dead"
            c.action = NewAction_Dead()
            Characters.vec_death_sounds.STARVED:play()
            Characters.num_alive = Characters.num_alive - 1
            NewMessage_Upwards( "STARVED!", 0.5, 0.66, c.pos_x, c.pos_y - a.hs_y, 100, {255,0,0,255} )
         end
      end
      -- Actions
      if c.state ~= "Dead" then
         c.action.time = c.action.time + dt
         if c.action.name == "Idle" then
            -- Nothing
         elseif c.action.name == "GoToPoint" then
            -- Idle if already arrived
            if TestPointInBox( c.action.pos_x, c.action.pos_y, c.pos_x, c.pos_y, c.action.halfsize, c.action.halfsize ) then
               c.action = NewAction_Idle()
            else
               local diff_x = c.action.pos_x - c.pos_x
               local diff_y = c.action.pos_y - c.pos_y
               local dist = math.sqrt( diff_x*diff_x + diff_y*diff_y )
               local dir_x = diff_x / dist
               local dir_y = diff_y / dist
               c.pos_x = c.pos_x + dt * dir_x * a.cSpeed
               c.pos_y = c.pos_y + dt * dir_y * a.cSpeed
            end
         elseif c.action.name == "Shoot" then
            if c.action.time > 0.5 then
               c.action = NewAction_Idle()
            end
         end
         -- Borders
         c.pos_x, c.pos_y = ApplyBorders( c.pos_x, c.pos_y, a.hs_x, a.hs_y )

         -- Gather
         -- TryToGatherResource( c.resource_archetype, c.pos_x, c.pos_y, a.hs_x, a.hs_y )
         for i,r in ipairs(Resources.table) do
            if r.archetype == c.resource_archetype and TestOverlapBox( c.pos_x, c.pos_y, a.hs_x, a.hs_y,
                                                                       r.pos_x, r.pos_y, r.archetype.hs_x,
                                                                       r.archetype.hs_y ) then
               -- Increase specific Heap
               if r.archetype == A_Carcass then
                  Meat.energy = Meat.energy + 1
                  NewMessage_Upwards( "+1", 0.5, 0.5, Meat.pos_x, Meat.pos_y, 300, {0,255,0,255} )
               elseif a == A_Plant then
                  Cereal.energy = Cereal.energy + 1
                  NewMessage_Upwards( "+1", 0.5, 0.5, Cereal.pos_x, Cereal.pos_y, 300, {0,255,0,255} )
               else --Wood
                  Fire.energy = Fire.energy + 1
                  NewMessage_Upwards( "+1", 0.5, 0.5, Fire.pos_x, Fire.pos_y, 300, {0,255,0,255} )
               end
               -- Consume resource
               local r_idx = table.find_index( Resources.table, r )
               if r_idx > 0 then
                  table.remove( Resources.table, r_idx )
               end
            end
         end
      end
   end
   -- Endgame
   if Characters.num_alive == 0 then
      Game.state = "Death"
      Game.death_time = 0
   end
end

----------------------------------------------------------------
-- Wildlife
----------------------------------------------------------------
function UpdateWildlife( dt )
   for i,w in ipairs(Wildlife.table) do
      local a = w.archetype
      if w.state ~= "Dead" then
         -- Update Actions
         w.action.time = w.action.time + dt
         if w.action.name == "Idle" then
            -- TODO: Random jump to Attack/Steal/Wander
         elseif w.action.name == "GoToPoint" then
            -- Idle if already arrived
            if TestPointInBox( w.action.pos_x, w.action.pos_y, w.pos_x, w.pos_y, w.action.halfsize, w.action.halfsize ) then
               w.action = NewAction_Idle()
            else
               local diff_x = w.action.pos_x - w.pos_x
               local diff_y = w.action.pos_y - w.pos_y
               local dist = math.sqrt( diff_x*diff_x + diff_y*diff_y )
               local dir_x = diff_x / dist
               local dir_y = diff_y / dist
               w.pos_x = w.pos_x + dt * dir_x * a.cSpeed
               w.pos_y = w.pos_y + dt * dir_y * a.cSpeed
            end
         end
         -- Borders
         w.pos_x, w.pos_y = ApplyBorders( w.pos_x, w.pos_y, a.hs_x, a.hs_y )
         -- Continuous contextual actions
         if a == A_Wolf then
            -- TryToAttackCharacter( w.pos_x, w.pos_y, a.hs_x, a.hs_y )
         elseif a == A_Bird then
            --
         elseif a == A_Bison then
            TryToAttackCharacter( a, w.pos_x, w.pos_y, a.cAttackHalfsize, a.cAttackHalfsize )
            TryToStealResource( A_Plant, w.pos_x, w.pos_y, a.hs_x, a.hs_y )
         end
         -- Timeouted actions and thinking
         w.action_timeout = w.action_timeout - dt
         w.hunger_timeout = w.hunger_timeout - dt
         if w.action_timeout < 0 then
            -- Execute Contextual Action (Attack,Steal)
            if a == A_Wolf then
               if TryToStealHeap( Meat, w.pos_x, w.pos_y, a.hs_x, a.hs_y ) then
                  w.hunger_timeout = a.cHungerTimeout
               elseif TryToAttackCharacter( a, w.pos_x, w.pos_y, a.cAttackHalfsize, a.cAttackHalfsize ) then
                  w.hunger_timeout = a.cHungerTimeout
               end
            elseif a == A_Bird then
               if TryToStealResource( A_Plant, w.pos_x, w.pos_y, a.hs_x, a.hs_y ) then
                  w.hunger_timeout = a.cHungerTimeout
               elseif TryToStealHeap( Cereal, w.pos_x, w.pos_y, a.hs_x, a.hs_y ) then
                  w.hunger_timeout = a.cHungerTimeout
               end
            elseif a == A_Bison then
               -- No timeouted actions, it does it all the time
               -- TryToAttackCharacter( a, w.pos_x, w.pos_y, a.cAttackHalfsize, a.cAttackHalfsize )
               -- TryToStealResource( A_Plant, w.pos_x, w.pos_y, a.hs_x, a.hs_y )
            end
            -- Think next move
            if w.action.name == "Idle" then
               if a == A_Wolf then
                  -- Priority 0: Flee from fire
                  local diff_x = w.pos_x - Fire.pos_x
                  local diff_y = w.pos_y - Fire.pos_y
                  local dist = math.sqrt( diff_x*diff_x + diff_y*diff_y )
                  -- TODO: Decrease fire safety radius when extinguishing
                  if dist < Fire.cRadius then
                     local dir_x = diff_x / dist
                     local dir_y = diff_y / dist
                     local flee_dist = a.hs_y + love.math.random_float( Fire.cRadius, 1.5*Fire.cRadius )
                     local target_x, target_y = ApplyBorders( Fire.pos_x + flee_dist*dir_x  + 0.25*Map.width*love.math.random_float(-1,1),
                                                              Fire.pos_y + flee_dist*dir_y  + 0.25*Map.height*love.math.random_float(-1,1),
                                                              a.hs_x, a.hs_y )
                     w.action = NewAction_GoToPoint( w, target_x, target_y )
                  elseif w.hunger_timeout < 0 then -- Priority 1: Fulfill hunger
                     -- Decide between Steal or Attack
                     if love.math.random_float(0,1) < 0.25 then
                        w.action = NewAction_GoToPoint( w, Meat.pos_x, Meat.pos_y )
                     else
                        if love.math.random_float(0,1) < 0.5 and IsAlive(Gatherer) and Distance( Gatherer, Fire ) > Fire.cRadius/2 then
                           w.action = NewAction_GoToPoint( w, Gatherer.pos_x, Gatherer.pos_y )
                        elseif IsAlive(Hunter) and Distance( Hunter, Fire ) > Fire.cRadius/2 then
                           w.action = NewAction_GoToPoint( w, Hunter.pos_x, Hunter.pos_y )
                        elseif IsAlive(Scout) and Distance( Scout, Fire ) > Fire.cRadius/2 then
                           w.action = NewAction_GoToPoint( w, Scout.pos_x, Scout.pos_y )
                        end
                     end
                  end -- Remain Idle
               elseif a == A_Bird then
                  -- Priority 0: Flee from fire
                  local diff_x = w.pos_x - Fire.pos_x
                  local diff_y = w.pos_y - Fire.pos_y
                  local dist = math.sqrt( diff_x*diff_x + diff_y*diff_y )
                  -- TODO: Decrease fire safety radius when extinguishing
                  if dist < Fire.cRadius then
                     local dir_x = diff_x / dist
                     local dir_y = diff_y / dist
                     local flee_dist = a.hs_y + love.math.random_float( Fire.cRadius, 1.5*Fire.cRadius )
                     local target_x, target_y = ApplyBorders( Fire.pos_x + flee_dist*dir_x  + 0.25*Map.width*love.math.random_float(-1,1),
                                                              Fire.pos_y + flee_dist*dir_y  + 0.25*Map.height*love.math.random_float(-1,1),
                                                              a.hs_x, a.hs_y )
                     w.action = NewAction_GoToPoint( w, target_x, target_y )
                  elseif w.hunger_timeout < 0 then -- Priority 1: Fulfill hunger
                     -- Decide between Steal or Gather
                     if love.math.random_float(0,1) < 0.99 then
                        w.action = NewAction_GoToPoint( w, Cereal.pos_x, Cereal.pos_y )
                     else
                        local target_x, target_y = FindClosestResourcePos( A_Plant, w.pos_x, w.pos_y )
                        w.action = NewAction_GoToPoint( w, ApplyBorders( target_x, target_y, a.hs_x, a.hs_y ) )
                     end
                  end -- Remain Idle
               elseif a == A_Bison then
                  -- STAMPEDE!!!!!
                  if w.pos_x >= Map.width - 2*a.hs_x then
                     w.action = NewAction_GoToPoint( w, a.hs_x, w.pos_y )
                  --elseif w.pos_x < 2*a.hs_x then
                     --                     w.action = NewAction_GoToPoint( w, Map.width - a.hs_x, w.pos_y )
                  else
                     w.action = NewAction_GoToPoint( w, Map.width - a.hs_x, w.pos_y )
                  end
                  -- TEMP: Bison is exported reversed, yeah
                  w.facing = -w.facing
                  -- Otherwise, Idle, but could change dir
               end
            end
            w.action_timeout = a.cActionTimeout
         end
      end
   end
end

function FindClosestResourcePos( archetype, pos_x, pos_y )
   -- TODO: FIND CLOSEST!!
   for i,r in ipairs(Resources.table) do
      if r.archetype == archetype then
         return r.pos_x, r.pos_y
      end
   end
   return pos_x, pos_y
end

function TryToStealResource( archetype, pos_x, pos_y, hs_x, hs_y )
   for i,r in ipairs(Resources.table) do
      if r.archetype == archetype and TestOverlapBox( pos_x, pos_y, hs_x, hs_y,
                                                      r.pos_x, r.pos_y,
                                                      r.archetype.hs_x, r.archetype.hs_y ) then
         -- Consume resource
         NewMessage_Upwards( "-1", 0.5, 0.5, r.pos_x, r.pos_y, 300, {255,0,0,255} )
         local r_idx = table.find_index( Resources.table, r )
         if r_idx > 0 then
            table.remove( Resources.table, r_idx )
         end
         return true
      end
   end
   return false
end

function TryToStealHeap( heap, pos_x, pos_y, hs_x, hs_y )
   if heap.energy > 0 then
      if TestOverlapBox( pos_x, pos_y, hs_x, hs_y, heap.pos_x, heap.pos_y, heap.hs_x, heap.hs_y ) then
         heap.energy = heap.energy - 1
         NewMessage_Upwards( "-1", 0.5, 0.5, heap.pos_x, heap.pos_y, 300, {255,0,0,255} )
         return true
      end
   end
   return false
end

function TryToAttackCharacter( attacker_archetype, pos_x, pos_y, hs_x, hs_y )
   for i,c in ipairs(Characters.table) do
      if c.state == "Alive" or c.state == "Starving" then
         if TestOverlapBox( pos_x, pos_y, hs_x, hs_y, c.pos_x, c.pos_y, c.archetype.hs_x, c.archetype.hs_y ) then
            c.state = "Dead"
            c.action = NewAction_Dead()
            Characters.vec_death_sounds.KILLED:play()
            Characters.num_alive = Characters.num_alive - 1
            if attacker_archetype == A_Wolf then
               NewMessage_Upwards( "EATEN!", 0.5, 0.66, c.pos_x, c.pos_y - c.archetype.hs_y, 100, {255,0,0,255} )
            elseif attacker_archetype == A_Bison then
               NewMessage_Upwards( "STAMPEDED!", 0.5, 0.66, c.pos_x, c.pos_y - c.archetype.hs_y, 100, {255,0,0,255} )
            end
            return true
         end
      end
   end
   return false
end

----------------------------------------------------------------
-- Projectiles
----------------------------------------------------------------
function UpdateProjectiles( dt )
   removed_projectiles = {}
   for i,p in ipairs(Projectiles.table) do
      local a = p.archetype
      -- Advance
      p.pos_x = p.pos_x + dt * p.dir_x * a.cSpeed
      p.pos_y = p.pos_y + dt * p.dir_y * a.cSpeed
      -- Remove if Kill or out of bounds
      if TryToKillWithProjectile( p ) or not IsInsideBorders( p.pos_x, p.pos_y, a.hs_x, a.hs_y ) then
         table.insert( removed_projectiles, i )
      end
   end
   for i,idx in ipairs(removed_projectiles) do
      table.remove( Projectiles.table, idx )
   end
end

function TryToKillWithProjectile( p )
   -- Check Wildlife
   removed_wildlife = {}
   for i,w in ipairs(Wildlife.table) do
      local a = w.archetype
      if w.state ~= "Dead" then
         if TestOverlapBox( p.pos_x, p.pos_y, p.archetype.cAttackHalfsize, p.archetype.cAttackHalfsize,
                            w.pos_x, w.pos_y, w.archetype.cDamageHalfsize, w.archetype.cDamageHalfsize ) then
            w.state = "Dead"
            w.action = nil
            for n=1,a.cCarcassNum do
               table.insert( Resources.table,
                             NewResource( A_Carcass,
                                          w.pos_x + 2*A_Carcass.hs_x*love.math.random_float(-1,1),
                                          w.pos_y + 2*A_Carcass.hs_y*love.math.random_float(-1,1) ) )
            end
            table.insert( removed_wildlife, i )
            NewMessage_Upwards( "HUNTED!", 0.5, 0.66, w.pos_x, w.pos_y - a.hs_y, 100, {0,255,0,255} )
         end
      end
   end
   for i,idx in ipairs(removed_wildlife) do
      table.remove( Wildlife.table, idx )
   end
   -- Check Characters
   removed_characters = {}
   for i,c in ipairs(Characters.table) do
      local a = c.archetype
      if a ~= Hunter then
         if c.state ~= "Dead" then
            if TestOverlapBox( p.pos_x, p.pos_y, p.archetype.cAttackHalfsize, p.archetype.cAttackHalfsize,
                               c.pos_x, c.pos_y, c.archetype.cDamageHalfsize, c.archetype.cDamageHalfsize ) then
               c.state = "Dead"
               c.action = NewAction_Dead()
               Characters.vec_death_sounds.ARROWED:play()
               Characters.num_alive = Characters.num_alive - 1
               table.insert( removed_characters, i )
               NewMessage_Upwards( "ARROWED!", 0.5, 0.66, c.pos_x, c.pos_y - a.hs_y, 100, {255,0,0,255} )
            end
         end
      end
   end
   for i,idx in ipairs(removed_characters) do
      table.remove( Characters.table, idx )
   end
   --
   return table.getn(removed_wildlife) > 0 or table.getn(removed_characters) > 0
end

----------------------------------------------------------------
-- Messages
----------------------------------------------------------------
function UpdateMessages( dt )
   removed_messages = {}
   for i,m in ipairs(Messages) do
      m.time = m.time + dt
      if m.time > m.duration then
         table.insert( removed_messages, i )
      end
   end
   for i,message_index in ipairs(removed_messages) do
      table.remove( Messages, message_index )
   end
end

----------------------------------------------------------------
-- Drawing
----------------------------------------------------------------
function love.draw()
   if Game.state == "Menu" then
      DrawMenu()
   elseif Game.state == "Tutorial" then
      DrawTutorial()
   elseif Game.state == "Playing" or Game.state == "Death" then
      DrawGameOrDeath()
   elseif Game.state == "Game Over" then
      DrawGameOver()
   end
   -- if Game.IsPaused then
   --    love.graphics.print( "PAUSED",
   --                         (Map.width - message_font:getWidth( Game.state ))/2,
   --                         (Map.height - message_font:getHeight())/2 )
   -- end
end

function DrawMenu()
      love.graphics.setColor(255,255,255,255)
      love.graphics.draw( Game.splashscreen )

      love.graphics.setFont( message_font )
      love.graphics.setColor(200,64,0,255)
      local text = "(Press any key)"
      love.graphics.print( text,
                           (Map.width - message_font:getWidth( text ))/2,
                           Map.height - 1.1*message_font:getHeight() )
end

function DrawTutorial()
      love.graphics.setColor(255,255,255,255)
      love.graphics.draw( Game.tutorialscreen )

      love.graphics.setFont( message_font )
      love.graphics.setColor(200,64,0,255)
      local text = "How to Play"
      love.graphics.print( text,
                           (Map.width - message_font:getWidth( text ))/2,
                           10 )
      text = "(Press any key)"
      love.graphics.print( text,
                           (Map.width - message_font:getWidth( text ))/2,
                           Map.height - 1.1*message_font:getHeight() )
end

function DrawGameOrDeath()
      -- Clear color
      love.graphics.setColor(255,255,255,255)
      -- Background
      love.graphics.draw( Map.background )
      -- TODO Shadows

      DrawHeaps()
      DrawScoutTorch()
      DrawResources()
      DrawAnimatedEntities( Characters.table )
      DrawCharacterAura()
      DrawAnimatedEntities( Projectiles.table )
      DrawAnimatedEntities( Wildlife.table )

      -- HUD
      love.graphics.setFont( hud_font )
      love.graphics.setColor(255,128,32,255)
      love.graphics.print( "Fire "..Fire.energy,
                           10, 10,
                           0,
                           1, 1 )
      love.graphics.print( "Cereal "..Cereal.energy,
                           10, 60,
                           0,
                           1, 1 )
      love.graphics.print( "Meat "..Meat.energy,
                           10, 110,
                           0,
                           1, 1 )

      -- Messages
      love.graphics.setFont( message_font )
      for i,m in ipairs(Messages) do
         if m.class == "Centered" then
            love.graphics.setColor( m.color[1], m.color[2], m.color[3], m.color[4] )
            local length = m.scale*message_font:getWidth( m.text )
            local height = m.scale*message_font:getHeight()
            local dx = love.math.random_float(-length/10,length/10)
            local dy = love.math.random_float(-height/10,height/10)
            love.graphics.print( m.text,
                                 (Map.width - length)/2 + dx,
                                 (Map.height)/2 - height + dy,
                                 --(Map.height - height)/2 + dy,
                                 0,
                                 m.scale, m.scale )
         elseif m.class == "Upwards" then
            local alpha01 = 1 - math.max( 0, m.time / m.duration )
            alpha01 = math.sqrt(math.sqrt(alpha01))
            love.graphics.setColor( m.color[1], m.color[2], m.color[3], alpha01*m.color[4] )
            local length = m.scale*message_font:getWidth( m.text )
            local height = m.scale*message_font:getHeight()
            local dx = 0
            local dy = -m.speed_y * math.sqrt(math.sqrt(m.time))
            love.graphics.print( m.text,
                                 m.pos_x + dx,
                                 m.pos_y + dy,
                                 --(Map.height - height)/2 + dy,
                                 0,
                                 m.scale, m.scale )
         end
      end
      -- Fade to red if dead
      if Game.state == "Death" then
         local lambda01 = math.min( Game.death_time / Game.cDeathDuration, 1 )
         love.graphics.setColor(255,0,0,lambda01*255)
         love.graphics.rectangle( "fill", 0, 0, Map.width, Map.height )
         --[[
         love.graphics.print( Game.state,
                              (Map.width - message_font:getWidth( Game.state ))/2,
                              (Map.height - message_font:getHeight())/2 )
         --]]
      end

      if IsEnabledDebugMode then
         DrawDebug()
      end
end

function DrawGameOver()
      love.graphics.setColor(255,0,0,255)
      love.graphics.rectangle( "fill", 0, 0, Map.width, Map.height )
      love.graphics.setColor(0,0,0,255)
      love.graphics.print( Game.state,
                           (Map.width - message_font:getWidth( Game.state ))/2,
                           (Map.height - message_font:getHeight())/2 )
      local score_text = "Survived for "..math.floor(Map.time).. "s"
      if Fire.energy == 0 then
         score_text = score_text.. " until your tribe was engulfed by darkness"
      elseif Cereal.energy == 0 and Meat.energy == 0 then
         score_text = score_text.. " until your tribe starved to death"
      elseif Characters.num_alive == 0 then
         score_text = score_text.. " until your tribe fell prey to wild animals"
      end
      love.graphics.setColor( love.math.random(128,255),
                              love.math.random(128,255),
                              love.math.random(128,255),
                              255 )
      love.graphics.print( score_text,
                           (Map.width - message_font:getWidth( score_text ))/2,
                           (Map.height)/2 + message_font:getHeight() )
end

function DrawHeaps()
   ---- Firelight
   local lambda01 = math.max( 0, Fire.energy / Fire.cInitialEnergy ) --blink faster as lifetime reduces
   local radius = Fire.cRadius
   -- Outer
   love.graphics.setColor( 255,
                           128,--(1-lambda01) * 128,
                           0,--(1-lambda01) * 255,
                           love.math.random( lambda01*25, 50 ) )
   love.graphics.circle( "fill",
                         Fire.pos_x + 50*(1-lambda01) * love.math.random_float(-1,1),
                         Fire.pos_y + 50*(1-lambda01) * love.math.random_float(-1,1),
                         radius,
                         32 )
   -- Inner
   local inner_fire_alpha_factor = love.math.random( lambda01, 2 )
   love.graphics.setColor( 255,
                           64,--(1-lambda01) * 128,
                           0,--(1-lambda01) * 255,
                           25*inner_fire_alpha_factor )
   love.graphics.circle( "fill",
                         Fire.pos_x + 25*(1-lambda01) * love.math.random_float(-1,1),
                         Fire.pos_y + 25*(1-lambda01) * love.math.random_float(-1,1),
                         radius/2,
                         32 )
   -- Fire
   local fire_frame = 1
   if inner_fire_alpha_factor > 1 then
      fire_frame = 2
   end
   love.graphics.setColor(255,255,255,255)
   love.graphics.draw( Fire.vec_frames[fire_frame], Fire.pos_x, Fire.pos_y, 0, 1, 1, Fire.hs_x, Fire.hs_y )
   -- Other
   love.graphics.setColor(255,255,255,255)
   love.graphics.draw( Cereal.image, Cereal.pos_x, Cereal.pos_y, 0, 1, 1, Cereal.hs_x, Cereal.hs_y )
   love.graphics.draw( Meat.image, Meat.pos_x, Meat.pos_y, 0, 1, 1, Meat.hs_x, Meat.hs_y )
end

function DrawScoutTorch()
   if IsAlive(Scout) then
      -- Torch has same lifetime as Fire
      local lambda01 = math.max( 0, Fire.energy / Fire.cInitialEnergy ) --blink faster as lifetime reduces
      local radius = 100
      local inner_fire_alpha_factor = love.math.random( lambda01, 2 )
      love.graphics.setColor( 255,
                              128,--(1-lambda01) * 128,
                              0,--(1-lambda01) * 255,
                              25*inner_fire_alpha_factor )
      love.graphics.circle( "fill",
                            Scout.pos_x + 25*(1-lambda01) * love.math.random_float(-1,1),
                            Scout.pos_y + 25*(1-lambda01) * love.math.random_float(-1,1),
                            radius,
                            32 )
   end
end

function NewResource( a, x, y )
   return { archetype = a, pos_x = x, pos_y = y }
end

function NewWildlife( a, x, y )
   return { archetype = a, pos_x = x, pos_y = y, action_timeout = a.cActionTimeout, hunger_timeout = a.cHungerTimeout, facing = 1, action = NewAction_Idle() }
end

function NewProjectile( a, x, y, d_x, d_y )
   local f = 1
   return { archetype = a, pos_x = x, pos_y = y, dir_x = d_x, dir_y = d_y, facing = f, angle = math.atan2( d_y, d_x ) }
end

function DrawResources()
   for i,r in ipairs(Resources.table) do
      -- local alpha01 = r.energy / r.cInitialEnergy
      -- love.graphics.setColor(255,255,255,64 + alpha01*(255-64))
      local a = r.archetype
      love.graphics.setColor(255,255,255,255)
      love.graphics.draw( a.image,
                          r.pos_x, r.pos_y,
                          0,
                          1, 1,
                          a.hs_x, a.hs_y )
   end
end

-- Characters and Wildlife
function DrawAnimatedEntities( t )
   -- Clear color
   love.graphics.setColor(255,255,255,255)
   -- Draw frame of cyclic animation
   for i,e in ipairs(t) do
      local archetype = e.archetype
      if e.action ~= nil then
         local animation = archetype.animations[e.action.name]
         local mod_time = math.fmod( e.action.time, animation.duration )
         local frame_lambda = mod_time / animation.duration;
         frame_lambda = math.max( 0, math.min( frame_lambda, 1 ) )
         --print( "Frame: Time " .. e.action.time .. " Duration " ..  animation.duration .. " ModTime " .. mod_time .. " Lambda " .. frame_lambda )
         local frame_idx = 1 + math.floor( (table.getn( animation.vec_frames )) * frame_lambda )
         --print( "Frame: Index " .. frame_idx .. " Count " .. table.getn( animation.vec_frames ) )
         local hs_y = animation.vec_frames[frame_idx]:getHeight() / 2
         love.graphics.draw( animation.vec_frames[frame_idx],
                             e.pos_x, e.pos_y + archetype.hs_y, --pivot at feet
                             0,
                             e.facing*1, 1,
                             archetype.hs_x, 2*hs_y ) --top at 2x half height
      else
         local angle = 0
         if e.angle ~= nil then angle = e.angle end
         love.graphics.draw( archetype.image,
                             e.pos_x, e.pos_y,
                             angle,
                             e.facing*1, 1,
                             archetype.hs_x, archetype.hs_y )
      end
   end
end

function DrawCharacterAura()
   local mod_time = math.fmod( Map.time, 0.66 )
   local frame_lambda = mod_time / 0.66;
   frame_lambda = math.max( 0, math.min( frame_lambda, 1 ) )
   local frame_idx = 1 + math.floor( 2 * frame_lambda )
   local aura_frame = Characters.vec_aura_frames[ frame_idx ]
   love.graphics.draw( aura_frame,
                       MainCharacter.pos_x, MainCharacter.pos_y,
                       0,
                       1, 1,
                       aura_frame:getWidth()/2, aura_frame:getHeight()/2 )
end

function DrawDebug()
   -- Cells
   -- for it_row=1,Map.rows do
   --    love.graphics.setColor(255,0,0,255)
   --    for it_col=1,Map.cols do
   --       local pos = { Map.cell_sizes[1]*(it_col - 0.5), Map.cell_sizes[2]*(it_row - 0.5) }
   --       love.graphics.rectangle( "fill", pos[1]-5, pos[2]-5, 10, 10 )
   --    end
   -- end
   -- Characters
   for i,c in ipairs( Characters.table ) do
      -- MC in white
      if c == MainCharacter then
         love.graphics.setColor(255,255,255,255)
      else
         love.graphics.setColor(0,0,255,255)
      end
      -- Starving in Pink, Dead in Red
      if c.state == "Starving" then
         love.graphics.setColor(255,128,128,255)
      elseif c.state == "Dead" then
         love.graphics.setColor(255,0,0,255)
      end
      -- Position
      love.graphics.rectangle( "fill", c.pos_x-5, c.pos_y-5, 10, 10 )
      -- Action state
      if c.action.name == "Idle" then
         love.graphics.rectangle( "line",
                                  c.pos_x - c.archetype.hs_x, c.pos_y - c.archetype.hs_y,
                                  2*c.archetype.hs_x, 2*c.archetype.hs_y )
      elseif c.action.name == "GoToPoint" then
         love.graphics.line( c.pos_x, c.pos_y,
                             c.action.pos_x, c.action.pos_y )
      end
   end
   -- Wildlife
   for i,w in ipairs( Wildlife.table ) do
      -- MC in white
      if c == MainCharacter then
         love.graphics.setColor(255,255,255,255)
      else
         love.graphics.setColor(0,0,255,255)
      end
      -- Starving in red
      if w.state == "Starving" then
         love.graphics.setColor(255,0,0,255)
      end
      -- Position
      love.graphics.rectangle( "fill", w.pos_x-5, w.pos_y-5, 10, 10 )
      -- Action state
      if w.action.name == "Idle" then
         love.graphics.rectangle( "line",
                                  w.pos_x - w.archetype.hs_x, w.pos_y - w.archetype.hs_y,
                                  2*w.archetype.hs_x, 2*w.archetype.hs_y )
      elseif w.action.name == "GoToPoint" then
         love.graphics.line( w.pos_x, w.pos_y,
                             w.action.pos_x, w.action.pos_y )
      end
   end
end

function IsAlive( c )
   return c.state == "Alive" or c.state == "Starving"
end

function Distance( a, b )
   local diff_x = a.pos_x - b.pos_x
   local diff_y = a.pos_y - b.pos_y
   return math.sqrt( diff_x*diff_x + diff_y*diff_y )
end

function love.quit()
   print("So Long...")
end

function table.find_index( t, e )
   for i,v in ipairs( t ) do
      if v == e then
         return i
      end
   end
   return -1
end
