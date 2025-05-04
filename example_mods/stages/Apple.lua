function onCreate()
	makeLuaSprite('BG', 'Backgrounds/Apple/BG', -1600, -200);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 2.5, 2.5);

  	makeAnimatedLuaSprite('Toby','Backgrounds/Apple/Toby',-250, 480)
  	addAnimationByPrefix('Toby','idle','Toby',24, true)
  	addLuaSprite('Toby', false);
    scaleObject('Toby', 1, 1);
    setProperty('Toby.flipX', false)
    objectPlayAnimation('Toby','idle',true)

  end