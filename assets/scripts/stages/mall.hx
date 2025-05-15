function createStageBack() {
	var game = PlayState.instance;
	
	game.boyfriend.x += 200;
	game.boyfriend.camOffset[1] = -200;
	
	PlayState.defaultCamZoom = 0.8;

	var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('backgrounds/mall/bgWalls'));
	bg.scrollFactor.set(0.2, 0.2);
	bg.active = false;
	bg.setGraphicSize(Std.int(bg.width * 0.8));
	bg.updateHitbox();
	game.add(bg);

	upperBoppers = new FlxSprite(-240, -90);
	upperBoppers.frames = Paths.getSparrowAtlas('backgrounds/mall/upperBop');
	upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
	upperBoppers.scrollFactor.set(0.33, 0.33);
	upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
	upperBoppers.updateHitbox();
	game.add(upperBoppers);

	var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('backgrounds/mall/bgEscalator'));
	bgEscalator.scrollFactor.set(0.3, 0.3);
	bgEscalator.active = false;
	bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
	bgEscalator.updateHitbox();
	game.add(bgEscalator);

	var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('backgrounds/mall/christmasTree'));
	tree.scrollFactor.set(0.40, 0.40);
	game.add(tree);

	bottomBoppers = new FlxSprite(-300, 140);
	bottomBoppers.frames = Paths.getSparrowAtlas('backgrounds/mall/bottomBop');
	bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
	bottomBoppers.scrollFactor.set(0.9, 0.9);
	bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
	bottomBoppers.updateHitbox();
	game.add(bottomBoppers);

	var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('backgrounds/mall/fgSnow'));
	fgSnow.active = false;
	game.add(fgSnow);

	santa = new FlxSprite(-840, 150);
	santa.frames = Paths.getSparrowAtlas('backgrounds/mall/santa');
	santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
	game.add(santa);
}

function beatHit(curBeat) {
	upperBoppers.animation.play('bop', true);
	bottomBoppers.animation.play('bop', true);
	santa.animation.play('idle', true);
}