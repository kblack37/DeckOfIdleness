package common.display;
import common.engine.IGameEngine;

/**
 * Animations need access to the game engine to add & change
 * components
 * 
 * @author kristen autumn blackburn
 */
class BaseAnimation implements IAnimation {
	
	private var m_gameEngine : IGameEngine;

	public function new(gameEngine : IGameEngine) {
		m_gameEngine = gameEngine;
	}
	
	
	/* INTERFACE common.display.IAnimation */
	// These methods should always be overridden by subclasses
	public function start() : Void {
		
	}
	
	public function stop() : Void {
		
	}
	
}