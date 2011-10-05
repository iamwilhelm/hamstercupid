require('vector.lua')

EntityModel = {}

function EntityModel:new(position, scale, rotation)
  -- coordinate system is wrt the parent entity or for the root entity, 
  -- it's the world coordinates
  local instance = {
    pos = V:new(position.x, position.y), -- need to clone
    vel = V:new(0, 0),
    acc = V:new(0, 0),
    scl = scale or V:new(1, 1),
    rot = rotation or 0,
    -- These angular attributes might be temporary
    angpos = 0,
    angvel = 0,
    angacc = 0,
  }
  setmetatable(instance, self)
  self.__index = self

  return instance
end

-- update velocity and position based on all the movement
function EntityModel:update(dt)
  self.vel = self.vel + (self.acc * dt)
  self.pos = self.pos + (self.vel * dt)
end 

 -- FIXME Possible bug where velocity accumulates over time, but I think 
 -- that it's fixed as long as movement functions don't suck
function EntityModel:updateByMovement(pos, vel, acc)
  self.acc = acc
  self.vel = self.vel + vel
  self.pos = self.pos + pos
end

