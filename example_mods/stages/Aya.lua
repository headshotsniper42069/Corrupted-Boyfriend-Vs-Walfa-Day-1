local whichStage = 0
local stepToReturn = 256800

function onCreate()
	makeLuaSprite('BG', 'Backgrounds/Aya/BG', -600, -200);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 1.2, 1.2);

  	makeAnimatedLuaSprite('GF','Backgrounds/Aya/ayastage',400, 1400)
  	addAnimationByPrefix('GF','idle','GF',24, true)

  	scaleObject('GF', 1.2, 1.2);
  	objectPlayAnimation('GF','idle',true)

  	makeAnimatedLuaSprite('Suwako','Backgrounds/Aya/souls',2600, 1900)
  	addAnimationByPrefix('Suwako','idle','Suwako',24, true)
  	
  	scaleObject('Suwako', 1.2, 1.2);
  	objectPlayAnimation('Suwako','idle',true)

  		makeAnimatedLuaSprite('Hatate','Backgrounds/Aya/souls',900, 2200)
  	addAnimationByPrefix('Hatate','idle','Hatate',24, true)

  	scaleObject('Hatate', 1.2, 1.2);
  	objectPlayAnimation('Hatate','idle',true)

  		makeAnimatedLuaSprite('Sanae','Backgrounds/Aya/souls',2300, 1150)
  	addAnimationByPrefix('Sanae','idle','Sanae',24, true)

  	scaleObject('Sanae', 1.2, 1.2);
  	objectPlayAnimation('Sanae','idle',true)

  		makeAnimatedLuaSprite('Kanako','Backgrounds/Aya/souls',2400, 1700)
  	addAnimationByPrefix('Kanako','idle','Kanako',24, true)

  	scaleObject('Kanako', 1.2, 1.2);
  	objectPlayAnimation('Kanako','idle',true)

  	makeLuaSprite('overlay', 'Backgrounds/Aya/overlay', -600, -200);

  	setProperty('overlay.antialiasing', true)
  	scaleObject('overlay', 1.2, 1.2);

	scaleObject('Black', 3, 3);

	makeLuaSprite('Black', 'Backgrounds/Aya/Black', -700, -250);

	makeLuaSprite("pixelStage", "Backgrounds/Aya/pixel", 0, 0)
    scaleObject("pixelStage", 2, 2)
end

function onStepHit()

    if curStep == 576 then
        removeLuaSprite('Black', true)
		setProperty('cameraSpeed', 5)
		setProperty('dad.x', 1050)
        setProperty('dad.y', 1450)
		setProperty('boyfriend.x', 1750)
        setProperty('boyfriend.y', 1855)
		addLuaSprite('BG', false);
  		addLuaSprite('GF', false);
		addLuaSprite('Suwako', false);
		addLuaSprite('Hatate', true);
		addLuaSprite('Sanae', true);
		addLuaSprite('Kanako', true);
		addLuaSprite('overlay', true);
	end
	if curStep == 600 then
		setProperty('cameraSpeed', 1)
	end

	if curStep == 109 then
	    setProperty('dad.x', 100)
        setProperty('dad.y', 100)
    end

	if curStep == stepToReturn then
		setProperty('cameraSpeed', 1)
	end
end

function onBeatHit()--for every beat
	if curBeat % 2 == 0 then
	    objectPlayAnimation('gf','idle',true)
	end
end

function onSongStart()
	setProperty('timeBar.visible', false)
	setProperty('timeBarBG.visible', false)
	setProperty('timeTxt.visible', false)
	setProperty('dad.x', -1300)
	setProperty('dad.y', 900)
end

function onEvent(name, value1, value2)
	if name == 'Shameimaru Pixel Transition' then
		setProperty('cameraSpeed', 15)
		stepToReturn = curStep + 4
		if whichStage == 0 then
			whichStage = 1
			triggerEvent("Change Character", "dad", "pixelaya")
			triggerEvent("Change Character", "bf", "pixelbf")
			setProperty('dad.x', 1050)
			setProperty('dad.y', 1480)
			setProperty('boyfriend.x', 1850)
			setProperty('boyfriend.y', 1600)
		    setProperty('Hatate.alpha', 0)
		    setProperty('Sanae.alpha', 0)
		    setProperty('Kanako.alpha', 0)
			addLuaSprite("pixelStage")
		else
			whichStage = 0
			triggerEvent("Change Character", "dad", "shamei.bbm")
			triggerEvent("Change Character", "bf", "bf")
			setProperty('dad.x', 1050)
			setProperty('dad.y', 1450)
			setProperty('boyfriend.x', 1750)
			setProperty('boyfriend.y', 1855)
			setProperty('Hatate.alpha', 1)
		    setProperty('Sanae.alpha', 1)
		    setProperty('Kanako.alpha', 1)
			removeLuaSprite("pixelStage")
		end
	end
end