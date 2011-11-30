require('object')

require('entity/model')
require('entity/view')
require('entity/physics')
require('entity/movement')


-- Entity represesents some object in the game world. It can use different components to affect 
-- its behaviors and properties. 
--
-- The entity methods are the API and interface to the outside world.
-- As other entities should never reach in and interact with the components of the entity directly. 
-- (Should this be true? Some components are fairly complex...maybe we should use delegates)
--
-- The current components are:
--
--  * model - data representing its properties like position, speed, and acceleration
--  * view - the animations necessary to draw the object
--  * physics - behaviors to implement rudimentary physics
--  * state - behavior related to state and state transitions
--
Entity = {
  name = "Entity",
}
setmetatable(Entity, Object) -- Entity inherits from Object
Entity.__index = Entity

Entity:include(Metamethodable)

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
  -- print("Moving entity: " .. self.name)
  self.movement:update(dt, block)
  self.view:update(dt)
end

-- Entity view methods (to be separated later)
function Entity:draw()
  -- have to figure out some way draw in z-order of all the children
  self.view:draw()
end

-- metamethods

function Entity:__tostring()
  return "<Entity: \n" ..
    "  " .. self.model .. "\n" ..
    "  " .. self.view .. "\n" ..
    "  " .. self.movement .. "\n" ..
    ">"
end

-- local person = Entity:new("person", V:new(100, 100))
-- print(person)

