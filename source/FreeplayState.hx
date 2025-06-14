package;

#if discord_rpc
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

import openfl.utils.Assets as OpenFlAssets;
#if sys
import sys.io.File;
#end

class FreeplayState extends MusicBeatState {
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;

	static var curSelected:Int = 0;
	static var curDifficulty:Int = 1;

	var bg:FlxSprite;
	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Float = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	
	private var coolColors:Array<Int> = [];

	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	override function create() {
		var path = 'assets/data/weeks';
		
		if (!CoolUtil.fileExists(path)) return;
		
		var itemCount:Int = 0;
		var items:Array<String> = CoolUtil.readDir(path);
		for (item in items) {
			if (!item.endsWith('.xml')) return;
			var weekPath:String = '$path/$item';
			
			itemCount += 1;
			
			#if sys
			var weekXml:Xml = Xml.parse(
			File.getContent(weekPath)
			#else
			OpenFlAssets.getText(weekPath)
			#end
			);
			
			// week parser!
			var root:Xml = weekXml.firstElement();
			
			if (root.get("hideOnFreeplay") != "true") {
				if (StoryMenuState.weekUnlocked.get(root.get("name")) != null ? StoryMenuState.weekUnlocked[root.get("name")] : root.get("unlocked") == "true") {
					for (song in root.elementsNamed("Song")) {
						if (song.get("name") != null) {
							var color:String = '0x' + song.get("color");
							addSong(song.get("name"), root.get("name"), song.get("icon"));
							trace(color);
							trace(FlxColor.fromString(color));
							coolColors.push(FlxColor.fromString(color));
						}
					}
				}
			}
		}

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		#if dicord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence('In the Menus', null);
		#end

		if (!FlxG.sound.music.playing) {
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}
		// LOAD MUSIC

		// LOAD CHARACTERS

		bg = new FlxSprite().loadGraphic(Paths.image('ui/menus/menuDesat'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length) {
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, '', 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.antialiasing = false;
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, '', 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = '>';
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, 'swag');

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
		
		changeSelection();
		changeDiff();
	}

	public function addSong(songName:String, weekName:String, songCharacter:String) {
		songs.push(new SongMetadata(songName, weekName, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekName:String, ?songCharacters:Array<String>) {
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs) {
			addSong(song, weekName, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float):Void {
		super.update(elapsed);

		if (FlxG.sound.music != null && FlxG.sound.music.volume < 0.7) {
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = MathFunctions.fixedLerp(lerpScore, intendedScore, 0.4);
		if (coolColors.length > 0 && curSelected < coolColors.length)
			bg.color = FlxColor.interpolate(bg.color, coolColors[curSelected], MathFunctions.fixedLerpValue(0.045));

		scoreText.text = 'PERSONAL BEST:' + Math.round(lerpScore);
		positionHighscore();

		var left:Bool = controls.UI_LEFT_P;
		var right:Bool = controls.UI_RIGHT_P;
		var up:Bool = controls.UI_UP_P;
		var down:Bool = controls.UI_DOWN_P;
		var accept:Bool = controls.ACCEPT;
		var back:Bool = controls.BACK;

		if (up)
			changeSelection(-1);
		if (down)
			changeSelection(1);
		if (FlxG.mouse.wheel != 0)
			changeSelection(-Math.round(FlxG.mouse.wheel));

		if (left)
			changeDiff(-1);
		if (right)
			changeDiff(1);

		if (back) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}

		if (accept) {
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	function changeDiff(change:Int = 0):Void {
		curDifficulty = FlxMath.wrap(curDifficulty + change, 0, 2);
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);

		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '< ' + Highscore.difficultyString + ' >';
		positionHighscore();
	}

	function changeSelection(change:Int = 0):Void {
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		curSelected = FlxMath.wrap(curSelected + change, 0, songs.length - 1);
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);

		#if PRELOAD_ALL
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		for (i in 0...iconArray.length) {
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (i in 0...grpSongs.length) {
			var item:Alphabet = grpSongs.members[i];
			item.targetY = i - curSelected;

			if (item.targetY == 0)
				item.alpha = 1.0;
			else
				item.alpha = 0.6;
		}
	}

	function positionHighscore():Void {
		scoreText.x = FlxG.width - scoreText.width - 6;
		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - scoreBG.scale.x / 2;
		diffText.x = scoreBG.x + scoreBG.width / 2;
		diffText.x -= diffText.width / 2;
	}
}

class SongMetadata {
	public var songName:String = '';
	public var week:String = '';
	public var songCharacter:String = '';

	public function new(song:String, week:String, songCharacter:String) {
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
