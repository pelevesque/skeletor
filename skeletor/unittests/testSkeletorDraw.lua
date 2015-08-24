-- get the relative path
local thispath = select('1', ...):match(".+%.") or ""
local parent = "unittests."
thispath = string.sub(thispath, 1, string.len(thispath) - string.len(parent))

-- load skeletor module
local Skeletor = require(thispath..'skeletor')
skeletor = Skeletor()

-- make a skeleton with a bone with everything drawn
-- to fully test skeleton:draw()
skeletor:newSkeleton('man', {
	boundariesCalculate = true,
	boundariesShow = true,
	wireShow = true,
	jointShow = true,
	shapeShow = true
})
skeletor:newBone('man.foot')

-- test skeletor:draw
skeletor:draw()
