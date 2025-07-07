function beatHit() {
	if (curBeat % 16 == 15 && game.dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48) {
		game.boyfriend.playAnim('hey', true);
		game.dad.playAnim('cheer', true);
	}
}
