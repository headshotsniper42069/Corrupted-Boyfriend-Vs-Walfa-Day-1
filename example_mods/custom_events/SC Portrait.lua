function onEvent(eventName, value1, value2)
    if eventName == "SC Portrait" then
        duration = value2
        durationFast = duration / 6
        durationSlow = duration / 2
        durationAlpha = duration / 3
        makeLuaSprite("sheeshcard", "Spell Cards/"..value1, 1280, -50)
        addLuaSprite("sheeshcard")
        makeLuaSprite("smallflash", "", 0, 0)
        makeGraphic("smallflash", 1280, 720, "FFFFFF")
        addLuaSprite("smallflash")
        setObjectCamera("sheeshcard", "hud")
        setObjectCamera("smallflash", "hud")
        doTweenX("moving 1", "sheeshcard", 370, durationFast, "linear")
        doTweenY("moving down 1", "sheeshcard", 100, durationFast, "linear")
        playSound("spellcard", 0.25, "spellcardsound")
        setProperty("sheeshcard.alpha", 0)
        doTweenAlpha("think fast", "smallflash", 0, 0.35, "cubeOut")
        doTweenAlpha("Get Into The Screen", "sheeshcard", 1, durationAlpha / 4, "linear")
    end
end

function onTweenCompleted(tag)
    if tag == "moving 1" then
        doTweenX("moving 2", "sheeshcard", 240, durationSlow, "linear")
    end
    if tag == "moving 2" then
        doTweenX("moving 3", "sheeshcard", -640, durationFast, "linear")
        doTweenAlpha("Get Off The Screen", "sheeshcard", 0, durationAlpha, "linear")
    end
    if tag == "moving down 1" then
        doTweenY("moving down 2", "sheeshcard", 150, durationSlow, "linear")
    end
    if tag == "moving down 2" then
        doTweenY("moving down 3", "sheeshcard", 600, durationFast, "linear")
    end
end

function onPause()
    pauseSound("spellcardsound")
end

function onResume()
    resumeSound("spellcardsound")
end