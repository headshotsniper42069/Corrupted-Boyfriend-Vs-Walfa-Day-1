function onCreate()
	makeLuaSprite('BG', 'Backgrounds/Pelo/Remilia/BG', -950, -2000);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 1.2, 1.2);

  	makeLuaSprite('Moon', 'Backgrounds/Pelo/Remilia/Moon', -200, -2500);
	addLuaSprite('Moon', false);
  	setProperty('Moon.antialiasing', true)
  	scaleObject('Moon', 1.2, 1.2);
  	setScrollFactor('Moon', 1.2, 1.4);

  	makeLuaSprite('Fog', 'Backgrounds/Pelo/Remilia/Fog', -950, -2000);
	addLuaSprite('Fog', true);
  	setProperty('Fog.antialiasing', true)
  	scaleObject('Fog', 1.4, 1.4);
  	setScrollFactor('Fog', 1.4, 1.4);

  	makeLuaSprite('Fog2', 'Backgrounds/Pelo/Remilia/Fog 2', -950, -800);
	addLuaSprite('Fog2', true);
  	setProperty('Fog2.antialiasing', true)
  	scaleObject('Fog2', 1.4, 1.4);
  	setScrollFactor('Fog2', 1.4, 1.4);

  	makeLuaSprite('Ground', 'Backgrounds/Pelo/Remilia/Ground', -600, -200);
	addLuaSprite('Ground', false);
  	setProperty('Ground.antialiasing', true)
  	scaleObject('Ground', 1.2, 1.2);
  end