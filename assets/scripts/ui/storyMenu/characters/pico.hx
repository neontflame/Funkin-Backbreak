function createCharacter() {
	char.loadFrames('ui/menus/storyMenu/campaign_menu_UI_characters');
	// epic notepad++ replace

	char.animation.addByPrefix('pico', 'Pico Idle Dance', 24);

	char.animation.play('pico');
	char.updateHitbox();
	
	char.flipX = true;
	char.offset.set(150, 40);
	char.setGraphicSize(Std.int(char.width * 0.65));
}