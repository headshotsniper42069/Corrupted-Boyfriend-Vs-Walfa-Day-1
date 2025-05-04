local side = "Left"
local image = 1

function onCreatePost()
    makeLuaSprite("flashback", "Backgrounds/Flanchan/FLAN"..image, 1500, 1700)
    scaleObject("flashback", 0.8, 0.8)
    setProperty("flashback.alpha", 0)
    addLuaSprite("flashback", true)
end

function onBeatHit()
    if curBeat >= 122 and (curBeat + 4) % 14 == 0 and image <= 7 then -- 92 seconds
        loadGraphic("flashback", "Backgrounds/Flanchan/FLAN"..image)
        scaleObject("flashback", 0.8, 0.8)
        if side == "Left" then
            setProperty("flashback.x", 530)
            side = "Right"
        else
            setProperty("flashback.x", 1570)
            side = "Left"
        end

        local position = 1500
        if side == "Right" then position = 600 end

        doTweenX("flashbackanimation", "flashback", position, 5)
        doTweenAlpha("flashbackappear", "flashback", 0.95, 0.5, "cubeOut")

        image = image + 1
    end
end

function onTweenCompleted(tag)
    if tag == "flashbackappear" then
        doTweenAlpha("flashbackdisappear", "flashback", 0, 4, "cubeIn")
    end
end