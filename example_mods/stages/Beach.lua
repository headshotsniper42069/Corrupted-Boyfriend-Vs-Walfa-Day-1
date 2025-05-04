function onCreate()

	makeLuaSprite('BG', 'Backgrounds/Fumo/Suwako/fumobg', -1600, -200);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 1.8, 1.8);

  		makeLuaSprite('shadow', 'Backgrounds/Fumo/Suwako/shadows', -1600, -200);
	addLuaSprite('shadow', false);
  	setProperty('shadow.antialiasing', true)
  	scaleObject('shadow', 1.8, 1.8);

  	makeAnimatedLuaSprite('Dog','Backgrounds/Fumo/Suwako/FG_Fumo',0, 1200)
  	addAnimationByPrefix('Dog','idle','Inu_Bounce',24, false)
  	addLuaSprite('Dog', true);
    scaleObject('Dog', 1.3, 1.3);

   makeAnimatedLuaSprite('Sleepy','Backgrounds/Fumo/Suwako/FG_Fumo',750, 1100)
  	addAnimationByPrefix('Sleepy','idle','Komachi_Bounce',24, false)
  	addLuaSprite('Sleepy', true);
   scaleObject('Sleepy', 1.1, 1.1);

   makeAnimatedLuaSprite('Buddhism','Backgrounds/Fumo/Suwako/FG_Fumo',-1300, 1100)
  	addAnimationByPrefix('Buddhism','idle','Byakuren_Bounce',24, false)
  	addLuaSprite('Buddhism', true);
   scaleObject('Buddhism', 1.3, 1.3);

  	makeAnimatedLuaSprite('big Sis','Backgrounds/Fumo/Suwako/SK',450, 565)
  	addAnimationByPrefix('big Sis','idle','Satori_Bounce',24, false)
  	addLuaSprite('big Sis', false);
    scaleObject('big Sis', 0.5, 0.5);

   	makeAnimatedLuaSprite('Baldi','Backgrounds/Fumo/Suwako/SK',1150, 640)
  	addAnimationByPrefix('Baldi','idle','Keine_Bounce',24, false)
  	addLuaSprite('Baldi', false);
   scaleObject('Baldi', 1.3, 1.3);

   makeAnimatedLuaSprite('DJ Role','Backgrounds/Fumo/Meiling/DJ',-820, 700)
  	addAnimationByPrefix('DJ Role','idle','Flandre',24, false)
  	setProperty('DJ Role.flipX', true) 
  	addLuaSprite('DJ Role', false);
   scaleObject('DJ Role', 2, 2);

   makeAnimatedLuaSprite('GF','characters/fumo_gf', 130, 965)
   addAnimationByPrefix("GF", "GF_DanceLeft", "GF_DanceLeft", 24)
   addAnimationByPrefix("GF", "GF_DanceRight", "GF_DanceRight", 24)
   addLuaSprite('GF', false);
   scaleObject('GF', 0.6, 0.6);

	danceDirection = "Left"
end

function onUpdatePost(elapsed)
	if getProperty('GF.animation.name') == 'GF_DanceRight' then
		setProperty('GF.origin.x', -85)
		setProperty('GF.origin.y', -229)
	else
		setProperty('GF.origin.x', -100)
		setProperty('GF.origin.y', -229)
	end
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
	if curBeat % 1 == 0 then
		objectPlayAnimation('GF','GF_Dance'..danceDirection,true)
		if danceDirection == "Left" then
			danceDirection = "Right"
		else
			danceDirection = "Left"
		end
	end
end

function onCountdownTick(swagCounter)
	objectPlayAnimation('GF','GF_Dance'..danceDirection,true)
	if danceDirection == "Left" then
		danceDirection = "Right"
	else
		danceDirection = "Left"
	end
end
