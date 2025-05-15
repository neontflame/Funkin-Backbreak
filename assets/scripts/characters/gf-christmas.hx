function createCharacter() {
	// trace(char.animation.curAnim.name);
	char.exoticDance = true;
	char.charScript.addByPath(Paths.script('characters/gf'));
	char.charScript.set('char', char);
}