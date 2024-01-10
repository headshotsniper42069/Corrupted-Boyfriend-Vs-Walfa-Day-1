package editors;

import vlc.MP4Sprite;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import openfl.utils.Assets;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.ui.FlxButton;
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import flash.net.FileFilter;
import lime.system.Clipboard;
import haxe.Json;
#if sys
import sys.io.File;
import sys.FileSystem;
#end
import WeekData;

using StringTools;

class WeekEditorState extends MusicBeatState
{
	var txtWeekTitle:FlxText;
	var bgSprite:FlxSprite;
	var weekThing:MenuItem;
	var leftTransparent:FlxSprite;
	var missingFileText:FlxText;
	var videoIsPlaying:Bool = false;
	var videoInstances:Array<MP4Sprite> = [];

	var weekFile:WeekFile = null;
	public function new(weekFile:WeekFile = null)
	{
		super();
		this.weekFile = WeekData.createWeekFile();
		if(weekFile != null) this.weekFile = weekFile;
		else weekFileName = 'week1';
	}

	override function create() {
		txtWeekTitle = new FlxText(10, 10, 0, "", 32);
		txtWeekTitle.setFormat("DFPPOPCorn-W12", 24, FlxColor.WHITE, LEFT);
		txtWeekTitle.alpha = 0.7;
		bgSprite = new FlxSprite(0, 0, Paths.image("storymenu/background"));
		bgSprite.antialiasing = ClientPrefs.globalAntialiasing;
		add(bgSprite);

		weekThing = new MenuItem(0, bgSprite.y + 396, weekFile.weekName);
		weekThing.inEditor = true;
		weekThing.antialiasing = ClientPrefs.globalAntialiasing;
		weekThing.setGraphicSize(0, 680);
		weekThing.updateHitbox();
		weekThing.screenCenter();
		add(weekThing);
		
		missingFileText = new FlxText(0, 0, FlxG.width, "");
		missingFileText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missingFileText.borderSize = 2;
		missingFileText.visible = false;
		add(missingFileText); 

		leftTransparent = new FlxSprite().makeGraphic(355, 110, 0xFF000000);
		leftTransparent.alpha = 0.25;
		add(leftTransparent);
		add(txtWeekTitle);

		addEditorBox();
		reloadAllShit();

		FlxG.mouse.visible = true;

		super.create();
	}

	var UI_box:FlxUITabMenu;
	var blockPressWhileTypingOn:Array<FlxUIInputText> = [];
	function addEditorBox() {
		var tabs = [
			{name: 'Week', label: 'Week'},
			{name: 'Walfa Scenes', label: 'Cutscenes'},
			{name: 'Other', label: 'Other'}
		];
		UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.resize(250, 375);
		UI_box.x = FlxG.width - UI_box.width;
		UI_box.y = FlxG.height - UI_box.height;
		UI_box.scrollFactor.set();
		addWeekUI();
		addCutsceneUI();
		addOtherUI();
		
		UI_box.selected_tab_id = 'Week';
		add(UI_box);

		var loadWeekButton:FlxButton = new FlxButton(0, 650, "Load Week", function() {
			loadWeek();
		});
		loadWeekButton.screenCenter(X);
		loadWeekButton.x -= 120;
		add(loadWeekButton);
		
		var freeplayButton:FlxButton = new FlxButton(0, 650, "Freeplay", function() {
			MusicBeatState.switchState(new WeekEditorFreeplayState(weekFile));
			
		});
		freeplayButton.screenCenter(X);
		add(freeplayButton);
	
		var saveWeekButton:FlxButton = new FlxButton(0, 650, "Save Week", function() {
			saveWeek(weekFile);
		});
		saveWeekButton.screenCenter(X);
		saveWeekButton.x += 120;
		add(saveWeekButton);
	}

	var songsInputText:FlxUIInputText;
	var displayNameInputText:FlxUIInputText;
	var displayNamePositionXStepper:FlxUINumericStepper;
	var displayNamePositionYStepper:FlxUINumericStepper;
	var displayNamePositionSizeStepper:FlxUINumericStepper;
	var weekNameInputText:FlxUIInputText;
	var weekFileInputText:FlxUIInputText;

	var hideCheckbox:FlxUICheckBox;

	public static var weekFileName:String = 'week1';
	
