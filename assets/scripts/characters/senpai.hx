function createCharacter() {
	char.frames = Paths.getSparrowAtlas('characters/senpai');
	char.quickAnimAdd('idle', 'Senpai Idle');
	char.quickAnimAdd('singUP', 'SENPAI UP NOTE');
	char.quickAnimAdd('singLEFT', 'SENPAI LEFT NOTE');
	char.quickAnimAdd('singRIGHT', 'SENPAI RIGHT NOTE');
	char.quickAnimAdd('singDOWN', 'SENPAI DOWN NOTE');

	char.loadOffsetFile('senpai');

	char.playAnim('idle');

	char.setGraphicSize(Std.int(width * 6));
	char.updateHitbox();

	char.antialiasing = false;
	
	char.camOffset[0] = -430;
	
	char.x += 150;
	char.y += 360;
}