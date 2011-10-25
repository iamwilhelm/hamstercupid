require('vector')
require('entity')
require('camera')
require('motion')

require('lib/pepperfish_profiler')
profiler = newProfiler()
profiler:start()

-- Read player input

function readPlayerInput(entity)
  local direction = V:new(0, 0)

  if love.keyboard.isDown('d') then
    direction.x = 1
    entity.model.state = "walk.right"
    entity.children[1].model.state = "look.right"
  end
  if love.keyboard.isDown('a') then
    direction.x = -1
    entity.model.state = "walk.left"
    entity.children[1].model.state = "look.left"
  end
  if love.keyboard.isDown('s') then
    direction.y = 1
    if string.find(entity.model.state, "right") then
      entity.model.state = "walk.down.right"
      entity.children[1].model.state = "look.down.right"
    else 
      entity.model.state = "walk.down.left"
      entity.children[1].model.state = "look.down.left"
    end
  end
  if love.keyboard.isDown('w') then
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
  if love.keyboard.isDown("right") then
    camera:pan(V:new(20, 0))
  end
  if love.keyboard.isDown('left') then
    camera:pan(V:new(-20, 0))
  end
  if love.keyboard.isDown('down') then
    camera:pan(V:new(0, 20))
  end
  if love.keyboard.isDown('up') then
    camera:pan(V:new(0, -20))
  end
  if love.keyboard.isDown(']') then
    camera:zoom(1.05)
  end
  if love.keyboard.isDown('[') then
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

function createPerson(x, y)
  local person = Entity:new("person", V:new(x, y))
  person.view:film("resources/dodgeball/wildlynx.gif", function(view)
    view:animation("stand.down.left", 40, 32, {}, function(animation)
      animation:frame(0, 0)
    end)

    view:animation("walk.down.left", 40, 32, { offset = V:new(0, 0), period = 1 }, function(animation)
      animation:frame(0, 3, { cols = 3 })
      animation:frame(1, 0, { cols = 3 })
    end)

    view:animation("stand.down.right", 40, 32, {}, function(animation)
      animation:frame(0, 0, { scale = V:new(-1, 1) })
    end)

    view:animation("walk.down.right", 40, 32, { offset = V:new(0, 0), period = 1 }, function(animation)
      animation:frame(0, 3, { cols = 3, scale = V:new(-1, 1) })
      animation:frame(1, 0, { cols = 3, scale = V:new(-1, 1) })
    end)

    view:animation("stand.left", 40, 32, {}, function(animation)
      animation:frame(0, 1)
    end)

    view:animation("walk.left", 40, 32, {}, function(animation)
      animation:frame(1, 3, { cols = 3 })
      animation:frame(2, 0, { cols = 3 })
    end)

    view:animation("stand.right", 40, 32, {}, function(animation)
      animation:frame(0, 1, { scale = V:new(-1, 1) })
    end)

    view:animation("walk.right", 40, 32, { scale = V:new(-1, 1) }, function(animation)
      animation:frame(1, 3, { cols = 3, scale = V:new(-1, 1) })
      animation:frame(2, 0, { cols = 3, scale = V:new(-1, 1) })
    end)

    view:animation("stand.up.left", 40, 32, {}, function(animation)
      animation:frame(0, 2, {})
    end)

    view:animation("walk.up.left", 40, 32, {}, function(animation)
      animation:frame(2, 3, { cols = 3 })
      animation:frame(3, 0, { cols = 3 })
    end)

    view:animation("stand.up.right", 40, 32, {}, function(animation)
      animation:frame(0, 2, { scale = V:new(-1, 1) })
    end)

    view:animation("walk.up.right", 40, 32, {}, function(animation)
      animation:frame(2, 3, { cols = 3, scale = V:new(-1, 1) })
      animation:frame(3, 0, { cols = 3, scale = V:new(-1, 1) })
    end)
  end)

  -- FIXME performance issue: addind child entity significantly degrades performance.
  local head = Entity:new("head", V:new(0, -18))
  head.view:film("resources/dodgeball/wildlynx.gif", function(view)
    view:animation("look.down.left", 32, 32, { offset = V:new(768, 0) }, function(animation)
      animation:frame(0, 0)
    end)

    view:animation("look.left", 32, 32, { offset = V:new(768, 0) }, function(animation)
      animation:frame(0, 1)
    end)

    view:animation("look.up.left", 32, 32, { offset = V:new(768, 0) }, function(animation)
      animation:frame(0, 2)
    end)

    view:animation("look.down.right", 32, 32, { offset = V:new(768, 0) }, function(animation)
      animation:frame(0, 0, { scale = V:new(-1, 1) })
    end)

    view:animation("look.right", 32, 32, { offset = V:new(768, 0) }, function(animation)
      animation:frame(0, 1, { scale = V:new(-1, 1) })
    end)

    view:animation("look.up.right", 32, 32, { offset = V:new(768, 0) }, function(animation)
      animation:frame(0, 2, { scale = V:new(-1, 1) })
    end)
  end)
  head.movement:addMovement(Motion.wiggle(0.5, 0.5, math.rad(270)))
  person:addChild(head)

  -- FIXME forgetting to initialize the state is causing bugs when writing the DSL
  person.model.state = "walk.down.left"
  head.model.state = "look.down.left"

  return person
end

function love.load()
  entities = {}

  math.randomseed(os.time())
  for i = 1, 200 do 
    -- table.insert(entities, createPerson(400, 300))
    table.insert(entities, createPerson(math.random(20, 780), math.random(20, 580)))
  end
end

function love.update(dt)
  readCameraInput()

  for i, entity in ipairs(entities) do
    if i == 1 then
      entity:update(dt, function()
        entity.physics:update(dt)
        
        local direction = readPlayerInput(entity)
        entity.movement:go(dt, direction)
      end)
    else
      entity:update(dt)
    end
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

  profiler:stop()
  local outfile = io.open("profiling/pepperfish_results.out", "w+")
  profiler:report(outfile)
  outfile:close()
end
