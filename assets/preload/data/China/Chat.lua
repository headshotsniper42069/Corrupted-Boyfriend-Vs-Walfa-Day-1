local america = false -- Developer Suggestion
local cat = false
local banning = false
local banned = false
local elapsedTime = 0
local chatter = 0
local amountOfMessages = 0
local nextChatTimer = 240
local messages = {
    {"Memi"," Can the green gaming goomba stop the gta 6 plane"},
    {"MetallA"," We love Racist Woman."},
    {"Slender"," Very interellectual conversation."},
    {"Norf"," Hey Moonies"}, -- "Norfair has been banned" 903a44
    {"NilVO"," America Ya"},
    {"Scoundrel"," I like men"},
    {"headshotsniper24"," What's good in the hood?"},
    {"DTSV"," Yo chat fumo time"},
    {"DarkGC"," whats a fumohou"},
    {"Mopsikus"," The heavy is dead"},
    {"Balls"," How do you pose?"},
    {"Head_Empty"," Shrimp frye"},
    {"Small_Sis"," I know your location "},
    {"Crow.exe"," Ayaya"},
    {"Local_Armpit"," Donate or perish"},
    {"Baka"," It's Joever"},
    {"EasyTaker"," Take it easy!"},
    {"IHATEYOU"," You thought the Yukkuri's worked alone?"},
    {"High_Bnuy"," Duuude...I think... I'm a rabbit..."},
    {"Cat"," Hello my name is ########"},
    {"NotABurgler"," Trading 2 book for a patchy hat"},
    {"tenks_u","NEW FUMO FUMO NFT LINE SET TO BREAK THE DIGITAL ECONOMY GET YOURS EARLY AT https://scambank.org.jp"},
    {"ayyykmao69"," she wants the D LULW"},
    {"w33dn00b"," was that a threat? monkaS"},
    {"thiccsakuya"," MOMMY? SORRY MOMMY? SORRY MOMMY?"},
    {"smol_bat"," Aww heck yeah evil vault crawl time! PogChamp"},
    {"weebqueen"," Why are all of you simping for 2D Maid smh TearGlare"},
    {"pristinebeater14"," god i HATE friday night funkin it isnt even TRYING to be a good music game"},
    {"GapHag"," Are you having fun yet?"},
    {"Rässist"," Are you watching Chang'e"},
    {"xXStr0ng3stF4ir1Xx"," how do i get free vbux"},
    {"NoNeck"," Bang bang!"},
    {"ClubPresident"," We all are just ficiton join my club to become non fiction!"},
    {"Mario"," It's a me... a Mario"},
    {"yasai-ka"," SINGLE GODS IN YOUR AREA!!! CLICK HERE TO MEET UP!!!!"},
    {"ImNotSmall"," You all are going to hell trust me."},
    {"MansionBoss4Eva"," Why can't I walk outside with an umbrella?"},
    {"Unbeatable"," Guess what?"},
    {"CircleEnjoyer"," 39 Burried... 0 Found."},
    {"SmartestinGensokios"," Baka"},
    {"ChinaSupporter"," God I wish Meiling would pick me up like that..."},
    {"CircaSunny"," Meiling best sensei don't @ me"},
    {"IAmTheBreadGuy"," Somebody get this girl a Sandwich"},
    {"Fumo"," When she Fumo on my Fumo till I fumo."},
    {"xranninx", "lemme put my cat on the chat"}
}



local NAME_COLORS = -- from roblox itself: https://devforum.roblox.com/t/your-name-color-in-chat-—-history-and-how-it-works/2702247
	{
        "fd2943",
        "01a2ff",
        "02b857",
        "6b327c",
        "da8541",
        "f5cd30",
        "e8bac8",
        "d7c59a"
	}

local function GetNameValue(pName)
	local value = 0
	for index = 1, #pName do
		local cValue = string.byte(string.sub(pName, index, index))
		local reverseIndex = #pName - index + 1
		if #pName%2 == 1 then
			reverseIndex = reverseIndex - 1
		end
		if reverseIndex%4 >= 2 then
			cValue = -cValue
		end
		value = value + cValue
	end
	return value
end

