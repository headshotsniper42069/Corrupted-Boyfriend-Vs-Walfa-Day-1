--script by BCTIX you can delete this if u want lol

-- ez settings lol

-- 0 is the middle of the screen
local xOffset = 430
local yOffset = 180

local size = 30

local setColor = '000000'
local sungColor = 'BEE7AF'

local font = 'vcr.ttf'




function onCreate()
	makeLuaText('setlyric','',0,screenWidth/2 + xOffset,screenHeight/2 + yOffset);
	setTextSize('setlyric',size);
	setTextAlignment('setlyric','center')
	setTextColor('sunglyric', setColor)
	setObjectCamera('setlyric', 'other')
	setTextFont('setlyric', font)
	addLuaText('setlyric');


	makeLuaText('sunglyric','',0,screenWidth/2 + xOffset,screenHeight/2 + yOffset);
	setTextSize('sunglyric',size);
	setTextAlignment('sunglyric','center')
	setTextColor('sunglyric', sungColor)
	setObjectCamera('sunglyric', 'other')
	setTextFont('sunglyric', font)
	addLuaText('sunglyric');
end
function onUpdate()
    screenCenter('setlyric', 'x')
	setProperty('sunglyric.x', getProperty('setlyric.x')) -- make sure sung text is always ontop of set text
end
function onEvent(name, value1, value2)
	if name == 'karaokelyrics' then
	if value1 == 'set' or value1 == '' then
		setProperty('setlyric.x', screenWidth/2-(#value2*11)+ xOffset) --attempt to emulate center alignment
		setTextString('setlyric', value2)
		setTextString('sunglyric', '')
		screenCenter('setlyric', 'x')
	end
	if value1 == 'sung' then
		setTextString('sunglyric', value2)
	end
	end
end