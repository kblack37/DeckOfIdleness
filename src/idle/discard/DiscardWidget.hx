package idle.discard;

import common.engine.IGameEngine;
import idle.engine.card.Card;
import idle.engine.card.ICardLibrary;
import idle.engine.widget.BaseLibraryWidget;

/**
 * ...
 * @author kristen autumn blackburn
 */
class DiscardWidget extends BaseLibraryWidget {
	
	public function new(gameEngine : IGameEngine, cards : Array<Card>) {
		super(gameEngine, cards);
	}

}