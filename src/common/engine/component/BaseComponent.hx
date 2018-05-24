package common.engine.component;
import common.data.ISerializable;

/**
 * Base class for all components
 * 
 * @author kristen autumn blackburn
 */
class BaseComponent implements ISerializable {
	
	public var id(get, set) : String;
	public var typeId(get, never) : String;
	
	private var m_entityId : String;
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
	
	function get_id() : String {
		return m_entityId;
	}
	
	function set_id(val : String) : String {
		if (m_entityId == null) {
			m_entityId = val;
		}
		
		return val;
	}
	
	function get_typeId() : String {
		return m_typeId;
	}
}