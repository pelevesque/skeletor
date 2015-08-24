--[[
Title:     skeletor
Use:       2D animation module for the LÖVE 2D game engine
Version:   1.0
Author:    Pierre-Emmanuel Lévesque
Email:     pierre.e.levesque@gmail.com
Created:   August 11th, 2012
Copyright: Copyright 2012, Pierre-Emmanuel Lévesque
License:   MIT license - @see README.md
--]]

----------------------------------------------------
-- Inclue utils.lua
----------------------------------------------------

local thispath = select('1', ...):match(".+%.") or ""
local Utils = require(thispath.."utils")
utils = Utils()

----------------------------------------------------
-- Module setup
----------------------------------------------------

local skeletor = {}
skeletor.__index = skeletor

--[[
	Default style

	uses@    utils:getEllipseVertices()
--]]
local defaultStyle = {
	show = true,
	boundariesCalculate = false,
	boundariesShow = false,
	boundariesStyle = "smooth",
	boundariesWidth = 1,
	boundariesColor = {0, 0, 255},
	wireShow = true,
	wireStyle = "smooth",
	wireWidth = 1,
	wireColor = {255, 255, 255},
	jointShow = true,
	jointMode = "fill",
	jointShape = utils:getEllipseVertices(0, 0, 8, 8, math.rad(0), 30),
	jointRotatable = false,
	jointScalable = true,
	jointColor = {255, 0, 0 },
	shapeShow = false,
	shapeMode = "line",
	shapeShape = utils:getEllipseVertices(0, 0, 1, .35, 0, 30),
	shapeSx = 1,
	shapeSy = 1,
	shapeColor = {125, 255, 125},
}

--[[
	New (constructor)

	@param   table    style [def: {}]
	@param   table    skeletons [def: {}]
	@return  table    metatable
	@uses    utils:mergeTablesShallow()
--]]
local function new(style, skeletons)
	return setmetatable({
		style = utils:mergeTablesShallow(defaultStyle, style or {}),
		skeletons = skeletons or {}
	}, skeletor)
end

----------------------------------------------------
-- Getters and setters
----------------------------------------------------

function skeletor:getStyle() return self.style end
function skeletor:setStyle(style) self.style = utils:mergeTablesShallow(self.style, style) end
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
	@uses    utils:parseValue()
--]]
function skeletor:newSkeleton(name, props)
	props = props or {}
	self.skeletons[name] = {
		x = props.x or 0,
		y = props.y or 0,
		sx = props.sx or 1,
		sy = props.sy or 1,
		angle = props.angle or 0,
		show = utils:parseValue(props.show, self.style.show),
		boundariesCalculate = utils:parseValue(props.boundariesCalculate, self.style.boundariesCalculate),
		boundariesShow = utils:parseValue(props.boundariesShow, self.style.boundariesShow),
		boundariesStyle = props.boundariesStyle or self.style.boundariesStyle,
		boundariesWidth = props.boundariesWidth or self.style.boundariesWidth,
		boundariesColor = props.boundariesColor or self.style.boundariesColor,
		wireShow = utils:parseValue(props.wireShow, self.style.wireShow),
		wireStyle = props.wireStyle or self.style.wireStyle,
		wireWidth = props.wireWidth or self.style.wireWidth,
		wireColor = props.wireColor or self.style.wireColor,
		jointShow = utils:parseValue(props.jointShow, self.style.jointShow),
		jointMode = props.jointMode or self.style.jointMode,
		jointShape = props.jointShape or self.style.jointShape,
		jointRotatable = utils:parseValue(props.jointRotatable, self.style.jointRotatable),
		jointScalable = utils:parseValue(props.jointScalable, self.style.jointScalable),
		jointColor = props.jointColor or self.style.jointColor,
		shapeShow = utils:parseValue(props.shapeShow, self.style.shapeShow),
		shapeMode = props.shapeMode or self.style.shapeMode,
		shapeShape = props.shapeShape or self.style.shapeShape,
		shapeSx = props.shapeSx or self.style.shapeSx,
		shapeSy = props.shapeSy or self.style.shapeSy,
		shapeColor = props.shapeColor or self.style.shapeColor,
		boundaries = {},
		childBones = {}
	}
	self.skeletons[name].boundaries.x1 = 99999
	self.skeletons[name].boundaries.y1 = 99999
	self.skeletons[name].boundaries.x2 = -99999
	self.skeletons[name].boundaries.y2 = -99999
