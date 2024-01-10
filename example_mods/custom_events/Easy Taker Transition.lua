local alphaDuration = 0.5

function onEvent(name, value1, value2)
    if name == "Easy Taker Transition" then
        makeLuaSprite("easytakertransition", 0, 0)
        makeGraphic("easytakertransition", 1280, 720, "000000")
        addLuaSprite("easytakertransition")
        setObjectCamera("easytakertransition", "other")
        runTimer("easytakerfadeout", value1, 1)
        alphaDuration = value2
    end
end

function onTimerCompleted(name)
    if name == "easytakerfadeout" then
        doTweenAlpha("easytakerduration", "easytakertransition", 0, alphaDuration, "cubeIn")
    end
end