package common.engine.scripting.selectors;

import common.engine.scripting.ScriptNode;
import common.engine.scripting.ScriptStatus;

/**
 * Simple selector that performs no logic and just runs its children in order
 * 
 * @author kristen autumn blackburn
 */
class AllSelector extends ScriptNode {

	public function new(id : String = null, isActive : Bool = true) {
		super(id, isActive);
	}
	
	override public function visit() : ScriptStatus {
		for (child in m_children) {
			child.visit();
		}
		
		return ScriptStatus.RUNNING;
	}
}