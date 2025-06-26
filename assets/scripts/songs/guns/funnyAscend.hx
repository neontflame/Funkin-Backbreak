var tankAscend = false;
var tankInitY = 0;

function createPost() {
	tankInitY = game.dad.y;
	
	timeline.queueBeat(224, 
	function(){
		tankAscend = true;
	}
	);

	timeline.queueBeat(288, 
	function(){
		tankAscend = false;
		game.dad.y = tankInitY;
	}
	);
}

function updatePost() {
	if (tankAscend)
		game.dad.y -= 3;
}
