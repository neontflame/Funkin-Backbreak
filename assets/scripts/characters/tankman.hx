using StringTools;

function createCharacter() {
	char.frames = Paths.getSparrowAtlas('characters/tankmanCaptain');
	char.quickAnimAdd('idle', 'Tankman Idle Dance');
	if (char.isPlayer) {
			char.quickAnimAdd('singLEFT', 'Tankman Note Left ');
			char.quickAnimAdd('singRIGHT', 'Tankman Right Note ');
			char.quickAnimAdd('singLEFTmiss', 'Tankman Note Left MISS');
			char.quickAnimAdd('singRIGHTmiss', 'Tankman Right Note MISS');
	} else {
			char.quickAnimAdd('singLEFT', 'Tankman Right Note ');
			char.quickAnimAdd('singRIGHT', 'Tankman Note Left ');
			char.quickAnimAdd('singLEFTmiss', 'Tankman Right Note MISS');
			char.quickAnimAdd('singRIGHTmiss', 'Tankman Note Left MISS');
	}
	char.quickAnimAdd('singUP', 'Tankman UP note ');
	char.quickAnimAdd('singDOWN', 'Tankman DOWN note ');
	char.quickAnimAdd('singUPmiss', 'Tankman UP note MISS');
	char.quickAnimAdd('singDOWNmiss', 'Tankman DOWN note MISS');

	char.quickAnimAdd('singDOWN-alt', 'PRETTY GOOD');
	char.quickAnimAdd('singUP-alt', 'TANKMAN UGH');

	char.loadOffsetFile('tankman');

	char.playAnim('idle');

	char.flipX = true;
	char.exoticDance = true;
	
	char.x += 50;
	char.y += 200;
}

function dance() {
	if (!char.animation.curAnim.name.endsWith('DOWN-alt'))
		char.playAnim('idle');
}