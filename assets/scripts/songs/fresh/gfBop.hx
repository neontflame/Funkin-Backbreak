function updatePost(elapsed) {
	switch (curBeat) {
		case 16:
			game.camZooming = true;
			game.gf.danceInterval = 2;
		case 48:
			game.gf.danceInterval = 1;
		case 80:
			game.gf.danceInterval = 2;
		case 112:
			game.gf.danceInterval = 1;
	}
}
