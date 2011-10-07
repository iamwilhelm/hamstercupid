require('vector.lua')

Motion = {}

function Motion:new()
  local instance = {
    pos = V:new(0, 0),
    vel = V:new(0, 0),
    acc = V:new(0, 0),
    angpos = 0,
    angvel = 0,
  }
  setmetatable(instance, self)
  self.__index = self

  return instance
end

function Motion:reset()
  self.pos = V:new(0, 0)
  self.vel = V:new(0, 0)
  self.acc = V:new(0, 0)
  self.angpos = 0
  self.angvel = 0
end

-- create anonymous motions
Motion.createMove = function(locals, block)
  local locals = locals
  return block
end

Motion.wiggle = function(amplitude, secs_per_cycle, phase)
  local angpos = 0
  return function(movement, model, dt)
    local angvel = math.rad(360) / secs_per_cycle
    phase = phase or 0
    local ypos_current = V:new(0, amplitude * math.sin(angpos + phase))
    local ypos_next = V:new(0, amplitude * math.sin(angpos + angvel * dt + phase))
    local dy = ypos_next - ypos_current
    
    movement:addToPosition(dy)
    angpos = (angpos + angvel * dt) % math.rad(360)
  end
end

Motion.jitter = function(amplitude, secs_per_cycle)
  return function(movement, model, dt)
    movement:addToVelocity(V:new(math.random(-5, 5), 0))
  end
end

Motion.orbit = function()
  return function(movement, model, dt)
  end
end

-- methods to move the character from user input
function Motion:go(dt, direction)
  return function(movement, model, dt)
    local acc = V:new(0, 0)
    if (direction.x > 0) then
      acc.x = self.accel_max
    elseif (direction.x < 0) then
      acc.x = -self.accel_max
    else
      acc.x = 0
    end

    if (direction.y > 0) then
      acc.y = self.accel_max
    elseif (direction.y < 0) then
      acc.y = -self.accel_max
    else
      acc.y = 0
    end
  end
end

function Motion:goToDestination(destination)
  local acc = destination - self.model.pos
  self.acc = self.acc + acc
end


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

function EntityMovement:addToAcceleration(acc)
  self.accumulated_acc = self.accumulated_acc + acc
end

function EntityMovement:addToVelocity(vel)
  self.accumulated_vel = self.accumulated_vel + vel
end

function EntityMovement:addToPosition(pos)
  self.accumulated_pos = self.accumulated_pos + pos
end

function EntityMovement:reset()
  self.accumulated_acc = V:new(0, 0)
  self.accumulated_vel = V:new(0, 0)
  self.accumulated_pos = V:new(0, 0)
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

count = 0
-- update velocity and position based on all the movement
function EntityMovement:pushToModel(dt)
  self.model.acc = self.accumulated_acc
  self.model.vel = self.model.vel + self.accumulated_vel + (self.model.acc * dt)
  self.model.pos = self.model.pos + self.accumulated_pos + (self.model.vel * dt)
  print(self.accumulated_pos:toString())
  print(self.model.acc:toString() .. " | " .. self.model.vel:toString() .. " | " .. self.model.pos:toString())
  -- if count == 15 then os.exit() end
  count = count + 1
end 

