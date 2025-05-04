function onCreate()

  	makeLuaSprite('bg', 'Backgrounds/KKHTA/FOM/3', -1200, -300);
	addLuaSprite('bg', false);
  	setProperty('bg.antialiasing', true)
  	scaleObject('bg', 1.2, 1.2);
  	setScrollFactor('bg', 0.8, 0.8);

    makeLuaSprite('hills', 'Backgrounds/KKHTA/FOM/bgs', -1160, -300);
	addLuaSprite('hills', false);
  	setProperty('hills.antialiasing', true)
  	scaleObject('hills', 1.2, 1.2);

	makeAnimatedLuaSprite('GF','characters/kkhtagf', 525, 650)
	addAnimationByIndices("GF", "GF_DanceLeft", "GF_Dance", "30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13", 24)
	addAnimationByIndices("GF", "GF_DanceRight", "GF_Dance", "14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29", 24)
	addLuaSprite('GF', false);
	scaleObject('GF', 1, 1);

	danceDirection = "Left"
end

function onSongStart()
	setProperty("cameraSpeed", 1)
end

function onBeatHit()--for every beat
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