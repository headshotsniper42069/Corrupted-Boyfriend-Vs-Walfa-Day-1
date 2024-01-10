function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Credits' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'Arrows/Credits');
		end
	end
	debugPrint("success")
end