package idle.engine.card.effects;

import common.engine.IGameEngine;
import common.engine.scripting.ScriptStatus;
import idle.engine.component.AmountComponent;
import idle.engine.events.ResourceEvent;
import idle.engine.type.Number;

/**
 * ...
 * @author kristen autumn blackburn
 */
class ResourceEffect extends CardEffect {
	
	public var resource(get, never) : String;
	public var amount(get, never) : Number;
	
	private var m_resource : String;
	private var m_amount : Number;

	public function new(gameEngine : IGameEngine, resource : String, amount : Number, id : String = null, isActive : Bool = true) {
		super(gameEngine, id, isActive);
		
		m_resource = resource;
		m_amount = amount;
	}
	
	override public function visit() : ScriptStatus {
		var eventToDispatch : String = m_amount > 0.0 ? ResourceEvent.RESOURCE_GAINED : ResourceEvent.RESOURCE_LOST;
		m_gameEngine.dispatchEvent(new ResourceEvent(eventToDispatch, {resource: m_resource, amount: m_amount}));
		return ScriptStatus.SUCCESS;
	}
	
	function get_resource() : String {
		return m_resource;
	}
	
	function get_amount() : Number {
		return m_amount;
	}
}