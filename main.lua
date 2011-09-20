require('entity.lua')

-- Read player input

function readPlayerInput()
  local direction = Vector:new(0, 0)

  if love.keyboard.isDown("right") then
    direction.x = 1
  end
  if love.keyboard.isDown("left") then
    direction.x = -1
  end
  if love.keyboard.isDown("down") then
    direction.y = 1
  end
  if love.keyboard.isDown("up") then
    direction.y = -1
  end

  return direction
end

function readPlayerWayPoint()
  return V:new(love.mouse.getX(), love.mouse.getY())
end

-- Callback functions for main loop

function love.load()
  ball = Entity:new()
  ball.view:setImage("resources/ball.png")

  player = Entity:new()
  player.view:setImage("resources/player.png")
end

function love.update(dt)
  player.movement:reset()

  local direction = readPlayerInput()
  player.movement:go(direction)

  local waypoint = readPlayerWayPoint()
  player.movement:goToDestination(waypoint)

  player:move(dt)
  ball:move(dt)
end

function love.draw()
  player:draw()
  ball:draw()
end

