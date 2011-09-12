
Entity = {
  x = 300,
  y = 300,
  x_speed = 0,
  y_speed = 0,
  x_accel = 0,
  y_accel = 0,
  accel_max = 500,
  image = nil,
  width = 128,
  height = 128,
}

function Entity:new(newObj)
  newObj = newObj or {}
  -- the metatable of the new obj is Entity(self)
  setmetatable(newObj, self)
  -- method_missing should look at self
  self.__index = self
  return newObj
end

function Entity:setImage(filepath)
  self.image = love.graphics.newImage(filepath)
end

function Entity:accelerate(x_direction, y_direction)
  if (x_direction > 0) then
    self.x_accel = self.accel_max
  elseif (x_direction < 0) then
    self.x_accel = -self.accel_max
  else
    self.x_accel = 0
  end

  if (y_direction > 0) then
    self.y_accel = self.accel_max
  elseif (y_direction < 0) then
    self.y_accel = -self.accel_max
  else
    self.y_accel = 0
  end
end

function Entity:move(dt)
  self.x_speed = self.x_speed + (self.x_accel * dt)
  self.y_speed = self.y_speed + (self.y_accel * dt)
  self.x = self.x + (self.x_speed * dt) 
  self.y = self.y + (self.y_speed * dt)
end

function Entity:draw()
  love.graphics.draw(self.image, self.x, self.y)
  love.graphics.print("(".. self.x ..",".. self.y ..")", self.x, self.y)
  love.graphics.print("(".. self.x_speed ..",".. self.y_speed ..")", self.x, self.y - 14)
  love.graphics.print("(".. self.x_accel ..",".. self.y_accel ..")", self.x, self.y - 14 * 2)
end

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

