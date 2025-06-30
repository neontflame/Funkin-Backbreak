package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.FlxState;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import PlayState;
import crowplexus.iris.Iris;
import crowplexus.iris.IrisConfig;
import openfl.utils.Assets as OpenFlAssets;

import bg.*;
import backend.IrisHandler;

using StringTools;

/**
	This is the stage class. It sets up everything you need for stages in a more organised and clean manner than the
	base game. It's not too bad, just very crowded. I'll be adding stages as a separate
	thing to the weeks, making them not hardcoded to the songs.
**/
class Stage extends FlxTypedGroup<FlxBasic> {
	public var stageScript:IrisHandler;

	public var curStage:String;

	var daPixelZoom = PlayState.daPixelZoom;

	public var gfVersion:String = 'gf';

	public function new(curStage) {
		super();
		
		this.curStage = curStage;

		// this is because I want to avoid editing the fnf chart type
		// custom stage stuffs will come with forever charts
		if (curStage == "") {
			switch (CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase())) {
				case 'spookeez' | 'south' | 'monster':
					curStage = 'spooky';
				case 'pico' | 'blammed' | 'philly-nice' | 'philly':
					curStage = 'philly';
				case 'milf' | 'satin-panties' | 'high':
					curStage = 'limo';
				case 'cocoa' | 'eggnog':
					curStage = 'mall';
				case 'winter-horrorland':
					curStage = 'mallEvil';
				case 'senpai' | 'roses':
					curStage = 'school';
				case 'thorns':
					curStage = 'schoolEvil';
				case 'guns' | 'stress' | 'ugh':
					curStage = 'tank';
				default:
					curStage = 'stage';
			}
		}

		PlayState.curStage = curStage;
		
		stageScript = new IrisHandler();
		var file:String = Paths.script('stages/' + PlayState.curStage);
		if (OpenFlAssets.exists(file))
		{
			trace("[STAGE] " + file);
			stageScript.addByPath(file);
			stageScript.setup();
			stageScript.set('stage', this);
			stageScript.set('BackgroundDancer', BackgroundDancer);
			stageScript.set('BackgroundGirls', BackgroundGirls);
			stageScript.set('TankmenBG', TankmenBG);
			stageScript.set('game', PlayState.instance);
			stageScript.set('timeline', PlayState.instance.timeline);
		}
	}

	public function createStageBack() {
		var boyfriend:Character = PlayState.instance.boyfriend;
		var gf:Character = PlayState.instance.gf;
		var dad:Character = PlayState.instance.dad;
		stageScript.set('bf', boyfriend);
		stageScript.set('gf', gf);
		stageScript.set('dad', dad);
		
		stageScript.call('createStageBack');
	}
	
	public function createStageMiddle() {
		stageScript.call('createStageMiddle');
	}
	
	public function createStageFront() {
		stageScript.call('createStageFront');
	}

	public function stageUpdate(curBeat:Int, boyfriend:Character, gf:Character, dad:Character) {
		stageScript.call('beatHit', [curBeat]);
	}

	public function stageUpdateConstant(elapsed:Float, boyfriend:Character, gf:Character, dad:Character) {
		stageScript.call('update', [elapsed]);
	}


	override function add(Object:FlxBasic):FlxBasic {
		stageScript.set('add', this);
		PlayState.instance.add(Object);
		return super.add(Object);
	}
}
