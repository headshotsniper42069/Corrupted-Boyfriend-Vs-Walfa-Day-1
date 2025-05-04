function onCreate()

  	makeAnimatedLuaSprite('BG','Backgrounds/Flanchan/BG',50, 1300)
  	addAnimationByPrefix('BG','idle','BG',24, true)
  	addLuaSprite('BG', false);
    scaleObject('BG', 1, 1);
 

    makeAnimatedLuaSprite('flanchan','Backgrounds/Flanchan/flanchan',1020, 1900)
  	addAnimationByPrefix('flanchan','idle','Flanchan',24, true)
  	addLuaSprite('flanchan', false);
    scaleObject('flanchan', 0.8, 0.8);


  end

  function onBeatHit()--for every beat
	if curBeat % 2 == 0 then
	        objectPlayAnimation('flanchan','idle',true)
	           objectPlayAnimation('BG','idle',true)
	end
end