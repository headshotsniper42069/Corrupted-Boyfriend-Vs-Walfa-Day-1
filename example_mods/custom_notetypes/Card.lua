function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Card' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'Arrows/Card')
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', 0.4)
		end
	end
end
function goodNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'Card' then
		playSound('Card', 0.7);
		playAnim('boyfriend', 'dodge', true)
		setProperty('boyfriend.specialAnim', true)
		playAnim('dad', 'card', true)
		setProperty('dad.specialAnim', true)
		for i = 0, getProperty('notes.length')-1 do
			if getPropertyFromGroup('notes', i, 'mustPress') == false then
				setPropertyFromGroup('notes', i, 'noAnimation', true)
			end
		end
		runTimer("makereimudanceagain", 0.375, 1)
	end
end
function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == 'Card' then
		playSound('Card', 0.7);
		playAnim('boyfriend', 'hurt', true)
		setProperty('boyfriend.specialAnim', true)
		playAnim('dad', 'card', true)
		setProperty('dad.specialAnim', true)
		for i = 0, getProperty('notes.length')-1 do
			if getPropertyFromGroup('notes', i, 'mustPress') == false then
				setPropertyFromGroup('notes', i, 'noAnimation', true)
			end
		end
		runTimer("makereimudanceagain", 0.375, 1)
	end
end
function onTimerCompleted(tag, loops, loopsLeft)
	if tag == "makereimudanceagain" then
		for i = 0, getProperty('notes.length')-1 do
			if getPropertyFromGroup('notes', i, 'mustPress') == false then
				setPropertyFromGroup('notes', i, 'noAnimation', false)
			end
		end
	end
end