# skeletor

## About

Skeletor is a 2d skeleton animation system for [LÖVE 2D](https://love2d.org/).

## Loading the module

To load the module, use the following code.

```lua
local Skeletor = require('skeletor')
skeletor = Skeletor()
```

## Default style

Here is the default style used by the skeletor engine. It can be overwritten at various levels.

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
jointShape = skeletor:getEllipseVertices(0, 0, 8, 8, math.rad(0), 30) -- the shape of joints  
jointRotatable = false -- rotate joints when skeletons or bones are scaled  
jointScalable = true -- scale joints when skeletons or bones are scaled  
jointColor = {255, 0, 0} -- the color of joints  

shapeShow = false -- show shapes  
shapeMode = "line" -- the drawing mode for shapes  
shapeShape = skeletor:getEllipseVertices(0, 0, 1, .35, 0, 30) -- the shape of shapes  
shapeSx = 1 -- x scale factor for shapes  
shapeSy = 1 -- y scale factor for shapes  
shapeColor = {0, 255, 0} -- the color of shapes  
```

You can overwrite any of these style properties when first loading the module.


```lua
-- modifying some style properties when loading the module
local Skeletor = require('skeletor')
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

The most useful is `skeletor:setStyle(style)`. It can be used to modify the default style at any time. For example, we can modify the `wireShow` and `shapeShow` properties after the module as been loaded.

```lua
-- modifying some style properties avec the module has been loaded
local Skeletor = require('skeletor')
skeletor = Skeletor()

skeletor:setStyle({
	wireShow = false,
	shapeShow = true
)
``` 

## Skeleton