package;

import flixel.FlxState;
import wave.video.Player;
import flixel.FlxG;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	final path:String = 'assets/video.mp4';
	var container:Player;

	override public function create():Void
	{
		var text:FlxText = new FlxText(0, 0, FlxG.width, "HxWave FlxPlaybackTest! : Press number keys 1, 2, or 3 to start playback!");
        	text.setFormat(null, 16, 0xFFFFFF, "center"); // Set the text format
        	add(text);
		super.create();
	}

	override public function update(elapsed:Float) {
		/* load method one */
		if (FlxG.keys.justPressed.ONE)
			container = Player.loadMedia(path);
		/* load method two */
		if(FlxG.keys.justPressed.TWO) {
			container = new Player(path);
			container.play();
		}
		/* load method three flixel exclusive */
		if(FlxG.keys.justPressed.THREE)
			flixel.FlxG.switchState(new PlayerState('assets/video.mp4'));
	}
}
