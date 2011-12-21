-- require('lib/pepperfish_profiler')
-- profiler = newProfiler()
-- profiler:start()

-- require('luarocks.loader')
-- require('profiler')
-- profiler:start("./profiling/luaprofiler_results.out")

require('vector')
require('entity')
require('camera')

require('characters/person')

-- Read player input

function readCameraInput()
  if love.keyboard.isDown("l") then
    camera:pan(V:new(20, 0))
  end
  if love.keyboard.isDown('j') then
    camera:pan(V:new(-20, 0))
  end
  if love.keyboard.isDown('k') then
    camera:pan(V:new(0, 20))
  end
  if love.keyboard.isDown('i') then
    camera:pan(V:new(0, -20))
  end
  if love.keyboard.isDown('u') then
    camera:zoom(1.05)
  end
  if love.keyboard.isDown('o') then
    camera:zoom(1 / 1.05)
  end
end

function readPlayerWayPoint()
  return V:new(love.mouse.getX(), love.mouse.getY())
end

Keyboard = {}
Keyboard.__index = Keyboard
function Keyboard:new()
  local instance = {
    map = {},
  }
  setmetatable(instance, self)
  return instance 
end

-- Every entity has controls that need to be hooked to an input. The input to the controls 
-- may be the keyboard, a script, or AI
function Keyboard:hookTo(block)
  block(self.map)
end

function Keyboard:navigateWithKeyPressedActions(key)
end

function Keyboard:navigateWithKeyHeldActions()
  for key, navigation in pairs(self.map) do
    if love.keyboard.isDown(key) then
      print("pushed key: " .. key)
      print(navigation)
      navigation()
    end
  end
end

function Keyboard:navigateWithKeyReleaseActions(key)
end


-- Map functions

map = {}
function map:draw()
  love.graphics.line(
    0, 0, 
    love.graphics.getWidth(), 0,
    love.graphics.getWidth(), love.graphics.getHeight(),
    0, love.graphics.getHeight(),
    0, 0
  )
end

-- Callback functions for main loop
function createCow()
  cow = Entity:new(325, 325)
  cow.view:setImage("resources/cow.png")
  return cow
end

-- FIXME every person object is taking up 5MB, because none of the sprites 
-- are being shared across objects. 
-- We need to make sprites be loaded and shared between objects that are identical.
function createPerson(x, y)
  local person = Person:new(x, y)
  return person
end

player = nil
function love.load()
  -- TODO A simple entity manager. we just have a list that we run through when 
  -- we're drawing them all. It needs to be ordered by Z-order
  entities = {}

  math.randomseed(os.time())
  for i = 1, 1 do 
    -- table.insert(entities, createPerson(400, 300))
    table.insert(entities, createPerson(math.random(20, 780), math.random(20, 580)))
  end
  player = entities[1]
  
  keyboard = Keyboard:new()
  keyboard:hookTo(function(map)
    map.up = function()
      player:control("north")
    end
    map.down = function()
      player:control("south")
    end
    map.right = function()
      player:control("east")
    end
    map.left = function()
      player:control("west")
    end
    map["z"] = function()
      player:control("throw")
    end
    map.otherwise = function()
      player:control("stand")
    end
  end)
end

function love.keyboard.keypressed(key, unicode)
end

function love.keyboard.keyreleased(key, unicode)
end

function love.update(dt)
  -- allow player entities to accept input
  readCameraInput()
  keyboard:navigateWithKeyHeldActions()

  -- allow the entities to think
  for _, entity in ipairs(entities) do
    entity:think(dt)
  end

  -- control the entities based on thinking decisions
  -- FIXME Consider whether navigate should be in subsumed in move()
  for _, entity in ipairs(entities) do
    entity:navigate(dt)
  end

  -- calculate the different motions and physics and collision detection
  for _, entity in ipairs(entities) do
    entity:move(dt) 
  end

  --  update the positions and animations of all entities in a uniform way
  for _, entity in ipairs(entities) do
    entity:update(dt)
  end

  print("-----------")
end

function love.draw()
  camera:shoot(function()
    -- TODO Will need to sort entities by Z-order and draw them according to z-order
    for _, entity in ipairs(entities) do
      entity:draw()
    end
    map:draw()
  end)

  love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 20)
end

function love.quit()
  print("Thanks for viewing the demo!")

--  --  pepperfish profiler
--  profiler:stop()
--  local outfile = io.open("profiling/pepperfish_results.out", "w+")
--  profiler:report(outfile)
--  outfile:close()

  -- lua profiler
  --  profiler:stop()
end

