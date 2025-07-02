package backend;

import backend.Conductor.BPMChangeEvent;
import flixel.addons.ui.FlxUIState;
import openfl.system.System;
import backend.IrisHandler;

class MusicBeatState extends FlxUIState {
	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;
	
	var globalScript:IrisHandler; 
	
	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create() {
		CoolUtil.clearCache(true, true, false);
		
		// lifted from Funkin-Multikey
		globalScript = new IrisHandler();
		
		var file:String = Paths.script('global');
		if (openfl.utils.Assets.exists(file))
		{
			globalScript.addByPath(file);
			globalScript.setup();
			globalScript.set('this', this);
		}
		
		globalScript.call('create');
		super.create();
		globalScript.call('createPost');
	}

	override function update(elapsed:Float) {
		// everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep >= 0)
			stepHit();

		if (ui.PreferencesMenu.getPref('unlimited-fps'))
			flixel.FlxG.stage.frameRate = 1000;
		else
			flixel.FlxG.stage.frameRate = 60;

		if (FlxG.keys.justPressed.F11)
			FlxG.fullscreen = !FlxG.fullscreen;
		
		globalScript.call('update', [elapsed]);
		super.update(elapsed);
		globalScript.call('updatePost', [elapsed]);
	}

	private function updateBeat():Void {
		curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep():Void {
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length) {
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void {
		globalScript.call('stepHit', [curStep]);
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void {
		globalScript.call('beatHit', [curBeat]);
		// do nothing as of yet
	}
}
