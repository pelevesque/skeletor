--[[
Title:     utils
Use:       utility functions used by skeletor
Author:    Pierre-Emmanuel Lévesque
Email:     pierre.e.levesque@gmail.com
Created:   August 11th, 2012
Copyright: Copyright 2012, Pierre-Emmanuel Lévesque
License:   MIT license - @see README.md
--]]

----------------------------------------------------
-- Module setup
----------------------------------------------------

local utils = {}
utils.__index = utils

--[[
	New (constructor)

	@return  table    metatable
--]]
local function new()
	return setmetatable({}, utils)
end

--[[
	Copies a single dimension table (shallow)

	@param   table    table
	@return  table    copied table
--]]
function utils:copyTableShallow(t)
	local copy = {}
	for k,v in pairs(t) do copy[k] = v end
	return copy
end

--[[
	Copies a multi dimension table (deep)

	@param   table    table
	@return  table    copied table
--]]
function utils:copyTableDeep(t)
	local copy = {}
	for k,v in pairs(t) do
		if type(v) == "table" then
			copy[k] = self:copyTableDeep(v)
		else
			copy[k] = v
		end
	end
	return copy
end

--[[
	Merges two single dimension tables

	Note: The values in t1 are overwritten by those in t2.

	@param   table    table 1
	@param   table    table 2
	@return  table    merged tables
	@uses    copyTableShallow()
--]]
function utils:mergeTablesShallow(t1, t2)
	local merged = self:copyTableShallow(t1)
	for k,v in pairs(t2) do merged[k] = v end
	return merged
end

--[[
	Splits a path

	Note: The character "." cannot begin or terminate a path.

	Example path: "this.is.a.path"

	@param   string   path
	@return  table    split path
--]]
function utils:splitPath(path)
	local parts = {}
	local needle = 1
	for pos in function() return string.find(path, '.', needle, true) end do
		table.insert(parts, string.sub(path, needle, pos - 1))
		needle = pos + 1
	end
	table.insert(parts, string.sub(path, needle))
	return parts
end

--[[
	Parses a value (returns value, or default if value is nil)

	@param   mixed    value
	@param   mixed    default value
	@return  mixed    parsed value
--]]
function utils:parseValue(v, default)
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
function utils:polarToCartesian(radius, angle)
	return radius * math.cos(angle), radius * math.sin(angle)
end

--[[
	Gets the distance between two points (using Pythagore's method)

	@param   number   x1
	@param   number   y1
	@param   number   x2
	@param   number   y2
	@return  number   distance
--]]
function utils:getDistanceBetweenPoints(x1, y1, x2, y2)
	return math.sqrt(math.pow((x2 - x1), 2) + math.pow((y2 - y1), 2))
end

--[[
	Rotates a vector

	@param   number   x
	@param   number   y
	@param   number   angle in radians
	@return  numbers  (x, y) rotated
--]]
function utils:rotate(x, y, angle)
	local a = math.atan2(y, x) + angle
	local d = math.sqrt(math.pow(x, 2) + math.pow(y, 2))
	return d * math.cos(a), d * math.sin(a)
end

--[[
	Scales a vector

	@param   number   x
	@param   number   y
	@param   number   scale factor of x
	@param   number   scale factor of y
	@return  numbers  (x, y) scaled
--]]
function utils:scale(x, y, sx, sy)
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
function utils:translate(x, y, ox, oy)
	return x + ox, y + oy
end

--[[
	Applies scaling, rotation, then translation to a set of vertices

	@param   table    vertices
	@param   number   angle in radians
	@param   number   offset factor of x
	@param   number   offset factor of y
	@param   number   scale factor of x
	@param   number   scale factor or y
	@return  void
	@uses    scale(), rotate(), translate()
--]]
function utils:transform(v, angle, ox, oy, sx, sy)
	for i = 1, #v, 2 do
		if sx ~= 1 or sy ~= 1 then v[i], v[i + 1] = self:scale(v[i], v[i + 1], sx, sy) end
		if angle ~= 0 then v[i], v[i + 1] = self:rotate(v[i], v[i+1], angle) end
		if ox ~= 0 or oy ~= 0 then v[i], v[i + 1] = self:translate(v[i], v[i + 1], ox, oy) end
	end
end

--[[
	Constant: 1 divided by PI
--]]
local constOneDividedByPI = 1 / math.pi

--[[
	Normalizes scaling from an angle

	@param   number   angle in radians
	@param   number   scale factor of x
	@param   number   scale factor of y
	@return  number   normalized scaling
	@uses    constOneDividedByPI
--]]
function utils:normalizeScalingFromAngle(angle, sx, sy)
	local factorY = math.abs((constOneDividedByPI * (angle % math.pi)) - .5)
	local factorX = .5 - factorY
	return (math.abs(sx) * factorX) + (math.abs(sy) * factorY)
end

--[[
	Gets the average of two numbers

	@param   number   number 1
	@param   number   number 2
	@return  number   average
--]]
function utils:getAverageOfTwoNums(n1, n2)
	return (n1 + n2) / 2
end

--[[
	Organizes two numbers in ascending order

	@param   number   n1
	@param   number   n2
	@return  numbers  numbers in ascending order (n1, n2)
--]]
function utils:orderTwoNumsAsc(n1, n2)
	if n2 < n1 then
		return n2, n1
	else
		return n1, n2
	end
end

--[[
	Updates box boundaries on grow

	@param   table    box boundaries
	@param   number   x1
	@param   number   y1
	@param   number   x2
	@return  number   y2
	@return  void
--]]
function utils:updateBoxBoundariesOnGrow(box, x1, y1, x2, y2)
	if x1 < box.x1 then box.x1 = x1 end
	if x2 > box.x2 then box.x2 = x2 end
	if y1 < box.y1 then box.y1 = y1 end
	if y2 > box.y2 then box.y2 = y2 end
end

--[[
	Gets the vertices of an ellipse

	@param   number   center x
	@param   number   center y
	@param   number   width
	@param   number   height
	@param   number   angle in radians
	@param   number   number of segments
	@return  table    vertices {x1, y1, x2, y2, ...}
--]]
function utils:getEllipseVertices(cx, cy, width, height, angle, numSegments)
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
		local vxT = vx
		vx = vy * math.sin(angle) + vx * math.cos(angle)
		vy = vxT * math.sin(angle) - vy * math.cos(angle)
		table.insert(vertices, vx + cx)
		table.insert(vertices, vy + cy)
		local xT = x
		x = (cosine * x) - (sine * y)
		y = (sine * xT) + (cosine * y)
	end
	return vertices
end

----------------------------------------------------
-- Module
----------------------------------------------------

return setmetatable({new = new},
	{__call = function(_, ...) return new(...) end})
