require('entity.lua')
require('camera.lua')

-- Read player input

function readPlayerInput()
  local direction = Vector:new(0, 0)

  if love.keyboard.isDown('d') then
    direction.x = 1
  end
  if love.keyboard.isDown('a') then
    direction.x = -1
  end
  if love.keyboard.isDown('s') then
    direction.y = 1
  end
  if love.keyboard.isDown('w') then
    direction.y = -1
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
  if love.keyboard.isDown('[') then
    camera:zoom(1.05)
  end
  if love.keyboard.isDown(']') then
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

function love.load()
  -- cow = Entity:new(325, 325)
  -- cow.view:setImage("resources/cow.png")

  player = Entity:new(400, 200, 2, math.rad(0))
  player.view:setImage("resources/player.png")

  ball = Entity:new(10, 15)
  ball.view:setImage("resources/ball.png")
  player:addChild("ball", ball)

  dog = Entity:new(40, 0, 1, math.rad(10))
  dog.view:setImage("resources/dog.png")
  ball:addChild("dog", dog)
end

function love.update(dt)
  player.movement:reset()

  readCameraInput()

  local direction = readPlayerInput()
  player.movement:go(direction)

  local waypoint = readPlayerWayPoint()
  player.movement:goToDestination(waypoint)

  player:move(dt)
  -- cow:move(dt)
end

function love.draw()
  camera:shoot(function()
    player:draw()
    -- cow:draw()

    map:draw()
  end)
end

