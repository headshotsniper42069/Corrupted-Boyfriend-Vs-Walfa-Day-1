function onCreate()
	makeLuaSprite('BG', 'Backgrounds/Pelo/BF/BG', -600, -200);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 1.2, 1.2);

  	if songName == 'Perfectionism' then

  	makeAnimatedLuaSprite('Reimu','Backgrounds/Pelo/BF/Reimu',1500, 680)
  	addAnimationByPrefix('Reimu','idle','Reimu_Bounce',24, false)
  	addLuaSprite('Reimu', false);
  	scaleObject('Reimu', 0.8, 0.8);
  		setObjectOrder('boyfriendGroup', 2)
    setObjectOrder('gfGroup', 1)
  end
end

function onBeatHit()--for every beat
	if curBeat % 2 == 0 then
	    objectPlayAnimation('Reimu','idle',true)
	end
end