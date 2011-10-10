require('entity_model.lua')
require('entity_view.lua')
require('entity_physics.lua')
require('entity_movement.lua')

Entity = {
  name = "Entity",
}

function Entity:new(name, position, scale, rotation)
  local instance = {
    klass = Entity,
  }

  -- the metatable of the new obj is Entity(self)
  setmetatable(instance, self)
  -- method_missing should look at self
  self.__index = self

  instance.model = EntityModel:new(position, scale, rotation)
  instance.view = EntityView:new(instance, instance.model)
  instance.movement = EntityMovement:new(instance, instance.model)
  instance.physics = EntityPhysics:new(instance.model)

  instance.parent = nil
  instance.children = {}

  return instance
end

-- Entity children methods
function Entity:hasParent()
  return self.parent ~= nil
end

function Entity:setParent(parent_entity)
  self.parent = parent_entity
end

function Entity:addChild(child_entity)
  child_entity:setParent(self)
  table.insert(self.children, child_entity)
end

-- Entity update methods
function Entity:move(dt, block)
  print("Moving entity: " .. self.name)
  self.movement:update(dt, block)
  self.view:update(dt)
end

-- Entity view methods (to be separated later)
function Entity:draw()
  -- have to figure out some way draw in z-order of all the children
  self.view:draw()
end

