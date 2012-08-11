--[[
Title:   Skeletor module for Love2D
Author:  Pierre-Emmanuel Lévesque
Date:    August 11th, 2012
Version: 1.0

Copyright (c) 2012 Pierre-Emmanuel Lévesque

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
--]]

----------------------------------------------------
-- Utilities
----------------------------------------------------

--[[
	Copies a single dimension table

	@param   table    table
	@return  table    copied table
--]]
local function copyTable(t)
	local copy = {}
	for k,v in pairs(t) do copy[k] = v end
	return copy
end

--[[
	Merges two single dimension tables

	The values in t1 are overwritten with those in t2.

	@param   table    table 1
	@param   table    table 2
	@return  table    merged tables
	@uses    copyTable
--]]
local function mergeTables(t1, t2)
	local merged = copyTable(t1)
	for k,v in pairs(t2) do merged[k] = v end
	return merged
end

--[[
	Splits a path

	Note: The character "/" cannot begin or terminate a path.

	Example path: "this/is/a/path"

	@param   string   path
	@return  table    split path
--]]
local function splitPath(path)
	local parts = {}
	local needle = 1
	for pos in function() return string.find(path, '/', needle, true) end do
		table.insert(parts, string.sub(path, needle, pos - 1))
		needle = pos + 1
	end
	table.insert(parts, string.sub(path, needle))
	return parts
end

--[[
	Parses a boolean

	@param   mixed    value
	@param   bool     default value
	@return  bool     parsed value
--]]
local function parseBool(v, default)
	if v == nil then
		return default
	else
		return v
	end
end

--[[
	Translates coordinates from polar to cartesian

	@param   number   radius
	@param   number   angle in radians
	@return  numbers  (x, y)
--]]
local function polarToCartesian(radius, angle)
	return radius * math.cos(angle), radius * math.sin(angle)
end

--[[
	Gets the distance between two coordinates

	@param   number   x1
	@param   number   y1
	@param   number   x2
	@param   number   y2
	@return  number   distance
--]]
local function getCoordinatesDistance(x1, y1, x2, y2)
	return math.sqrt(math.pow((x2 - x1), 2) + math.pow((y2 - y1), 2))
end

--[[
	Rotates a vector

	@param   number   x
	@param   number   y
	@param   number   angle in radians
	@return  numbers  (x, y) rotated
--]]
local function rotate(x, y, angle)
	local a = math.atan2(y, x) + angle
	local d = math.sqrt(math.pow(x, 2) + math.pow(y, 2))
	x = d * math.cos(a)
	y = d * math.sin(a)
	return x, y
end

--[[
	Scales a vector

	@param   number   x
	@param   number   y
	@param   number   scale factor of x
	@param   number   scale factor of y
	@return  numbers  (x, y) scaled
--]]
local function scale(x, y, sx, sy)
	return x * sx, y * sy
end

--[[
	Translates a vector

	@param   number   x
	@param   number   y
	@param   number   offset factor of x
	@param   number   offset factor of y
	@return  numbers  (x, y) translated
--]]
local function translate(x, y, ox, oy)
	return x + ox, y + oy
end

--[[
	Applies rotation, translation, and scaling to a set of vertices

	@param   table    vertices
	@param   number   angle
	@param   number   offset factor of x
	@param   number   offset factor of y
	@param   number   scale factor of x
	@param   number   scale factor or y
	@return  void
	@uses    rotate(), translate(), scale()
--]]
local function transform(v, angle, ox, oy, sx, sy)
	for i=1, #v, 2 do
		if sx ~= 1 or sy ~= 1 then v[i], v[i + 1] = scale(v[i], v[i + 1], sx, sy) end
		if angle ~= 0 then v[i], v[i + 1] = rotate(v[i], v[i+1], angle) end
		if ox ~= 0 or oy ~= 0 then v[i], v[i + 1] = translate(v[i], v[i + 1], ox, oy) end
	end
end

----------------------------------------------------
-- Module setup
----------------------------------------------------

local skeletor = {}
skeletor.__index = skeletor

