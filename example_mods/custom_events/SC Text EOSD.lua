function onCreatePost()
    if downscroll then
        spelltextY = {553, 600}
    else
        spelltextY = {553, 20}
    end
    durationUntilTextGoesUp = 0
end

function onEvent(eventName, value1, value2)
    if eventName == "SC Text EOSD" then
        makeLuaSprite("stubborntext", "Spell Cards/"..value1.." Text" , 1280, spelltextY[1])
        addLuaSprite("stubborntext", true)
        setObjectCamera("stubborntext", "hud")
        scaleObject("stubborntext", 0.65, 0.65)
        doTweenX("go up", "stubborntext", 640, 0.5, "cubeOut")
        durationUntilTextGoesUp = value2
        runTimer("get out EOSD", 20, 1)
    end
end

function onTweenCompleted(tag)
    if tag == "go up" then
        runTimer("elevate", durationUntilTextGoesUp, 1)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "elevate" then -- or, well, its more like going down if youre in downscroll LOL
        doTweenY("going up but better", "stubborntext", spelltextY[2], 0.45, "cubeOut")
    end

    if tag == "get out EOSD" then -- https://www.youtube.com/watch?v=RcGyPrGhljQ
        doTweenAlpha("EOSDTextTween", "stubborntext", 0, 0.5, "cubeIn")
    end
end