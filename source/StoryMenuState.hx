package;

#if discord_rpc
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

import openfl.utils.Assets;
#if sys
import sys.io.File;
#end

class StoryMenuState extends MusicBeatState {
	var scoreText:FlxText;
	
	var weekImgs:Array<String> = [];

	var weekData:Array<Dynamic> = [];
	public static var weekUnlocked:Map<String, Bool> = [];
	var weekCharacters:Array<Dynamic> = [];
	var weekNames:Array<String> = [];
	
	var curDifficulty:Int = 1;

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	override function create() {
		var path = 'assets/data/weeks';
		
		if (!CoolUtil.fileExists(path)) return;
		
		var items:Array<String> = CoolUtil.readDir(path);
		for (item in items) {
			if (!item.endsWith('.xml')) return;
			var weekPath:String = '$path/$item';
			
			#if sys
			var weekXml:Xml = Xml.parse(
			File.getContent(weekPath)
			#else
			Assets.getText(weekPath)
			#end
			);
			
			// week parser!
			var root:Xml = weekXml.firstElement();
			var storyIter = root.elementsNamed("StoryInfo");
			if (storyIter.hasNext()) {
				if (root.get("hideOnStory") != "true") {
					var unlock:String = root.get("unlocked");
					
					if (weekUnlocked.get(root.get("name")) == null) {
						if (unlock != null && unlock == "false") weekUnlocked.set(root.get("name"), false);
						else weekUnlocked.set(root.get("name"), true);
					}
					
					var name:String = root.get("name");
					if (name != null) weekNames.push(name);
					
					var storyInfo = storyIter.next();
					var opponent:String = storyInfo.get("opponent");
					var player:String = storyInfo.get("player");
					var girlfriend:String = storyInfo.get("girlfriend");
					weekCharacters.push([opponent, player, girlfriend]);
					weekImgs.push(storyInfo.get("weekImg"));
					
					// Songs
					var songs:Array<String> = [];
					for (song in root.elementsNamed("Song")) {
						var songName:String = song.get("name");
						if (songName != null) songs.push(songName);
					}
					weekData.push(songs);
				}
			}
		}
		
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null) {
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, 'SCORE: 49324858', 36);
		scoreText.setFormat('VCR OSD Mono', 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, '', 32);
		txtWeekTitle.setFormat('VCR OSD Mono', 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font('vcr.ttf'), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('ui/menus/storyMenu/campaign_menu_UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		trace('Line 70');

		#if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence('In the Menus', null);
		#end
		
		for (i in 0...weekImgs.length) {
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, weekImgs[i]);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);

			// Needs an offset thingie
			if (!weekUnlocked[weekNames[i]]) {
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				grpLocks.add(lock);
			}
		}

		trace('Line 96');

		for (char in 0...3) {
			var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, weekCharacters[curWeek][char]);
			weekCharacterThing.y += 70;
			switch (weekCharacterThing.character) {
				case 'bf':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.9));
					weekCharacterThing.updateHitbox();
					weekCharacterThing.x -= 80;
				case 'dad':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.5));
					weekCharacterThing.updateHitbox();
				case 'gf':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.5));
					weekCharacterThing.updateHitbox();
				case 'parents-christmas':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.9));
					weekCharacterThing.updateHitbox();
				case 'pico':
					weekCharacterThing.flipX = true;
			}

			grpWeekCharacters.add(weekCharacterThing);
		}

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		trace('Line 124');

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', 'arrow left');
		leftArrow.animation.addByPrefix('press', 'arrow push left');
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.play('easy');
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', 'arrow push right', 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		trace('Line 150');

		add(yellowBG);
		add(grpWeekCharacters);

		txtTracklist = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 100, 0, 'Tracks', 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);

		updateText();

		trace('Line 165');

		super.create();
	}

	override function update(elapsed:Float) {
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = MathFunctions.fixedLerp(lerpScore, intendedScore, 0.5);

		scoreText.text = 'WEEK SCORE:' + Math.round(lerpScore);

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[weekNames[curWeek]];

		grpLocks.forEach(function(lock:FlxSprite) {
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack) {
			if (!selectedWeek) {
				if (controls.UI_UP_P) {
					changeWeek(-1);
				}

				if (controls.UI_DOWN_P) {
					changeWeek(1);
				}

				if (controls.UI_RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.UI_LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.UI_RIGHT_P)
					changeDifficulty(1);
				if (controls.UI_LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT) {
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek() {
		if (weekUnlocked[weekNames[curWeek]]) {
			if (stopspamming == false) {
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				grpWeekCharacters.members[1].animation.play('bfConfirm');
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = '';

			switch (curDifficulty) {
				case 0:
					diffic = '-easy';
				case 2:
					diffic = '-hard';
			}

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = weekNames[curWeek];
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer) {
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		}
	}

	function changeDifficulty(change:Int = 0):Void {
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		sprDifficulty.offset.x = 0;

		switch (curDifficulty) {
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = 20;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
		}

		sprDifficulty.alpha = 0;
		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;

		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Float = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void {
		curWeek += change;

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members) {
			item.targetY = bullShit - curWeek;
			if (item.targetY == 0 && weekUnlocked[weekNames[curWeek]])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
	}

	function updateText() {
		grpWeekCharacters.members[0].animation.play(weekCharacters[curWeek][0]);
		grpWeekCharacters.members[1].animation.play(weekCharacters[curWeek][1]);
		grpWeekCharacters.members[2].animation.play(weekCharacters[curWeek][2]);
		txtTracklist.text = 'Tracks\n';

		switch (grpWeekCharacters.members[0].animation.curAnim.name) {
			case 'dad':
				grpWeekCharacters.members[0].offset.set(120, 200);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));

			case 'mom':
				grpWeekCharacters.members[0].offset.set(100, 200);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));

			case 'parents-christmas':
				grpWeekCharacters.members[0].offset.set(200, 200);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 0.99));

			case 'senpai':
				grpWeekCharacters.members[0].offset.set(130, 0);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1.4));

			case 'tankman':
				grpWeekCharacters.members[0].offset.set(60, -20);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));

			default:
				grpWeekCharacters.members[0].offset.set(100, 100);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));
				// grpWeekCharacters.members[0].updateHitbox();
		}

		var stringThing:Array<String> = weekData[curWeek];

		for (i in stringThing) {
			txtTracklist.text += '\n' + i;
		}

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}
}
