function onCreate()
	makeLuaSprite('BG', 'Backgrounds/Indie/Puppet/BG', -1600, -200);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', false)
  	scaleObject('BG', 6, 6);
end