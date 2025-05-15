function createStageBack() {
	var game = PlayState.instance;
	
	stage.gfVersion = 'gf-christmas';
	
	var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image("backgrounds/mallEvil/evilBG"));
	bg.antialiasing = true;
	bg.scrollFactor.set(0.2, 0.2);
	bg.active = false;
	bg.setGraphicSize(Std.int(bg.width * 0.8));
	bg.updateHitbox();
	game.add(bg);

	var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('backgrounds/mallEvil/evilTree'));
	evilTree.antialiasing = true;
	evilTree.scrollFactor.set(0.2, 0.2);
	game.add(evilTree);

	var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("backgrounds/mallEvil/evilSnow"));
	evilSnow.antialiasing = true;
	game.add(evilSnow);

	game.boyfriend.x += 320;
	game.dad.y -= 80;
}