function onCreate()
	makeLuaSprite('BG', 'Backgrounds/SC/BG_BF', -1585, -100);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 1.4, 1.4);

  	makeLuaSprite('Rem', 'Backgrounds/SC/BF_Remilia', -1600, -100);
	addLuaSprite('Rem', false);
  	setProperty('Rem.antialiasing', true)
  	scaleObject('Rem', 1.4, 1.4);

	makeAnimatedLuaSprite('Window','Backgrounds/SC/window2',-200, 250)
  	addAnimationByPrefix('Window','idle','Window',24, true)
  	addLuaSprite('Window', false);
    scaleObject('Window', 0.8, 0.8);


  	makeLuaSprite('bars', 'Backgrounds/SC/desk_BF', -1600, 1150);
	addLuaSprite('bars', true);
  	setProperty('bars.antialiasing', true)
  	scaleObject('bars', 1.2, 1.2);

  	  	makeLuaSprite('davinki', 'Backgrounds/SC/desk', -1600, 1150);
	addLuaSprite('davinki', true);
  	setProperty('davinki.antialiasing', true)
  	scaleObject('davinki', 1.2, 1.2);

	makeLuaSprite('glow', 'Backgrounds/SC/glow', -895, 0)
	addLuaSprite('glow', true)
	setProperty('glow.alpha', 0)

  	makeAnimatedLuaSprite('Border','Backgrounds/SC/Border',500, -150)
  	addAnimationByPrefix('Border','idle','Border',24, true)
  	addLuaSprite('Border', false);
   scaleObject('Border', 1.4, 1.6);
	epicOffset = 1100
	doingEpicEffects = false
	totalCircles = 0
	circlesSpeed = {}
	scarletElapsedTime = 0
--	setProperty("defaultCamZoom", 0.25)
end


function onUpdate(elapsed)
	scarletElapsedTime = scarletElapsedTime + elapsed

	if scarletElapsedTime >= 0.05 and doingEpicEffects then -- making it equal for all framerates
		if math.random(0, 15) == 1 then
			spawnEpicCircle()
		end
		scarletElapsedTime = 0
	end

	
	if not doingEpicEffects and totalCircles > 0 then
		for circle = 0,totalCircles - 1 do
			circlesSpeed[circle] = circlesSpeed[circle] + (500 * elapsed)
		end
	end

	for circle = 0,totalCircles - 1 do
		setProperty('circle'..circle..'.y', getProperty('circle'..circle..'.y') + elapsed * circlesSpeed[circle] * -1)
	end
end

function spawnEpicCircle()
	circlesSpeed[totalCircles] = math.random(250, 450)
	local randomside = math.random(0, 1)
	local whichside = ""
	local range = {}
	local scale = math.random(5, 17) / 100

	if randomside == 0 then whichside = "left" range = {-300, 600} else whichside = "right" range = {770, 1800} end

	makeLuaSprite('circle'..totalCircles, 'Backgrounds/SC/'..whichside..' circle', math.random(range[1], range[2]), 1400) -- 770, 1800
	scaleObject('circle'..totalCircles, scale, scale)
	addLuaSprite('circle'..totalCircles)
	totalCircles = totalCircles + 1
end

function onCreatePost()
	setProperty("dad.x", getProperty("dad.x") - epicOffset)
	setProperty("Window.x", getProperty("Window.x") - epicOffset)
	setProperty("davinki.x", getProperty("davinki.x") - epicOffset)
	setProperty("Rem.x", getProperty("Rem.x") - epicOffset)
	objectPlayAnimation('Border','idle',true)
	setProperty("cameraSpeed", 5)
	triggerEvent("Camera Follow Pos", 1750, 650)
end

function onSongStart()
	setProperty("cameraSpeed", 2)
end

function onBeatHit()
	if curBeat == 15 then
		triggerEvent("Camera Follow Pos", 800, 650)
		setProperty("defaultCamZoom", 0.6)
	end
end

function epiceffects()
	if not doingEpicEffects then
		doTweenAlpha("darkenbackground", "Rem", 0.6, 0.35, "cubeIn")
		doTweenAlpha("darkenbackgroundbf", "BG", 0.6, 0.35, "cubeIn")
		doTweenAlpha("darkenwindow", "Window", 0.6, 0.35, "cubeIn")
		doTweenAlpha("brightenglow", "glow", 0.65, 0.35, "backOut") -- Top 10 Plot Twists
		doingEpicEffects = true
	else
		doTweenAlpha("darkenbackground", "Rem", 1, 0.35, "cubeIn")
		doTweenAlpha("darkenbackgroundbf", "BG", 1, 0.35, "cubeIn")
		doTweenAlpha("darkenwindow", "Window", 1, 0.35, "cubeIn")
		doTweenAlpha("brightenglow", "glow", 0, 0.35, "cubeIn")
		doingEpicEffects = false
	end
end

function slidetotheright() -- real smooth
	doTweenX("slideopponent", "dad", getProperty("dad.x") + epicOffset + 15, 0.75, "cubeOut")
	doTweenX("slidewindow", "Window", getProperty("Window.x") + epicOffset + 15, 0.75, "cubeOut")
	doTweenX("slidedesk", "davinki", getProperty("davinki.x") + epicOffset + 15, 0.75, "cubeOut")
	doTweenX("slidebackground", "Rem", getProperty("Rem.x") + epicOffset + 15, 0.75, "cubeOut")
end

function onEvent(name)
    if name == 'Scarlet Calling Start' then
        slidetotheright()
    end

	if name == 'Scarlet Calling Effects' then
        epiceffects()
    end
end