package backend;

import flixel.FlxG;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxRect;
import flixel.system.FlxAssets;

import openfl.display.BitmapData;
import openfl.display3D.textures.RectangleTexture;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import openfl.system.System;
import openfl.geom.Rectangle;

import lime.utils.Assets;
import flash.media.Sound;

#if sys
import sys.FileSystem;
#end 

class Paths {
	inline public static var SOUND_EXT = 'ogg';

	public static function excludeAsset(key:String) {
		if (!dumpExclusions.contains(key))
			dumpExclusions.push(key);
	}

	public static var dumpExclusions:Array<String> = ['assets/shared/music/freakyMenu.$SOUND_EXT'];
	// haya I love you for the base cache dump I took to the max
	public static function clearUnusedMemory()
	{
		// clear non local assets in the tracked assets list
		for (key in currentTrackedAssets.keys())
		{
			// if it is not currently contained within the used local assets
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key))
			{
				destroyGraphic(currentTrackedAssets.get(key)); // get rid of the graphic
				currentTrackedAssets.remove(key); // and remove the key from local cache map
			}
		}

		// run the garbage collector for good measure lmfao
		System.gc();
	}

	// define the locally tracked assets
	public static var localTrackedAssets:Array<String> = [];
	public static var currentTrackedSounds:Map<String, Sound> = [];
	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];

	@:access(flixel.system.frontEnds.BitmapFrontEnd._cache)
	public static function clearStoredMemory()
	{
		// clear anything not in the tracked assets list
		for (key in FlxG.bitmap._cache.keys())
		{
			if (!currentTrackedAssets.exists(key))
				destroyGraphic(FlxG.bitmap.get(key));
		}

		// clear all sounds that are cached
		for (key => asset in currentTrackedSounds)
		{
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key) && asset != null)
			{
				Assets.cache.clear(key);
				currentTrackedSounds.remove(key);
			}
		}
		// flags everything to be cleared out next unused memory clear
		localTrackedAssets = [];
		#if !html5 openfl.Assets.cache.clear("songs"); #end
	}

	public static function freeGraphicsFromMemory()
	{
		var protectedGfx:Array<FlxGraphic> = [];
		function checkForGraphics(spr:Dynamic)
		{
			try
			{
				var grp:Array<Dynamic> = Reflect.getProperty(spr, 'members');
				if(grp != null)
				{
					//trace('is actually a group');
					for (member in grp)
					{
						checkForGraphics(member);
					}
					return;
				}
			}

			//trace('check...');
			try
			{
				var gfx:FlxGraphic = Reflect.getProperty(spr, 'graphic');
				if(gfx != null)
				{
					protectedGfx.push(gfx);
					//trace('gfx added to the list successfully!');
				}
			}
			//catch(haxe.Exception) {}
		}

		for (member in FlxG.state.members)
			checkForGraphics(member);

		if(FlxG.state.subState != null)
			for (member in FlxG.state.subState.members)
				checkForGraphics(member);

		for (key in currentTrackedAssets.keys())
		{
			// if it is not currently contained within the used local assets
			if (!dumpExclusions.contains(key))
			{
				var graphic:FlxGraphic = currentTrackedAssets.get(key);
				if(!protectedGfx.contains(graphic))
				{
					destroyGraphic(graphic); // get rid of the graphic
					currentTrackedAssets.remove(key); // and remove the key from local cache map
					//trace('deleted $key');
				}
			}
		}
	}

	inline static function destroyGraphic(graphic:FlxGraphic)
	{
		// free some gpu memory
		@:privateAccess
		if (graphic != null && graphic.bitmap != null && graphic.bitmap.__texture != null) {
			@:privateAccess
			graphic.bitmap.__texture.dispose();
		}
		FlxG.bitmap.remove(graphic);
	}

	public static function cacheBitmap(key:String, ?bitmap:BitmapData, ?allowGPU:Bool = true):FlxGraphic
	{
		if (bitmap == null)
		{
			var file:String = getPath(key, IMAGE, null);
			if (OpenFlAssets.exists(file, IMAGE))
				bitmap = OpenFlAssets.getBitmapData(file);

			if (bitmap == null)
			{
				trace('Bitmap not found: $file | key: $key');
				return null;
			}
		}

		// Upload to GPU if needed
		if (allowGPU)
		{
			@:privateAccess
			if (bitmap.__texture == null)
			{
				bitmap.getTexture(FlxG.stage.context3D);
			}
			
			bitmap.getSurface();
			bitmap.disposeImage(); // Frees GPU texture, retains RAM copy
		}

		var graph:FlxGraphic = FlxGraphic.fromBitmapData(bitmap, false, key);
		graph.persist = true;
		graph.destroyOnNoUse = false;

		currentTrackedAssets.set(key, graph);
		localTrackedAssets.push(key);
		return graph;
	}


	public static function returnSound(key:String, ?beepOnNull:Bool = true)
	{
		var file:String = getPath('$key.$SOUND_EXT', SOUND, null);

		//trace('precaching sound: $file');
		if(!currentTrackedSounds.exists(file))
		{
			#if sys
			if(FileSystem.exists(file))
				currentTrackedSounds.set(file, Sound.fromFile(file));
			#else
			if(OpenFlAssets.exists(file, SOUND))
				currentTrackedSounds.set(file, OpenFlAssets.getSound(file));
			#end
			else if(beepOnNull)
			{
				trace('SOUND NOT FOUND: $key');
				FlxG.log.error('SOUND NOT FOUND: $key');
				return FlxAssets.getSound('flixel/sounds/beep');
			}
		}
		localTrackedAssets.push(file);
		return currentTrackedSounds.get(file);
	}
	
	// END CACHE LOL
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
		return returnSound('sounds/$key');
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String) {
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String) {
		return returnSound('music/$key');
	}

	inline static public function voices(song:String) {
		return returnSound('songs/${song.toLowerCase()}/Voices');
	}

	inline static public function inst(song:String) {
		return returnSound('songs/${song.toLowerCase()}/Inst');
	}

	
	static public function image(key:String, ?allowGPU:Bool = true):FlxGraphic
	{
		key = 'images/$key.png';
		var bitmap:BitmapData = null;
		if (currentTrackedAssets.exists(key))
		{
			localTrackedAssets.push(key);
			return currentTrackedAssets.get(key);
		}
		return cacheBitmap(key, bitmap, allowGPU);
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
	
	inline static public function getSparrowAtlas(key:String, ?allowGPU:Bool = true):FlxAtlasFrames
	{
		var imageLoaded:FlxGraphic = image(key, allowGPU);
		return FlxAtlasFrames.fromSparrow(imageLoaded, getPath('images/$key.xml', TEXT, null));
	}

	inline static public function getPackerAtlas(key:String, ?allowGPU:Bool = true):FlxAtlasFrames
	{
		var imageLoaded:FlxGraphic = image(key, allowGPU);
		return FlxAtlasFrames.fromSpriteSheetPacker(imageLoaded, getPath('images/$key.txt', TEXT, null));
	}

	public static function getTextFileArray(path:String, delimeter:String = '\n'):Array<String> {
		var daList:Array<String> = openfl.Assets.getText(path).trim().split(delimeter);

		for (i in 0...daList.length) {
			daList[i] = daList[i].trim();
		}

		return daList;
	}
}
