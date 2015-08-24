# skeletor

## About

Skeletor is a 2d skeleton animation system for [LÖVE 2D](https://love2d.org/).

## Features

- A detailed cascading style system to decorate the wireframe, joints, and shapes.
- A comprehensive tagging system to retain track of skeletons and bones.
- A skeleton boundary system for collision detection.
- A clean and comprehensive API.
- A fast learning curve.

## To do

- An animation algorithm to morph from one frame to another in a given number of steps.
- A texture system to decorate skeletons and bones with .jpg or .pgn images.
- A grouping system for skeletons.

## Loading the module

```lua
local Skeletor = require('skeletor.skeletor')
skeletor = Skeletor()
```

## Default style

Below is the default styles used by the skeletor engine.

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

You can overwrite any of these style properties when first loading the module.

```lua
-- modifying some style properties when loading the module
local Skeletor = require('skeletor.skeletor')
skeletor = Skeletor({
	wireShow = false,
	shapeShow = true,
})
```

## Getters and Setters

```lua
	skeletor:getStyle() -- returns the default style being used
	skeletor:setStyle(style) -- modifies the default style being used
	skeletor:getSkeletons() -- returns the skeletons
	skeletor:setSkeletons(skeletons) -- sets the skeletons
```

The most useful is `skeletor:setStyle(style)`. It can be used to modify the default styles at any time. For example, we can modify the `wireShow` and `shapeShow` properties after the module has been loaded.

```lua
-- modifying some style properties avec the module has been loaded
local Skeletor = require('skeletor.skeletor')
skeletor = Skeletor()

skeletor:setStyle({
	wireShow = false,
	shapeShow = true
)
``` 

## Skeleton

### Creating a skeleton

Creating a new skeleton is done with the `skeletor:newSkeleton(name, props)` function.

The `name` is a tag we use to identify the skeleton. It is required.

The `prop` is a list of properties. It is optional.

Here is the list of skeleton properties and their defaults:

```lua
x = 0 -- the skeleton's x position
y = 0 -- the skeleton's y position
sx = 1 -- the skeleton's x scale factor
sy = 1 -- the skeleton's y scale factor
angle = 0 -- the skeleton's angle

-- The remaining properties are the style properties mentionned above.
-- When you create a skeleton, you can overwrite any of the default style properties previously set. 

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

Here are some examples of skeleton creation:

```lua
-- create a skeleton named John
skeletor:newSkeleton('John');

-- create a skeleton named max with a position of 200,200
skeletor:newSkeleton('max', {
	x = 200,
	y = 200
});

-- create a skeleton with various properties
skeletor:newSkeleton('max', {
	x = 200,
	y = 200,
	angle = math.rad(90),
	wireShow = true,
	shapeColor = {23, 432, 23}
});

```

### Retrieving a skeleton's property

The `skeletor:getSkeletonProperty(name, propName)` function makes it possible to retrieve any given property of a skeleton.

```lua
-- retrieving the x value of a skeleton named jim
local x = skeletor:getSkeletonProperty('jim', 'x')
```

### Editing a skeleton's properties

The `skeletor:editSkeleton(name, props)` function is used to edit many properties at once.

```lua
-- editing a skeleton named sandra
skeletor:editSkeleton('sandra', {
	x = 123,
	y = 34,
	sx = 2,
	wireColor = {123, 22, 33}
})
```

### Deleting a skeleton

`skeletor:killSkeleton(name)` is used to delete skeletons.

```lua
-- deleting a skeleton named mary
skeletor:killSkeleton('mary')

```

### Cloning a skeleton

`skeletor:cloneSkeleton(from, to, props)` is used to clone a skeleton.

You can optionally change some of the skeleton's properties when cloning.

```lua
-- Clone joe from a skeleton named jerry
skeletor:cloneSkeleton('jerry', 'joe')

-- Clone betsy from a skeleton name monica and change some properties
skeletor:cloneSkeleton('monica', 'betsy', {
	x = 100,
	angle = math.rad(23),
	sy = 2.4,
	wireColor = {234, 234, 12}
})
```
