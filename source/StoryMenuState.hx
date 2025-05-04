package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.input.keyboard.FlxKey;
import sys.FileSystem;
import flixel.tweens.FlxEase;
import lime.app.Application;
import flixel.graphics.frames.FlxFramesCollection;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;
import flixel.graphics.FlxGraphic;
import WeekData;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();

	var scoreText:FlxText;

	private static var lastDifficultyName:String = '';
	var curDifficulty:Int = 1;

	var txtWeekTitle:FlxText;
	var bgSprite:FlxSprite;
	var backdrop:FlxBackdrop;

	private static var curWeek:Int = 0;

	public static var currentSongs:Array<String> = [
	'Flashy Beats', 
	'Da Ze', 
	'Incident Solvers', 

	'China',
	'Mlem',
	'Atomic',

	'Adventuring',
	'Geistesmadchen',
	'Mind Breaker',

	'Bnnuy Blast',
	'Kugutsunette',
	'Crimson Eclipse',

//	'Gapped Out',

	'Mistr00s', 
	'Brainfreeze',
	'Baddest Bitpch', 
	'Calling in Red', 
	'Easy Taker', 
	'Lacking', 
	'My Memories', 
	'Perfectionism', 
	'Scarlet Dance', 
	'Smol', 
	'Stubborness'];

	public static var currentFreeplaySongs:Array<String> = ['Mistr00s', 'Brainfreeze','Baddest Bitpch', 'Brreasy Scarer', 
	'Calling in Red', 'Lacking', 'My Memories', 'Smol']; // for freeplay lunatic achievement, internet survivor and Easy Taker have none

	public var explanationOfDifficulties:Array<String> = ['
		For people getting used to the Controls.

		Only a few double notes
		','
		For people who enjoy Mods.

		Some double notes
		','
		A Difficulty worthy of boasting about.

		Normal chart
		','
		The Usual.
		'
	];

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var loadedWeeks:Array<WeekData> = [];

	var stuffAtTheTop:FlxTypedGroup<FlxSprite>;

	var leftTransparent:FlxSprite;
	var rightTransparent:FlxSprite;

	var explanationText:FlxText;

	var ayayaIntensifiesBuffer:String = '';

	override function create()
	{
		PlayState.isStoryMode = true;
		WeekData.reloadWeekFiles(true);
		GlobalFreeplayStuff.kooshThemePlayback = 0;
		if(curWeek >= WeekData.weeksList.length) curWeek = 0;
		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(930, 45, 0, "Score: 49324858", 36);
		scoreText.setFormat("DFPPOPCorn-W12", 24);
		scoreText.alpha = 0.7;
		txtWeekTitle = new FlxText(10, 10, 0, "", 32);
		txtWeekTitle.setFormat("DFPPOPCorn-W12", 24, FlxColor.WHITE, LEFT);
		txtWeekTitle.alpha = 0.7;
		
		explanationText = new FlxText(920, 75);
		explanationText.setFormat("DFPPOPCorn-W12", 16);
		explanationText.alpha = 0.7;

		bgSprite = new FlxSprite(0, 0, Paths.image("storymenu/background"));
		bgSprite.antialiasing = ClientPrefs.globalAntialiasing;
		add(bgSprite);

		backdrop = new FlxBackdrop(Paths.image("storymenu/background checkers"));
		backdrop.velocity.set(50, 50);
		add(backdrop);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var arrows:FlxFramesCollection = Paths.getSparrowAtlas("storymenu/Arrows");

		var num:Int = 0;
		for (i in 0...WeekData.weeksList.length)
		{
			var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var isLocked:Bool = weekIsLocked(WeekData.weeksList[i]);
			if(!isLocked || !weekFile.hiddenUntilUnlocked)
			{
				loadedWeeks.push(weekFile);
				WeekData.setDirectoryFromWeek(weekFile);
				var weekThing:MenuItem = new MenuItem(0, 0, weekFile.weekName, isLocked);
				weekThing.setGraphicSize(0, 680);
				weekThing.updateHitbox();
				weekThing.screenCenter(Y);
				weekThing.targetY = num;
				grpWeekText.add(weekThing);
				weekThing.antialiasing = ClientPrefs.globalAntialiasing;
				// weekThing.updateHitbox();

				// Needs an offset thingie

				num++;
			}
		}

		WeekData.setDirectoryFromWeek(loadedWeeks[0]);

		leftArrow = new FlxSprite(10, 0);
		leftArrow.frames = arrows;
		leftArrow.animation.addByPrefix('idle', "Normal_Left");
		leftArrow.animation.addByPrefix('press', "Press_Left", 24, false);
		leftArrow.animation.play('idle');
		leftArrow.setGraphicSize(Std.int(leftArrow.width * 0.4));
		leftArrow.updateHitbox();
		leftArrow.antialiasing = ClientPrefs.globalAntialiasing;
		leftArrow.screenCenter(Y);
		add(leftArrow);

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		
		stuffAtTheTop = new FlxTypedGroup<FlxSprite>();
		add(stuffAtTheTop);

		sprDifficulty = new FlxSprite(0, 0);
		sprDifficulty.screenCenter();
		sprDifficulty.antialiasing = ClientPrefs.globalAntialiasing;

		rightArrow = new FlxSprite();
		rightArrow.frames = arrows;
		rightArrow.animation.addByPrefix('idle', 'Normal_Right');
		rightArrow.animation.addByPrefix('press', "Press_Right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.antialiasing = ClientPrefs.globalAntialiasing;
		rightArrow.setGraphicSize(Std.int(rightArrow.width * 0.4));
		rightArrow.updateHitbox();
		rightArrow.x = 1280 - (rightArrow.width + 10);
		rightArrow.screenCenter(Y);
		add(rightArrow);

		leftTransparent = new FlxSprite().makeGraphic(355, 110, 0xFF000000);
		leftTransparent.alpha = 0.25;
		stuffAtTheTop.add(leftTransparent);

		rightTransparent = new FlxSprite().makeGraphic(360, 80, 0xFF000000);
		rightTransparent.x = 920;
		rightTransparent.alpha = 0.4;
		stuffAtTheTop.add(rightTransparent);
		
		stuffAtTheTop.add(scoreText);
		stuffAtTheTop.add(txtWeekTitle);
		stuffAtTheTop.add(sprDifficulty);
		stuffAtTheTop.add(explanationText);

		changeWeek();
		changeDifficulty();

		super.create();
	}

	override function closeSubState() {
		persistentUpdate = true;
		changeWeek();
		super.closeSubState();
	}

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 30, 0, 1)));
		if(Math.abs(intendedScore - lerpScore) < 10) lerpScore = intendedScore;

		scoreText.text = "Score: " + lerpScore;

		// FlxG.watch.addQuick('font', scoreText.font);

		if (!movedBack && !selectedWeek)
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
			var upP = controls.UI_UP_P;
			var downP = controls.UI_DOWN_P;
			if (upP)
				changeDifficulty(-1);

			if (downP)
				changeDifficulty(1);

			if (controls.UI_RIGHT_P)
			{
				rightArrow.animation.play('press', true);
				changeWeek(1);
			}
			else if (controls.UI_LEFT_P)
			{
				leftArrow.animation.play('press', true);
				changeWeek(-1);
			}
			else if (controls.UI_LEFT_P || controls.UI_RIGHT_P)
			{
				changeDifficulty();
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if(FlxG.keys.justPressed.CONTROL)
			{
				persistentUpdate = false;
				openSubState(new GameplayChangersSubstate());
			}
			else if(controls.RESET)
			{
				persistentUpdate = false;
				openSubState(new ResetScoreSubState('', curDifficulty, '', curWeek));
				//FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			else if (controls.ACCEPT)
			{
				selectWeek();
			}
		}
		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			MusicBeatState.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (!weekIsLocked(loadedWeeks[curWeek].fileName))
		{

			// We can't use Dynamic Array .copy() because that crashes HTML5, here's a workaround.
			var songArray:Array<String> = [];
			var leWeek:Array<Dynamic> = loadedWeeks[curWeek].songs;
			for (i in 0...leWeek.length) {
				songArray.push(leWeek[i][0]);
			}

			// Nevermind that's stupid lmao
			PlayState.storyPlaylist = songArray;
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = CoolUtil.getDifficultyFilePath(curDifficulty);
			if(diffic == null) diffic = '';

			try 
			{
				PlayState.storyDifficulty = curDifficulty;

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
				PlayState.campaignScore = 0;
				PlayState.campaignMisses = 0;
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					if (FileSystem.exists(Paths.video(WeekData.getCurrentWeek().songs[0][3])))
						LoadingState.loadAndSwitchState(new Cutscenes(WeekData.getCurrentWeek().songs[0][3]), true);
					else
						LoadingState.loadAndSwitchState(new PlayState(), true);
					FreeplayState.destroyFreeplayVocals();
				});
				if (stopspamming == false)
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));
					stopspamming = true;
					grpWeekText.members[curWeek].startFlashing();
					FlxTween.tween(grpWeekText.members[curWeek], {angle: 360}, 0.5, {ease:FlxEase.cubeOut});
				}
			}
			catch (e)
			{
				Application.current.window.alert("An error has been caught: " + e, "Chart Not Found?");
				stopspamming = false;
				selectedWeek = false;
				PlayState.isStoryMode = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
			}
		} else {
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}
	}

	var tweenDifficulty:FlxTween;
	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		WeekData.setDirectoryFromWeek(loadedWeeks[curWeek]);

		var diff:String = CoolUtil.difficulties[curDifficulty];
		var newImage:FlxGraphic = Paths.image('menudifficulties/' + Paths.formatToSongPath(diff));

		if(sprDifficulty.graphic != newImage)
		{
			sprDifficulty.loadGraphic(newImage);
			sprDifficulty.setGraphicSize(Std.int(sprDifficulty.width * 0.3));
			sprDifficulty.updateHitbox();
			sprDifficulty.x = 926;
		//	sprDifficulty.x += (308 - sprDifficulty.width) / 2;
			sprDifficulty.alpha = 0;
			sprDifficulty.y = -10;

			if(tweenDifficulty != null) tweenDifficulty.cancel();
			tweenDifficulty = FlxTween.tween(sprDifficulty, {y: 0, alpha: 1}, 0.07, {onComplete: function(twn:FlxTween)
			{
				tweenDifficulty = null;
			}});
		}
		lastDifficultyName = diff;

		#if !switch
		intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		#end

		if (explanationOfDifficulties[curDifficulty] == null)
			explanationText.text = "
			Couldn't find text data for this difficulty!

			Did you add a custom difficulty?
		";
		else
			explanationText.text = explanationOfDifficulties[curDifficulty];
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= loadedWeeks.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = loadedWeeks.length - 1;

		var leWeek:WeekData = loadedWeeks[curWeek];
		WeekData.setDirectoryFromWeek(leWeek);

		var leName:String = leWeek.storyName;
		txtWeekTitle.text = leName;

		var bullShit:Int = 0;

		var unlocked:Bool = !weekIsLocked(leWeek.fileName);
		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && unlocked)
				item.alpha = 1;
			else
				item.alpha = 1;
			bullShit++;
		}
		PlayState.storyWeek = curWeek;
		if (leWeek.storyNameSettings == null)
		{
			txtWeekTitle.setPosition(10, 10);
			txtWeekTitle.size = 24;
			trace("didnt load settings");
		}
		else
		{
			txtWeekTitle.setPosition(leWeek.storyNameSettings[0], leWeek.storyNameSettings[1]);
			txtWeekTitle.size = Std.int(leWeek.storyNameSettings[2]);
			trace("loaded settings");
		}
		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5
		// to do: backing out animation if the week is locked

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));
		
		updateText();
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!weekCompleted.exists(leWeek.weekBefore) || !weekCompleted.get(leWeek.weekBefore)));
	}

	function updateText()
	{
		#if !switch
		intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		#end
	}
}
