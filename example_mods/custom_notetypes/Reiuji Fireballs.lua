function onCreate()
	luaDebugMode = true
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Reiuji Fireballs' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'Arrows/okuu');
			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
				setPropertyFromGroup('unspawnNotes', i, 'hitCausesMiss', true);
			end
		end
	end
end

function noteMiss(id, direction, noteType, isSustainNote)
	if noteType == 'Reiuji Fireballs' then
		setProperty('health', getProperty('health') - 0.25)
    end
end