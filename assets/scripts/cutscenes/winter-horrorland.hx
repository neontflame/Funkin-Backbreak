import flixel.util.FlxColor;

function cutscene()
{
	var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
	game.add(blackScreen);
	blackScreen.scrollFactor.set();
	game.camHUD.visible = false;

	new FlxTimer().start(0.1, function(tmr:FlxTimer)
	{
		game.remove(blackScreen);
		FlxG.sound.play(Paths.sound('Lights_Turn_On'));
		game.camFollow.y = -2050;
		game.camFollow.x += 200;
		FlxG.camera.focusOn(game.camFollow.getPosition());
		FlxG.camera.zoom = 1.5;

		new FlxTimer().start(0.8, function(tmr:FlxTimer)
		{
			game.camHUD.visible = true;
			game.remove(blackScreen);
			FlxTween.tween(FlxG.camera, {zoom: game.defaultCamZoom}, 2.5,
				{
					ease: FlxEase.quadInOut,
					onComplete: function(twn:FlxTween)
					{
						game.startCountdown();
					}
				});
		});
	});
}
