require("object")
require("vector")

--  local person = Entity:new("person", V:new(400, 200))
--  person.view:film("resources/dodgeball/wildlynx.gif", function(view)
--    view:animation("stand.down", 40, 32, {}, function(animation)
--      animation:frame(0, 0)
--    end)
--
--    view:animation("walk.down", 40, 32, { offset = V:new(0, 0), period = 1 }, function(animation)
--      animation:frame(0, 3, { cols = 3 })
--      animation:frame(1, 0, { cols = 3 })
--    end)
--
--    view:animation("stand.up", 40, 32, {}, function(animation)
--      animation:frame(0, 2)
--    end)
--
--    view:animation("walk.up", 40, 32, {}, function(animation)
--      animation:frame(2, 3, { cols = 3 })
--      animation:frame(3, 0, { cols = 3 })
--    end)
--  end)
Animation = {
  name = "Animation",
}
setmetatable(Animation, Object)
Animation.__index = Animation

Animation:include(Metamethodable)

function Animation:new()
  local instance = {
    klass = Animation,
    offset = V:new(0, 0),
    width = 32,
    height = 32,
    ref_width = 64,
    ref_height = 64,
    scale = V:new(1, 1),
    time = 0,
    period = 1,
    frames = {},
  }
  setmetatable(instance, self)

  return instance
end

-- Methods for setting up and initializing the animation object

function Animation:setDimension(width, height)
  self.width = width
  self.height = height
end

function Animation:setReferenceDimension(ref_width, ref_height)
  self.ref_width = ref_width
  self.ref_height = ref_height
end

function Animation:setOffset(offset)
  self.offset = offset or V:new(0, 0)
end

function Animation:setPeriod(period) 
  self.period = period or 1
end

function Animation:setScale(scale)
  self.scale = scale or V:new(1, 1)
end

function Animation:frame(row, col, options)
  options = options or {}
  options["rows"] = options["rows"] or 1
  options["cols"] = options["cols"] or 1
  self:setScale(options["scale"])
  
  for rowrun = 1, options["rows"] do
    for colrun = 1, options["cols"] do
      local x = self.width * (col + colrun - 1) + self.offset.x
      local y = self.height * (row + rowrun - 1) + self.offset.y
      table.insert(self.frames, love.graphics.newQuad(x, y, self.width, self.height, self.ref_width, self.ref_height))
    end
  end
end

-- returns the total number of frames in this animation
function Animation:frameCount()
  return table.getn(self.frames)
end

-- move the animation reel forward by dt
function Animation:tickAnimation(dt)
  self.time = (self.time + dt) % self.period
end

-- get the current frame in the animation
function Animation:getFrame()
  return self.frames[self:_frameIndex()]
end

function Animation:getCenter()
  return V:new(self.width / 2, self.height / 2)
end

function Animation:getScale()
  return self.scale
end

-- private methods

function Animation:_frameIndex()
  -- ugh. lua arrays are 1-based, so we use math.ceil()
  return math.ceil(self.time / self.period * self:frameCount())
end

-- metamethods
Animation.__tostring = Animation.__toattrstring

-- ani = Animation:new()
-- print(ani)
-- print("prefix " .. ani)
-- print(ani .. " postfix")
