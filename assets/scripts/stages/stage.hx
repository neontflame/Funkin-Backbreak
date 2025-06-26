function createStageBack() {
	PlayState.defaultCamZoom = 0.9;
	
	var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('backgrounds/stage/stageback'));
	bg.scrollFactor.set(0.9, 0.9);
	bg.active = false;

	// add to the final array
	game.add(bg);

	var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('backgrounds/stage/stagefront'));
	stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
	stageFront.updateHitbox();
	stageFront.scrollFactor.set(0.9, 0.9);
	stageFront.active = false;

	// add to the final array
	game.add(stageFront);

	var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('backgrounds/stage/stagecurtains'));
	stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
	stageCurtains.updateHitbox();
	stageCurtains.scrollFactor.set(1.3, 1.3);
	stageCurtains.active = false;

	// add to the final array
	game.add(stageCurtains);
}