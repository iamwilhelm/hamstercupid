require('entity_model.lua')
require('entity_view.lua')
require('entity_physics.lua')
require('entity_movement.lua')

Entity = {
}

function Entity:new(position, scale, rotation)
  local instance = {}

  -- the metatable of the new obj is Entity(self)
  setmetatable(instance, self)
  -- method_missing should look at self
  self.__index = self

  instance.model = EntityModel:new(position, scale, rotation)
  instance.view = EntityView:new(instance.model)
  instance.physics = EntityPhysics:new(instance.model)
  instance.movement = EntityMovement:new(instance.model)
  instance.children = {}

  return instance
end

-- Entity children methods
function Entity:addChild(name, entity_part)
  self.children[name] = entity_part
  self.view:addChild(name, entity_part.view)
end

-- Entity update methods
function Entity:move(dt)
  self.movement:move(dt)
  self.physics:move(dt)

  self.model:move(dt)
end

-- Entity view methods (to be separated later)
function Entity:draw()
  -- have to figure out some way draw in z-order of all the children
  self.view:draw()
end

