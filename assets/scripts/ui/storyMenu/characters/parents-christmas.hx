function createCharacter() {
	char.loadFrames('ui/menus/storyMenu/campaign_menu_UI_characters');
	// epic notepad++ replace

	char.animation.addByPrefix('parents-christmas', 'Parent Christmas Idle', 24);

	char.animation.play('parents-christmas');
	char.updateHitbox();
	
	char.setGraphicSize(Std.int(char.width * 0.4));
	char.updateHitbox();
	char.offset.set(360, 200);
}