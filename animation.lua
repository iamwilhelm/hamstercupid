Animation = {
  name = "Animation",
}

function Animation:new()
  local instance = {
    klass = Animation,
    offset = V:new(0, 0),
    width = 32,
    height = 32,
    ref_width = 64,
    ref_height = 64,
    time = 0,
    period = 1,
    frames = {},
  }
  setmetatable(instance, self)
  self.__index = self

  return instance
end

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

function Animation:frame(row, col, options)
  options = options or {}
  local frame_index = self:frameCount() + 1
  local x = self.width * col + self.offset.x
  local y = self.height * row + self.offset.y

  for i = 0, self:frameCount() do
    print(self.frames[i])
  end
  print("---")
  table.insert(self.frames, love.graphics.newQuad(x, y, self.width, self.height, self.ref_width, self.ref_height))
end

function Animation:frameCount()
  return table.getn(self.frames)
end

function Animation:tickAnimation(dt)
  self.time = (self.time + dt) % self.period
end

function Animation:frameIndex()
  -- ugh. lua arrays are 1-based, so we use math.ceil()
  return math.ceil(self.time / self.period * self:frameCount())
end

function Animation:getFrame()
  return self.frames[self:frameIndex()]
end

function Animation:getCenter()
  return V:new(self.width / 2, self.height / 2)
end


