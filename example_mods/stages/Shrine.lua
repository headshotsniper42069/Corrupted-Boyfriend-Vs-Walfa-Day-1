function onCreate()
	  makeLuaSprite('BG', 'Backgrounds/Walfas/Shrine/BG', -600, -200);
	  addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 1.4, 1.4);
  	setObjectOrder('boyfriendGroup', 2)
    setObjectOrder('gfGroup', 1)

  	if songName == 'Da Ze' then
  	makeAnimatedLuaSprite('Cleaning','Backgrounds/Walfas/Shrine/Reimu_Cleaning',200, 820)
  	addAnimationByIndices("Cleaning", "sweepLeft", "Reimu_Cleaning", "0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14", 24)
	  addAnimationByIndices("Cleaning", "sweepRight", "Reimu_Cleaning", "15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30", 24)
  	addLuaSprite('Cleaning', false);
  	scaleObject('Cleaning', 1, 1);

    setObjectOrder('boyfriendGroup', 2)
    setObjectOrder('gfGroup', 1)
  end

    if songName == 'Incident Solvers' then

    setObjectOrder('boyfriendGroup', 2)
    setObjectOrder('dadGroup', 4)

    makeLuaSprite('BG', 'Backgrounds/Walfas/Shrine/BG_Solvers', -600, -200);
	  addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 1.4, 1.4);


    makeAnimatedLuaSprite('GF','Backgrounds/Walfas/Shrine/gf',825, 850)
	  addAnimationByIndices("GF", "GF_DanceLeft", "GF_Dance", "30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14", 24)
	  addAnimationByIndices("GF", "GF_DanceRight", "GF_Dance", "15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29", 24)
    addLuaSprite('GF', false);
    scaleObject('GF', 1, 1);

  	makeAnimatedLuaSprite('Green Reimu','Backgrounds/Walfas/Shrine/KS',1600, 900)
  	addAnimationByPrefix('Green Reimu','idle','Sanae_Bounce',24, false)
  	addLuaSprite('Green Reimu', false);
  	scaleObject('Green Reimu', 1, 1);
  	setProperty('Green Reimu.flipX', true)

  	makeAnimatedLuaSprite('Stevo','Backgrounds/Walfas/Shrine/CS',1750, 1000)
  	addAnimationByPrefix('Stevo','idle','Stevo_Bounce',24, false)
  	addLuaSprite('Stevo', false);
  	scaleObject('Stevo', 1, 1);
  	setProperty('Stevo.flipX', true)


  	makeAnimatedLuaSprite('Creepy','Backgrounds/Walfas/Shrine/KS', -150, 950)
  	addAnimationByPrefix('Creepy','idle','Koishi_Bounce',24, false)
  	addLuaSprite('Creepy', false);
  	scaleObject('Creepy', 1, 1);
  	setProperty('Creepy.flipX', true)

  	makeAnimatedLuaSprite('9','Backgrounds/Walfas/Shrine/CS', 0, 450)
  	addAnimationByPrefix('9','idle','Cirno_Bounce',24, false)
  	addLuaSprite('9', false);
  	scaleObject('9', 1, 1);
  	setProperty('9.flipX', false)

  	makeLuaSprite('Overlay', 'Backgrounds/Walfas/Shrine/Overlay', -600, -200);
	  addLuaSprite('Overlay', true);
  	setProperty('Overlay.antialiasing', true)
  	scaleObject('Overlay', 1.4, 1.4);

  	end
	if songName == "Da Ze" then
		danceDirection = "Right"
	else
		danceDirection = "Left"
	end
end

function onBeatHit()--for every beat
	if curBeat % 2 == 0 then
	    objectPlayAnimation('Green Reimu','idle',true)
	    objectPlayAnimation('Creepy','idle',true)
	    objectPlayAnimation('9','idle',true)
	    objectPlayAnimation('Stevo','idle',true)
	end
	if songName == 'Incident Solvers' and curBeat % 1 == 0 then
		objectPlayAnimation('GF','GF_Dance'..danceDirection,true)
		if danceDirection == "Left" then
			danceDirection = "Right"
		else
			danceDirection = "Left"
		end
	end
	if songName == 'Da Ze' and curBeat % 2 == 0 then
		objectPlayAnimation('Cleaning','sweep'..danceDirection,true)
		if danceDirection == "Left" then
			danceDirection = "Right"
		else
			danceDirection = "Left"
		end
	end
end

function onCountdownTick(swagCounter)
	if songName == 'Incident Solvers' then
		objectPlayAnimation('GF','GF_Dance'..danceDirection,true)
		if danceDirection == "Left" then
			danceDirection = "Right"
		else
			danceDirection = "Left"
		end
		if swagCounter == 0 or swagCounter == 2 or swagCounter == 4 then
			objectPlayAnimation('Green Reimu','idle',true)
			objectPlayAnimation('Creepy','idle',true)
			objectPlayAnimation('9','idle',true)
			objectPlayAnimation('Stevo','idle',true)
		end
	end
	if swagCounter == 0 or swagCounter == 2 or swagCounter == 4 then
		if songName == 'Da Ze' then
			objectPlayAnimation('Cleaning','sweep'..danceDirection,true)
			if danceDirection == "Left" then
				danceDirection = "Right"
			else
				danceDirection = "Left"
			end
		end
	end
end