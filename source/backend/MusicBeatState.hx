package backend;

import backend.Conductor.BPMChangeEvent;
import flixel.addons.ui.FlxUIState;
import openfl.system.System;

class MusicBeatState extends FlxUIState {
	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create() {
		CoolUtil.clearCache(true, true, false);
		
		// dump
		if (transIn != null)
			trace('reg ' + transIn.region);
			
		super.create();
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

		super.update(elapsed);
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
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void {
		// do nothing as of yet
	}
}
