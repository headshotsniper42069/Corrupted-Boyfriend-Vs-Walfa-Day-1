function onCreate()
	makeLuaSprite('BG', 'Backgrounds/Fumo/Okuu/fumobg', -1600, -200);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 1.8, 1.8);

  		makeLuaSprite('shadow', 'Backgrounds/Fumo/Okuu/shadow', -1600, -200);
	addLuaSprite('shadow', false);
  	setProperty('shadow.antialiasing', true)
  	scaleObject('shadow', 1.8, 1.8);

  	makeAnimatedLuaSprite('Smol','Backgrounds/Fumo/Okuu/FG_Fumo',-70, 1200)
  	addAnimationByPrefix('Smol','idle','Shikie_Bounce',24, false)
  	addLuaSprite('Smol', true);
   scaleObject('Smol', 1.5, 1.5);

   makeAnimatedLuaSprite('Mommy','Backgrounds/Fumo/Okuu/FG_Fumo',950, 1100)
  	addAnimationByPrefix('Mommy','idle','Yuuka_Bounce',24, false)
  	addLuaSprite('Mommy', true);
   scaleObject('Mommy', 1.7, 1.7);

   makeAnimatedLuaSprite('Buddhist','Backgrounds/Fumo/Okuu/FG_Fumo',-1600, 900)
  	addAnimationByPrefix('Buddhist','idle','Miko_Bounce',24, false)
  	addLuaSprite('Buddhist', true);
   scaleObject('Buddhist', 1.5, 1.5);

  	makeAnimatedLuaSprite('DJ Role','Backgrounds/Fumo/Meiling/DJ',-820, 670)
  	addAnimationByPrefix('DJ Role','idle','Flandre',24, false)
  	setProperty('DJ Role.flipX', true) 
  	addLuaSprite('DJ Role', false);
   scaleObject('DJ Role', 1.3, 1.3);

   makeAnimatedLuaSprite('Bnuy','Backgrounds/Fumo/Okuu/TE',550, 655)
  	addAnimationByPrefix('Bnuy','idle','Tewi_Bounce',24, false)
  	addLuaSprite('Bnuy', false);
    scaleObject('Bnuy', 0.5, 0.5);

    makeAnimatedLuaSprite('Medical','Backgrounds/Fumo/Okuu/TE',-950, 835)
  	addAnimationByPrefix('Medical','idle','Eirin_Bounce',24, false)
  	addLuaSprite('Medical', false);
    scaleObject('Medical', 0.5, 0.5);

      makeAnimatedLuaSprite('ZUN','Backgrounds/Fumo/Okuu/Y',950, 805)
  	addAnimationByPrefix('ZUN','idle','Zun_Bounce',24, false)
  	addLuaSprite('ZUN', false);
    scaleObject('ZUN', 0.6, 0.6);


  end

  function onBeatHit()--for every beat
	if curBeat % 2 == 0 then
	    objectPlayAnimation('Buddhist','idle',true)
	    objectPlayAnimation('Medical','idle',true)
	    objectPlayAnimation('Smol','idle',true)
	    objectPlayAnimation('Bnuy','idle',true)
	    objectPlayAnimation('Mommy','idle',true)
	    objectPlayAnimation('ZUN','idle',true)
	    objectPlayAnimation('DJ Role','idle',true)


	end
end