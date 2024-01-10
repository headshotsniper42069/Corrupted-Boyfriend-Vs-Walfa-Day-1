function onCreate()
	luaDebugMode = true
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Lightning' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'Arrows/Lightning');

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
				setPropertyFromGroup('unspawnNotes', i, 'hitCausesMiss', true);
			end
		end
	end
end

function onCreatePost()
	makeLuaSprite("flash", "", 0, 0)
	makeGraphic("flash", 1280, 720, "0xFFFFFFFF")
	setProperty("flash.alpha", 0)
	setObjectCamera("flash", "other")
	addLuaSprite("flash")
	callOnLuas("initCameraShader")
end

function noteMiss(id, direction, noteType, isSustainNote)
	if noteType == 'Lightning' then
		setProperty("flash.alpha", 1)
		doTweenAlpha("flash", "flash", 0, 1.0, "cubeOut")
		playSound("Lightning", 1)
		callOnLuas("trigger")
    end
end