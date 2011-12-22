require('object')

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
  Model = require('entity/model'),
  View = require('entity/view'),
  Movement = require('entity/movement'),
  Physics = require('entity/physics'),
  WalkingControls = require('entity/walking_controls'),
}
setmetatable(Entity, Object) -- Entity inherits from Object
Entity.__index = Entity -- method_missing. We put it outside, since it only needs to be set once every instanciation

Entity:include(Metamethodable)


function Entity:new(name, position, scale, rotation)
  local instance = {
    klass = Entity,
    name = name,
  }

  -- Metatable is used to define special operations for the table
  setmetatable(instance, self)

  -- FIXME Should be able to swap out components during initialization
  -- Right now, every component is hardcoded
  instance.model = Entity.Model:new(position, scale, rotation)
  instance.view = Entity.View:new(instance.model)
  instance.movement = Entity.Movement:new(instance.model)
  instance.physics = Entity.Physics:new(instance.model)
  instance.controls = Entity.WalkingControls:new(instance.view, instance.movement)

  instance.parent = nil
  instance.children = {}

  return instance
end

----------------------- Entity children methods ---------------------

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

---------------------- Entity update methods -------------------------

-- Entity control method...could it be in "think"?
function Entity:control(commandname)
  self.controls[commandname](self.controls)

  for _, child_entity in ipairs(self.children) do
    child_entity:control(commandname)
  end
end

function Entity:think(dt)
  -- Allow the entity to make a decision 
  -- self.brain:think(dt)
end

-- Move the positioning of the entity based on its motions and movements
function Entity:move(dt)
  self.movement:move(dt, function(dt)
    self.controls:navigate(dt, not self:hasParent())
    self.movement:motion(dt)
    self.physics:update(dt)
  end)
    
  for _, child_entity in ipairs(self.children) do
    child_entity:move(dt)
  end
end

-- Update the animations and the views of the entity
function Entity:update(dt)
  self.view:update(dt)

  for _, child_entity in ipairs(self.children) do
    child_entity:update(dt)
  end
end

-- Entity view methods (to be separated later)
function Entity:draw()
  -- TODO have to figure out some way draw in z-order of all the children
  self.view:draw(function()
    for name, child_entity in pairs(self.children) do
      child_entity:draw()
    end
    
    if not self:hasParent() then
      -- self:drawDebug()
    end
  end)
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

