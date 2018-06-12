package idle.engine.component;

import common.engine.component.BaseComponent;

/**
 * ...
 * @author kristen autumn blackburn
 */
class NameComponent extends BaseComponent {
	
	public static var TYPE_ID : String = Type.getClassName(NameComponent);
	
	public var cardName(get, never) : String;
	
	private var m_cardName : String;

	public function new() {
		super(TYPE_ID);
	}
	
	override public function initialize() {
		super.initialize();
		
		m_cardName = "";
	}
	
	override public function serialize() : Dynamic {
		return null;
	}
	
	override public function deserialize(object : Dynamic) {
		m_cardName = object.name;
	}
	
	/** GETTERS / SETTERS **/
	
	function get_cardName() : String {
		return m_cardName;
	}
}