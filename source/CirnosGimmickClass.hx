import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.FlxSubState;

class CirnosGimmickClass extends FlxSubState // this is unused
{
    var targetImage:FlxGraphic;
    var actualImage:FlxSprite;
    var background:FlxSprite;
    var finishedCallback:Void->Void;
    public function new(targetImage:FlxGraphic, finish:Void->Void)
    {
        super();
        this.targetImage = targetImage;
        this.finishedCallback = finish;
    }
    override public function create()
    {
        super.create();
        background = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        background.scrollFactor.set();
        add(background);
        cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
        trace("added");
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        trace("updating");
        if (FlxG.keys.anyJustPressed(["SPACE", "ENTER", "ESCAPE"]))
        {
            finishedCallback();
            trace("exited");
            close();
        }
    }
}