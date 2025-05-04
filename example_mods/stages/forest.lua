function onCreate()
	makeLuaSprite('BG', 'Backgrounds/Forest/floor', -1600, -200);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 0.9, 0.9);

  	

  	makeLuaSprite('overlay', 'Backgrounds/Forest/overlay', -1600, -200);
	addLuaSprite('overlay', true);
  	setProperty('overlay.antialiasing', true)
  	scaleObject('overlay', 0.9, 0.9);


  end