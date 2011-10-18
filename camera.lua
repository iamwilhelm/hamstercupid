require('vector')

camera = {}
camera.pos = V:new(0, 0)
camera.scl = V:new(1, 1)
camera.rot = 0

function camera:shoot(block)
  love.graphics.push()
  love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
  love.graphics.rotate(-self.rot)
  love.graphics.scale(self.scl.x, self.scl.y)
  love.graphics.translate(-love.graphics.getWidth() / 2, -love.graphics.getHeight() / 2)

  love.graphics.translate(-self.pos.x, -self.pos.y)

  block()

  love.graphics.pop()
end

function camera:pan(direction)
  self.pos = self.pos + direction
end

function camera:rotate(rotation)
  self.rot = self.rot + rotation
end

function camera:zoom(sx, sy)
  sx = sx or 1
  self.scl.x = self.scl.x * sx
  self.scl.y = self.scl.y * (sy or sx)
end

function camera:setPosition(x, y)
  self.pos.x = x or self.pos.x
  self.pos.y = y or self.pos.y
end

function camera:setZoom(sx, sy)
  self.scl.x = sx or self.scl.x
  self.scl.y = sy or self.scl.y
end
