function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Cirno Shoots' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'Arrows/Ice_Shards')
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', -0.1)
            setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
		end
	end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'Cirno Shoots' then
        callOnLuas("shootJackInTheFace")
	end
end