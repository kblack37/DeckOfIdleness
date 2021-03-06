package idle.deck;

import common.engine.IGameEngine;
import common.engine.widget.BaseWidget;
import idle.engine.card.Card;
import idle.engine.card.ICardLibrary;
import idle.engine.widget.BaseLibraryWidget;

/**
 * ...
 * @author kristen autumn blackburn
 */
class DeckWidget extends BaseLibraryWidget {
	
	public function new(gameEngine : IGameEngine, cards : Array<Card>) {
		super(gameEngine, cards);
	}
}