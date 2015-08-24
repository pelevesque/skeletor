-- get the relative path
local thispath = select('1', ...):match(".+%.") or ""
local parent = "unittests."
thispath = string.sub(thispath, 1, string.len(thispath) - string.len(parent))

-- load skeletor module
local Skeletor = require(thispath..'skeletor')
skeletor = Skeletor()

-- test skeletor:newSkeleton()
skeletor:newSkeleton('james', {x = 10, y = 100})
assert(skeletor.skeletons['james'].x == 10)
assert(skeletor.skeletons['james'].y == 100)
assert(skeletor.skeletons['james'].wireStyle == "smooth")

-- test skeletor:getSkeletonProp
skeletor:newSkeleton('vic', {x = 99})
assert(skeletor:getSkeletonProp('vic', 'x') == 99)

-- test skeletor:editSkeleton
skeletor:newSkeleton('kate', {x = 0, y = 10})
skeletor:editSkeleton('kate', {x = 1, y = 100, wireStyle = "test"})
assert(skeletor:getSkeletonProp('kate', 'x') == 1)
assert(skeletor:getSkeletonProp('kate', 'y') == 100)
assert(skeletor:getSkeletonProp('kate', 'wireStyle') == "test")

-- test skeletor:cloneSkeleton()
skeletor:newSkeleton('pete', {x = 1, y = 100, wireStyle = "test"})
skeletor:cloneSkeleton('pete', 'max')
assert(skeletor:getSkeletonProp('max', 'x') == 1)
assert(skeletor:getSkeletonProp('max', 'y') == 100)
assert(skeletor:getSkeletonProp('max', 'wireStyle') == "test")
skeletor:cloneSkeleton('max', 'joe', {x = 99, y = 10})
assert(skeletor:getSkeletonProp('joe', 'x') == 99)
assert(skeletor:getSkeletonProp('joe', 'y') == 10)

-- test skeletor:deleteSkeleton()
skeletor:newSkeleton('damien', {x = 10, y = 10})
skeletor:deleteSkeleton('damien')
assert(skeletor.skeletons['damien'] == nil)
