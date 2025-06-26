import GameOverSubstate;

function createCharacter() {
	char.frames = Paths.getSparrowAtlas('characters/bfPixel');
	char.quickAnimAdd('idle', 'BF IDLE');
	char.quickAnimAdd('singUP', 'BF UP NOTE');
	char.quickAnimAdd('singLEFT', 'BF LEFT NOTE');
	char.quickAnimAdd('singRIGHT', 'BF RIGHT NOTE');
	char.quickAnimAdd('singDOWN', 'BF DOWN NOTE');
	char.quickAnimAdd('singUPmiss', 'BF UP MISS');
	char.quickAnimAdd('singLEFTmiss', 'BF LEFT MISS');
	char.quickAnimAdd('singRIGHTmiss', 'BF RIGHT MISS');
	char.quickAnimAdd('singDOWNmiss', 'BF DOWN MISS');

	char.loadOffsetFile('bf-pixel');

	char.setGraphicSize(Std.int(char.width * 6));
	char.updateHitbox();

	char.playAnim('idle');

	char.width -= 100;
	char.height -= 100;

	char.antialiasing = false;

	char.flipX = true;
	char.gameOverChar = 'bf-pixel-dead';
	GameOverSubstate.stageSuffix = '-pixel';
}