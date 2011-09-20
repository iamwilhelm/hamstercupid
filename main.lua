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
  hamster = Entity:new()
  hamster.view:setImage("resources/hamster_ball.png")
end

function love.update(dt)
  hamster.movement:reset()

  local direction = readPlayerInput()
  hamster.movement:go(direction.x, direction.y)

  local waypoint = readPlayerWayPoint()
  hamster.movement:goToDestination(waypoint.x, waypoint.y)

  hamster:move(dt)
end

function love.draw()
  hamster:draw()
end

