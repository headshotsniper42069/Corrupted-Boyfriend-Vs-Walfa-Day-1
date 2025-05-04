function onCreate()
	makeLuaSprite('Background', 'Backgrounds/ExRumia/OSANA_BG_1', -1900, 100);
	addLuaSprite('Background', false);
  	setProperty('Background.antialiasing', true)
  	scaleObject('Background', 1, 1);
  	setScrollFactor('Background', 1.2, 1.2);

	makeLuaSprite('BG', 'Backgrounds/ExRumia/OSANA_BG_2', -1600, -200);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 1, 1);

  	makeLuaSprite('Stone', 'Backgrounds/ExRumia/OSANA_BG_3', -1250, 50);
	addLuaSprite('Stone', true);
  	setProperty('Stone.antialiasing', true)
  	scaleObject('Stone', 0.8, 0.8);
  	setScrollFactor('Stone', 0.8, 0.8);
  	 setObjectOrder('boyfriendGroup', 2)

  end