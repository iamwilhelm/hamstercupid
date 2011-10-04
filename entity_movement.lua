require('vector.lua')

EntityMovement = {
  accel_max = 500,
}

function EntityMovement.vibrate(origin)
  return function(self, movement, model, dt)
    local vel = origin - self.model.pos 
    self.vel = self.vel + vel
  end
end

-- FIXME not yet working correctly
function EntityMovement.orbit()
  return function(self, movement, model, dt)
    local axis_of_rotation = math.rad(0.5) / dt
    local radius = model.pos
    print("dt: " .. dt)
    print("axis: " .. axis_of_rotation)
    print("rad: " .. radius:toString())
    local tangential = V:new(-axis_of_rotation * radius.y, axis_of_rotation * radius.x) 
    local centripetal = radius:norm() * -tangential:r() 
    print("tang: " .. tangential:toString())
    print("cent: " .. centripetal:toString())
    print("dot: " .. tangential:dot(centripetal))

    movement.acc = movement.acc + tangential
    movement.acc = movement.acc + centripetal
  end
end

function EntityMovement:new(entity, model)
  -- The coordinate system for movement is with respect to the entity, 
  -- unlike in the model, the coordinate system is with respect to the parent entity
  local instance = {
    entity = entity,
    model = model,
    pos = V:new(0, 0),
    vel = V:new(0, 0),
    acc = V:new(0, 0),
    movements = {},
  }
  setmetatable(instance, self)
  self.__index = self

  instance:reset()

  return instance
end

function EntityMovement:toString()
  return "EntityMovement: " .. self.acc:toString() .. ", " ..
    self.vel:toString() .. ", " ..
    self.pos:toString()
end

function EntityMovement:addMovement(block)
  table.insert(self.movements, block)
end

-- Entity movement control methods

-- Provides the core engine for updating an entity's movements
function EntityMovement:update(dt, block)
  -- reset the accumulated movements since last tick
  self:reset()

  -- allow movements from every tick, such as player controls
  if block ~= nil then
    block(dt)
  end

  -- do all the pre-declared movements for this entity
  for _, movement in ipairs(self.movements) do
    movement(self, self.model, dt)
  end

  -- push the updates to the model
  self.model.acc = self.acc
  self.model.vel = self.model.vel + self.vel -- FIXME These two don't work as velocity changes accumulate over time
  self.model.pos = self.model.pos + self.pos

  -- repeat for all child entities
  for _, child_entity in ipairs(self.entity.children) do
    child_entity:move(dt)
  end
end

function EntityMovement:reset()
  self.pos = V:new(0, 0)
  self.vel = V:new(0, 0)
  self.acc = V:new(0, 0)
end

-- methods to move the character from user input
function EntityMovement:go(direction)
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

  self.acc = self.acc + acc
end

function EntityMovement:goToDestination(destination)
  local acc = destination - self.model.pos

  self.acc = self.acc + acc
end


