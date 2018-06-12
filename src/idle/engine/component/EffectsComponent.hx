package idle.engine.component;

import common.engine.component.BaseComponent;

/**
 * ...
 * @author kristen autumn blackburn
 */
class EffectsComponent extends BaseComponent {
	
	public static var TYPE_ID : String = Type.getClassName(EffectsComponent);
	
	public var effects(get, set) : Array<Dynamic>;
	
	private var m_effects : Array<Dynamic>;

	public function new() {
		super(TYPE_ID);
	}
	
	override public function initialize() {
		super.initialize();
		
		m_effects = new Array<Dynamic>();
	}
	
	override public function serialize() : Dynamic {
		return null;
	}
	
	override public function deserialize(object : Dynamic) {
		m_effects = object.effects;
	}
	
	/** GETTERS / SETTERS **/
	
	function get_effects() : Array<Dynamic> {
		return m_effects.copy();
	}
	
	function set_effects(value : Array<Dynamic>) : Array<Dynamic> {
		m_effects = value.copy();
		return value;
	}
}