require('object')
require('vector')
require('entity/animation')

local View = {
  name = "Entity.View"
}
setmetatable(View, Object)
View.__index = View

View:include(Metamethodable)

function View:new(model)
  local instance = {
    klass = View,
    model = model,

    spriteMap = nil,
    spriteBatch = nil,
    animations = {},
    animationTime = 0,
    animationState = nil,
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

function View:setCurrentAnimation(animationState)
  print("keys for the animation: " .. animationState)
  print(self.animations[animationState])

  if self.animations[animationState] ~= nil then
    self.animationState = animationState
    print("set animation state to: " .. self.animationState)
  else
    error("Invalid animationName set: " .. animationState)
  end
end

function View:currentAnimation()
  local animation = self.animations[self.animationState]
  if animation == nil then
    error("Animation for state: " .. self.animationState .. " was not found")
  else
    return animation 
  end
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
  local scale = self:currentAnimation():getScale()
  local center = self:currentAnimation():getCenter()
  self:currentAnimation():tickAnimation(dt)

  -- FIXME It seems that sometimes, currentAnimation is selected that doesn't have any frames at all?
  self.spriteBatch:addq(self:currentAnimation():getFrame(), 0, 0, 0, scale.x, scale.y, center.x, center.y)
end

-- Entity drawing methods

function View:draw(block)
  -- transform coordinate system to entity's local coordinate system

  self:transform(function()
    love.graphics.draw(self.spriteBatch, 0, 0, 0, 1, 1)

    if block ~= nil then block() end

    -- for debugging
    -- self:drawMotionVectors()
  end)
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
View.__tostring = View.tostringByAttr({ spriteMap=1, spriteBatch=1, animations=1, animationTime=1, animationState=1 })

return View

-- a = View:new(nil, nil)
-- print(a)
-- print("prefix: " .. a)
-- print(a .. " :postfix")
