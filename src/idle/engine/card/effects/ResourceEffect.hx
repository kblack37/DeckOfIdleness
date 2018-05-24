package idle.engine.card.effects;

import common.engine.IGameEngine;
import common.engine.scripting.ScriptStatus;
import idle.engine.component.AmountComponent;
import idle.engine.type.Number;

/**
 * ...
 * @author kristen autumn blackburn
 */
class ResourceEffect extends CardEffect {
	
	private var m_resource : String;
	private var m_amount : Number;

	public function new(gameEngine : IGameEngine, resource : String, amount : Number, id : String = null, isActive : Bool = true) {
		super(gameEngine, id, isActive);
		
		m_resource = resource;
		m_amount = amount;
	}
	
	override public function visit() : ScriptStatus {
		var amountComponent : AmountComponent = 
			try cast(m_gameEngine.getComponentManager().getComponentByIdAndType(m_resource, AmountComponent.TYPE_ID), AmountComponent) catch (e : Dynamic) null;
		
		amountComponent.amount += m_amount;
		return ScriptStatus.SUCCESS;
	}
	
}