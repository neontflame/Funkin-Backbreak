package;

#if USE_SHADERS
import shaders.BuildingShaders;
import shaders.ColorSwap;
#end
import animate.FlxAnimate;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.FlxState;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import PlayState;
import crowplexus.iris.Iris;
import crowplexus.iris.IrisConfig;
import openfl.utils.Assets as OpenFlAssets;

import bg.*;
import backend.IrisHandler;

using StringTools;

/**
	This is the stage class. It sets up everything you need for stages in a more organised and clean manner than the
	base game. It's not too bad, just very crowded. I'll be adding stages as a separate
	thing to the weeks, making them not hardcoded to the songs.
**/
class Stage extends FlxTypedGroup<FlxBasic> {
	public var stageScript:IrisHandler;

	public var curStage:String;

	var daPixelZoom = PlayState.daPixelZoom;

	var gfVersion:String = 'gf';

	public function new(curStage) {
		super();
		
		this.curStage = curStage;

		// this is because I want to avoid editing the fnf chart type
		// custom stage stuffs will come with forever charts
		switch (CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase())) {
			case 'spookeez' | 'south' | 'monster':
				curStage = 'spooky';
			case 'pico' | 'blammed' | 'philly-nice':
				curStage = 'philly';
			case 'milf' | 'satin-panties' | 'high':
				curStage = 'limo';
			case 'cocoa' | 'eggnog':
				curStage = 'mall';
			case 'winter-horrorland':
				curStage = 'mallEvil';
			case 'senpai' | 'roses':
				curStage = 'school';
			case 'thorns':
				curStage = 'schoolEvil';
			case 'guns' | 'stress' | 'ugh':
				curStage = 'tank';
			default:
				curStage = 'stage';
		}

		PlayState.curStage = curStage;
		
		stageScript = new IrisHandler();
		var file:String = Paths.script('stages/' + PlayState.curStage);
		trace(file);

		trace(CoolUtil.fileExists(file));
		if (CoolUtil.fileExists(file))
		{
			trace("Stage: " + file);
			stageScript.addByPath(file);
			stageScript.setup();
		}
		
