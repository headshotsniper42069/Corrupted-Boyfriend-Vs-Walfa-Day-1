function onCreate()
	makeLuaSprite('BG', 'Backgrounds/Hatstack/BGs', -1600, -200);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 1.8, 1.8);

  	    makeAnimatedLuaSprite('Sakuya','Backgrounds/Hatstack/BG_Chars',1820, 1090)
  	addAnimationByPrefix('Sakuya','idle','Sakuya_Bounce',24, false)
  	addLuaSprite('Sakuya', false);
    scaleObject('Sakuya', 0.6, 0.6);
    setProperty('Sakuya.flipX', false)

        makeAnimatedLuaSprite('Marisa','Backgrounds/Hatstack/BG_Chars',1600, 1100)
  	addAnimationByPrefix('Marisa','idle','Marisa_Bounce',24, false)
  	addLuaSprite('Marisa', false);
    scaleObject('Marisa', 0.7, 0.7);
    setProperty('Marisa.flipX', true)

        makeAnimatedLuaSprite('Patchy','Backgrounds/Hatstack/BG_Chars',1300, 1090)
  	addAnimationByPrefix('Patchy','idle','Patchy_Idle',24, false)
  	addLuaSprite('Patchy', false);
    scaleObject('Patchy', 0.7, 0.7);
    setProperty('Patchy.flipX', false)

    makeAnimatedLuaSprite('Rumia','Backgrounds/Hatstack/BG_Chars',400, 1200)
  	addAnimationByPrefix('Rumia','idle','Rumia_Bounce',24, false)
  	addLuaSprite('Rumia', false);
    scaleObject('Rumia', 0.9, 0.9);
    setProperty('Rumia.flipX', false)

     makeAnimatedLuaSprite('Meiling','Backgrounds/Hatstack/BG_Chars2',900, 1000)
  	addAnimationByPrefix('Meiling','idle','Meiling_Bounce',24, false)
  	addLuaSprite('Meiling', false);
    scaleObject('Meiling', 0.9, 0.9);
    setProperty('Meiling.flipX', false)

    makeAnimatedLuaSprite('Reimu','Backgrounds/Hatstack/BG_Chars2',-900, 1200)
  	addAnimationByPrefix('Reimu','Idle','Reimu_Bounce',24, false)
  	addLuaSprite('Reimu', false);
    scaleObject('Reimu', 0.9, 0.9);
    setProperty('Reimu.flipX', false)

    

    makeAnimatedLuaSprite('Aya','Backgrounds/Hatstack/BG_Chars',-600, 1150)
  	addAnimationByPrefix('Aya','Idle','Aya_Bounce',24, false)
  	addLuaSprite('Aya', false);
    scaleObject('Aya', 0.9, 0.9);
    setProperty('Aya.flipX', true)

    makeAnimatedLuaSprite('Koakuma','Backgrounds/Hatstack/BG_Chars',-900, 1350)
  	addAnimationByPrefix('Koakuma','Idle','Koakuma_Bounce',24, false)
  	addLuaSprite('Koakuma', false);
    scaleObject('Koakuma', 1, 1);
    setProperty('Koakuma.flipX', false)

  	makeLuaSprite('Table', 'Backgrounds/Hatstack/Tables', -270, 950);
	addLuaSprite('Table', false);
  	setProperty('Table.antialiasing', true)
  	scaleObject('Table', 1, 0.9);

	makeAnimatedLuaSprite('Koosh','Backgrounds/Hatstack/Koishi',200, 1200)
  	addAnimationByPrefix('Koosh','idle','Koishi_Bounce',24, false)
	addAnimationByPrefix('Koosh','stab','Koishi_Stab',24, false)
  	addLuaSprite('Koosh', false);
    scaleObject('Koosh', 0.9, 0.9);
    setProperty('Koosh.flipX', true)

    makeAnimatedLuaSprite('Tipsy','Backgrounds/Hatstack/Tipsy',-250, 1050)
  	addAnimationByPrefix('Tipsy','idle','Tipsy_Bounce',24, false)
	addAnimationByPrefix('Tipsy','stab','Tipsy_Stab',24, false)
  	addLuaSprite('Tipsy', false);
    scaleObject('Tipsy', 0.9, 0.9);

    makeAnimatedLuaSprite('Daiyousei','Backgrounds/Hatstack/Daiyousei',1050, 1050)
  	addAnimationByPrefix('Daiyousei','Idle','Dayiousei_Bounce',24, false)
  	addAnimationByPrefix('Daiyousei','scared','Dayiousei_Scared',24, false)
  	addLuaSprite('Daiyousei', false);
    scaleObject('Daiyousei', 0.9, 0.9);
    setProperty('Daiyousei.flipX', true)

	setProperty("camGame.alpha", 0)
	setProperty("cameraSpeed", 1000)
	setProperty("defaultCamZoom", 1.25)
	setProperty("camZoomingDecay", 1000)
