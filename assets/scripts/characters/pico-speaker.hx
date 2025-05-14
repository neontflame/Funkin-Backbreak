function createCharacter() {
	char.exoticDance = true;
}

function update(elapsed){
	if (char.animationNotes.length > 0 && Conductor.songPosition > char.animationNotes[0][0]) {
	
		trace('played shoot anim' + char.animationNotes[0][1]);
		
		var shotDirection:Int = 1;
		if (char.animationNotes[0][1] >= 2) {
			shotDirection = 3;
		}
		shotDirection += FlxG.random.int(0, 1);

		char.playAnim('shoot' + shotDirection, true);
		char.animationNotes.shift();
	}
	
	if (char.animation.curAnim.finished) {
		char.playAnim(char.animation.curAnim.name, false, false, char.animation.curAnim.frames.length - 3);
	}
}