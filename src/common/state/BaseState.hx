package common.state;

import common.engine.IGameEngine;
import common.engine.scripting.ScriptNode;
import common.engine.scripting.selectors.AllSelector;
import openfl.display.Sprite;

/**
 * ...
 * @author kristen autumn blackburn
 */
class BaseState extends Sprite implements IState {
	
	private var m_gameEngine : IGameEngine;
	
	private var m_scriptRoot : ScriptNode;

	public function new(gameEngine : IGameEngine) {
		super();
		
		m_gameEngine = gameEngine;
		
		m_scriptRoot = new AllSelector();
	}
	
	public function getSprite() : Sprite {
		return this;
	}
	
	public function enter(from : IState, params : Dynamic) {
		
	}
	
	public function exit(to : IState) : Dynamic {
		return null;
	}
	
	public function update() {
		m_scriptRoot.visit();
	}
}