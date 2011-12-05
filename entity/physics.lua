require('object')
require('vector')

local Physics = {
  name = "Entity.Physics",
}
setmetatable(Physics, Object)
Physics.__index = Physics

Physics:include(Metamethodable)

function Physics:new(model)
  local instance = {
    klass = Physics,

    model = model,
  }
  setmetatable(instance, self)

  return instance
end

function Physics:friction(dt, coef)
  -- Not true friction, but it's enough to simulate it
  coef = coef or 0.05

  if (not self.model.vel:isMicro(0.1)) then
    self.model.vel = self.model.vel - self.model.vel * coef
  else
    self.model.vel = V:new(0, 0)
  end
end

function Physics:update(dt)
  self:friction(dt, 0.05)
end

-- metamethods

Physics.__tostring = Physics.tostringByAttr({})

return Physics

