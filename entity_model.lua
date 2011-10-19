require('object')
require('vector')

EntityModel = {
  name = "EntityModel"
}
setmetatable(EntityModel, Object)
EntityModel.__index = EntityModel

EntityModel:include(Metamethodable)

function EntityModel:new(position, scale, rotation)
  -- coordinate system is wrt the parent entity or for the root entity, 
  -- it's the world coordinates
  local instance = {
    klass = EntityModel,

    pos = position:clone(),
    vel = V:new(0, 0),
    acc = V:new(0, 0),
    scl = scale or V:new(1, 1),
    rot = rotation or 0,

    state = "stand",
  }
  setmetatable(instance, self)

  return instance
end

-- Metamethods on instance
function EntityModel:__tostring()
  return "<" .. self.klass.name ..
    ": pos=" .. self.pos ..
    ", vel=" .. self.vel ..
    ", acc=" .. self.acc .. ">"
end

function EntityModel:__concat(a)
  if (type(self) == "string" or type(self) == "number") then
    return self .. a:__tostring()
  else
    return self:__tostring() .. a
  end
end

-- a = EntityModel:new(V:new(1,2))
-- print(a)
-- print("a: " .. a)
-- print(a .. " hello")
