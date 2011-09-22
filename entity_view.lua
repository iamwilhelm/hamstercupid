require('vector.lua')

EntityView = {
  identity = "EntityView Class"
}

function EntityView:new(model)
  local instance = {
    model = model,
    image = nil,
    width = nil,
    height = nil,
 }
  -- the metatable of the new obj is Entity(self)
  setmetatable(instance, self)
  -- method_missing should look at self
  self.__index = self

  instance.children = {}

  return instance
end

function EntityView:setImage(filepath)
  self.image = love.graphics.newImage(filepath)
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
end

function EntityView:getCenter()
  return V:new(self.width / 2, self.height / 2)
end

-- Entity children methods
function EntityView:addChild(name, entity)
  self.children[name] = entity
end

function EntityView:draw()
  local position = self.model.pos
  local rotation = self.model.rot
  local center = self:getCenter()

  love.graphics.draw(self.image, 
    position.x, position.y, 
    rotation, 2, 2, 
    center.x, center.y) 

  for name, view_child in pairs(self.children) do
    self:transform(function()
      view_child:draw()
    end)
  end
  -- self:drawDebug()
end

-- private to transform coordinate to draw the child entity
function EntityView:transform(block)
  love.graphics.push()

  love.graphics.rotate(self.model.rot)
  love.graphics.translate(self.model.pos.x, self.model.pos.y)
  block()

  love.graphics.pop()
end

function EntityView:drawDebug()
  love.graphics.print(self.model.pos:toString(), self.model.pos.x, self.model.pos.y)
  love.graphics.print(self.model.vel:toString(), self.model.pos.x, self.model.pos.y - 14)
  love.graphics.print(self.model.acc:toString(), self.model.pos.x, self.model.pos.y - 14 * 2)
end

