function onCreate()
	luaDebugMode = true
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Suwako' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'Arrows/Suwako_Arrow');

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
				setPropertyFromGroup('unspawnNotes', i, 'hitCausesMiss', true);
			end
		end
	end
end

function onCreatePost()
	makeLuaSprite("suwakoflash", "Suwako", -43, -24)
	setProperty("suwakoflash.alpha", 0)
	setObjectCamera("suwakoflash", "other")
	setGraphicSize("suwakoflash", 1366, 768)
	addLuaSprite("suwakoflash")
end

function noteMiss(id, direction, noteType, isSustainNote)
	if noteType == 'Suwako' then
		setProperty("suwakoflash.alpha", 1)
		doTweenAlpha("suwakoflash", "suwakoflash", 0, 2, "cubeIn")
		playSound("frog", 1)
    end
end