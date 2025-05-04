import flixel.util.FlxTimer;
import flixel.tweens.misc.NumTween;
import flixel.addons.text.FlxTypeText;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxRect;
import lime.app.Application;
import openfl.events.Event;
import flixel.group.FlxGroup.FlxTypedGroup;
import sys.io.File;
import sys.FileSystem;
import flixel.addons.ui.*;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;
import haxe.Json;
import flixel.tweens.misc.NumTween;

using StringTools;

class GalleryState extends MusicBeatState
{
	// New gallery

	var background:FlxSprite;
	var speechBubble:FlxSprite;
	var akyuu:FlxSprite;
	var scroll:FlxSprite;
	var text:FlxText;

	var height:Float = 0;
	var height2:Float = 0;

	var heightTween:NumTween;
	var height2Tween:NumTween;

    var talking:Bool = false;

    var exiting:Bool = false;

	// Leftover variables

	var descriptionText:FlxTypeText; // Should be speechText, but let the name stay for continiuity
	var galleryGroup:FlxTypedGroup<FlxSprite>;
	var index:GalleryIndex;
	var curSelected = 0;


    override public function create()
    {
		super.create();

        persistentUpdate = true;
        persistentDraw = true;

		background = new FlxSprite(0, 0, Paths.image("akyuu/BG"));
		background.setGraphicSize(1280);
		background.updateHitbox();
		background.screenCenter();
		background.antialiasing = true;
		add(background);

		akyuu = new FlxSprite(-50, 215);
		akyuu.frames = Paths.getSparrowAtlas("akyuu/akyuu_menu");
        akyuu.animation.addByPrefix("idle", "Akyuu_Idle", 18, false);
		akyuu.animation.addByPrefix("talk", "Akyuu_Talk", 24, false);
		akyuu.animation.play("talk");
		akyuu.setGraphicSize(Std.int(akyuu.width * 0.9));
		akyuu.updateHitbox();
		akyuu.antialiasing = true;
		add(akyuu);

		speechBubble = new FlxSprite(250, 550, Paths.image("akyuu/speechbubble"));
		speechBubble.setGraphicSize(Std.int(speechBubble.width * 1.45));
		speechBubble.updateHitbox();
		speechBubble.setGraphicSize(Std.int(speechBubble.width * 1.15), Std.int(speechBubble.height));
		speechBubble.updateHitbox();
		speechBubble.antialiasing = true;
		add(speechBubble);

		scroll = new FlxSprite(800, 50);
		scroll.frames = Paths.getSparrowAtlas("akyuu/scroll");
		scroll.animation.addByPrefix("idle", "Scroll_Closed", 24, false);
		scroll.animation.addByPrefix("dance", "Scroll_Open", 24, false);
		scroll.animation.play("dance");
		add(scroll);

		descriptionText = new FlxTypeText(speechBubble.x, speechBubble.y, 0, "Description goes here", 16);
		descriptionText.setFormat("CC Wild Words Roman");
		descriptionText.color = 0xFF000000;

		add(descriptionText);

		galleryGroup = new FlxTypedGroup<FlxSprite>();
		add(galleryGroup);

		heightTween = FlxTween.num(height, height * 2, 0.5, {ease: FlxEase.cubeInOut}, function(value:Float)
		{
			height = value;
		});

		height2Tween = FlxTween.num(0, height2, 0.5, {ease: FlxEase.cubeInOut}, function(value:Float)
		{
			height2 = value;
		});

        if (FileSystem.exists(Paths.mods("images/gallery/index.json")))
        {
            var rawJson:String = File.getContent(Paths.mods("images/gallery/index.json"));
            try {
                index = cast Json.parse(rawJson);
                checkForMissingImages();
            }
            catch (e)
            {
                Application.current.window.alert('The index.json file could not be parsed! Refer to this error for more details: \n\n $e \n\n' + "If you haven't touched any files, try and reextract the mod", "Index file may be broken");
                index = {
                    images: []
                };
                FlxG.camera.alpha = 0;
                MusicBeatState.switchState(new MainMenuState());
            }
        }
        else
        {
            Application.current.window.alert('The index.json file could not be located at "mods/images/gallery/"!' + " If you haven't touched any files, try and reextract the mod", "Index file does not exist");
            FlxG.camera.alpha = 0;
            MusicBeatState.switchState(new MainMenuState());
        }
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
        
        if (talking)
        {
            akyuu.animation.play("talk");
        }

		galleryGroup.members[curSelected].clipRect.y = galleryGroup.members[curSelected].height - height;
		galleryGroup.members[curSelected].clipRect.height = height2;

		galleryGroup.members[curSelected].clipRect = galleryGroup.members[curSelected].clipRect;

        if (!exiting)
        {
            if (controls.UI_RIGHT_P)
            {
                changeImage(1);
            }
            if (controls.UI_LEFT_P)
            {
                changeImage(-1);
            }
            if (controls.UI_LEFT_P || controls.UI_RIGHT_P)
            {
                FlxG.sound.play(Paths.sound('scrollMenu'));
            }
            if (controls.BACK)
            {
                exiting = true;
                FlxG.sound.play(Paths.sound('cancelMenu'));
                MusicBeatState.switchState(new MainMenuState());
            }
        }
    }

