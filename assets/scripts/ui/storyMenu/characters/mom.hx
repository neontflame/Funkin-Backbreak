function createCharacter() {
	char.loadFrames('ui/menus/storyMenu/campaign_menu_UI_characters');
	// epic notepad++ replace
	
	char.animation.addByPrefix('mom', 'Mom Idle BLACK LINES', 24);

	char.animation.play('mom');
	char.updateHitbox();
	
	char.setGraphicSize(Std.int(char.width * 0.4));
	char.updateHitbox();
	char.offset.set(100, 230);
}