	function addWeekUI() {
		var tab_group = new FlxUI(null, UI_box);
		tab_group.name = "Week";
		
		songsInputText = new FlxUIInputText(10, 30, 200, '', 8);
		blockPressWhileTypingOn.push(songsInputText);

		displayNameInputText = new FlxUIInputText(10, songsInputText.y + 40, 200, '', 8);
		blockPressWhileTypingOn.push(displayNameInputText);

		weekNameInputText = new FlxUIInputText(10, displayNameInputText.y + 60, 150, '', 8);
		blockPressWhileTypingOn.push(weekNameInputText);

		weekFileInputText = new FlxUIInputText(10, weekNameInputText.y + 40, 100, '', 8);
		blockPressWhileTypingOn.push(weekFileInputText);
		reloadWeekThing();

		hideCheckbox = new FlxUICheckBox(10, weekFileInputText.y + 40, null, null, "Hide Week from Story Mode?", 100);
		hideCheckbox.callback = function()
		{
			weekFile.hideStoryMode = hideCheckbox.checked;
		};

		displayNamePositionXStepper = new FlxUINumericStepper(10, hideCheckbox.y + 40, 5, 0, -9000, 9000, 0);
		displayNamePositionYStepper = new FlxUINumericStepper(displayNamePositionXStepper.x + 60, displayNamePositionXStepper.y, 5, 0, -9000, 9000, 0);

		displayNamePositionSizeStepper = new FlxUINumericStepper(10, displayNamePositionXStepper.y + 40, 1, 0, 10, 128, 0);

		tab_group.add(new FlxText(songsInputText.x, songsInputText.y - 18, 0, 'Songs:'));
		tab_group.add(new FlxText(displayNameInputText.x, displayNameInputText.y - 18, 0, 'Display Name:'));
		tab_group.add(new FlxText(weekNameInputText.x, weekNameInputText.y - 28, 0, 'Week Name (for Reset Score Menu, \nalso used for disc sprite):'));
		tab_group.add(new FlxText(weekFileInputText.x, weekFileInputText.y - 18, 0, 'Week File:'));
		tab_group.add(new FlxText(displayNamePositionXStepper.x, displayNamePositionXStepper.y - 18, 0, 'Display Name Position:'));
		tab_group.add(new FlxText(displayNamePositionSizeStepper.x, displayNamePositionSizeStepper.y - 18, 0, 'Display Name Size:'));

		tab_group.add(songsInputText);
		tab_group.add(displayNameInputText);
		tab_group.add(weekNameInputText);
		tab_group.add(weekFileInputText);
		tab_group.add(hideCheckbox);
		tab_group.add(displayNamePositionXStepper);
		tab_group.add(displayNamePositionYStepper);
		tab_group.add(displayNamePositionSizeStepper);
		UI_box.addGroup(tab_group);
	}

	var weekSongsList:FlxUIDropDownMenuCustom;
	var weekSongsForReal:Array<String> = [];
	var cutsceneInputText:FlxUIInputText;
	var videoTesterButton:FlxButton;
	function addCutsceneUI() {
		var tab_group = new FlxUI(null, UI_box);
		tab_group.name = "Walfa Scenes";
		for (songName in weekFile.songs)
		{
			weekSongsForReal.push(songName[0]);
			trace(songName[0]);
		}

		weekSongsList = new FlxUIDropDownMenuCustom(10, 30, FlxUIDropDownMenuCustom.makeStrIdLabelArray(weekSongsForReal, true), function(bruh:String)
		{
			trace(bruh);
		});
		cutsceneInputText = new FlxUIInputText(10, weekSongsList.y + 40, 200, '', 8);
		blockPressWhileTypingOn.push(cutsceneInputText);
		videoTesterButton = new FlxButton(10, cutsceneInputText.y + 40, "Play Video", function(){
			if (!videoIsPlaying && (FileSystem.exists(Paths.video(cutsceneInputText.text))))
			{
				var videoSprite:MP4Sprite = new MP4Sprite(0, 0);
				add(videoSprite);
				videoSprite.readyCallback = function(){
					videoSprite.setGraphicSize(640);
					videoSprite.updateHitbox();
					videoSprite.y = FlxG.height - videoSprite.height;
				};
				videoSprite.finishCallback = function(){
					videoIsPlaying = false;
				};
				videoIsPlaying = true;
				videoSprite.playVideo(Paths.video(cutsceneInputText.text));
				trace(videoSprite.x + ", " + videoSprite.y + ", " + videoSprite.width + ", " + videoSprite.height);
				videoInstances.push(videoSprite);
			}
		});
		tab_group.add(new FlxText(weekSongsList.x, weekSongsList.y - 18, 0, 'Song to Play Cutscene in:'));
		tab_group.add(new FlxText(cutsceneInputText.x, cutsceneInputText.y - 18, 0, 'Cutscene Video File:'));

		tab_group.add(videoTesterButton);
		tab_group.add(cutsceneInputText);
		tab_group.add(weekSongsList);

		UI_box.addGroup(tab_group);
	}

	var weekBeforeInputText:FlxUIInputText;
	var difficultiesInputText:FlxUIInputText;
	var lockedCheckbox:FlxUICheckBox;
	var hiddenUntilUnlockCheckbox:FlxUICheckBox;

