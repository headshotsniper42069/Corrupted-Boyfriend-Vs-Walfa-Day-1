function onCreate()
	makeLuaSprite('BG', 'Backgrounds/Lacking/BG', -1600, -200);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 0.8, 0.8);
end