package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import backend.IrisHandler;
import openfl.utils.Assets as OpenFLAssets;

class MenuCharacter extends FlxSprite {
	public var character:String;
	var initX:Float = 0;
	public var charScript:IrisHandler; // almost everything is softcoded here lol
	
	public function new(x:Float, character:String = 'bf') {
		super(x);
		
		initX = x;

		this.character = character;
		
		charScript = new IrisHandler();
		var file:String = Paths.script('ui/storyMenu/characters/' + character);
		
		if (OpenFLAssets.exists(file))
		{
			trace("[MENUCHARACTER] " + file);
			charScript.addByPath(file);
			charScript.setup();
			charScript.set('char', this);
		} 
		
		charScript.call('createCharacter');
	}
	
	public function refresh(character:String) {
		x = initX;
		setGraphicSize(Std.int(this.frameWidth * 1));
		offset.set(0, 0);
		flipX = false;
		
		charScript = new IrisHandler();
		var file:String = Paths.script('ui/storyMenu/characters/' + character);
		

		if (OpenFLAssets.exists(file))
		{
			trace("[MENUCHARACTER] " + file);
			charScript.addByPath(file);
			charScript.setup();
			charScript.set('char', this);
		} 
		
		charScript.call('createCharacter');
	}
	
	var curPath:String = '';
	
	function loadFrames(path:String) {
		if (curPath == path) return;
		curPath = path;
		frames = Paths.getSparrowAtlas(curPath);
	}
}
