package;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import flash.media.Sound;

using StringTools;

class FreeplayItem extends FlxSpriteGroup // loosely based off of class Alphabet, designed specifically for EOCS
{
	public var text:String;

	public var targetY:Int = 0;
	public var changeX:Bool = true;
	public var changeY:Bool = true;

	public var rows:Int = 0;

    public var textsprite:FlxText;

	public var distancePerItem:FlxPoint = new FlxPoint(20, 155);
	public var startPosition:FlxPoint = new FlxPoint(0, 0);
	public var textPosition:FlxPoint = new FlxPoint(0, 0); // for freeplay editor, it went wack without this

    var backgroundshrine:FlxSprite;

	public function new(x:Float, y:Float, text:String = "", textX:Float, textY:Float, textSize:Int)
	{
		super(x, y);

		this.text = text;
		this.startPosition.x = x;
		this.startPosition.y = y;
		this.textPosition.x = textX;
		this.textPosition.y = textY;

        backgroundshrine = new FlxSprite(0, 0, Paths.image("freeplay/Shrine"));
        backgroundshrine.setGraphicSize(Std.int(backgroundshrine.width * 0.5));
        backgroundshrine.updateHitbox();
        add(backgroundshrine);

        textsprite = new FlxText(textX, textY, 0, text);
        textsprite.setFormat("Topsicle", textSize);
		textsprite.color = 0xFF000000;
        add(textsprite);
	}

	override function update(elapsed:Float)
	{
		if(changeX)
		{
			var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);
			x = FlxMath.lerp(x, Math.exp(Math.abs(scaledY * 0.6)) * -40 + (FlxG.width * 0.075), GlobalFreeplayStuff.lerpVal);
			if (x < -900)
				x = -900;
		}
		if(changeY)
			y = FlxMath.lerp(y, (targetY * 1.3 * distancePerItem.y) + startPosition.y, GlobalFreeplayStuff.lerpVal);

		textsprite.text = text;
		textsprite.setPosition(getPosition().x + textPosition.x, getPosition().y + textPosition.y);

		super.update(elapsed);
	}
	public function snapToPosition()
	{
		if(changeX)
			x = (targetY * distancePerItem.x) + startPosition.x;
		if(changeY)
			y = (targetY * 1.3 * distancePerItem.y) + startPosition.y;
	}
	function setTextPosition(x:Float, y:Float)
	{
		this.textPosition.x = x;
		this.textPosition.y = y;
	}
}
