local animations = {"singLEFT", "singDOWN", "singUP", "singRIGHT"}
local lastAnimation = ""
local animationPlay = ""

function onCreate()
    math.randomseed(os.time())
end

function onEvent(name, value1, value2)
    if name == "Random Animation" then
        animationPlay = animations[math.random(1, 4)]

        while animationPlay == lastAnimation do
            animationPlay = animations[math.random(1, 4)]
        end

        if value2 == "" then
            playAnim(value1, animationPlay)
        else
            playAnim(value1, value2)
        end

        lastAnimation = animationPlay
    end
end