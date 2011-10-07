require('vector.lua')

EntityMovement = {
  accel_max = 500,
}

function EntityMovement:new(entity, model)
  -- The coordinate system for movement is with respect to the entity, 
  -- unlike in the model, the coordinate system is with respect to the parent entity
  local instance = {
    entity = entity,
    model = model,
    accumulated_acc = V:new(0, 0),
    accumulated_vel = V:new(0, 0),
    accumulated_pos = V:new(0, 0),
    motions = {},
  }
  setmetatable(instance, self)
  self.__index = self

  return instance
end

function EntityMovement:toString()
  return "EntityMovement: " .. 
    self.acc:toString() .. ", " ..
    self.vel:toString() .. ", " ..
    self.pos:toString()
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
  self:reset()

  -- allow motions from every tick, such as player controls
  if block ~= nil then
    block(dt)
  end

  -- do all the pre-declared motions for this entity
  for _, motion in ipairs(self.motions) do
    motion(self, self.model, dt)
  end

  -- push the updates to the model
  self:pushToModel(dt)
  
  -- repeat for all child entities
  for _, child_entity in ipairs(self.entity.children) do
    child_entity:move(dt)
  end
end

function EntityMovement:reset()
  self.accumulated_acc = V:new(0, 0)
  self.accumulated_vel = V:new(0, 0)
  self.accumulated_pos = V:new(0, 0)
end

-- update velocity and position based on all the movement
function EntityMovement:pushToModel(dt)
  self.model.acc = self.accumulated_acc
  self.model.vel = self.model.vel + self.accumulated_vel + (self.model.acc * dt)
  self.model.pos = self.model.pos + self.accumulated_pos + (self.model.vel * dt)
end 

