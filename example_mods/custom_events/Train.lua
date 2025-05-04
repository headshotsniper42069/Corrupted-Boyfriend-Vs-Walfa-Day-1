local active = false
local stepToTrigger = 0
local pressedSpace = false
local trainMoving = false

function onCreate()
    makeLuaSprite("lightningImage", "train_warning", 0, 0)
    setObjectCamera("lightningImage", "hud")
    setProperty("lightningImage.alpha", 0)
    setGraphicSize("lightningImage", 1280)
    addLuaSprite("lightningImage")

    makeAnimatedLuaSprite('Train', 'train_attack', -1200, 700)
	addAnimationByPrefix('Train', 'attack', 'Train_Attack', 48, false)
    addAnimationByPrefix('Train', 'idle', 'Train_Idle', 24, false)
    addAnimationByPrefix('Train', 'disappear', 'Train_2Stage', 48, false)
	addLuaSprite('Train', true)
	scaleObject('Train', 0.6, 0.6)
    setProperty("Train.alpha", 0)

	makeLuaSprite('TrainStandalone', 'train', -120, 1030)
	addLuaSprite('TrainStandalone', true)
	scaleObject('TrainStandalone', 0.6, 0.6)
    setProperty("TrainStandalone.alpha", 0)
end

function onEvent(name, value1, value2)
    if name == 'Train' and not active then
        playSound("trainWarning", 0.65)
        setProperty("TrainStandalone.alpha", 0)
        setProperty('TrainStandalone.x', -120)
        stepToTrigger = curStep + 9
        setProperty("lightningImage.alpha", 0.9)
        doTweenAlpha("warningDown", "lightningImage", 0, 1, "cubeIn")
        active = true
        pressedSpace = false
        trainMoving = false
    end
end

function onUpdate(elapsed)
    if keyJustPressed("space") and not pressedSpace and active then
        playSound("dodged", 0.7)
        pressedSpace = true
    end

    if getProperty("Train.animation.curAnim.finished") and getProperty("Train.animation.curAnim.name") == "attack" and trainMoving then
        objectPlayAnimation("Train", "idle")
        setProperty("TrainStandalone.alpha", 1)
        doTweenX("trainMove", "TrainStandalone", -4600, 0.5, "linear")
        runTimer("gapFadeOut", 1.25)
    end

    if getProperty("Train.animation.curAnim.finished") and getProperty("Train.animation.curAnim.name") == "disappear" and trainMoving then
        setProperty("Train.alpha", 0)
        trainMoving = false
    end
end

function onStepHit()
    if curStep == stepToTrigger then
        setProperty("Train.alpha", 1)
        objectPlayAnimation("Train", "attack", true)
        playSound("train", 0.4)
        trainMoving = true
        if pressedSpace then
            doTweenY("jump", "boyfriend", -200, 0.85, "cubeOut")
            doTweenAngle("spin2", "boyfriend", 360, 1.5, "cubeOut")
            setProperty("cameraSpeed", 2.5)
            triggerEvent("Camera Follow Pos", "-200", "450")
        else
            playSound("miss", 0.3)
            addHealth(-0.8)
        end
        active = false
    end
end

function onPause()
    pauseSound("trainWarning")
    pauseSound("train")
end

function onTweenCompleted(tag)
    if tag == "jump" then
        doTweenY("jump2", "boyfriend", 550, 0.65, "cubeIn")
    end

    if tag == "spin2" then
        setProperty("boyfriend.angle", 0)
        triggerEvent("Camera Follow Pos")
        runHaxeCode("game.moveCameraSection();")
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "gapFadeOut" then
        objectPlayAnimation("Train", "disappear", true)
        setProperty("cameraSpeed", 1)
    end
end