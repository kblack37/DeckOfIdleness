package common.engine.widget;

import common.display.BaseSprite;
import common.engine.IGameEngine;

/**
 * The base class for almost all display elements; override the resize method
 * 
 * @author kristen autumn blackburn
 */
class BaseWidget extends BaseSprite {

	private var m_gameEngine : IGameEngine;
	
	public function new(gameEngine : IGameEngine) {
		super();
		
		m_gameEngine = gameEngine;
	}
	
	public function resize(width : Float, height : Float) {
		this.width = width;
		this.height = height;
	}
}