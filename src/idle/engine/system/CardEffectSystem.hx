package idle.engine.system;

import common.engine.IGameEngine;
import common.engine.scripting.ScriptStatus;
import common.engine.systems.BaseSystem;
import idle.engine.card.Card;
import idle.engine.events.CardEvent;

/**
 * ...
 * @author kristen autumn blackburn
 */
class CardEffectSystem extends BaseSystem {
	
	public function new(gameEngine : IGameEngine, id : String = null, isActive : Bool = true) {
		super(gameEngine, id, isActive);
		
		m_gameEngine.addEventListener(CardEvent.CARD_PLAYED, onCardPlayed);
	}
	
	override public function visit() : ScriptStatus {
		return m_children.shift().visit();
	}
	
	override public function dispose() {
		m_gameEngine.removeEventListener(CardEvent.CARD_PLAYED, onCardPlayed);
	}
	
	private function onCardPlayed(event : CardEvent) {
		var playedCard : Card = try cast(event.data, Card) catch (e : Dynamic) null;
		
		for (cardEffect in playedCard.getCardEffects()) {
			addChild(cardEffect);
		}
	}
	
}