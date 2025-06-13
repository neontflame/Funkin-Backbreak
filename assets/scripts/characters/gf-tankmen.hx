function createCharacter() {
	// trace(char.animation.curAnim.name);
	char.exoticDance = true;
	char.charScript.addByPath(Paths.script('characters/gfCommonScript'));
	char.charScript.set('char', char);
	
	char.frames = Paths.getSparrowAtlas('characters/gfTankmen');
	char.animation.addByIndices('sad', 'GF Crying at Gunpoint', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], '', 24, true);
	char.animation.addByIndices('danceLeft', 'GF Dancing at Gunpoint', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], '', 24, false);
	char.animation.addByIndices('danceRight', 'GF Dancing at Gunpoint', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], '', 24, false);

	char.loadOffsetFile('gf');

	char.playAnim('danceRight');
}