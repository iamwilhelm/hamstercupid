require('vector')

EntityPhysics = {
  name = "EntityPhysics",
}
EntityPhysics.__index = EntityPhysics

function EntityPhysics:new(model)
  local instance = {
    klass = EntityPhysics,

    model = model,
  }
  setmetatable(instance, self)

  return instance
end

function EntityPhysics:friction(dt, coef)
  -- Not true friction, but it's enough to simulate it
  coef = coef or 0.05

  if (not self.model.vel:isMicro(0.1)) then
    self.model.vel = self.model.vel - self.model.vel * coef
  else
    self.model.vel = V:new(0, 0)
  end
end

function EntityPhysics:update(dt)
  self:friction(dt, 0.05)
end

