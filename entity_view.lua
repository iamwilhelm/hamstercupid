require('vector.lua')

EntityView = {
  identity = "EntityView Class"
}

function EntityView:new(entity, model)
  local instance = {
    entity = entity,
    model = model,
    image = nil,
    width = nil,
    height = nil,
 }
  -- the metatable of the new obj is Entity(self)
  setmetatable(instance, self)
  -- method_missing should look at self
  self.__index = self

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

-- Entity drawing methods

function EntityView:draw()
  local center = self:getCenter()

  -- transform coordinate system to entity's local coordinate system
  self:transform(function()
    -- TODO use unpack for position and center vectors
    love.graphics.draw(self.image, 
      0, 0, 0, 1, 1, center.x, center.y) 

    for name, child_entity in pairs(self.entity.children) do
        child_entity:draw()
    end
  end)

  if not self.entity:hasParent() then
    -- self:drawDebug()
  end
end

-- private to transform coordinate to draw the child entity
function EntityView:transform(block)
  love.graphics.push()

  love.graphics.translate(self.model.pos.x, self.model.pos.y)
  love.graphics.rotate(self.model.rot)
  love.graphics.scale(self.model.scl.x, self.model.scl.y)
  block()

  love.graphics.pop()
end

function EntityView:drawDebug()
  love.graphics.print(self.model.pos:toString(), self.model.pos.x, self.model.pos.y)
  love.graphics.print(self.model.vel:toString(), self.model.pos.x, self.model.pos.y - 14)
  love.graphics.print(self.model.acc:toString(), self.model.pos.x, self.model.pos.y - 14 * 2)
end

