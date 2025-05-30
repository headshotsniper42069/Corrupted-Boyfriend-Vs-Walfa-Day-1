package;

import flixel.input.keyboard.FlxKey;
import lime.app.Application;
import flixel.tweens.FlxEase;
import flixel.addons.display.FlxBackdrop;
#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = '';

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<FreeplayItem>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];
	var freeplayArtArray:Array<FlxSprite> = []; // for the cool animation when you back out of a song
	var freeplayArtInitPosition:Array<Float> = [];
	var bg:FlxSprite;
	var backdrop:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;
	var backdropColorTween:FlxTween;

	var ayayaIntensifiesBuffer:String = '';

	var rectangles:Array<FlxSprite> = [];

	var descriptionBG:FlxSprite;

	var descriptionText:FlxText;

	override function create()
	{
		//Paths.clearStoredMemory();
		//Paths.clearUnusedMemory();
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();

		var songsToCheck:Array<String> = StoryMenuState.currentSongs;

		for (i in 0...WeekData.weeksList.length) {
			if(weekIsLocked(WeekData.weeksList[i])) continue;
			
			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}
			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				if (song[0] == 'Ayaya' && FlxG.save.data.ayaya != "Completed") continue;
				if (song[4] == null)
				{
					song[4] = [0, 0];
					trace("freeplay shrine array for " + song[0] + " is null, setting valid values");
				}
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				if (song[5] == null)
				{
					song[5] = '';
					song[6] = [0, 0, 0.9];
					song[6][2] = 1;
					trace("freeplay art stuff for " + song[0] + " is null, setting valid values");
				}
				if (song[7] == null)
				{
					song[7] = '';
					trace("freeplay seperate difficulty stuff for " + song[0] + " is null, setting as blank");
				}
				if (song[8] == null)
				{
					song[8] = 'Description goes here';
					trace("freeplay description for " + song[0] + " is null, setting placeholder");
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]), [song[4][0], song[4][1]], song[7], song[8]);
				var freeplayArt:FlxSprite = new FlxSprite(400 + song[6][0], 50 + song[6][1]);
				if (song[0] == "Donation Frustration") song[5] = "Donation";
				if (Paths.image("Freeplay Art/" + song[5]) != null)
					freeplayArt.loadGraphic(Paths.image("Freeplay Art/" + song[5]));
				freeplayArt.scale.set(song[6][2], song[6][2]);
				freeplayArt.updateHitbox();
				freeplayArt.alpha = 0;
				freeplayArt.antialiasing = !ClientPrefs.lowQuality;
				// using a FlxGroup is too much fuss!
				freeplayArtArray.push(freeplayArt);
				freeplayArtInitPosition.push(freeplayArt.x);
				freeplayArt.x += 50;
			}
		}
		WeekData.loadTheFirstEnabledMod();

		/*		//KIND OF BROKEN NOW AND ALSO PRETTY USELESS//

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		for (i in 0...initSonglist.length)
		{
			if(initSonglist[i] != null && initSonglist[i].length > 0) {
				var songArray:Array<String> = initSonglist[i].split(":");
				addSong(songArray[0], 0, songArray[1], Std.parseInt(songArray[2]));
			}
		}*/

		bg = new FlxSprite(0, 0, Paths.image("freeplay/Background"));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		backdrop = new FlxBackdrop(Paths.image("storymenu/freeplay checkers"));
		backdrop.velocity.set(50, 50);
		add(backdrop);

		for (i in 0...3)
		{
			var rectangle:FlxSprite;
			if (i != 2)
			{
				rectangle = new FlxSprite(640, 280 + (120 * i)).makeGraphic(30, 730);
				rectangle.scale.y *= 1.5;
			}
			else
			{
				rectangle = new FlxSprite(640, 520).makeGraphic(250, 1280);
			}
			rectangle.y -= 300;
			rectangle.x -= 500;
			rectangle.angle = -45;
			rectangle.alpha = 0.15;
			add(rectangle);
			rectangles.push(rectangle);
		}

		grpSongs = new FlxTypedGroup<FreeplayItem>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:FreeplayItem = new FreeplayItem(90, 320, songs[i].songName, songs[i].shrineTextValues[0], songs[i].shrineTextValues[1]);
			songText.targetY = i - curSelected;
			grpSongs.add(songText);
			songText.snapToPosition();
			rectangles.push(songText.backgroundshrine);

			Paths.currentModDirectory = songs[i].folder;
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter, false, true);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("Topsicle.ttf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		if(curSelected >= songs.length) curSelected = 0;
		bg.color = songs[curSelected].color;
		backdrop.color = songs[curSelected].color;
		intendedColor = bg.color;
		for (designSprite in rectangles)
		{
			designSprite.color = songs[curSelected].color;
		}

		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		for (freeplayActualArt in freeplayArtArray)
		{
			add(freeplayActualArt);
		}

		descriptionBG = new FlxSprite(0, FlxG.height - 125).makeGraphic(FlxG.width, 125, 0xFF000000);
		descriptionBG.alpha = 0.6;
		add(descriptionBG);

		descriptionText = new FlxText(10, 600, 0, "If you can see this, something is wrong", 32);
		descriptionText.setFormat("PC-9800", 32);
		add(descriptionText);
		
		changeSelection();
		changeDiff();
		
		super.create();
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int, shrineTextValues:Array<Float>, seperateDifficulties:String, description:String)
	{
		if (songName == 'Ayaya')
		{
			if (FlxG.save.data.ayaya == 'Completed')
				songs.push(new SongMetadata(songName, weekNum, songCharacter, color, shrineTextValues, seperateDifficulties, description));
		}
		else
			songs.push(new SongMetadata(songName, weekNum, songCharacter, color, shrineTextValues, seperateDifficulties, description));
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	/*public function addWeek(songs:Array<String>, weekNum:Int, weekColor:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);
			this.songs[this.songs.length-1].color = weekColor;

			if (songCharacters.length != 1)
				num++;
		}
	}*/

	var instPlaying:Int = -1;
	public static var vocals:FlxSound = null;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + ratingSplit.join('.') + '%)';
		positionHighscore();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		if(songs.length > 1)
		{
			if (upP)
			{
				changeSelection(-shiftMult);
				holdTime = 0;
			}
			if (downP)
			{
				changeSelection(shiftMult);
				holdTime = 0;
			}

			if(controls.UI_DOWN || controls.UI_UP)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					changeDiff();
				}
			}

			if(FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
				changeSelection(-shiftMult * FlxG.mouse.wheel, false);
				changeDiff();
			}
		}

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		else if (controls.UI_RIGHT_P)
			changeDiff(1);
		else if (upP || downP) changeDiff();

		if (controls.BACK)
		{
			persistentUpdate = false;
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			for (designSprite in rectangles)
			{
				FlxTween.cancelTweensOf(designSprite);
				designSprite.alpha = 0.15;
			}
			MusicBeatState.switchState(new MainMenuState());
		}

		if(ctrl)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if(space)
		{
			if(instPlaying != curSelected)
			{
				#if PRELOAD_ALL
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;
				Paths.currentModDirectory = songs[curSelected].folder;
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				if (PlayState.SONG.needsVoices)
					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
				else
					vocals = new FlxSound();

				FlxG.sound.list.add(vocals);
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
				vocals.play();
				vocals.persist = true;
				vocals.looped = true;
				vocals.volume = 0.7;
				instPlaying = curSelected;
				#end
			}
		}

		else if (accepted)
		{
			persistentUpdate = false;
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
			/*#if MODS_ALLOWED
			if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
			#else
			if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
			#end
				poop = songLowercase;
				curDifficulty = 1;
				trace('Couldnt find file');
			}*/
			trace(poop);

			try {
				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;
	
				trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
				if(colorTween != null) {
					colorTween.cancel();
				}
				
				for (designSprite in rectangles)
				{
					FlxTween.cancelTweensOf(designSprite);
				}
				
				if (FlxG.keys.pressed.SHIFT){
					LoadingState.loadAndSwitchState(new ChartingState());
				}else{
					LoadingState.loadAndSwitchState(new PlayState());
				}
				
				FlxG.sound.music.volume = 0;

				destroyFreeplayVocals();
			}
			catch (e) {
				Application.current.window.alert("An error has been caught: " + e, "Chart Not Found?");
				FlxG.sound.play(Paths.sound('cancelMenu'));
			}
		}
		else if(controls.RESET)
		{
			persistentUpdate = false;
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
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
						vocals.pause();
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
		for (designSprite in rectangles)
		{
			designSprite.alpha = 0.15;
		}
		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
		positionHighscore();
	}

	var previousSelected:Int = -1;
	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		previousSelected = curSelected;
		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
			
		var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			if(colorTween != null) {
				backdropColorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
			backdropColorTween = FlxTween.color(backdrop, 1, backdrop.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					backdropColorTween = null;
				}
			});
			for (designSprite in rectangles)
			{
				FlxTween.cancelTweensOf(designSprite);
				FlxTween.color(designSprite, 1, designSprite.color, intendedColor);
			}
		}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
		//	iconArray[i].alpha = 0.6;
		}

	//	iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.textsprite.alpha = 0.75;
			item.backgroundshrine.alpha = 0.15;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				item.textsprite.alpha = 1;
				item.backgroundshrine.alpha = 0.3;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		
		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if (songs[curSelected].seperateDifficulties != "")
			diffStr = songs[curSelected].seperateDifficulties;

		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

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
		FlxTween.cancelTweensOf(freeplayArtArray[curSelected]);
		if (freeplayArtArray[curSelected].width > 32)
			FlxTween.tween(freeplayArtArray[curSelected], {x: freeplayArtInitPosition[curSelected], alpha: 1}, 0.35, {ease:FlxEase.cubeOut});
		if (previousSelected != curSelected)
		{
			FlxTween.cancelTweensOf(freeplayArtArray[previousSelected]);
			FlxTween.tween(freeplayArtArray[previousSelected], {x: freeplayArtInitPosition[previousSelected] + 50, alpha: 0}, 0.25, {ease:FlxEase.cubeOut});
		}

		descriptionText.text = songs[curSelected].description;
	}

	private function positionHighscore() {
		scoreText.x = FlxG.width - scoreText.width - 6;

		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var shrineTextValues:Array<Float> = [];
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";
	public var seperateDifficulties:String = "";
	public var description:String;

	public function new(song:String, week:Int, songCharacter:String, color:Int, shrineTextValues:Array<Float>, seperateDifficulties:String, description:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		this.shrineTextValues = shrineTextValues;
		this.seperateDifficulties = seperateDifficulties;
		this.description = description;
		if(this.folder == null) this.folder = '';
	}
}