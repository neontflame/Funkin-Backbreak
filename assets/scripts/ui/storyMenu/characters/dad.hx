function createCharacter() {
	char.loadFrames('ui/menus/storyMenu/campaign_menu_UI_characters');
	// epic notepad++ replace

	char.animation.addByPrefix('dad', 'Dad idle dance BLACK LINE', 24);

	char.animation.play('dad');
	char.updateHitbox();
	
	char.offset.set(120, 200);
	char.setGraphicSize(Std.int(char.width * 0.5));
	char.updateHitbox();
}