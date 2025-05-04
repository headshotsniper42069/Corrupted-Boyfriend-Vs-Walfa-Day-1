function onCreatePost()
    makeLuaSprite("blackOverlayFlanchanThing", "", 0, 0)
    makeGraphic("blackOverlayFlanchanThing", 1920, 1080, "000000")
    setObjectCamera("blackOverlayFlanchanThing", "other")
    setProperty("blackOverlayFlanchanThing.alpha", 0)
    addLuaSprite("blackOverlayFlanchanThing", true)
end

function onEvent(name, value1, value2)
    if name == "Camera Fade Out" then
        doTweenAlpha("blackOverlayFlanchanAlpha", "blackOverlayFlanchanThing", 1, value1, "cubeIn")
    end
end