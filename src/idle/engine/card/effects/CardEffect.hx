package idle.engine.card.effects;

import common.engine.IGameEngine;
import common.engine.scripting.ScriptNode;

/**
 * ...
 * @author kristen autumn blackburn
 */
class CardEffect extends ScriptNode {
	
	private var m_gameEngine : IGameEngine;

	public function new(gameEngine : IGameEngine, id : String = null, isActive : Bool = true) {
		super(id, isActive);
		
		m_gameEngine = gameEngine;
	}
	
}