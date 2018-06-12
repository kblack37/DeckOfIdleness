package idle.engine.component;

import common.engine.component.BaseComponent;
import common.engine.scripting.selectors.AllSelector;
import common.engine.type.EntityId;
import common.engine.type.Number;

/**
 * Component that stores upgrade data for cards that have an upgrade
 * option
 * 
 * @author kristen autumn blackburn
 */
class UpgradeComponent extends BaseComponent {
	
	public static var TYPE_ID : String = Type.getClassName(UpgradeComponent);
	
	public var level(get, set) : Int;
	public var cost(get, never) : Map<EntityId, Number>;
	public var effects(get, set) : Array<Dynamic>;
	
	private var m_level : Int;
	private var m_cost : Map<EntityId, Number>;
	private var m_effects : Array<Dynamic>;

	public function new() {
		super(TYPE_ID);
	}
	
	override public function initialize() {
		super.initialize();
		
		m_level = 0;
		m_cost = new Map<EntityId, Number>();
		m_effects = new Array<Dynamic>();
	}
	
	override public function serialize() : Dynamic {
		return null;
	}
	
	override public function deserialize(object : Dynamic) {
		// If we're loading from a save, we need to know the current level of the upgrade
		if (Reflect.hasField(object, "l")) {
			m_level = object.l;
		}
		
		// If the upgrade has a cost, enter that in
		if (Reflect.hasField(object, "cost")) {
			var costObject : Dynamic = object.cost;
			for (resourceName in Reflect.fields(costObject)) {
				m_cost.set(resourceName, Reflect.field(costObject, resourceName));
			}
		}
		
		m_effects = object.effects;
	}
	
	public function setCost(resource : EntityId, amount : Number) {
		if (amount > 0) {
			m_cost[resource] = amount;
		}
	}
	
	/** GETTERS / SETTERS **/
	
	function get_level() : Int {
		return m_level;
	}
	
	function set_level(value : Int) : Int {
		return m_level = value;
	}
	
	function get_cost() : Map<EntityId, Number> {
		return m_cost;
	}
	
	function get_effects() : Array<Dynamic> {
		return m_effects.copy();
	}
	
	function set_effects(value : Array<Dynamic>) : Array<Dynamic> {
		m_effects = value.copy();
		return value;
	}
}