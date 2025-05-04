function onCreate()


  	makeLuaSprite('Door', 'Backgrounds/Chen/Door', -1600, -200);
	addLuaSprite('Door', false);
  	setProperty('Door.antialiasing', true)
  	scaleObject('Door', 1.8, 1.8);

  	makeAnimatedLuaSprite('Ran','Backgrounds/Chen/Ran',-1500, 150)
  	addAnimationByPrefix('Ran','idle','Ran_Bounce',24, false)
  	addLuaSprite('Ran', false);
    scaleObject('Ran', 1.6, 1.6);

    	makeLuaSprite('BG', 'Backgrounds/Chen/BG', -1600, -200);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 1.8, 1.8);

  	makeAnimatedLuaSprite('Twerkchouli','Backgrounds/Chen/Twerkchouli',-300, 1350)
  	addAnimationByPrefix('Twerkchouli','idle','Patchy_Twerk',48, true)
  	addAnimationByPrefix('Twerkchouli','ass','Patchy_Idle',48, true)
  	addLuaSprite('Twerkchouli', true);
    scaleObject('Twerkchouli', 1.8, 1.8);


  end

  function onStartCountdown()
  	objectPlayAnimation('Twerkchouli','idle',true)
  end

  function onSongStart()
        objectPlayAnimation('Twerkchouli','ass',true)
end


  function onBeatHit()--for every beat
	if curBeat % 2 == 0 then
	    objectPlayAnimation('Ran','idle',true)
	    
	end
end