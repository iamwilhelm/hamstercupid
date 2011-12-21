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
local Movement = {
  name = "Entity.Movement",
}
setmetatable(Movement, Object)
Movement.__index = Movement

Movement:include(Metamethodable)

function Movement:new(model)
  -- The coordinate system for movement is with respect to the entity, 
  -- unlike in the model, the coordinate system is with respect to the parent entity
  local instance = {
    klass = Movement,
    model = model,

    accumulated_acc = V:new(0, 0),
    accumulated_vel = V:new(0, 0),
    accumulated_pos = V:new(0, 0),

    motions = {},
  }
  setmetatable(instance, self)

  return instance
end

function Movement:go(dt, direction)
  if (direction.x > 0) then
    self:addToAcceleration(V:new(Motion.accel_max, 0))
    print(self)
  elseif (direction.x < 0) then
    self:addToAcceleration(V:new(-Motion.accel_max, 0))
  end

  if (direction.y > 0) then
    self:addToAcceleration(V:new(0, Motion.accel_max))
  elseif (direction.y < 0) then
    self:addToAcceleration(V:new(0, -Motion.accel_max))
  end
end

-- Entity movement initialization methods
function Movement:addMovement(block)
  table.insert(self.motions, block)
end

-- NOTE: We have the addTo* functions because Motions make use of them and 
-- we need a public interface
--
-- Add the differential acceleration to accumulated acceleration 
function Movement:addToAcceleration(acc)
  self.accumulated_acc:accum(acc)
end

-- Add the differential velocity to accumulated velocity
function Movement:addToVelocity(vel)
  self.accumulated_vel:accum(vel)
end

-- Add the differential position to accumultated position
function Movement:addToPosition(pos)
  self.accumulated_pos:accum(pos)
end

-- Provides the core engine for updating an entity's motions
function Movement:move(dt)
  -- reset the accumulated motions since last tick
  self:_reset()

  -- do all the pre-declared motions for this entity
  for _, motion in ipairs(self.motions) do
    motion(self, self.model, dt)
  end

  -- push the updates to the model
  self:_pushToModel(dt)
end

-- private methods

function Movement:_reset()
  self.accumulated_acc.x = 0
  self.accumulated_acc.y = 0
  self.accumulated_vel.x = 0
  self.accumulated_vel.y = 0
  self.accumulated_pos.x = 0
  self.accumulated_pos.y = 0
end

-- update velocity and position based on all the movement
function Movement:_pushToModel(dt)
  self.model.acc = self.accumulated_acc
  self.model.vel:accum(self.accumulated_vel):accum(self.model.acc * dt)
  self.model.pos:accum(self.accumulated_pos):accum(self.model.vel * dt)
end 

-- Metamethods
Movement.__tostring = Movement.tostringByAttr({ accumulated_pos=1, accumulated_vel=1, accumulated_acc=1, motions=1 })

return Movement

-- movement = Movement:new()
-- print(movement)
-- print("prefix: " .. movement)
-- print(movement .. ": postfix")
