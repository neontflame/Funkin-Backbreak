import shaders.BuildingShaders;
import shaders.ColorSwap;

var phillyCityLights:FlxTypedGroup<FlxSprite>;
var phillyTrain:FlxSprite;
var trainSound:FlxSound;
var lightFadeShader:BuildingShaders;

var USE_SHADERS:Bool = true;

function createStageBack() {
	PlayState.defaultCamZoom = 1.05;

	var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('backgrounds/philly/sky'));
	bg.scrollFactor.set(0.1, 0.1);
	game.add(bg);

	var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('backgrounds/philly/city'));
	city.scrollFactor.set(0.3, 0.3);
	city.setGraphicSize(Std.int(city.width * 0.85));
	city.updateHitbox();
	game.add(city);

	lightFadeShader = new BuildingShaders();
	phillyCityLights = new FlxTypedGroup();
	game.add(phillyCityLights);

	for (i in 0...5) {
		var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('backgrounds/philly/win' + i));
		light.scrollFactor.set(0.3, 0.3);
		light.visible = false;
		light.setGraphicSize(Std.int(light.width * 0.85));
		light.updateHitbox();
		if (USE_SHADERS) light.shader = lightFadeShader.shader;
		phillyCityLights.add(light);
	}

	var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('backgrounds/philly/behindTrain'));
	game.add(streetBehind);

	phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('backgrounds/philly/train'));
	game.add(phillyTrain);

	trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
	FlxG.sound.list.add(trainSound);

	var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('backgrounds/philly/street'));
	game.add(street);
	// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

	var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('backgrounds/philly/street'));
	game.add(street);
}

var curLight:Int = 0;
var trainMoving:Bool = false;
var trainFrameTiming:Float = 0;

var trainCars:Int = 8;
var trainFinishing:Bool = false;
var trainCooldown:Int = 0;
var startedMoving:Bool = false;

function beatHit(curBeat) {
	if (!trainMoving)
		trainCooldown += 1;

	if (curBeat % 4 == 0) {
		var lastLight:FlxSprite = phillyCityLights.members[0];

		phillyCityLights.forEach(function(light:FlxSprite) {
			// Take note of the previous light
			if (light.visible == true)
				lastLight = light;

			light.visible = false;
		});

		// To prevent duplicate lights, iterate until you get a matching light
		while (lastLight == phillyCityLights.members[curLight]) {
			curLight = FlxG.random.int(0, phillyCityLights.length - 1);
		}

		phillyCityLights.members[curLight].visible = true;
		if (USE_SHADERS) lightFadeShader.reset();
		else phillyCityLights.members[curLight].alpha = 1;

		FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, Conductor.stepCrochet * .016);
	}

	if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8) {
		trainCooldown = FlxG.random.int(-4, 0);
		trainStart();
	}
}

function update(elapsed) {
	if (trainMoving) {
		trainFrameTiming += elapsed;

		if (trainFrameTiming >= 1 / 24) {
			updateTrainPos(gf);
			trainFrameTiming = 0;
		}
	}

	if (USE_SHADERS) lightFadeShader.update(1.5 * (Conductor.crochet / 1000) * FlxG.elapsed);
	else phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
}

// PHILLY STUFFS!
function trainStart():Void {
	trainMoving = true;
	if (!trainSound.playing)
		trainSound.play(true);
}

function updateTrainPos(gf:Character):Void {
	if (trainSound.time >= 4700) {
		startedMoving = true;
		gf.playAnim('hairBlow');
	}

	if (startedMoving) {
		phillyTrain.x -= 400;

		if (phillyTrain.x < -2000 && !trainFinishing) {
			phillyTrain.x = -1150;
			trainCars -= 1;

			if (trainCars <= 0)
				trainFinishing = true;
		}

		if (phillyTrain.x < -4000 && trainFinishing)
			trainReset(gf);
	}
}

function trainReset(gf:Character):Void {
	gf.playAnim('hairFall');
	phillyTrain.x = FlxG.width + 200;
	trainMoving = false;
	// trainSound.stop();
	// trainSound.time = 0;
	trainCars = 8;
	trainFinishing = false;
	startedMoving = false;
}