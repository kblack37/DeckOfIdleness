package common.engine.scripting;

/**
 * ...
 * @author kristen autumn blackburn
 */
class ScriptNode {
	
	public var id(get, never) : String;
	
	private var m_id : String;
	
	private var m_isActive : Bool;
	
	private var m_children : Array<ScriptNode>;
	
	private var m_parent : ScriptNode;

	public function new(id : String = null, isActive : Bool = true) {
		m_id = id;
		m_isActive = isActive;
		
		m_children = new Array<ScriptNode>();
		
		setIsActive(m_isActive);
	}
	
	public function addChild(child : ScriptNode, index : Int = -1) {
		m_children.insert(index, child);
		child.m_parent = this;
		child.onAdded();
	}
	
	public function removeChild(childToRemove : ScriptNode) {
		m_children.remove(childToRemove);
		childToRemove.dispose();
	}
	
	public function visit() : ScriptStatus {
		return ScriptStatus.ERROR;
	}
	
	public function reset() {
		for (child in m_children) {
			child.reset();
		}
	}
	
	public function getIsActive() : Bool {
		return m_isActive;
	}
	
	public function setIsActive(value : Bool) {
		m_isActive = value;
		
		for (child in m_children) {
			child.setIsActive(value);
		}
	}
	
	/**
	 * Searches the entire tree this script is in to try to
	 * find the script with the given id
	 */
	public function findNodeById(id : String) : ScriptNode {
		var currentNode = this;
		while (currentNode.m_parent != null) {
			currentNode = currentNode.m_parent;
		}
		
		return currentNode._findNodeById(id);
	}
	
	private function _findNodeById(id : String) : ScriptNode {
		var targetNode : ScriptNode = null;
		if (m_id == id) {
			targetNode = this;
		} else {
			for (child in m_children) {
				targetNode = child._findNodeById(id);
				if (targetNode != null) break;
			}
		}
		
		return targetNode;
	}
	
	public function dispose() {
		for (child in m_children) {
			child.dispose();
		}
		
		this.setIsActive(false);
		
		m_parent = null;
	}
	
	private function onAdded() {
		
	}
	
	function get_id() : String {
		return m_id;
	}
}