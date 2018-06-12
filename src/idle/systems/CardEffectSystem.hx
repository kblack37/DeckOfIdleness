package idle.systems;

import common.engine.IGameEngine;
import common.engine.scripting.ScriptStatus;
import common.engine.systems.BaseSystem;
import common.engine.type.EntityId;
import idle.engine.card.Card;
import idle.engine.card.effects.ResourceEffect;
import idle.engine.component.EffectsComponent;
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
		var status : ScriptStatus = ScriptStatus.FAIL;
		if (m_children.length > 0) {
			status = m_children.shift().visit();
		}
		return status;
	}
	
	override public function dispose() {
		m_gameEngine.removeEventListener(CardEvent.CARD_PLAYED, onCardPlayed);
	}
	
	private function onCardPlayed(event : CardEvent) {
		var playedCardId : EntityId = event.data;
		
		var effectsComponent : EffectsComponent = 
			try cast(m_gameEngine.getComponentManager().getComponentByIdAndType(playedCardId, EffectsComponent.TYPE_ID), EffectsComponent) catch (e : Dynamic) null;
		for (effectData in effectsComponent.effects) {
			this.addChild(
				switch(Reflect.field(effectData, "type")) {
					case "resource": new ResourceEffect(m_gameEngine, Reflect.field(effectData, "r"), Reflect.field(effectData, "a"));
					case _: throw "Undefined effect";
				}
			);
		}
	}
	
}