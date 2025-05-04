worried = false
elapsedTime = 0

function onCreatePost()
    triggerEvent('Change Character', "GF", "kkhtameilingworried")
    triggerEvent('Change Character', "GF", "kkhtameiling")
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'Glitching' then
        triggerEvent('Screen Shake', "0.25, 0.0025", "0.25, 0.0025")
        if getHealth() >= 0.01 then
            addHealth(-0.0475)
        end
        elapsedTime = 0
        if not worried then
            triggerEvent('Change Character', "GF", "kkhtameilingworried")
        end
        worried = true
	end
end

function onUpdate(elapsed)
    if worried then
        elapsedTime = elapsedTime + elapsed
        if elapsedTime >= 1 then
            worried = false
            elapsedTime = 0
            triggerEvent('Change Character', "GF", "kkhtameiling")
        end
    end

end