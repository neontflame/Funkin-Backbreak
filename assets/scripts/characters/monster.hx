function createCharacter() {
	char.frames = Paths.getSparrowAtlas('characters/Monster_Assets');
	char.quickAnimAdd('idle', 'monster idle');
	char.quickAnimAdd('singUP', 'monster up note');
	char.quickAnimAdd('singDOWN', 'monster down');
	char.quickAnimAdd('singLEFT', 'Monster left note');
	char.quickAnimAdd('singRIGHT', 'Monster Right note');

	char.loadOffsetFile('monster');
	char.playAnim('idle');
	
	char.y += 100;
}