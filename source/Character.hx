package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

import backend.IrisHandler;

class Character extends FlxSprite {
	public var charScript:IrisHandler;

	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var typeOfChar:String = 'dad';
	
	public var curCharacter:String = 'bf';
	public var gameOverChar:String = '';
	public var singLength:Float = 4;

	public var exoticDance:Bool = false;
	
	public var holdTimer:Float = 0;
	
	public var camOffset:Vector2 = [150, -100];

	public function new(x:Float, y:Float, ?character:String = 'bf', ?_isPlayer:Bool = false) {
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = _isPlayer;

		var tex:FlxAtlasFrames;
		
		charScript = new IrisHandler();
		var file:String = Paths.script('characters/' + curCharacter);
		
		if (CoolUtil.fileExists(file))
		{
			trace("[CHARACTER] " + file);
			charScript.addByPath(file);
			charScript.setup();
			charScript.set('char', this);
		} 
		
		charScript.call('createCharacter');

		dance();
		animation.finish();

		if (isPlayer) {
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf')) {
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null) {
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	function quickAnimAdd(Name:String, Prefix:String) {
		animation.addByPrefix(Name, Prefix, 24, false);
	}

	function loadOffsetFile(char:String) {
		var offsets:Array<String> = Paths.getTextFileArray(Paths.getPath('images/characters/' + char + 'Offsets.txt'));
		for (i in offsets) {
			var split = i.split(' ');
			addOffset(split[0], Std.parseInt(split[1]), Std.parseInt(split[2]));
		}
	}

	// Boyfriend.hx is no more
	public var stunned:Bool = false;
	public var startedDeath:Bool = false;

	override function update(elapsed:Float) {
		if (isPlayer) {
			if (!debugMode) {
				if (animation.curAnim.name.startsWith('sing')) {
					holdTimer += elapsed;
				} else
					holdTimer = 0;

				if (animation.curAnim.name.endsWith('miss') && animation.curAnim.finished && !debugMode) {
					playAnim('idle', true, false, 10);
				}

				if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished && startedDeath) {
					playAnim('deathLoop');
				}
			}
		} else {
			if (animation.curAnim.name.startsWith('sing')) {
				holdTimer += elapsed;
			}

			if (holdTimer >= Conductor.stepCrochet * singLength * 0.001) {
				dance();
				holdTimer = 0;
			}
		}

		charScript.call('update', [elapsed]);
		super.update(elapsed);
		charScript.call('updatePost', [elapsed]);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance() {
		if (!debugMode) {
			charScript.call('dance');
			
			if (exoticDance) {
				// nothing lol! script it yerself
			} else {
				playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void {
		charScript.call('playAnim', [AnimName, Force, Reversed, Frame]);
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName)) {
			offset.set(daOffset[0], daOffset[1]);
		} else
			offset.set(0, 0);
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0) {
		animOffsets[name] = [x, y];
	}
}
