import modchart.Config;

function startCountdown() {
	trace(game.modManager.playfields);
	game.modManager.addModifier('beat');
	// game.modManager.setPercent('beat', 2);
	/* schmovinMgr.set(8, 1, 'beat');

	schmovinMgr.ease(40, 1, FlxEase.cubeOut, 1.25, 'tipsy');
	schmovinMgr.ease(40, 1, FlxEase.cubeOut, 0, 'beat');

	schmovinMgr.ease(72, 1, FlxEase.cubeOut, 1, 'tipsy');
	schmovinMgr.ease(72, 1, FlxEase.cubeOut, 1.25, 'beat'); */
}