	function addOtherUI() {
		var tab_group = new FlxUI(null, UI_box);
		tab_group.name = "Other";

		lockedCheckbox = new FlxUICheckBox(10, 30, null, null, "Week starts Locked", 100);
		lockedCheckbox.callback = function()
		{
			weekFile.startUnlocked = !lockedCheckbox.checked;
			hiddenUntilUnlockCheckbox.alpha = 0.4 + 0.6 * (lockedCheckbox.checked ? 1 : 0);
		};

		hiddenUntilUnlockCheckbox = new FlxUICheckBox(10, lockedCheckbox.y + 25, null, null, "Hidden until Unlocked", 110);
		hiddenUntilUnlockCheckbox.callback = function()
		{
			weekFile.hiddenUntilUnlocked = hiddenUntilUnlockCheckbox.checked;
		};
		hiddenUntilUnlockCheckbox.alpha = 0.4;

		weekBeforeInputText = new FlxUIInputText(10, hiddenUntilUnlockCheckbox.y + 55, 100, '', 8);
		blockPressWhileTypingOn.push(weekBeforeInputText);

		difficultiesInputText = new FlxUIInputText(10, weekBeforeInputText.y + 60, 200, '', 8);
		blockPressWhileTypingOn.push(difficultiesInputText);
		
		tab_group.add(new FlxText(weekBeforeInputText.x, weekBeforeInputText.y - 28, 0, 'Week File name of the Week you have\nto finish for Unlocking:'));
		tab_group.add(new FlxText(difficultiesInputText.x, difficultiesInputText.y - 20, 0, 'Difficulties:'));
		tab_group.add(new FlxText(difficultiesInputText.x, difficultiesInputText.y + 20, 0, 'Default difficulties are "Easy, Normal, Hard,\nLunatic" without quotes.'));
		tab_group.add(weekBeforeInputText);
		tab_group.add(difficultiesInputText);
		tab_group.add(hiddenUntilUnlockCheckbox);
		tab_group.add(lockedCheckbox);
		UI_box.addGroup(tab_group);
	}

	//Used on onCreate and when you load a week
	function reloadAllShit() {
		var weekString:String = weekFile.songs[0][0];
		for (i in 1...weekFile.songs.length) {
			weekString += ', ' + weekFile.songs[i][0];
		}
		songsInputText.text = weekString;
		displayNameInputText.text = weekFile.storyName;
		weekNameInputText.text = weekFile.weekName;
		weekFileInputText.text = weekFileName;

		hideCheckbox.checked = weekFile.hideStoryMode;

		weekBeforeInputText.text = weekFile.weekBefore;

		if (weekFile.storyNameSettings == null)
		{
			displayNamePositionXStepper.value = 10;
			displayNamePositionYStepper.value = 10;
			displayNamePositionSizeStepper.value = 24;
			weekFile.storyNameSettings = [10, 10, 24];
		}
		else
		{
			displayNamePositionXStepper.value = weekFile.storyNameSettings[0];
			displayNamePositionYStepper.value = weekFile.storyNameSettings[1];
			displayNamePositionSizeStepper.value = weekFile.storyNameSettings[2];
		}

		difficultiesInputText.text = '';
		if(weekFile.difficulties != null) difficultiesInputText.text = weekFile.difficulties;

		lockedCheckbox.checked = !weekFile.startUnlocked;
		
		hiddenUntilUnlockCheckbox.checked = weekFile.hiddenUntilUnlocked;
		hiddenUntilUnlockCheckbox.alpha = 0.4 + 0.6 * (lockedCheckbox.checked ? 1 : 0);

		for (weekSong in weekFile.songs)
		{
			if (weekSong[3] == null)
			{
				weekSong[3] = '';
				trace("cutscene value for " + weekSong[0] + " is null, setting valid value");
			}
			if (weekSong[4] == null)
			{
				weekSong[4] = [0, 0];
				trace("freeplay shrine array for " + weekSong[0] + " is null, setting valid values");
			}
			if (weekSong[5] == null)
			{
				weekSong[5] = '';
				weekSong[6] = [0, 0, 0.9];
				weekSong[6][2] = 1;
				trace("freeplay art array for " + weekSong[0] + " is null, setting valid values");
			}
		}
		weekSongsForReal = [];
		for (songName in weekFile.songs)
		{
			weekSongsForReal.push(songName[0]);
			trace(songName[0]);
		}
		weekSongsList.setData(FlxUIDropDownMenuCustom.makeStrIdLabelArray(weekSongsForReal, true));
		weekSongsList.selectedId = '0';
		cutsceneInputText.text = weekFile.songs[Std.parseInt(weekSongsList.selectedId)][3];

		reloadWeekThing();
		updateText();
	}

	function updateText()
	{
		var stringThing:Array<String> = [];
		for (i in 0...weekFile.songs.length) {
			stringThing.push(weekFile.songs[i][0]);
		}
		txtWeekTitle.text = weekFile.storyName;
		txtWeekTitle.setPosition(weekFile.storyNameSettings[0], weekFile.storyNameSettings[1]);
		txtWeekTitle.size = Std.int(weekFile.storyNameSettings[2]);
	}

