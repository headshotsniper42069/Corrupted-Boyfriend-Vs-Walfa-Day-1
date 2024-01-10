package editors;

import flixel.ui.FlxButton;
import openfl.events.IOErrorEvent;
import openfl.events.Event;
import openfl.net.FileReference;
import flixel.group.FlxGroup.FlxTypedGroup;
import sys.io.File;
import sys.FileSystem;
import flixel.addons.ui.*;
import lime.app.Application;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;
import haxe.Json;

using StringTools;

class GalleryEditor extends MusicBeatState
{
    var background:FlxSprite;
    var borders:FlxSprite;
    var descriptionBox:FlxSprite;
    var descriptionText:FlxText;
    var index:GalleryIndex;
    var galleryImage:GalleryItem;
    var galleryGroup:FlxTypedGroup<GalleryItem>;
    var curSelected:Int = 0;
    var listOfImageNames:Array<String> = [];
    var previousImages:Array<String> = [];
    var allImagesAreMissing:Bool = false;
    var indexIsInFactMissing:Bool = true;

    override public function create()
    {
        background = new FlxSprite(0, 0, Paths.image("storymenu/background"));
        add(background);

        galleryGroup = new FlxTypedGroup<GalleryItem>();
        add(galleryGroup);

        try {
            galleryImage = new GalleryItem(index.images[0].scale, Paths.image("gallery/" + index.images[0].image), index.images[0].offset);
            add(galleryImage);
        }
        catch (e)
        {
           trace("Got an error: " + e);
        }
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
        
        indexImagesListForReal = ["test"];
        
        addEditorBox();

        var indexError:Bool = false;
        if (FileSystem.exists(Paths.mods("images/gallery/index.json")))
        {
            var rawJson:String = File.getContent(Paths.mods("images/gallery/index.json"));
            indexIsInFactMissing = false;
            try {
                index = cast Json.parse(rawJson);
            }
            catch (e)
            {
                indexError = true;
                Application.current.window.alert('The index.json file could not be parsed! Refer to this error for more details: \n\n $e \n\nA new one is being made from scratch. Remember to save it!', "Index file may be broken");
                index = {
                    images: []
                };
                rescanImages();
            }
            if (!indexError)
            {
                checkForMissingImages(true);
                curSelected = 0;
                indexImagesListForReal = [];
                try {
                    galleryImage.destroy();
                }
                catch (e)
                {
                   trace("Got an error: " + e);
                }
                galleryImage = null;
                try {
                    galleryImage = new GalleryItem(index.images[0].scale, Paths.image("gallery/" + index.images[0].image), index.images[0].offset);
                    galleryGroup.add(galleryImage);
                }
                catch (e)
                {
                   trace("Got an error: " + e);
                }
                for (i in index.images)
                {
                    trace(i.image);
                    indexImagesListForReal.push(i.image);
                }
                reloadImageDropdown();
                loadSettings();
            }
        }
        else
        {
            index = {
                images: []
            };
            rescanImages();
            trace(listOfImageNames);
        }

        FlxG.mouse.visible = true;

        super.create();
    }

    var UI_box:FlxUITabMenu;
	var blockPressWhileTypingOn:Array<FlxUIInputText> = [];
    function addEditorBox() {
		var tabs = [
			{name: 'Gallery', label: 'Gallery'},
		];
		UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.resize(250, 350);
		UI_box.x = FlxG.width - UI_box.width;
		UI_box.y = FlxG.height - UI_box.height;
		UI_box.scrollFactor.set();
        addGalleryUI();

        UI_box.selected_tab_id = 'Gallery';
		add(UI_box);
    }

