-- get the relative path
local thispath = select('1', ...):match(".+%.") or ""
local parent = "unittests."
thispath = string.sub(thispath, 1, string.len(thispath) - string.len(parent))

-- load skeletor module
local Skeletor = require(thispath..'skeletor')
skeletor = Skeletor()

-- make sure skeletor.skeletons is set properly
assert(type(skeletor.skeletons) == 'table')
assert(next(skeletor.skeletons) == nil)

-- make sure skeletor.style is set properly
assert(type(skeletor.style) == 'table')
assert(next(skeletor.style) ~= nil)

-- test types of each default style
assert(type(skeletor.style['show']) == 'boolean')
assert(type(skeletor.style['boundariesCalculate']) == 'boolean')
assert(type(skeletor.style['boundariesShow']) == 'boolean')
assert(type(skeletor.style['boundariesStyle']) == 'string')
assert(type(skeletor.style['boundariesWidth']) == 'number')
assert(type(skeletor.style['boundariesColor']) == 'table')
assert(type(skeletor.style['wireShow']) == 'boolean')
assert(type(skeletor.style['wireStyle']) == 'string')
assert(type(skeletor.style['wireWidth']) == 'number')
assert(type(skeletor.style['wireColor']) == 'table')
assert(type(skeletor.style['jointShow']) == 'boolean')
assert(type(skeletor.style['jointMode']) == 'string')
assert(type(skeletor.style['jointShape']) == 'table')
assert(type(skeletor.style['jointRotatable']) == 'boolean')
assert(type(skeletor.style['jointScalable']) == 'boolean')
assert(type(skeletor.style['jointColor']) == 'table')
assert(type(skeletor.style['shapeShow']) == 'boolean')
assert(type(skeletor.style['shapeMode']) == 'string')
assert(type(skeletor.style['shapeShape']) == 'table')
assert(type(skeletor.style['shapeSx']) == 'number')
assert(type(skeletor.style['shapeSy']) == 'number')
assert(type(skeletor.style['shapeColor']) == 'table')
