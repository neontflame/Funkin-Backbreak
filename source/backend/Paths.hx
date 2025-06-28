package backend;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import lime.utils.Assets as LimeAssets;
import openfl.utils.Assets as OpenFlAssets;

class Paths {
	inline public static var SOUND_EXT = 'ogg';

	static public function getPath(file:String) {
		var data = 'assets/$file';
		return data;
	}

	inline static public function file(file:String) {
		return getPath(file);
	}

	inline static public function txt(key:String) {
		return getPath('data/$key.txt');
	}

	inline static public function xml(key:String) {
		return getPath('data/$key.xml');
	}

	inline static public function json(key:String, ?root:String = 'data') {
		return getPath('$root/$key.json');
	}

	inline static public function sound(key:String) {
		return getPath('sounds/$key.$SOUND_EXT');
	}

	inline static public function soundRandom(key:String, min:Int, max:Int) {
		return sound(key + FlxG.random.int(min, max));
	}

	inline static public function music(key:String) {
		return getPath('music/$key.$SOUND_EXT');
	}

	inline static public function voices(song:String) {
		return getPath('songs/${song.toLowerCase()}/Voices.$SOUND_EXT');
	}

	inline static public function inst(song:String) {
		return getPath('songs/${song.toLowerCase()}/Inst.$SOUND_EXT');
	}

	inline static public function image(key:String) {
		return OpenFlAssets.getBitmapData(getPath('images/$key.png'));
	}

	inline static public function font(key:String) {
		return getPath('fonts/$key');
	}

	inline static public function video(key:String) {
		return getPath('videos/$key.mp4');
	}

	inline static public function script(key:String) {
		var filetypes:Array<String> = ['hx', 'hxs', 'hxc', 'hscript'];
		var existingType:String = 'hx';
		
		for (file in filetypes) {
			if (OpenFlAssets.exists(getPath('scripts/$key.$file'))) {
				existingType = file;
			}
		}
		
		return getPath('scripts/$key.$existingType');
	}
	
	inline static public function getSparrowAtlas(key:String) {
		return FlxAtlasFrames.fromSparrow(image(key), file('images/$key.xml'));
	}

	inline static public function getPackerAtlas(key:String) {
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key), file('images/$key.txt'));
	}

	public static function getTextFileArray(path:String, delimeter:String = '\n'):Array<String> {
		var daList:Array<String> = OpenFlAssets.getText(path).trim().split(delimeter);

		for (i in 0...daList.length) {
			daList[i] = daList[i].trim();
		}

		return daList;
	}
}
