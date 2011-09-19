require('vector.lua')
require('entity_view.lua')
require('entity_physics.lua')

Entity = {
  accel_max = 500,
  instance = nil,
}

function Entity:new()
  local instance = {
    pos = Vector:new(300, 300),
    vel = Vector:new(0, 0),
    acc = Vector:new(0, 0),
 }

  -- the metatable of the new obj is Entity(self)
  setmetatable(instance, self)
  -- method_missing should look at self
  self.__index = self

  instance.view = EntityView:new(instance)
  instance.physics = EntityPhysics:new(instance)

  return instance
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
function Entity:update(dt)
  self.vel = self.vel + (self.acc * dt)
  self.pos = self.pos + (self.vel * dt)
end

function Entity:move(dt)
  self:update(dt)
  self.physics:update(dt)
end

-- Entity view methods (to be separated later)
function Entity:draw()
  self.view:draw()
end