end

--[[
	Gets a property from a skeleton

	@param   string   skeleton's name
	@param   string   property's key (name)
	@return  mixed    property's value
--]]
function skeletor:getSkeletonProp(name, propName)
	return self.skeletons[name][propName]
end

--[[
	Edits a skeleton

	@param   string   skeleton's name
	@param   table    properties to edit
	@return  void
--]]
function skeletor:editSkeleton(name, props)
	for k,v in pairs(props) do
		self.skeletons[name][k] = v
	end
end

--[[
	Clones a skeleton

	@param   string   name of the skeleton to clone from
	@param   string   name of the new skeleton
	@param   table    skeleton properties to edit
	@return  void
	@uses    utils:copyDeepTable(), skeletor:editSkeleton()
--]]
function skeletor:cloneSkeleton(fromName, toName, props)
	self.skeletons[toName] = utils:copyTableDeep(self.skeletons[fromName])
	self:editSkeleton(toName, props or {})
end

--[[
	Deletes a skeleton

	@param   string   skeleton's name
	@return  void
--]]
function skeletor:deleteSkeleton(name)
	self.skeletons[name] = nil
end

--[[
	Creates a new bone

	@param   string   path
	@param   table    properties
	@return  void
	@uses    utils:parseValue(), utils:splitPath()
--]]
function skeletor:newBone(path, props)
	local function newBone(path, i, bone, props)
		if #path == i then
			bone[path[i]] = {
				length = props.length or 0,
				sx = props.sx or 1,
				sy = props.sy or 1,
				angle = props.angle or 0,
				show = utils:parseValue(props.show, true),
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
			newBone(path, i + 1, bone[path[i]].childBones, props)
		end
	end
	newBone(utils:splitPath(path), 1, self.skeletons, props or {})
end

--[[
	Fetches a bone, with option to delete

	@param   string   bone's path
	@param   number   path index
	@param   table    table containing bones
	@param   bool     delete bone upon finding it
	@return  table    bone
--]]
local function fetchBone(path, i, bones, delete)
	if delete == nil then delete = false end
	if #path == i then
		if delete then
			bones[path[i]] = nil
		else
			bone = bones[path[i]]
		end
	else
		fetchBone(path, i + 1, bones[path[i]].childBones, delete)
	end
	return bone
end

--[[
	Gets a property from a bone

	@param   string   bone's path
	@param   string   property's key (name)
	@return  mixed    property's value
	@uses    fetchBone(), utils:splitPath()
--]]
function skeletor:getBoneProp(path, propName)
	local bone = fetchBone(utils:splitPath(path), 1, self.skeletons)
	return bone[proName]

end

--[[
	Edits a bone

	@param   string   path
	@param   table    properties
	@return  void
	@uses    fetchBone(), utils:splitPath()
--]]
function skeletor:editBone(path, props)
	local bone = fetchBone(utils:splitPath(path), 1, self.skeletons)
	for k,v in pairs(props) do
		bone[k] = v
	end
end

--[[
	Deletes a bone

	@param   string   path
	@return  void
	@uses    fetchBone(), utils:splitPath()
--]]
function skeletor:deleteBone(path)
	fetchBone(utils:splitPath(path), 1, self.skeletons, true)
end

--[[
	Draws the skeletons

	@return  void
	@uses    utils:scale(), utils:polarToCartesian(), utils:translate(), utils:getDistanceBetweenPoints()
	@uses    utils:getAverageOfTwoNums, utils:orderTwoNumsAsc, utils:updateBoxBoundariesOnGrow
	@uses    utils:parseValue, utils:copyTableShallow, utils:normalizeScalingFromAngle
--]]
function skeletor:draw()
	local function drawBones(bone, x1, y1, skeleton)
		local sx, sy = utils:scale(bone.sx, bone.sy, skeleton.sx, skeleton.sy)
		local angle = bone.angle + skeleton.angle
		local x2, y2 = utils:polarToCartesian(bone.length, angle)
		x2, y2 = utils:scale(x2, y2, sx, sy)
		x2, y2 = utils:translate(x2, y2, x1, y1)
		angle = math.atan2(y2 - y1, x2 - x1)
		local length = utils:getDistanceBetweenPoints(x1, y1, x2, y2)
		local xAverage = utils:getAverageOfTwoNums(x1, x2)
		local yAverage = utils:getAverageOfTwoNums(y1, y2)
		if skeleton.boundariesCalculate then
			local x1T, x2T = utils:orderTwoNumsAsc(x1, x2)
			local y1T, y2T = utils:orderTwoNumsAsc(y1, y2)
			utils:updateBoxBoundariesOnGrow(skeleton.boundaries, x1T, y1T, x2T, y2T)
		end
		if bone.show then
			if utils:parseValue(bone.wireShow, skeleton.wireShow) then
				local wireStyle = bone.wireStyle or skeleton.wireStyle
				local wireWidth = bone.wireWidth or skeleton.wireWidth
				local wireColor = bone.wireColor or skeleton.wireColor
				love.graphics.setLineStyle(wireStyle)
				love.graphics.setLineWidth(wireWidth)
				love.graphics.setColor(wireColor)
				love.graphics.line(x1, y1, x2, y2)
			end
			if utils:parseValue(bone.jointShow, skeleton.jointShow) then
				local jointMode = bone.jointMode or skeleton.jointMode
				local jointShape = utils:copyTableShallow(bone.jointShape or skeleton.jointShape)
				local jointScalable = utils:parseValue(bone.jointScalable, skeleton.jointScalable)
				local jointRotatable = utils:parseValue(bone.jointRotatable, skeleton.jointRotatable)
				local jointColor = bone.jointColor or skeleton.jointColor
				local jointAngle, jointSx, jointSy
				if jointRotatable then jointAngle = angle else jointAngle = 0 end
				if jointScalable then jointSx, jointSy = sx, sy else jointSx, jointSy = 1, 1 end
				love.graphics.setColor(jointColor)
				-- draw joints at both ends of bone
				utils:transform(jointShape, jointAngle, x1, y1, jointSx, jointSy)
				love.graphics.polygon(jointMode, jointShape)
				utils:transform(jointShape, 0, x2 - x1, y2 - y1, 1, 1)
				love.graphics.polygon(jointMode, jointShape)
			end
			if utils:parseValue(bone.shapeShow, skeleton.shapeShow) then
				local shapeMode = bone.shapeMode or skeleton.shapeMode
				local shapeShape = utils:copyTableShallow(bone.shapeShape or skeleton.shapeShape)
				local shapeSx = bone.shapeSx or skeleton.shapeSx
				local shapeSy = bone.shapeSy or skeleton.shapeSy
				local shapeColor = bone.shapeColor or skeleton.shapeColor
				utils:transform(
					shapeShape,
					angle,
					xAverage,
					yAverage,
					length * shapeSx,
					length * shapeSy * utils:normalizeScalingFromAngle(angle, sx, sy)
				)
				love.graphics.setColor(shapeColor)
				love.graphics.polygon(shapeMode, shapeShape)
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
			if skeleton.boundariesCalculate and skeleton.boundariesShow then
				love.graphics.setLineWidth(skeleton.boundariesWidth)
				love.graphics.setLineStyle(skeleton.boundariesStyle)
				love.graphics.setColor(skeleton.boundariesColor)
				love.graphics.rectangle(
					"line",
					skeleton.boundaries.x1,
					skeleton.boundaries.y1,
					skeleton.boundaries.x2 - skeleton.boundaries.x1,
					skeleton.boundaries.y2 - skeleton.boundaries.y1
				)
			end

		end
	end
end

----------------------------------------------------
-- Module
----------------------------------------------------

return setmetatable({new = new},
	{__call = function(_, ...) return new(...) end})
