require("object")

local WalkingControls = {
  name = "Entity.WalkingControls",
}
setmetatable(WalkingControls, Object)
WalkingControls.__index = WalkingControls

WalkingControls:include(Metamethodable)

-- Add the different state machine definitions to be instanciated for every instance

function WalkingControls:new(view, movement)
  local instance = {
    klass = WalkingControls,
    view = view,
    movement = movement,

    state = { 
      move = "stand",
      vert = "down",
      horz = "left",
    },
    mapping = {},

    direction = V:new(0, 0),
  }
  setmetatable(instance, WalkingControls)
  
  return instance
end

---------------------- Initialization and Setting Methods ----------------------

function WalkingControls:interface(initialState, block)
  self.state = initialState
  block(self.mapping)
end

function WalkingControls:toState(stateChanges)
  for k, v in pairs(stateChanges) do
    self.state[k] = stateChanges[k]
  end
end

------------------------------ Command and Control Methods -----------------------------

function WalkingControls:north()
  self.direction = V:new(0, -1)
  self.mapping.north(self)
end

function WalkingControls:south()
  self.direction = V:new(0, 1)
  self.mapping.south(self)
end

function WalkingControls:east()
  self.direction = V:new(1, 0)
  self.mapping.east(self)
end

function WalkingControls:west()
  self.direction = V:new(-1, 0)
  self.mapping.west(self)
end

function WalkingControls:throw()
  self.mapping.throw(self)
end

function WalkingControls:stand()
  self.direction = V:new(0, 0)
  self.mapping.stand(self)
end

--------------------------- Navigation Stage Method -------------------------------

-- Navigation direction should only be applied to the root entity, so that's
-- why we ask for it. Otherwise, every level down in the child hierarchy will 
-- move in double the direction. However, we need all the child entities to be called
-- in the entity:navigate() since we need the currentAnimation state to propagate down 
-- to the child entities
function WalkingControls:navigate(dt, isRoot)
  if isRoot == true then
    self:go(dt, self.direction)
  end

  local state = self.state["move"] .. "." .. self.state["vert"] .. "." .. self.state["horz"]
  self.view:setCurrentAnimation(state)
end

function WalkingControls:go(dt, direction)
  if (direction.x > 0) then
    self.movement:addToAcceleration(V:new(Motion.accel_max, 0))
  elseif (direction.x < 0) then
    self.movement:addToAcceleration(V:new(-Motion.accel_max, 0))
  end

  if (direction.y > 0) then
    self.movement:addToAcceleration(V:new(0, Motion.accel_max))
  elseif (direction.y < 0) then
    self.movement:addToAcceleration(V:new(0, -Motion.accel_max))
  end
end

return WalkingControls
