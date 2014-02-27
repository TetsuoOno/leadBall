--
display.setStatusBar( display.HiddenStatusBar )

local physics = require("physics")
--physics.setDrawMode("hybrid")
physics.start()

local SE_coin = audio.loadSound( "Coin.mp3" )

local _W = display.contentWidth
local _H = display.contentHeight

local button = display.newImage("Button.png", _W/2, _H*4/5)
button.isVisible = false

--キャラクター
local myBall = display.newImage("ball.png", 30, 30)
physics.addBody( myBall, {density = 2, friction = 0.2, bounce = 0.5, radius = 20})

--コイン
local coin =  display.newImage("coin.png", math.random(20, _W-20), math.random(20, _H-20))
physics.addBody( coin, "kinematic", {isSensor = true})
-----------------------------------------------------------------------------

local walls = {
	display.newRect(3, _H/2, 6, _H),
	display.newRect(_W/2, 3, _W, 6),
	display.newRect(_W -3, _H/2, 6, _H),
	display.newRect(_W/2, _H -3, _W, 6)
}

for i=1, 4, 1 do
	physics.addBody( walls[i], "static", {} )
end
-----------------------------------------------------------------------------
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
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local function onAccelerometer( event )
	--端末の傾きに合わせて重力の方向を変化させる
	physics.setGravity( 9.8 *event.xGravity, -9.8 *event.yGravity )
end

Runtime:addEventListener( "accelerometer", onAccelerometer )
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
local function reset(event)
	if("ended" == event.phase)then
		coin.x = math.random(20, _W-20); coin.y = math.random(20, _H-20)
		coin.isVisible = true

		--button:removeEventListener("touch", reset)
		--button.isVisible = false
		Runtime:removeEventListener("touch", reset)
			
		physics.start()
	end
end
-----------------------------------------------------------------------------
local function moveCoin()
	coin.isVisible = false
	--button.isVisible = true
	--button:addEventListener("touch", reset)
	Runtime:addEventListener("touch", reset)
end

local function onCollision(event)
	if(event.phase == "began")then
		audio.play( SE_coin )
		physics.pause()
		moveCoin()
	end
end

coin:addEventListener("collision", onCollision)
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
