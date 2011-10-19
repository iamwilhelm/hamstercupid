-- Experimental and object class. Remember that love also has an object class
-- And that MiddleClass exists as well.
-- https://github.com/kikito/middleclass  

-- Mixin for common metamethods
Metamethodable = {
  __tostring = function(self)
    if self.name ~= nil then
      return "<<" .. self.name .. ">>"
    else
      return "<Object>"
    end
  end,

  __concat = function(self, a)
    if (type(self) == "string" or type(self) == "number") then
      return self .. a:__tostring()
    else
      return self:__tostring() .. a
    end
  end,
}

-- The base object class.
Object = {
  name = "Object"
}
Object.__index = Object

function Object:new()
  local instance = {
    klass = Object,
  }
  setmetatable(instance, self)

  return instance
end

function Object:include(mod)
  for k, v in pairs(mod) do self[k] = v end
end

Object:include(Metamethodable)

-- table.foreach(Object, print)
-- obj = Object:new()
-- print(obj)
