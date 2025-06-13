import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import PlayState;

using StringTools;

function createCharacter() {
	// trace(char.animation.curAnim.name);
	char.exoticDance = true;
}

var gfDadVis:Bool = false;

function update(elapsed){
	if (char.typeOfChar == 'dad' && PlayState.instance.gf.curCharacter == char.curCharacter && !gfDadVis) {
		PlayState.instance.gf.visible = false;
		gfDadVis = true;
	}
	
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

function playAnim(AnimName, Force, Reversed, Frame) {
	if (AnimName == 'singLEFT') {
		leDance = true;
	} else if (AnimName == 'singRIGHT') {
		leDance = false;
	}

	if (AnimName == 'singUP' || AnimName == 'singDOWN') {
		leDance = !leDance;
	}
}