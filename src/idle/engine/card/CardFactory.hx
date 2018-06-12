package idle.engine.card;
import common.engine.IGameEngine;
import common.engine.component.HighlightComponent;
import common.engine.component.IComponentManager;
import idle.card.CardDisplay;
import idle.engine.GameEngine;
import idle.engine.card.effects.CardEffect;
import idle.engine.card.effects.ResourceEffect;
import idle.engine.component.ColorComponent;
import idle.engine.component.EffectsComponent;
import idle.engine.component.NameComponent;
import idle.engine.component.RarityComponent;
import idle.engine.component.UpgradeComponent;
import idle.engine.events.CardEvent;

/**
 * ...
 * @author kristen autumn blackburn
 */
class CardFactory {
	private static var g_nextUid : Int = 0;
	
	private var m_gameEngine : GameEngine;
	
	public function new(gameEngine : IGameEngine) {
		m_gameEngine = try cast(gameEngine, GameEngine) catch (e : Dynamic) null;
	}
	
	public function createCard(id : Int) : Card {
		var cardObject : Dynamic = m_gameEngine.getIdToCardMap().get(id);
		if (cardObject != null) {
			var cardId : Card = Std.string(g_nextUid++);
			var componentManager : IComponentManager = m_gameEngine.getComponentManager();
			
			// Deserialize the basic data
			var nameComponent : NameComponent = try cast(componentManager.addComponentToEntity(cardId, NameComponent.TYPE_ID), NameComponent) catch (e : Dynamic) null;
			nameComponent.deserialize(cardObject);
			
			var colorComponent : ColorComponent = try cast(componentManager.addComponentToEntity(cardId, ColorComponent.TYPE_ID), ColorComponent) catch (e : Dynamic) null;
			colorComponent.deserialize(cardObject);
			
			var highlightComponent : HighlightComponent = try cast(componentManager.addComponentToEntity(cardId, HighlightComponent.TYPE_ID), HighlightComponent) catch (e : Dynamic) null;
			highlightComponent.deserialize(cardObject);
			highlightComponent.blinkDurationMs = 1000;
			#if debug
				if (Math.random() > 0.5) {
					highlightComponent.active = true;
				}
			#end
			
			var rarityComponent : RarityComponent = try cast(componentManager.addComponentToEntity(cardId, RarityComponent.TYPE_ID), RarityComponent) catch (e : Dynamic) null;
			rarityComponent.deserialize(cardObject);
			
			// Deserialize the effects data
			var effectsComponent : EffectsComponent = try cast(componentManager.addComponentToEntity(cardId, EffectsComponent.TYPE_ID), EffectsComponent) catch (e : Dynamic) null;
			effectsComponent.deserialize(cardObject);
			
			// Deserialize the upgrade data, if it exists
			if (Reflect.hasField(cardObject, "upgrade")) {
				var cardUpgradeData : Dynamic = cardObject.upgrade;
				var upgradeComponent : UpgradeComponent = try cast(componentManager.addComponentToEntity(cardId, UpgradeComponent.TYPE_ID), UpgradeComponent) catch (e : Dynamic) null;
				upgradeComponent.deserialize(cardUpgradeData);
			}
			
			m_gameEngine.dispatchEvent(new CardEvent(CardEvent.CARD_CREATED, cardId));
			
			return cardId;
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