		stageScript.set('stage', this);
	}

	// todo: move these giant switch statements and their variables to individual scripts
	// decluttering my behated

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;
	#if USE_SHADERS
	var lightFadeShader:BuildingShaders;
	#end

	public var limo:FlxSprite;
	public var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;

	var fastCar:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:BackgroundGirls;

	var tankWatchtower:BGSprite;
	var tankGround:BGSprite;

	public var tankmanRun:FlxTypedGroup<TankmenBG>;

	public function createStageBack() {
		var boyfriend:Boyfriend = PlayState.instance.boyfriend;
		var gf:Character = PlayState.instance.gf;
		var dad:Character = PlayState.instance.dad;
		stageScript.set('bf', boyfriend);
		stageScript.set('gf', gf);
		stageScript.set('dad', dad);
		
		switch (PlayState.curStage) {
			case 'philly':
				curStage = 'philly';

				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('backgrounds/' + curStage + '/sky'));
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('backgrounds/' + curStage + '/city'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				#if USE_SHADERS
				lightFadeShader = new BuildingShaders();
				#end
				phillyCityLights = new FlxTypedGroup<FlxSprite>();
				add(phillyCityLights);

				for (i in 0...5) {
					var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('backgrounds/' + curStage + '/win' + i));
					light.scrollFactor.set(0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					#if USE_SHADERS
					light.shader = lightFadeShader.shader;
					#end
					phillyCityLights.add(light);
				}

				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('backgrounds/' + curStage + '/behindTrain'));
				add(streetBehind);

				phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('backgrounds/' + curStage + '/train'));
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				FlxG.sound.list.add(trainSound);

				var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('backgrounds/' + curStage + '/street'));
				add(street);
				// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

				var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('backgrounds/' + curStage + '/street'));
				add(street);
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;
				
				curStage = 'limo';
				PlayState.defaultCamZoom = 0.90;

				var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('backgrounds/' + curStage + '/limoSunset'));
				skyBG.scrollFactor.set(0.1, 0.1);
				add(skyBG);

				var bgLimo:FlxSprite = new FlxSprite(-200, 480);
				bgLimo.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/bgLimo');
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				add(bgLimo);

				grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
				add(grpLimoDancers);

				for (i in 0...5) {
					var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
					dancer.scrollFactor.set(0.4, 0.4);
					grpLimoDancers.add(dancer);
				}

				var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('backgrounds/' + curStage + '/limoOverlay'));
				overlayShit.alpha = 0.5;
				// add(overlayShit);

				// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

				// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

				// overlayShit.shader = shaderBullshit;


				fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('backgrounds/' + curStage + '/fastCarLol'));
			// loadArray.add(limo);

			case 'mall':
				boyfriend.x += 200;
				
				curStage = 'mall';
				PlayState.defaultCamZoom = 0.80;

				var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('backgrounds/' + curStage + '/bgWalls'));
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				upperBoppers = new FlxSprite(-240, -90);
				upperBoppers.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/upperBop');
				upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				add(upperBoppers);

				var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('backgrounds/' + curStage + '/bgEscalator'));
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				add(bgEscalator);

				var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('backgrounds/' + curStage + '/christmasTree'));
				tree.scrollFactor.set(0.40, 0.40);
				add(tree);

				bottomBoppers = new FlxSprite(-300, 140);
				bottomBoppers.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/bottomBop');
				bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);

				var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('backgrounds/' + curStage + '/fgSnow'));
				fgSnow.active = false;
				add(fgSnow);

				santa = new FlxSprite(-840, 150);
				santa.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/santa');
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				add(santa);

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
				
				curStage = 'mallEvil';
				var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('backgrounds/mall/evilBG'));
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('backgrounds/mall/evilTree'));
				evilTree.scrollFactor.set(0.2, 0.2);
				add(evilTree);

				var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("backgrounds/mall/evilSnow"));
				add(evilSnow);

			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
				
				curStage = 'school';

				// defaultCamZoom = 0.9;

				var bgSky = new FlxSprite().loadGraphic(Paths.image('backgrounds/' + curStage + '/weebSky'));
				bgSky.scrollFactor.set(0.1, 0.1);
				add(bgSky);

				var repositionShit = -200;

				var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/weebSchool'));
				bgSchool.scrollFactor.set(0.6, 0.90);
				add(bgSchool);

				var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('backgrounds/' + curStage + '/weebStreet'));
				bgStreet.scrollFactor.set(0.95, 0.95);
				add(bgStreet);

				var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('backgrounds/' + curStage + '/weebTreesBack'));
				fgTrees.scrollFactor.set(0.9, 0.9);
				add(fgTrees);

				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				var treetex = Paths.getPackerAtlas('backgrounds/' + curStage + '/weebTrees');
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);

				var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
				treeLeaves.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/petals');
				treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
				treeLeaves.animation.play('leaves');
				treeLeaves.scrollFactor.set(0.85, 0.85);
				add(treeLeaves);

				var widShit = Std.int(bgSky.width * 6);

				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));
				fgTrees.setGraphicSize(Std.int(widShit * 0.8));
				treeLeaves.setGraphicSize(widShit);

				fgTrees.updateHitbox();
				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();
				treeLeaves.updateHitbox();

				bgGirls = new BackgroundGirls(-100, 190);
				bgGirls.scrollFactor.set(0.9, 0.9);

				if (PlayState.SONG.song.toLowerCase() == 'roses')
					bgGirls.getScared();

				bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
				bgGirls.updateHitbox();
				add(bgGirls);
			case 'schoolEvil':
				var posX = 400;
				var posY = 200;
				var bg:FlxSprite = new FlxSprite(posX, posY);
				bg.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/animatedEvilSchool');
				bg.animation.addByPrefix('idle', 'background 2', 24);
				bg.animation.play('idle');
				bg.scrollFactor.set(0.8, 0.9);
				bg.scale.set(6, 6);
				add(bg);
			case 'tank':
				gf.y += 10;
				gf.x -= 30;
				boyfriend.x += 40;
				boyfriend.y += 0;
				dad.y += 60;
				dad.x -= 80;

				if (gfVersion != 'pico-speaker') {
					gf.x -= 170;
					gf.y -= 75;
				} else {
					gf.x -= 50;
					gf.y -= 200;
				}
				
				PlayState.defaultCamZoom = 0.9;

				curStage = 'tank';

				var sky:BGSprite = new BGSprite('backgrounds/' + curStage + '/tankSky', -400, -400, [0, 0]);
				add(sky);

				var clouds:BGSprite = new BGSprite('backgrounds/' + curStage + '/tankClouds', FlxG.random.int(-700, -100), FlxG.random.int(-20, 20),
					[0.1, 0.1]);
				clouds.velocity.x = FlxG.random.float(5, 15);
				add(clouds);

				var mountains:BGSprite = new BGSprite('backgrounds/' + curStage + '/tankMountains', -300, -20, [0.2, 0.2]);
				mountains.setGraphicSize(Std.int(mountains.width * 1.2));
				mountains.updateHitbox();
				add(mountains);

				var buildings:BGSprite = new BGSprite('backgrounds/' + curStage + '/tankBuildings', -200, 0, [0.3, 0.3]);
				buildings.setGraphicSize(Std.int(buildings.width * 1.1));
				buildings.updateHitbox();
				add(buildings);

				var ruins:BGSprite = new BGSprite('backgrounds/' + curStage + '/tankRuins', -200, 0, [0.35, 0.35]);
				ruins.setGraphicSize(Std.int(ruins.width * 1.1));
				ruins.updateHitbox();
				add(ruins);

				var smokeL:BGSprite = new BGSprite('backgrounds/' + curStage + '/smokeLeft', -200, -100, [0.4, 0.4], ['SmokeBlurLeft'], true);
				add(smokeL);

				var smokeR:BGSprite = new BGSprite('backgrounds/' + curStage + '/smokeRight', 1100, -100, [0.4, 0.4], ['SmokeRight'], true);
				add(smokeR);

				tankWatchtower = new BGSprite('backgrounds/' + curStage + '/tankWatchtower', 100, 50, [0.5, 0.5], ['watchtower gradient color']);
				add(tankWatchtower);

				tankGround = new BGSprite('backgrounds/' + curStage + '/tankRolling', 300, 300, [0.5, 0.5], ['BG tank w lighting'], true);
				add(tankGround);

				tankmanRun = new FlxTypedGroup<TankmenBG>();
				add(tankmanRun);

				var ground:BGSprite = new BGSprite('backgrounds/' + curStage + '/tankGround', -420, -150);
				ground.setGraphicSize(Std.int(ground.width * 1.15));
				ground.updateHitbox();
				add(ground);
				moveTank();

			case 'stage':
				PlayState.defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('backgrounds/' + curStage + '/stageback'));
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;

				// add to the final array
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;

				// add to the final array
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				// add to the final array
				add(stageCurtains);
		}
		
		stageScript.call('createStageBack');
	}
	
	public function createStageMiddle() {
		switch (curStage) {
			case 'limo':
				var limoTex = Paths.getSparrowAtlas('backgrounds/' + curStage + '/limoDrive');

				limo = new FlxSprite(-120, 550);
				limo.frames = limoTex;
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				add(limo);
		}
		stageScript.call('createStageMiddle');
	}
	
	public function createStageFront() {
		switch (curStage) {
			case 'tank':
				var tankdude0:BGSprite = new BGSprite('backgrounds/' + curStage + '/tank0', -500, 650, [1.7, 1.5], ['fg']);
				add(tankdude0);

				var tankdude1:BGSprite = new BGSprite('backgrounds/' + curStage + '/tank1', -300, 750, [2, 0.2], ['fg']);
				add(tankdude1);

				var tankdude2:BGSprite = new BGSprite('backgrounds/' + curStage + '/tank2', 450, 940, [1.5, 1.5], ['foreground']);
				add(tankdude2);

				var tankdude4:BGSprite = new BGSprite('backgrounds/' + curStage + '/tank4', 1300, 900, [1.5, 1.5], ['fg']);
				add(tankdude4);

				var tankdude5:BGSprite = new BGSprite('backgrounds/' + curStage + '/tank5', 1620, 700, [1.5, 1.5], ['fg']);
				add(tankdude5);

				var tankdude3:BGSprite = new BGSprite('backgrounds/' + curStage + '/tank3', 1300, 1200, [3.5, 2.5], ['fg']);
				add(tankdude3);
		}
		stageScript.call('createStageFront');
	}
	
	// return the girlfriend's type
	public function returnGFtype(curStage) {
		switch (curStage) {
			case 'limo':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
			case 'tank':
				gfVersion = 'gf-tankmen';
		}

		if (PlayState.SONG.song.toLowerCase() == 'stress')
			gfVersion = 'pico-speaker';

		return gfVersion;
	}

	// get the dad's position
	public function dadPosition(curStage, dad:Character, gf:Character, camPos:FlxPoint, songPlayer2):Void {
		switch (songPlayer2) {
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
			/*
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
			}*/
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'tankman':
				dad.x += 50;
				dad.y += 200;
		}
	}

	var curLight:Int = 0;
	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	var startedMoving:Bool = false;

	var tankResetShit:Bool = false;
	var tankMoving:Bool = false;
	var tankAngle:Float = FlxG.random.int(-90, 45);
	var tankSpeed:Float = FlxG.random.float(5, 7);
	var tankX:Float = 400;

	public function stageUpdate(curBeat:Int, boyfriend:Boyfriend, gf:Character, dad:Character) {
		stageScript.call('beatHit', [curBeat]);
		// trace('update backgrounds');
		switch (PlayState.curStage) {
			case 'tank':
				tankWatchtower.dance();
			case 'limo':
				// trace('highway update');
				grpLimoDancers.forEach(function(dancer:BackgroundDancer) {
					dancer.dance();
				});
			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'school':
				bgGirls.dance();

			case 'philly':
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
					#if USE_SHADERS
					lightFadeShader.reset();
					#else
					phillyCityLights.members[curLight].alpha = 1;
					#end

					FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, Conductor.stepCrochet * .016);
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8) {
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}
	}

	public function stageUpdateConstant(elapsed:Float, boyfriend:Boyfriend, gf:Character, dad:Character) {
		stageScript.call('update', [elapsed]);

		switch (PlayState.curStage) {
			case 'philly':
				if (trainMoving) {
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24) {
						updateTrainPos(gf);
						trainFrameTiming = 0;
					}
				}

				#if USE_SHADERS
				lightFadeShader.update(1.5 * (Conductor.crochet / 1000) * FlxG.elapsed);
				#else
				phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
				#end
			case 'tank':
				moveTank();
		}
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

	// TANK SHIT

	function moveTank():Void {
		if (!PlayState.inCutscene) {
			tankAngle += tankSpeed * FlxG.elapsed;
			tankGround.angle = (tankAngle - 90 + 15);
			tankGround.x = tankX + 1500 * Math.cos(Math.PI / 180 * (1 * tankAngle + 180));
			tankGround.y = 1300 + 1100 * Math.sin(Math.PI / 180 * (1 * tankAngle + 180));
		}
	}

	override function add(Object:FlxBasic):FlxBasic {
		stageScript.set('add', this);
		PlayState.instance.add(Object);
		return super.add(Object);
	}
}
