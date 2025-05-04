local noteDirections = {"Left", "Down", "Up", "Right"}
local shots = 0

function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == "Patchouli's Ass Water" then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'Arrows/Fire');

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
			--	setPropertyFromGroup('unspawnNotes', i, 'missHealth', 0.35)
			end
		end
	end
end

--function onCreatePost()
--	makeAnimatedLuaSprite("fire", "Backgrounds/Mukyu/fire", 160, -1150)
--	addAnimationByPrefix("fire", "shoot", "Fire", 40, false)
--	addLuaSprite("fire", true)
--	setProperty("fire.angle", 15)
--end

--function onSongStart()
--	doTweenX("fireX", "fire", 2180, 0.5)
--	doTweenY("fireY", "fire", -300, 0.5)
--end

function goodNoteHit(id, noteData, noteType, isSustainNote)
	shots = shots + 1
	if noteType == "Patchouli's Ass Water" then

		makeAnimatedLuaSprite("fire"..shots, "Backgrounds/Mukyu/fire", 160, -1150)
		addAnimationByPrefix("fire"..shots, "shoot", "Fire", 40, false)
		addLuaSprite("fire"..shots, true)

		playAnim("fire"..shots, "shoot", true)
		setProperty("fire"..shots..".x", 160)
		setProperty("fire"..shots..".y", -1150)

        if curBeat < 172 then
			triggerEvent("Play Animation", "attack", "dad")
			triggerEvent("Play Animation", "dodge"..noteDirections[noteData + 1], "bf")

			setProperty("fire"..shots..".angle", 15)
			doTweenX("fireX"..shots, "fire"..shots, 2180, 0.25, "cubeIn")
			doTweenY("fireY"..shots, "fire"..shots, -300, 0.25, "cubeIn")

			runTimer("fire"..shots, 0.25)
		else
			triggerEvent("Play Animation", "attack", "dad")
			triggerEvent("Play Animation", "dodge", "bf")

			setProperty("fire"..shots..".angle", 10)
			doTweenX("fireX"..shots, "fire"..shots, 2180, 0.25, "cubeIn")
			doTweenY("fireY"..shots, "fire"..shots, -700, 0.25, "cubeIn")

			runTimer("fire"..shots, 0.25)
		end

		removeLuaSprite("BG_RIGHT", false)
		addLuaSprite("BG_RIGHT", true)
	end
end



function noteMiss(id, noteData, noteType, isSustainNote)
	shots = shots + 1
	if noteType == "Patchouli's Ass Water" then

		makeAnimatedLuaSprite("fire"..shots, "Backgrounds/Mukyu/fire", 160, -1150)
		addAnimationByPrefix("fire"..shots, "shoot", "Fire", 40, false)
		addLuaSprite("fire"..shots, true)

		playAnim("fire"..shots, "shoot", true)
		setProperty("fire"..shots..".x", 160)
		setProperty("fire"..shots..".y", -1150)

        if curBeat < 172 then
			triggerEvent("Play Animation", "attack", "dad")

			setProperty("fire"..shots..".angle", 15)

			doTweenX("fireX"..shots, "fire"..shots, 2180, 0.25, "cubeIn")
			doTweenY("fireY"..shots, "fire"..shots, -300, 0.25, "cubeIn")

			runTimer("fire"..shots, 0.19)
		else
			triggerEvent("Play Animation", "attack", "dad")

			setProperty("fire"..shots..".angle", 10)

			doTweenX("fireX"..shots, "fire"..shots, 2180, 0.25, "cubeIn")
			doTweenY("fireY"..shots, "fire"..shots, -700, 0.25, "cubeIn")

			runTimer("fire"..shots, 0.21)
		end

		removeLuaSprite("BG_RIGHT", false)
		addLuaSprite("BG_RIGHT", true)
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	cancelTween(tag)
	removeLuaSprite(tag, true)
end