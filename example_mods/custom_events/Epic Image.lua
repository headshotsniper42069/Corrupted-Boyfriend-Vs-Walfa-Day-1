function onEvent(eventName, value1, value2)
    if eventName == "Epic Image" then
        makeLuaSprite("stubbornimage", value1, 0, 0)
        addLuaSprite("stubbornimage")
        screenCenter("stubbornimage")
        setObjectCamera("stubbornimage", "other")
        runTimer("no longer stubborn", value2, 1)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "no longer stubborn" then
        setProperty("stubbornimage.alpha", 0)
    end
end