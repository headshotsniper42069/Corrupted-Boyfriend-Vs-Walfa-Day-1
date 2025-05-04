local lastPositionBoyfriend = {0, 0}
local lastPositionGirlfriend = {0, 0}
local startOutro = true
local elapsedTime = 0

function onCreatePost()
    lastPositionBoyfriend[1] = getProperty("boyfriend.x")
    lastPositionBoyfriend[2] = getProperty("boyfriend.y")

    lastPositionGirlfriend[1] = getProperty("gf.x")
    lastPositionGirlfriend[2] = getProperty("gf.y")

    makeLuaSprite("portal", "Backgrounds/Indie/portal", -400, 500)
    scaleObject("portal", 0.65, 0.65)
    addLuaSprite("portal")

    setProperty("boyfriend.x", getProperty("portal.x") + 150)
    setProperty("gf.x", getProperty("portal.x") + 100)
    setProperty("portal.x", 1000)

    setProperty("portal.alpha", 0)
    setProperty("boyfriend.alpha", 0)
    setProperty("gf.alpha", 0)

    setProperty("boyfriend.angle", 25)
    setProperty("gf.angle", 25)

    runTimer("portal", 0.25)

    runTimer("boyfriendteleport", 0.85)
    runTimer("girlfriendteleport", 1.15)

    runTimer("portalAway", 1.5)
end

function onUpdate(elapsed)
    elapsedTime = elapsedTime + elapsed
    if getPropertyFromClass("flixel.FlxG", "sound.music.time") >= (getPropertyFromClass("flixel.FlxG", "sound.music.length") - 4000) then
        triggerEvent("Camera Follow Pos", cameraX, cameraY)
        if startOutro then
            startOutro = false
            runTimer("boyfriendAway", 0.5)
            doTweenX("portalX", "portal", -400, 0.75, "quintOut")
            doTweenAlpha("portalAlpha", "portal", 0.85, 1.25, "cubeOut")
            setProperty("portal.angle", 0)
            runTimer("girlfriendAway", 0.6)
            runTimer("portalFlingAway", 1.25)
        end
    end
end

function onTweenCompleted(tag)
    if tag == "boyfriendFlingAwayX" then
        setProperty("boyfriend.alpha", 0)
    elseif tag == "gfFlingAwayX" then
        setProperty("gf.alpha", 0)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "boyfriendteleport" then
        doTweenX("boyfriendFlingX", "boyfriend", lastPositionBoyfriend[1], 0.5, "quintOut")
        doTweenY("boyfriendFlingY", "boyfriend", lastPositionBoyfriend[2], 0.5, "quintOut")
        doTweenAngle("boyfriendFlingAngle", "boyfriend", 0, 0.5, "quintOut")
        setProperty("boyfriend.alpha", 1)
    elseif tag == "girlfriendteleport" then
        doTweenX("gfFlingX", "gf", lastPositionGirlfriend[1], 0.5, "quintOut")
        doTweenY("gfFlingY", "gf", lastPositionGirlfriend[2], 0.5, "quintOut")
        doTweenAngle("gfFlingAngle", "gf", 0, 0.5, "quintOut")
        setProperty("gf.alpha", 1)
    elseif tag == "portal" then
        doTweenX("portalX", "portal", -400, 0.75, "quintOut")
        doTweenAlpha("portalAlpha", "portal", 0.85, 1.25, "cubeOut")
    elseif tag == "portalAway" then
        doTweenX("portalX", "portal", 1000, 0.75, "quintIn")
        doTweenAlpha("portalAlpha", "portal", 0, 1, "cubeIn")
        doTweenAngle("portalAngle", "portal", 2080, 1.5, "cubeIn")
    elseif tag == "boyfriendAway" then
        doTweenX("boyfriendFlingAwayX", "boyfriend", getProperty("portal.x") + 200, 0.4, "quintIn")
        doTweenAngle("boyfriendFlingAwayAngle", "boyfriend", 620, 0.7, "quintIn")
    elseif tag == "girlfriendAway" then
        doTweenX("gfFlingAwayX", "gf", getProperty("portal.x") + 150, 0.75, "quintIn")
        doTweenAngle("gfFlingAwayAngle", "gf", 330, 1.2, "quintIn")
    elseif tag == "portalFlingAway" then
        doTweenX("portalX", "portal", 2000, 1.25, "quintIn")
        doTweenAlpha("portalAlpha", "portal", 0, 1, "cubeIn")
        doTweenAngle("portalAngle", "portal", 2080, 1.8, "cubeIn")
    end
end