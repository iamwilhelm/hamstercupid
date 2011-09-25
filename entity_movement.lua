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
  print("in entitymomvement:move")
  print(self.acc.x .. "," .. self.acc.y)
  print(self.vel.x .. "," .. self.vel.y)
  print(self.pos.x .. "," .. self.pos.y)
  print("\n")

  self.model.acc = self.acc
  self.model.vel = self.model.vel + (self.model.acc * dt)
  self.model.pos = self.model.pos + (self.model.vel * dt)

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

function EntityMovement:vibrate(dt)
  local acc = V:new(0, 0)
  self.acc = self.acc + acc
end

