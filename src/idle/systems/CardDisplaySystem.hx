package idle.systems;

import common.display.IAnimation;
import common.engine.IGameEngine;
import common.engine.component.IComponentManager;
import common.engine.component.RenderableComponent;
import common.engine.scripting.ScriptStatus;
import common.engine.systems.BaseSystem;
import idle.card.CardDisplay;
import idle.engine.card.Card;
import idle.engine.events.CardEvent;

/**
 * ...
 * @author kristen autumn blackburn
 */
class CardDisplaySystem extends BaseSystem {

	private var m_queuedAnimations : Array<IAnimation>;
	
	public function new(gameEngine : IGameEngine, id : String = null, isActive : Bool = true) {
		super(gameEngine, id, isActive);
		
		m_gameEngine.addEventListener(CardEvent.CARD_CREATED, onCardChange);
		m_gameEngine.addEventListener(CardEvent.CARD_UPGRADED, onCardChange);
		
		m_queuedAnimations = new Array<IAnimation>();
	}
	
	override public function visit() : ScriptStatus {
		return ScriptStatus.RUNNING;
	}
	
	private function onCardChange(e : CardEvent) {
		var cardId : Card = e.data;
		var componentManager : IComponentManager = m_gameEngine.getComponentManager();
		
		if (!componentManager.entityHasComponent(cardId, RenderableComponent.TYPE_ID)) {
			var cardDisplay : CardDisplay = new CardDisplay(m_gameEngine, cardId);
			m_gameEngine.addUIComponent(cardId, cardDisplay);
		}
		
		var renderableComponent : RenderableComponent = 
			try cast(m_gameEngine.getComponentManager().getComponentByIdAndType(cardId, RenderableComponent.TYPE_ID), RenderableComponent) catch (e : Dynamic) null;
		var cardDisplay : CardDisplay = try cast(renderableComponent.view, CardDisplay) catch (e : Dynamic) null;
		cardDisplay.refreshFromData();
	}
}