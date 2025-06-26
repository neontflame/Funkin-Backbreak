function createCharacter() {
	char.frames = Paths.getPackerAtlas('characters/spirit');
	char.quickAnimAdd('idle', 'idle spirit_');
	char.quickAnimAdd('singUP', 'up_');
	char.quickAnimAdd('singRIGHT', 'right_');
	char.quickAnimAdd('singLEFT', 'left_');
	char.quickAnimAdd('singDOWN', 'spirit down_');

	char.loadOffsetFile('spirit');

	char.setGraphicSize(Std.int(width * 6));
	char.updateHitbox();

	char.playAnim('idle');

	char.antialiasing = false;
	
	char.camOffset[0] = 300;
	char.camOffset[1] = 0;
	
	char.x -= 150;
	char.y += 100;
}