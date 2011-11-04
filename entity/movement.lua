require('object')
require('vector')
require('entity/motion')

--  magician = Entity:new("magician", V:new(200, 200)
--
--  helmet = Entity:new("helmet", V:new(-2, -24))
--  magician:addChild(helmet)
--
--  weapon = Entity:new("weapon", V:new(-24, 0), nil, math.rad(-10))
--  weapon.movement:addMovement(Motion.wiggle(30, 1))
--  magician:addChild(weapon)
--
--  shield = Entity:new("shield", V:new(15, 10), V:new(0.75, 1), math.rad(0))
--  magician:addChild(shield)
--
--  cow = Entity:new("cow", V:new(50, 0), V:new(4 / 3, 1), math.rad(0))
--  cow.movement:addMovement(Motion.wiggle(50, 1))
--  cow.movement:addMovement(Motion.waggle(50, 1, math.rad(90)))
--  shield:addChild(cow)
EntityMovement = {
  name = "EntityMovement",
}
setmetatable(EntityMovement, Object)
EntityMovement.__index = EntityMovement

EntityMovement:include(Metamethodable)

function EntityMovement:new(entity, model)
  -- The coordinate system for movement is with respect to the entity, 
  -- unlike in the model, the coordinate system is with respect to the parent entity
  local instance = {
    klass = EntityMovement,
    entity = entity,
    model = model,

    accumulated_acc = V:new(0, 0),
    accumulated_vel = V:new(0, 0),
    accumulated_pos = V:new(0, 0),

    motions = {},
  }
  setmetatable(instance, self)

  return instance
end

function EntityMovement:go(dt, direction)
  local acc = V:new(0, 0)
  if (direction.x > 0) then
    self:addToAcceleration(V:new(Motion.accel_max, 0))
  elseif (direction.x < 0) then
    self:addToAcceleration(V:new(-Motion.accel_max, 0))
  else
    -- acc.x = 0
  end

  if (direction.y > 0) then
    self:addToAcceleration(V:new(0, Motion.accel_max))
  elseif (direction.y < 0) then
    self:addToAcceleration(V:new(0, -Motion.accel_max))
  else
    -- acc.y = 0
  end
end



-- Entity movement control methods
function EntityMovement:addMovement(block)
  table.insert(self.motions, block)
end

-- Add the differential acceleration to accumulated acceleration 
function EntityMovement:addToAcceleration(acc)
  self.accumulated_acc = self.accumulated_acc + acc
end

-- Add the differential velocity to accumulated velocity
function EntityMovement:addToVelocity(vel)
  self.accumulated_vel = self.accumulated_vel + vel
end

-- Add the differential position to accumultated position
function EntityMovement:addToPosition(pos)
  self.accumulated_pos = self.accumulated_pos + pos
end

-- Provides the core engine for updating an entity's motions
function EntityMovement:update(dt, block)
  -- reset the accumulated motions since last tick
  self:_reset()

  -- allow motions from every tick, such as player controls
  if block ~= nil then
    block(dt)
  end

  -- do all the pre-declared motions for this entity
  for _, motion in ipairs(self.motions) do
    motion(self, self.model, dt)
  end

  -- push the updates to the model
  self:_pushToModel(dt)
  
  -- repeat for all child entities
  for _, child_entity in ipairs(self.entity.children) do
    child_entity:update(dt)
  end
end

-- private methods

function EntityMovement:_reset()
  self.accumulated_acc.x = 0
  self.accumulated_acc.y = 0
  self.accumulated_vel.x = 0
  self.accumulated_vel.y = 0
  self.accumulated_pos.x = 0
  self.accumulated_pos.y = 0
end

-- update velocity and position based on all the movement
function EntityMovement:_pushToModel(dt)
  self.model.acc = self.accumulated_acc
  self.model.vel = self.model.vel + self.accumulated_vel + (self.model.acc * dt)
  self.model.pos = self.model.pos + self.accumulated_pos + (self.model.vel * dt)
end 

-- Metamethods
EntityMovement.__tostring = EntityMovement.tostringByAttr({ accumulated_pos=1, accumulated_vel=1, accumulated_acc=1, motions=1 })

-- movement = EntityMovement:new()
-- print(movement)
-- print("prefix: " .. movement)
-- print(movement .. ": postfix")