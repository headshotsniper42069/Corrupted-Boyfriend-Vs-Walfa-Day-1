function onCreate()
	makeLuaSprite('BG', 'Backgrounds/Mukyu/BG', -950, -2000);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 1.6, 1.6);

  	makeLuaSprite('BG_LEFT', 'Backgrounds/Mukyu/BG_LEFT', -1250, -2300);
	addLuaSprite('BG_LEFT', true);
  	setProperty('BG_LEFT.antialiasing', true)
  	scaleObject('BG_LEFT', 1.6, 1.6);
  	setScrollFactor('BG_LEFT', 1.4, 1.4);

  	makeLuaSprite('BG_RIGHT', 'Backgrounds/Mukyu/BG_RIGHT', -450, -2300);
	addLuaSprite('BG_RIGHT', true);
  	setProperty('BG_RIGHT.antialiasing', true)
  	scaleObject('BG_RIGHT', 1.6, 1.6);
  	setScrollFactor('BG_RIGHT', 1.4, 1.4);
	luaDebugMode = true
end

function onCreatePost()
	setObjectOrder("BG_RIGHT", 249)
	makeLuaSprite("white", "", -1000, -1800)
	makeGraphic("white", 3500, 2500, "FFFFFF")
	setProperty("white.x", -5000)

	setObjectOrder("boyfriend", 251)

	makeAnimatedLuaSprite('bfdies', 'characters/bfdies', 845, -955)
	addAnimationByPrefix('bfdies', 'idle', 'BF_Dies', 10, false)
	setProperty('bfdies.alpha', 0)
end

function onUpdate(elapsed)
--	debugPrint(cameraX, ", ", cameraY)
end
  
function onStepHit()
--	debugPrint(curStep)

	if curStep == 656 then
		triggerEvent("Camera Follow Pos", "1007.5", "-881")
	end

	if curStep == 666 then -- LOL???
		setObjectOrder("boyfriend", 251)
		setObjectOrder("bfdies", 252)
		doTweenX("decimate", "white", -200, 0.25)
		setProperty("vocals.volume", 1)
		addLuaSprite("white", true)
		addLuaSprite('bfdies', true)
		setObjectOrder("BG_RIGHT", 249)
		setObjectOrder("white", 500)
		setObjectOrder("white", 250)
	end

	if curStep == 670 then
		setProperty("boyfriend.alpha", 0)
		setProperty("bfdies.alpha", 1)
		playAnim("bfdies", "idle", true)
	end

	if curStep == 680 then
		loadGraphic("BG_LEFT", "Backgrounds/Mukyu/BG_LEFT_2")
		loadGraphic("BG", "Backgrounds/Mukyu/BG2")
		setProperty("bfdies.alpha", 0)
		triggerEvent("Camera Follow Pos", "926.5", "-941.5")
		setProperty("cameraSpeed", 12)
	end

	if curStep == 682 then
		doTweenAlpha("whitegetback", "white", 0, 0.5, "cubeIn")
	end

	if curStep == 684 then
		setProperty("boyfriend.alpha", 1)
		setProperty("boyfriend.y", getProperty("boyfriend.y") - 1000)
	end

	if curStep == 688 then
		doTweenY("marisafloats", "boyfriend",  getProperty("boyfriend.y") + 1000, 1, "cubeOut")
	end

	if curStep == 692 then
		setProperty("cameraSpeed", 1)
		triggerEvent("Camera Follow Pos", "", "")
	end
end

function onBeatHit() -- x: 926.5, y: -941.5

end