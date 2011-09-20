require('vector.lua')

EntityMovement = {
  accel_max = 500,
}

function EntityMovement:new(model)
  local instance = {
    model = model,
  }
  setmetatable(instance, self)
  self.__index = self

  instance:reset()

  return instance
end

-- Entity movement control methods
function EntityMovement:move(dt)
  self.model.acc = self.acc
  -- self.vel = self.vel + self.movement.vel
  -- self.pos = self.pos + self.movement.pos
end

function EntityMovement:reset()
  self.pos = V:new(0, 0)
  self.vel = V:new(0, 0)
  self.acc = V:new(0, 0)
end

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


