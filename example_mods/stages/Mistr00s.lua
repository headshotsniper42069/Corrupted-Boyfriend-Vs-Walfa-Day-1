function onCreate()
	makeLuaSprite('BG', 'Backgrounds/Mistr00s/BG', -1600, -200);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 4, 2);
  	setObjectOrder('boyfriendGroup', 2)

  end

  function onStepHit()

     if curStep == 2065 then

          setObjectOrder('boyfriendGroup', 3)
	  end
	end