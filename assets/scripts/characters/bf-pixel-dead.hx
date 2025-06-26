function createCharacter() {
	char.frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD');
	char.quickAnimAdd('singUP', 'BF Dies pixel');
	char.quickAnimAdd('firstDeath', 'BF Dies pixel');
	char.animation.addByPrefix('deathLoop', 'Retry Loop', 24, true);
	char.quickAnimAdd('deathConfirm', 'RETRY CONFIRM');
	char.animation.play('firstDeath');

	char.loadOffsetFile('bf-pixel-dead');
	char.playAnim('firstDeath');
	// pixel bullshit
	char.setGraphicSize(Std.int(char.width * 6));
	char.antialiasing = false;
	char.flipX = true;
	char.updateHitbox();
}