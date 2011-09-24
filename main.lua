require('vector.lua')
require('entity.lua')
require('camera.lua')

-- Read player input

function readPlayerInput()
  local direction = V:new(0, 0)

  if love.keyboard.isDown('d') then
    direction.x = 1
  end
  if love.keyboard.isDown('a') then
    direction.x = -1
  end
  if love.keyboard.isDown('s') then
    direction.y = 1
  end
  if love.keyboard.isDown('w') then
    direction.y = -1
  end

  return direction
end

function readCameraInput()
  if love.keyboard.isDown("right") then
    camera:pan(V:new(20, 0))
  end
  if love.keyboard.isDown('left') then
    camera:pan(V:new(-20, 0))
  end
  if love.keyboard.isDown('down') then
    camera:pan(V:new(0, 20))
  end
  if love.keyboard.isDown('up') then
    camera:pan(V:new(0, -20))
  end
  if love.keyboard.isDown('[') then
    camera:zoom(1.05)
  end
  if love.keyboard.isDown(']') then
    camera:zoom(1 / 1.05)
  end
end

function readPlayerWayPoint()
  return V:new(love.mouse.getX(), love.mouse.getY())
end

-- Map functions

map = {}
function map:draw()
  love.graphics.line(
    0, 0, 
    love.graphics.getWidth(), 0,
    love.graphics.getWidth(), love.graphics.getHeight(),
    0, love.graphics.getHeight(),
    0, 0
  )
end

-- Callback functions for main loop
function createCow()
  cow = Entity:new(325, 325)
  cow.view:setImage("resources/cow.png")
  return cow
end

function createMagician()
  magician = Entity:new(V:new(400, 200))
  magician.view:setImage("resources/rpg/magician.front.gif")

  helmet = Entity:new(V:new(-2, -24))
  helmet.view:setImage("resources/rpg/moonstone.tiara.gif")
  magician:addChild("helmet", helmet)

  weapon = Entity:new(V:new(-24, 0), 1, math.rad(-10))
  weapon.view:setImage("resources/rpg/mythril.rod.gif")
  magician:addChild("weapon", weapon)

  -- TODO should be able to scale each axes separately, for perspective
  shield = Entity:new(V:new(15, 10), 1, math.rad(0))
  shield.view:setImage("resources/rpg/adamant.shield.gif")
  magician:addChild("shield", shield)

  return magician
end

function love.load()
  entities = {}

  player = createMagician()
  table.insert(entities, player)
end

function love.update(dt)
  readCameraInput()

  player:move(dt, function()
    local direction = readPlayerInput()
    player.movement:go(direction)

    -- local waypoint = readPlayerWayPoint()
    -- player.movement:goToDestination(waypoint)

  end)

  -- cow:move(dt)
end

function love.draw()
  camera:shoot(function()
    player:draw()
    -- cow:draw()

    map:draw()
  end)
end

