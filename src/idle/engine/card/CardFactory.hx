package idle.engine.card;
import common.engine.IGameEngine;
import idle.engine.GameEngine;
import idle.engine.card.effects.CardEffect;
import idle.engine.card.effects.ResourceEffect;

/**
 * ...
 * @author kristen autumn blackburn
 */
class CardFactory {

	private var m_gameEngine : GameEngine;
	
	public function new(gameEngine : IGameEngine) {
		m_gameEngine = try cast(gameEngine, GameEngine) catch (e : Dynamic) null;
	}
	
	public function createCard(id : Int) : Card {
		var cardObject : Dynamic = m_gameEngine.getIdToCardMap().get(id);
		if (cardObject != null) {
			var card : Card = new Card();
			card.deserialize(cardObject);
			
			var cardEffectData : Array<Dynamic> = cardObject.effects;
			for (effectData in cardEffectData) {
				card.addCardEffect(parseEffect(effectData));
			}
			
			return card;
		} else {
			throw "Invalid card ID!";
		}
	}
	
	private function parseEffect(effectData : Dynamic) {
		var cardEffect : CardEffect = null;
		var type : String = effectData.type;
		if (type == "resource") {
			cardEffect = new ResourceEffect(m_gameEngine, effectData.r, effectData.a);
		}
		return cardEffect;
	}
}