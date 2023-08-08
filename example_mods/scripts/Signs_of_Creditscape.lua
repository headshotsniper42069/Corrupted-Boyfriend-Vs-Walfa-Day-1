--Made by headshotsniper, name suggested by Mopsikus
--man please dont steal this i put hard work and spent 26 minutes of my time to this script

function onCreatePost()
	makeLuaSprite("sign", "Song Credits/"..songName, 20, 720)
	addLuaSprite("sign", true)
	setObjectCamera("sign", "hud")
	scaleObject("sign", 0.8, 0.8)
end

function onCountdownTick(swagCounter)
	if swagCounter == 0 then
		runTimer("delay", 0.5, 1)
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == "delay" then
		doTweenY("getup", "sign", getProperty("sign.height"), 0.5, "cubeOut")
	end

	if tag == "getdown" then
		doTweenY("getawayfromhere", "sign", 720, 0.5, "cubeIn")
	end
end

function onTweenCompleted(tag)
	if tag == "getup" then
		runTimer("getdown", 2.5, 1)
	end
end