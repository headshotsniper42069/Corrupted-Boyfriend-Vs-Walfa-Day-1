function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'applebfdeath'); --Character json file for the death animation
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'explosion'); --put in mods/sounds/
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'lacking_game_over'); --put in mods/music/
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd'); --put in mods/music/
end