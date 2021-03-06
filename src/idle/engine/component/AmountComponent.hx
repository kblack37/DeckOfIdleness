package idle.engine.component;

import common.engine.component.BaseComponent;
import common.engine.type.Number;

/**
 * ...
 * @author kristen autumn blackburn
 */
class AmountComponent extends BaseComponent {
	
	public static var TYPE_ID : String = Type.getClassName(AmountComponent);
	
	public var amount(get, set) : Number;
	
	private var m_amount : Number;

	private function new() {
		super(TYPE_ID);
	}
	
	override public function initialize() {
		super.initialize();
		
		m_amount = new Number(0);
	}
	
	override public function serialize() : Dynamic {
		return null;
	}
	
	override public function deserialize(object : Dynamic) {
		if (Reflect.hasField(object, "amount")) {
			m_amount = object.amount;
		}
	}
	
	function get_amount() : Number {
		return m_amount;
	}
	
	function set_amount(value : Number) : Number {
		return m_amount = value;
	}
}