package idle.systems;

import common.engine.IGameEngine;
import common.engine.systems.BaseSystem;
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
	}
	
	private function onResourceLost(e : ResourceEvent) {
		var amountComponent : AmountComponent =
			try cast(m_gameEngine.getComponentManager().getComponentByIdAndType(e.data.resource, AmountComponent.TYPE_ID), AmountComponent) catch (e : Dynamic) null;
		
		amountComponent.amount -= e.data.amount;
	}
}