	function reloadWeekThing() {
		weekThing.visible = true;
		missingFileText.visible = false;
		var assetName:String = weekNameInputText.text.trim();
		
		var isMissing:Bool = true;
		if(assetName != null && assetName.length > 0) {
			if( #if MODS_ALLOWED FileSystem.exists(Paths.modsImages('discs/' + assetName)) || #end
			Assets.exists(Paths.getPath('images/discs/' + assetName + '.png', IMAGE), IMAGE)) {
				weekThing.loadGraphic(Paths.image('discs/' + assetName));
				weekThing.setGraphicSize(0, 680);
				weekThing.updateHitbox();
				isMissing = false;
			}
		}

		if(isMissing) {
			weekThing.visible = false;
			missingFileText.visible = true;
			missingFileText.text = 'MISSING FILE: images/discs/' + assetName + '.png';
		}
		recalculateStuffPosition();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Week Editor", "Editting: " + weekFileName);
		#end
	}
	
	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
		if(id == FlxUIInputText.CHANGE_EVENT && (sender is FlxUIInputText)) {
			if(sender == weekFileInputText) {
				weekFileName = weekFileInputText.text.trim();
			} else if(sender == displayNameInputText) {
				weekFile.storyName = displayNameInputText.text.trim();
				updateText();
			} else if(sender == weekNameInputText) {
				weekFile.weekName = weekNameInputText.text.trim();
				reloadWeekThing();
			} else if(sender == songsInputText) {
				var splittedText:Array<String> = songsInputText.text.trim().split(',');
				for (i in 0...splittedText.length) {
					splittedText[i] = splittedText[i].trim();
				}

				while(splittedText.length < weekFile.songs.length) {
					weekFile.songs.pop();
				}

				for (i in 0...splittedText.length) {
					if(i >= weekFile.songs.length) { //Add new song
						weekFile.songs.push([splittedText[i], 'dad', [146, 113, 253]]);
					} else { //Edit song
						weekFile.songs[i][0] = splittedText[i];
						if(weekFile.songs[i][1] == null || weekFile.songs[i][1]) {
							weekFile.songs[i][1] = 'dad';
							weekFile.songs[i][2] = [146, 113, 253];
							weekFile.songs[i][3] = '';
						}
					}
				}
				updateText();
				trace(weekFile.songs);
			} else if(sender == weekBeforeInputText) {
				weekFile.weekBefore = weekBeforeInputText.text.trim();
			} else if(sender == difficultiesInputText) {
				weekFile.difficulties = difficultiesInputText.text.trim();
			} else if(sender == cutsceneInputText) {
				weekFile.songs[Std.parseInt(weekSongsList.selectedId)][3] = cutsceneInputText.text;
			};
		}
		else if(id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper)) {
			if (sender == displayNamePositionXStepper) {
				weekFile.storyNameSettings[0] = displayNamePositionXStepper.value;
			} else if (sender == displayNamePositionYStepper) {
				weekFile.storyNameSettings[1] = displayNamePositionYStepper.value;
			} else if (sender == displayNamePositionSizeStepper) {
				weekFile.storyNameSettings[2] = displayNamePositionSizeStepper.value;
			}
			updateText();
		}
		else if (id == FlxUITabMenu.CLICK_EVENT)
		{
			trace(data);
			if (data == 'Walfa Scenes')
			{
				weekSongsForReal = [];
				for (songName in weekFile.songs)
				{
					weekSongsForReal.push(songName[0]);
					trace(songName[0]);
				}
				weekSongsList.setData(FlxUIDropDownMenuCustom.makeStrIdLabelArray(weekSongsForReal, true));
			}
		}
		else if (id == FlxUIDropDownMenuCustom.CLICK_EVENT)
		{
			trace(data);
			if (weekFile.songs[Std.parseInt(weekSongsList.selectedId)][3] == null)
				weekFile.songs[Std.parseInt(weekSongsList.selectedId)][3] = '';
			cutsceneInputText.text = weekFile.songs[Std.parseInt(weekSongsList.selectedId)][3];
		}
	}
	
	override function update(elapsed:Float)
	{
		if(loadedWeek != null) {
			weekFile = loadedWeek;
			loadedWeek = null;

			reloadAllShit();
		}

		var blockInput:Bool = false;
		for (inputText in blockPressWhileTypingOn) {
			if(inputText.hasFocus) {
				FlxG.sound.muteKeys = [];
				FlxG.sound.volumeDownKeys = [];
				FlxG.sound.volumeUpKeys = [];
				blockInput = true;

				if(FlxG.keys.justPressed.ENTER) inputText.hasFocus = false;
				break;
			}
		}

		if(!blockInput) {
			FlxG.sound.muteKeys = TitleState.muteKeys;
			FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
			FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
			if(FlxG.keys.justPressed.ESCAPE) {
				for (video in videoInstances)
				{
					video.pause();
				}
				MusicBeatState.switchState(new editors.MasterEditorMenu());
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				FlxG.sound.music.loopTime = 9410;
				FlxG.sound.music.time = 9410;
			}
		}

		super.update(elapsed);

		missingFileText.screenCenter();
	}

	function recalculateStuffPosition() {
		weekThing.screenCenter();
	}

	private static var _file:FileReference;
	public static function loadWeek() {
		var jsonFilter:FileFilter = new FileFilter('JSON', 'json');
		_file = new FileReference();
		_file.addEventListener(Event.SELECT, onLoadComplete);
		_file.addEventListener(Event.CANCEL, onLoadCancel);
		_file.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_file.browse([jsonFilter]);
	}
	
	public static var loadedWeek:WeekFile = null;
	public static var loadError:Bool = false;
	private static function onLoadComplete(_):Void
	{
		_file.removeEventListener(Event.SELECT, onLoadComplete);
		_file.removeEventListener(Event.CANCEL, onLoadCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);

		#if sys
		var fullPath:String = null;
		@:privateAccess
		if(_file.__path != null) fullPath = _file.__path;

		if(fullPath != null) {
			var rawJson:String = File.getContent(fullPath);
			if(rawJson != null) {
				loadedWeek = cast Json.parse(rawJson);
				if(loadedWeek.weekName != null) //Make sure it's really a week
				{
					var cutName:String = _file.name.substr(0, _file.name.length - 5);
					trace("Successfully loaded file: " + cutName);
					loadError = false;

					weekFileName = cutName;
					_file = null;
					return;
				}
			}
		}
		loadError = true;
		loadedWeek = null;
		_file = null;
		#else
		trace("File couldn't be loaded! You aren't on Desktop, are you?");
		#end
	}

	/**
		* Called when the save file dialog is cancelled.
		*/
		private static function onLoadCancel(_):Void
	{
		_file.removeEventListener(Event.SELECT, onLoadComplete);
		_file.removeEventListener(Event.CANCEL, onLoadCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_file = null;
		trace("Cancelled file loading.");
	}

	/**
		* Called if there is an error while saving the gameplay recording.
		*/
	private static function onLoadError(_):Void
	{
		_file.removeEventListener(Event.SELECT, onLoadComplete);
		_file.removeEventListener(Event.CANCEL, onLoadCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_file = null;
		trace("Problem loading file");
	}

	public static function saveWeek(weekFile:WeekFile) {
		var data:String = Json.stringify(weekFile, "\t");
		if (data.length > 0)
		{
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data, weekFileName + ".json");
		}
	}
	
	private static function onSaveComplete(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved file.");
	}

	/**
		* Called when the save file dialog is cancelled.
		*/
		private static function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	/**
		* Called if there is an error while saving the gameplay recording.
		*/
	private static function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving file");
	}
}

