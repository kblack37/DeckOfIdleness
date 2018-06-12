package idle.engine.events;

import common.engine.BaseEvent;

/**
 * ...
 * @author kristen autumn blackburn
 */
class UpgradeEvent extends BaseEvent {
	/**
	 * Dispatched when an upgrade of an entity is requested, via clicking on a card
	 * or upgrading other effects in the menu
	 * data: entityId
	 */
	public static inline var UPGRADE_REQUESTED : String = "upgrade_requested";
}