package idle.systems;

import common.engine.IGameEngine;
import common.engine.scripting.ScriptStatus;
import common.engine.systems.BaseSystem;
import idle.engine.GameEngine;
import idle.engine.card.Card;
import idle.engine.card.ICardLibrary;
import idle.engine.events.CardEvent;
import idle.engine.events.DeckEvent;

/**
 * ...
 * @author kristen autumn blackburn
 */
class CardDrawSystem extends BaseSystem {

	private var m_deck : ICardLibrary;
	private var m_hand : ICardLibrary;
	
	public function new(gameEngine : IGameEngine, id : String = null, isActive : Bool = true) {
		super(gameEngine, id, isActive);
		
		var castedEngine : GameEngine = try cast(gameEngine, GameEngine) catch (e : Dynamic) null;
		m_deck = castedEngine.getCardLibrary("deck");
		m_hand = castedEngine.getCardLibrary("hand");
	}
	
	override public function visit() : ScriptStatus {
		var status : ScriptStatus = ScriptStatus.SUCCESS;
		
		if (m_deck.size() > 0) {
			drawCard();
		} else {
			m_gameEngine.dispatchEvent(new DeckEvent(DeckEvent.DECK_EMPTY));
			m_gameEngine.addEventListener(DeckEvent.DECK_REFILLED, onDeckRefilled);
			status = ScriptStatus.FAIL;
		}
		
		return status;
	}
	
	private function onDeckRefilled(e : Dynamic) {
		drawCard();
		m_gameEngine.removeEventListener(DeckEvent.DECK_REFILLED, onDeckRefilled);
	}
	
	private function drawCard() {
		var drawnCard : Card = m_deck.removeCardFromTop();
		m_hand.addCardToBottom(drawnCard);
		m_gameEngine.dispatchEvent(new CardEvent(CardEvent.CARD_DRAWN, drawnCard));
	}
}