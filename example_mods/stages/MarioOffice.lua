function onCreate()
	-- background shit
	makeLuaSprite('mariooffice', 'mariooffice', -830, -250)
	scaleObject('mariooffice', 1.3, 1.3)
	
	makeLuaSprite('marioofficefront', 'marioofficefront', -830, -250)
	scaleObject('marioofficefront', 1.3, 1.3)
	
	addLuaSprite('mariooffice', false)
	setProperty('mariooffice.antialiasing',false)
	addLuaSprite('marioofficefront', true)
	setProperty('marioofficefront.antialiasing',false)
end