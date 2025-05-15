package;

#if discord_rpc
import Discord.DiscordClient;
#end
#if USE_SHADERS
import shaders.BuildingShaders;
import shaders.ColorSwap;
#end
import animate.FlxAnimate;
import ui.PreferencesMenu;
import backend.Section.SwagSection;
import backend.Song.SwagSong;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import openfl.utils.Assets;

import crowplexus.iris.Iris;
import backend.IrisHandler;
import bg.*;

#if html5
import video.FlxVideo;
#end
#if cpp
import video.FunkinVideoSprite;
#end

class PlayState extends MusicBeatState {
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var deathCounter:Int = 0;
	public static var practiceMode:Bool = false;
	public static var seenCutscene:Bool = false;

	var halloweenLevel:Bool = false;

	private var vocals:FlxSound;
	private var vocalsFinished = false;

	public var dad:Character;
	public var gf:Character;
	public var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;
	private var camPos:FlxPoint;

	private static var prevCamFollow:FlxObject;

	public var strumLineNotes:FlxTypedGroup<FlxSprite>;
	public var playerStrums:FlxTypedGroup<FlxSprite>;

	private var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	private var camZooming:Bool = false;
	private var curSong:String = '';

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
	private var misses:Int = 0;
	
	private var accuracy:Float = 0;
	private var notesHit:Float = 0;
	private var notesTotal:Float = 0;
	
	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var gfCutsceneLayer:FlxTypedGroup<FlxAnimate>;
	var bfTankCutsceneLayer:FlxTypedGroup<FlxAnimate>;

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;

	public static var campaignScore:Int = 0;

	public static var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	public static var inCutscene:Bool = false;

	// Discord RPC variables
	var storyDifficultyText:String = '';
	var iconRPC:String = '';
	var songLength:Float = 0;
	var detailsText:String = '';
	var detailsPausedText:String = '';

	private var stageBuild:Stage;
	
	// lifted from Funkin-Multikey you get the gist by now
	var script:IrisHandler;

	override public function create() {
		instance = this;

		// lifted from Funkin-Multikey
		script = new IrisHandler();
		var file:String = Paths.script('songs/' + PlayState.SONG.song.toLowerCase());
		trace(file);

		if (CoolUtil.fileExists(file))
		{
			trace("ADDING SCRIPT: " + file);
			script.addByPath(file);
			script.setup();
		}
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		var instPath = Paths.inst(SONG.song.toLowerCase());
		if (Assets.exists(instPath, SOUND) || Assets.exists(instPath, MUSIC))
			Assets.getSound(instPath, true);
		var vocalsPath = Paths.voices(SONG.song.toLowerCase());
		if (Assets.exists(vocalsPath, SOUND) || Assets.exists(vocalsPath, MUSIC))
			Assets.getSound(vocalsPath, true);

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);

		grpNoteSplashes = new FlxTypedGroup<NoteSplash>(4);
		var splash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(splash);
		splash.alpha = 0.1;

		persistentUpdate = persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		// taken from forever engine
		// set up a class for the stage type in here afterwards
		curStage = "";
		// call the song's stage if it exists
		if (SONG.stage != null)
			curStage = SONG.stage;

		stageBuild = new Stage(curStage);
		add(stageBuild);
		script.set('stage', stageBuild);
		
		if (CoolUtil.fileExists(Paths.txt('dialogue/${SONG.song.toLowerCase()}'))) {
			dialogue = Paths.getTextFileArray(Paths.txt('dialogue/${SONG.song.toLowerCase()}'));
		}

