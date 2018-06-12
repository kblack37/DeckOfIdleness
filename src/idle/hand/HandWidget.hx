package idle.hand;

import common.engine.IGameEngine;
import common.engine.component.IComponentManager;
import common.engine.component.RenderableComponent;
import common.engine.component.TransformComponent;
import common.engine.widget.BaseWidget;
import idle.engine.card.Card;
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
	private var m_cards : Array<Card>;
	
	private var m_dirty : Bool;
	
	public function new(gameEngine : IGameEngine) {
		super(gameEngine);
		
		m_background = new Bitmap(new BitmapData(800, 200, false, 0x666666));
		addChild(m_background);
		
		m_cards = new Array<Card>();
		
		m_dirty = false;
		
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	/* INTERFACE idle.engine.card.ICardLibrary */
	
	public function getCards() : Array<Card> {
		return m_cards.copy();
	}
	
	public function addCardAt(card : Card, index : Int) {
		m_cards.insert(index, card);
		addCard(card);
	}
	
	public function addCardToTop(card : Card) {
		m_cards.unshift(card);
		addCard(card);
	}
	
	public function addCardToBottom(card : Card) {
		m_cards.push(card);
		addCard(card);
	}
	
	public function addCardAtRandom(card : Card) {
		addCardAt(card, Std.random(m_cards.length + 1));
	}
	
	public function removeCard(card : Card) {
		_removeCard(card);
	}
	
	public function removeCardAt(index : Int) : Card {
		var card : Card = m_cards[index];
		m_cards.remove(card);
		_removeCard(card);
		return card;
	}
	
	public function removeCardFromTop() : Card {
		var card : Card = m_cards.shift();
		_removeCard(card);
		return card;
	}
	
	public function removeCardFromBottom() : Card {
		var card : Card = m_cards.pop();
		_removeCard(card);
		return card;
	}
	
	public function removeCardAtRandom() : Card {
		return removeCardAt(Std.random(m_cards.length));
	}
	
	public function size() : Int {
		return m_cards.length;
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
	
	private function addCard(card : Card) {
		var renderableComponent : RenderableComponent =
			try cast(m_gameEngine.getComponentManager().getComponentByIdAndType(card, RenderableComponent.TYPE_ID), RenderableComponent) catch (e : Dynamic) null;
		addChild(renderableComponent.view);
		
		// For now show them coming from somewhere off to the left
		var transformComponent : TransformComponent =
			try cast(m_gameEngine.getComponentManager().getComponentByIdAndType(card, TransformComponent.TYPE_ID), TransformComponent) catch (e : Dynamic) null;
		transformComponent.move.queueMove({x: -20, y: (m_background.height - renderableComponent.view.height) * 0.5, velocity: -1});
		
		// Set it to rearrange the displays
		m_dirty = true;
	}
	
	private function _removeCard(card : Card) {
		var renderableComponent : RenderableComponent =
			try cast(m_gameEngine.getComponentManager().getComponentByIdAndType(card, RenderableComponent.TYPE_ID), RenderableComponent) catch (e : Dynamic) null;
		removeChild(renderableComponent.view);
		
		// Set it to rearrange the displays
		m_dirty = true;
	}
	
	private function arrangeDisplays() {
		var xOffset : Float = PADDING_SIDES;
		var overlap : Float = calculateNeededOverlap();
		var componentManager : IComponentManager = m_gameEngine.getComponentManager();
		for (cardId in m_cards) {
			var renderableComponent : RenderableComponent = try cast(componentManager.getComponentByIdAndType(cardId, RenderableComponent.TYPE_ID), RenderableComponent) catch (e : Dynamic) null;
			var cardDisplay = renderableComponent.view;
			var endPoint : Point = new Point(m_background.width - cardDisplay.width - xOffset, (m_background.height - cardDisplay.height) * 0.5);
			var slideToEndAnimation : SlideToEndAnimation = new SlideToEndAnimation(m_gameEngine, cardId, endPoint, 500);
			slideToEndAnimation.start();
			xOffset += cardDisplay.width;
			if (overlap > 0) {
				xOffset -= overlap;
			} else {
				xOffset += PADDING_SIDES;
			}
		}
	}
	
	// In some cases, the hand may grow too big and the cards may have
	// to overlap each other; this is calculating how much overlap is needed
	// for them to fit within the hand space still
	private function calculateNeededOverlap() : Float {
		var overlap : Float = 0;
		var totalDisplayWidth : Float = 0;
		var componentManager : IComponentManager = m_gameEngine.getComponentManager();
		for (cardId in m_cards) {
			var renderableComponent : RenderableComponent = try cast(componentManager.getComponentByIdAndType(cardId, RenderableComponent.TYPE_ID), RenderableComponent) catch (e : Dynamic) null;
			totalDisplayWidth += renderableComponent.view.width;
		}
		
		var widthToFitIn : Float = m_background.width - 2 * PADDING_SIDES;
		if (totalDisplayWidth > widthToFitIn) {
			var widthDiff : Float = totalDisplayWidth - widthToFitIn;
			overlap = widthDiff / (m_cards.length - 1);
		}
		
		return overlap;
	}
}