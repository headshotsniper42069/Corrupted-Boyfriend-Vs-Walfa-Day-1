function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'mokou_death'); --Character json file for the death animation
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'dead'); --put in mods/sounds/
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'lacking_game_over'); --put in mods/music/
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd'); --put in mods/music/
end