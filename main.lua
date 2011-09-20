require('entity.lua')

-- Read player input

function readPlayerInput()
  dir_x = 0
  dir_y = 0

  if love.keyboard.isDown("right") then
    dir_x = 1
  end
  if love.keyboard.isDown("left") then
    dir_x = -1
  end
  if love.keyboard.isDown("down") then
    dir_y = 1
  end
  if love.keyboard.isDown("up") then
    dir_y = -1
  end

  return Vector:new(dir_x, dir_y)
end

function readPlayerWayPoint()
  return Vector:new(love.mouse.getX(), love.mouse.getY())
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
  player.movement:go(direction.x, direction.y)

  local waypoint = readPlayerWayPoint()
  player.movement:goToDestination(waypoint.x, waypoint.y)

  player:move(dt)
  ball:move(dt)
end

function love.draw()
  player:draw()
  ball:draw()
end

