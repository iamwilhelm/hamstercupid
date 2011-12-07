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

function readPlayerInput(entity)
  local direction = V:new(0, 0)

  if love.keyboard.isDown('right') then
    direction.x = 1
    entity.model.state = "walk.right"
    entity.children[1].model.state = "look.right"
  end
  if love.keyboard.isDown('left') then
    direction.x = -1
    entity.model.state = "walk.left"
    entity.children[1].model.state = "look.left"
  end
  if love.keyboard.isDown('down') then
    direction.y = 1
    if string.find(entity.model.state, "right") then
      entity.model.state = "walk.down.right"
      entity.children[1].model.state = "look.down.right"
    else 
      entity.model.state = "walk.down.left"
      entity.children[1].model.state = "look.down.left"
    end
  end
  if love.keyboard.isDown('up') then
    direction.y = -1
    if string.find(entity.model.state, "right") then
      entity.model.state = "walk.up.right"
      entity.children[1].model.state = "look.up.right"
    else
      entity.model.state = "walk.up.left"
      entity.children[1].model.state = "look.up.left"
    end
  end
  
  return direction
end

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

-- FIXME every person object is taking up 5MB, because none of the sprites are being shared across objects. 
-- We need to make sprites be loaded and shared between objects that are identical.
function createPerson(x, y)
  local person = Person:new(x, y)
  return person
end

player = nil
function love.load()
  -- TODO A simple entity manager. we just have a list that we run through when we're drawing them all. It needs to be ordered by Z-order
  entities = {}

  math.randomseed(os.time())
  for i = 1, 5 do 
    -- table.insert(entities, createPerson(400, 300))
    table.insert(entities, createPerson(math.random(20, 780), math.random(20, 580)))
  end
  player = entities[1]
end
end

function love.update(dt)
  readCameraInput()

  --  update all entities in a uniform way
  for i, entity in ipairs(entities) do
    entity:update(dt, function()
      if entity.physics ~= nil then
        entity.physics:update(dt)
      end

      local direction = readPlayerInput(player)
      player.movement:go(dt, direction)

    end)
  end

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

