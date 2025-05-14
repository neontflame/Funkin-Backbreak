import flixel.animation.FlxBaseAnimation;

function createCharacter() {
	char.y += 200;
}

var leDance = true;

function dance() {
	leDance = !leDance;

	if (leDance)
		char.playAnim('danceRight');
	else
		char.playAnim('danceLeft');
}