local color_offset = 0
local function ComputeNameColor(pName)
	return NAME_COLORS[((GetNameValue(pName) + color_offset) % #NAME_COLORS) + 1]
end

function onCreate() -- up to 14 lines, 46 in total
    makeLuaSprite("chatOverlay", "", 10, 35)
    makeGraphic("chatOverlay", 420, 250, "000000")
    setObjectCamera("chatOverlay", "other")
    setProperty("chatOverlay.alpha", 0.65)
    addLuaSprite("chatOverlay")
    makeLuaText("chat0user", "Chat '/?' or '/help' for a list of chat commands.", 0, 10, 35)
    setTextSize("chat0user", 12)
    setProperty("chat0user.antialiasing", true)
    setTextFont("chat0user", "SourceSansPro-Bold.otf")
    setTextBorder("chat0user", 0, "0xFF000000")
    setObjectCamera("chat0user", "other")
    addLuaText("chat0user")
    nextChatTimer = getRandomFloat(1.27, 9.6)
end

local messageOffset = 1
local previousPlayer = ""

function makeNewText(player, message)
    if player == 'xranninx' and not america then
        runTimer("cat", 4.5)
    elseif player == 'NilVO' then
        america = true
        nextChatTimer = 1.8
    elseif player == 'Norf' then
        banning = true
    end
--    debugPrint(player, message)

    if amountOfMessages == 14 + messageOffset then
        removeLuaText("chat"..(amountOfMessages - 15).."user")
        removeLuaText("chat"..(amountOfMessages - 15))
        messageOffset = messageOffset + 1
        for i = messageOffset - 1, amountOfMessages do
            setProperty("chat"..i.."user.y", getProperty("chat"..i.."user.y") - 15)
            setProperty("chat"..i..".y", getProperty("chat"..i..".y") - 15)
        end
    end

    amountOfMessages = amountOfMessages + 1

    if player == "" then
        makeLuaText("chat"..amountOfMessages.."user", "", 0, 10, 35 + (15 * (amountOfMessages - (messageOffset - 1))))
    else
        makeLuaText("chat"..amountOfMessages.."user", player..":", 0, 10, 35 + (15 * (amountOfMessages - (messageOffset - 1))))
    end
    setTextSize("chat"..amountOfMessages.."user", 12)
    setTextColor("chat"..amountOfMessages.."user", ComputeNameColor(player))
    setProperty("chat"..amountOfMessages.."user.antialiasing", true)
    setTextFont("chat"..amountOfMessages.."user", "SourceSansPro-Bold.otf")
    setTextBorder("chat"..amountOfMessages.."user", 0, "0xFF000000")
    setObjectCamera("chat"..amountOfMessages.."user", "other")
    addLuaText("chat"..amountOfMessages.."user")

    local currentMessage = message
    local makeAnother = false

    if string.len(message) >= 55 then
        currentMessage = string.sub(message, 1, 55)
        makeAnother = true
    end

    if player == "" then
        makeLuaText("chat"..amountOfMessages, currentMessage, 0, 7, 35 + (15 * (amountOfMessages - (messageOffset - 1))))
    else
        makeLuaText("chat"..amountOfMessages, currentMessage, 0, 10 + getTextWidth("chat"..amountOfMessages.."user"), 35 + (15 * (amountOfMessages - (messageOffset - 1))))
    end
    setTextSize("chat"..amountOfMessages, 12)
    setProperty("chat"..amountOfMessages..".antialiasing", true)
    setTextFont("chat"..amountOfMessages, "SourceSansPro-Bold.otf")
    setTextBorder("chat"..amountOfMessages, 0, "0xFF000000")
    setObjectCamera("chat"..amountOfMessages, "other")
    addLuaText("chat"..amountOfMessages)

    if makeAnother then makeNewText("", string.sub(message, 56, string.len(message))) end
end

local americas = 0
local lastHalloPlayer = ""

function onUpdate(elapsed)
    if startedCountdown then
        elapsedTime = elapsedTime + elapsed
        if elapsedTime >= nextChatTimer and not inGameOver and not america and not banning then
            elapsedTime = 0
            chatter = getRandomInt(1, 44)
            while messages[chatter][1] == previousPlayer do -- stop duplicate players
                chatter = getRandomInt(1, 44)
            end
            while chatter == 4 and banned do -- Anti ban evasion?
                chatter = getRandomInt(1, 44)
            end
            nextChatTimer = getRandomFloat(1.27, 9.6)
            previousPlayer = messages[chatter][1]
            makeNewText(messages[chatter][1], messages[chatter][2])
        end
        if america and elapsedTime >= nextChatTimer then
            for i = 0, americas do
                lastHalloPlayer = messages[getRandomInt(1, 44)][1]
                while not lastHalloPlayer == 'NilVO' do
                    lastHalloPlayer = messages[getRandomInt(1, 44)][1]
                end
                makeNewText(lastHalloPlayer, "HALLO :D")
            end
            elapsedTime = 0
            nextChatTimer = 1.1
            if americas == 0 then
                americas = 2
            elseif americas == 2 then
                americas = 3
            elseif americas == 3 then
                nextChatTimer = getRandomFloat(1.27, 9.6)
                americas = 0
                america = false
            end
        end
        if banning and elapsedTime >= 2.5 then
            elapsedTime = 0
            setTextString("chat"..amountOfMessages.."user", "Norf has been banned")
            setTextString("chat"..amountOfMessages, "")
            setTextFont("chat"..amountOfMessages.."user", "SourceSansPro-BoldIt.otf")
            setTextColor("chat"..amountOfMessages.."user", "903A44")
            banned = true
            banning = false
        end
    end
end

function onTimerCompleted(tag)
    if tag == "cat" then
        makeNewText("xranninx", "MGWHRAOAOWER")
    end
end