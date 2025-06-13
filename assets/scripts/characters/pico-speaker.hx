import backend.Section.SwagSection;
import bg.TankmenBG;

var animationNotes:Array<Dynamic> = [];
	
function createCharacter() {
	char.exoticDance = true;
	char.frames = Paths.getSparrowAtlas('characters/picoSpeaker');
	char.quickAnimAdd('shoot1', 'Pico shoot 1');
	char.quickAnimAdd('shoot2', 'Pico shoot 2');
	char.quickAnimAdd('shoot3', 'Pico shoot 3');
	char.quickAnimAdd('shoot4', 'Pico shoot 4');

	char.loadOffsetFile('pico-speaker');

	char.playAnim('shoot1');

	char.loadMappedAnims();
}

function loadMappedAnims() {
	var sections:Array<SwagSection> = Song.loadFromJson('picospeaker', 'stress').notes;
	for (section in sections) {
		for (note in section.sectionNotes) {
			animationNotes.push(note);
		}
	}
	TankmenBG.animationNotes = animationNotes;
	trace(animationNotes);
	animationNotes.sort(sortAnims);
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