require('entity.lua')

-- Read player input

function readPlayerInput()
  x_acc = 0
  y_acc = 0

  if love.keyboard.isDown("right") then
    x_acc = 1
  end
  if love.keyboard.isDown("left") then
    x_acc = -1
  end
  if love.keyboard.isDown("down") then
    y_acc = 1
  end
  if love.keyboard.isDown("up") then
    y_acc = -1
  end

  return x_acc, y_acc
end

-- Callback functions for main loop

function love.load()
  hamster = Entity:new()
  hamster:setImage("resources/hamster_ball.png")
end

function love.update(dt)
  x_acc, y_acc = readPlayerInput()

  hamster:accelerate(x_acc, y_acc)

  hamster:move(dt)
end

function love.draw()
  hamster:draw()
end

