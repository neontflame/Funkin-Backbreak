function createCharacter() {
	char.loadFrames('ui/menus/storyMenu/campaign_menu_UI_characters');
	// epic notepad++ replace
	
	char.animation.addByPrefix('senpai', 'SENPAI idle Black Lines', 24);

	char.animation.play('senpai');
	char.updateHitbox();
	
	char.setGraphicSize(Std.int(char.width * 0.8));
	char.updateHitbox();
	char.offset.set(100, -50);
}