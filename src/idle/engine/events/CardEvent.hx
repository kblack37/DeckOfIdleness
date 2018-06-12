package idle.engine.events;

import common.engine.BaseEvent;

/**
 * ...
 * @author kristen autumn blackburn
 */
class CardEvent extends BaseEvent {
	/**
	 * Event that is dispatched when a unique card is created for the first time
	 * data: entityId
	 */
	public static inline var CARD_CREATED : String = "card_created";
	/**
	 * Event that is dispatched when a card is drawn
	 * data: entityId
	 */
	public static inline var CARD_DRAWN : String = "card_drawn";
	
	/**
	 * Event that is dispatched when a card is played
	 * data: entityId
	 */
	public static inline var CARD_PLAYED : String = "card_played";
	
	/**
	 * Event that is dispatched when a card is upgraded
	 * data: entityId
	 */
	public static inline var CARD_UPGRADED : String = "card_upgraded";
}