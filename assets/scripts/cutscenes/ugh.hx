function cutscene()
{
	var game = PlayState.instance;
	
	game.playVideoCutscene('assets/videos/ughCutscene.mp4');
	
	FlxG.camera.zoom = PlayState.defaultCamZoom * 1.2;
	game.camFollow.x += 100;
	game.camFollow.y += 100;
}
