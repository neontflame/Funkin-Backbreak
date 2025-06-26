function createCharacter() {
	char.frames = Paths.getSparrowAtlas('characters/Pico_FNF_assetss');
	char.quickAnimAdd('idle', 'Pico Idle Dance');
	char.quickAnimAdd('singUP', 'pico Up note0');
	char.quickAnimAdd('singDOWN', 'Pico Down Note0');
	if (char.isPlayer) {
		char.quickAnimAdd('singLEFT', 'Pico NOTE LEFT0');
		char.quickAnimAdd('singRIGHT', 'Pico Note Right0');
		char.quickAnimAdd('singRIGHTmiss', 'Pico Note Right Miss');
		char.quickAnimAdd('singLEFTmiss', 'Pico NOTE LEFT miss');
	} else {
		// Need to be flipped! REDO THIS LATER!
		char.quickAnimAdd('singLEFT', 'Pico Note Right0');
		char.quickAnimAdd('singRIGHT', 'Pico NOTE LEFT0');
		char.quickAnimAdd('singRIGHTmiss', 'Pico NOTE LEFT miss');
		char.quickAnimAdd('singLEFTmiss', 'Pico Note Right Miss');
	}

	char.quickAnimAdd('singUPmiss', 'pico Up note miss');
	char.quickAnimAdd('singDOWNmiss', 'Pico Down Note MISS');

	char.loadOffsetFile('pico');

	char.playAnim('idle');

	char.flipX = true;
		
	char.camOffset[0] = 250;
	if (!char.isPlayer) {
		char.y += 300;
	}
}