local shakeAmount = 0.01
local active = false

function onCreatePost()
    makeAnimatedLuaSprite("shameimarufumo", "Backgrounds/Aya/Fumo", 0, 0)
    addAnimationByIndices("shameimarufumo", "idle", "Fumo", "0")
    addLuaSprite("shameimarufumo")
    setObjectCamera("shameimarufumo", "other")
    scaleObject("shameimarufumo", 0.6, 0.6)
    updateHitbox("shameimarufumo")
    screenCenter("shameimarufumo")
    setProperty("shameimarufumo.alpha", 0)
end

function onEvent(name, value1, value2)
    if name == "AAAAAAAH fumo" then
        active = true
        playSound("aaaah")
        setProperty("shameimarufumo.alpha", 1)
        doTweenAlpha("shameifumodisappear", "shameimarufumo", 0, 2, "cubeIn")
	end
end

function onUpdate(elapsed)
    if active then
        triggerEvent("Screen Shake", ""..(elapsed * 2)..", "..shakeAmount, "")
        shakeAmount = shakeAmount - (0.005 * elapsed)
        if shakeAmount < 0 then
            active = false
        end
    end
end