var bgGirls;
var game;
var curSong;
function createStageBack() {
	game = PlayState.instance;
	curSong = PlayState.SONG.song.toLowerCase();
	
	stage.gfVersion = 'gf-pixel';
	
	game.boyfriend.x += 200;
	game.boyfriend.y += 220;
	game.boyfriend.camOffset = [200, -200];

	PlayState.defaultCamZoom = 1.05;

	var bgSky = new FlxSprite().loadGraphic(Paths.image('backgrounds/school/weebSky'));
	bgSky.scrollFactor.set(0.1, 0.1);
	bgSky.antialiasing = false;
	game.add(bgSky);

	var repositionShit = -200;

	var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('backgrounds/school/weebSchool'));
	bgSchool.scrollFactor.set(0.6, 0.90);
	bgSchool.antialiasing = false;
	game.add(bgSchool);

	var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('backgrounds/school/weebStreet'));
	bgStreet.scrollFactor.set(0.95, 0.95);
	bgStreet.antialiasing = false;
	game.add(bgStreet);

	var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('backgrounds/school/weebTreesBack'));
	fgTrees.scrollFactor.set(0.9, 0.9);
	fgTrees.antialiasing = false;
	game.add(fgTrees);

	var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
	var treetex = Paths.getPackerAtlas('backgrounds/school/weebTrees');
	bgTrees.frames = treetex;
	bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
	bgTrees.animation.play('treeLoop');
	bgTrees.scrollFactor.set(0.85, 0.85);
	bgTrees.antialiasing = false;
	game.add(bgTrees);

	var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
	treeLeaves.frames = Paths.getSparrowAtlas('backgrounds/school/petals');
	treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
	treeLeaves.animation.play('leaves');
	treeLeaves.scrollFactor.set(0.85, 0.85);
	treeLeaves.antialiasing = false;
	game.add(treeLeaves);

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

	bgGirls.setGraphicSize(Std.int(bgGirls.width * PlayState.daPixelZoom));
	bgGirls.updateHitbox();
	game.add(bgGirls);

	if (curSong == 'roses') {
		bgGirls.getScared();
		bgGirls.dance();
	}
}

function createStageFront() {
	game.gf.x += 180;
	game.gf.y += 300;	
} 

function beatHit(curBeat) {
	bgGirls.dance();
}