function createCharacter() {
	char.loadFrames('ui/menus/storyMenu/campaign_menu_UI_characters');
	// epic notepad++ replace

	char.animation.addByPrefix('spooky', 'spooky dance idle BLACK LINES', 24);

	char.animation.play('spooky');
	char.updateHitbox();
	
	char.setGraphicSize(Std.int(char.width * 0.6));
	char.offset.set(150, 100);
}