package idle.systems;

import common.engine.IGameEngine;
import common.engine.scripting.ScriptStatus;
import common.engine.systems.BaseSystem;
import idle.engine.GameEngine;
import idle.engine.card.Card;
import idle.engine.card.ICardLibrary;
import idle.engine.events.CardEvent;

/**
 * ...
 * @author kristen autumn blackburn
 */
class EmptyDeckDiscardPlaySystem extends BaseSystem {
	
	private var m_deck : ICardLibrary;
	private var m_hand : ICardLibrary;
	private var m_discard : ICardLibrary;

	public function new(gameEngine : IGameEngine, id : String = null, isActive : Bool = true) {
		super(gameEngine, id, isActive);
		
		var castedEngine : GameEngine = try cast(m_gameEngine, GameEngine) catch (e : Dynamic) null;
		m_deck = castedEngine.getCardLibrary("deck");
		m_hand = castedEngine.getCardLibrary("hand");
		m_discard = castedEngine.getCardLibrary("discard");
	}
	
	override public function visit() : ScriptStatus {
		var status : ScriptStatus = ScriptStatus.FAIL;
		
		if (m_deck.size() == 0 && m_discard.size() == 0) {
			var cardToPlay : Card = m_hand.removeCardFromTop();
			m_gameEngine.dispatchEvent(new CardEvent(CardEvent.CARD_PLAYED, cardToPlay));
			m_discard.addCardToTop(cardToPlay);
			
			status = ScriptStatus.SUCCESS;
		}
		
		return status;
	}
}