package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;
import flixel.addons.text.FlxTypeText;
import openfl.filters.ShaderFilter;
import flixel.FlxG;
import flixel.FlxCamera;
import sys.io.File;
import flixel.addons.display.FlxRuntimeShader;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxAssets.FlxShader;

using StringTools;

class FinalDialog extends MusicBeatState
{
	var dialog:Array<String> = [
	"Yukari: Well, well... it seems we've finally met.", // closedeyes
	"BF: Bep?", // neutral
	"Yukari: Who am I, you ask? Quite simple, really.", // normal
	"Yukari: I'm the one who orchestrated this little 'vacation' of yours; the one pulling the strings from behind the scenes.", // smug
	"Yukari: My name is Yukari Yakumo, one of Gensokyo's Sages. A youkai of boundaries, if you will.", // smug 
	"Yukari: I was the one who opened the Gaps that sent you and your girlfriend on your little multiversal adventure.", // happy
	"BF: Beep skidep?", // sad
	"Yukari: Why did I do it?", // smug
	"Yukari: Well... have you ever had one of those days where nothing happens? Where time drags on endlessly, and no matter how long you wait, nothing exciting comes your way?", // closedeyes
	"Yukari: That's been my life lately. No incidents, no troublesome youkai, not even a minor spell card duel to break up the monotony.", // sad
	"Yukari: It was all so dreadfully dull, so dreadfully exhausting.", // sad
	"Yukari: And then, I saw you: sitting comfortably in your little room, spending time with her, doing absolutely nothing.", // closedeyes
	"Yukari: And I thought... Why not shake things up a little?", // smug
	"Yukari: So, with just a flick of my hand, I wove the boundaries and sent you tumbling across dimensions.", // happy
	"BF: B- BOOP!", // sad
	"Yukari: Oh? You're mad? Why, how cute.", // smug
	"Yukari: I suppose it's only natural to be frustrated. Thrown from world to world, forced into challenges, meeting bizarre beings.", // closedeyes
	"Yukari: Honestly, you should be thanking me! When else would you get to experience so many different places in such a short span of time?", // smug
	"Yukari: Though... I'll admit, it didn't bring me quite as much joy as I expected.", // sad
	"Yukari: And it certainly didn't amuse the local shrine maiden. She gave me quite the earful.", // closedeyes
	"BF: Beep?", // sad
	"Yukari: Oh, don't get me wrong, I could keep this up. I could send you spiraling through countless more realms, watch you struggle, see how you adapt.", // smug
	"Yukari: But alas, it seems this little game has lost its charm.", // closedeyes
	"Yukari: So I suppose this is where it ends.", // sad_alt
	"BF: Bopip?", // sad
	"Yukari: Heh. You're asking if that's really it? ...well, that's what I think you're saying.", // normal
	"Yukari: I'll be honest, I have no idea what you're actually saying. I've just been guessing from context this whole time.", // closedeyes
	"Yukari: But don't worry, I won't force you to stay.", // closedeyes
	"Yukari: The shrine maiden wants you gone and I no longer have a reason to interfere.", // normal
	"Yukari: ...for now.", // smug
	"Yukari: After all, who's to say I won't grow bored again?", // smug
	"Yukari: Perhaps next time, we'll put on a proper play involving this whole scenario.", // closedeyes
	"Yukari: One with higher stakes. One more...entertaining.", // closedeyes
	"Yukari: But that's a thought for another time.", // smug
	"Yukari: For now... farewell."]; // closedeyes

	var dialogEmotions:Array<String> = [
	"closedeyes",
	"neutral",
	"normal",
	"smug",
	"smug",
	"happy",
	"sad",
	"smug",
	"closedeyes",
	"sad",
	"sad",
	"closedeyes",
	"smug",
	"happy",
	"sad",
	"smug",
	"closedeyes",
	"smug",
	"sad",
	"closedeyes",
	"sad",
	"smug",
	"closedeyes",
	"sad_ALT",
	"happy", // sad
	"normal",
	"closedeyes",
	"closedeyes",
	"normal",
	"smug",
	"smug",
	"closedeyes",
	"closedeyes",
	"smug",
	"closedeyes"];

