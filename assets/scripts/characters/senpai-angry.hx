function createCharacter() {
	char.frames = Paths.getSparrowAtlas('characters/senpai');
	char.quickAnimAdd('idle', 'Angry Senpai Idle');
	char.quickAnimAdd('singUP', 'Angry Senpai UP NOTE');
	char.quickAnimAdd('singLEFT', 'Angry Senpai LEFT NOTE');
	char.quickAnimAdd('singRIGHT', 'Angry Senpai RIGHT NOTE');
	char.quickAnimAdd('singDOWN', 'Angry Senpai DOWN NOTE');

	char.loadOffsetFile('senpai-angry');
	char.playAnim('idle');

	char.setGraphicSize(Std.int(char.width * 6));
	char.updateHitbox();

	char.antialiasing = false;
	
	char.camOffset[0] = -100;
	char.camOffset[1] = -450;
	
	char.x += 150;
	char.y += 360;
}