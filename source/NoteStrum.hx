package;

import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

class NoteStrum extends FlxSprite {
	public var player:Int = 0;
	public var noteskin:String = '';
	
	public function new(x:Float, y:Float, num:Int, _noteskin:String = '', _player:Int = 0) {
		super(x, y);
		player = _player;
		noteskin = _noteskin;
		
		switch (noteskin) {
			case 'pixel':
				loadGraphic(Paths.image('ui/noteShit/pixelUI/arrows-pixels'), true, 17, 17);
				animation.add('green', [6]);
				animation.add('red', [7]);
				animation.add('blue', [5]);
				animation.add('purplel', [4]);

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

				switch (num) {
					case 0:
						animation.add('static', [0]);
						animation.add('pressed', [4, 8], 12, false);
						animation.add('confirm', [12, 16], 24, false);
					case 1:
						animation.add('static', [1]);
						animation.add('pressed', [5, 9], 12, false);
						animation.add('confirm', [13, 17], 24, false);
					case 2:
						animation.add('static', [2]);
						animation.add('pressed', [6, 10], 12, false);
						animation.add('confirm', [14, 18], 12, false);
					case 3:
						animation.add('static', [3]);
						animation.add('pressed', [7, 11], 12, false);
						animation.add('confirm', [15, 19], 24, false);
				}

			default:
				frames = Paths.getSparrowAtlas('ui/noteShit/NOTE_strums');
				animation.addByPrefix('green', 'arrowUP');
				animation.addByPrefix('blue', 'arrowDOWN');
				animation.addByPrefix('purple', 'arrowLEFT');
				animation.addByPrefix('red', 'arrowRIGHT');
				setGraphicSize(Std.int(width * 0.7));

				switch (num) {
					case 0:
						animation.addByPrefix('static', 'arrow static instance 1');
						animation.addByPrefix('pressed', 'left press', 24, false);
						animation.addByPrefix('confirm', 'left confirm', 24, false);
					case 1:
						animation.addByPrefix('static', 'arrow static instance 2');
						animation.addByPrefix('pressed', 'down press', 24, false);
						animation.addByPrefix('confirm', 'down confirm', 24, false);
					case 2:
						animation.addByPrefix('static', 'arrow static instance 4');
						animation.addByPrefix('pressed', 'up press', 24, false);
						animation.addByPrefix('confirm', 'up confirm', 24, false);
					case 3:
						animation.addByPrefix('static', 'arrow static instance 3');
						animation.addByPrefix('pressed', 'right press', 24, false);
						animation.addByPrefix('confirm', 'right confirm', 24, false);
				}
		}
	
		ID = num;

		if (player == 1) {
			PlayState.instance.playerStrums.add(this);
			
			animation.finishCallback = function(name:String)
			{
				if (PlayState.instance.botplay)
				{
					if (name == "confirm")
					{
						animation.play('static', true);
						centerOffsets();
					}
				}
			}
		}
			
		animation.play('static');
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}
}
