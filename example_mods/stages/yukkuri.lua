local part2 = false

function onCreate()

	makeLuaSprite('Mountains', 'Backgrounds/Yukkuri/Mountains', -1300, -900);
	addLuaSprite('Mountains', false);
  	setProperty('Mountains.antialiasing', true)
  	scaleObject('Mountains', 0.8, 0.8);
  	  	setLuaSpriteScrollFactor('Mountains',0.8,0.9)

	makeLuaSprite('BG', 'Backgrounds/Yukkuri/ground', -1600, -200);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 1, 1);

  	 	makeAnimatedLuaSprite('Sakuya','Backgrounds/Yukkuri/S_N',-300, 200)
  	addAnimationByPrefix('Sakuya','idle','Sakuya',24, false)
  	addLuaSprite('Sakuya', true);
  	scaleObject('Sakuya', 1, 1);
  	setLuaSpriteScrollFactor('Sakuya',1.2,1.1)

  	 	makeAnimatedLuaSprite('Nitori','Backgrounds/Yukkuri/S_N',900, 200)
  	addAnimationByPrefix('Nitori','idle','Nitori',24, false)
  	addLuaSprite('Nitori', true);
  	scaleObject('Nitori', 1, 1);
  	setLuaSpriteScrollFactor('Nitori',1.2,1.1)

	makeLuaSprite('space', 'Backgrounds/Yukkuri/space', -1350, -1300);
	addLuaSprite('space', false);
	scaleObject('space', 1.2, 1.2);
	setProperty('space.antialiasing', true)
	setProperty('space.alpha', 0)
	
	makeAnimatedLuaSprite('gfspace', 'characters/yukkuri_gf_space', 900, 200)
  	addAnimationByPrefix('gfspace', 'idle', 'GF_Dance', 24, false)
  	addLuaSprite('gfspace', false)
	setProperty('gfspace.alpha', 0)
end

function onBeatHit()--for every beat
	if curBeat % 2 == 0 then
	    objectPlayAnimation('Sakuya','idle',true)
	    objectPlayAnimation('Nitori','idle',true)
		objectPlayAnimation('gfspace','idle',true)
	end
end

local lastCenterOriginX = 0
local lastCenterOriginY = 0
function onUpdate(elapsed)
	if part2 then
		setProperty('dad.angle', getProperty('dad.angle') - (15 * elapsed * getProperty('playbackRate')))
		setProperty('gfspace.angle', getProperty('gfspace.angle') + (20 * elapsed * getProperty('playbackRate')))
		if getProperty('gfspace.angle') >= 360 then
			setProperty('gfspace.angle', getProperty('gfspace.angle') - 360)
		end
		if getProperty('dad.angle') <= 0 then
			setProperty('dad.angle', getProperty('dad.angle') + 360)
		end
	end
end

function onUpdatePost(elapsed)
	if part2 then
		if getProperty('dad.animation.name') == 'laugh' then
			setProperty('dad.origin.x', 195)
			setProperty('dad.origin.y', 470)
		else
			setProperty('dad.origin.x', lastCenterOriginX)
			setProperty('dad.origin.y', lastCenterOriginY)
		end
	end
end

function onEvent(name, value1, value2)
    if name == "Easy Taker Part 2" then
        getToSpace()
    end
end

function onMoveCamera(focus)
	if part2 then
		if focus == 'boyfriend' then
			setProperty('defaultCamZoom', 0.5)
		elseif focus == 'gf' then
			setProperty('defaultCamZoom', 0.3)
		elseif focus == 'dad' then
			setProperty('defaultCamZoom', 0.4)
		end
	end
end

local yukkuriLastXpos = 0

function getToSpace()
	part2 = true
	setProperty("opponentCameraOffset", {700, -150})
	setProperty('Mountains.alpha', 0)
	setProperty('BG.alpha', 0)
	setProperty('Sakuya.alpha', 0)
	setProperty('Nitori.alpha', 0)
	setProperty('space.alpha', 1)
	setProperty('camZooming', true)
	setProperty('cameraSpeed', 2)
	setProperty('defaultCamZoom', 0.4)
	setProperty('dad.x', -800)
	setProperty('dad.y', -200)
--	triggerEvent('Change Character', "gf", "yukkuri_big")
	lastCenterOriginX = getProperty('dad.origin.x')
	lastCenterOriginY = getProperty('dad.origin.y')
	triggerEvent('Change Character', "bf", "yukkuri_bf_space")
	setProperty('gf.color', getColorFromHex("c1c1c1"))
	setProperty('dad.color', getColorFromHex("c1c1c1"))
	scaleObject('gfspace', 2, 2)
	setProperty('gf.x', 700)
	setProperty('gf.y', -600)
	setProperty('gfspace.alpha', 1)
	setProperty('gfspace.x', 1700)
	setProperty('gfspace.y', 600)
	scaleObject('boyfriend', 2, 2)
	setProperty('boyfriend.x', 800)
	setProperty('boyfriend.y', 840)
end