    function changeImage(amount:Int = 0)
    {
		curSelected += amount;

		if (curSelected >= index.images.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = index.images.length - 1;

        talking = true;

		galleryGroup.forEach(function(image:FlxSprite)
		{
			image.alpha = 0;
		});

		descriptionText.resetText(index.images[curSelected].description);
	//	descriptionText.text = index.images[curSelected].description;
		descriptionText.setPosition(speechBubble.x + index.images[curSelected].descriptionPosition[0],
			speechBubble.y + index.images[curSelected].descriptionPosition[1]);
		descriptionText.size = index.images[curSelected].descriptionSize;

		descriptionText.start(0.02, true, false, null, function(){
            trace("done");
            talking = false;
            akyuu.animation.play("idle", true);
        });

		FlxTween.cancelTweensOf(height);

		height = Std.int(galleryGroup.members[curSelected].height / 2); // initial value
		height2 = Std.int(galleryGroup.members[curSelected].height); // initial value

		heightTween.cancel();
		height2Tween.cancel();

		var height2temp = height2;

		new FlxTimer().start(0.05, function(bruh:FlxTimer)
		{ // frame delay

            galleryGroup.members[curSelected].alpha = 1;
			heightTween = FlxTween.num(height, height * 2, 0.5, {ease: FlxEase.cubeInOut}, function(value:Float)
			{
				height = value;
			});

			height2Tween = FlxTween.num(0, height2temp, 0.5, {ease: FlxEase.cubeInOut}, function(value:Float)
			{
				height2 = value;
			});
		});

		scroll.animation.play("dance", true);
    }

    override public function beatHit()
    {
        super.beatHit();

        if (!talking)
        {
            trace("playing");
            akyuu.animation.play("idle", true);
        }
    }

    function checkForMissingImages()
    {
        var listOfImageNames:Array<String> = [];
        var listOfFilesInFolder = FileSystem.readDirectory(Paths.mods("images/gallery"));
        for (i in 0...listOfFilesInFolder.length)
        {
            if (listOfFilesInFolder[i].contains(".png"))
            {
                listOfImageNames.push(listOfFilesInFolder[i]);
            }
        }
        for (i in 0...listOfImageNames.length)
        {
            listOfImageNames[i] = CoolUtil.removeLine(listOfImageNames[i], ".png");
        }
        var allImagesAreMissing:Bool = true;
        var missingImages:Array<String> = [];
        var indexLoopInteger:Int = 0;
        while (indexLoopInteger < index.images.length)
        {
            var imageToCheck:GalleryImage = index.images[indexLoopInteger];
            if (imageToCheck != null)
            {
                if (!listOfImageNames.contains(imageToCheck.image))
                {
                    trace(imageToCheck.image + ": Exists in the index, but doesnt exist in the folder D:");
                    missingImages.push(imageToCheck.image);
                    index.images.remove(imageToCheck);
                    indexLoopInteger--;
                }
                else
                {
                    allImagesAreMissing = false;
                    indexLoopInteger++;
                }
            }
            else
            {
                indexLoopInteger++;
            }
        }

        if (missingImages.length != 0)
        {
            if (!allImagesAreMissing)
            {
                Application.current.window.alert("Could not find the following images: " + "\n\n" + missingImages.join("\n") + "\n\n" + "The gallery will still continue to load, but with these images not displaying", "Missing Images");
                generateContent();
            }
            else
            {
                Application.current.window.alert("Could not find any of the images in the index! Try reextracting the mod", "Missing All Images");
                FlxG.camera.alpha = 0;
                MusicBeatState.switchState(new MainMenuState());
            }
        }
        else
        {
            generateContent();
        }
    }

    
    function generateContent()
    {
        for (i in 0...index.images.length)
        {
            try {
                var temp:Int = 0 + index.images[i].x; // source/GalleryState.hx:269: characters 29-33 : On static platforms, null can't be used as basic type Int
            }
            catch (e)
            {
                index.images[i].x = 0;
				index.images[i].y = 0;
            }
			var galleryImage:FlxSprite = new FlxSprite(800 + index.images[i].x, 50 + index.images[i].y, Paths.image("gallery/" + index.images[i].image));
			galleryImage.scale.set(index.images[i].scale, index.images[i].scale);
            galleryImage.antialiasing = ClientPrefs.globalAntialiasing;
            galleryImage.alpha = 0;
			galleryImage.clipRect = new FlxRect(0, 0, galleryImage.width, galleryImage.height);
			galleryGroup.add(galleryImage);
        }
        changeImage();
    //    openSubState(new CustomFadeTransition(0.7, true));
    }
}

typedef GalleryIndex =
{
    var images:Array<GalleryImage>;
}

typedef GalleryImage = 
{
	var image:String;
	var scale:Float;
	var x:Int;
	var y:Int;
	var offset:Float; // Unused
	var description:String; // Speech bubble text
	var descriptionPosition:Array<Float>; // Speech bubble text position
	var descriptionSize:Int;
}