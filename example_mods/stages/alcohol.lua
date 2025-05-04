local images = {"1bgred", "2bgblue", "3bggreen", "4bgpink", "5bgturqoise", "6bgyellow"}
local image = 1
local lastCameraReimu = false

function onCreate()
    makeLuaSprite("background", "Backgrounds/Goblins/"..images[image], -700, -300)
    addLuaSprite('background')
    setProperty('background.antialiasing', true)
    scaleObject('background', 1, 1)

    for i = 1, 6 do 
        loadGraphic("background", "Backgrounds/Goblins/"..images[i])
    end
    loadGraphic("background", "Backgrounds/Goblins/"..images[image])
end

function onCreatePost()

    setProperty('dad.alpha', 1)
    setProperty('boyfriend.alpha', 0)
    setProperty("cameraSpeed", 50)
    triggerEvent("Camera Follow Pos", 255, 255)
end

function onSectionHit()

    if not lastCameraReimu == mustHitSection then

        lastCameraReimu = mustHitSection

        if not mustHitSection then
            setProperty('dad.alpha', 1)
            setProperty('boyfriend.alpha', 0)
        else
            setProperty('dad.alpha', 0)
            setProperty('boyfriend.alpha', 1)
        end

        if image == 6 then
            image = 1
        else
            image = image + 1
        end

        loadGraphic("background", "Backgrounds/Goblins/"..images[image])

    --    scaleObject('background', 1.5, 1.5)
    end
end