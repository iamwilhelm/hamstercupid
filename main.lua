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

  local direction = readPlayerInput()
  player.movement:go(direction)

  local waypoint = readPlayerWayPoint()
  player.movement:goToDestination(waypoint)

  player:move(dt)
  -- cow:move(dt)
end

function love.draw()
  player:draw()
  -- cow:draw()
end

