function onCreate()
	  makeLuaSprite('BG', 'Backgrounds/KRIMAS/Background', -600, -200);
	  addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 1.4, 1.4);

  	  	makeAnimatedLuaSprite('small','Backgrounds/KRIMAS/shikie',100, 100)
  	addAnimationByPrefix('small','idle','Shikie_Bounce',24, false)
  	addLuaSprite('small', false);
  	scaleObject('small', 1, 1);
  	setProperty('small.flipX', false)

  	  	makeAnimatedLuaSprite('mistr00s','Backgrounds/KRIMAS/mistr00s',-200, 400)
  	addAnimationByPrefix('mistr00s','idle','Mistr00s_Bounce',24, false)
  	addLuaSprite('mistr00s', false);
  	scaleObject('mistr00s', 1, 1);
  	setProperty('mistr00s.flipX', false)

  	makeLuaSprite('Desk', 'Backgrounds/KRIMAS/Desk', 300, 500);
	  addLuaSprite('Desk', false);
  	setProperty('Desk.antialiasing', true)
  	scaleObject('Desk', 1.4, 1.4);

  	makeLuaSprite('Tree', 'Backgrounds/KRIMAS/Tree', 1300, -100);
	  addLuaSprite('Tree', false);
  	setProperty('Tree.antialiasing', true)
  	scaleObject('Tree', 1.2, 1.2);

  	  	 	makeLuaSprite('shadow', 'Backgrounds/KRIMAS/shadow', 1400, 760);
	  addLuaSprite('shadow', false);
  	setProperty('shadow.antialiasing', true)
  	scaleObject('shadow', 1, 1);


  	makeAnimatedLuaSprite('Gay','Backgrounds/KRIMAS/P-M',2150, 200)
  	addAnimationByPrefix('Gay','idle','Couple_Bounce',24, false)
  	addLuaSprite('Gay', false);
  	scaleObject('Gay', 1, 1);
  	setProperty('Gay.flipX', false)

  		makeAnimatedLuaSprite('tomboy','Backgrounds/KRIMAS/Marisa',1850, 500)
  	addAnimationByPrefix('tomboy','idle','Marisa_Bounce',24, false)
  	addLuaSprite('tomboy', false);
  	scaleObject('tomboy', 1, 1);
  	setProperty('tomboy.flipX', true)

  	makeAnimatedLuaSprite('Mommy','Backgrounds/KRIMAS/FG',-150, 600)
  	addAnimationByPrefix('Mommy','idle','Yukari_Bounce',24, false)
  	addLuaSprite('Mommy', true);
  	scaleObject('Mommy', 1, 1);
  	setProperty('Mommy.flipX', false)

  	makeAnimatedLuaSprite('rember','Backgrounds/KRIMAS/FG',1550, 700)
  	addAnimationByPrefix('rember','idle','Yuuka_Bounce',24, false)
  	addLuaSprite('rember', true);
  	scaleObject('rember', 1, 1);
  	setProperty('rember.flipX', false)
  end

  	
function onBeatHit()--for every beat
	if curBeat % 2 == 0 then
	    objectPlayAnimation('Gay','idle',true)
	    objectPlayAnimation('Mommy','idle',true)
	     objectPlayAnimation('rember','idle',true)
	    objectPlayAnimation('small','idle',true)
	    objectPlayAnimation('mistr00s','idle',true)
	    objectPlayAnimation('tomboy','idle',true)
	    objectPlayAnimation('reimu','idle',true)
	end
end
	