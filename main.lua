-- uncomment to run unit tests
-- require 'skeletor.unittests.run'

-- load the skeletor module with property adjustments
local Skeletor = require('skeletor.skeletor')
skeletor = Skeletor({
	boundariesCalculate	= true,
	boundariesShow = true,
	shapeShow = true
})

opts = {
	x = 400,
	y = 200,
	angle = 0,
	speed = 100,
	sx = 1,
	sy = 1,
	scaleSpeed = 1,
	boneArmLeftAngle = 150,
	boneArmLeftLength = 80
}

function love.load()
	skeletor:newSkeleton('man', {x = opts.x, y = opts.y, angle = opts.angle, sx = opts.sx, sy = opts.sy})
	skeletor:newBone('man.head', {
		length = 50,
		angle = math.rad(110),
		-- you can use utils methods when loading skeletor.
		-- this should be changed as it isn't transparent.
		-- the shape is modified for a more headlike shape.
		shapeShape = utils:getEllipseVertices(0, 0, 1, 1, math.rad(0), 30),
	})
	skeletor:newBone('man.head.body', {length = 100, angle = math.rad(90)})
	skeletor:newBone('man.head.armRight', {length = 80, angle = math.rad(30)})
	skeletor:newBone('man.head.armRight.forearm', {length = 40, angle = math.rad(300)})
	skeletor:newBone('man.head.armLeft', {length = opts.boneArmLeftLength, angle = math.rad(opts.boneArmLeftAngle)})
	skeletor:newBone('man.head.armLeft.forearm', {length = 40, angle = math.rad(30)})
	skeletor:newBone('man.head.body.legRight', {length = 100, angle = math.rad(45)})
	skeletor:newBone('man.head.body.legRight.foot', {length = 50, angle = math.rad(120)})
	skeletor:newBone('man.head.body.legLeft', {length = 100, angle = math.rad(100)})
	skeletor:newBone('man.head.body.legLeft.foot', {length = 50, angle = math.rad(160)})
end

function love.update(dt)

	-- move skeleton sideways
	if love.keyboard.isDown('left') then
		opts.x = opts.x - (opts.speed*dt)	
	elseif love.keyboard.isDown('right') then
		opts.x = opts.x + (opts.speed*dt)
	end
	skeletor:editSkeleton('man', {x = opts.x})
	
	-- move skeleton up and down
	if love.keyboard.isDown('up') then
		opts.y = opts.y - (opts.speed*dt)
	elseif love.keyboard.isDown('down') then
		opts.y = opts.y + (opts.speed*dt)
	end
	skeletor:editSkeleton('man', {y = opts.y})

	-- rotate skeleton
	if love.keyboard.isDown('q') then
		opts.angle = opts.angle + (opts.speed*dt)
	elseif love.keyboard.isDown('w') then
		opts.angle = opts.angle - (opts.speed*dt)
	end
	skeletor:editSkeleton('man', {angle = math.rad(opts.angle)})

	-- mofify x scale
	if love.keyboard.isDown('a') then
		opts.sx = opts.sx + (opts.scaleSpeed*dt)
	elseif love.keyboard.isDown('s') then
		opts.sx = opts.sx - (opts.scaleSpeed*dt)
	end
	skeletor:editSkeleton('man', {sx = opts.sx})

	-- mofify y scale
	if love.keyboard.isDown('z') then
		opts.sy = opts.sy + (opts.scaleSpeed*dt)
	elseif love.keyboard.isDown('x') then
		opts.sy = opts.sy - (opts.scaleSpeed*dt)
	end
	skeletor:editSkeleton('man', {sy = opts.sy})

	-- rotate arm left bone
	if love.keyboard.isDown('e') then
		opts.boneArmLeftAngle = opts.boneArmLeftAngle + (opts.speed*dt)
	elseif love.keyboard.isDown('r') then
		opts.boneArmLeftAngle = opts.boneArmLeftAngle - (opts.speed*dt)
	end
	skeletor:editBone('man.head.armLeft', {angle = math.rad(opts.boneArmLeftAngle)})

	-- mofify left arm's length
	if love.keyboard.isDown('d') then
		opts.boneArmLeftLength = opts.boneArmLeftLength - (opts.speed*dt)
	elseif love.keyboard.isDown('f') then
		opts.boneArmLeftLength = opts.boneArmLeftLength + (opts.speed*dt)
	end
	skeletor:editBone('man.head.armLeft', {length = opts.boneArmLeftLength})

end

function love.draw()
	love.graphics.setColor({255, 255, 255})
	love.graphics.print("- use arrows to move skeleton", 10, 10)
	love.graphics.print("- use q and w to rotate skeleton", 10, 30)
	love.graphics.print("- use a and s to modify x scaling", 10, 50)
	love.graphics.print("- use z and x to modify y scaling", 10, 70)
	love.graphics.print("- use e and r to rotate left arm", 10, 90)
	love.graphics.print("- use d and f to change the left arm's length", 10, 110)
	skeletor:draw()
end
