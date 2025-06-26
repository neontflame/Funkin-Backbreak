function init() {
	game.hasCutscene = true;
}

function cutscene() {
	FlxG.sound.play(Paths.sound('ANGRY'));
	softcodedSchoolIntro(game.newDialogueBox(game.dialogue, game.startCountdown, game.camHUD));
}

function softcodedSchoolIntro(?dialogueBox) {
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFF000000);
		black.scrollFactor.set();
		game.add(black);
		
		game.camFollow.setPosition(game.camPos.x, game.camPos.y);
		
		game.remove(black);

		new FlxTimer().start(0.3, function(tmr:FlxTimer) {
			black.alpha -= 0.15;

			if (black.alpha > 0) {
				tmr.reset(0.3);
			} else {
				if (dialogueBox != null) {
					PlayState.inCutscene = true;
					game.add(dialogueBox);
				} else
					game.startCountdown();

				game.remove(black);
			}
		});
	}