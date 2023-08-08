function onCreate()
	-- backgrounds shit
	makeLuaSprite('stageback', 'Backgrounds/Aya/stageback', -500, -550);
	scaleObject('Black', 3, 3);

	makeLuaSprite('Black', 'Backgrounds/Aya/Black', -700, -250);
	
	makeLuaSprite('stagefront', 'Backgrounds/Aya/stagefront', -650, 600);
	scaleObject('stagefront', 1.1, 1.1);

		makeLuaSprite('stagecurtains', 'Backgrounds/Aya/stagecurtains', -500, -300);

	makeLuaSprite('Layer', 'Backgrounds/Aya/Layer2', -650, -400);
	scaleObject('Layer', 4, 4);
end

function onStepHit()

     if curStep == 576 then

          removeLuaSprite('Black', true)
          addLuaSprite('stageback', false);
	      addLuaSprite('stagefront', false);
	      addLuaSprite('stagecurtains', false);
	      addLuaSprite('Layer', true);
	      addLuaSprite('Black', false);
	  end

	      if curStep == 109 then

	      	setProperty('dad.x', 100)
            setProperty('dad.y', 100)
      end

          if curStep == 493 then

	      	objectPlayAnimation('Fumo','idle',true)
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