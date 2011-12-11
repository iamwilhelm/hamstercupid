
require('object')
require('entity')

Person = {
  name = "Person"
}
setmetatable(Person, Object)
Person.__index = Person

Person:include(Metamethodable)

function Person:new(x, y)
  local person = Entity:new("person", V:new(x, y))
  local head = Entity:new("head", V:new(0, -18))
  head.movement:addMovement(Motion.wiggle(1, 0.5, 0))
  person:addChild(head)

  Person.states(person, head)
  Person.animations(person, head)
  Person.controlMap(person, head)

  return person
end

function Person.states(person, head)
  -- FIXME forgetting to initialize the state is causing bugs when writing the DSL
  person.model.state = "walk.down.left"
  head.model.state = "look.down.left"
end

function Person.animations(person, head)
  -- TODO This is just temporary until I find a good way to declare in json-like format
  person.view:film("resources/dodgeball/wildlynx.gif", function(view)
    view:animation("stand.down.left", 40, 32, {}, function(animation)
      animation:frame(0, 0)
    end)

    view:animation("walk.down.left", 40, 32, { offset = V:new(0, 0), period = 1 }, function(animation)
      animation:frame(0, 3, { cols = 3 })
      animation:frame(1, 0, { cols = 3 })
    end)

    view:animation("stand.down.right", 40, 32, {}, function(animation)
      animation:frame(0, 0, { scale = V:new(-1, 1) })
    end)

    view:animation("walk.down.right", 40, 32, { offset = V:new(0, 0), period = 1 }, function(animation)
      animation:frame(0, 3, { cols = 3, scale = V:new(-1, 1) })
      animation:frame(1, 0, { cols = 3, scale = V:new(-1, 1) })
    end)

    view:animation("stand.left", 40, 32, {}, function(animation)
      animation:frame(0, 1)
    end)

    view:animation("walk.left", 40, 32, {}, function(animation)
      animation:frame(1, 3, { cols = 3 })
      animation:frame(2, 0, { cols = 3 })
    end)

    view:animation("stand.right", 40, 32, {}, function(animation)
      animation:frame(0, 1, { scale = V:new(-1, 1) })
    end)

    view:animation("walk.right", 40, 32, { scale = V:new(-1, 1) }, function(animation)
      animation:frame(1, 3, { cols = 3, scale = V:new(-1, 1) })
      animation:frame(2, 0, { cols = 3, scale = V:new(-1, 1) })
    end)

    view:animation("stand.up.left", 40, 32, {}, function(animation)
      animation:frame(0, 2, {})
    end)

    view:animation("walk.up.left", 40, 32, {}, function(animation)
      animation:frame(2, 3, { cols = 3 })
      animation:frame(3, 0, { cols = 3 })
    end)

    view:animation("stand.up.right", 40, 32, {}, function(animation)
      animation:frame(0, 2, { scale = V:new(-1, 1) })
    end)

    view:animation("walk.up.right", 40, 32, {}, function(animation)
      animation:frame(2, 3, { cols = 3, scale = V:new(-1, 1) })
      animation:frame(3, 0, { cols = 3, scale = V:new(-1, 1) })
    end)
  end)

  -- FIXME performance issue: adding child entity significantly degrades performance.
  head.view:film("resources/dodgeball/wildlynx.gif", function(view)
    view:animation("look.down.left", 32, 32, { offset = V:new(768, 0) }, function(animation)
      animation:frame(0, 0)
    end)

    view:animation("look.left", 32, 32, { offset = V:new(768, 0) }, function(animation)
      animation:frame(0, 1)
    end)

    view:animation("look.up.left", 32, 32, { offset = V:new(768, 0) }, function(animation)
      animation:frame(0, 2)
    end)

    view:animation("look.down.right", 32, 32, { offset = V:new(768, 0) }, function(animation)
      animation:frame(0, 0, { scale = V:new(-1, 1) })
    end)

    view:animation("look.right", 32, 32, { offset = V:new(768, 0) }, function(animation)
      animation:frame(0, 1, { scale = V:new(-1, 1) })
    end)

    view:animation("look.up.right", 32, 32, { offset = V:new(768, 0) }, function(animation)
      animation:frame(0, 2, { scale = V:new(-1, 1) })
    end)
  end)

  return person
end

function Person.controlMap(person, head)
end
