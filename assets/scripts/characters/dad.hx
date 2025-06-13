function createCharacter() {
	// DAD ANIMATION LOADING CODE
	char.frames = Paths.getSparrowAtlas('characters/DADDY_DEAREST');
	char.quickAnimAdd('idle', 'Dad idle dance');
	char.quickAnimAdd('singUP', 'Dad Sing Note UP');
	char.quickAnimAdd('singRIGHT', 'Dad Sing Note RIGHT');
	char.quickAnimAdd('singDOWN', 'Dad Sing Note DOWN');
	char.quickAnimAdd('singLEFT', 'Dad Sing Note LEFT');

	char.loadOffsetFile('dad');

	char.playAnim('idle');
}