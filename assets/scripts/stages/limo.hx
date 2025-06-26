var limo:FlxSprite;
var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;

var fastCar:FlxSprite;
	
function createStageBack() {
	stage.gfVersion = 'gf-car';
	
	game.boyfriend.y -= 220;
	game.boyfriend.x += 260;
	
	PlayState.defaultCamZoom = 0.90;

	var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('backgrounds/limo/limoSunset'));
	skyBG.scrollFactor.set(0.1, 0.1);
	game.add(skyBG);

	var bgLimo:FlxSprite = new FlxSprite(-200, 480);
	bgLimo.frames = Paths.getSparrowAtlas('backgrounds/limo/bgLimo');
	bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
	bgLimo.animation.play('drive');
	bgLimo.scrollFactor.set(0.4, 0.4);
	game.add(bgLimo);

	grpLimoDancers = new FlxTypedGroup();
	game.add(grpLimoDancers);

	for (i in 0...5) {
		var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
		dancer.scrollFactor.set(0.4, 0.4);
		grpLimoDancers.add(dancer);
	}

	var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('backgrounds/limo/limoOverlay'));
	overlayShit.alpha = 0.5;
	// add(overlayShit);

	// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

	// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

	// overlayShit.shader = shaderBullshit;


	fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('backgrounds/limo/fastCarLol'));
	// loadArray.add(limo);
}

function createStageMiddle(){
	var limoTex = Paths.getSparrowAtlas('backgrounds/limo/limoDrive');

	limo = new FlxSprite(-120, 550);
	limo.frames = limoTex;
	limo.animation.addByPrefix('drive', "Limo stage", 24);
	limo.animation.play('drive');
	game.add(limo);
}

function beatHit(curBeat) {
	// trace('highway update');
	grpLimoDancers.forEach(function(dancer:BackgroundDancer) {
		dancer.dance();
	});
}