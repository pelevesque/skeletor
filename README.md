# skeletor

## About

Skeletor is a 2d skeleton animation system for [LÖVE 2D](https://love2d.org/).

## Features

- A detailed cascading style system to decorate the wireframe, joints, and shapes.
- A comprehensive tagging system to retain track of skeletons and bones.
- A skeleton boundary system for collision detection.
- A fast learning curve.
- A clean and comprehensive API.
- Clean source code.
- Good documentation.
- Unit tests for better development and testing.

## To do

- An animation algorithm to morph from one frame to another in a given number of steps.
- A texture system to decorate skeletons and bones with .jpg or .pgn images.
- A grouping system for skeletons.
- Saving and loading skeletons using files.

## Skeletor's functions reference

```lua
local Skeletor = require('skeletor.skeletor')
skeletor = Skeletor(style, skeletons)

skeletor:getStyle()
skeletor:setStyle(style)
skeletor:getSkeletons()
skeletor:setSkeletons(skeletons)

skeletor:newSkeleton(name, props)
skeletor:getSkeletonProp(name, propKey)
skeletor:editSkeleton(name, props)
skeletor:cloneSkeleton(fromName, toName, props)
skeletor:deleteSkeleton(name)

skeletor:newBone(path, props)
skeletor:getBoneProp(path, propName)
skeletor:editBone(path, props)
skeletor:deleteBone(path)

skeletor:draw()

```

## Default style

Below are the default style properties used by the skeletor engine. They control the display and behavior of skeletons and their bones.

These style properties can be overwritten at many different stages: when first loading the module, anytime using skeletor:setStyle(), when creating skeletons, and when creating bones.

```lua
show = true -- show element (use false to hide skeletons and/or bones)  

boundariesCalculate = false -- calculate the skeleton's boundary (useful for collision detection)  
boundariesShow = false -- show the boundary (useful for testing)  
boundariesStyle = "smooth" -- the style of the boundary line ("smooth", "rough")  
boundariesWidth = 1 -- the width of the boundary line  
boundariesColor = {255, 255, 255} -- the color of the boundary line  

wireShow = true -- show the wireframe  
wireStyle = "smooth" -- the style of the wireframe line ("smooth", "rough")  
wireWidth = 1 -- the width of the wireframe line  
wireColor = {255, 255, 255} -- the color of the wireframe line  

jointShow = true -- show joints  
jointMode = "fill" -- the drawing mode for joints  
jointShape = utils:getEllipseVertices(0, 0, 8, 8, math.rad(0), 30) -- the shape of joints  
jointRotatable = false -- rotate joints when skeletons or bones are scaled  
jointScalable = true -- scale joints when skeletons or bones are scaled  
jointColor = {255, 0, 0} -- the color of joints  

shapeShow = false -- show shapes  
shapeMode = "line" -- the drawing mode for shapes  
shapeShape = utils:getEllipseVertices(0, 0, 1, .35, 0, 30) -- the shape of shapes  
shapeSx = 1 -- x scale factor for shapes  
shapeSy = 1 -- y scale factor for shapes  
shapeColor = {0, 255, 0} -- the color of shapes  
```

## Loading the module

```lua
-- simple loading
local Skeletor = require('skeletor.skeletor')
skeletor = Skeletor()
```

```lua
-- modifying some style properties at load time
local Skeletor = require('skeletor.skeletor')
skeletor = Skeletor({
	wireShow = false,
	shapeShow = true,
})
```

```lua
-- loading skeletons from a file
-- NOTE: this feature is not yet implemented (reference only)
local skeletons = -- retrieve skeletons from file

local Skeletor = require('skeletor.skeletor')
skeletor = Skeletor(nil, skeletons)
```

## Getters and Setters

```lua
	skeletor:getStyle() -- returns the default style being used
	skeletor:setStyle(style) -- modifies the default style being used
	skeletor:getSkeletons() -- returns the skeletons
	skeletor:setSkeletons(skeletons) -- sets the skeletons
```

At this time, the most useful is `skeletor:setStyle(style)`. It can be used to modify the default styles at any time. For example, we can modify the `wireShow` and `shapeShow` properties after the module has been loaded.

```lua
-- modifying some style properties after the module has been loaded
local Skeletor = require('skeletor.skeletor')
skeletor = Skeletor()

skeletor:setStyle({
	wireShow = false,
	shapeShow = true
)
```

`skeletor:getSkeletons()` and `skeletor:setStyle(style)` are there for reference. They will become useful when saving and loading skeletons from file is implemented.

## Skeleton

### Creating a skeleton

Creating a new skeleton is done via `skeletor:newSkeleton(name, props)`.

`name` is a tag used to identify the skeleton. *(required)*

`props` is a list of properties. *(optional)*

Here is the list of skeleton properties and their defaults values:

```lua
x = 0 -- the skeleton's x position
y = 0 -- the skeleton's y position
sx = 1 -- the skeleton's x scale factor
sy = 1 -- the skeleton's y scale factor
angle = 0 -- the skeleton's angle (in radians)

-- The remaining properties are the style properties mentionned above. (@see Default style)
-- When you create a skeleton, you can overwrite any of these style properties. 

show
boundariesCalculate
boundariesShow
boundariesStyle
boundariesWidth
boundariesColor
wireShow
wireStyle 
wireWidth
wireColor
jointShow
jointMode
jointShape
jointRotatable
jointScalable
jointColor
shapeShow
shapeMode
shapeShape 
shapeSx
shapeSy
shapeColor

```

Examples of skeleton creation:

```lua
-- create a skeleton named john
skeletor:newSkeleton('john')
```

```lua
-- create a skeleton named max with a position of 200, 200
skeletor:newSkeleton('max', {
	x = 200,
	y = 200
})
```

```lua
-- create a skeleton named carl with various properties
skeletor:newSkeleton('carl', {
	x = 200,
	y = 200,
	angle = math.rad(90),
	wireShow = true,
	shapeColor = {23, 432, 23}
})

```

### Retrieving a skeleton property

`skeletor:getSkeletonProp(name, propName)` makes it possible to retrieve any given property of a skeleton.

```lua
-- retrieving the x value of a skeleton named jim
local x = skeletor:getSkeletonProp('jim', 'x')
```

### Editing a skeleton's properties

`skeletor:editSkeleton(name, props)` is used to edit any number of properties at once.

```lua
-- editing a skeleton named sandra
skeletor:editSkeleton('sandra', {
	x = 123,
	y = 34,
	sx = 2,
	wireColor = {123, 22, 33}
})
```

### Cloning a skeleton

`skeletor:cloneSkeleton(from, to, props)` is used to clone a skeleton.

You can optionally change some of the skeleton's properties when cloning.

```lua
-- Clone joe from a skeleton named jerry
skeletor:cloneSkeleton('jerry', 'joe')
```

```lua
-- Clone betsy from a skeleton name monica and change some properties
skeletor:cloneSkeleton('monica', 'betsy', {
	x = 100,
	angle = math.rad(23),
	sy = 2.4,
	wireColor = {234, 234, 12}
})
```

### Deleting a skeleton

`skeletor:deleteSkeleton(name)` is used to delete skeletons.

```lua
-- deleting a skeleton named mary
skeletor:deleteSkeleton('mary')

```

## Bone

### Creating a bone

Creating a new bone is done via skeletor:newBone(path, props).

`path` is a tag used to identify the bone. *(required)*

`props` is a list of properties. *(optional)*

Here is the list of bone properties.

If they are not overwritten when creating the bone, the style properties will be derived from the skeleton they are attached to.

```lua
length = 0 -- the bone's length
angle = 0 -- the bone's angle (in radians)
sx = 1 -- the bone's x scale factor
sy = 1 -- the bone's y scale factor

-- The remaining properties are the style properties mentionned above. (@see Default style)
-- Notice boundary styles are gone. This is because boundaries are reserved for the skeleton.
-- When you create a bone, you can overwrite any of these style properties. 

show
wireShow
wireStyle 
wireWidth
wireColor
jointShow
jointMode
jointShape
jointRotatable
jointScalable
jointColor
shapeShow
shapeMode
shapeShape 
shapeSx
shapeSy
shapeColor

```

Examples of bone creation:

```lua
-- add an arm bone on a skeleton named james
skeletor:newSkeleton('james')
skeletor:newBone('james.arm')
```

```lua
-- add a hand bone on an arm bone on a skeleton named maurice
skeletor:newSkeleton('maurice')
skeletor:newBone('maurice.arm')
skeletor:newBone('maurice.arm.hand')
```

```lua
-- add a foot bone with properties on a skeleton named tim
skeletor:newSkeleton('tim')
skeletor:newBone('tim.foot', {
	length = 100,
	angle = math.rad(180),
	wireStyle = "rough",
	wireColor = {23, 42, 255}
})
```

### Retrieving a bone property

`skeletor:getBoneProp(path, propName)` makes it possible to retrieve any given property of a bone.

```lua
-- retrieving the angle of a bone named joe on skeleton mary
local angle  = skeletor:getBoneProp('joe.mary', 'angle')
```

### Editing a bone's properties

`skeletor:editBone(path, props)` is used to edit any number of properties at once.

```lua
-- editing a bone named arm from a skeleton named paul
skeletor:editBone('paul.arm', {
	length = 100,
	sx = 2,
	wireColor = {123, 255, 255},
	wireWidth = 5
})
```

### Deleting a bone

`skeletor:deleteBone(path)` is used to delete bones.

```lua
-- deleting a bone named toe on bone foot from skeleton jack
skeletor:deleteBone('jack.foot.toe')

```

## Drawing skeletons and their bones

To draw skeletons and their bones, you simply run `skeletor:draw()` inside Love's draw function.

```lua
function love.draw()
	skeletor:draw()
end
```