end

function onSongStart()
	setProperty("cameraSpeed", 1000)
	setProperty("camGame.alpha", 1)
	setProperty("camHUD.alpha", 0)
	setProperty("camZoomingDecay", 1000)
	triggerEvent('Camera Follow Pos', "1100", "1350")
	setProperty("boyfriend.skipDance", true)
	setProperty("dad.skipDance", true)
end

function onBeatHit()--for every beat
	if curBeat % 2 == 0 then
	    objectPlayAnimation('Sakuya','idle',true)
		if curBeat < 209 then
	    	objectPlayAnimation('Koosh','idle',true)
		end
	    objectPlayAnimation('Marisa','idle',true)
	    objectPlayAnimation('Patchy','idle',true)
	    objectPlayAnimation('Rumia','idle',true)
	    objectPlayAnimation('Reimu','Idle',true)
	    objectPlayAnimation('Aya','Idle',true)
        objectPlayAnimation('Meiling','Idle',true)
	    objectPlayAnimation('Koakuma','Idle',true)
		objectPlayAnimation('Tipsy','idle',true)
		if curBeat > 56 and curBeat < 214 then
			objectPlayAnimation('Daiyousei','scared',true)
		else
			objectPlayAnimation('Daiyousei','Idle',true)
		end
	end

	if curBeat == 64 then
		setProperty("camHUD.alpha", 1)
		setProperty("defaultCamZoom", 0.4)
		setProperty("boyfriend.skipDance", false)
		setProperty("dad.skipDance", false)
		triggerEvent('Camera Follow Pos', "", "")
		setProperty("cameraSpeed", 1.6)
	end
	
	if curBeat == 65 then
		setProperty("camZoomingDecay", 1)
	end

	if curBeat == 209 then
		setProperty("camHUD.alpha", 0)
		setProperty("cameraSpeed", 1000)
		setProperty("camZoomingDecay", 1000)
		setProperty("defaultCamZoom", 1.25)
		setProperty("boyfriend.skipDance", true)
		setProperty("dad.skipDance", true)
	end

	if curBeat == 224 then
		setProperty("camHUD.alpha", 1)
		setProperty("defaultCamZoom", 0.4)
		triggerEvent('Camera Follow Pos', "", "")
		setProperty("boyfriend.skipDance", false)
		setProperty("dad.skipDance", false)
		setProperty("cameraSpeed", 1.6)
	end

	if curBeat == 225 then
		setProperty("camZoomingDecay", 1)
	end

	if curBeat == 352 then
		setProperty("camHUD.alpha", 0)
		setProperty("cameraSpeed", 1000)
		setProperty("camZoomingDecay", 1000)
		setProperty("defaultCamZoom", 1.25)
		setProperty("boyfriend.skipDance", true)
		setProperty("dad.skipDance", true)
	end

	if curBeat == 373 then
		setProperty("camGame.alpha", 0)
	end
end

function onStepHit()
	if curStep == 879 then
		setProperty('Koosh.x', 76)
		objectPlayAnimation('Koosh','stab',true)
		objectPlayAnimation('Tipsy','stab',true)
	end
	
	if curStep == 880 then
		setProperty('Koosh.alpha', 0)
		setProperty('Tipsy.alpha', 0)
	end
end

function onSectionHit()
	if getProperty("camHUD.alpha") == 0 then
		if mustHitSection then
			triggerEvent('Camera Follow Pos', "1100", "1350")
		else
			triggerEvent('Camera Follow Pos', "350", "1350")
		end
	else
	--	triggerEvent('Camera Follow Pos', "", "")
		if mustHitSection then
			setProperty("defaultCamZoom", 0.4)
		else
			setProperty("defaultCamZoom", 1)
		end
	end
end
