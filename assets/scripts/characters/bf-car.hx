function createCharacter() {
	char.frames = Paths.getSparrowAtlas('characters/bfCar');
	char.quickAnimAdd('idle', 'BF idle dance');
	char.quickAnimAdd('singUP', 'BF NOTE UP0');
	char.quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
	char.quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
	char.quickAnimAdd('singDOWN', 'BF NOTE DOWN0');
	char.quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
	char.quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
	char.quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
	char.quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');

	char.animation.addByIndices('idleHair', 'BF idle dance', [10, 11, 12, 13], '', 24, true);

	char.loadOffsetFile('bf-car');

	char.playAnim('idle');

	char.flipX = true;
}

function update(elapsed){
	if (!char.animation.curAnim.name.startsWith('sing') && char.animation.curAnim.finished) {
		char.playAnim('idleHair');
	}
}