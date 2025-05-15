function createCharacter() {
	char.tex = Paths.getSparrowAtlas('characters/bfChristmas');
	char.frames = char.tex;
	char.quickAnimAdd('idle', 'BF idle dance');
	char.quickAnimAdd('singUP', 'BF NOTE UP0');
	char.quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
	char.quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
	char.quickAnimAdd('singDOWN', 'BF NOTE DOWN0');
	char.quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
	char.quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
	char.quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
	char.quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');
	char.quickAnimAdd('hey', 'BF HEY');

	char.loadOffsetFile('bf-christmas');

	char.playAnim('idle');

	char.flipX = true;
}