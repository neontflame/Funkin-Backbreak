package backend; // put this file wherever you want, you STILL must change this

import crowplexus.iris.Iris;
import openfl.utils.Assets;
#if sys
import sys.io.File;
#end

using StringTools;

class IrisHandler {
	public static var path:String = "assets/data/scripts";
	public static var extensions:Array<String> = ["hx", "hxs", "hxc", "hscript"];

	var scripts:Array<Iris> = [];

	public function new(?folders:Array<String>) {
		// if (folders != null)
			// loadFolder(folders);
	}

	/*
	public function loadFolder(folders:Array<String>):Void {
		for (folder in folders) {
			#if sys
			if (!sys.FileSystem.exists('./$path/$folder')) return;
			var items:Array<String> = sys.FileSystem.readDirectory('./${path + (folder != "" ? "/" : "")}$folder');
			#elseif openfl
			if (!Assets.exists('./$path/$folder')) return;
			var items:Array<String> = Assets.list('./${path + (folder != "" ? "/" : "")}$folder');
			#end
			for (item in items) {
				for (extension in extensions)
					if (!item.endsWith('.$extension')) return;
				var scriptPath:String = (folder != "" ? folder + "/" : folder) + item;
				#if sys
				var script:Iris = new Iris(File.getContent('./$path/$scriptPath'), {name: scriptPath, autoRun: true, autoPreset: true});
				#else
				var script:Iris = new Iris(Assets.getText('./$path/$scriptPath'), {name: scriptPath, autoRun: true, autoPreset: true});
				#end
				add(script);
			}
		}
	}
	*/
	
	public function addByPath(path:String):Void {
		#if sys
		var script:Iris = new Iris(File.getContent(path), {name: path, autoRun: true, autoPreset: true});
		#else
		var script:Iris = new Iris(Assets.getText(path), {name: path, autoRun: true, autoPreset: true});
		#end
		add(script);
	}
	
	public function add(script:Iris):Void {
		if (script != null)
			scripts.push(script);
			
		setup();
	}

	public function call(func:String, ?args:Array<Dynamic>):Void {
		for (script in scripts) {
			var scriptFunc:Dynamic = script.get(func);
			if (scriptFunc != null && Reflect.isFunction(scriptFunc))
				script.call(func, args);
		}
	}

	public function set(name:String, value:Dynamic):Void {
		for (script in scripts)
			script.set(name, value, true);
	}

	public function destroy():Void {
		for (script in scripts)
			script.destroy();
	}
	
	public function setup():Void {
		#if sys
		set("Sys", Sys);
		#end
		set("Std", Std);
		set("Math", Math);
		set("StringTools", StringTools);

		// Classes (Assets)
		set("Assets", openfl.utils.Assets);
		set("LimeAssets", lime.utils.Assets);

		// Classes (Flixel)
		set("FlxG", flixel.FlxG);
		set("FlxSprite", flixel.FlxSprite);
		set("FlxTypedGroup", flixel.group.FlxGroup.FlxTypedGroup);
		set("FlxSpriteGroup", flixel.group.FlxSpriteGroup);
		set("FlxCamera", flixel.FlxCamera);
		set("FlxMath", flixel.math.FlxMath);
		set("FlxTimer", flixel.util.FlxTimer);
		set("FlxTween", flixel.tweens.FlxTween);
		set("FlxEase", flixel.tweens.FlxEase);
		set("FlxSound", flixel.sound.FlxSound);
		set("FlxRuntimeShader", flixel.addons.display.FlxRuntimeShader);
		set("FlxFlicker", flixel.effects.FlxFlicker);
		set('FlxSpriteUtil', flixel.util.FlxSpriteUtil);
		set("FlxBackdrop", flixel.addons.display.FlxBackdrop);
		set("FlxTiledSprite", flixel.addons.display.FlxTiledSprite);

		set("add", FlxG.state.add);
		set("remove", FlxG.state.remove);
		set("insert", FlxG.state.insert);
		set("members", FlxG.state.members);

		set('FlxCameraFollowStyle', flixel.FlxCamera.FlxCameraFollowStyle);
		set("FlxTextBorderStyle", flixel.text.FlxText.FlxTextBorderStyle);
		set("FlxBarFillDirection", flixel.ui.FlxBar.FlxBarFillDirection);

		set('FlxPoint', flixel.math.FlxPoint.FlxBasePoint); // redirects to flxbasepoint because thats all flxpoints are
		set("FlxBasePoint", flixel.math.FlxPoint.FlxBasePoint);
		
		// Classes (Funkin')
		set("PreferencesMenu", ui.PreferencesMenu);
		set("Paths", Paths);
		set("CoolUtil", CoolUtil);
		set("Conductor", Conductor);
		set("MusicBeatState", MusicBeatState);
		set("PlayState", PlayState);
		
		set("Note", Note);
		set("NoteSplash", NoteSplash);
		
		set("HealthIcon", HealthIcon);
		set("Character", Character);
		
		set("BGSprite", bg.BGSprite);
		set("Alphabet", ui.Alphabet);
	}
}
