package idle.hand;

import common.engine.IGameEngine;
import common.engine.component.IComponentManager;
import common.engine.component.RenderableComponent;
import common.engine.component.TransformComponent;
import common.engine.widget.BaseWidget;
import idle.engine.card.Card;
import idle.engine.card.CardDisplay;
import idle.engine.card.ICardLibrary;
import idle.engine.card.animation.SlideToEndAnimation;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.geom.Point;

/**
 * ...
 * @author kristen autumn blackburn
 */
class HandWidget extends BaseWidget implements ICardLibrary {
	
	private static inline var PADDING_SIDES : Float = 5.0;
	
	private var m_background : DisplayObject;
	
	/**
	 * To keep things straight in my head:
	 * this acts as a queue where the front of it means the cards
	 * on the right of the widget and the back is the cards at the
	 * left of the widget; noting this because the direction of the 
	 * queue growth is counter that of the hand growth
	 */
	private var m_cardDisplays : Array<CardDisplay>;
	
	private var m_dirty : Bool;
	
	public function new(gameEngine : IGameEngine) {
		super(gameEngine);
		
		m_background = new Bitmap(new BitmapData(800, 200, false, 0x666666));
		addChild(m_background);
		
		m_cardDisplays = new Array<CardDisplay>();
		
		m_dirty = false;
		
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	/* INTERFACE idle.engine.card.ICardLibrary */
	
	public function addCardAt(card : Card, index : Int) {
		var cardDisplay : CardDisplay = createCardDisplay(card);
		m_cardDisplays.insert(index, cardDisplay);
		addCard(cardDisplay);
	}
	
	public function addCardToTop(card : Card) {
		var cardDisplay : CardDisplay = createCardDisplay(card);
		m_cardDisplays.unshift(cardDisplay);
		addCard(cardDisplay);
	}
	
	public function addCardToBottom(card : Card) {
		var cardDisplay : CardDisplay = createCardDisplay(card);
		m_cardDisplays.push(cardDisplay);
		addCard(cardDisplay);
	}
	
	public function addCardAtRandom(card : Card) {
		addCardAt(card, Std.random(m_cardDisplays.length + 1));
	}
	
	public function removeCard(card : Card) {
		var cardDisplay : CardDisplay = Lambda.find(m_cardDisplays, 
			function(disp : CardDisplay) : Bool {
				return disp.cardData.uid == card.uid;
			});
		_removeCard(cardDisplay);
	}
	
	public function removeCardAt(index : Int) : Card {
		var cardDisplay : CardDisplay = m_cardDisplays[index];
		m_cardDisplays.remove(cardDisplay);
		_removeCard(cardDisplay);
		return cardDisplay.cardData;
	}
	
	public function removeCardFromTop() : Card {
		var cardDisplay : CardDisplay = m_cardDisplays.shift();
		_removeCard(cardDisplay);
		return cardDisplay.cardData;
	}
	
	public function removeCardFromBottom() : Card {
		var cardDisplay : CardDisplay = m_cardDisplays.pop();
		_removeCard(cardDisplay);
		return cardDisplay.cardData;
	}
	
	public function removeCardAtRandom() : Card {
		return removeCardAt(Std.random(m_cardDisplays.length));
	}
	
	public function size() : Int {
		return m_cardDisplays.length;
	}
	
	public function shuffle() {
		
	}
	
	/* PRIVATE FUNCTIONS */
	
	private function onAddedToStage(e : Dynamic) {
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private function onEnterFrame(e : Dynamic) {
		if (m_dirty) {
			arrangeDisplays();
			m_dirty = false;
		}
	}
	
	private function addCard(cardDisplay : CardDisplay) {
		addChild(cardDisplay);
		m_gameEngine.addUIComponent(cardDisplay.cardData.uid, cardDisplay);
		m_dirty = true;
	}
	
	private function _removeCard(cardDisplay : CardDisplay) {
		removeChild(cardDisplay);
		var componentManager : IComponentManager = m_gameEngine.getComponentManager();
		componentManager.removeComponentFromEntity(cardDisplay.cardData.uid, RenderableComponent.TYPE_ID);
		componentManager.removeComponentFromEntity(cardDisplay.cardData.uid, TransformComponent.TYPE_ID);
		m_dirty = true;
	}
	
	private function arrangeDisplays() {
		var xOffset : Float = PADDING_SIDES;
		var overlap : Float = calculateNeededOverlap();
		for (cardDisplay in m_cardDisplays) {
			var endPoint : Point = new Point(m_background.width - cardDisplay.width - xOffset, (m_background.height - cardDisplay.height) * 0.5);
			var slideToEndAnimation : SlideToEndAnimation = new SlideToEndAnimation(m_gameEngine, cardDisplay.cardData.uid, endPoint, 500);
			slideToEndAnimation.start();
			xOffset += cardDisplay.width;
			if (overlap > 0) {
				xOffset -= overlap;
			} else {
				xOffset += PADDING_SIDES;
			}
		}
	}
	
	private function createCardDisplay(card : Card) : CardDisplay {
		var cardDisplay : CardDisplay = new CardDisplay(card);
		
		// For now show them coming from somewhere off to the left
		cardDisplay.x = -20;
		cardDisplay.y = (m_background.height - cardDisplay.height) * 0.5;
		return cardDisplay;
	}
	
	// In some cases, the hand may grow too big and the cards may have
	// to overlap each other; this is calculating how much overlap is needed
	// for them to fit within the hand space still
	private function calculateNeededOverlap() : Float {
		var overlap : Float = 0;
		var totalDisplayWidth : Float = 0;
		for (cardDisplay in m_cardDisplays) {
			totalDisplayWidth += cardDisplay.width;
		}
		
		var widthToFitIn : Float = m_background.width - 2 * PADDING_SIDES;
		if (totalDisplayWidth > widthToFitIn) {
			var widthDiff : Float = totalDisplayWidth - widthToFitIn;
			overlap = widthDiff / (m_cardDisplays.length - 1);
		}
		
		return overlap;
	}
}