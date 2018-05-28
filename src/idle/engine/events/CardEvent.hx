package idle.engine.events;

import common.engine.BaseEvent;

/**
 * ...
 * @author kristen autumn blackburn
 */
class CardEvent extends BaseEvent {
	/**
	 * Event that is dispatched when a card is drawn
	 * data: the card that was drawn
	 */
	public static inline var CARD_DRAWN = "card_drawn";
	
	/**
	 * Event that is dispatched when a card is played
	 * data: the card that was played
	 */
	public static inline var CARD_PLAYED = "card_played";
}