    var imageList:FlxUIDropDownMenuCustom; // this is gonna be a long one
    var indexImagesListForReal:Array<String> = [];
    var scaleStepper:FlxUINumericStepper;
    var yOffsetStepper:FlxUINumericStepper;
    var descriptionInputText:FlxUIInputText;
    var descriptionPositionXStepper:FlxUINumericStepper;
	var descriptionPositionYStepper:FlxUINumericStepper;
    var descriptionPositionSizeStepper:FlxUINumericStepper;
    var rescanButton:FlxButton;
    var saveButton:FlxButton;
    function addGalleryUI() {
        var tab_group = new FlxUI(null, UI_box);
		tab_group.name = "Gallery";

        imageList = new FlxUIDropDownMenuCustom(10, 30, FlxUIDropDownMenuCustom.makeStrIdLabelArray(indexImagesListForReal, true), function(bruh:String){
            curSelected = Std.parseInt(bruh);
            loadSettings();
        });
        scaleStepper = new FlxUINumericStepper(10, imageList.y + 40, 0.05, 1, 0.05, 5, 2);

        yOffsetStepper = new FlxUINumericStepper(10, scaleStepper.y + 40, 5, 0, -1280, 1280, 0);

        descriptionInputText = new FlxUIInputText(10, yOffsetStepper.y + 40, 150, 'Description goes here', 8);
        blockPressWhileTypingOn.push(descriptionInputText);
        
		descriptionPositionXStepper = new FlxUINumericStepper(10, descriptionInputText.y + 40, 10, 0, -640, 640, 0);
		descriptionPositionYStepper = new FlxUINumericStepper(descriptionPositionXStepper.x + 60, descriptionPositionXStepper.y, 10, 0, -640, 640, 0);

		descriptionPositionSizeStepper = new FlxUINumericStepper(10, descriptionPositionXStepper.y + 40, 4, 0, 8, 64, 0);

        rescanButton = new FlxButton(10, descriptionPositionSizeStepper.y + 40, "Rescan", rescanImages);

        saveButton = new FlxButton(120, rescanButton.y, "Save", saveIndex);

        tab_group.add(new FlxText(imageList.x, imageList.y - 18, 0, 'Image:'));
        tab_group.add(new FlxText(scaleStepper.x, scaleStepper.y - 18, 0, 'Image scale multiplier:'));
        tab_group.add(new FlxText(yOffsetStepper.x, yOffsetStepper.y - 18, 0, 'Image vertical offset:'));
        tab_group.add(new FlxText(descriptionInputText.x, descriptionInputText.y - 18, 0, 'Description:'));

        tab_group.add(new FlxText(descriptionPositionXStepper.x, descriptionPositionXStepper.y - 18, 0, 'Description text X/Y offset:'));
        tab_group.add(new FlxText(descriptionPositionSizeStepper.x, descriptionPositionSizeStepper.y - 18, 0, 'Description text size:'));

        tab_group.add(scaleStepper);
        tab_group.add(yOffsetStepper);
        tab_group.add(descriptionInputText);
        tab_group.add(descriptionPositionXStepper);
        tab_group.add(descriptionPositionYStepper);
        tab_group.add(descriptionPositionSizeStepper);
        tab_group.add(rescanButton);
        tab_group.add(saveButton);
        tab_group.add(imageList);
        UI_box.addGroup(tab_group);
    }

    function loadSettings()
    {
        scaleStepper.value = index.images[curSelected].scale;
        yOffsetStepper.value = index.images[curSelected].offset;
        descriptionInputText.text = index.images[curSelected].description;
        descriptionPositionXStepper.value = index.images[curSelected].descriptionPosition[0];
        descriptionPositionYStepper.value = index.images[curSelected].descriptionPosition[1];
        descriptionPositionSizeStepper.value = index.images[curSelected].descriptionSize;
        descriptionText.text = index.images[curSelected].description;
        descriptionText.setPosition(descriptionBox.x + index.images[curSelected].descriptionPosition[0], descriptionBox.y + index.images[curSelected].descriptionPosition[1]);
        descriptionText.size = index.images[curSelected].descriptionSize;
        galleryImage.reloadImage(index.images[curSelected].scale, Paths.image("gallery/" + index.images[curSelected].image));
        galleryImage.yOffset = index.images[curSelected].offset;
    }

