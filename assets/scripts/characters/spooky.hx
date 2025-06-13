import flixel.animation.FlxBaseAnimation;

function createCharacter() {
	char.exoticDance = true;
	char.y += 200;
	
	char.frames = Paths.getSparrowAtlas('characters/spooky_kids_assets');
	char.quickAnimAdd('singUP', 'spooky UP NOTE');
	char.quickAnimAdd('singDOWN', 'spooky DOWN note');
	char.quickAnimAdd('singLEFT', 'note sing left');
	char.quickAnimAdd('singRIGHT', 'spooky sing right');
	char.animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], '', 12, false);
	char.animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], '', 12, false);

	char.loadOffsetFile('spooky');

	char.playAnim('danceRight');
}

var leDance = true;

function dance() {
	leDance = !leDance;

	if (leDance)
		char.playAnim('danceRight');
	else
		char.playAnim('danceLeft');
}