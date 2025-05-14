var halloweenBG:FlxSprite;
	
function createStageBack() {
	var hallowTex = Paths.getSparrowAtlas('backgrounds/spooky/halloween_bg');

	halloweenBG = new FlxSprite(-200, -100);
	halloweenBG.frames = hallowTex;
	halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
	halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
	halloweenBG.animation.play('idle');
	add(halloweenBG);
}

var lightningStrikeBeat:Int = 0;
var lightningOffset:Int = 8;
	
function lightningStrikeShit(curBeat) {
	FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
	halloweenBG.animation.play('lightning');
	
	lightningStrikeBeat = curBeat;
	lightningOffset = FlxG.random.int(8, 24);

	boyfriend.playAnim('scared', true);
	gf.playAnim('scared', true);
}

function beatHit(curBeat) {
	if (FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset) {
		lightningStrikeShit(curBeat);
	}
}