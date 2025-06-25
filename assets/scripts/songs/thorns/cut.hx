function init() {
	game.hasCutscene = true;
}

function cutscene() {
	game.schoolIntro(game.newDialogueBox(game.dialogue, game.startCountdown, game.camHUD));
}