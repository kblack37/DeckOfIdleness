package common.engine.systems;

import common.engine.IGameEngine;
import common.engine.scripting.ScriptNode;
import common.engine.scripting.ScriptStatus;

/**
 * Base system doesn't do much for now besides always return that it's running
 * 
 * @author kristen autumn blackburn
 */
class BaseSystem extends ScriptNode {
	
	private var m_gameEngine : IGameEngine;
	
	public function new(gameEngine : IGameEngine, id : String = null, isActive : Bool = true) {
		super(id, isActive);
		
		m_gameEngine = gameEngine;
	}
	
	override public function visit() : ScriptStatus {
		return ScriptStatus.RUNNING;
	}
}