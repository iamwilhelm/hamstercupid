require('vector.lua')
require('entity.lua')
require('camera.lua')
require('motion.lua')

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
  magician = Entity:new("magician", V:new(400, 200))
  magician.view:setImage("resources/rpg/magician.front.gif")
  magician.movement:addMovement(Motion.jitter(10))

  helmet = Entity:new("helmet", V:new(-2, -24))
  helmet.view:setImage("resources/rpg/moonstone.tiara.gif")
  magician:addChild(helmet)

  weapon = Entity:new("weapon", V:new(-24, 0), nil, math.rad(-10))
  weapon.view:setImage("resources/rpg/mythril.rod.gif")
  -- weapon.movement:addMovement(Motion.wiggle(30, 1))
  magician:addChild(weapon)

  -- TODO should be able to scale each axes separately, for perspective
  shield = Entity:new("shield", V:new(15, 10), V:new(0.75, 1), math.rad(0))
  shield.view:setImage("resources/rpg/adamant.shield.gif")
  magician:addChild(shield)

  cow = Entity:new("cow", V:new(50, 0), V:new(4 / 3, 1), math.rad(0))
  cow.view:setImage("resources/cow.png")
  cow.movement:addMovement(Motion.wiggle(50, 1))
  cow.movement:addMovement(Motion.waggle(50, 1, math.rad(0)))
  shield:addChild(cow)

  return magician
end

function love.load()
  entities = {}

  player = createMagician()
  table.insert(entities, player)
end

function love.update(dt)
  readCameraInput()

  -- TODO make every root entity move in the game
  -- TODO make child entities move in the game relative to root
  player:move(dt, function()
    player.physics:move(dt)
    
    local direction = readPlayerInput()
    player.movement:go(dt, direction)

    -- local waypoint = readPlayerWayPoint()
    -- player.movement:goToDestination(waypoint)
  end)

end

function love.draw()
  camera:shoot(function()
    for _, entity in ipairs(entities) do
      entity:draw()
    end
    map:draw()
  end)
end

