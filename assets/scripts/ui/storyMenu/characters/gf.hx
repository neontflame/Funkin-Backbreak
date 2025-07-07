function createCharacter() {
	char.loadFrames('ui/menus/storyMenu/campaign_menu_UI_characters');
	// epic notepad++ replace

	char.animation.addByPrefix('gf', 'GF Dancing Beat WHITE', 24);

	char.animation.play('gf');
	char.updateHitbox();
	
	char.setGraphicSize(Std.int(char.width * 0.65));
	char.updateHitbox();
	char.offset.set(130, 130);
}