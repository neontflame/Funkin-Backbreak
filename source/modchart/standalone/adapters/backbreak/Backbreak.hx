package modchart.standalone.adapters.backbreak;

import flixel.FlxCamera;
import flixel.FlxSprite;
import modchart.standalone.IAdapter;
import Note;
import NoteStrum;
import ui.PreferencesMenu;

class Backbreak implements IAdapter {
	private var __fCrochet:Float = 0;

	private var __receptorXs:Array<Array<Float>>;
	private var __receptorYs:Array<Array<Float>>;

	public function new() {}

	public function onModchartingInitialization() {
		__fCrochet = Conductor.crochet;

		__receptorXs = [];
		__receptorYs = [];

		@:privateAccess
		PlayState.instance.strumLineNotes.forEachAlive(strumNote -> {
			if (__receptorXs[strumNote.player] == null)
				__receptorXs[strumNote.player] = [];
			if (__receptorYs[strumNote.player] == null)
				__receptorYs[strumNote.player] = [];

			__receptorXs[strumNote.player][strumNote.ID] = strumNote.x;
			__receptorYs[strumNote.player][strumNote.ID] = getDownscroll() ? FlxG.height - strumNote.y - Manager.ARROW_SIZE : strumNote.y;
		});
	}

	public function isTapNote(sprite:FlxSprite) {
		return sprite is Note;
	}

	// Song related
	public function getSongPosition():Float {
		return Conductor.songPosition;
	}

	@:privateAccess public function getCurrentBeat():Float {
		return Conductor.songPosition / Conductor.crochet;
	}

	public function getStaticCrochet():Float {
		return __fCrochet;
	}

	public function getBeatFromStep(step:Float)
		return step * 4;

	public function arrowHit(arrow:FlxSprite) {
		if (arrow is Note)
			return cast(arrow, Note).wasGoodHit;
		return false;
	}

	public function isHoldEnd(arrow:FlxSprite) {
		if (arrow is Note) {
			final castedNote = cast(arrow, Note);
			return castedNote.isSustainEnd;
		}
		return false;
	}

	public function getLaneFromArrow(arrow:FlxSprite) {
		if (arrow is Note)
			return cast(arrow, Note).noteData;
		else if (arrow is NoteStrum) @:privateAccess
			return cast(arrow, NoteStrum).ID;

		return 0;
	}

	public function getPlayerFromArrow(arrow:FlxSprite) {
		if (arrow is Note)
			return cast(arrow, Note).mustPress ? 1 : 0;
		else if (arrow is NoteStrum) @:privateAccess
			return cast(arrow, NoteStrum).player;

		return 0;
	}

	public function getKeyCount(?player:Int = 0):Int {
		return 4;
	}

	public function getPlayerCount():Int {
		return 2;
	}

	public function getTimeFromArrow(arrow:FlxSprite) {
		if (arrow is Note)
			return cast(arrow, Note).strumTime;

		return 0;
	}

	public function getHoldSubdivisions():Int {
		return 4;
	}

	// psych adjust the strum pos at the begin of playstate
	public function getDownscroll():Bool {
		return PreferencesMenu.getPref('downscroll');
	}

	public function getDefaultReceptorX(lane:Int, player:Int):Float {
		return __receptorXs[player][lane];
	}

	public function getDefaultReceptorY(lane:Int, player:Int):Float {
		return __receptorYs[player][lane];
	}

	public function getArrowCamera():Array<FlxCamera>
		return [PlayState.instance.camHUD];

	public function getCurrentScrollSpeed():Float {
		return PlayState.SONG.speed;
	}

	// 0 receptors
	// 1 tap arrows
	// 2 hold arrows
	public function getArrowItems() {
		var pspr:Array<Array<Array<FlxSprite>>> = [[[], [], []], [[], [], []]];

		@:privateAccess
		PlayState.instance.strumLineNotes.forEachAlive(strumNote -> {
			if (pspr[strumNote.player] == null)
				pspr[strumNote.player] = [];

			pspr[strumNote.player][0].push(strumNote);
		});
		PlayState.instance.notes.forEachAlive(strumNote -> {
			final player = Adapter.instance.getPlayerFromArrow(strumNote);
			if (pspr[player] == null)
				pspr[player] = [];

			pspr[player][strumNote.isSustainNote ? 2 : 1].push(strumNote);
		});

		return pspr;
	}
	
	public function getHoldParentTime(arrow:FlxSprite) {
		final note:Note = cast arrow;
		return note.strumTime;
	}
}