require('vector.lua')
require('entity_view.lua')
require('entity_physics.lua')
require('entity_movement.lua')

Entity = {
}

function Entity:new()
  local instance = {
    pos = V:new(300, 300),
    vel = V:new(0, 0),
    acc = V:new(0, 0),
 }

  -- the metatable of the new obj is Entity(self)
  setmetatable(instance, self)
  -- method_missing should look at self
  self.__index = self

  instance.view = EntityView:new(instance)
  instance.physics = EntityPhysics:new(instance)
  instance.movement = EntityMovement:new(instance)

  return instance
end

-- Entity update methods
function Entity:move(dt)
  self.movement:move(dt)
  self.physics:move(dt)

  -- update velocity and position based on all the movement
  self.vel = self.vel + (self.acc * dt)
  self.pos = self.pos + (self.vel * dt)
end

-- Entity view methods (to be separated later)
function Entity:draw()
  self.view:draw()
end

