package idle.engine.widget;

import common.engine.IGameEngine;
import common.engine.widget.BaseWidget;
import idle.engine.card.Card;
import idle.engine.card.ICardLibrary;

/**
 * ...
 * @author kristen autumn blackburn
 */
class BaseLibraryWidget extends BaseWidget implements ICardLibrary {
	
	private var m_cards : Array<Card>;

	public function new(gameEngine : IGameEngine, cards : Array<Card>) {
		super(gameEngine);
		
		m_cards = cards;
	}
	
	
	/* INTERFACE idle.engine.card.ICardLibrary */
	
	public function getCards() : Array<Card> {
		return m_cards.copy();
	}

	public function addCardAt(card : Card, index : Int) : Void {
		m_cards.insert(index, card);
	}
	
	public function addCardToTop(card : Card) : Void {
		m_cards.unshift(card);
	}
	
	public function addCardToBottom(card : Card) : Void {
		m_cards.push(card);
	}
	
	public function addCardAtRandom(card : Card) : Void {
		addCardAt(card, Std.random(m_cards.length + 1));
	}
	
	public function removeCard(card : Card) : Void {
		m_cards.remove(card);
	}
	
	public function removeCardAt(index : Int) : Card {
		var cardToRemove : Card = m_cards[index];
		m_cards.remove(cardToRemove);
		return cardToRemove;
	}
	
	public function removeCardFromTop() : Card {
		return m_cards.shift();
	}
	
	public function removeCardFromBottom() : Card {
		return m_cards.pop();
	}
	
	public function removeCardAtRandom() : Card {
		return removeCardAt(Std.random(m_cards.length));
	}
	
	public function size() : Int {
		return m_cards.length;
	}
	
	public function shuffle() : Void {
		m_cards.sort(function(a : Card, b : Card) {
			return Math.random() > 0.5 ? 1 : -1;
		});
	}
}