		#if discord_rpc
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty) {
			case 0:
				storyDifficultyText = 'Easy';
			case 1:
				storyDifficultyText = 'Normal';
			case 2:
				storyDifficultyText = 'Hard';
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC) {
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode) {
			detailsText = 'Story Mode: Week ' + storyWeek;
		} else {
			detailsText = 'Freeplay';
		}

		// String for when the game is paused
		detailsPausedText = 'Paused - ' + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + ' (' + storyDifficultyText + ')', iconRPC);
		#end

		// defines the girl
		gf = new Character(400, 130, 'gf');

		dad = new Character(100, 100, SONG.player2);
		camPos = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);
		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// set the dad's position (check the stage class to edit that!)
		// reminder that this probably isn't the best way to do this but hey it works I guess and is cleaner
		// todo: make this go on character scripts
		stageBuild.dadPosition(curStage, dad, gf, camPos, SONG.player2);

		stageBuild.createStageBack();
		
		gf = new Character(400, 130, stageBuild.returnGFtype(curStage));
		gf.scrollFactor.set(0.95, 0.95);
		
		if (stageBuild.returnGFtype(curStage) == 'pico-speaker') {
			var tankmen:TankmenBG = new TankmenBG(20, 500, true);
			tankmen.strumTime = 10;
			tankmen.resetShit(20, 600, true);
			stageBuild.tankmanRun.add(tankmen);

			for (i in 0...TankmenBG.animationNotes.length) {
				if (!FlxG.random.bool(16))
					continue;

				var man:TankmenBG = stageBuild.tankmanRun.recycle(TankmenBG);
				man.strumTime = TankmenBG.animationNotes[i][0];
				man.resetShit(500, 200 + FlxG.random.int(50, 100), TankmenBG.animationNotes[i][1] < 2);
				stageBuild.tankmanRun.add(man);
			}
		}

		add(gf);

		gfCutsceneLayer = new FlxTypedGroup<FlxAnimate>();
		add(gfCutsceneLayer);
		bfTankCutsceneLayer = new FlxTypedGroup<FlxAnimate>();
		add(bfTankCutsceneLayer);
		
		stageBuild.createStageMiddle();
		
		add(dad);
		add(boyfriend);

		stageBuild.createStageFront();

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, PreferencesMenu.getPref('downscroll') ? FlxG.height - 150 : 50).makeGraphic(FlxG.width, 10);
		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		add(grpNoteSplashes);

		playerStrums = new FlxTypedGroup<FlxSprite>();

		generateSong();


		camFollow = new FlxObject(camPos.x, camPos.y, 1, 1);

		if (prevCamFollow != null) {
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('ui/healthBar'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		if (PreferencesMenu.getPref('downscroll'))
			healthBarBG.y = FlxG.height * 0.1;

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width - 190, healthBarBG.y + 40, 0, '', 20);
		scoreTxt.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		
		// add everything!!!
		add(healthBarBG);
		add(healthBar);
		
		add(iconP1);
		add(iconP2);
		
		add(scoreTxt);
		updateScoreText();
		
		grpNoteSplashes.cameras = [camHUD];
		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode && !seenCutscene) {
			seenCutscene = true;
			if (CoolUtil.fileExists(Paths.script("cutscenes/" + SONG.song.toLowerCase()))) {
				trace(Paths.script("cutscenes/" + SONG.song.toLowerCase()) + ' EXISTS!');
				script.addByPath(Paths.script("cutscenes/" + SONG.song.toLowerCase()));
				allScriptCall("cutscene");
			} else {
				trace(Paths.script("cutscenes/" + SONG.song.toLowerCase()) + ' DOES NOT EXIST!');
				startCountdown();
			}
		} else {
			startCountdown();
		}

		allScriptCall("createPost");

		super.create();
	}
	
	function allScriptCall(func:String, ?args:Array<Dynamic>) {
		script.call(func, args);
	}
	
	function playVideoCutscene(path) {
		inCutscene = true;
		var black:FlxSprite = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);
		
		#if html5
		new FlxVideo(path).finishCallback = function() {
			remove(black);
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, (Conductor.stepCrochet / 1000) * 5, {ease: FlxEase.quadInOut});
			startCountdown();
			cameraMovement();
		};
		#end
		
		#if cpp
		var video:FunkinVideoSprite = new FunkinVideoSprite(0, 0);
		video.cameras = [camHUD];
		video.antialiasing = true;
		// Resize videos bigger or smaller than the screen.
		video.bitmap.onFormatSetup.add(function():Void {
			if (video == null) return;
			video.setGraphicSize(FlxG.width, FlxG.height);
			video.updateHitbox();
			video.x = 0;
			video.y = 0;
			// video.scale.set(0.5, 0.5);
		});
		video.bitmap.onEndReached.add(function() {
			video.destroy();
			remove(black);
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, (Conductor.stepCrochet / 1000) * 5, {ease: FlxEase.quadInOut});
			startCountdown();
			cameraMovement();
		});
		
		add(video);

		if (video.load(path)) {
			FlxTimer.wait(0.001, () -> video.play());
		} else {
			video.destroy();
			remove(black);
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, (Conductor.stepCrochet / 1000) * 5, {ease: FlxEase.quadInOut});
			startCountdown();
			cameraMovement();
		}
		#end
	}
	
	function initDiscord() {
		// Angel here.
		// I have no idea what this function does.
		// The function is still in the compiled code, but everything inside was ommited since it was compiled for the HTML target.
		// Just leaving this here in case I ever figure out what it was used for.
		// If I never find a use for this, sorry, but this is just staying here cause it's a part of v0.2.8's code lol.
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void {
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * daPixelZoom));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();
		senpaiEvil.x += senpaiEvil.width / 5;

		camFollow.setPosition(camPos.x, camPos.y);

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns') {
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns') {
				add(red);
				camHUD.visible = false;
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer) {
			black.alpha -= 0.15;

			if (black.alpha > 0) {
				tmr.reset(0.3);
			} else {
				if (dialogueBox != null) {
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns') {
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer) {
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1) {
								swagTimer.reset();
							} else {
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function() {
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function() {
										add(dialogueBox);
										camHUD.visible = true;
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer) {
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					} else {
						add(dialogueBox);
					}
				} else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer = new FlxTimer();

	function startCountdown():Void {
		//Paths.clearUnusedMemory();
		allScriptCall("startCountdown");
		
		inCutscene = false;

		camHUD.visible = true;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer.start(Conductor.crochet / 1000, function(tmr:FlxTimer) {
			if (swagCounter % gfSpeed == 0) {
				gf.dance();
			}
			if (swagCounter % 2 == 0) {
				if (!boyfriend.animation.curAnim.name.startsWith('sing'))
					boyfriend.playAnim('idle');
				if (!dad.animation.curAnim.name.startsWith('sing'))
					dad.dance();
			} else if (dad.curCharacter == 'spooky' && !dad.animation.curAnim.name.startsWith('sing'))
				dad.dance();

			if (generatedMusic) {
				notes.members.sort(function(Obj1:Note, Obj2:Note) {
					return sortNotes(FlxSort.DESCENDING, Obj1, Obj2);
				});
			}
			
			var uiCountdownLocation:String = 'ui/countdown/';
			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', [uiCountdownLocation + 'ready', uiCountdownLocation + 'set', uiCountdownLocation + 'go']);
			introAssets.set('school', [uiCountdownLocation + 'pixelUI/ready-pixel', uiCountdownLocation + 'pixelUI/set-pixel', uiCountdownLocation + 'pixelUI/date-pixel']);
			introAssets.set('schoolEvil', [uiCountdownLocation + 'pixelUI/ready-pixel', uiCountdownLocation + 'pixelUI/set-pixel', uiCountdownLocation + 'pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = '';

			for (value in introAssets.keys()) {
				if (value == curStage) {
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter) {
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
					allScriptCall("countdownCount", [3]);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween) {
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
					allScriptCall("countdownCount", [2]);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween) {
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
					allScriptCall("countdownCount", [1]);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween) {
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
					allScriptCall("countdownCount", [0]);
				case 4:
					allScriptCall("countdownCount", [-1]);
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 4);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void {
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		#if discord_rpc
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + ' (' + storyDifficultyText + ')', iconRPC, true, songLength);
		#end
		allScriptCall("startSong");
	}

	var debugNum:Int = 0;

	private function generateSong():Void {
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		vocals.onComplete = function() {
			vocalsFinished = true;
		};
		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData) {
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes) {
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3) {
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.altNote = songNotes[3];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength /= Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength)) {
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress) {
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress) {
					swagNote.x += FlxG.width / 2; // general offset
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int {
		return sortNotes(FlxSort.ASCENDING, Obj1, Obj2);
	}

	function sortNotes(Sort:Int = FlxSort.ASCENDING, Obj1:Note, Obj2:Note):Int {
		return Obj1.strumTime < Obj2.strumTime ? Sort : Obj1.strumTime > Obj2.strumTime ? -Sort : 0;
	}

	private function generateStaticArrows(player:Int):Void {
		for (i in 0...4) {
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);
			#if USE_SHADERS
			var colorSwap:ColorSwap = new ColorSwap();

			babyArrow.shader = colorSwap.shader;
			colorSwap.update(Note.arrowColors[i]);
			#end

			switch (curStage) {
				case 'school' | 'schoolEvil':
					babyArrow.loadGraphic(Paths.image('ui/noteShit/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i)) {
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('ui/noteShit/NOTE_strums');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i)) {
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 1');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 2');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 4');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 3');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode) {
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			if (player == 1) {
				playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50 + ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
			
		}
	}

	function tweenCamIn():Void {
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState) {
		if (paused) {
			if (FlxG.sound.music != null) {
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState() {
		if (paused) {
			if (FlxG.sound.music != null && !startingSong) {
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if discord_rpc
			if (startTimer.finished) {
				DiscordClient.changePresence(detailsText, SONG.song + ' (' + storyDifficultyText + ')', iconRPC, true, songLength - Conductor.songPosition);
			} else {
				DiscordClient.changePresence(detailsText, SONG.song + ' (' + storyDifficultyText + ')', iconRPC);
			}
			#end
		}
		//Paths.clearUnusedMemory();
		super.closeSubState();
	}

	#if discord_rpc
	override public function onFocus():Void {
		if (health > 0 && !paused) {
			if (Conductor.songPosition > 0.0) {
				DiscordClient.changePresence(detailsText, SONG.song + ' (' + storyDifficultyText + ')', iconRPC, true, songLength - Conductor.songPosition);
			} else {
				DiscordClient.changePresence(detailsText, SONG.song + ' (' + storyDifficultyText + ')', iconRPC);
			}
		}

		super.onFocus();
	}

	override public function onFocusLost():Void {
		if (health > 0 && !paused) {
			DiscordClient.changePresence(detailsPausedText, SONG.song + ' (' + storyDifficultyText + ')', iconRPC);
		}

		super.onFocusLost();
	}
	#end

	function resyncVocals():Void {
		if (!_exiting) {
			vocals.pause();

			FlxG.sound.music.play();
			Conductor.songPosition = FlxG.sound.music.time + Conductor.offset;
			if (!vocalsFinished) {
				vocals.time = Conductor.songPosition;
				vocals.play();
			}
		}
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var cameraRightSide:Bool = false;

	public static final iconOffset:Int = 26;

	override public function update(elapsed:Float) {
		if (FlxG.keys.justPressed.NINE) {
			iconP1.swapOldIcon();
		}

		if (startingSong) {
			if (startedCountdown) {
				Conductor.songPosition += FlxG.elapsed * 1000.0;
				if (Conductor.songPosition >= 0.0)
					startSong();
			}
		} else {
			#if USE_INST_TIME
			Conductor.songPosition = FlxG.sound.music.time + Conductor.offset;
			#else
			Conductor.songPosition += FlxG.elapsed * 1000.0;
			#end
		}

		stageBuild.stageUpdateConstant(elapsed, boyfriend, gf, dad);
		allScriptCall("update", [elapsed]);

		super.update(elapsed);
		
		allScriptCall("updatePost", [elapsed]);
		
		updateScoreText();

		if (controls.PAUSE && startedCountdown && canPause) {
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1)) {
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			} else {
				var screenPos:FlxPoint = boyfriend.getScreenPosition();
				var pauseMenu:PauseSubState = new PauseSubState(screenPos.x, screenPos.y);
				openSubState(pauseMenu);
				pauseMenu.camera = camHUD;
			}

			#if discord_rpc
			DiscordClient.changePresence(detailsPausedText, SONG.song + ' (' + storyDifficultyText + ')', iconRPC);
			#end
		}

		if (FlxG.keys.justPressed.SEVEN) {
			if (FlxG.keys.pressed.SHIFT) {
				FlxG.switchState(new KadeChartingState());
			} else {
				FlxG.switchState(new ChartingState());
			}

			#if discord_rpc
			DiscordClient.changePresence('Chart Editor', null, null, true);
			#end
		}

		iconP1.scale.set(MathFunctions.fixedLerp(iconP1.scale.x, 1, 0.15), MathFunctions.fixedLerp(iconP1.scale.y, 1, 0.15));
		iconP2.scale.set(MathFunctions.fixedLerp(iconP2.scale.x, 1, 0.15), MathFunctions.fixedLerp(iconP2.scale.y, 1, 0.15));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		health = FlxMath.bound(health, 0, 2);

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2));
		#end

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null) {
			cameraRightSide = PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection;
			cameraMovement();
		}

		if (camZooming) {
			FlxG.camera.zoom = MathFunctions.fixedLerp(FlxG.camera.zoom, defaultCamZoom, 0.05);
			camHUD.zoom = MathFunctions.fixedLerp(camHUD.zoom, 1, 0.05);
		}

		FlxG.watch.addQuick('beatShit', curBeat);
		FlxG.watch.addQuick('stepShit', curStep);

		if (curSong.toLowerCase() == 'fresh') {
			switch (curBeat) {
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
			}
		}

		if (curSong.toLowerCase() == 'bopeebo') {
			switch (curBeat) {
				case 128, 129, 130:
					vocals.volume = 0;
			}
		}
		// better streaming of shit

		if (!inCutscene && !_exiting) {
			// RESET = Quick Game Over Screen
			if (controls.RESET) {
				health = 0;
				trace('RESET = True');
			}

			// CHEAT = brandon's a pussy
			// if (controls.CHEAT)
			// {
			// 	health += 1;
			// 	trace('User is cheating!');
			// }

			if (health <= 0 && !practiceMode) {
				boyfriend.stunned = true;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;

				vocals.stop();
				FlxG.sound.music.stop();

				deathCounter += 1;

				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

				#if discord_rpc
				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence('Game Over - ' + detailsText, SONG.song + ' (' + storyDifficultyText + ')', iconRPC);
				#end
			}
		}

		while (unspawnNotes[0] != null) {
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1800 / SONG.speed) {
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.shift();
			} else {
				break;
			}
		}

		if (generatedMusic) {
			notes.forEachAlive(function(daNote:Note) {
				if (daNote.y > FlxG.height) {
					daNote.active = false;
					daNote.visible = false;
				} else {
					daNote.visible = true;
					daNote.active = true;
				}

				var center = strumLine.y + (Note.swagWidth / 2);

				// i am so fucking sorry for these if conditions
				if (PreferencesMenu.getPref('downscroll')) {
					daNote.y = strumLine.y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2);

					if (daNote.isSustainNote) {
						daNote.alpha -= 0.4;
						if (daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
							daNote.y += daNote.prevNote.height;
						else
							daNote.y += daNote.height / 2;

						if (daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center
							&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit)))) {
							var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
							swagRect.height = (center - daNote.y) / daNote.scale.y;
							swagRect.y = daNote.frameHeight - swagRect.height;

							daNote.clipRect = swagRect;
						}
					}
				} else {
					daNote.y = strumLine.y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2);

					if (daNote.isSustainNote
						&& daNote.y + daNote.offset.y * daNote.scale.y <= center
						&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit)))) {
						var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
						swagRect.y = (center - daNote.y) / daNote.scale.y;
						swagRect.height -= swagRect.y;

						daNote.clipRect = swagRect;
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit) {
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = '';

					if (SONG.notes[Math.floor(curStep / 16)] != null) {
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}
					if (daNote.altNote)
						altAnim = '-alt';

					switch (Math.abs(daNote.noteData)) {
						case 0:
							dad.playAnim('singLEFT' + altAnim, true);
						case 1:
							dad.playAnim('singDOWN' + altAnim, true);
						case 2:
							dad.playAnim('singUP' + altAnim, true);
						case 3:
							dad.playAnim('singRIGHT' + altAnim, true);
					}

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				var doKill = daNote.y < -daNote.height;
				if (PreferencesMenu.getPref('downscroll'))
					doKill = daNote.y > FlxG.height;

				if (doKill) {
					if (daNote.tooLate || !daNote.wasGoodHit) {
						health -= 0.0475;
						if (!daNote.isSustainNote) {
							misses++;
							notesTotal += 1;
						}
						vocals.volume = 0;
						noteMiss(Math.round(daNote.noteData));
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	public var exoticEnding:Bool = false;
	
	function endSong():Void {
		allScriptCall("endSong");
		seenCutscene = false;
		deathCounter = 0;
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;

		if (SONG.validScore)
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);

		if (isStoryMode) {
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0) {
				FlxG.sound.playMusic(Paths.music('freakyMenu'));

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				if (storyWeek == 7)
					FlxG.switchState(new VideoState());
				else
					FlxG.switchState(new StoryMenuState());

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore) {
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			} else {
				var difficulty:String = '';

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				trace('LOADING NEXT SONG');
				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;

				FlxG.sound.music.stop();
				vocals.stop();
				
				allScriptCall("endSongPost", [difficulty]);
				if (exoticEnding) {
					// do whatever
				} else {
					prevCamFollow = camFollow;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);

					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
		} else {
			trace('WENT BACK TO FREEPLAY??');
			FlxG.switchState(new FreeplayState());
		}
	}

	var endingSong:Bool = false;

	private function popUpScore(strumtime:Float, daNote:Note):Void {
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;
		var accAdder:Float = 1;

		var daRating:String = 'sick';
		var doSplash:Bool = true;

		if (noteDiff > Conductor.shitMaxWindow) {
			daRating = 'shit';
			score = 50;
			accAdder = 0.25;
			doSplash = false;
		} else if (noteDiff > Conductor.badMaxWindow) {
			daRating = 'bad';
			score = 100;
			accAdder = 0.5;
			doSplash = false;
		} else if (noteDiff > Conductor.goodMaxWindow) {
			daRating = 'good';
			score = 200;
			accAdder = 0.75;
			doSplash = false;
		}
		
		notesHit += accAdder;
		notesTotal += 1;

		if (doSplash) {
			var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
			splash.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
			grpNoteSplashes.add(splash);
		}

		if (!practiceMode)
			songScore += score;

		var pixelShitPart1:String = '';
		var pixelShitPart2:String = '';

		if (curStage.startsWith('school')) {
			pixelShitPart1 = 'pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Paths.image('ui/ratingShit/' + pixelShitPart1 + 'ratings/' + daRating + pixelShitPart2));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/ratingShit/' + pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		insert(members.indexOf(boyfriend), rating);

		if (!curStage.startsWith('school')) {
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
		} else {
			rating.antialiasing = false;
			comboSpr.antialiasing = false;
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore) {
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/ratingShit/' + pixelShitPart1 + 'numbers/num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			if (!curStage.startsWith('school')) {
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			} else {
				numScore.antialiasing = false;
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (combo >= 10 || combo == 0)
				insert(members.indexOf(rating), numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween) {
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});
			
			numScore.cameras = rating.cameras;
			daLoop++;
		}
		
		allScriptCall("popUpScore", [strumtime, daNote, rating]);
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween) {
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}

	private function cameraMovement():Void {
		if (camFollow.x != dad.getMidpoint().x + dad.camOffset.x && !cameraRightSide) {
			camFollow.setPosition(dad.getMidpoint().x + dad.camOffset.x, dad.getMidpoint().y + dad.camOffset.y);
			// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);
			
			/*
			we can softcode this !
			switch (dad.curCharacter) {
				case 'mom':
					camFollow.y = dad.getMidpoint().y;
				case 'senpai' | 'senpai-angry':
					camFollow.y = dad.getMidpoint().y - 430;
					camFollow.x = dad.getMidpoint().x - 100;
			}
			*/

			if (dad.curCharacter == 'mom')
				vocals.volume = 1;

			if (SONG.song.toLowerCase() == 'tutorial') {
				tweenCamIn();
			}
		}

		if (cameraRightSide && camFollow.x != boyfriend.getMidpoint().x - boyfriend.camOffset.x) {
			camFollow.setPosition(boyfriend.getMidpoint().x - boyfriend.camOffset.x, boyfriend.getMidpoint().y + boyfriend.camOffset.y);

			switch (curStage) {
				case 'limo':
					camFollow.x = boyfriend.getMidpoint().x - 300;
				case 'school':
					camFollow.x = boyfriend.getMidpoint().x - 200;
					camFollow.y = boyfriend.getMidpoint().y - 200;
				case 'schoolEvil':
					camFollow.x = boyfriend.getMidpoint().x - 200;
					camFollow.y = boyfriend.getMidpoint().y - 200;
			}

			if (SONG.song.toLowerCase() == 'tutorial') {
				FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
			}
		}
	}

	private function keyShit():Void {
		var holdingArray:Array<Bool> = [controls.NOTE_LEFT, controls.NOTE_DOWN, controls.NOTE_UP, controls.NOTE_RIGHT];
		var controlArray:Array<Bool> = [
			controls.NOTE_LEFT_P,
			controls.NOTE_DOWN_P,
			controls.NOTE_UP_P,
			controls.NOTE_RIGHT_P
		];
		var releaseArray:Array<Bool> = [
			controls.NOTE_LEFT_R,
			controls.NOTE_DOWN_R,
			controls.NOTE_UP_R,
			controls.NOTE_RIGHT_R
		];

		// FlxG.watch.addQuick('asdfa', upP);
		if (holdingArray.contains(true) && generatedMusic) {
			notes.forEachAlive(function(daNote:Note) {
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdingArray[daNote.noteData])
					goodNoteHit(daNote);
			});
		}
		if (controlArray.contains(true) && generatedMusic) {
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			var removeList:Array<Note> = [];

			notes.forEachAlive(function(daNote:Note) {
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit) {
					if (ignoreList.contains(daNote.noteData)) {
						for (possibleNote in possibleNotes) {
							if (possibleNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - possibleNote.strumTime) < 10) {
								removeList.push(daNote);
							} else if (possibleNote.noteData == daNote.noteData && daNote.strumTime < possibleNote.strumTime) {
								possibleNotes.remove(possibleNote);
								possibleNotes.push(daNote);
							}
						}
					} else {
						possibleNotes.push(daNote);
						ignoreList.push(daNote.noteData);
					}
				}
			});

			for (badNote in removeList) {
				badNote.kill();
				notes.remove(badNote, true);
				badNote.destroy();
			}

			possibleNotes.sort(function(note1:Note, note2:Note) {
				return Std.int(note1.strumTime - note2.strumTime);
			});

			if (possibleNotes.length > 0) {
				for (i in 0...controlArray.length) {
					if (controlArray[i] && !ignoreList.contains(i)) {
						badNoteHit();
					}
				}
				for (possibleNote in possibleNotes) {
					if (controlArray[possibleNote.noteData]) {
						goodNoteHit(possibleNote);
					}
				}
			} else
				badNoteHit();
		}
		if (boyfriend.holdTimer > 0.004 * Conductor.stepCrochet
			&& !holdingArray.contains(true)
			&& boyfriend.animation.curAnim.name.startsWith('sing')
			&& !boyfriend.animation.curAnim.name.endsWith('miss')) {
			boyfriend.playAnim('idle');
		}
		playerStrums.forEach(function(spr:FlxSprite) {
			if (controlArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
				spr.animation.play('pressed');
			if (!holdingArray[spr.ID])
				spr.animation.play('static');

			if (spr.animation.curAnim.name != 'confirm' || curStage.startsWith('school'))
				spr.centerOffsets();
			else {
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
		});
	}

	function noteMiss(direction:Int = 1):Void {
		allScriptCall('noteMiss', [direction]);
		if (!boyfriend.stunned) {
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad')) {
				gf.playAnim('sad');
			}
			combo = 0;

			if (!practiceMode)
				songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			boyfriend.stunned = true;

			// get stunned for 5 seconds
			new FlxTimer().start(5 / 60, function(tmr:FlxTimer) {
				boyfriend.stunned = false;
			});

			switch (direction) {
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}
		}
	}

	function badNoteHit() {
		if (!PreferencesMenu.getPref('ghost-tapping')) {
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var leftP = controls.NOTE_LEFT_P;
			var downP = controls.NOTE_DOWN_P;
			var upP = controls.NOTE_UP_P;
			var rightP = controls.NOTE_RIGHT_P;

			if (leftP)
				noteMiss(0);
			if (downP)
				noteMiss(1);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
		}
	}

	function goodNoteHit(note:Note):Void {
		allScriptCall('goodNoteHit', [note]);
		
		if (!note.wasGoodHit) {
			if (!note.isSustainNote) {
				popUpScore(note.strumTime, note);
				combo += 1;
			}

			if (note.noteData >= 0)
				health += 0.023;
			else
				health += 0.004;

			switch (note.noteData) {
				case 0:
					boyfriend.playAnim('singLEFT', true);
				case 1:
					boyfriend.playAnim('singDOWN', true);
				case 2:
					boyfriend.playAnim('singUP', true);
				case 3:
					boyfriend.playAnim('singRIGHT', true);
			}

			playerStrums.forEach(function(spr:FlxSprite) {
				if (Math.abs(note.noteData) == spr.ID) {
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			if (!note.isSustainNote) {
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	override function stepHit() {
		allScriptCall("stepHit");
		super.stepHit();
		if (Math.abs(FlxG.sound.music.time - (Conductor.songPosition - Conductor.offset)) > 20
			|| (SONG.needsVoices && Math.abs(vocals.time - (Conductor.songPosition - Conductor.offset)) > 20)) {
			resyncVocals();
		}

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2) {
			// dad.dance();
		}
	}


	override function beatHit() {
		super.beatHit();
		allScriptCall("beatHit");

		if (generatedMusic) {
			notes.members.sort(function(note1:Note, note2:Note) {
				return sortNotes(FlxSort.DESCENDING, note1, note2);
			});
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null) {
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM) {
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			// if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
			// 	dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);

		if (PreferencesMenu.getPref('camera-zoom')) {
			// HARDCODING FOR MILF ZOOMS!
			if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35) {
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}

			if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0) {
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0) {
			gf.dance();
		}

		if (curBeat % 2 == 0) {
			if (!boyfriend.animation.curAnim.name.startsWith('sing')) {
				boyfriend.playAnim('idle');
			}

			if (!dad.animation.curAnim.name.startsWith('sing')) {
				dad.dance();
			}
		} else if (dad.curCharacter == 'spooky') {
			if (!dad.animation.curAnim.name.startsWith('sing')) {
				dad.dance();
			}
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo') {
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48) {
			boyfriend.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}

		// stage stuffs
		stageBuild.stageUpdate(curBeat, boyfriend, gf, dad);
	}

	public function newDialogueBox(dialogue:Array<String>, ?finishFunction:Dynamic, ?camera:flixel.FlxCamera) {
		if (finishFunction == null)
			finishFunction = startCountdown;
		if (camera == null)
			camera = camHUD;

		var box:DialogueBox = new DialogueBox(dialogue);
		box.scrollFactor.set();
		box.finishThing = finishFunction;
		box.cameras = [camera];
		return box;
	}
	
	function updateScoreText() {
		allScriptCall("updateScoreText");
		var divider:String = ' | ';
		
		if (notesTotal > 0) {
			accuracy = (notesHit / notesTotal) * 100;
		}
		scoreTxt.text = 'Score:' + songScore +
						divider + 
						'Misses:' + misses +
						divider + 
						'Accuracy:' + FlxMath.roundDecimal(accuracy, 2) + '%';
		
		scoreTxt.screenCenter(X);
	}
}
