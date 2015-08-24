-- get the relative path
local thispath = select('1', ...):match(".+%.") or ""
local parent = "unittests."
thispath = string.sub(thispath, 1, string.len(thispath) - string.len(parent))

-- load skeletor module
local Skeletor = require(thispath..'skeletor')
skeletor = Skeletor()

-- test skeletor:getStyle()
local style = skeletor:getStyle()

assert(type(style['show']) == 'boolean')
assert(type(style['boundariesCalculate']) == 'boolean')
assert(type(style['boundariesShow']) == 'boolean')
assert(type(style['boundariesStyle']) == 'string')
assert(type(style['boundariesWidth']) == 'number')
assert(type(style['boundariesColor']) == 'table')
assert(type(style['wireShow']) == 'boolean')
assert(type(style['wireStyle']) == 'string')
assert(type(style['wireWidth']) == 'number')
assert(type(style['wireColor']) == 'table')
assert(type(style['jointShow']) == 'boolean')
assert(type(style['jointMode']) == 'string')
assert(type(style['jointShape']) == 'table')
assert(type(style['jointRotatable']) == 'boolean')
assert(type(style['jointScalable']) == 'boolean')
assert(type(style['jointColor']) == 'table')
assert(type(style['shapeShow']) == 'boolean')
assert(type(style['shapeMode']) == 'string')
assert(type(style['shapeShape']) == 'table')
assert(type(style['shapeSx']) == 'number')
assert(type(style['shapeSy']) == 'number')
assert(type(style['shapeColor']) == 'table')

-- test skeletor:setStyle()
skeletor:setStyle({wireStyle = "test", shapeSx = 999999})
local style = skeletor:getStyle()
assert(style.wireStyle == "test" and style.shapeSx == 999999)

-- test skeletor:getSkeletons
local skeletons = skeletor:getSkeletons()
assert(type(skeletons) == "table")
assert(next(skeletons) == nil)

-- test skeletor:setSkeletons
skeletor:setSkeletons({name = "joe", x = 1})
local skeletons = skeletor:getSkeletons()
assert(type(skeletons) == "table")
assert(next(skeletons) ~= nil)
assert(skeletons.name == "joe")
assert(skeletons.x == 1)
