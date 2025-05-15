function createCharacter() {
	char.frames = Paths.getSparrowAtlas('characters/mom_dad_christmas_assets');
	char.quickAnimAdd('idle', 'Parent Christmas Idle');
	char.quickAnimAdd('singUP', 'Parent Up Note Dad');
	char.quickAnimAdd('singDOWN', 'Parent Down Note Dad');
	char.quickAnimAdd('singLEFT', 'Parent Left Note Dad');
	char.quickAnimAdd('singRIGHT', 'Parent Right Note Dad');

	char.quickAnimAdd('singUP-alt', 'Parent Up Note Mom');

	char.quickAnimAdd('singDOWN-alt', 'Parent Down Note Mom');
	char.quickAnimAdd('singLEFT-alt', 'Parent Left Note Mom');
	char.quickAnimAdd('singRIGHT-alt', 'Parent Right Note Mom');

	char.loadOffsetFile('parents-christmas');

	char.playAnim('idle');
}