class WeekEditorFreeplayState extends MusicBeatState
{
	var weekFile:WeekFile = null;
	public function new(weekFile:WeekFile = null)
	{
		super();
		this.weekFile = WeekData.createWeekFile();
		if(weekFile != null) this.weekFile = weekFile;
	}

	var bg:FlxSprite;
	var freeplayActualArt:FlxSprite;
	private var grpSongs:FlxTypedGroup<FreeplayItem>;
	private var iconArray:Array<HealthIcon> = [];
	private var inputTextBackgrounds:Array<FlxSprite> = [];

	var curSelected = 0;

	var descriptionBG:FlxSprite;

	var descriptionText:FlxText;

	override function create() {
		bg = new FlxSprite().loadGraphic(Paths.image('freeplay/Background'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;

		bg.color = FlxColor.WHITE;
		add(bg);

		freeplayActualArt = new FlxSprite();
		freeplayActualArt.antialiasing = ClientPrefs.globalAntialiasing;

		add(freeplayActualArt);

		grpSongs = new FlxTypedGroup<FreeplayItem>();
		add(grpSongs);

		for (i in 0...weekFile.songs.length)
		{
			if (weekFile.songs[i][4] == null)
			{
				weekFile.songs[i][4] = [0, 0];
				trace("freeplay shrine array for " + weekFile.songs[i][0] + " is null, setting valid values");
			}
			if (weekFile.songs[i][5] == null)
			{
				weekFile.songs[i][5] = '';
				weekFile.songs[i][6] = [0, 0, 0.9]; // put a floating point number in there,
				weekFile.songs[i][6][2] = 1; // then put it back to 1 so it still identifies as a number with decimals
				trace("freeplay art stuff for " + weekFile.songs[i][0] + " is null, setting valid values");
			}
			if (weekFile.songs[i][7] == null) // Freeplay seperate difficulties
			{
				weekFile.songs[i][7] = '';
				trace("freeplay seperate difficulty stuff for " + weekFile.songs[i][0] + " is null, setting as blank");
			}
			if (weekFile.songs[i][8] == null) // Freeplay description
			{
				weekFile.songs[i][8] = 'Description goes here';
				trace("freeplay description for " + weekFile.songs[i][0] + " is null, setting valid values");
			}
			if (weekFile.songs[i][9] == null) // Suika custom intro type, this time we got 10 song values now LOL
			{
				weekFile.songs[i][9] = '';
				trace("Suika custom intro type for " + weekFile.songs[i][9] + " is null, setting as blank");
			}
			var songText:FreeplayItem = new FreeplayItem(90, 320, weekFile.songs[i][0], weekFile.songs[i][4][0], weekFile.songs[i][4][1]);
			songText.targetY = i;
			grpSongs.add(songText);
			songText.snapToPosition();

			var icon:HealthIcon = new HealthIcon(weekFile.songs[i][1], false, true);
			icon.freeplayTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		descriptionBG = new FlxSprite(0, FlxG.height - 125).makeGraphic(FlxG.width, 125, 0xFF000000);
		descriptionBG.alpha = 0.6;
		add(descriptionBG);

		descriptionText = new FlxText(10, 600, 0, "If you can see this, something is wrong", 32);
		descriptionText.setFormat("PC-9800", 32);
		add(descriptionText);

		addEditorBox();
		changeSelection();
		super.create();
	}
	
	var UI_box:FlxUITabMenu;
	var blockPressWhileTypingOn:Array<FlxUIInputText> = [];
	function addEditorBox() {
		var tabs = [
			{name: 'Freeplay', label: 'Freeplay'},
		];
		UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.resize(250, 500);
		UI_box.x = FlxG.width - UI_box.width - 100;
		UI_box.y = FlxG.height - UI_box.height;
		UI_box.scrollFactor.set();
		
		UI_box.selected_tab_id = 'Week';
		addFreeplayUI();
		add(UI_box);

		var blackBlack:FlxSprite = new FlxSprite(0, 670).makeGraphic(FlxG.width, 50, FlxColor.BLACK);
		blackBlack.alpha = 0.6;
		add(blackBlack);

		var loadWeekButton:FlxButton = new FlxButton(0, 685, "Load Week", function() {
			WeekEditorState.loadWeek();
		});
		loadWeekButton.screenCenter(X);
		loadWeekButton.x -= 120;
		add(loadWeekButton);
		
		var storyModeButton:FlxButton = new FlxButton(0, 685, "Story Mode", function() {
			MusicBeatState.switchState(new WeekEditorState(weekFile));
		});
		storyModeButton.screenCenter(X);
		add(storyModeButton);
	
		var saveWeekButton:FlxButton = new FlxButton(0, 685, "Save Week", function() {
			WeekEditorState.saveWeek(weekFile);
		});
		saveWeekButton.screenCenter(X);
		saveWeekButton.x += 120;
		add(saveWeekButton);
	}
	
	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
		if(id == FlxUIInputText.CHANGE_EVENT && (sender is FlxUIInputText)) {
			weekFile.songs[curSelected][1] = iconInputText.text;
			iconArray[curSelected].changeIcon(iconInputText.text);
			updateFreeplayValues();
		} else if(id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper)) {
			updateFreeplayValues();
		}
	}

	var bgColorStepperR:FlxUINumericStepper;
	var bgColorStepperG:FlxUINumericStepper;
	var bgColorStepperB:FlxUINumericStepper;
	var shrineTextX:FlxUINumericStepper;
	var shrineTextY:FlxUINumericStepper;
	var iconInputText:FlxUIInputText;
	var freeplayArtInput:FlxUIInputText;
	var freeplayArtX:FlxUINumericStepper;
	var freeplayArtY:FlxUINumericStepper;
	var freeplayArtSize:FlxUINumericStepper;
	var seperateDifficultyInputText:FlxUIInputText;
	var descriptionInputText:FlxUIInputText;
	var suikaCustomInputText:FlxUIInputText;
	function addFreeplayUI() {
		var tab_group = new FlxUI(null, UI_box);
		tab_group.name = "Freeplay";

		bgColorStepperR = new FlxUINumericStepper(10, 40, 20, 255, 0, 255, 0);
		bgColorStepperG = new FlxUINumericStepper(80, 40, 20, 255, 0, 255, 0);
		bgColorStepperB = new FlxUINumericStepper(150, 40, 20, 255, 0, 255, 0);

		var copyColor:FlxButton = new FlxButton(10, bgColorStepperR.y + 25, "Copy Color", function() {
			Clipboard.text = bg.color.red + ',' + bg.color.green + ',' + bg.color.blue;
		});
		var pasteColor:FlxButton = new FlxButton(140, copyColor.y, "Paste Color", function() {
			if(Clipboard.text != null) {
				var leColor:Array<Int> = [];
				var splitted:Array<String> = Clipboard.text.trim().split(',');
				for (i in 0...splitted.length) {
					var toPush:Int = Std.parseInt(splitted[i]);
					if(!Math.isNaN(toPush)) {
						if(toPush > 255) toPush = 255;
						else if(toPush < 0) toPush *= -1;
						leColor.push(toPush);
					}
				}

				if(leColor.length > 2) {
					bgColorStepperR.value = leColor[0];
					bgColorStepperG.value = leColor[1];
					bgColorStepperB.value = leColor[2];
					updateFreeplayValues();
				}
			}
		});

		iconInputText = new FlxUIInputText(10, bgColorStepperR.y + 70, 100, '', 8);

		var hideFreeplayCheckbox:FlxUICheckBox = new FlxUICheckBox(10, iconInputText.y + 30, null, null, "Hide Week from Freeplay?", 100);
		hideFreeplayCheckbox.checked = weekFile.hideFreeplay;
		hideFreeplayCheckbox.callback = function()
		{
			weekFile.hideFreeplay = hideFreeplayCheckbox.checked;
		};

		shrineTextX = new FlxUINumericStepper(10, hideFreeplayCheckbox.y + 40, 10, 24, -1280, 1280, 0);
		shrineTextY = new FlxUINumericStepper(10, shrineTextX.y + 40, 2, 24, -720, 720, 0);

		freeplayArtInput = new FlxUIInputText(10, shrineTextY.y + 40, 100, '', 8);
		freeplayArtX = new FlxUINumericStepper(10, freeplayArtInput.y + 40, 10, 0, -1280, 1280, 0);
		freeplayArtY = new FlxUINumericStepper(80, freeplayArtInput.y + 40, 10, 0, -720, 720, 0);
		freeplayArtSize = new FlxUINumericStepper(150, freeplayArtInput.y + 40, 0.05, 1, 0.05, 5, 3);
		seperateDifficultyInputText = new FlxUIInputText(10, freeplayArtSize.y + 40, 175, '', 8);

		descriptionInputText = new FlxUIInputText(10, seperateDifficultyInputText.y + 40, 175, '', 8);

		suikaCustomInputText = new FlxUIInputText(10, descriptionInputText.y + 40, 175, '', 8);
		
		tab_group.add(new FlxText(10, bgColorStepperR.y - 18, 0, 'Selected background Color R/G/B:'));
		tab_group.add(new FlxText(10, iconInputText.y - 18, 0, 'Selected icon:'));
		tab_group.add(new FlxText(10, shrineTextX.y - 18, 0, 'Selected Text X Offset:'));
		tab_group.add(new FlxText(10, shrineTextY.y - 18, 0, 'Rectangle X Offset:'));
		tab_group.add(new FlxText(10, freeplayArtInput.y - 18, 0, 'Freeplay Art Image Name:'));
		tab_group.add(new FlxText(10, freeplayArtX.y - 18, 0, 'Freeplay Art X/Y Offset/Size Multiplier:'));
		tab_group.add(new FlxText(10, seperateDifficultyInputText.y - 18, 0, 'Difficulties (only works in freeplay):'));
		tab_group.add(new FlxText(10, descriptionInputText.y - 18, 0, 'Freeplay description:'));
		tab_group.add(new FlxText(10, suikaCustomInputText.y - 18, 0, 'Suika intro filename:'));
		tab_group.add(bgColorStepperR);
		tab_group.add(bgColorStepperG);
		tab_group.add(bgColorStepperB);
		tab_group.add(shrineTextX);
		tab_group.add(shrineTextY);
		tab_group.add(freeplayArtInput);
		tab_group.add(freeplayArtX);
		tab_group.add(freeplayArtY);
		tab_group.add(freeplayArtSize);
		tab_group.add(seperateDifficultyInputText);
		tab_group.add(descriptionInputText);
		tab_group.add(copyColor);
		tab_group.add(pasteColor);
		tab_group.add(iconInputText);
		tab_group.add(hideFreeplayCheckbox);
		tab_group.add(suikaCustomInputText);
		UI_box.addGroup(tab_group);

		blockPressWhileTypingOn.push(freeplayArtInput);
		blockPressWhileTypingOn.push(seperateDifficultyInputText);
		blockPressWhileTypingOn.push(iconInputText);
		blockPressWhileTypingOn.push(descriptionInputText);
		blockPressWhileTypingOn.push(suikaCustomInputText);
		inputTextBackgrounds.push(iconInputText.backgroundSprite); // what the hell am i looking at below me?
		inputTextBackgrounds.push(iconInputText.fieldBorderSprite);
		inputTextBackgrounds.push(bgColorStepperR.getBackgroundSprites()[0]);
		inputTextBackgrounds.push(bgColorStepperR.getBackgroundSprites()[1]);
		inputTextBackgrounds.push(bgColorStepperG.getBackgroundSprites()[0]);
		inputTextBackgrounds.push(bgColorStepperG.getBackgroundSprites()[1]);
		inputTextBackgrounds.push(bgColorStepperB.getBackgroundSprites()[0]);
		inputTextBackgrounds.push(bgColorStepperB.getBackgroundSprites()[1]);
		inputTextBackgrounds.push(shrineTextX.getBackgroundSprites()[0]);
		inputTextBackgrounds.push(shrineTextX.getBackgroundSprites()[1]);
		inputTextBackgrounds.push(shrineTextY.getBackgroundSprites()[0]);
		inputTextBackgrounds.push(shrineTextY.getBackgroundSprites()[1]);
		inputTextBackgrounds.push(freeplayArtInput.backgroundSprite);
		inputTextBackgrounds.push(freeplayArtInput.fieldBorderSprite);
		inputTextBackgrounds.push(freeplayArtX.getBackgroundSprites()[0]);
		inputTextBackgrounds.push(freeplayArtX.getBackgroundSprites()[1]);
		inputTextBackgrounds.push(freeplayArtY.getBackgroundSprites()[0]);
		inputTextBackgrounds.push(freeplayArtY.getBackgroundSprites()[1]);
		inputTextBackgrounds.push(freeplayArtSize.getBackgroundSprites()[0]);
		inputTextBackgrounds.push(freeplayArtSize.getBackgroundSprites()[1]);
		inputTextBackgrounds.push(seperateDifficultyInputText.backgroundSprite);
		inputTextBackgrounds.push(seperateDifficultyInputText.fieldBorderSprite);
		inputTextBackgrounds.push(descriptionInputText.backgroundSprite); // ill fix these one day, trust me
		inputTextBackgrounds.push(descriptionInputText.fieldBorderSprite);
		inputTextBackgrounds.push(suikaCustomInputText.backgroundSprite);
		inputTextBackgrounds.push(suikaCustomInputText.fieldBorderSprite);
	}

	function updateFreeplayValues() {
		weekFile.songs[curSelected][2][0] = Math.round(bgColorStepperR.value);
		weekFile.songs[curSelected][2][1] = Math.round(bgColorStepperG.value);
		weekFile.songs[curSelected][2][2] = Math.round(bgColorStepperB.value);
		weekFile.songs[curSelected][4][0] = Math.round(shrineTextX.value);
		weekFile.songs[curSelected][4][1] = Math.round(shrineTextY.value);
		weekFile.songs[curSelected][5] = freeplayArtInput.text;
		weekFile.songs[curSelected][6][0] = Math.round(freeplayArtX.value);
		weekFile.songs[curSelected][6][1] = Math.round(freeplayArtY.value);
		weekFile.songs[curSelected][6][2] = freeplayArtSize.value;
		weekFile.songs[curSelected][7] = seperateDifficultyInputText.text;
		weekFile.songs[curSelected][8] =  descriptionInputText.text;
		weekFile.songs[curSelected][9] =  suikaCustomInputText.text;
		trace(freeplayArtSize.value);
		grpSongs.members[curSelected].textPosition = 500 + shrineTextX.value;
		grpSongs.members[curSelected].rectanglePosition = shrineTextY.value;
		bg.color = FlxColor.fromRGB(weekFile.songs[curSelected][2][0], weekFile.songs[curSelected][2][1], weekFile.songs[curSelected][2][2]);

		if (Paths.image("Freeplay Art/" + freeplayArtInput.text) != null)
		{
			freeplayActualArt.loadGraphic(Paths.image("Freeplay Art/" + freeplayArtInput.text));
			freeplayActualArt.setPosition(400 + freeplayArtX.value, 50 + freeplayArtY.value);
			freeplayActualArt.scale.set(freeplayArtSize.value, freeplayArtSize.value);
			freeplayActualArt.updateHitbox();
			freeplayActualArt.alpha = 1;
		}
		else
		{
			freeplayActualArt.alpha = 0;
		}

		descriptionText.text = weekFile.songs[curSelected][8];
	}

	function changeSelection(change:Int = 0) {
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		
		curSelected += change;

		if (curSelected < 0)
			curSelected = weekFile.songs.length - 1;
		if (curSelected >= weekFile.songs.length)
			curSelected = 0;

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
				item.textsprite.alpha = 1;
				item.backgroundshrine.alpha = 0.3;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		iconInputText.text = weekFile.songs[curSelected][1];
		bgColorStepperR.value = Math.round(weekFile.songs[curSelected][2][0]);
		bgColorStepperG.value = Math.round(weekFile.songs[curSelected][2][1]);
		bgColorStepperB.value = Math.round(weekFile.songs[curSelected][2][2]);
		shrineTextX.value = Math.round(weekFile.songs[curSelected][4][0]);
		shrineTextY.value = Math.round(weekFile.songs[curSelected][4][1]);
		freeplayArtInput.text = weekFile.songs[curSelected][5];
		freeplayArtX.value = Math.round(weekFile.songs[curSelected][6][0]);
		freeplayArtY.value = Math.round(weekFile.songs[curSelected][6][1]);
		freeplayArtSize.value = weekFile.songs[curSelected][6][2];
		seperateDifficultyInputText.text = weekFile.songs[curSelected][7];
		descriptionInputText.text = weekFile.songs[curSelected][8];
		suikaCustomInputText.text = weekFile.songs[curSelected][9];
		updateFreeplayValues();
	}

	override function update(elapsed:Float) {
		if(WeekEditorState.loadedWeek != null) {
			super.update(elapsed);
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new WeekEditorFreeplayState(WeekEditorState.loadedWeek));
			WeekEditorState.loadedWeek = null;
			return;
		}
		
		var blockInput:Bool = false;
		for (inputText in blockPressWhileTypingOn) {
			if(inputText.hasFocus) {
				FlxG.sound.muteKeys = [];
				FlxG.sound.volumeDownKeys = [];
				FlxG.sound.volumeUpKeys = [];
				blockInput = true;

				if(FlxG.keys.justPressed.ENTER) inputText.hasFocus = false;
				break;
			}
		}
		
		if(!blockInput) {
			FlxG.sound.muteKeys = TitleState.muteKeys;
			FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
			FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
			if(FlxG.keys.justPressed.ESCAPE) {
				MusicBeatState.switchState(new editors.MasterEditorMenu());
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				FlxG.sound.music.loopTime = 9410;
				FlxG.sound.music.time = 9410;
			}

			if(controls.UI_UP_P) changeSelection(-1);
			if(controls.UI_DOWN_P) changeSelection(1);
		}
		if (FlxG.mouse.overlaps(UI_box))
		{
			UI_box.alpha = 1;
			for (background in inputTextBackgrounds)
			{
				background.alpha = 1;
			}
		}
		else
		{
			UI_box.alpha = 0.1;
			for (background in inputTextBackgrounds)
			{
				background.alpha = 0.1;
			}
		}
		super.update(elapsed);
	}
}
