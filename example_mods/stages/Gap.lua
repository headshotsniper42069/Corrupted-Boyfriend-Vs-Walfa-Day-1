function onCreate()
	makeLuaSprite('BG', 'Backgrounds/Ciryes/BG', -1600, -200);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 2.5, 2.5);

  	makeAnimatedLuaSprite('Gaps','Backgrounds/Ciryes/R_C',-1900, 450)
  	addAnimationByPrefix('Gaps','idle','R_C',24, false)
  	addLuaSprite('Gaps', false);
    scaleObject('Gaps', 1, 1);

    makeAnimatedLuaSprite('Reimu','Backgrounds/Ciryes/Reimu',100, 250)
  	addAnimationByPrefix('Reimu','idle','Reimu',24, false)
  	addLuaSprite('Reimu', false);
    scaleObject('Reimu', 0.8, 0.8);

  end

  function onBeatHit()--for every beat
	if curBeat % 2 == 0 then
	    objectPlayAnimation('Gaps','idle',true)
	    objectPlayAnimation('Reimu','idle',true)
	end
end