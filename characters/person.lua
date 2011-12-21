
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
    view:animation("stand.south.west", 40, 32, {}, function(animation)
      animation:frame(0, 0)
    end)

    view:animation("walk.south.west", 40, 32, { offset = V:new(0, 0), period = 1 }, function(animation)
      animation:frame(0, 3, { cols = 3 })
      animation:frame(1, 0, { cols = 3 })
    end)

    view:animation("stand.south.east", 40, 32, {}, function(animation)
      animation:frame(0, 0, { scale = V:new(-1, 1) })
    end)

    view:animation("walk.south.east", 40, 32, { offset = V:new(0, 0), period = 1 }, function(animation)
      animation:frame(0, 3, { cols = 3, scale = V:new(-1, 1) })
      animation:frame(1, 0, { cols = 3, scale = V:new(-1, 1) })
    end)

    view:animation("stand.neutral.west", 40, 32, {}, function(animation)
      animation:frame(0, 1)
    end)

    view:animation("walk.neutral.west", 40, 32, {}, function(animation)
      animation:frame(1, 3, { cols = 3 })
      animation:frame(2, 0, { cols = 3 })
    end)

    view:animation("stand.neutral.east", 40, 32, {}, function(animation)
      animation:frame(0, 1, { scale = V:new(-1, 1) })
    end)

    view:animation("walk.neutral.east", 40, 32, { scale = V:new(-1, 1) }, function(animation)
      animation:frame(1, 3, { cols = 3, scale = V:new(-1, 1) })
      animation:frame(2, 0, { cols = 3, scale = V:new(-1, 1) })
    end)

    view:animation("stand.north.west", 40, 32, {}, function(animation)
      animation:frame(0, 2, {})
    end)

    view:animation("walk.north.west", 40, 32, {}, function(animation)
      animation:frame(2, 3, { cols = 3 })
      animation:frame(3, 0, { cols = 3 })
    end)

    view:animation("stand.north.east", 40, 32, {}, function(animation)
      animation:frame(0, 2, { scale = V:new(-1, 1) })
    end)

    view:animation("walk.north.east", 40, 32, {}, function(animation)
      animation:frame(2, 3, { cols = 3, scale = V:new(-1, 1) })
      animation:frame(3, 0, { cols = 3, scale = V:new(-1, 1) })
    end)
  end)

  -- FIXME performance issue: adding child entity significantly degrades performance.
  head.view:film("resources/dodgeball/wildlynx.gif", function(view)
    view:animation("look.south.west", 32, 32, { offset = V:new(768, 0) }, function(animation)
      animation:frame(0, 0)
    end)

    view:animation("look.neutral.west", 32, 32, { offset = V:new(768, 0) }, function(animation)
      animation:frame(0, 1)
    end)

    view:animation("look.north.west", 32, 32, { offset = V:new(768, 0) }, function(animation)
      animation:frame(0, 2)
    end)

    view:animation("look.south.east", 32, 32, { offset = V:new(768, 0) }, function(animation)
      animation:frame(0, 0, { scale = V:new(-1, 1) })
    end)

    view:animation("look.neutral.east", 32, 32, { offset = V:new(768, 0) }, function(animation)
      animation:frame(0, 1, { scale = V:new(-1, 1) })
    end)

    view:animation("look.north.east", 32, 32, { offset = V:new(768, 0) }, function(animation)
      animation:frame(0, 2, { scale = V:new(-1, 1) })
    end)
  end)

  return person
end

function Person.controlMap(person, head)
  person.controls:interface(
    { move = "stand", vert = "south", horz = "east" }, 
    function(map)
      map.east = function(ctrl)
        print("person going east")
        ctrl:toState({ move = "walk", vert = "neutral", horz = "east" })
      end
      map.west = function(ctrl)
        print("person going west")
        ctrl:toState({ move = "walk", vert = "neutral", horz = "west" })
      end
      map.north = function(ctrl)
        print("person going north")
        ctrl:toState({ move = "walk", vert = "north" })
      end
      map.south = function(ctrl)
        print("person going south")
        ctrl:toState({ move = "walk", vert = "south" })
      end
      map.throw = function(ctrl)
        print("person going throw")
        ctrl:toState({ move = "throw" })
      end
      map.stand = function(ctrl)
        print("person going stand")
        ctrl:toState({ move = "stand" })
      end
    end)

  head.controls:interface(
    { move = "look", vert = "south", horz = "east" }, 
    function(map)
      map.east = function(ctrl)
        ctrl:toState({ vert = "neutral", horz = "east" })
      end
      map.west = function(ctrl)
        ctrl:toState({ vert = "neutral", horz = "west" })
      end
      map.north = function(ctrl)
        ctrl:toState({ vert = "north" })
      end
      map.south = function(ctrl)
        ctrl:toState({ vert = "south" })
      end
      map.throw = function(ctrl)
        ctrl:toState({ })
      end
      map.stand = function(ctrl, key)
        ctrl:toState({ })
      end
    end)
end
