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

	public var exoticDance:Bool = false;
	
	public var holdTimer:Float = 0;
	
	public var camOffset:Vector2 = [150, -100];

	public function new(x:Float, y:Float, ?character:String = 'bf', ?isPlayer:Bool = false) {
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		
		charScript = new IrisHandler();
		var file:String = Paths.script('characters/' + curCharacter);
		trace(file);

		trace(CoolUtil.fileExists(file));
		if (CoolUtil.fileExists(file))
		{
			trace("Character: " + file);
			charScript.addByPath(file);
			charScript.setup();
			charScript.set('char', this);
		} 
		
		switch (curCharacter) {
			case 'mom':
				tex = Paths.getSparrowAtlas('characters/Mom_Assets');
				frames = tex;

				quickAnimAdd('idle', 'Mom Idle');
				quickAnimAdd('singUP', 'Mom Up Pose');
				quickAnimAdd('singDOWN', 'MOM DOWN POSE');
				quickAnimAdd('singLEFT', 'Mom Left Pose');
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				quickAnimAdd('singRIGHT', 'Mom Pose Left');

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'mom-car':
				tex = Paths.getSparrowAtlas('characters/momCar');
				frames = tex;

				quickAnimAdd('idle', 'Mom Idle');
				quickAnimAdd('singUP', 'Mom Up Pose');
				quickAnimAdd('singDOWN', 'MOM DOWN POSE');
				quickAnimAdd('singLEFT', 'Mom Left Pose');
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				quickAnimAdd('singRIGHT', 'Mom Pose Left');
				animation.addByIndices('idleHair', 'Mom Idle', [10, 11, 12, 13], '', 24, true);

				loadOffsetFile(curCharacter);

				playAnim('idle');
			case 'monster':
				tex = Paths.getSparrowAtlas('characters/Monster_Assets');
				frames = tex;
				quickAnimAdd('idle', 'monster idle');
				quickAnimAdd('singUP', 'monster up note');
				quickAnimAdd('singDOWN', 'monster down');
				quickAnimAdd('singLEFT', 'Monster left note');
				quickAnimAdd('singRIGHT', 'Monster Right note');

				loadOffsetFile(curCharacter);
				playAnim('idle');
			case 'pico':
				tex = Paths.getSparrowAtlas('characters/Pico_FNF_assetss');
				frames = tex;
				quickAnimAdd('idle', 'Pico Idle Dance');
				quickAnimAdd('singUP', 'pico Up note0');
				quickAnimAdd('singDOWN', 'Pico Down Note0');
				if (isPlayer) {
					quickAnimAdd('singLEFT', 'Pico NOTE LEFT0');
					quickAnimAdd('singRIGHT', 'Pico Note Right0');
					quickAnimAdd('singRIGHTmiss', 'Pico Note Right Miss');
					quickAnimAdd('singLEFTmiss', 'Pico NOTE LEFT miss');
				} else {
					// Need to be flipped! REDO THIS LATER!
					quickAnimAdd('singLEFT', 'Pico Note Right0');
					quickAnimAdd('singRIGHT', 'Pico NOTE LEFT0');
					quickAnimAdd('singRIGHTmiss', 'Pico NOTE LEFT miss');
					quickAnimAdd('singLEFTmiss', 'Pico Note Right Miss');
				}

				quickAnimAdd('singUPmiss', 'pico Up note miss');
				quickAnimAdd('singDOWNmiss', 'Pico Down Note MISS');

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;

			case 'bf':
				tex = Paths.getSparrowAtlas('characters/BOYFRIEND');
				frames = tex;
				quickAnimAdd('idle', 'BF idle dance');
				quickAnimAdd('singUP', 'BF NOTE UP0');
				quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
				quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
				quickAnimAdd('singDOWN', 'BF NOTE DOWN0');
				quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
				quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
				quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');
				quickAnimAdd('hey', 'BF HEY');

				quickAnimAdd('firstDeath', 'BF dies');
				animation.addByPrefix('deathLoop', 'BF Dead Loop', 24, true);
				quickAnimAdd('deathConfirm', 'BF Dead confirm');

				animation.addByPrefix('scared', 'BF idle shaking', 24, true);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;

				loadOffsetFile(curCharacter);
			case 'bf-car':
				tex = Paths.getSparrowAtlas('characters/bfCar');
				frames = tex;
				quickAnimAdd('idle', 'BF idle dance');
				quickAnimAdd('singUP', 'BF NOTE UP0');
				quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
				quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
				quickAnimAdd('singDOWN', 'BF NOTE DOWN0');
				quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
				quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
				quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');

				animation.addByIndices('idleHair', 'BF idle dance', [10, 11, 12, 13], '', 24, true);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('characters/bfPixel');
				quickAnimAdd('idle', 'BF IDLE');
				quickAnimAdd('singUP', 'BF UP NOTE');
				quickAnimAdd('singLEFT', 'BF LEFT NOTE');
				quickAnimAdd('singRIGHT', 'BF RIGHT NOTE');
				quickAnimAdd('singDOWN', 'BF DOWN NOTE');
				quickAnimAdd('singUPmiss', 'BF UP MISS');
				quickAnimAdd('singLEFTmiss', 'BF LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF RIGHT MISS');
				quickAnimAdd('singDOWNmiss', 'BF DOWN MISS');

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD');
				quickAnimAdd('singUP', 'BF Dies pixel');
				quickAnimAdd('firstDeath', 'BF Dies pixel');
				animation.addByPrefix('deathLoop', 'Retry Loop', 24, true);
				quickAnimAdd('deathConfirm', 'RETRY CONFIRM');
				animation.play('firstDeath');

				loadOffsetFile(curCharacter);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;
			case 'bf-holding-gf':
				frames = Paths.getSparrowAtlas('characters/bfAndGF');
				quickAnimAdd('idle', 'BF idle dance');
				quickAnimAdd('singDOWN', 'BF NOTE DOWN0');
				quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
				quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
				quickAnimAdd('singUP', 'BF NOTE UP0');
				quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');
				quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
				quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');

				quickAnimAdd('bfCatch', 'BF catches GF');

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;
			case 'bf-holding-gf-dead':
				frames = Paths.getSparrowAtlas('characters/bfHoldingGF-DEAD');
				quickAnimAdd('singUP', 'BF Dead with GF Loop');
				quickAnimAdd('firstDeath', 'BF Dies with GF');
				animation.addByPrefix('deathLoop', 'BF Dead with GF Loop', 24, true);
				quickAnimAdd('deathConfirm', 'RETRY confirm holding gf');

				loadOffsetFile(curCharacter);

				playAnim('firstDeath');

				flipX = true;

			case 'spirit':
				frames = Paths.getPackerAtlas('characters/spirit');
				quickAnimAdd('idle', 'idle spirit_');
				quickAnimAdd('singUP', 'up_');
				quickAnimAdd('singRIGHT', 'right_');
				quickAnimAdd('singLEFT', 'left_');
				quickAnimAdd('singDOWN', 'spirit down_');

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;
			case 'tankman':
				frames = Paths.getSparrowAtlas('characters/tankmanCaptain');
				quickAnimAdd('idle', 'Tankman Idle Dance');
				if (isPlayer) {
					quickAnimAdd('singLEFT', 'Tankman Note Left ');
					quickAnimAdd('singRIGHT', 'Tankman Right Note ');
					quickAnimAdd('singLEFTmiss', 'Tankman Note Left MISS');
					quickAnimAdd('singRIGHTmiss', 'Tankman Right Note MISS');
				} else {
					quickAnimAdd('singLEFT', 'Tankman Right Note ');
					quickAnimAdd('singRIGHT', 'Tankman Note Left ');
					quickAnimAdd('singLEFTmiss', 'Tankman Right Note MISS');
					quickAnimAdd('singRIGHTmiss', 'Tankman Note Left MISS');
				}
				quickAnimAdd('singUP', 'Tankman UP note ');
				quickAnimAdd('singDOWN', 'Tankman DOWN note ');
				quickAnimAdd('singUPmiss', 'Tankman UP note MISS');
				quickAnimAdd('singDOWNmiss', 'Tankman DOWN note MISS');

				quickAnimAdd('singDOWN-alt', 'PRETTY GOOD');
				quickAnimAdd('singUP-alt', 'TANKMAN UGH');

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;
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
		var offsets:Array<String> = Paths.getTextFileArray(Paths.getPath('images/characters/' + char + 'Offsets.txt', TEXT, null));
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

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001) {
				dance();
				holdTimer = 0;
			}
		}

		if (curCharacter.endsWith('-car') && !animation.curAnim.name.startsWith('sing') && animation.curAnim.finished) {
			playAnim('idleHair');
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
				switch (curCharacter) {
					case 'tankman':
						if (!animation.curAnim.name.endsWith('DOWN-alt'))
							playAnim('idle');
				}
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
