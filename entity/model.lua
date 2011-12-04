require('object')
require('vector')

local Model = {
  name = "Model"
}
setmetatable(Model, Object)
Model.__index = Model

Model:include(Metamethodable)

function Model:new(position, scale, rotation)
  -- coordinate system is wrt the parent entity or for the root entity, 
  -- it's the world coordinates
  local instance = {
    klass = Model,

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
Model.__tostring = Model.tostringByAttr({ pos=1, vel=1, acc=1, scl=1, rot=1 })
  
return Model

-- a = EntityModel:new(V:new(1,2))
-- print(a)
-- print("prefix: " .. a)
-- print(a .. " :postfix")
