package common.engine.component;
import common.data.ISerializable;
import common.engine.type.EntityId;

/**
 * Base class for all components
 * 
 * @author kristen autumn blackburn
 */
class BaseComponent implements ISerializable {
	
	public var id(get, set) : EntityId;
	public var typeId(get, never) : String;
	
	private var m_entityId : EntityId;
	private var m_typeId : String;

	private function new(typeId : String) {
		m_typeId = typeId;
		
		initialize();
	}
	
	public function initialize() {
		m_entityId = null;
	}
	
	public function serialize() : Dynamic {
		return null;
	}
	
	public function deserialize(object : Dynamic) {
		
	}
	
	function get_id() : EntityId {
		return m_entityId;
	}
	
	function set_id(val : EntityId) : EntityId {
		if (m_entityId == null) {
			m_entityId = val;
		}
		
		return val;
	}
	
	function get_typeId() : String {
		return m_typeId;
	}
}