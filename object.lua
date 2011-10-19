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

  -- is a replacement for the default tostring() that displays all non-function
  -- attributes in the object. In order to use it, simply replace the default tostring() using:
  --
  --   setmetatable(MyClass, Object)
  --   MyClass:include(Metamethodable)
  --
  --   MyClass.__tostring = MyClass.__toattrstring
  --
  -- NOTE: make sure that you setup the table correctly in order to include the Metamethodable module
  --       so that you have the default __tostring() and __toattrstring() in your class
  __toattrstring = function(self)
    local str = "<" .. self.klass.name .. " "
    for k, v in pairs(self) do
      if (type(v) == "table" and v["__concat"] == nil) then
        str = str .. k .. "={" .. type(v) .. "}, "
      elseif k == "__index" or k == "klass" or type(v) == "function" then
        -- do nothing
      else
        str = str .. k .. "=" .. v .. ", "
      end
    end
    return str .. ">"
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
