function createCharacter() {
	char.loadFrames('ui/menus/storyMenu/campaign_menu_UI_characters');
	// epic notepad++ replace

	char.animation.addByPrefix('bf', 'BF idle dance white', 24);
	char.animation.addByPrefix('confirm', 'BF HEY!!', 24, false);

	char.animation.play('bf');
	char.updateHitbox();
	
	char.setGraphicSize(Std.int(char.width * 0.9));
	char.updateHitbox();
	char.x -= 80;
	
	char.offset.set(0, 20);
}