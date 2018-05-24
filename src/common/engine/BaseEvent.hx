package common.engine;

import openfl.events.Event;

/**
 * Wrapper class for events
 * 
 * @author kristen autumn blackburn
 */
class BaseEvent extends Event {
	
	public var data;

	public function new(type : String, data : Dynamic = null) {
		super(type, false, false);
		
		this.data = data;
	}
	
}