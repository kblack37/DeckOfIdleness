package idle.systems;

import common.engine.IGameEngine;
import common.engine.systems.BaseSystem;
import common.engine.type.Number;
import idle.engine.component.AmountComponent;
import idle.engine.events.ResourceEvent;

/**
 * ...
 * @author kristen autumn blackburn
 */
class ResourceChangeSystem extends BaseSystem {

	public function new(gameEngine : IGameEngine, id : String = null, isActive : Bool = true) {
		super(gameEngine, id, isActive);
		
		m_gameEngine.addEventListener(ResourceEvent.RESOURCE_GAINED, onResourceGained);
		m_gameEngine.addEventListener(ResourceEvent.RESOURCE_LOST, onResourceLost);
	}
	
	private function onResourceGained(e : ResourceEvent) {
		var amountComponent : AmountComponent =
			try cast(m_gameEngine.getComponentManager().getComponentByIdAndType(e.data.resource, AmountComponent.TYPE_ID), AmountComponent) catch (e : Dynamic) null;
		
		amountComponent.amount += e.data.amount;
		m_gameEngine.dispatchEvent(new ResourceEvent(ResourceEvent.RESOURCE_CHANGED, e.data.resource));
	}
	
	private function onResourceLost(e : ResourceEvent) {
		var amountComponent : AmountComponent =
			try cast(m_gameEngine.getComponentManager().getComponentByIdAndType(e.data.resource, AmountComponent.TYPE_ID), AmountComponent) catch (e : Dynamic) null;
		
		amountComponent.amount += -1 * e.data.amount;
		m_gameEngine.dispatchEvent(new ResourceEvent(ResourceEvent.RESOURCE_CHANGED, e.data.resource));
	}
}