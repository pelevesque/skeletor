-- get the relative path
local thispath = select('1', ...):match(".+%.") or ""
local parent = "unittests."
thispath = string.sub(thispath, 1, string.len(thispath) - string.len(parent))

-- create a function to calculate a table size
-- @usedby -> test utils:mergeTablesShallow()
local function getTableSize(t)
	local count = 0
	for _ in pairs(t) do count = count + 1 end
	return count
end

-- load utils module
local Utils = require(thispath..'utils')
utils = Utils()

-- test utils:copyTableShallow()
local t = {x = 1, y = 2}
local tn = utils:copyTableShallow(t)
assert(tn.x == 1 and tn.y == 2)

-- test utils:copyTableDeep()
local t = {x = 1, base = { a = 2, b = 3 }}
local tn = utils:copyTableDeep(t)
assert(tn.x == 1 and tn.base.a == 2 and tn.base.b == 3)

-- test utils:mergeTablesShallow()
local t1 = {x = 1, y = 2, z = 3}
local t2 = {a = 1, z = 5}
local tn = utils:mergeTablesShallow(t1, t2)
assert(getTableSize(tn) == 4)
assert(tn.x == 1 and tn.y == 2 and tn.a == 1 and tn.z == 5)

-- test utils:splitPath()
local path = utils:splitPath('this.is.my.path')
assert(path[1] == 'this')
assert(path[2] == 'is')
assert(path[3] == 'my')
assert(path[4] == 'path')

-- test utils:parseValue()
local value = "value"
local default = "default"
assert(utils:parseValue(value, default) == "value")
assert(utils:parseValue(v, default) == "default")

-- test utils:polarToCartesian()
local x, y = utils:polarToCartesian(13, math.rad(22.6))
assert(math.floor(x) == 12 and math.ceil(y) == 5)

-- test utils:getDistanceBetweenPoints()
assert(utils:getDistanceBetweenPoints(10, 100, 100, 100) == 90)
assert(utils:getDistanceBetweenPoints(0, 10, 100, 0) == math.sqrt(10100))

-- test utils:rotate()
local x, y = utils:rotate(0, 0, math.rad(0))
assert(x == 0 and y == 0)

-- test utils:scale()
local x, y = utils:scale(1, 2, 0.5, 6)
assert(x == 0.5 and y == 12)

-- test utils:translate()
local x, y = utils:translate(2, 5, 10, 100)
assert(x == 12 and y == 105)

-- test utils:transform()
local v = {0, 0, 10, 10, 10, 0}
utils:transform(v, math.rad(0), 0, 0, 2, 4)
assert(v[1] == 0 and v[2] == 0 and v[3] == 20 and v[4] == 40 and v[5] == 20 and v[6] == 0)
utils:transform(v, math.rad(0), 10, 5, 1, 1)
assert(v[1] == 10 and v[2] == 5 and v[3] == 30 and v[4] == 45 and v[5] == 30 and v[6] == 5)

-- test utils:normalizeScalingFromAngle()
local scale = utils:normalizeScalingFromAngle(math.rad(0), 1, 1)
assert(scale == 0.5)
local scale = utils:normalizeScalingFromAngle(math.rad(180), 0.4, 1.6)
assert(scale == 0.8)

-- test utils:getAverageOfTwoNums()
assert(utils:getAverageOfTwoNums(10, 20) == 15)

-- test utils:orderTwoNumsAsc()
local n1, n2 = utils:orderTwoNumsAsc(1, 2)
assert(n1 == 1 and n2 == 2)
local n1, n2 = utils:orderTwoNumsAsc(2, 1)
assert(n1 == 1 and n2 == 2)

-- test utils:updateBoxBoundariesOnGrow()
local box = {x1 = 0, y1 = 100, x2 = 100, y2 = 0}
utils:updateBoxBoundariesOnGrow(box, 0, 100, 150, 150)
assert(box.x1 == 0 and box.y1 == 100 and box.x2 == 150 and box.y2 == 150)

-- test utils:getEllipseVertices()
local v = utils:getEllipseVertices(0, 0, 10, 10, math.rad(0), 4)
assert(v[1] == 5)
assert(v[2] == 0)
assert(v[4] == -5)
assert(v[5] == -5)
assert(v[8] == 5)
