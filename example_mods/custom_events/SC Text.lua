function onCreate()
    scaleImage = false
    scaleDownAmount = 0;
end

function onCreatePost()
    if downscroll then
        spelltextY = {-10, 600}
    else
        spelltextY = {553, -60}
    end
    scaleAmount = (2145 / framerate) / 3
end

function onEvent(eventName, value1, value2)
    if eventName == "SC Text" then
        makeLuaSprite("spell card disaster disspelling disinfecting gaming", "Spell Cards/"..value1.." Text" , 440, spelltextY[1])
        addLuaSprite("spell card disaster disspelling disinfecting gaming", true)
        setObjectCamera("spell card disaster disspelling disinfecting gaming", "hud")
        setObjectOrder("spell card disaster disspelling disinfecting gaming", getProperty("members.length") - 1)
    --    runTimer("Scale", 0.4, 1)
        scaleImage = true
        setProperty("spell card disaster disspelling disinfecting gaming.alpha", 0)
        doTweenAlpha("pop up", "spell card disaster disspelling disinfecting gaming", 1, 0.3, "linear")
        runTimer("get out spell", 20, 1)
    end
end

function onTweenCompleted(tag)
    if tag == "pop up" then
        runTimer("elevate", 0.85, 1)
    end
end

function onUpdate(elapsed)
--[[    if scaleImage then
    --    scaleDownAmount = 30 / framerate
        setGraphicSize("spell card disaster disspelling disinfecting gaming", getProperty("spell card disaster disspelling disinfecting gaming.width") - scaleAmount)
        setProperty("spell card disaster disspelling disinfecting gaming.x", getPropertyFromClass("flixel.FlxG", "width") - getProperty("spell card disaster disspelling disinfecting gaming.width"))
        scaleAmount = scaleAmount - 33 / framerate
        debugPrint(scaleAmount)
    end ]]
    if (getProperty("spell card disaster disspelling disinfecting gaming.width") >= 349) and scaleImage then
        setGraphicSize("spell card disaster disspelling disinfecting gaming", getProperty("spell card disaster disspelling disinfecting gaming.width") + (scaleAmount * -1))
        setProperty("spell card disaster disspelling disinfecting gaming.x", getPropertyFromClass("flixel.FlxG", "width") - getProperty("spell card disaster disspelling disinfecting gaming.width"))
        scaleAmount = scaleAmount + 33 / framerate
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "elevate" then -- or, well, its more like going down if youre in downscroll LOL
        doTweenY("going up", "spell card disaster disspelling disinfecting gaming", spelltextY[2], 1, "cubeInOut")
        scaleImage = false
    end

    if tag == "get out spell" then -- https://www.youtube.com/watch?v=RcGyPrGhljQ
        doTweenAlpha("SpellTextTween", "spell card disaster disspelling disinfecting gaming", 0, 0.5, "cubeIn")
    end
end