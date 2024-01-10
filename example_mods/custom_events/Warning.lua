local eventDuration = 0

function onCreatePost()
    setProperty("defaultCamZoom", 0.5)
    setProperty("camGame.zoom", 0.5)
    makeLuaSprite("reiujiLineDown", "Reiuji Warning/Line", 0, 0)
    scaleObject("reiujiLineDown", 3.25, 1.625)
    setProperty("reiujiLineDown.y", 720 - getProperty("reiujiLineDown.height"))
    addLuaSprite("reiujiLineDown", true)
    setObjectCamera("reiujiLineDown", "hud")

    makeLuaSprite("reiujiLineUp", "Reiuji Warning/Line", 0, 0)
    scaleObject("reiujiLineUp", 3.25, 1.625)
    addLuaSprite("reiujiLineUp", true)
    setObjectCamera("reiujiLineUp", "hud")

    setProperty("reiujiLineUp.y", getProperty("reiujiLineUp.height") * -1)
    setProperty("reiujiLineDown.y", getProperty("reiujiLineDown.y") + getProperty("reiujiLineDown.height") + 10)

    for number=0,3 do
        makeLuaSprite("reiujiCaution"..number, "Reiuji Warning/Line Text", 0 + (425 * number), 17)
        scaleObject("reiujiCaution"..number, 1.4, 1.4)
        addLuaSprite("reiujiCaution"..number, true)
        setObjectCamera("reiujiCaution"..number, "hud")
        setProperty("reiujiCaution"..number..".velocity.x", -200)

        makeLuaSprite("reiujiCautionDown"..number, "Reiuji Warning/Line Text", 0 + (425 * number), 630)
        scaleObject("reiujiCautionDown"..number, 1.4, 1.4)
        addLuaSprite("reiujiCautionDown"..number, true)
        setObjectCamera("reiujiCautionDown"..number, "hud")
        setProperty("reiujiCautionDown"..number..".velocity.x", -200)

        setProperty("reiujiCaution"..number..".y", getProperty("reiujiCaution"..number..".height") * -1)
        setProperty("reiujiCautionDown"..number..".y", getProperty("reiujiCautionDown"..number..".y") + getProperty("reiujiCautionDown"..number..".height") + 20)
    end

    for number=0,2 do
        makeLuaSprite("reiujiCenterIcon"..number, "Reiuji Warning/Center Image", 0, 0)
        scaleObject("reiujiCenterIcon"..number, 1.7, 1.7)
        addLuaSprite("reiujiCenterIcon"..number, true)
        setObjectCamera("reiujiCenterIcon"..number, "hud")
        screenCenter("reiujiCenterIcon"..number, "y")
        setProperty("reiujiCenterIcon"..number..".x", (getProperty("reiujiCenterIcon"..number..".width") + 575 * (number - 1)))
        setProperty("reiujiCenterIcon"..number..".velocity.x", 300)
        setProperty("reiujiCenterIcon"..number..".alpha", 0)
    end
end

function onEvent(name, value1, value2)
    if name == "Warning" then
        eventDuration = value1
        doTweenY("getLineDown", "reiujiLineDown", 720 - getProperty("reiujiLineDown.height"), 0.5, "cubeOut")
        doTweenY("getLineUp", "reiujiLineUp", 0, 0.5, "cubeOut")
        for number=0,3 do
            doTweenY("getCautionText"..number.."Down", "reiujiCautionDown"..number, 630, 0.5, "cubeOut")
            doTweenY("getCautionText"..number.."Up", "reiujiCaution"..number, 17, 0.5, "cubeOut")
        end
        for number=0,2 do
            doTweenAlpha("getCenterIcon"..number.."InView", "reiujiCenterIcon"..number, 1, 0.5, "cubeOut")
        end
    end
end

function onTweenCompleted(tag)
    if tag == "getLineDown" then
        runTimer("getTheWarningOut", eventDuration, 1)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "getTheWarningOut" then
        doTweenY("getLineDownOuttaHere", "reiujiLineDown", getProperty("reiujiLineDown.y") + getProperty("reiujiLineDown.height") + 10, 0.5, "cubeIn")
        doTweenY("getLineUpOuttaHere", "reiujiLineUp", getProperty("reiujiLineUp.height") * -1, 0.5, "cubeIn")
        for number=0,3 do
            doTweenY("getCautionText"..number.."DownOuttaHere", "reiujiCautionDown"..number, getProperty("reiujiCautionDown"..number..".y") + getProperty("reiujiCautionDown"..number..".height") + 20, 0.5, "cubeIn")
            doTweenY("getCautionText"..number.."UpOuttaHere", "reiujiCaution"..number, getProperty("reiujiCaution"..number..".height") * -1, 0.5, "cubeIn")
        end
        for number=0,2 do
            doTweenAlpha("getCenterIcon"..number.."OutOfView", "reiujiCenterIcon"..number, 0, 0.5, "cubeIn")
        end
    end
end

function onUpdate(elapsed)
    for number=0,3 do
        if getProperty("reiujiCaution"..number..".x") < (getProperty("reiujiCaution"..number..".width") * -1) then
            setProperty("reiujiCaution"..number..".x", 1280)
        end
        if getProperty("reiujiCautionDown"..number..".x") < (getProperty("reiujiCautionDown"..number..".width") * -1) then
            setProperty("reiujiCautionDown"..number..".x", 1280)
        end
    end

    for number=0,2 do
        if getProperty("reiujiCenterIcon"..number..".x") > 1280 then
            setProperty("reiujiCenterIcon"..number..".x", getProperty("reiujiCenterIcon"..number..".width") * -1)
        end
    end
end