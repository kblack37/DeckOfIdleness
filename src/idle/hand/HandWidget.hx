package idle.hand;

import common.engine.IGameEngine;
import common.engine.widget.BaseWidget;
import idle.engine.card.Card;
import idle.engine.card.CardLibrary;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author kristen autumn blackburn
 */
class HandWidget extends BaseWidget {
	
	private var m_background : Bitmap;
	
	private var m_heldCards : CardLibrary;
	
	private var m_cardUidToDisplayMap : Map<Int, DisplayObject>;
	
	public function new(gameEngine : IGameEngine) {
		super(gameEngine);
		
		m_background = new Bitmap(new BitmapData(600, 100, false, 0x666666));
		addChild(m_background);
		
		m_heldCards = new CardLibrary();
		
		m_cardUidToDisplayMap = new Map<Int, DisplayObject>();
	}
	
	public function addCard(card : Card) {
		m_heldCards.addCard(card);
		
		var cardDisplay : Sprite = new Sprite();
		var cardBackground : Bitmap = new Bitmap(Assets.getBitmapData("assets/img/" + card.color + "_card.png"));
		var nameTextField : TextField = new TextField();
		nameTextField.text = card.name;
		nameTextField.height = 8;
		nameTextField.width = 20;
		nameTextField.x = 5;
		nameTextField.y = 4;
		cardDisplay.addChild(cardBackground);
		cardDisplay.addChild(nameTextField);
		
		m_cardUidToDisplayMap.set(card.uid, cardDisplay);
		addChild(cardDisplay);
	}
	
	public function removeCard(card : Card) {
		
	}
}