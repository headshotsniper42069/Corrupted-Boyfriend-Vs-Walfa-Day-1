local randomStepHit = 255680

local elapsedTime = 0

local fairyType = 1

local fairy2Event = 0

local fairiesSpawned = 0

function onCreate()
	makeLuaSprite('BG', 'Backgrounds/Pelo/BF/BG', -600, -200);
	addLuaSprite('BG', false);
  	setProperty('BG.antialiasing', true)
  	scaleObject('BG', 1.2, 1.2);

  	if songName == 'Perfectionism' then

  	makeAnimatedLuaSprite('Reimu','Backgrounds/Pelo/BF/Reimu_BG',1400, 720)
  	addAnimationByPrefix('Reimu','idle','Reimu_Bounce',24, false)
  	addLuaSprite('Reimu', false);
  	scaleObject('Reimu', 0.8, 0.8);
  	setProperty('Reimu.flipX', true)
  		setObjectOrder('boyfriendGroup', 2)
    setObjectOrder('gfGroup', 1)

    makeAnimatedLuaSprite('randomFairies', 'Backgrounds/Pelo/BF/fairy', 2300, 500)
		addAnimationByPrefix('randomFairies', 'Fairy 1', 'Fairy1', 24, true)
		addAnimationByPrefix('randomFairies', 'Fairy 2', 'Fairy2', 24, true)
		addLuaSprite('randomFairies', true)
		scaleObject('randomFairies', 0.7, 0.7)

    makeAnimatedLuaSprite('Marisa','Backgrounds/Pelo/BF/Marisa',-100, 720)
  	addAnimationByPrefix('Marisa','idle','Marisa_Bounce',24, false)
  	addLuaSprite('Marisa', false);
  	scaleObject('Marisa', 0.75, 0.75);
  end

  	if songName == 'stubborness' then
		makeAnimatedLuaSprite('randomFairies', 'Backgrounds/Pelo/BF/fairy', 2300, 500)
		addAnimationByPrefix('randomFairies', 'Fairy 1', 'Fairy1', 24, true)
		addAnimationByPrefix('randomFairies', 'Fairy 2', 'Fairy2', 24, true)
		addAnimationByPrefix('randomFairies', 'Fairy Scream', 'FairyShoot', 20, false)
		addLuaSprite('randomFairies', true)
		objectPlayAnimation('randomFairies', 'Fairy 1', true)
		scaleObject('randomFairies', 0.7, 0.7)
	end

	randomStepHit = getRandomInt(64, 120)

--	randomStepHit = 8

	fairyType = getRandomInt(1, 2)

--	fairyType = 2
end

function onBeatHit()--for every beat
	if curBeat % 2 == 0 then
	    objectPlayAnimation('Reimu','idle',true)
	    objectPlayAnimation('Marisa','idle',true)
	end
end

function onUpdate(elapsed)
	elapsedTime = elapsedTime + elapsed
	if fairyType == 1 then
		setProperty('randomFairies.y', 480 + (math.sin(elapsedTime * 6)) * 10)
	elseif fairyType == 2 then
		setProperty('randomFairies.y', 950 + (math.sin(elapsedTime * 6)) * 10)
		if fairy2Event == 1 then
			if getProperty('randomFairies.velocity.x') < -900 then
				setProperty('randomFairies.velocity.x', getProperty('randomFairies.velocity.x') + (2400 * elapsed))
			end
			if getProperty('randomFairies.velocity.x') > -500 then
				setProperty('randomFairies.velocity.x', -500)
			end
		elseif fairy2Event == 2 then
			setProperty('randomFairies.velocity.x', getProperty('randomFairies.velocity.x') - (2400 * elapsed))
		end
	else
		setProperty('randomFairies.y', 400 + (math.sin(elapsedTime * 6)) * 10)
	end
end

function onStepHit()
	if curStep == randomStepHit then
		fairyType = getRandomInt(1, 2)
		fairiesSpawned = fairiesSpawned + 1
		setProperty('randomFairies.x', 2300)
		if fairyType == 1 then
			doTweenX('fairyFlying1', 'randomFairies', -2500, 5, 'linear')
			objectPlayAnimation('randomFairies', 'Fairy 1', true)
		else
			setProperty('randomFairies.velocity.x', -1800)
			objectPlayAnimation('randomFairies', 'Fairy 2', true)
			runTimer('fairy2Set1', 0.25)
		end
		if fairiesSpawned == 1 then
			randomStepHit = getRandomInt(304, 446)
		elseif fairiesSpawned == 2 then
			randomStepHit = getRandomInt(736, 816)
		end
	end

if songName == 'stubborness' then
	if curStep == 546 then
		fairyType = 3
		setProperty('randomFairies.x', 2300)
		doTweenX('fairyFlying2', 'randomFairies', 1200, 0.5, 'cubeOut')
		objectPlayAnimation('randomFairies', 'Fairy Scream', true)
		runTimer('fairy3BeGone', 4.25)
	end
end
if songName == 'stubborness' then
	if curStep == 548 then
		triggerEvent('Play Animation', 'shootFairy', 'dad')
	end
end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'fairy2Set1' then
		fairy2Event = 1
		runTimer('fairy2Set2', 1.5)
	elseif tag == 'fairy2Set2' then
		fairy2Event = 2
		runTimer('fairy2ResetVelocity', 1.5)
	elseif tag == 'fairy2ResetVelocity' then
		fairy2Event = 0
		setProperty('randomFairies.velocity.x', 0)
	elseif tag == 'fairy3BeGone' then
		setProperty('randomFairies.x', 2300)
	end
end