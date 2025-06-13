import PlayState;

function createCharacter() {
	// trace(char.animation.curAnim.name);
	char.exoticDance = true;
	char.charScript.addByPath(Paths.script('characters/gfCommonScript'));
	char.charScript.set('char', char);
	
	char.frames = Paths.getSparrowAtlas('characters/gfPixel');
	char.animation.addByIndices('singUP', 'GF IDLE', [2], '', 24, false);
	char.animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], '', 24, false);
	char.animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], '', 24, false);

	char.loadOffsetFile('gf-pixel');

	char.playAnim('danceRight');

	char.setGraphicSize(Std.int(width * 6));
	char.updateHitbox();
	char.antialiasing = false;
}