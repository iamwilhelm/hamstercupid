
Object = {
  name = "Object"
}
setmetatable(Object, Object)
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

function Object:__concat(a)
  if (type(self) == "string" or type(self) == "number") then
    return self .. a:__tostring()
  else
    return self:__tostring() .. a
  end
end

function Object:foo()
  print("foo!")
end

-- table.foreach(Object, print)
-- obj = Object:new()
-- print(obj)
