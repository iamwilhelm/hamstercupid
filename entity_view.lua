require('vector.lua')

EntityView = {
  identity = "EntityView Class"
}

function EntityView:new(entity, model)
  local instance = {
    entity = entity,
    model = model,

    spriteMap = nil,
    spriteBatch = nil,
    width = nil,
    height = nil,
    animations = {},
    animationTime = 0,
    periods = {},
 }
  -- the metatable of the new obj is Entity(self)
  setmetatable(instance, self)
  -- method_missing should look at self
  self.__index = self

  return instance
end

function EntityView:setSpriteMap(filepath, width, height)
  self.spriteMap = love.graphics.newImage(filepath)
  self.width = width
  self.height = height
end

function EntityView:setAnimation(state, spriteMapRow, frames, period)
  self.animations[state] = {}
  for frame = 0, frames - 1 do
    self.animations[state][frame] = love.graphics.newQuad(self.width * frame, self.height * spriteMapRow, 
      self.width, self.height, self.spriteMap:getWidth(), self.spriteMap:getHeight())
  end
  self.periods[state] = period
  self.spriteBatch = love.graphics.newSpriteBatch(self.spriteMap, self.frames)
end

function EntityView:getNumOfFrames(state)
  return table.getn(self.animations[state])
end

function EntityView:getCenter()
  return V:new(self.width / 2, self.height / 2)
end

function EntityView:update(dt)
  self.spriteBatch:clear()
  self.animationTime = (self.animationTime + dt) % self.periods[self.model.state]
  local index = math.floor(self.animationTime / self.periods[self.model.state] * self:getNumOfFrames(self.model.state))
  self.spriteBatch:addq(self.animations[self.model.state][index], 0, 0)
end

-- Entity drawing methods

function EntityView:draw()
  local center = self:getCenter()

  -- transform coordinate system to entity's local coordinate system
  self:transform(function()
    -- TODO use unpack for position and center vectors
    love.graphics.draw(self.spriteBatch, 
      0, 0, 0, 1, 1, center.x, center.y) 

    for name, child_entity in pairs(self.entity.children) do
        child_entity:draw()
    end

    self:drawMotionVectors()

    if not self.entity:hasParent() then
      -- self:drawDebug()
    end
  end)
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

function EntityView:drawMotionVectors()
  local r, g, b, a = love.graphics.getColor()
  love.graphics.setColor(0, 200, 0)
  love.graphics.line(0, 0, self.model.acc.x, self.model.acc.y)
  love.graphics.setColor(200, 0, 0)
  love.graphics.line(0, 0, self.model.vel.x, self.model.vel.y)
  love.graphics.setColor(r, g, b, a)
end


