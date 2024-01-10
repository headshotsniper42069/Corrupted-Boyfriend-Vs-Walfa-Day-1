local enabled = false
function onCreate()
	makeLuaSprite("blackoverlayformiddle", "", 0, 0)
	makeGraphic("blackoverlayformiddle", 1280, 720, "000000")
	addLuaSprite("blackoverlayformiddle")
	setProperty("blackoverlayformiddle.alpha", 0)
	setObjectCamera("blackoverlayformiddle", "hud")
end

function onEvent(name, value1, value2)
	if name == 'Middlescroll Event' then
		if not middlescroll then
			if not enabled then
			--	setPropertyFromGroup('playerStrums', 0, 'x', defaultPlayerStrumX0 - 320);
			--	setPropertyFromGroup('playerStrums', 1, 'x', defaultPlayerStrumX1 - 320);
			--	setPropertyFromGroup('playerStrums', 2, 'x', defaultPlayerStrumX2 - 320);
			--	setPropertyFromGroup('playerStrums', 3, 'x', defaultPlayerStrumX3 - 320);
			--	setPropertyFromGroup('opponentStrums', 2, 'x', defaultOpponentStrumX2 + 640);
			--	setPropertyFromGroup('opponentStrums', 3, 'x', defaultOpponentStrumX3 + 640);
				noteTweenX("player1", 4, defaultPlayerStrumX0 - 320, 0.5, "cubeOut")
				noteTweenX("player2", 5, defaultPlayerStrumX1 - 320, 0.5, "cubeOut")
				noteTweenX("player3", 6, defaultPlayerStrumX2 - 320, 0.5, "cubeOut")
				noteTweenX("player4", 7, defaultPlayerStrumX3 - 320, 0.5, "cubeOut")
				noteTweenX("opponent1", 2, defaultOpponentStrumX2 + 640, 0.5, "cubeOut")
				noteTweenX("opponent2", 3, defaultOpponentStrumX3 + 640, 0.5, "cubeOut")
				noteTweenAlpha("opponentalpha1", 0, 0.35, 0.5, "cubeOut")
				noteTweenAlpha("opponentalpha2", 1, 0.35, 0.5, "cubeOut")
				noteTweenAlpha("opponentalpha3", 2, 0.35, 0.5, "cubeOut")
				noteTweenAlpha("opponentalpha4", 3, 0.35, 0.5, "cubeOut")
				doTweenAlpha("blackoverlayappear", "blackoverlayformiddle", 0.45, 0.5, "cubeOut")

				for i = 0, getProperty('notes.length')-1 do
					if getPropertyFromGroup('notes', i, 'mustPress') == false then
						setPropertyFromGroup('notes', i, 'alpha', 0.35)
					end
				end
				for i = 0, getProperty('unspawnNotes.length')-1 do
					if getPropertyFromGroup('unspawnNotes', i, 'mustPress') == false then
						setPropertyFromGroup('unspawnNotes', i, 'alpha', 0.35)
					end
				end
				enabled = true
			else
				noteTweenX("player1", 4, defaultPlayerStrumX0, 0.5, "cubeOut")
				noteTweenX("player2", 5, defaultPlayerStrumX1, 0.5, "cubeOut")
				noteTweenX("player3", 6, defaultPlayerStrumX2, 0.5, "cubeOut")
				noteTweenX("player4", 7, defaultPlayerStrumX3, 0.5, "cubeOut")
				noteTweenX("opponent1", 2, defaultOpponentStrumX2, 0.5, "cubeOut")
				noteTweenX("opponent2", 3, defaultOpponentStrumX3, 0.5, "cubeOut")
				noteTweenAlpha("opponentalpha1", 0, 1, 0.5, "cubeOut")
				noteTweenAlpha("opponentalpha2", 1, 1, 0.5, "cubeOut")
				noteTweenAlpha("opponentalpha3", 2, 1, 0.5, "cubeOut")
				noteTweenAlpha("opponentalpha4", 3, 1, 0.5, "cubeOut")
				doTweenAlpha("blackoverlaydisappear", "blackoverlayformiddle", 0, 0.5, "cubeOut")

				for i = 0, getProperty('notes.length')-1 do
					if getPropertyFromGroup('notes', i, 'mustPress') == false then
						setPropertyFromGroup('notes', i, 'alpha', 1)
					end
				end
				for i = 0, getProperty('unspawnNotes.length')-1 do
					if getPropertyFromGroup('unspawnNotes', i, 'mustPress') == false then
						setPropertyFromGroup('unspawnNotes', i, 'alpha', 1)
					end
				end
				enabled = false
			end
		end
	end
end