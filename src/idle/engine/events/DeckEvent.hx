package idle.engine.events;

import common.engine.BaseEvent;

/**
 * ...
 * @author kristen autumn blackburn
 */
class DeckEvent extends BaseEvent {
	/**
	 * Dispatched when a card draw is attempted and the deck is empty
	 */
	public static inline var DECK_EMPTY : String = "deck_empty";
	
	/**
	 * Dispatched when the discard pile is reshuffled into the deck
	 */
	public static inline var DECK_REFILLED : String = "deck_refilled";
}