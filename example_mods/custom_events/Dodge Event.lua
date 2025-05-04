local active = false
local stepToTrigger = 0
local pressedSpace = false

function onCreatePost()
    makeLuaSprite("reimuWarning", "reimuSpaceWarning", 0, 0)
    setObjectCamera("reimuWarning", "hud")
    setProperty("reimuWarning.alpha", 0)
    setGraphicSize("reimuWarning", 0, 480, false)
    addLuaSprite("reimuWarning")
end

function onEvent(name, value1, value2)
    if name == 'Dodge Event' and not active then
        playSound("spaceWarning", 0.7)
        stepToTrigger = curStep + 9
        setProperty("reimuWarning.alpha", 1)
        setProperty("reimuWarning.y", 30)
        doTweenY("warningDown", "reimuWarning", 0, 0.35, "cubeOut")
        active = true
        pressedSpace = false
    end
end

function onUpdate(elapsed)
    if keyPressed("space") and not pressedSpace and active then
        playSound("dodged", 0.7)
        pressedSpace = true
        setProperty("reimuWarning.alpha", 0)
    end
end

function onStepHit()
    if curStep == stepToTrigger then
        setProperty("reimuWarning.alpha", 0)
        for i = 0, getProperty('notes.length')-1 do
            if getPropertyFromGroup('notes', i, 'mustPress') == false and (getPropertyFromGroup('notes', i, 'noteType') == "GF Sing") == false then
                setPropertyFromGroup('notes', i, 'noAnimation', true)
            end
        end
        playAnim("dad", "shoot", true)
        playSound("Gun", 0.9)
        if pressedSpace then
            playAnim("boyfriend", "dodge", true)
        else
            playSound("miss", 0.3)
            addHealth(-0.4)
            playAnim("boyfriend", "singRIGHTmiss", true)
        end
        runTimer("makereimudanceagain", 0.375, 1)
        active = false
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "makereimudanceagain" then
        for i = 0, getProperty('notes.length')-1 do
            if getPropertyFromGroup('notes', i, 'mustPress') == false then
                setPropertyFromGroup('notes', i, 'noAnimation', false)
            end
        end
    end
end