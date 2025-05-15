import backend.Song;
import PlayState;
import LoadingState;
var game;

function createPost() {
	game = PlayState.instance;
	game.exoticEnding = true;
}

function endSongPost(difficulty) {
	var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
		-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, 0xFF000000);
	blackShit.scrollFactor.set();
	game.add(blackShit);
	game.camHUD.visible = false;

	FlxG.sound.play(Paths.sound('Lights_Shut_off'), 1, false, null, true, function() {
		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
		LoadingState.loadAndSwitchState(new PlayState());
	});
}