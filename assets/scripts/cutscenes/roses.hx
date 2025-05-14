function cutscene() {
	FlxG.sound.play(Paths.sound('ANGRY'));
	game.schoolIntro(game.newDialogueBox(game.dialogue, game.startCountdown, game.camHUD));
}