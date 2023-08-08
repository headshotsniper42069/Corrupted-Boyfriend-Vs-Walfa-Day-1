function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Jack Gives Cirno Brain Damage' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'Arrows/Jack_Shards')
		end
	end
end


function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if noteType == 'Jack Gives Cirno Brain Damage' then
        callOnLuas("absolutelyBonkers")
    end
end