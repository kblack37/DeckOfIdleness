package;

import common.engine.IGameEngine;
import idle.engine.GameEngine;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author kristen autumn blackburn
 */
class TestMain extends Sprite {

	private var m_gameEngine : IGameEngine;
	
	public function new() {
		super();
		
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	private function onAddedToStage(e : Dynamic) {
		m_gameEngine = new GameEngine();
		addChild(m_gameEngine.getSprite());
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private function onEnterFrame(e : Dynamic) {
		m_gameEngine.update();
	}
}