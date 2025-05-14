var game;

function cutscene() {
	game = PlayState.instance;
	softcodedSchoolIntro(game.newDialogueBox(game.dialogue, game.startCountdown, game.camHUD));
}

function softcodedSchoolIntro(?dialogueBox) {
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFF000000);
		black.scrollFactor.set();
		game.add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(PlayState.daPixelZoom, PlayState.daPixelZoom);
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();
		senpaiEvil.antialiasing = false;
		senpaiEvil.x += senpaiEvil.width / 5;

		game.camFollow.setPosition(game.camPos.x, game.camPos.y);

		if (PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns') {
			game.remove(black);

			if (PlayState.SONG.song.toLowerCase() == 'thorns') {
				game.add(red);
				game.camHUD.visible = false;
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer) {
			black.alpha -= 0.15;

			if (black.alpha > 0) {
				tmr.reset(0.3);
			} else {
				if (dialogueBox != null) {
					PlayState.inCutscene = true;

					if (PlayState.SONG.song.toLowerCase() == 'thorns') {
						game.add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer) {
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1) {
								swagTimer.reset();
							} else {
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function() {
									game.remove(senpaiEvil);
									game.remove(red);
									FlxG.camera.fade(0xFFFFFFFF, 0.01, true, function() {
										game.add(dialogueBox);
										game.camHUD.visible = true;
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer) {
									FlxG.camera.fade(0xFFFFFFFF, 1.6, false);
								});
							}
						});
					} else {
						game.add(dialogueBox);
					}
				} else
					game.startCountdown();

				game.remove(black);
			}
		});
	}