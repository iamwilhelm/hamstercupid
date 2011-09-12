require('vector.lua')

Entity = {
  pos = Vector:new(300, 300),
  vel = Vector:new(0, 0),
  acc = Vector:new(0, 0),
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
    self.acc.x = self.accel_max
  elseif (x_direction < 0) then
    self.acc.x = -self.accel_max
  else
    self.acc.x = 0
  end

  if (y_direction > 0) then
    self.acc.y = self.accel_max
  elseif (y_direction < 0) then
    self.acc.y = -self.accel_max
  else
    self.acc.y = 0
  end
end

function Entity:move(dt)
  self.vel = self.vel + (self.acc * dt)
  self.pos = self.pos + (self.vel * dt)
end

function Entity:draw()
  love.graphics.draw(self.image, self.pos.x, self.pos.y)
  self:drawDebug()
end

function Entity:drawDebug()
  love.graphics.print(self.pos:toString(), self.pos.x, self.pos.y)
  love.graphics.print(self.vel:toString(), self.pos.x, self.pos.y - 14)
  love.graphics.print(self.acc:toString(), self.pos.x, self.pos.y - 14 * 2)
end

