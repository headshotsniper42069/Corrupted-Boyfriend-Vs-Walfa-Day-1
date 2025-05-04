local images = {
    {name = 'text1', x = 640, y = 160},    -- Beat 221, centered x position
    {name = 'text2', x = 640, y = 360},  -- Beat 232, centered x position
    {name = 'text3', x = 640, y = 550}   -- Beat 237, centered x position
}

function onCreate()
    for i, img in ipairs(images) do
        makeLuaSprite(img.name, img.name, img.x, img.y)
        setObjectCamera(img.name, 'other')
        setProperty(img.name..'.alpha', 0)
        -- Scale the images to 0.8
        scaleObject(img.name, 0.8, 0.8)
        addLuaSprite(img.name, true)
        -- Center the images horizontally
        screenCenter(img.name, 'x')
    end
end

function onBeatHit()
    if curBeat == 221 then
        doTweenAlpha('text1FadeIn', 'text1', 1, 0.5, 'linear')
        runTimer('text1Fade', 1.5)
    elseif curBeat == 228 then
        doTweenAlpha('text2FadeIn', 'text2', 1, 0.5, 'linear')
        runTimer('text2Fade', 1.8)
    elseif curBeat == 235 then
        doTweenAlpha('text3FadeIn', 'text3', 1, 0.5, 'linear')
        runTimer('text3Fade', 1.8)
    end
end

function onTimerCompleted(tag)
    if tag == 'text1Fade' then
        doTweenAlpha('text1fade', 'text1', 0, 0.5, 'linear')
    elseif tag == 'text2Fade' then
        doTweenAlpha('text2fade', 'text2', 0, 0.5, 'linear')
    elseif tag == 'text3Fade' then
        doTweenAlpha('text3fade', 'text3', 0, 0.5, 'linear')
    end
end