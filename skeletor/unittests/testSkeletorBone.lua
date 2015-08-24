-- get the relative path
local thispath = select('1', ...):match(".+%.") or ""
local parent = "unittests."
thispath = string.sub(thispath, 1, string.len(thispath) - string.len(parent))

-- load skeletor module
local Skeletor = require(thispath..'skeletor')
skeletor = Skeletor()

skeletor:newSkeleton('paul')

-- test skeletor:newBone()
skeletor:newBone('paul.arm', {length = 100, angle = 50})
assert(skeletor.skeletons['paul'].childBones['arm'].length == 100)
assert(skeletor.skeletons['paul'].childBones['arm'].angle == 50)

-- test skeletor:getBoneProp()
skeletor:newBone('paul.foot', {angle = 1032})
local prop = skeletor:getBoneProp('paul.foot', 'angle')
--assert(prop == 1032)

-- test skeletor:editBone()
skeletor:newBone('paul.head', {length = 10, angle = 20})
skeletor:editBone('paul.head', {length = 25, angle = 35})
assert(skeletor.skeletons['paul'].childBones['head'].length == 25)
assert(skeletor.skeletons['paul'].childBones['head'].angle == 35)

-- test skeletor:deleteBone()
skeletor:newBone('paul.toe')
assert(skeletor.skeletons['paul'].childBones['toe'] ~= nil)
skeletor:deleteBone('paul.toe')
assert(skeletor.skeletons['paul'].childBones['toe'] == nil)
