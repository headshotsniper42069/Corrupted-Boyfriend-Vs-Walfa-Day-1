package;

import cpp.abi.Abi;
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
	public static var cyberScapeVersion:String = '2.0'; //This is used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story mode',
		'freeplay',
		'gallery',
		'credits',
		'options'
	];

	var debugKeys:Array<FlxKey>;

	var randomCharacters:FlxSprite;
	var rightSideBar:FlxSprite; // Now left side since v2

	var resetTimer:Float = 0;
	var ayayaIntensifiesBuffer:String = '';

	var menuCharacters:Array<FlxTypedGroup<FlxSprite>> = [];
	var menuCharactersInit:Array<Array<Float>> = []; // initial y positions
	var elapsedTime:Float = 0;

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
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/background'));
		bg.scrollFactor.set(0, yScroll);
	//	bg.setGraphicSize(Std.int(bg.width * 0.925));
	//	bg.updateHitbox();
	//	bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		rightSideBar = new FlxSprite().loadGraphic(Paths.image('mainmenu/bar'));
	//	rightSideBar.scale.set(0.685, 0.685);
		rightSideBar.antialiasing = ClientPrefs.globalAntialiasing;
		add(rightSideBar);
		
		// magenta.scrollFactor.set();

		var scale:Float = 0.69;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/
		
		var characters:Array<Array<String>> = [["pelo", "fumo"], ["silly", "flandre"], ["gallery"], ["credits"], ["settings"]];

		var charactersPositions:Map<String, Array<Float>> = ["pelo" => [625, 0, 0.6], "fumo" => [975, 255, 0.6], "silly" => [750, 50, 1], "flandre" => [770, 220, 0.7], "gallery" => [750, 150, 0.7], "credits" => [780, 150, 0.3], "settings" => [770, 175, 0.5]];
		var whichLoop:Int = 0;
		for (charactersList in characters)
		{
			var characterTypedGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
			characterTypedGroup.ID = whichLoop;
			menuCharacters.push(characterTypedGroup);
			menuCharactersInit.push([]);
			add(characterTypedGroup);

			for (i in 0...charactersList.length)
			{
				trace(charactersList[i]);
				var characterPosition:Array<Float> = charactersPositions.get(charactersList[i]);

				var character:FlxSprite = new FlxSprite(characterPosition[0], characterPosition[1], Paths.image("mainmenu/" + charactersList[i]));
				character.ID = i;
				character.setGraphicSize(Std.int(character.width * characterPosition[2]));
				if (whichLoop != 0) character.updateHitbox(); // Avoid refactoring
				character.antialiasing = ClientPrefs.globalAntialiasing;
				menuCharacters[whichLoop].add(character);
			}

			whichLoop++;
		}

		var reimu:FlxSprite = new FlxSprite(875, 175, Paths.image("mainmenu/walfa"));
		reimu.ID = 2;
		reimu.setGraphicSize(Std.int(reimu.width * 0.8));
		reimu.antialiasing = ClientPrefs.globalAntialiasing;
		menuCharacters[0].add(reimu);

		for (characters in menuCharacters)
			characters.forEach(function(bruh:FlxSprite){
				menuCharactersInit[characters.ID].push(bruh.y);
			});

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
			
		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(50, 115 + (i * 140));
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/buttons/' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + "_basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + "_white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			menuItem.updateHitbox();
			if (optionShit[i] == 'options'){
				menuItem.x += 1100;
				menuItem.y -= 72;
			}
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
		elapsedTime += elapsed;

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (Sys.args().contains("--mainmenu")) trace("--mainmenu was used, but characters were removed");

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

					switch (curSelected)
					{
						case 0:
							for (i in 0...menuCharactersInit[curSelected].length)
							{
								FlxTween.num(menuCharactersInit[curSelected][i], menuCharactersInit[curSelected][i] - 600, 0.5, {ease:FlxEase.cubeOut}, function(bruh:Float){
									menuCharactersInit[curSelected][i] = bruh;
								});
							}
						default:
							for (i in 0...menuCharacters[curSelected].members.length)
							{
								FlxTween.tween(menuCharacters[curSelected].members[i], {x: FlxG.width}, 0.5, {ease:FlxEase.cubeOut});
							}
					}

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

		for (characters in menuCharacters)
		{
			for (character in characters.members)
			{
			//	character.y = menuCharactersInit[character.ID] + (Math.sin(elapsedTime * (1 + (character.ID / 2) / 2)) * 15);
				character.y = menuCharactersInit[characters.ID][character.ID] + ((characters.ID == 1 && character.ID == 1) ? 0 : (Math.sin(elapsedTime + (character.ID / 4) / 2) * 5));
			}
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

		for (characters in menuCharacters)
		{
			if (characters.ID == curSelected) 
				for (character in characters.members) character.alpha = 1;
			else 
				for (character in characters.members) character.alpha = 0;
		}

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
}