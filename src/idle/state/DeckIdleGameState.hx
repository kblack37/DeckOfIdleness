package idle.state;

import common.engine.IGameEngine;
import common.state.BaseState;
import common.state.IState;
import idle.engine.card.Card;
import idle.engine.card.CardFactory;
import idle.hand.HandWidget;

/**
 * ...
 * @author kristen autumn blackburn
 */
class DeckIdleGameState extends BaseState {

	public function new(gameEngine : IGameEngine) {
		super(gameEngine);
		
	}
	
	override public function enter(from : IState, params : Dynamic) {
		// Initialize the hand widget
		var handWidget : HandWidget = new HandWidget(m_gameEngine);
		m_gameEngine.addWidget("hand", handWidget);
		handWidget.x = (stage.stageWidth - handWidget.width) * 0.5;
		handWidget.y = stage.stageHeight - handWidget.height;
		addChild(handWidget);
		
		var cardFactory : CardFactory = new CardFactory(m_gameEngine);
		var card : Card = cardFactory.createCard(0);
		handWidget.addCard(card);
	}
}