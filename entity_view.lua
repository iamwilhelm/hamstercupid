
EntityView = {
  model = nil,
  image = nil,
  width = 128,
  height = 128,
}

function EntityView:new(model)
  local instance = {}
  -- the metatable of the new obj is Entity(self)
  setmetatable(instance, self)
  -- method_missing should look at self
  self.__index = self

  instance.model = model

  return instance
end

function EntityView:setImage(filepath)
  self.image = love.graphics.newImage(filepath)
end

function EntityView:draw()
  love.graphics.draw(self.image, self.model.pos.x, self.model.pos.y)
  self:drawDebug()
end

function EntityView:drawDebug()
  love.graphics.print(self.model.pos:toString(), self.model.pos.x, self.model.pos.y)
  love.graphics.print(self.model.vel:toString(), self.model.pos.x, self.model.pos.y - 14)
  love.graphics.print(self.model.acc:toString(), self.model.pos.x, self.model.pos.y - 14 * 2)
end
