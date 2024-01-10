function onCreate()

	makeLuaSprite('BG', 'Backgrounds/Fumo/Suwako/fumobg', -1600, -200);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 1.8, 1.8);

  		makeLuaSprite('shadow', 'Backgrounds/Fumo/Suwako/shadows', -1600, -200);
	addLuaSprite('shadow', false);
  	setProperty('shadow.antialiasing', true)
  	scaleObject('shadow', 1.8, 1.8);

  	makeAnimatedLuaSprite('Dog','Backgrounds/Fumo/Suwako/FG_Fumo',-200, 1200)
  	addAnimationByPrefix('Dog','idle','Inu_Bounce',24, false)
  	addLuaSprite('Dog', true);
   scaleObject('Dog', 1.3, 1.3);

   makeAnimatedLuaSprite('Sleepy','Backgrounds/Fumo/Suwako/FG_Fumo',950, 1100)
  	addAnimationByPrefix('Sleepy','idle','Komachi_Bounce',24, false)
  	addLuaSprite('Sleepy', true);
   scaleObject('Sleepy', 1.3, 1.3);

   makeAnimatedLuaSprite('Buddhism','Backgrounds/Fumo/Suwako/FG_Fumo',-1300, 1100)
  	addAnimationByPrefix('Buddhism','idle','Byakuren_Bounce',24, false)
  	addLuaSprite('Buddhism', true);
   scaleObject('Buddhism', 1.5, 1.5);

  	makeAnimatedLuaSprite('big Sis','Backgrounds/Fumo/Suwako/SK',450, 635)
  	addAnimationByPrefix('big Sis','idle','Satori_Bounce',24, false)
  	addLuaSprite('big Sis', false);
    scaleObject('big Sis', 1.3, 1.3);

   	makeAnimatedLuaSprite('Baldi','Backgrounds/Fumo/Suwako/SK',1150, 640)
  	addAnimationByPrefix('Baldi','idle','Keine_Bounce',24, false)
  	addLuaSprite('Baldi', false);
   scaleObject('Baldi', 1.3, 1.3);

   makeAnimatedLuaSprite('DJ Role','Backgrounds/Fumo/Meiling/DJ',-820, 700)
  	addAnimationByPrefix('DJ Role','idle','Flandre',24, false)
  	setProperty('DJ Role.flipX', true) 
  	addLuaSprite('DJ Role', false);
   scaleObject('DJ Role', 2, 2);

  end

  function onBeatHit()--for every beat
	if curBeat % 2 == 0 then
	    objectPlayAnimation('big Sis','idle',true)
	    objectPlayAnimation('Baldi','idle',true)
	    objectPlayAnimation('Dog','idle',true)
	    objectPlayAnimation('Sleepy','idle',true)
	    	    objectPlayAnimation('DJ Role','idle',true)
	    objectPlayAnimation('Buddhism','idle',true)
	end
end