package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFLAssets;

class HealthIcon extends FlxSprite {
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public var char:String;
	public var isPlayer:Bool = false;
	public var isOldIcon:Bool = false;

	public function new(char:String = 'bf', isPlayer:Bool = false) {
		super();
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	public function swapOldIcon() {
		isOldIcon = !isOldIcon;

		if (isOldIcon) {
			changeIcon('bf-old');
		} else {
			changeIcon('bf');
		}
	}

	public function changeIcon(char:String) {
		var charSplit = char.split('-')[0].trim();
		if (char != 'bf-pixel' && char != 'bf-old') {
			if (OpenFLAssets.exists(Paths.getPath('images/icons/$charSplit.png'))) {
				char = charSplit;
			}
		}

		if (char != this.char) {
			if (animation.getByName(char) == null) {
				loadGraphic(Paths.image('icons/' + char), true, 150, 150);
				animation.add(char, [0, 1], 0, false, isPlayer);
			}
			animation.play(char);
			this.char = char;
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
