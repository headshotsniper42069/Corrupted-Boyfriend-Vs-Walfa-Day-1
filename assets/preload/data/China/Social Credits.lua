local credits = 20
local opponentCredits = 20 -- in decimals

function onCreate()
--    luaDebugMode = true
    makeLuaSprite("socials", "social-credit", 0, 0)
    addLuaSprite("socials")
    setProperty("socials.alpha", 0)
    setGraphicSize("socials", 0, 720)
    setObjectCamera("socials", "hud")

    makeLuaText("socialBoyfriend", "Social Credits: "..credits, 0, 0)
    setTextAlignment("socialBoyfriend", "right")
    setTextFont("socialBoyfriend", "DFPOCOC.ttf")
    addLuaText("socialBoyfriend")
    setObjectCamera("socialBoyfriend", "hud")
    setTextSize("socialBoyfriend", 24)
    setProperty("socialBoyfriend.x", screenWidth - getProperty("socialBoyfriend.width") - 25)

    makeLuaText("socialOpponent", "Social Credits: "..opponentCredits, 0, 0)
    setTextAlignment("socialOpponent", "left")
    setTextFont("socialOpponent", "DFPOCOC.ttf")
    addLuaText("socialOpponent")
    setObjectCamera("socialOpponent", "hud")
    setTextSize("socialOpponent", 24)
    setProperty("socialOpponent.x", 25)
end

function onCreatePost()
    for i = 0, getProperty('unspawnNotes.length')-1 do
		setPropertyFromGroup('unspawnNotes', i, 'missHealth', 0);
        setPropertyFromGroup('unspawnNotes', i, 'hitHealth', 0);
	end
    setProperty("socialOpponent.y", getProperty("healthLeft.y"))
    setProperty("socialBoyfriend.y", getProperty("healthRight.y"))
end

function onUpdate(elapsed)
    if credits <= 0 then
        setProperty('health', 0)
    elseif credits < 15 then
        setProperty('health', 0.15)
    elseif credits > opponentCredits + 5 then
        setProperty('health', 2)
    else
        setProperty('health', 1)
    end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if not isSustainNote then
        opponentCredits = opponentCredits + 0.25 -- 1 credit every 4 notes
        setTextString("socialOpponent", "Social Credits: "..math.floor(opponentCredits))
    end
end

function noteMiss(id, direction, noteType, isSustainNote)
    if not isSustainNote then
        credits = credits - 5
        setTextString("socialBoyfriend", "Social Credits: "..credits)
        setTextString("socialOpponent", "Social Credits: "..math.floor(opponentCredits))
        setProperty("socialBoyfriend.x", screenWidth - getProperty("socialBoyfriend.width") - 25)
    end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Credits' and not isSustainNote then
        setProperty("socials.alpha", 1)
        doTweenAlpha("socialPopup", "socials", 0, 0.5)
        credits = credits + 5
        setTextString("socialBoyfriend", "Social Credits: "..credits)
        setTextString("socialOpponent", "Social Credits: "..math.floor(opponentCredits))
        setProperty("socialBoyfriend.x", screenWidth - getProperty("socialBoyfriend.width") - 25)
    end
end