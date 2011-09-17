require('vector.lua')
require('entity_view.lua')

Entity = {
  pos = Vector:new(300, 300),
  vel = Vector:new(0, 0),
  acc = Vector:new(0, 0),
  accel_max = 500,
  instance = nil,
}

function Entity:new()
  local instance = {}
  -- the metatable of the new obj is Entity(self)
  setmetatable(instance, self)
  -- method_missing should look at self
  self.__index = self

  instance.view = EntityView:new(instance)

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
function Entity:move(dt)
  self.vel = self.vel + (self.acc * dt)
  self.pos = self.pos + (self.vel * dt)
end

-- NOTE: technically, the physics shouldn't belong here in entity.
-- We should probably be able to pass in physics based on the state of the entity
-- or based on its interaction with the world.
function Entity:friction(dt, coef)
  -- Not true friction, but it's enough to simulate it
  coef = coef or 0.05

  if (not self.vel:isMicro(0.1)) then
    self.vel = self.vel - self.vel * coef
  else
    self.vel = Vector:new(0, 0)
  end
end

-- Entity view methods (to be separated later)
function Entity:draw()
  self.view:draw()
end

