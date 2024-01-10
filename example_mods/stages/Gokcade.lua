function onCreate()
	makeLuaSprite('BG', 'Backgrounds/Fumo/Meiling/fumobg', -1600, -200);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 1.8, 1.8);

  	makeAnimatedLuaSprite('Shrine Maid','Backgrounds/Fumo/Meiling/FG_Fumo',-200, 1200)
  	addAnimationByPrefix('Shrine Maid','idle','Reimu',24, false)
  	addLuaSprite('Shrine Maid', true);
   scaleObject('Shrine Maid', 1.3, 1.3);

   makeAnimatedLuaSprite('Cake Witch','Backgrounds/Fumo/Meiling/FG_Fumo',950, 1100)
  	addAnimationByPrefix('Cake Witch','idle','Patchy',24, false)
  	addLuaSprite('Cake Witch', true);
   scaleObject('Cake Witch', 1.3, 1.3);

   makeAnimatedLuaSprite('Food','Backgrounds/Fumo/Meiling/FG_Fumo',-1300, 1100)
  	addAnimationByPrefix('Food','idle','Youmu',24, false)
  	addLuaSprite('Food', true);
   scaleObject('Food', 1.3, 1.3);

   makeAnimatedLuaSprite('Cat','Backgrounds/Fumo/Meiling/CC',-1200, 650)
  	addAnimationByPrefix('Cat','idle','Chen',24, false)
  	addLuaSprite('Cat', false);
   scaleObject('Cat', 1.5, 1.5);

    makeAnimatedLuaSprite('9','Backgrounds/Fumo/Meiling/CC',-600, 720)
  	addAnimationByPrefix('9','idle','Cirno',24, false)
  	addLuaSprite('9', false);
   scaleObject('9', 1.5, 1.5);

   makeAnimatedLuaSprite('DJ Role','Backgrounds/Fumo/Meiling/DJ',620, 700)
  	addAnimationByPrefix('DJ Role','idle','Flandre',24, false)
  	addLuaSprite('DJ Role', false);
   scaleObject('DJ Role', 2, 2);

  end

  function onBeatHit()--for every beat
	if curBeat % 2 == 0 then
	    objectPlayAnimation('Shrine Maid','idle',true)
	    objectPlayAnimation('9','idle',true)
	    objectPlayAnimation('Cat','idle',true)
	    objectPlayAnimation('Cake Witch','idle',true)
	    objectPlayAnimation('Food','idle',true)
	    objectPlayAnimation('DJ Role','idle',true)
	end
end

function onSongStart()--for every beat
objectPlayAnimation('Shrine Maid','idle',true)
objectPlayAnimation('9','idle',true)
	    objectPlayAnimation('Cat','idle',true)
	    objectPlayAnimation('Cake Witch','idle',true)
	    objectPlayAnimation('Food','idle',true)
	    objectPlayAnimation('DJ Role','idle',true)
	end