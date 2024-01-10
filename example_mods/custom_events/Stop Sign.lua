local elapsedTime = 0
local offset = 0
local timeToSet = 0
local movefromside = false
function onCreatePost()
    makeAnimatedLuaSprite("epicsign", "Backgrounds/Ciryes/Sign", 1500, 100)
    addAnimationByPrefix("epicsign", "loop", "Sign", 20, true)
    addLuaSprite("epicsign", true)
    setObjectCamera("epicsign", 'hud')
    scaleObject("epicsign", 0.4, 0.4)
end

function onEvent(eventName, value1, value2)
    if eventName == "Stop Sign" then
        doTweenX('stopsigntween', 'epicsign', 700, 1, 'bounceOut')
        timeToSet = value1
    end
end

function onUpdate(elapsed)
    elapsedTime = elapsedTime + elapsed
    setProperty('epicsign.y', 80 + (math.sin((elapsedTime * 2)) * 80))
    if offset > 0.1 then
        setProperty('epicsign.x', 700 + (math.sin((elapsedTime * 2.5)) * 100) * offset)
    end
    if movefromside then
        offset = linearinterp(1, offset, 0.97)
    else
        offset = linearinterp(0, offset, 0.9)
    end
end

function onTweenCompleted(tag)
	if tag == "stopsigntween" then
		runTimer('getthesignout', timeToSet)
        runTimer('stopsidemoving', timeToSet - 0.5)
        movefromside = true
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'stopsidemoving' then
		movefromside = false
	end
	if tag == 'getthesignout' then
		doTweenX('startsign', 'epicsign', 1500, 1, 'cubeIn')
	end
end

function linearinterp(pos1, pos2, perc)
    return (1-perc)*pos1 + perc*pos2 -- Linear Interpolation
end