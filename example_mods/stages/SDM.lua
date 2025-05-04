function onCreate()

	makeAnimatedLuaSprite('BG','Backgrounds/KKHTA/Flan/BG',-600, 250)
  	addAnimationByPrefix('BG','idle','BG',24, true)
  	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
    scaleObject('BG', 3, 3);

	makeLuaSprite('balcony', 'Backgrounds/KKHTA/Flan/balcony', 400, 725)
	setProperty('balcony.antialiasing', true)
	scaleObject('balcony', 0.6, 0.6)
	
	makeLuaSprite('FG', 'Backgrounds/KKHTA/Flan/FG', 820, 1340)
	setProperty('FG.antialiasing', true)
	scaleObject('FG', 0.6, 0.6)

	makeAnimatedLuaSprite('rain','Backgrounds/KKHTA/Flan/rain', 400, 725)
  	addAnimationByPrefix('rain','idle','Rain', 12, true)
  	setProperty('rain.antialiasing', true)
    scaleObject('rain', 0.6, 0.6);
end

function onCreatePost()


end

function onBeatHit()
	if curBeat == 560 then
		setProperty('camGame.alpha', 0)
		setProperty('dad.alpha', 0)
		setProperty("defaultCamZoom", 0.85)
		setProperty("cameraSpeed", 50)

		triggerEvent("Camera Follow Pos", 1180, 1230)
		triggerEvent("Change Character", "bf", "kkhtakoishpov")

		removeLuaSprite('BG')
		
		addLuaSprite('balcony', false)
		addLuaSprite('FG', true)
		addLuaSprite('rain', true);
	end

	if curBeat == 564 then
		setProperty('camGame.alpha', 1)
	end
end