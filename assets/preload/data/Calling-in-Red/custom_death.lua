function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'sc_dead'); --Character json file for the death animation
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'phone'); --put in mods/sounds/
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver'); --put in mods/music/
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd'); --put in mods/music/
end