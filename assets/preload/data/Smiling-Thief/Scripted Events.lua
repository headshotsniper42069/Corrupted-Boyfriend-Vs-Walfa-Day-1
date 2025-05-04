local elapsedTime = 0

function onCreatePost()
    makeLuaSprite("cameraOverlay", -1000, -2000)
    makeGraphic("cameraOverlay", 4000, 5000, "000000")
    setProperty("cameraOverlay.alpha", 0)
    addLuaSprite("cameraOverlay", true)
end

function onUpdate(elapsed)
    if curBeat >= 272 and curBeat < 287 then
        elapsedTime = elapsedTime + elapsed
        setShaderFloat("Smiling Thief Glitch Shader", "iTime", elapsedTime)
        setShaderFloat("Smiling Thief Glitch Shader", "AMT", elapsedTime / 30)
    end
end

function onBeatHit()
    if curBeat == 54 then
        doTweenAlpha("cameraFade", "cameraOverlay", 1, 3, "cubeIn")
    end

    if curBeat == 64 then -- STCutscene1
        setProperty("camGame.alpha", 0)
        setProperty("camHUD.alpha", 0)
    end

    if curBeat == 128 then
        setProperty("camGame.alpha", 1)
        setProperty("camHUD.alpha", 1)
        setProperty("camOther.alpha", 1)
        setProperty("cameraOverlay.alpha", 0)
    end

    if curBeat == 287 then
        setProperty("cameraSpeed", 250)
        setProperty("camGame.alpha", 0)
    end

    if curBeat == 288 then
        setShaderFloat("Smiling Thief Glitch Shader", "iTime", 0)
        setShaderFloat("Smiling Thief Glitch Shader", "AMT", 0)
        setProperty("boyfriend.alpha", 0)
        setProperty("boyfriend.x", 0)
    end

    if curBeat == 352 then
        setProperty("camGame.alpha", 1)
        setProperty("cameraSpeed", 1)
        removeLuaSprite("BG")
    end

    if curBeat == 485 then
        setProperty("camGame.alpha", 0)
        setProperty("camHUD.alpha", 0)
        setProperty("vocals.volume", 0)
    end
end