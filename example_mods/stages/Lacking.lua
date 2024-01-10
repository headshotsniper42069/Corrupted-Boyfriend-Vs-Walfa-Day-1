function onCreate()
	makeLuaSprite('BG', 'Backgrounds/Lacking/BG', -1600, -200);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 4, 4);

	makeAnimatedLuaSprite('Crowd','Backgrounds/Lacking/Crowd',-1450, 1500)
	addAnimationByPrefix('Crowd','idle','Crowd',24, false)
	addLuaSprite('Crowd', true);
	setProperty('Crowd.alpha', 0)

	makeAnimatedLuaSprite('Medic','Backgrounds/Lacking/ERT',-1450, 1100)
	addAnimationByPrefix('Medic','idle','Eirin_Bounce',24, false)
	addLuaSprite('Medic', false);
	setProperty('Medic.flipX', true)
	scaleObject('Medic', 0.8, 0.8);

	makeAnimatedLuaSprite('High','Backgrounds/Lacking/ERT',-1450, 1300)
	addAnimationByPrefix('High','idle','Reisen_Bounce',24, false)
	addLuaSprite('High', false);
	setProperty('High.flipX', true)
	scaleObject('High', 0.8, 0.8);

	makeAnimatedLuaSprite('Bnuy','Backgrounds/Lacking/ERT',-1350, 1500)
	addAnimationByPrefix('Bnuy','idle','Tewi_Bounce',24, false)
	addLuaSprite('Bnuy', false);
	setProperty('Bnuy.flipX', true)
	scaleObject('Bnuy', 0.8, 0.8);

	makeAnimatedLuaSprite('Keine','Backgrounds/Lacking/Keine',250, 1300)
	addAnimationByPrefix('Keine','idle','Keine_Bounce',24, false)
	addLuaSprite('Keine', false);
	scaleObject('Keine', 0.8, 0.8);
end

function onBeatHit()--for every beat
	if curBeat % 1 == 0 then
		objectPlayAnimation('Crowd','idle',true)
	end
	if curBeat % 2 == 0 then
		objectPlayAnimation('Medic','idle',true)
		objectPlayAnimation('High','idle',true)
		objectPlayAnimation('Bnuy','idle',true)
		objectPlayAnimation('Keine','idle',true)

	end
	if curBeat == 324 then
		setProperty('Crowd.alpha', 10)
	end
	if curBeat == 384 then
		setProperty('Crowd.alpha', 0)
end
end