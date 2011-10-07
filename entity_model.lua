require('vector.lua')

EntityModel = {}

function EntityModel:new(position, scale, rotation)
  -- coordinate system is wrt the parent entity or for the root entity, 
  -- it's the world coordinates
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


