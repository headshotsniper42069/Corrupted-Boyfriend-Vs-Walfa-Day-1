import flixel.FlxG;
import flixel.FlxSprite;

class ShameimaruCamera extends FlxSprite
{
    public var clicked:Bool = false;
    public var stepToTrigger:Int = 0;
    public var initialScale:Float = 0;
    public var arrayPosition:Int = 0;
    
    public function new(stepToTrigger:Int){
        super();
        this.stepToTrigger = stepToTrigger;
        loadGraphic(Paths.image("ShameiCamera"));
        setGraphicSize(150);
        updateHitbox();
        trace(scale);
        initialScale = scale.x;
        setPosition(FlxG.random.int(60, 1280 - Std.int(width) - 60), FlxG.random.int(60, 720 - Std.int(height) - 60));
    }
}