	var background:FlxSprite;
	var elapsedTime:Float = 0;

	var yukari:FlxSprite;
	var boyfriend:FlxSprite;
	var yukaridark:FlxSprite;
	var boyfrienddark:FlxSprite;

	var dialogueBox:FlxSprite;

	var dialogueText:FlxTypeText;
	var dialogCamera:FlxCamera;
	var dialogSound:FlxSound;
	var dialogMusic:FlxSound;
	var dialogActive:Bool = false;

	var backgroundShader:FlxRuntimeShader;
	var backgroundCamera:FlxCamera;

	var line:Int = 0;
	var lineActive:Bool = false;

	override public function create()
	{
		super.create();

        FlxG.sound.music.stop();

		dialogCamera = new FlxCamera(0, 0, 1500, 0);
		backgroundCamera = new FlxCamera(0, 0, 1500, 0);
		dialogCamera.bgColor.alpha = 0;

		FlxG.cameras.reset(backgroundCamera);
		FlxG.cameras.add(dialogCamera, true);

		FlxG.cameras.setDefaultDrawTarget(backgroundCamera, false);

		background = new FlxSprite(0, -100, Paths.image("Backgrounds/Ciryes/BG"));
		background.setGraphicSize(1300);
		background.updateHitbox();
		background.antialiasing = true;
		background.cameras = [backgroundCamera];
		background.color = FlxColor.fromInt(0xFF616161);
		add(background);

		yukari = new FlxSprite(600, 100, Paths.image("yukari/Yukari/yukari_normal"));
		yukari.setGraphicSize(Std.int(yukari.width * 0.7));
		yukari.updateHitbox();
		yukari.antialiasing = true;
		yukari.alpha = 0;
		yukari.setPosition(650, 125);

		yukaridark = new FlxSprite(600, 100, Paths.image("yukari/Yukari/yukari_normal"));
		yukaridark.setGraphicSize(Std.int(yukaridark.width * 0.7));
		yukaridark.updateHitbox();
		yukaridark.antialiasing = true;
		yukaridark.color = 0xFF696969;
		yukaridark.alpha = 0;
		yukaridark.setPosition(650, 125);
		add(yukaridark);

		add(yukari);

		boyfriend = new FlxSprite(0, 250, Paths.image("yukari/BF/bf_happy"));
		boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.7));
		boyfriend.updateHitbox();
		boyfriend.antialiasing = true;
		boyfriend.alpha = 0;

		boyfrienddark = new FlxSprite(0, 250, Paths.image("yukari/BF/bf_happy"));
		boyfrienddark.setGraphicSize(Std.int(boyfrienddark.width * 0.7));
		boyfrienddark.updateHitbox();
		boyfrienddark.antialiasing = true;
		boyfrienddark.color = 0xFF696969;
		boyfrienddark.alpha = 0;
		add(boyfrienddark);

		add(boyfriend);

		dialogueBox = new FlxSprite().makeGraphic(1150, 150, 0xFF000000);
		dialogueBox.alpha = 0.75;
		dialogueBox.y = FlxG.height - dialogueBox.height - 75;
		dialogueBox.screenCenter(X);
		add(dialogueBox);

		dialogueText = new FlxTypeText(dialogueBox.x + 25, dialogueBox.y + 25, 1100, "", 24);
		dialogueText.font = Paths.font("DFPOCOC.ttf");
		add(dialogueText);

		dialogueText.start(0.015, true, false, null, function(){
			dialogActive = false;
		});

		dialogActive = true;

		dialogSound = FlxG.sound.load(Paths.sound("dialogueClose", "shared"));
		dialogMusic = FlxG.sound.load(Paths.music("yukariDialog"), 0, true);

		backgroundShader = new FlxRuntimeShader(File.getContent(Paths.mods("shaders/Atomic Heat Distortion but for Yukari.frag")), null, 120);
		backgroundCamera.setFilters([new ShaderFilter(backgroundShader)]);

		backgroundCamera.alpha = 0;

		new FlxTimer().start(2.5, function(start:FlxTimer) {
			nextLine();
			FlxTween.tween(backgroundCamera, {alpha: 1}, 4, {ease:FlxEase.cubeOut});
			lineActive = true;
		});

		dialogMusic.play();
		dialogMusic.fadeIn(3, 0, 0.8);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		elapsedTime += elapsed;

		background.y = (Math.sin(elapsedTime * 0.12) + 1) * -100 - 50 * 0.25;

		backgroundShader.setFloat("iTime", elapsedTime);

		if (FlxG.keys.justPressed.ENTER && lineActive)
		{
			dialogSound.play(true);

			if (dialogActive)
			{
				dialogueText.skip();
				dialogActive = false;
			}
			else
			{
				nextLine();
			}
		}
	}

	function nextLine()
	{
		dialogActive = true;

		FlxTween.cancelTweensOf(yukari);
		FlxTween.cancelTweensOf(yukaridark);
		FlxTween.cancelTweensOf(boyfriend);
		FlxTween.cancelTweensOf(boyfrienddark);

		if (line == dialog.length)
		{
			lineActive = false;
			dialogCamera.alpha = 0;
			backgroundCamera.alpha = 0;

			dialogMusic.fadeOut(2, 0);

			new FlxTimer().start(2.5, function(bruh:FlxTimer){
                FlxG.sound.playMusic(Paths.music('freakyMenu'));
                FlxG.sound.music.loopTime = 9410;
				FlxG.sound.music.time = 9410;
                LoadingState.loadAndSwitchState(new MainMenuState());
			});
		}
		else
		{
			var textLine:Array<String> = dialog[line].split(":");

			if (line == 1)
			{
				yukaridark.alpha = 1;
			}
			else if (line == 2)
			{
				boyfrienddark.alpha = 1;
			}

			if (textLine[0].contains("Yukari"))
			{
				trace("yukari line");
				FlxTween.tween(yukari, {x: 600, y: 100, alpha: 1}, 0.5, {ease: FlxEase.quintOut, onComplete: function(sigma:FlxTween) yukaridark.alpha = 1});
				FlxTween.tween(yukaridark, {x: 600, y: 100}, 0.5, {ease: FlxEase.quintOut});
				FlxTween.tween(boyfriend, {x: -50, y: 275, alpha: 0}, 0.5, {ease: FlxEase.quintOut});
				FlxTween.tween(boyfrienddark, {x: -50, y: 275}, 0.5, {ease: FlxEase.quintOut});
				yukari.loadGraphic(Paths.image("yukari/" + textLine[0] + "/" + textLine[0].toLowerCase() + "_" + dialogEmotions[line]));
				yukaridark.loadGraphic(Paths.image("yukari/" + textLine[0] + "/" + textLine[0].toLowerCase() + "_" + dialogEmotions[line]));
			}
			else
			{
				trace("bf line");
				FlxTween.tween(yukari, {x: 650, y: 125, alpha: 0}, 0.5, {ease: FlxEase.quintOut});
				FlxTween.tween(yukaridark, {x: 650, y: 125}, 0.5, {ease: FlxEase.quintOut});
				FlxTween.tween(boyfriend, {x: 0, y: 250, alpha: 1}, 0.5,
					{ease: FlxEase.quintOut, onComplete: function(sigma:FlxTween) boyfrienddark.alpha = 1});
				FlxTween.tween(boyfrienddark, {x: 0, y: 250}, 0.5, {ease: FlxEase.quintOut});
				boyfriend.loadGraphic(Paths.image("yukari/" + textLine[0] + "/" + textLine[0].toLowerCase() + "_" + dialogEmotions[line]));
				boyfrienddark.loadGraphic(Paths.image("yukari/" + textLine[0] + "/" + textLine[0].toLowerCase() + "_" + dialogEmotions[line]));
			}

			line++;

			dialogueText.resetText(textLine[1]);
			dialogueText.start(0.015, true, false, null, function()
			{
				dialogActive = false;
			});
		}
	}
}