function createCharacter() {
	char.tex = Paths.getSparrowAtlas('characters/monsterChristmas');
	char.frames = char.tex;
	char.quickAnimAdd('idle', 'monster idle');
	char.quickAnimAdd('singUP', 'monster up note');
	char.quickAnimAdd('singDOWN', 'monster down');
	char.quickAnimAdd('singLEFT', 'Monster left note');
	char.quickAnimAdd('singRIGHT', 'Monster Right note');

	char.loadOffsetFile('monster-christmas');
	char.playAnim('idle');
	
	char.y += 130;
}