
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
  setmetatable(newObj, self)
  self.__index = self
  return newObj
end

function Entity:setImage(filepath)
  self.image = love.graphics.newImage(filepath)
end

function Entity:gas(x_direction, y_direction)
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

function Entity:accelerate_y(direction)
  self.y_accel = (direction > 0) and self.accel_max or -self.accel_max
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

function love.load()
  hamster = Entity:new()
  hamster:setImage("resources/hamster_ball.png")
end

function love.update(dt)
  if love.keyboard.isDown("right") then
    hamster:gas(1, 0)
  elseif love.keyboard.isDown("left") then
    hamster:gas(-1, 0)
  elseif love.keyboard.isDown("down") then
    hamster:gas(0, 1)
  elseif love.keyboard.isDown("up") then
    hamster:gas(0, -1)
  else
    hamster:gas(0, 0)
  end

  hamster:move(dt)
end

function love.draw()
  hamster:draw()
end

