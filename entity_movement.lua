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
  self.pos = Vector:new(0, 0)
  self.vel = Vector:new(0, 0)
  self.acc = Vector:new(0, 0)
end

function EntityMovement:go(x_direction, y_direction)
  local acc = Vector:new(0, 0)
  if (x_direction > 0) then
    acc.x = self.accel_max
  elseif (x_direction < 0) then
    acc.x = -self.accel_max
  else
    acc.x = 0
  end

  if (y_direction > 0) then
    acc.y = self.accel_max
  elseif (y_direction < 0) then
    acc.y = -self.accel_max
  else
    acc.y = 0
  end

  self.acc = self.acc + acc
end

function EntityMovement:goToDestination(destX, destY)
  local acc = Vector:new(destX, destY) - self.model.pos

  self.acc = self.acc + acc
end


