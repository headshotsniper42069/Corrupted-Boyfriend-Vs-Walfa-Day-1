function onStartCountdown()
    setProperty("dad.skipDance", true)
    playAnim("dad", "intro", true, false, 0)
end

function onSongStart()
    setProperty("dad.skipDance", false)
end