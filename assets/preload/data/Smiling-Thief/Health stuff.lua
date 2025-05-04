local healthLerp = false

function onCreate()
    luaDebugMode = true
end
function onBeatHit()
    if curBeat == 96 then
        setProperty('health', 0.4)
        healthLerp = true
    end

    if curBeat == 104 then
        healthLerp = false
    end
end

function onUpdate(elapsed)
    if curBeat >= 96 and getProperty('health') > 1 then
        setProperty('health', 1)
    end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
    if curBeat >= 96 and getProperty('health') > 0.05 and not healthLerp and not isSustainNote then
        addHealth(-0.0115)
    end
end

function linearinterp(pos1, pos2, perc)
    return (1-perc)*pos1 + perc*pos2 -- Linear Interpolation
end