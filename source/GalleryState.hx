import flixel.addons.display.FlxBackdrop;
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

using StringTools;

class GalleryState extends MusicBeatState
{
    var background:FlxSprite;
    var borders:FlxSprite;
    var descriptionBox:FlxSprite;
    var descriptionText:FlxText;
    var imageText:FlxText;
    var galleryGroup:FlxTypedGroup<GalleryItem>;
    var index:GalleryIndex;
    var curSelected = 0;
    var backdrop:FlxBackdrop;
    override public function create() 
    {
        background = new FlxSprite(0, 0, Paths.image("storymenu/background"));
        add(background);

        backdrop = new FlxBackdrop(Paths.image("storymenu/background checkers"));
		backdrop.velocity.set(50, 50);
		add(backdrop);

        galleryGroup = new FlxTypedGroup<GalleryItem>();
        add(galleryGroup);

        borders = new FlxSprite(-10, -5, Paths.image("galleryscreen/Bars"));
        borders.setGraphicSize(1300);
        borders.updateHitbox();
        add(borders);

        descriptionBox = new FlxSprite(0, 591, Paths.image("galleryscreen/Textbox"));
        descriptionBox.scale.set(0.61, 0.61);
        descriptionBox.updateHitbox();
        descriptionBox.screenCenter(X);
        add(descriptionBox);

        descriptionText = new FlxText(descriptionBox.x, descriptionBox.y, 0, "Description goes here", 16);
        descriptionText.setFormat("Topsicle");
        add(descriptionText);

        imageText = new FlxText(5, 10, 0, "Image file name goes here");
        imageText.setFormat("Topsicle", 32);
        add(imageText);

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
        Main.fpsVar.visible = false;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
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
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new MainMenuState());
        }
    }

    function changeImage(amount:Int = 0)
    {
        curSelected += amount;
        if (curSelected >= index.images.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = index.images.length - 1;

        var amountToShift:Int = 0;
        for (item in galleryGroup.members)
        {
            item.targetY = amountToShift - curSelected;
            amountToShift++;
        }

        imageText.text = index.images[curSelected].image + ".png";
        descriptionText.text = index.images[curSelected].description;
        descriptionText.setPosition(descriptionBox.x + index.images[curSelected].descriptionPosition[0], descriptionBox.y + index.images[curSelected].descriptionPosition[1]);
        descriptionText.size = index.images[curSelected].descriptionSize;
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
            var galleryImage:GalleryItem = new GalleryItem(index.images[i].scale, Paths.image("gallery/" + index.images[i].image), index.images[i].offset);
            galleryImage.targetY = i;
            galleryGroup.add(galleryImage);
            galleryImage.instantSetPosition();
        }
        changeImage();
        openSubState(new CustomFadeTransition(0.7, true));
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
    var offset:Float;
    var description:String;
    var descriptionPosition:Array<Float>;
    var descriptionSize:Int;
}