function onCreate()


    makeLuaSprite('hills', 'Backgrounds/KKHTA/Hills/bg', -1160, -300);
	addLuaSprite('hills', false);
  	setProperty('hills.antialiasing', true)
  	scaleObject('hills', 0.6, 0.6);
  	setScrollFactor('hills', 0.5, 0.5);

    makeLuaSprite('see', 'Backgrounds/KKHTA/Hills/sea', -1360, -300);
	addLuaSprite('see', false);
  	setProperty('see.antialiasing', true)
  	scaleObject('see', 0.6, 0.6);
  	setScrollFactor('see', 0.8, 0.8);

	makeLuaSprite('BG', 'Backgrounds/KKHTA/Hills/Ground', -1600, -200);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 0.6, 0.6);


  end