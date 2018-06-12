package idle.systems;

import common.engine.IGameEngine;
import common.engine.component.BaseComponent;
import common.engine.component.IComponentManager;
import common.engine.component.RenderableComponent;
import common.engine.scripting.ScriptStatus;
import common.engine.systems.BaseSystem;
import common.engine.type.EntityId;
import idle.card.CardDisplay;
import idle.engine.component.UpgradeComponent;
import idle.engine.events.UpgradeEvent;
import openfl.events.MouseEvent;

/**
 * ...
 * @author kristen autumn blackburn
 */
class CardClickUpgradeSystem extends BaseSystem {

	public function new(gameEngine : IGameEngine, id : String = null, isActive : Bool = true) {
		super(gameEngine, id, isActive);
		
	}
	
	override public function visit() : ScriptStatus {
		var status : ScriptStatus = ScriptStatus.FAIL;
		if (m_children.length > 0) {
			status = m_children.shift().visit();
		}
		return status;
	}
	
	override public function dispose() {
		var componentManager : IComponentManager = m_gameEngine.getComponentManager();
		var baseComponents : Array<BaseComponent> = componentManager.getComponentsOfType(UpgradeComponent.TYPE_ID);
		for (baseComponent in baseComponents) {
			var entityId : EntityId = baseComponent.id;
			if (componentManager.entityHasComponent(entityId, RenderableComponent.TYPE_ID)) {
				var renderableComponent : RenderableComponent =
					try cast(componentManager.getComponentByIdAndType(baseComponent.id, RenderableComponent.TYPE_ID), RenderableComponent) catch (e : Dynamic) null;
				renderableComponent.view.removeEventListener(MouseEvent.RIGHT_CLICK, onCardClick);
			}
		}
	}
	
	override private function onAdded() {
		var componentManager : IComponentManager = m_gameEngine.getComponentManager();
		var baseComponents : Array<BaseComponent> = componentManager.getComponentsOfType(UpgradeComponent.TYPE_ID);
		for (baseComponent in baseComponents) {
			var entityId : EntityId = baseComponent.id;
			if (componentManager.entityHasComponent(entityId, RenderableComponent.TYPE_ID)) {
				var renderableComponent : RenderableComponent =
					try cast(componentManager.getComponentByIdAndType(baseComponent.id, RenderableComponent.TYPE_ID), RenderableComponent) catch (e : Dynamic) null;
				renderableComponent.view.addEventListener(MouseEvent.RIGHT_CLICK, onCardClick);
			}
		}
	}
	
	private function onCardClick(e : MouseEvent) {
		var cardDisplay : CardDisplay = try cast(e.target, CardDisplay) catch (e : Dynamic) null;
		if (cardDisplay != null) {
			var entityId : EntityId = cardDisplay.cardId;
			m_gameEngine.dispatchEvent(new UpgradeEvent(UpgradeEvent.UPGRADE_REQUESTED, entityId));
		}
	}
	
}