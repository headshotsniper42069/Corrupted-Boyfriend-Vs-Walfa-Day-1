package;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class GalleryItem extends FlxSprite // based off of menuitem
{
	public var targetY:Float = 0;
	public var yOffset:Float = 0;

	public function new(scale:Float, image:FlxGraphicAsset, offset:Float)
	{
		super(x, y);
		loadGraphic(image);
        this.scale.set(scale, scale);
        updateHitbox();
		antialiasing = ClientPrefs.globalAntialiasing;
		yOffset = offset;
	}

    public function reloadImage(scale:Float, image:FlxGraphicAsset)
    {
        loadGraphic(image);
        this.scale.set(scale, scale);
        updateHitbox();
    }

	public function instantSetPosition()
	{
		x = (targetY * 1280) + getTheCenter();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		x = FlxMath.lerp(x, (targetY * 1280) + getTheCenter(), CoolUtil.boundTo(elapsed * 20.2, 0, 1));
        screenCenter(Y);
		y += yOffset;
	}

	function getTheCenter():Float
	{
		return (FlxG.width - width) / 2;
	}
}
