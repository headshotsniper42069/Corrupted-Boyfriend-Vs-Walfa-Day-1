function onCreate()

	local objects = "bg_objects"

	amountOfTwitterUsers = 150

	if getRandomBool(5) then
		objects = "bg_objects_chance"
	end
	makeLuaSprite('Sky', 'Backgrounds/Frostbite/sky', -1400, -700);
	addLuaSprite('Sky', false);
  	setProperty('Sky.antialiasing', true)
  	scaleObject('Sky', 1, 1);
  	setScrollFactor('Sky', 0.8, 0.8);

    makeLuaSprite('bg_snow', 'Backgrounds/Frostbite/bg_snow', -1500, -300);
	addLuaSprite('bg_snow', false);
  	setProperty('bg_snow.antialiasing', true)
  	scaleObject('bg_snow', 1, 1);

  	makeLuaSprite('bg_objects', 'Backgrounds/Frostbite/'..objects, -850, -200);
	addLuaSprite('bg_objects', false);
  	setProperty('bg_objects.antialiasing', true)
  	scaleObject('bg_objects', 1, 1);
  	setScrollFactor('bg_objects', 0.95, 0.95);

	makeLuaSprite('BG', 'Backgrounds/Frostbite/ground', -1600, -200);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 1, 1);

	makeAnimatedLuaSprite('Pyro', 'Backgrounds/Frostbite/pyro', 300, -750);
	addAnimationByPrefix("Pyro", "bounce", "pyro", 24, false)
	addLuaSprite('Pyro');
	setProperty('Pyro.antialiasing', true)

	makeAnimatedLuaSprite('Ripper', 'Backgrounds/Frostbite/ripper', -450, -80);
	addAnimationByPrefix("Ripper", "bounce", "ripper", 24, false)
	addLuaSprite('Ripper');
	setProperty('Ripper.antialiasing', true)

	makeAnimatedLuaSprite("diamondtester", "Backgrounds/Frostbite/Cirno Attacking", 300, 0, "sparrow")
	addAnimationByPrefix("diamondtester", "bounce", "Crystal_Idle", 24, false)
	addAnimationByPrefix("diamondtester", "shoot", "Crystal_Shoot", 64, false)
	addLuaSprite("diamondtester", true)

	makeAnimatedLuaSprite("jackvscirno", "Backgrounds/Frostbite/jackvscir", 400, -1200, "sparrow")
	addAnimationByPrefix("jackvscirno", "bonkers", "Ice", 64, false)
	setProperty("jackvscirno.alpha", 0)
	addLuaSprite("jackvscirno")

  	makeLuaSprite('Snow', 'Backgrounds/Frostbite/snowmans', -1300, -50);
	addLuaSprite('Snow', true);
  	setProperty('Snow.antialiasing', true)
  	scaleObject('Snow', 1, 1);
  	setScrollFactor('Snow', 1.1, 1.1);

	for particle=1,amountOfTwitterUsers do
		makeLuaSprite('particle'..particle, "", getRandomInt(-1280, 1280), getRandomInt(-720, 720))
		makeGraphic("particle"..particle, 20, 20, 'ffffff')
		addLuaSprite('particle'..particle, true)
	end

  	makeLuaSprite('Layer', 'Backgrounds/Frostbite/Layer1', -1400, -700);
	addLuaSprite('Layer', true);
  	setProperty('Layer.antialiasing', true)
  	scaleObject('Layer', 1, 1);

	elapsedTime = 0
	cirnocrystalidle = true
	cirnocrystaloffset = 0
end

