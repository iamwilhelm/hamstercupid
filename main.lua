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
  magician = Entity:new("magician", V:new(400, 200))
  magician.view:setImage("resources/rpg/magician.front.gif")

  helmet = Entity:new("helmet", V:new(-2, -24))
  helmet.view:setImage("resources/rpg/moonstone.tiara.gif")
  magician:addChild(helmet)

  weapon = Entity:new("weapon", V:new(-24, 0), 1, math.rad(-10))
  weapon.view:setImage("resources/rpg/mythril.rod.gif")
  weapon.movement:addMovement(function(movement, model, dt)
    movement.acc = movement.acc + (V:new(-30, 0) - model.pos)
  end)
  magician:addChild(weapon)

  -- TODO should be able to scale each axes separately, for perspective
  shield = Entity:new("shield", V:new(15, 10), 1, math.rad(0))
  shield.view:setImage("resources/rpg/adamant.shield.gif")
  shield.movement:addMovement(function(movement, model, dt)
    -- movement.acc = movement.acc + (V:new(15, 7) - model.pos) * 25
  end)
  magician:addChild(shield)

  cow = Entity:new("cow", V:new(40, 0), 1, math.rad(0))
  cow.view:setImage("resources/cow.png")
  cow.movement:addMovement(function(movement, model, dt)
    print("pos: " .. model.pos:toString())
    local centripetal = V:new(0, 0) - model.pos
    local acc = V:new(model.pos.x, model.pos.y - 40) - model.pos
    print("cen: " .. centripetal:toString())
    print("acc: " .. acc:toString())
    movement.acc = movement.acc + centripetal -- + acc
  end)
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
    player.movement:go(direction)

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

