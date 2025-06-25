package backend;

class EventTimeline {
	// because i dont wanna have to add an event thing to the chart editor so this will have to do!
	public var eventsBeat:Map<Int, Dynamic> = new Map();
	public var eventsStep:Map<Int, Dynamic> = new Map();

	public function new() {}

	public function queueBeat(beat:Int, ?callback:Dynamic) {
		eventsBeat.set(beat, callback);
	}
	
	public function queueStep(step:Int, ?callback:Dynamic) {
		eventsStep.set(step, callback);
	}

	public function stepHit(step:Int) {
		var toRemove = [];
		for (event in eventsStep.keys()) {
			if (step >= event) {
				var callback = eventsStep.get(event);
				if (callback != null) callback();
				eventsStep.remove(event);
			}
		}
	}

	public function beatHit(beat:Int) {
		var toRemove = [];
		for (event in eventsBeat.keys()) {
			if (beat >= event) {
				var callback = eventsBeat.get(event);
				if (callback != null) callback();
				eventsBeat.remove(event);
			}
		}
	}
}
