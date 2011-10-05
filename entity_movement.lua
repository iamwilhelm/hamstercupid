require('vector.lua')

EntityMovement = {
  accel_max = 500,
}

EntityMovement.vibrate = function(origin)
  return function(movement, model, dt)
    model.angvel = math.rad(10) -- takes six seconds per revolution
    model.angpos = (model.angpos + model.angvel * dt) % math.rad(360)
    local ypos = 5 * math.sin(model.angpos)
    movement.pos = V:new(0, ypos)
  end
end

EntityMovement.orbit = function()
  return function(movement, model, dt)
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
  self.model:updateByMovement(self.acc, self.vel, self.pos)
  
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


