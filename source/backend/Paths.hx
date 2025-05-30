package backend;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

class Paths {
	inline public static var SOUND_EXT = 'ogg';

	static public function getPath(file:String, type:AssetType, library:Null<String>) {
		if (library != null)
			return getLibraryPath(file, library);

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = 'preload') {
		return if (library == 'preload' || library == 'default') getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String) {
		return '$library:assets/$library/$file';
	}

	inline static function getPreloadPath(file:String) {
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String) {
		return getPath(file, type, library);
	}

	inline static public function txt(key:String, ?library:String) {
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String) {
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?root:String = 'data', ?library:String) {
		return getPath('$root/$key.json', TEXT, library);
	}

	inline static public function sound(key:String, ?library:String) {
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String) {
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String) {
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	inline static public function voices(song:String) {
		return getPath('songs/${song.toLowerCase()}/Voices.$SOUND_EXT', MUSIC, null);
	}

	inline static public function inst(song:String) {
		return getPath('songs/${song.toLowerCase()}/Inst.$SOUND_EXT', MUSIC, null);
	}

	inline static public function image(key:String, ?library:String) {
		return getPath('images/$key.png', IMAGE, library);
	}

	inline static public function font(key:String) {
		return getPath('fonts/$key', TEXT, null);
	}

	inline static public function video(key:String, ?library:String) {
		return getPath('videos/$key.mp4', TEXT, library);
	}

	inline static public function script(key:String) {
		var filetypes:Array<String> = ['hx', 'hxs', 'hxc', 'hscript'];
		var existingType:String = 'hx';
		
		for (file in filetypes) {
			if (CoolUtil.fileExists('assets/scripts/$key.$file')) {
				existingType = file;
			}
		}
		
		return 'assets/scripts/$key.$existingType';
	}
	
	inline static public function getSparrowAtlas(key:String, ?library:String) {
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String) {
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}

	public static function getTextFileArray(path:String, delimeter:String = '\n'):Array<String> {
		var daList:Array<String> = openfl.Assets.getText(path).trim().split(delimeter);

		for (i in 0...daList.length) {
			daList[i] = daList[i].trim();
		}

		return daList;
	}
}