--[[
	Gets the vertices of an ellipse

	@param   number   center x
	@param   number   center y
	@param   number   width
	@param   number   height
	@param   number   angle
	@param   number   numSegments
	@return  table    vertices {x1, y1, x2, y2, ...}
--]]
function skeletor:getEllipseVertices(cx, cy, width, height, angle, numSegments)
	local sy = height / width
	local radius = width / 2
	local arcAngle = 2 * math.pi
	local theta = arcAngle / numSegments
	local cosine = math.cos(theta)
	local sine = math.sin(theta)
	local x = radius
	local y = 0
	local vertices = {}
	for i = 1, numSegments do
		local vx = x
		local vy = y * sy
		local Tvx = vx
		vx = vy * math.sin(angle) + vx * math.cos(angle)
		vy = Tvx * math.sin(angle) - vy * math.cos(angle)
		table.insert(vertices, vx + cx)
		table.insert(vertices, vy + cy)
		local Tx = x
		x = (cosine * x) - (sine * y)
		y = (sine * Tx) + (cosine * y)
	end
	return vertices
end

--[[
	Default style
--]]
local defaultStyle = {
	show = true,
	wireShow = true,
	wireStyle = "smooth",
	wireWidth = 1,
	wireColor = {255, 255, 255},
	jointShow = true,
	jointMode = "fill",
	jointShape = skeletor:getEllipseVertices(0, 0, 8, 8, 0, 15),
	jointRotatable = false,
	jointScalable = true,
	jointColor = {0, 123, 255},
	shapeShow = true,
	shapeMode = "fill",
	shapeShape = skeletor:getEllipseVertices(0, 0, 1, .35, 0, 30),
	shapeSx = 1,
	shapeSy = 1,
	shapeColor = {255, 255, 255}
}

--[[
	New (constructor)

	@param   table    style [def: {}]
	@param   table    skeletons [def: {}]
	@return  table    metatable
	@uses    mergeTables()
--]]
local function new(style, skeletons)
	return setmetatable({
		style = mergeTables(defaultStyle, style or {}),
		skeletons = skeletons or {}
	}, skeletor)
end

----------------------------------------------------
-- Getters and setters
----------------------------------------------------

function skeletor:getStyle() return self.style end
function skeletor:setStyle(style) self.style = mergeTables(self.style, style) end
function skeletor:getSkeletons() return self.skeletons end
function skeletor:setSkeletons(skeletons) self.skeletons = skeletons end

----------------------------------------------------
-- Skeleton functions
----------------------------------------------------

--[[
	Creates a new skeleton

	@param   string   name
	@param   table    properties
	@return  void
--]]
function skeletor:newSkeleton(name, props)
	props = props or {}
	self.skeletons[name] = {
		x = props.x or 0,
		y = props.y or 0,
		sx = props.sx or 1,
		sy = props.sy or 1,
		angle = props.angle or 0,
		show = parseBool(props.show, self.style.show),
		wireShow = parseBool(props.wireShow, self.style.wireShow),
		wireStyle = props.wireStyle or self.style.wireStyle,
		wireWidth = props.wireWidth or self.style.wireWidth,
		wireColor = props.wireColor or self.style.wireColor,
		jointShow = parseBool(props.jointShow, self.style.jointShow),
		jointMode = props.jointMode or self.style.jointMode,
		jointShape = props.jointShape or self.style.jointShape,
		jointRotatable = parseBool(props.jointRotatable, self.style.jointRotatable),
		jointScalable = parseBool(props.jointScalable, self.style.jointScalable),
		jointColor = props.jointColor or self.style.jointColor,
		shapeShow = parseBool(props.shapeShow, self.style.shapeShow),
		shapeMode = props.shapeMode or self.style.shapeMode,
		shapeShape = props.shapeShape or self.style.shapeShape,
		shapeSx = props.shapeSx or self.style.shapeSx,
		shapeSy = props.shapeSy or self.style.shapeSy,
		shapeColor = props.shapeColor or self.style.shapeColor,
		childBones = {}
	}
end

--[[
	Adds a bone to a skeleton

	@param   string   name
	@param   string   path
	@param   table    properties
	@return  void
--]]
function skeletor:addBone(path, props)
	local function addBone(path, i, bone, props)
		if #path == i then
			bone[path[i]] = {
				length = props.length or 0,
				ox = props.ox or 0,
				oy = props.oy or 0,
				sx = props.sx or 1,
				sy = props.sy or 1,
				angle = props.angle or 0,
				show = parseBool(props.show, true),
				wireShow = props.wireShow,
				wireStyle = props.wireStyle,
				wireWidth = props.wireWidth,
				wireColor = props.wireColor,
				jointShow = props.jointShow,
				jointMode = props.jointMode,
				jointShape = props.jointShape,
				jointRotatable = props.jointRotatable,
				jointScalable = props.jointScalable,
				jointColor = props.jointColor,
				shapeShow = props.shapeShow,
				shapeMode = props.shapeMode,
				shapeShape = props.shapeShape,
				shapeSx = props.shapeSx,
				shapeSy = props.shapeSy,
				shapeColor = props.shapeColor,
				childBones = {}
			}
		else
			addBone(path, i + 1, bone[path[i]].childBones, props)
		end
	end
	addBone(splitPath(path), 1, self.skeletons, props or {})
