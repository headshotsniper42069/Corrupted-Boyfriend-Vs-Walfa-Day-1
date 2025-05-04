local shooting = false -- LOCAL SHOOTING???!111!111
local elapsedTime = 0
local amountOfSakooyas = 0

function onCreatePost()
    setProperty("boyfriend.flipX", true)
--    luaDebugMode = true
end

function onBeatHit()
    if curBeat == 25 then
        setProperty("boyfriend.skipDance", true)
    end
end

function onUpdate(elapsed)
    elapsedTime = elapsedTime + elapsed
    if curStep >= 100 and getProperty("boyfriend.flipX") then
        setProperty("boyfriend.origin.x", getProperty("boyfriend.origin.x") - (650 * elapsed)) -- spin offsets
        setProperty("boyfriend.origin.y", getProperty("boyfriend.origin.y") - (650 * elapsed))
    end
--    debugPrint(getProperty("boyfriend.origin.y")) -- 262, 257

    if shooting then
        if elapsedTime >= (1 / 60) then
            for i=0,5 do
                makeLuaSprite("sakooya"..amountOfSakooyas, "Backgrounds/Mistr00s/sakooya_attack", getProperty("dad.x") + getProperty("dad.width"), getProperty("dad.y") + 150)
                setGraphicSize("sakooya"..amountOfSakooyas, 100)
                setProperty("sakooya"..amountOfSakooyas..".velocity.x", getRandomInt(375, 2674))
                setProperty("sakooya"..amountOfSakooyas..".velocity.y", getRandomInt(-650, 650))
                setProperty("sakooya"..amountOfSakooyas..".elasticity", getRandomFloat(0, 0.12))
                addLuaSprite("sakooya"..amountOfSakooyas, true)
                amountOfSakooyas = amountOfSakooyas + 1
            end
        end
    end

    if amountOfSakooyas > 0 or shooting then
        for this=0,amountOfSakooyas do
        --    debugPrint(this)
            if elapsedTime >= (1 / 60) then
                if (getProperty("sakooya"..this..".scale.x") <= (0.09 + getProperty("sakooya"..this..".elasticity"))) then
                    setProperty("sakooya"..this..".scale.x", 0.15 + getProperty("sakooya"..this..".elasticity"))
                    setProperty("sakooya"..this..".scale.y", 0.15 + getProperty("sakooya"..this..".elasticity"))
                end
                setProperty("sakooya"..this..".scale.x", getProperty("sakooya"..this..".scale.x") - 0.02)
                setProperty("sakooya"..this..".scale.y", getProperty("sakooya"..this..".scale.y") - 0.02)
                setProperty("sakooya"..this..".elasticity", getProperty("sakooya"..this..".elasticity") - 0.0005)
            end
            if getProperty("sakooya"..this..".x") >= 1500 then
            --    removeLuaSprite("sakooya"..this)
            end
        end
    end

    if elapsedTime >= (1 / 60) then
        elapsedTime = 0 
    end
end

function onStepHit()
    if curStep == 100 then
        doTweenAngle("spinner", "boyfriend", -1090, 0.55)
    end
    if curStep == 114 then
        setProperty("boyfriend.angle", 0)
        setProperty("boyfriend.skipDance", false)
        setProperty("boyfriend.origin.x", 262)
        setProperty("boyfriend.origin.y", 257)
    end

    if curStep == 1535 then
        setProperty('boyfriend.flipX', false)
        setProperty("boyfriend.origin.x", 262)
        setProperty("boyfriend.origin.y", 257)
        setProperty('dad.angularVelocity', -6900)
        shooting = true
    end
    if curStep == 1538 then
        setProperty('boyfriend.angularVelocity', -5360)
    end
    if curStep == 1568 then
        setProperty('dad.angularVelocity', 0)
        setProperty('dad.angle', 0)
        shooting = false
    end
    if curStep == 1570 then
        setProperty('boyfriend.angularVelocity', 0)
        doTweenAlpha("remiliaDisappear", "boyfriend", 0, 1.25)
    end
    if curStep == 1587 then
        doTweenAlpha("remiliaAppear", "boyfriend", 1, 2)
    end
    if curStep == 1617 then
        for this=0,amountOfSakooyas do
            removeLuaSprite("sakooya"..this)
        end
        for i=0,4 do
            makeLuaSprite("attack"..i, "Backgrounds/Mistr00s/mistr00s_attack", getProperty("boyfriend.x"), getProperty("boyfriend.y"))
            setProperty("attack"..i..".velocity.x", -850 - (150 * i))
            addLuaSprite("attack"..i, true)
            doTweenAlpha("attackStuff"..i, "attack"..i, 0, 1.5 - (i * 0.25))
        end
    end
end

function onTweenCompleted(tag)
    if tag == "spinner" then
        setProperty("boyfriend.flipX", false)
    end
end