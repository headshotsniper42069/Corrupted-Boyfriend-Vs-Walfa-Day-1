package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class MenuItem extends FlxSprite
{
	public var targetY:Float = 0; // target Y is actually target X...shit
	public var flashingInt:Int = 0;
	public var inEditor:Bool = false;

	public function new(x:Float, y:Float, weekName:String = '', shouldBeLocked:Bool = false)
	{
		super(x, y);
		loadGraphic(Paths.image('discs/' + weekName + (shouldBeLocked ? "_Locked" : "")));
		//trace('Test added: ' + WeekData.getWeekNumber(weekNum) + ' (' + weekNum + ')');
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	private var isFlashing:Bool = false;

	public function startFlashing():Void
	{
		isFlashing = true;
	}

	// if it runs at 60fps, fake framerate will be 6
	// if it runs at 144 fps, fake framerate will be like 14, and will update the graphic every 0.016666 * 3 seconds still???
	// so it runs basically every so many seconds, not dependant on framerate??
	// I'm still learning how math works thanks whoever is reading this lol
	var fakeFramerate:Int = Math.round((1 / FlxG.elapsed) / 10);

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (!inEditor)
			x = FlxMath.lerp(x, (targetY * 1280) + getTheCenter(), CoolUtil.boundTo(elapsed * 20.2, 0, 1));

		if (isFlashing)
			flashingInt += 1;

		if (flashingInt % fakeFramerate >= Math.floor(fakeFramerate / 2))
			color = 0xFF33ffff;
		else
			color = FlxColor.WHITE;
	}

	function getTheCenter():Float // taken from screenCenter(), not a lotta people credit sources its pretty sad
	{
		return (FlxG.width - width) / 2;
	}
}
