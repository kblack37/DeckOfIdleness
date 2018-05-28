package idle.engine.events;

import common.engine.BaseEvent;

/**
 * ...
 * @author kristen autumn blackburn
 */
class ResourceEvent extends BaseEvent {
	/**
	 * Dispatched when a resource is added to
	 * data:
	 * {
	 * 	resource: the resource name
	 * 	amount: the amount to gain
	 * }
	 */
	public static inline var RESOURCE_GAINED : String = "resource_gained";
	
	/**
	 * Dispatched when a resource is subtracted from
	 * data:
	 * {
	 * 	resource: the resource name
	 * 	amount: the amount to lose
	 * }
	 */
	public static inline var RESOURCE_LOST : String = "resource_lost";
}