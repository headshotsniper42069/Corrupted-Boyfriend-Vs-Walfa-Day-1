function onCreate()


  	makeLuaSprite('BG', 'Backgrounds/Mcdonalds/BG', -1600, -200);
	  addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 1, 1);

    makeLuaSprite('Overlay', 'Backgrounds/Mcdonalds/Overlayw', -1600, -200);
    addLuaSprite('Overlay', true);
    setProperty('Overlay.antialiasing', true)
    scaleObject('Overlay', 1, 1);


  end