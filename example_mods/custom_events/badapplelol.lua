function onCreatePost()
	makeLuaSprite('whitebg', '', 0, 0)
	setScrollFactor('whitebg', 0, 0)
	makeGraphic('whitebg', 3840, 2160, 'ffffff')
	addLuaSprite('whitebg', false)
	setProperty('whitebg.alpha', 0)
	screenCenter('whitebg', 'xy')
end
function onEvent(n, v1, v2)
	if n == 'badapplelol' and string.lower(v1) == 'a' then
		doTweenAlpha('applebadxd69', 'whitebg', 1, v2, 'linear')
		doTweenColor('badapplexd', 'boyfriend', '000000', v2, 'linear')
		doTweenColor('badapplexd1', 'dad', '000000', v2, 'linear')
		doTweenColor('badapplexd2', 'gf', '000000', v2, 'linear')
		doTweenColor('badapplexd6', 'healthBar', '000000', v2, 'linear')
		doTweenColor('badapplexd100', 'iconP1', '000000', v2, 'linear')
		doTweenColor('badapplexd10', 'iconP2', '000000', v2, 'linear')
		if songName == 'atomic' then
			doTweenColor('badapplexd110', 'Buddhist', '000000', v2, 'linear')
	   		doTweenColor('badapplexd111', 'Medical', '000000', v2, 'linear')
	   		doTweenColor('badapplexd112', 'Smol', '000000', v2, 'linear')
	   		doTweenColor('badapplexd113', 'Bnuy', '000000', v2, 'linear')
	   		doTweenColor('badapplexd114', 'Mommy', '000000', v2, 'linear')
	   		doTweenColor('badapplexd115', 'Tomboy', '000000', v2, 'linear')
	   		doTweenColor('badapplexd116', 'DJ Role', '000000', v2, 'linear')
		elseif songName == 'Brainfreeze' then
			doTweenColor('badapplexd110', 'Pyro', '000000', v2, 'linear')
			doTweenColor('badapplexd111', 'Ripper', '000000', v2, 'linear')
			doTweenColor('badapplexd112', 'Snow', '000000', v2, 'linear')
			doTweenColor('badapplexd113', 'diamondtester', '000000', v2, 'linear')
		end
	end
	if n == 'badapplelol' and string.lower(v1) == 'b' then
		doTweenAlpha('applebadxd', 'whitebg', 0, v2, 'linear')
		doTweenColor('badapplexd3', 'boyfriend', 'FFFFFF', v2, 'linear')
		doTweenColor('badapplexd4', 'dad', 'FFFFFF', v2, 'linear')
		doTweenColor('badapplexd5', 'gf', 'FFFFFF', v2, 'linear')
		doTweenColor('badapplexd7', 'healthBar', 'FFFFFF', v2, 'linear')
		doTweenColor('badapplexd101', 'iconP1', 'FFFFFF', v2, 'linear')
		doTweenColor('badapplexd102', 'iconP2', 'FFFFFF', v2, 'linear')
		if songName == 'atomic' then
			doTweenColor('badapplexd103', 'Buddhist', 'FFFFFF', v2, 'linear')
	    	doTweenColor('badapplexd104', 'Medical', 'FFFFFF', v2, 'linear')
	    	doTweenColor('badapplexd105', 'Smol', 'FFFFFF', v2, 'linear')
	    	doTweenColor('badapplexd106', 'Bnuy', 'FFFFFF', v2, 'linear')
	    	doTweenColor('badapplexd107', 'Mommy', 'FFFFFF', v2, 'linear')
	    	doTweenColor('badapplexd108', 'Tomboy', 'FFFFFF', v2, 'linear')
	    	doTweenColor('badapplexd109', 'DJ Role', 'FFFFFF', v2, 'linear')
		elseif songName == 'Brainfreeze' then
			doTweenColor('badapplexd103', 'Pyro', 'FFFFFF', v2, 'linear')
			doTweenColor('badapplexd104', 'Ripper', 'FFFFFF', v2, 'linear')
			doTweenColor('badapplexd105', 'Snow', 'FFFFFF', v2, 'linear')
			doTweenColor('badapplexd106', 'diamondtester', 'FFFFFF', v2, 'linear')
		end
	end
end