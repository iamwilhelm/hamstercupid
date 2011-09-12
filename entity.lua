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

-- Entity control methods
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

-- Entity update methods
function Entity:move(dt)
  self.vel = self.vel + (self.acc * dt)
  self.pos = self.pos + (self.vel * dt)
end

-- NOTE: technically, the physics shouldn't belong here in entity.
-- We should probably be able to pass in physics based on the state of the entity
-- or based on its interaction with the world.
function Entity:friction(dt)
  -- Not true friction, but it's enough to simulate it
  if (not self.vel:isMicro(0.1)) then
    self.vel = self.vel - self.vel * 0.05
  else
    self.vel = Vector:new(0, 0)
  end
end

-- Entity view methods (to be separated later)
function Entity:setImage(filepath)
  self.image = love.graphics.newImage(filepath)
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

