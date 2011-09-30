require('vector.lua')

EntityModel = {}

function EntityModel:new(position, scale, rotation)
  local instance = {
    pos = V:new(position.x, position.y), -- need to clone
    vel = V:new(0, 0),
    acc = V:new(0, 0),
    scl = scale or V:new(1, 1),
    rot = rotation or 0,
  }
  setmetatable(instance, self)
  self.__index = self

  return instance
end

-- update velocity and position based on all the movement
function EntityModel:update(dt)
  self.vel = self.vel + (self.acc * dt)
  self.pos = self.pos + (self.vel * dt)
end 



