function createCharacter() {
	char.frames = Paths.getSparrowAtlas('characters/bfAndGF');
	char.quickAnimAdd('idle', 'BF idle dance');
	char.quickAnimAdd('singDOWN', 'BF NOTE DOWN0');
	char.quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
	char.quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
	char.quickAnimAdd('singUP', 'BF NOTE UP0');
	char.quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');
	char.quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
	char.quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
	char.quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');

	char.quickAnimAdd('bfCatch', 'BF catches GF');

	char.loadOffsetFile('bf-holding-gf');

	char.playAnim('idle');

	char.flipX = true;
	
	char.gameOverChar = 'bf-holding-gf-dead';
}