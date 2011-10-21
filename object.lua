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

  -- Use to generate a function for __tostring() for objects. You would need to set the
  -- attributes to print. It's generally not recommended you include objects that are 
  -- references to parent objects, or else there's going to be a stack overflow.
  --
  --   MyClass.__tostring = MyClass.tostringByAttr({ first_attr=1, second_attr=1 })
  --
  -- Make sure you include Metamethodable:
  --
  --   setmetatable(MyClass, Object)
  --   MyClass:include(Metamethodable)
  --
  tostringByAttr = function(only)
    only = only or {}
    return function(self)
      local str = "<" .. self.klass.name .. " "
      for k, v in pairs(self) do
        if only[k] ~= nil then
          if (type(v) == "table" and v["__concat"] == nil) then
            str = str .. k .. "={" .. type(v) .. "}, "
          elseif k == "__index" or k == "klass" or type(v) == "function" then
            -- do nothing
          else
            str = str .. k .. "=" .. v .. ", "
          end
        end
      end
      return str .. ">"
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
