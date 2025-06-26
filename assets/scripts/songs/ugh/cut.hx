import LoadingState;
import CutsceneAnimTestState;

function init() {
	game.hasCutscene = true;
}

function createPost() {
	/* timeline.queueBeat(5, 
	function(){
		game.playVideoMidsong('assets/videos/ughCutscene.mp4');
	}
	); */
}

function cutscene()
{
	game.playVideoCutscene('assets/videos/ughCutscene.mp4');
	
	FlxG.camera.zoom = PlayState.defaultCamZoom * 1.2;
	game.camFollow.x += 100;
	game.camFollow.y += 100;
}
