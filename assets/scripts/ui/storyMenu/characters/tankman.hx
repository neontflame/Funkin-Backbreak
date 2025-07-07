function createCharacter() {
	char.loadFrames('ui/menus/storyMenu/campaign_menu_UI_characters');
	// epic notepad++ replace

	char.animation.addByPrefix('tankman', 'Tankman Menu BLACK', 24);

	char.animation.play('tankman');
	char.updateHitbox();
	
	char.offset.set(60, -20);
}