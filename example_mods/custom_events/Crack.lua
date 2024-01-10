local elapsedTime = 0
local floatingIntensity = 0
local tweenFloatingIntensity = false
function onCreatePost()
    makeLuaSprite("remiliafog", "Backgrounds/Pelo/Remilia/layer", 0, 0)
    addLuaSprite("remiliafog")
    setObjectCamera("remiliafog", 'other')
    setProperty("remiliafog.alpha", 0)
end

function onEvent(eventName, value1, value2)
    if eventName == "Crack" then
        tweenFloatingIntensity = true
        doTweenAlpha("fogappear", "remiliafog", 0.75, 0.75, "cubeOut")
    end
end

function onUpdate(elapsed)
    elapsedTime = elapsedTime + elapsed
    -- global float value: math.sin(elapsedTime * 4) * 6
    if tweenFloatingIntensity then
        if floatingIntensity >= 1 then
            tweenFloatingIntensity = false
            floatingIntensity = 1
        else
            floatingIntensity = floatingIntensity + elapsed
        end
    end
    for i = 0, getProperty('strumLineNotes.length')-1 do
		setPropertyFromGroup('strumLineNotes', i, 'y', defaultOpponentStrumY0 + math.sin((elapsedTime * 2) + (0.5 * i)) * 10 * floatingIntensity)
	end
end