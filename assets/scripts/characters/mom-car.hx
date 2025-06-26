using StringTools;

function createCharacter() {
	char.frames = Paths.getSparrowAtlas('characters/momCar');

	char.quickAnimAdd('idle', 'Mom Idle');
	char.quickAnimAdd('singUP', 'Mom Up Pose');
	char.quickAnimAdd('singDOWN', 'MOM DOWN POSE');
	char.quickAnimAdd('singLEFT', 'Mom Left Pose');
	// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
	// CUZ DAVE IS DUMB!
	char.quickAnimAdd('singRIGHT', 'Mom Pose Left');
	char.animation.addByIndices('idleHair', 'Mom Idle', [10, 11, 12, 13], '', 24, true);

	char.loadOffsetFile('mom-car');

	char.playAnim('idle');
}

function update(elapsed){
	if (!char.animation.curAnim.name.startsWith('sing') && char.animation.curAnim.finished) {
		char.playAnim('idleHair');
	}
}