require('object')
require('vector')
require('entity/animation')

local View = {
  name = "Entity.View"
}
setmetatable(View, Object)
View.__index = View

View:include(Metamethodable)

function View:new(entity, model)
  local instance = {
    klass = View,
    entity = entity,
    model = model,

    spriteMap = nil,
    spriteBatch = nil,
    animations = {},
    animationTime = 0,
  }
  setmetatable(instance, self)

  return instance
end

-- The mini DSL to define the animations

function View:film(filepath, block)
  self.spriteMap = love.graphics.newImage(filepath)
  -- The spriteBatch holds at most one quad at a time since we're animating
  self.spriteBatch = love.graphics.newSpriteBatch(self.spriteMap, 1)
  block(self)
end

function View:animation(state, width, height, options, block)
  -- TODO it might be better to have width and height in options, and just pass that directly into animation
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

-- helper functions

function View:currentAnimation()
  local animation = self.animations[self.model.state]
  if animation == nil then
    error("Animation for state: " .. self.model.state .. " was not found")
  else
    return animation 
  end
end

function View:getCenter()
  return self:currentAnimation():getCenter()
end

-- Error: ./entity_view.lua:65: Incorrect parameter type: expected userdata.
-- stack traceback:
-- 	[C]: in function 'addq'
-- 	./entity_view.lua:65: in function 'update'
-- 	./entity.lua:53: in function 'update'
-- 	./entity_movement.lua:108: in function 'update'
-- 	./entity.lua:52: in function 'update'
-- 	[string "main.lua"]:205: in function 'update'
-- 	[string "boot.lua"]:1: in function <[string "boot.lua"]:1>
-- 	[C]: in function 'xpcall'
-- 
function View:update(dt)
  self.spriteBatch:clear()
  self:currentAnimation():tickAnimation(dt)
  local scale = self:currentAnimation():getScale()
  local center = self:getCenter()
  -- FIXME It seems that sometimes, currentAnimation is selected that doesn't have any frames at all?
  self.spriteBatch:addq(self:currentAnimation():getFrame(), 0, 0, 0, scale.x, scale.y, center.x, center.y)
end

-- Entity drawing methods

function View:draw()
  -- transform coordinate system to entity's local coordinate system

  -- self:transform(function()
  love.graphics.push()

  love.graphics.translate(self.model.pos.x, self.model.pos.y)
  love.graphics.rotate(self.model.rot)
  love.graphics.scale(self.model.scl.x, self.model.scl.y)

    -- TODO use unpack for position and center vectors
    love.graphics.draw(self.spriteBatch, 0, 0, 0, 1, 1)

    for name, child_entity in pairs(self.entity.children) do
      child_entity:draw()
    end

    -- for debugging
    -- self:drawMotionVectors()

    if not self.entity:hasParent() then
      -- self:drawDebug()
    end

  love.graphics.pop()
  -- end)
end

-- transform coordinate to draw the child entity
-- FIXME will have to test again, but it seems like functions that take blocks
-- Take longer to run...well at least they clog up the profiler.
function View:transform(block)
  love.graphics.push()

  love.graphics.translate(self.model.pos.x, self.model.pos.y)
  love.graphics.rotate(self.model.rot)
  love.graphics.scale(self.model.scl.x, self.model.scl.y)
  block()

  love.graphics.pop()
end

function View:drawDebug()
  love.graphics.print(self.model.pos:toString(), self.model.pos.x, self.model.pos.y)
  love.graphics.print(self.model.vel:toString(), self.model.pos.x, self.model.pos.y - 14)
  love.graphics.print(self.model.acc:toString(), self.model.pos.x, self.model.pos.y - 14 * 2)
end

function View:drawMotionVectors()
  local r, g, b, a = love.graphics.getColor()
  love.graphics.setColor(0, 200, 0)
  love.graphics.line(0, 0, self.model.acc.x, self.model.acc.y)
  love.graphics.setColor(200, 0, 0)
  love.graphics.line(0, 0, self.model.vel.x, self.model.vel.y)
  love.graphics.setColor(r, g, b, a)
end

-- metamethods
View.__tostring = View.tostringByAttr({ spriteMap=1, spriteBatch=1, animations=1, animationTime=1 })

return View

-- a = View:new(nil, nil)
-- print(a)
-- print("prefix: " .. a)
-- print(a .. " :postfix")
