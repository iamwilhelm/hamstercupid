require('object')

--  A custom vector class

-- FIXME The creation of new vectors when doing arithmetic operations on it gets to
-- be really expensive, especially when it's used in the update loop
Vector = {
  name = "Vector",
}
setmetatable(Vector, Object)
Vector.__index = Vector
V = Vector

Vector:include(Metamethodable)

function Vector:new(newX, newY)
  local instance = {
    klass = Vector,
    x = newX or 0,
    y = newY or 0,
  }
  setmetatable(instance, self)

  return instance
end

function Vector:isNearby(threshold, a)
  if a == self then
     return false 
  end
  return self:distance(a) < threshold
end

function Vector:distance(a)
  return math.sqrt((self.x - a.x)^2 + (self.y - a.y)^2)
end

function Vector:accum(b)
  self.x = self.x + b.x
  self.y = self.y + b.y
  return self
end

function Vector:__add(a)
  return Vector:new(self.x + a.x, self.y + a.y)
end

function Vector:__sub(a)
  return Vector:new(self.x - a.x, self.y - a.y)
end

function Vector:__mul(num)
  return Vector:new(self.x * num, self.y * num)
end

function Vector:__div(num)
  if (num ~= 0) then
     return Vector:new(self.x / num, self.y / num)
  else
     return self
  end
end

function Vector:__unm()
  return Vector:new(-self.x, -self.y)
end

function Vector:clone()
  return Vector:new(self.x, self.y)
end

-- When a vector is within some delta-epsilon, zero it out to remove jittering
function Vector:isMicro(delta)
  return (math.abs(self.x) < delta) and (math.abs(self.y) < delta)
end

function Vector:dot(a)
  return self.x * a.x + self.y * a.y
end

function Vector:r()
  return math.sqrt(self:dot(self))
end

function Vector:norm()
  return Vector:new(self.x, self.y) / self:r()
end

function Vector:ang()
  return math.atan(self.y / self.x)
end

function Vector:__tostring()
  return "(" .. self.x .. ", " .. self.y .. ")"
end

-- a = Vector:new(2,2)
-- 
-- print("this vector is: " .. a)
-- b = Vector:new(5,6)
-- c = a + b
-- print("c: " .. c)
-- print(c .. " hello")
-- 
-- print(a:distance(b))
-- print(a:is_nearby(10, a))
-- print(a:is_nearby(10, b))
-- print(a:is_nearby(3, b))
-- print((a+b):to_s())
-- print((b-a):to_s())
-- print((a*3):to_s())
-- print((a/3):to_s())
-- print((-a):to_s())
-- print(a:dot(b))
-- print(a:r())

