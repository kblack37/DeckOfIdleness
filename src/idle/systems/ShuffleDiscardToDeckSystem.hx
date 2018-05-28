package idle.systems;

import common.engine.IGameEngine;
import common.engine.systems.BaseSystem;
import idle.engine.GameEngine;
import idle.engine.card.Card;
import idle.engine.card.ICardLibrary;
import idle.engine.events.DeckEvent;

/**
 * ...
 * @author kristen autumn blackburn
 */
class ShuffleDiscardToDeckSystem extends BaseSystem {

	private var m_discard : ICardLibrary;
	private var m_deck : ICardLibrary;
	
	public function new(gameEngine : IGameEngine, id : String = null, isActive : Bool = true) {
		super(gameEngine, id, isActive);
		
		var castedEngine : GameEngine = try cast(m_gameEngine, GameEngine) catch (e : Dynamic) null;
		m_discard = castedEngine.getCardLibrary("discard");
		m_deck = castedEngine.getCardLibrary("deck");
		
		m_gameEngine.addEventListener(DeckEvent.DECK_EMPTY, onDeckEmpty);
	}
	
	override public function dispose() {
		m_gameEngine.removeEventListener(DeckEvent.DECK_EMPTY, onDeckEmpty);
	}
	
	private function onDeckEmpty(e : Dynamic) {
		trace("shuffling discard into deck");
		while (m_discard.size() > 0) {
			m_deck.addCardAtRandom(m_discard.removeCardAtRandom());
		}
		
		m_gameEngine.dispatchEvent(new DeckEvent(DeckEvent.DECK_REFILLED));
	}
}