function createCharacter() {
	char.frames = Paths.getSparrowAtlas('characters/bfHoldingGF-DEAD');
	char.quickAnimAdd('singUP', 'BF Dead with GF Loop');
	char.quickAnimAdd('firstDeath', 'BF Dies with GF');
	char.animation.addByPrefix('deathLoop', 'BF Dead with GF Loop', 24, true);
	char.quickAnimAdd('deathConfirm', 'RETRY confirm holding gf');

	char.loadOffsetFile('bf-holding-gf-dead');

	char.playAnim('firstDeath');

	char.flipX = true;
}