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

function WalkingControls:navigate(dt)
  self.movement:go(dt, self.direction)

  local state = self.state["move"] .. "." .. self.state["vert"] .. "." .. self.state["horz"]
  self.view:setCurrentAnimation(state)
end

return WalkingControls
