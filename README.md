# skeletor

## About

Skeletor is a 2d skeleton animation system for [LÖVE 2D](https://love2d.org/).

## Loading the module

To load the module, use the following code.

    local Skeletor = require('skeletor')
    skeletor = Skeletor()

## Default style

show = true                 -- show the element (use false to hide skeletons or bones)  

boundariesCalculate = false -- calculate the skeleton's boundary (useful for collision detection)  
boundariesShow = false      -- show the boundary (useful for testing)  
boundariesStyle = "smooth" -- the style of the boundary line ("smooth", "rough")  
boundariesWidth = 1 -- the width of the boundary line  
boundariesColor = {255, 255, 255} -- the color of the boundary line  

wireShow = true -- show the wireframe  
wireStyle = "smooth" - the style of the wireframe line ("smooth", "rough")  
wireWidth = 1 -- the width of the wireframe line  
wireColor = {255, 255, 255} - the color of the wireframe line  

jointShow = true -- show joints  
jointMode = "fill" -- the drawing mode for joints  
jointShape = skeletor:getEllipseVertices(0, 0, 8, 8, math.rad(0), 30) -- The shape of joints  
jointRotatable = false -- rotate joints when skeletons or bones are scaled  
jointScalable = true -- scale joints when skeletons or bones are scaled  
jointColor = {255, 0, 0} -- the color of joints  

shapeShow = false -- show shapes  
shapeMode = "line" -- drawing mode for shapes  
shapeShape = skeletor:getEllipseVertices(0, 0, 1, .35, 0, 30) -- the shape for shapes  
shapeSx = 1 -- x scale factor for shapes  
shapeSy = 1 -- y scale factor for shapes  
shapeColor = {0, 255, 0} - the color of shapes  











## Getters and Setters