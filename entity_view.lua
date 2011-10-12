require('vector.lua')
require('animation.lua')

EntityView = {
  name = "EntityView"
}

function EntityView:new(entity, model)
  local instance = {
    klass = EntityView,
    entity = entity,
    model = model,

    spriteMap = nil,
    spriteBatch = nil,
    animations = {},
    animationTime = 0,
 }
  setmetatable(instance, self)
  -- method_missing should look at self
  self.__index = self

  return instance
end

function EntityView:film(filepath, block)
  self.spriteMap = love.graphics.newImage(filepath)
  -- The spriteBatch holds at most one quad at a time since we're animating
  self.spriteBatch = love.graphics.newSpriteBatch(self.spriteMap, 1)
  block(self)
end

function EntityView:animation(state, width, height, options, block)
  -- TODO it might be better to ahve width and height in options, and just pass that directly into animation
  -- by also merging the reference dimensions as well. Lua doesn't have a table merge, but a:
  -- for k, v in pairs(second_table) do first_table[k] = v end
  local animation = Animation:new()
  animation:setDimension(width, height)
  animation:setReferenceDimension(self.spriteMap:getWidth(), self.spriteMap:getHeight())
  animation:setOffset(options["offset"])
  animation:setPeriod(options["period"])

  block(animation) 
  
  self.animations[state] = animation
end

function EntityView:currentAnimation()
  -- FIXME What to do if the entity's state isn't found in the animations?
  return self.animations[self.model.state]
end

function EntityView:getCenter()
  return self:currentAnimation():getCenter()
end

function EntityView:update(dt)
  self.spriteBatch:clear()
  self:currentAnimation():tickAnimation(dt)
  local scale = self:currentAnimation():getScale()
  local center = self:getCenter()
  self.spriteBatch:addq(self:currentAnimation():getFrame(), 0, 0, 0, scale.x, scale.y, center.x, center.y)
end

-- Entity drawing methods

function EntityView:draw()
  -- transform coordinate system to entity's local coordinate system
  self:transform(function()
    -- TODO use unpack for position and center vectors
    love.graphics.draw(self.spriteBatch, 0, 0, 0, 1, 1)

    for name, child_entity in pairs(self.entity.children) do
        child_entity:draw()
    end

    -- for debugging
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


