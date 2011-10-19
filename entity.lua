require('object')
require('entity_model')
require('entity_view')
require('entity_physics')
require('entity_movement')

Entity = {
  name = "Entity",
}
setmetatable(Entity, Object)
Entity.__index = Entity

-- FIXME somehow this one doesn't work
-- Entity:include(MetaMethodable)

function Entity:new(name, position, scale, rotation)
  local instance = {
    klass = Entity,
    name = name,
  }

  -- the metatable of the new obj is Entity(self)
  setmetatable(instance, self)

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
function Entity:update(dt, block)
  print("Moving entity: " .. self.name)
  self.movement:update(dt, block)
  self.view:update(dt)
end

-- Entity view methods (to be separated later)
function Entity:draw()
  -- have to figure out some way draw in z-order of all the children
  self.view:draw()
end

