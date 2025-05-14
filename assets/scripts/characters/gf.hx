import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

function createCharacter() {
	// trace(char.animation.curAnim.name);
	char.exoticDance = true;
}

function update(elapsed){
	if (char.animation.curAnim.name == 'hairFall' && char.animation.curAnim.finished)
		char.playAnim('danceRight');
}

var leDance = true;

function dance() {
	if (!char.animation.curAnim.name.startsWith('hair')) {
		leDance = !leDance;

	if (leDance)
		char.playAnim('danceRight');
	else
		char.playAnim('danceLeft');
	}
}