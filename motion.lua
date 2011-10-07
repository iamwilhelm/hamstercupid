require('vector.lua')

Motion = {}

-- create anonymous motions
Motion.createMove = function(locals, block)
  local locals = locals
  return block
end

Motion._cycle = function(amplitude, period, phase, block)
  local angpos = 0
  return function(movement, model, dt)
    local angvel = math.rad(360) / period
    phase = phase or 0
    block(movement, dt, angpos + phase, angpos + angvel * dt + phase) 
    angpos = (angpos + angvel * dt) % math.rad(360)
  end
end

-- wiggle the entity vertically
Motion.wiggle = function(amplitude, period, phase)
  return Motion._cycle(amplitude, period, phase, 
    function(movement, dt, angpos_current, angpos_next)
      local currentPos = V:new(0, amplitude * math.sin(angpos_current))
      local nextPos = V:new(0, amplitude * math.sin(angpos_next))
      movement:addToPosition(nextPos - currentPos)
    end)
end

-- waggle the entity horizontally
Motion.waggle = function(amplitude, period, phase)
  return Motion._cycle(amplitude, period, phase,
    function(movement, dt, angpos_current, angpos_next)
      local currentPos = V:new(amplitude * math.cos(angpos_current), 0)
      local nextPos = V:new(amplitude * math.cos(angpos_next), 0)
      movement:addToPosition(nextPos - currentPos)
    end)
end

Motion.jitter = function(amplitude, secs_per_cycle)
  return function(movement, model, dt)
    movement:addToVelocity(V:new(math.random(-5, 5), 0))
  end
end

Motion.orbit = function(amplitude, secs_per_cycle, phase)
  local angpos = 0
  return function(movement, model, dt)
    local angvel = math.rad(360) / secs_per_cycle
    phase = phase or 0
    local pos_currrent = V:new(amplitude * math.cos(angpos + phase))
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


