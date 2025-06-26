function createStageBack() {
	game = PlayState.instance;
	
	stage.gfVersion = 'gf-pixel';
	
	game.boyfriend.x += 200;
	game.boyfriend.y += 220;

	var bg:FlxSprite = new FlxSprite(400, 200);
	bg.frames = Paths.getSparrowAtlas('backgrounds/schoolEvil/animatedEvilSchool');
	bg.animation.addByPrefix('idle', 'background 2', 24);
	bg.animation.play('idle');
	bg.scrollFactor.set(0.8, 0.9);
	bg.scale.set(6, 6);
	bg.antialiasing = false;
	game.add(bg);
}

function createStageFront() {
	game.gf.x += 180;
	game.gf.y += 300;
} 