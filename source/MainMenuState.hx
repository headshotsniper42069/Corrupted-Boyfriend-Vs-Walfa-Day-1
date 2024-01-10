package;

import flixel.util.FlxGradient;
import sys.FileSystem;
import flixel.math.FlxPoint;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.3'; //This was used for Discord RPC
	public static var cyberScapeVersion:String = 'Version 1'; //This is used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story mode',
		'freeplay',
		'awards',
		'gallery',
		'credits',
		'options'
	];

	var debugKeys:Array<FlxKey>;

	var randomCharacters:FlxSprite;
	var rightSideBar:FlxSprite;

	var randomCharacterAnimations:Array<String> = ["Aya_Idle", "Meiling_Bounce", "Mistr00s_Bounce", "Reimu_Bounce", "Tsukasa_Bounce", "Jack_Idle", "Pelo_Reimu_Idle", "Pelo_R_Idle", "Remilia_idle"];
	var randomCharacterAnimations2:Array<String> = ["Koishi_Bounce", "Yukari_Idle", "Yukkuri_Bounce"];

	var attributes:Array<Array<Float>> = [ // 0 = x, 1 = y, 2 = scale
	[240, 60, 1.420], // Ayayas
	[-10, 5, 0.78], // Meling
	[120, 70, 0.785], // Mistress
	[140, 100, 0.69], // Reimu, cool number dude
	[30, 155, 0.6], // Catgirl
	[-115, 90, 1.3], // Jack
	[15, 105, 1.456], // Stubbornness
	[-175, 95, 1.48], // Scarlet Dance
	[-190, -5, 1.455] // Scarlet Dance...on Ghetto Patrol
	];

	var attributes2:Array<Array<Float>> = [ // 0 = x, 1 = y, 2 = scale
	[120, 100, 0.675], // Coarse Salt
	[-80, -35, 0.735], // https://www.youtube.com/watch?v=4ZX9T0kWb4Y
	[-40, 225, 0.61], // Easy Taker
	];

	var characterSet:Int = 0; // 0 = Set 1, 1 = Set 2

	var whichone:Int = 0;

	var character:Int;

	var resetTimer:Float = 0;

	var ayayaIntensifiesBuffer:String = '';

	var gradientOverlays:Array<FlxSprite> = [];

	override function create()
	{
		Main.fpsVar.visible = ClientPrefs.showFPS;
		
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		if (FlxG.save.data.ayaya == null)
			FlxG.save.data.ayaya = 'Not Yet';

		if (Sys.args().contains("--shameisentlink"))
		{
			FlxG.save.data.ayaya = 'Sent Link';
		}

		if (Sys.args().contains("--shameicomplete"))
		{
			FlxG.save.data.ayaya = 'Completed';
		}

		Conductor.changeBPM(TitleState.beatsPerMinute);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('mainmenu/background'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 0.925));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		characterSet = FlxG.random.int(1, 2);
		if (characterSet != 1)
		{
			attributes = attributes2;
			randomCharacterAnimations = randomCharacterAnimations2;
		}

		trace('Character set $characterSet loaded!');

		randomizeCharacter();
		randomCharacters = new FlxSprite();
		randomCharacters.frames = Paths.getSparrowAtlas('mainmenu/characters$characterSet');
		if (Sys.args().contains("--mainmenu"))
		{
			for (number in 0...randomCharacterAnimations.length)
			{
				randomCharacters.animation.addByPrefix('animation ' + number, randomCharacterAnimations[number], 24, true);
			}
			randomCharacters.animation.play('animation ' + whichone);
			randomCharacters.setPosition(attributes[whichone][0], attributes[whichone][1]);
			randomCharacters.scale.set(attributes[whichone][2], attributes[whichone][2]);
		}
		else
		{
			randomCharacters.animation.addByPrefix('bounce', randomCharacterAnimations[character], 24, false);
			randomCharacters.animation.play('bounce', true);
			randomCharacters.setPosition(attributes[character][0], attributes[character][1]);
			randomCharacters.scale.set(attributes[character][2], attributes[character][2]);
		}
		randomCharacters.antialiasing = ClientPrefs.globalAntialiasing;
		randomCharacters.updateHitbox();
		add(randomCharacters);
		rightSideBar = new FlxSprite(680, -195).loadGraphic(Paths.image('mainmenu/bar'));
		rightSideBar.scale.set(0.685, 0.685);
		rightSideBar.antialiasing = ClientPrefs.globalAntialiasing;
		add(rightSideBar);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 0.69;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(930, 225 + (i * 80));
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/buttons/' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			menuItem.updateHitbox();
		}

		var versionShit:FlxText = new FlxText(12, FlxG.height - 64, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Echoes of Cyberscape " + cyberScapeVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		
		if (character == 0 && characterSet == 1)
		{
			for (i in 0...4)
			{
				var gradientOverlay:FlxSprite = new FlxSprite();
				switch (i)
				{
					case 0:
						gradientOverlay = FlxGradient.createGradientFlxSprite(1280, 480, [0xFF000000, 0x00000000], 1, 90);
					case 1:
						gradientOverlay = FlxGradient.createGradientFlxSprite(1280, 480, [0x00000000, 0xFF000000], 1, 90);
						gradientOverlay.y = FlxG.height - gradientOverlay.height;
					case 2:
						gradientOverlay = FlxGradient.createGradientFlxSprite(480, 720, [0xFF000000, 0x00000000], 1, 180);
						gradientOverlay.x = FlxG.width - gradientOverlay.width;
					case 3:
						gradientOverlay = FlxGradient.createGradientFlxSprite(480, 720, [0x00000000, 0xFF000000], 1, 180);
				}
				gradientOverlays.push(gradientOverlay);
			}
			for (overlay in gradientOverlays)
			{
				add(overlay);
			}
		}

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
	/*	var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		} */
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (character == 0 && characterSet == 1 && FlxG.sound.music.volume > 0.1 && !selectedSomethin)
		{
			FlxG.sound.music.volume -= 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume -= 0.5 * elapsed;
		}
		else if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (Sys.args().contains("--mainmenu"))
		{
			Application.current.window.title = "Current Animation: " + randomCharacterAnimations[whichone] + ", X: " + randomCharacters.x + ", Y: " + randomCharacters.y + ", Scale: " + randomCharacters.scale.x;
			
			if (FlxG.keys.pressed.LEFT)
				randomCharacters.x--;
			if (FlxG.keys.pressed.RIGHT)
				randomCharacters.x++;
			if (FlxG.keys.pressed.UP)
				randomCharacters.y--;
			if (FlxG.keys.pressed.DOWN)
				randomCharacters.y++;
			if (FlxG.keys.pressed.I)
			{
				randomCharacters.scale.x -= 0.001;
				randomCharacters.scale.y -= 0.001;
			}
			if (FlxG.keys.pressed.O)
			{
				randomCharacters.scale.x += 0.001;
				randomCharacters.scale.y += 0.001;
			}
			randomCharacters.updateHitbox();

			if (FlxG.keys.justPressed.K)
			{
				characterChanged("left");
			}
			if (FlxG.keys.justPressed.L)
			{
				characterChanged("right");
			}
		}
		else
		{
			if (!selectedSomethin)
			{
				if (FlxG.keys.firstJustPressed() != FlxKey.NONE && FlxG.save.data.ayaya != 'Completed')
				{
					var allowedKeys:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
					var keyPressed:FlxKey = FlxG.keys.firstJustPressed();
					var keyName:String = Std.string(keyPressed);
					if (allowedKeys.contains(keyName))
					{
						ayayaIntensifiesBuffer += keyName;
						trace(ayayaIntensifiesBuffer.toLowerCase());
						if (ayayaIntensifiesBuffer.toLowerCase().contains("ayaya"))
						{
							trace("oh shit it says the name oh no");
							FlxG.camera.alpha = 0;
							FlxTransitionableState.skipNextTransIn = true;
							Main.fpsVar.visible = false;
							FlxG.sound.music.volume = 0;
							try {
								FreeplayState.vocals.pause();
							}
							catch (e)
							{
								trace("freeplay vocals doesnt exist: ");
							}
							CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
							PlayState.SONG = Song.loadFromJson(Highscore.formatSong('Ayaya', 2), 'Ayaya');
							PlayState.storyDifficulty = 2;
							PlayState.alreadySeenClass = false;
							LoadingState.loadAndSwitchState(new PlayState());
						}
					}
				}
				if (controls.UI_UP_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}

				if (controls.UI_DOWN_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}

				if (controls.BACK)
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					MusicBeatState.switchState(new TitleState());
				}

				if (controls.ACCEPT)
				{
					if (optionShit[curSelected] == 'donate')
					{
						CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
					}
					else
					{
						selectedSomethin = true;
						FlxG.sound.play(Paths.sound('confirmMenu'));

						menuItems.forEach(function(spr:FlxSprite)
						{
							if (curSelected != spr.ID)
							{
								FlxTween.tween(spr, {alpha: 0}, 0.4, {
									ease: FlxEase.quadOut,
									onComplete: function(twn:FlxTween)
									{
										spr.kill();
									}
								});
							}
							else
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									var daChoice:String = optionShit[curSelected];

									switch (daChoice)
									{
										case 'story mode':
											MusicBeatState.switchState(new StoryMenuState());
										case 'freeplay':
											MusicBeatState.switchState(new FreeplayState());
										case 'awards':
											MusicBeatState.switchState(new AchievementsMenuState());
										case 'credits':
											MusicBeatState.switchState(new CreditsState());
										case 'options':
											LoadingState.loadAndSwitchState(new options.OptionsState());
										case 'gallery':
											LoadingState.loadAndSwitchState(new GalleryState());
									}
								});
							}
						});
					}
				}
				#if desktop
				else if (FlxG.keys.anyJustPressed(debugKeys))
				{
					selectedSomethin = true;
					MusicBeatState.switchState(new MasterEditorMenu());
				}
				#end
			}
		}
		if (FlxG.keys.pressed.A)
			resetTimer += elapsed;
		if (FlxG.keys.released.A)
			resetTimer = 0;
		if (resetTimer >= 3 && FlxG.save.data.ayaya != 'Not Yet')
		{
			FlxG.save.data.ayaya = 'Not Yet';
			FlxG.sound.play(Paths.sound('cancelMenu'));
			trace('Resetted Progress on Ayaya');
		}
		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				spr.centerOffsets();
			}
		});
	}

	function characterChanged(whichway:String)
	{
		attributes[whichone][0] = randomCharacters.x;
		attributes[whichone][1] = randomCharacters.y;
		attributes[whichone][2] = randomCharacters.scale.x;
		for (value in 0...3)
			trace(attributes[whichone][value]);
		if (whichway == "left")
		{
			whichone--;
			if (whichone < 0)
				whichone = randomCharacterAnimations.length - 1;
		}
		if (whichway == "right")
		{
			whichone++;
			if (whichone == randomCharacterAnimations.length)
				whichone = 0;
		}
		randomCharacters.animation.play('animation ' + whichone, true);
		randomCharacters.x = attributes[whichone][0];
		randomCharacters.y = attributes[whichone][1];
		randomCharacters.scale.x = attributes[whichone][2];
		randomCharacters.scale.y = attributes[whichone][2];
	}

	override function beatHit()
	{
		randomCharacters.animation.play('bounce', true);
	}

	function randomizeCharacter() // aya sonic.exe moment
	{
		character = FlxG.random.int(0, randomCharacterAnimations.length - 1);
		if (character == 0 && FlxG.save.data.ayaya != 'Completed' && characterSet == 1)
		{
			trace("Aya was supposed to show up, but the song hasnt been cleared");
			randomizeCharacter(); // refresh
		}
	}
}