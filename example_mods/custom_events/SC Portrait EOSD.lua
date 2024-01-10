function onCreatePost()
--    setProperty("camHUD.zoom", 0.5)
end

function onEvent(eventName, value1, value2)
    if eventName == "SC Portrait EOSD" then
        disappearing = false
        duration = value2
        makeLuaSprite("epicstubborn", "Spell Cards/"..value1, 1280, 160)
        addLuaSprite("epicstubborn")
        setObjectCamera("epicstubborn", "hud")
        doTweenX("moving 1", "epicstubborn", 705, 0.5, "cubeOut")
        scaleObject("epicstubborn", 0.6, 0.6);
        previousWidth = getProperty("epicstubborn.width")
    end
end

function onTweenCompleted(tag)
    if tag == "moving 1" then
        runTimer("disappear", duration, 1)
    end
end

function onUpdate(elapsed)
    if disappearing then
        amountToScaleEpicPortrait = elapsed
        previousWidth = math.floor(previousWidth * (1 + amountToScaleEpicPortrait))
        setGraphicSize("epicstubborn", previousWidth, 0, false);
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "disappear" then -- or, well, its more like going down if youre in downscroll LOL
        doTweenAlpha("disappearing", "epicstubborn", 0, 0.4, "linear")
        disappearing = true
    end
end

function onPause()
    pauseSound("spellcardsound")
end

function onResume()
    resumeSound("spellcardsound")
end