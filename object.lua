-- Experimental and object class. Remember that love also has an object class

-- Mixin to merge tables into other tables
Mixin = {
  include = function(a, b)
    for k, v in pairs(b) do a[k] = v end
  end,
}

Objectable = {
  __concat = function(self, a)
    if (type(self) == "string" or type(self) == "number") then
      return self .. a:__tostring()
    else
      return self:__tostring() .. a
    end
  end,
}

-- This is the base object class
Object = {
  name = "Object"
}
-- setmetatable(Object, Object)
Object.__index = Object

function Object:new()
  local instance = {
    klass = Object,
  }
  setmetatable(instance, self)

  return instance
end

function Object:__tostring()
  if self.name ~= nil then
    return "<<" .. self.name .. ">>"
  else
    return "<Object>"
  end
end

function Object:foo()
  print("foo!")
end

-- table.foreach(Object, print)
-- obj = Object:new()
-- print(obj)
