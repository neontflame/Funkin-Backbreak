package;

import flixel.FlxG;
import backend.IrisHandler;

class CustomState extends MusicBeatState {
	var scriptState:IrisHandler;
	var stateName:String = '';
	
	override function create(_state:String) {
		stateName = _state;
		// lifted from Funkin-Multikey
		scriptState = new IrisHandler();
		
		var file:String = Paths.script('states/' + stateName);
		if (openfl.utils.Assets.exists(file))
		{
			scriptState.addByPath(file);
			scriptState.setup();
			scriptState.set('this', this);
		}
		
		scriptState.call('create');
		super.create();
		scriptState.call('createPost');
	}

	override function update(elapsed:Float) {
		scriptState.call('update', [elapsed]);
		super.update(elapsed);
		scriptState.call('updatePost', [elapsed]);
	}
		
	override function stepHit() {
		scriptState.call('stepHit', [curStep]);
		super.stepHit();
	}
	
	override function beatHit() {
		scriptState.call('beatHit', [curBeat]);
		super.beatHit();
	}
}