import flixel.FlxG;
import bg.BGSprite;

var tankWatchtower:BGSprite;
var tankGround:BGSprite;

var tankmanRun:FlxTypedGroup<TankmenBG>;

function createStageBack() {
	stage.gfVersion = 'gf-tankmen';
	
	if (PlayState.SONG.song.toLowerCase() == 'stress')
		stage.gfVersion = 'pico-speaker';
	
	game.gf.y += 10;
	game.gf.x -= 30;
	game.boyfriend.x += 40;
	game.boyfriend.y += 0;
	game.dad.y += 60;
	game.dad.x -= 80;

	if (stage.gfVersion != 'pico-speaker') {
		game.gf.x -= 170;
		game.gf.y -= 75;
	} else {
		game.gf.x -= 50;
		game.gf.y -= 200;
	}
	
	PlayState.defaultCamZoom = 0.9;

	var sky:BGSprite = new BGSprite('backgrounds/tank/tankSky', -400, -400, [0, 0]);
	game.add(sky);

	var clouds:BGSprite = new BGSprite('backgrounds/tank/tankClouds', FlxG.random.int(-700, -100), FlxG.random.int(-20, 20),
		[0.1, 0.1]);
	clouds.velocity.x = FlxG.random.float(5, 15);
	game.add(clouds);

	var mountains:BGSprite = new BGSprite('backgrounds/tank/tankMountains', -300, -20, [0.2, 0.2]);
	mountains.setGraphicSize(Std.int(mountains.width * 1.2));
	mountains.updateHitbox();
	game.add(mountains);

	var buildings:BGSprite = new BGSprite('backgrounds/tank/tankBuildings', -200, 0, [0.3, 0.3]);
	buildings.setGraphicSize(Std.int(buildings.width * 1.1));
	buildings.updateHitbox();
	game.add(buildings);

	var ruins:BGSprite = new BGSprite('backgrounds/tank/tankRuins', -200, 0, [0.35, 0.35]);
	ruins.setGraphicSize(Std.int(ruins.width * 1.1));
	ruins.updateHitbox();
	game.add(ruins);

	var smokeL:BGSprite = new BGSprite('backgrounds/tank/smokeLeft', -200, -100, [0.4, 0.4], ['SmokeBlurLeft'], true);
	game.add(smokeL);

	var smokeR:BGSprite = new BGSprite('backgrounds/tank/smokeRight', 1100, -100, [0.4, 0.4], ['SmokeRight'], true);
	game.add(smokeR);

	tankWatchtower = new BGSprite('backgrounds/tank/tankWatchtower', 100, 50, [0.5, 0.5], ['watchtower gradient color']);
	game.add(tankWatchtower);

	tankGround = new BGSprite('backgrounds/tank/tankRolling', 300, 300, [0.5, 0.5], ['BG tank w lighting'], true);
	game.add(tankGround);

	tankmanRun = new FlxTypedGroup();
	game.add(tankmanRun);

	var ground:BGSprite = new BGSprite('backgrounds/tank/tankGround', -420, -150);
	ground.setGraphicSize(Std.int(ground.width * 1.15));
	ground.updateHitbox();
	game.add(ground);
	
	moveTank();
	
	if (stage.gfVersion == 'pico-speaker') {
		var tankmen:TankmenBG = new TankmenBG(20, 500, true);
		trace(tankmen);
		tankmen.strumTime = 10;
		tankmen.resetShit(20, 600, true);
		tankmanRun.add(tankmen);

		for (i in 0...TankmenBG.animationNotes.length) {
			if (!FlxG.random.bool(16))
				continue;

			var man:TankmenBG = tankmanRun.recycle(TankmenBG);
			man.strumTime = TankmenBG.animationNotes[i][0];
			man.resetShit(500, 200 + FlxG.random.int(50, 100), TankmenBG.animationNotes[i][1] < 2);
			tankmanRun.add(man);
		}
	}
}

function createStageFront() {
	var tankdude0:BGSprite = new BGSprite('backgrounds/tank/tank0', -500, 650, [1.7, 1.5], ['fg']);
	game.add(tankdude0);

	var tankdude1:BGSprite = new BGSprite('backgrounds/tank/tank1', -300, 750, [2, 0.2], ['fg']);
	game.add(tankdude1);

	var tankdude2:BGSprite = new BGSprite('backgrounds/tank/tank2', 450, 940, [1.5, 1.5], ['foreground']);
	game.add(tankdude2);

	var tankdude4:BGSprite = new BGSprite('backgrounds/tank/tank4', 1300, 900, [1.5, 1.5], ['fg']);
	game.add(tankdude4);

	var tankdude5:BGSprite = new BGSprite('backgrounds/tank/tank5', 1620, 700, [1.5, 1.5], ['fg']);
	game.add(tankdude5);

	var tankdude3:BGSprite = new BGSprite('backgrounds/tank/tank3', 1300, 1200, [3.5, 2.5], ['fg']);
	game.add(tankdude3);
}

var tankResetShit:Bool = false;
var tankMoving:Bool = false;
var tankAngle:Float = FlxG.random.int(-90, 45);
var tankSpeed:Float = FlxG.random.float(5, 7);
var tankX:Float = 400;
	
function beatHit(curBeat) {
	tankWatchtower.dance();
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
	
function update(elapsed) {
	moveTank();
}