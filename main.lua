require('vector.lua')
require('entity.lua')
require('camera.lua')
require('motion.lua')

-- Read player input

function readPlayerInput(entity)
  local direction = V:new(0, 0)

  if love.keyboard.isDown('d') then
    direction.x = 1
    entity.model.state = "walk.right"
  end
  if love.keyboard.isDown('a') then
    direction.x = -1
    entity.model.state = "walk.left"
  end
  if love.keyboard.isDown('s') then
    direction.y = 1
    if string.find(entity.model.state, "right") then
      entity.model.state = "walk.down.right"
    else 
      entity.model.state = "walk.down.left"
    end
  end
  if love.keyboard.isDown('w') then
    direction.y = -1
    if string.find(entity.model.state, "right") then
      entity.model.state = "walk.up.right"
    else
      entity.model.state = "walk.up.left"
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

function createPerson()
  local person = Entity:new("person", V:new(400, 200))
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

  person.model.state = "walk.down.left"
 
  return person
end

function love.load()
  entities = {}

  player = createPerson()
  table.insert(entities, player)
end

function love.update(dt)
  readCameraInput()

  -- TODO make every root entity move in the game
  -- TODO make child entities move in the game relative to root
  player:move(dt, function()
    player.physics:move(dt)
    
    local direction = readPlayerInput(player)
    player.movement:go(dt, direction)

    -- local waypoint = readPlayerWayPoint()
    -- player.movement:goToDestination(waypoint)
  end)

end

function love.draw()
  camera:shoot(function()
    for _, entity in ipairs(entities) do
      entity:draw()
    end
    map:draw()
  end)

  love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 20)
end

