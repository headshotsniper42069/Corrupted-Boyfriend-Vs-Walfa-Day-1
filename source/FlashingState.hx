package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	var rememberText:FlxText;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"Hey, watch out!\n
			This Mod contains some flashing lights!\n
			Press ENTER to disable them now or go to Options Menu.\n
			Press ESCAPE to ignore this message.\n
			You've been warned!",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);

		rememberText = new FlxText(0, 0, FlxG.width,
			"Remember to set your keybinds and preferences!",
			32);
		rememberText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		rememberText.screenCenter(Y);
		add(rememberText);
		rememberText.alpha = 0;
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (warnText.alpha >= 0.5)
			{
				if (controls.ACCEPT || back) {
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					if(!back) {
						ClientPrefs.flashing = false;
						ClientPrefs.saveSettings();
						FlxG.sound.play(Paths.sound('scrollMenu'));
					} else {
						ClientPrefs.saveSettings();
						FlxG.sound.play(Paths.sound('cancelMenu'));
					}
					warnText.alpha = 0;
					rememberText.alpha = 1;
				}
			}
			else
			{
				if (controls.ACCEPT || back) {
					leftState = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(rememberText, 1, 0.1, false, true, function(flk:FlxFlicker) {
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new TitleState());
						});
					});
				}
			}
		}
		super.update(elapsed);
	}
}
