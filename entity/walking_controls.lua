require("object")

local WalkingControls = {
  name = "Entity.WalkingControls",
}
setmetatable(WalkingControls, Object)
WalkingControls.__index = WalkingControls

WalkingControls:include(Metamethodable)

-- Add the different state machine definitions to be instanciated for every instance

function WalkingControls:new(view)
  local instance = {
    klass = WalkingControls,
    view = view,

    verticalState = nil,
    horizontalState = nil,
    throwState = nil,
    mapping = {},
  }
  setmetatable(instance, WalkingControls)
  
  return instance
end

-- Every entity has controls that need to be hooked to an input. The input to the controls 
-- may be the keyboard, a script, or AI
function WalkingControls:hookTo(input)

end

-- Changes the state of the entity correctly, so that other components are doing the right thing.
-- Should this change the animation? Or do we store it and change the animation when animation asks for it?
-- I'm guessing the latter, because event keypress may happen not when you draw anything.
function WalkingControls:navigateWithKeyPressedAction(key)
end


function WalkingControls:navigateWithKeyHeldAction(key)
  if love.keyboard.isDown("up") then
    print("up!")
  end
end

function WalkingControls:navigateWithKeyReleaseAction(key)
end

return WalkingControls
