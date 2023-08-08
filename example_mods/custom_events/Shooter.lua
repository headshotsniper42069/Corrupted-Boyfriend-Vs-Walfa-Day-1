--Made by headshotsniper
--Swear to god please don't steal i spent 45 minutes on this man

function onCreatePost()
	if downscroll then 
		lasery = 0
	else
		lasery = 655
	end
	makeAnimatedLuaSprite("beam", "Beam", -50, lasery)
	addAnimationByPrefix("beam", "shoot", "Beam", 45, false)
	addLuaSprite("beam", true)
	setObjectCamera("beam", "hud")
	setProperty("beam.alpha", 0)
	currentlyShooting = false
	lerpHealth = false
	recordedHealth = 0.75
	setHealth = 1
	percentageAmount = 0
	test = 1
end

function onEvent(name, value1, value2)
	if name == "Shooter" and not currentlyShooting then
		doTweenX("appear", "beam", 700, 0.5, "cubeOut")
		runTimer("playthesound", 0.25, 1)
		runTimer("disappear", 1, 1)
		currentlyShooting = true
		percentageAmount = value1
	end
end

function onSongStart()
	setProperty("beam.alpha", 1)
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == "disappear" then
		doTweenX("getouttahere", "beam", -50, 0.5, "cubeIn")
		lerpHealth = false
	end

	if tag == "playthesound" then
		playSound("DODGE", 0.5, "")
		playAnim("beam", "shoot", true, false, 0)
		setHealth = getProperty("health")
		recordedHealth = getProperty("health")
		lerpHealth = true
	end
end

function onUpdate(elapsed)
	if lerpHealth then
		setHealth = linearinterp(recordedHealth - (percentageAmount / 50), setHealth, 0.925)
		setProperty("health", setHealth)
	end

end

function onTweenCompleted(tag)
	if tag == "getouttahere" then
		currentlyShooting = false
	end
end

function linearinterp(pos1, pos2, perc)
    return (1-perc)*pos1 + perc*pos2 -- Linear Interpolation
end
