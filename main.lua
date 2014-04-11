display.setStatusBar( display.HiddenStatusBar )

local physics = require("physics")
physics.start()

local SE_coin = audio.loadSound( "Coin.mp3" )

local _W = display.contentWidth
local _H = display.contentHeight

--背景
local back = display.newRect(_W/2, _H/2, _W, _H)
-----------------------------------------------------------------------------
--周囲の壁
local walls = {
	display.newRect(3, _H/2, 6, _H),
	display.newRect(_W/2, 3, _W, 6),
	display.newRect(_W -3, _H/2, 6, _H),
	display.newRect(_W/2, _H -3, _W, 6)
}

for i=1, 4, 1 do
	walls[i]:setFillColor(0.5, 0.3, 0.1)
	physics.addBody( walls[i], "static", {} )
end
-----------------------------------------------------------------------------
--キャラクター
local myBall = display.newImage("ball.png", 30, 30)
physics.addBody( myBall, {density = 2, friction = 0.2, bounce = 0.5, radius = 20})
--スリープさせない
myBall.isSleepingAllowed = false

--コイン
local coin =  display.newImage("coin.png", math.random(20, _W-20), math.random(20, _H-20))
physics.addBody( coin, "kinematic", {isSensor = true})
-----------------------------------------------------------------------------
--邪魔するオブジェクト
local rect = {
	display.newRect(math.random(_W/2, _W-100), math.random(100, _H-100), _W/2, 6),
	display.newRect(_W/3, _H/4, 6, _H/2-100),
	display.newRect(_W*2/3, _H*3/4, 6, _H/2-100)
}
	
for n=1, 3, 1 do
	rect[n]:setFillColor(0.5, 0.3, 0.1)
	physics.addBody( rect[n], "static", {} )
end
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
local function reset(event)
	if("ended" == event.phase)then
		coin.x = math.random(20, _W-20); coin.y = math.random(20, _H-20)
		coin.isVisible = true

		Runtime:removeEventListener("touch", reset)
		
		rect[1].x = math.random(100, _W-100); rect[1].y = math.random(100, _H-100)
		coin:toFront()
		physics.start()
	end
end
-----------------------------------------------------------------------------
local function onCollision(event)
	if(event.phase == "began")then
		audio.play( SE_coin )
		physics.pause()
		coin.isVisible = false
		Runtime:addEventListener("touch", reset)
	end
end

coin:addEventListener("collision", onCollision)
-----------------------------------------------------------------------------
--[[
--シミュレータでのデバッグ用
local function onCircle(event)
	if("began" == event.phase)then
		display.getCurrentStage():setFocus(event.target)
	--タッチしてドラッグしている時
	elseif("moved" == event.phase)then
		myBall.x = event.x
		myBall.y = event.y
	
	elseif("ended" == event.phase)then
		display.getCurrentStage():setFocus(nil)
	end
end

myBall:addEventListener("touch", onCircle)
--]]
-----------------------------------------------------------------------------
--加速度のfunction
local function onAccelerometer( event )
	--端末の傾きに合わせて重力の方向を変化させる
	physics.setGravity( 9.8 *event.xGravity, -9.8 *event.yGravity )
end

Runtime:addEventListener( "accelerometer", onAccelerometer )
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
