package backend;

import PlayState;
import lime.utils.Assets;
import openfl.utils.Assets as OpenFLAssets;
import openfl.system.System;
import flixel.sound.FlxSound;
import flixel.system.FlxAssets.FlxSoundAsset;

using StringTools;

#if !html5
import sys.FileSystem;
#end

class CoolUtil {
	// tymgus45
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];
	public static var difficultyLength = difficultyArray.length;

	public static function difficultyFromNumber(number:Int):String {
		return difficultyArray[number];
	}

	public static function dashToSpace(string:String):String {
		return string.replace("-", " ");
	}

	public static function spaceToDash(string:String):String {
		return string.replace(" ", "-");
	}

	public static function swapSpaceDash(string:String):String {
		return StringTools.contains(string, '-') ? dashToSpace(string) : spaceToDash(string);
	}

	public static function coolTextFile(path:String):Array<String> {
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length) {
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function getOffsetsFromTxt(path:String):Array<Array<String>> {
		var fullText:String = Assets.getText(path);

		var firstArray:Array<String> = fullText.split('\n');
		var swagOffsets:Array<Array<String>> = [];

		for (i in firstArray)
			swagOffsets.push(i.split(' '));

		return swagOffsets;
	}

	public static function returnAssetsLibrary(library:String, ?subDir:String = 'assets/images'):Array<String> {
		//
		var libraryArray:Array<String> = [];
		#if !html5
		var unfilteredLibrary = FileSystem.readDirectory('$subDir/$library');

		for (folder in unfilteredLibrary) {
			if (!folder.contains('.'))
				libraryArray.push(folder);
		}
		trace(libraryArray);
		#end

		return libraryArray;
	}

	public static function getAnimsFromTxt(path:String):Array<Array<String>> {
		var fullText:String = Assets.getText(path);

		var firstArray:Array<String> = fullText.split('\n');
		var swagOffsets:Array<Array<String>> = [];

		for (i in firstArray) {
			swagOffsets.push(i.split('--'));
		}

		return swagOffsets;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int> {
		var dumbArray:Array<Int> = [];
		for (i in min...max) {
			dumbArray.push(i);
		}
		return dumbArray;
	}
	
	public static function fileExists(path):Bool {
		#if sys
		return sys.FileSystem.exists(path);
		#else
		return OpenFLAssets.exists(path);
		#end
	}
		/**
	 * Clears all images and sounds from the cache.
	 * @author swordcube
	 */
	public inline static function clearCache(assets:Bool = true, bitmaps:Bool = true, sounds:Bool = false) {
		
		if (assets) {
			// Clear OpenFL & Lime Assets
			OpenFLAssets.cache.clear();
			Assets.cache.clear();
			trace('asset cache cleared i think');
		} 
		
		if (bitmaps) {
			// Clear all Flixel bitmaps
			FlxG.bitmap.dumpCache();
			FlxG.bitmap.clearCache();
			trace('bitmap cache cleared too');
		}
		
		if (sounds) {
			// Clear all Flixel sounds
			FlxG.sound.list.forEach((sound:FlxSound) -> {
				sound.stop();
				sound.kill();
				sound.destroy();
				trace('fuck you sound');
			});
			FlxG.sound.list.clear();
			FlxG.sound.destroy(false);
		trace('sound cache cleared mhm');
		}
		
		// Run garbage collector just in case none of that worked
		System.gc();
		trace('here comes the garbage truck woo');
	}

}