    override public function update(elapsed:Float) 
    {
        super.update(elapsed);
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
		}
    }

    override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
		if(id == FlxUIInputText.CHANGE_EVENT && (sender is FlxUIInputText)) {
			if(sender == descriptionInputText) {
				index.images[curSelected].description = descriptionInputText.text;
			}
            loadSettings();
		}
		else if(id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper)) {
			if(sender == scaleStepper) {
				index.images[curSelected].scale = scaleStepper.value;
			} else if(sender == yOffsetStepper) {
				index.images[curSelected].offset = yOffsetStepper.value;
			} else if(sender == descriptionPositionXStepper){
                index.images[curSelected].descriptionPosition[0] = descriptionPositionXStepper.value;
            } else if(sender == descriptionPositionYStepper){
                index.images[curSelected].descriptionPosition[1] = descriptionPositionYStepper.value;
            } else if (sender == descriptionPositionSizeStepper) {
                index.images[curSelected].descriptionSize = Std.int(descriptionPositionSizeStepper.value);
                descriptionText.size = index.images[curSelected].descriptionSize;
            }
            loadSettings();
		}
    }

    function checkForMissingImages(relist:Bool = false)
    {
        if (relist)
            listFolderItems();
        var missingImages:Array<String> = [];
        allImagesAreMissing = true;
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
                    if (previousImages == null && indexLoopInteger == 0)
                        indexLoopInteger++;
                    else
                    {
                        indexLoopInteger--;
                    }
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
                Application.current.window.alert("Could not find the following images: " + "\n\n" + missingImages.join("\n") + "\n\n" + "Saving this index file will remove these from it, make sure to backup any data you have for them", "Missing Images");
        }
        if (allImagesAreMissing)
        {
            if (indexIsInFactMissing)
            {
                Application.current.window.alert('The index.json file could not be located at "mods/images/gallery/". A new one is being made from scratch, but remember to save it!', "Index file does not exist");
                indexIsInFactMissing = false;
            }
            else
            {
                Application.current.window.alert("Could not find any of the images in the index! Closing this window will rescan the folder again, but the images will lose their attributes", "Missing All Images");
                index = {
                    images: []
                };
            }
            rescanImages();
        }
    }
    function listFolderItems()
    {
        listOfImageNames = [];
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
    }
    function rescanImages() // https://try.haxe.org/#35BC1D26
    {
        previousImages = listOfImageNames.copy();
        listFolderItems();
        var stuffToBeAdded:Array<String> = [];
        for (imagename in listOfImageNames)
        {
            var imageExists:Bool = false;
            for (imageitem in index.images)
            {
                if (imageitem.image == imagename) 
                {
                    imageExists = true;
                    trace(imagename + ": Already exists");
                    break;
                }
            }
            if (!imageExists && listOfImageNames[0] == previousImages[0])
            {
                trace(imagename + ": Doesn't exist in the index");
                stuffToBeAdded.push(imagename);
            }
        }
        try {
            if (index.images[0].image != listOfImageNames[0])
            {
                if (listOfImageNames[0] != index.images[0].image)
                {
                    trace(listOfImageNames[0] + ": Doesn't exist in the index, and is the first image, unless the first image was deleted");
                    stuffToBeAdded.push(listOfImageNames[0]);
                }
            }
        }
        catch (e)
        {
            trace("Got an error: " + e);
        }
        for (newImageString in stuffToBeAdded)
        {
            index.images.push({
                image: newImageString,
                scale: 1,
                offset: 0,
                description: "Description goes here",
                descriptionPosition: [0, 0],
                descriptionSize: 16
            });
        }

        checkForMissingImages();

        index.images.sort(compareImages);
        
        var previousImageString:String = "";
        indexImagesListForReal = [];
        for (image in index.images) {
            if (previousImageString != image.image)
            {
                previousImageString = image.image;
            }
            else
            {
                index.images.remove(image);
            }
        }
        try {
            galleryImage.destroy();
        }
        catch (e)
        {
           trace("Got an error: " + e);
        }
        galleryImage = null;
        try {
            galleryImage = new GalleryItem(index.images[0].scale, Paths.image("gallery/" + index.images[0].image), index.images[0].offset);
            galleryGroup.add(galleryImage);
        }
        catch (e)
        {
           trace("Got an error: " + e);
        }

        for (i in index.images)
        {
            trace(i.image);
            indexImagesListForReal.push(i.image);
        }
        curSelected = 0;
        reloadImageDropdown();
        if (index.images.length != 0)
            loadSettings();
    }

    function reloadImageDropdown()
    {
        imageList.setData(FlxUIDropDownMenuCustom.makeStrIdLabelArray(indexImagesListForReal, true));
        imageList.selectedId = "0";
        imageList.selectedLabel = index.images[0].image;
    }

    static function compareImages(a:GalleryImage, b:GalleryImage):Int {
        return Reflect.compare(a.image, b.image);
    }

    private static var _file:FileReference;

    public function saveIndex() {
        var data:String = Json.stringify(index, "\t");
        if (data.length > 0)
        {
            _file = new FileReference();
            _file.addEventListener(Event.COMPLETE, onSaveComplete);
            _file.addEventListener(Event.CANCEL, onSaveCancel);
            _file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
            _file.save(data, "index.json");
        }
    }
    private static function onSaveComplete(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		trace("Saved index file, make sure it was in the gallery folder!");
	}

	private static function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	private static function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		trace("Looks like there was an issue with saving the file D:");
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