function onUpdate(elapsed)
	elapsedTime = elapsedTime + elapsed
	setProperty("Pyro.y", -750 + (math.sin(elapsedTime * 3) * 16))
	setProperty("diamondtester.y", -100 + (math.sin(elapsedTime * 4.5) * 16) + cirnocrystaloffset)
	for particle=1,amountOfTwitterUsers do
		setProperty('particle'..particle..'.x', getProperty('particle'..particle..'.x') + (elapsed / 1.5) * 1050)
		setProperty('particle'..particle..'.y', getProperty('particle'..particle..'.y') + (elapsed / 1.5) * 950)
		if getProperty('particle'..particle..'.x') >= 1650 then
			setProperty('particle'..particle..'.x', getRandomInt(-1950, -550))
		end
		if getProperty('particle'..particle..'.y') >= 720 then
			setProperty('particle'..particle..'.y', getRandomInt(-1950, -550))
		end
	end
end

function shootJackInTheFace()
	cirnocrystalidle = false
	setProperty("diamondtester.x", -475)
	cirnocrystaloffset = 20
	objectPlayAnimation("diamondtester", "shoot", true)
	runTimer("cirnocrystal", 0.5)
	runTimer("sad", 0.25)
	playSound("CirnoShoots", 0.5, "shoot")
end

function absolutelyBonkers()
	objectPlayAnimation("jackvscirno", "bonkers", true)
	runTimer("braindamage", 0.2)
	runTimer("disappear", 0.275)
	runTimer("cirnoplayanimation", 0.5)
	setProperty("jackvscirno.alpha", 1)
end

function onPause()
	pauseSound("hurt")
	pauseSound("shoot")
end

function onResume()
	resumeSound("hurt")
	resumeSound("shoot")
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == "cirnocrystal" then
		cirnocrystalidle = true
		setProperty("dad.skipDance", false)
		for i = 0, getProperty('notes.length')-1 do
			if getPropertyFromGroup('notes', i, 'mustPress') == false then
				setPropertyFromGroup('notes', i, 'noAnimation', false)
			end
		end
	end
	if tag == "sad" then
		playAnim("dad", "shot", true)
		setProperty("dad.skipDance", true)
		setProperty("health", getProperty("health") + 0.0575)
		for i = 0, getProperty('notes.length')-1 do
			if getPropertyFromGroup('notes', i, 'mustPress') == false then
				setPropertyFromGroup('notes', i, 'noAnimation', true)
			end
		end
	end
	if tag == "braindamage" then
		playAnim("boyfriend", "shot", true)
		setProperty("boyfriend.skipDance", true)
		playSound("CirnoHurt", 0.5, "hurt")
		setProperty("health", getProperty("health") - 0.2875)
		for i = 0, getProperty('notes.length')-1 do
			if getPropertyFromGroup('notes', i, 'mustPress') == true then
				setPropertyFromGroup('notes', i, 'noAnimation', true)
			end
		end
	end
	if tag == "disappear" then
		setProperty("jackvscirno.alpha", 0)
	end
	if tag == "cirnoplayanimation" then
		setProperty("boyfriend.skipDance", false)
		for i = 0, getProperty('notes.length')-1 do
			if getPropertyFromGroup('notes', i, 'mustPress') == true then
				setPropertyFromGroup('notes', i, 'noAnimation', false)
			end
		end
	end
end

function onBeatHit()
	if curBeat % 2 == 0 then
		objectPlayAnimation("Pyro", "bounce", true)
		objectPlayAnimation("Ripper", "bounce", true)
	end
	if cirnocrystalidle then
		setProperty("diamondtester.x", 300)
		cirnocrystaloffset = 0
		objectPlayAnimation("diamondtester", "bounce", true)
	end
end

function onCountdownTick(swagCounter)
	if swagCounter == 0 or swagCounter == 2 then
		objectPlayAnimation("Pyro", "bounce", true)
		objectPlayAnimation("Ripper", "bounce", true)
	end
	objectPlayAnimation("diamondtester", "bounce", true)
end

function onSongStart()
	objectPlayAnimation("Pyro", "bounce", true)
	objectPlayAnimation("Ripper", "bounce", true)
	objectPlayAnimation("diamondtester", "bounce", true)
end