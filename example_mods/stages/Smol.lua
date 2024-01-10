function onCreate()
	makeLuaSprite('BG', 'Backgrounds/Smol/BG', -1600, -200);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 4, 2);

  	makeLuaSprite('Shrine', 'Backgrounds/Smol/Shrine', -50, 100);
	addLuaSprite('Shrine', false);
  	setProperty('Shrine.antialiasing', true)
  	scaleObject('Shrine', 1, 1);

	makeLuaSprite('playing', 'Backgrounds/Smol/playing', 0, 0)
	addLuaSprite('playing', false)
	setProperty('playing.antialiasing', true)
	scaleObject('playing', 0.3, 0.3);
	setObjectCamera('playing', 'hud')
	screenCenter('playing')
	setProperty('playing.x', getProperty('playing.x') - 850)

	makeAnimatedLuaSprite('Komachi','Backgrounds/Smol/Komachi',450, 500)
  	addAnimationByPrefix('Komachi','idle','Komachi_Bounce',24, false)
  	addLuaSprite('Komachi', false);
  	scaleObject('Komachi', 0.3, 0.3);
  	setLuaSpriteScrollFactor('Komachi',0.8,0.9)

  	makeLuaSprite('Shrine', 'Backgrounds/Smol/Shrine', -50, 100);
	addLuaSprite('Shrine', false);
  	setProperty('Shrine.antialiasing', true)
  	scaleObject('Shrine', 1, 1);
  	setLuaSpriteScrollFactor('Shrine',0.95,0.95)
end

function onSongStart()
	doTweenX('getin', 'playing', getProperty('playing.x') + 850, 0.5, 'cubeOut')
	runTimer('moveout', 3.5)
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'moveout' then
		doTweenY('getout', 'playing', 720, 0.5, 'cubeIn')
	end
end

function onBeatHit()--for every beat
	if curBeat % 2 == 0 then
	    objectPlayAnimation('Komachi','idle',true)
	end
end