end

--[[
	Edits a skeleton bone

	@param   string   path
	@param   table    properties
	@return  void
--]]
function skeletor:editBone(path, props)
	local function editBone(path, i, bone, props)
		if #path == i then
			for k,v in pairs(props) do
				bone[path[i]][k] = v
			end
		else
			editBone(path, i + 1, bone[path[i]].childBones, props)
		end
	end
	editBone(splitPath(path), 1, self.skeletons, props or {})
end

--[[
	Edits a skeleton

	@param   string   name
	@param   string   path
	@param   table    properties
	@return  void
--]]
function skeletor:editSkeleton(name, props)
	for k,v in pairs(props) do
		self.skeletons[name][k] = v
	end
end

--[[
	Draws the skeletons

	@return  void
--]]
function skeletor:draw()
	local function drawBones(bone, x, y, skeleton)
		local sx, sy = scale(bone.sx, bone.sy, skeleton.sx, skeleton.sy)
		local angle = bone.angle + skeleton.angle
		local x1, y1 = translate(x, y, bone.ox, bone.oy)
		local x2, y2 = polarToCartesian(bone.length, angle)
		x2, y2 = scale(x2, y2, sx, sy)
		x2, y2 = translate(x2, y2, x1, y1)
		angle = math.atan2(y2 - y1, x2 - x1)
		local length = getCoordinatesDistance(x1, y1, x2, y2)
		if bone.show then
			if parseBool(bone.shapeShow, skeleton.shapeShow) then
				local shapeMode = bone.shapeMode or skeleton.shapeMode
				local shapeShape = copyTable(bone.shapeShape or skeleton.shapeShape)
				local shapeSx = bone.shapeSx or skeleton.shapeSx
				local shapeSy = bone.shapeSy or skeleton.shapeSy
				local shapeColor = bone.shapeColor or skeleton.shapeColor
				transform(
					shapeShape,
					angle,
					x1 + ((x2 - x1) / 2),
					y1 + ((y2 - y1) / 2),
					length * shapeSx,
					length * shapeSy
				)
				love.graphics.setColor(shapeColor)
				love.graphics.polygon(shapeMode, shapeShape)
			end
			if parseBool(bone.wireShow, skeleton.wireShow) then
				local wireStyle = bone.wireStyle or skeleton.wireStyle
				local wireWidth = bone.wireWidth or skeleton.wireWidth
				local wireColor = bone.wireColor or skeleton.wireColor
				love.graphics.setLine(wireWidth, wireStyle)
				love.graphics.setColor(wireColor)
				love.graphics.line(x1, y1, x2, y2)
			end
			if parseBool(bone.jointShow, skeleton.jointShow) then
				local jointMode = bone.jointMode or skeleton.jointMode
				local jointShape = copyTable(bone.jointShape or skeleton.jointShape)
				local jointScalable = parseBool(bone.jointScalable, skeleton.jointScalable)
				local jointRotatable = parseBool(bone.jointRotatable, skeleton.jointRotatable)
				local jointColor = bone.jointColor or skeleton.jointColor
				local jointAngle, jointSx, jointSy
				if jointRotatable then jointAngle = angle else jointAngle = 0 end
				if jointScalable then
					jointSx, jointSy = sx, sy
				else
					jointSx, jointSy = 1, 1
				end
				love.graphics.setColor(jointColor)
				transform(jointShape, jointAngle, x1, y1, jointSx, jointSy)
				love.graphics.polygon(jointMode, jointShape)
				transform(jointShape, 0, x2 - x1, y2 - y1, 1, 1)
				love.graphics.polygon(jointMode, jointShape)
			end
		end
		for _,childBone in pairs(bone.childBones) do
			drawBones(childBone, x2, y2, skeleton)
		end
	end
	for _,skeleton in pairs(self.skeletons) do
		if skeleton.show then
			for _,childBone in pairs(skeleton.childBones) do
				drawBones(childBone, skeleton.x, skeleton.y, skeleton)
			end
		end
	end
end

----------------------------------------------------
-- Module
----------------------------------------------------

return setmetatable({new = new},
	{__call = function(_, ...) return new(...) end})
