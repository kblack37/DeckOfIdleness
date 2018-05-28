package idle.engine.card;

/**
 * @author kristen autumn blackburn
 */
interface ICardLibrary {
	public function addCardAt(card : Card, index : Int) : Void;
	
	/**
	 * When referring to decks, this is the next card drawn
	 * When referring to hands, this is the least recently drawn
	 */
	public function addCardToTop(card : Card) : Void;
	
	/**
	 * When referring to decks, this is the last card drawn
	 * When referring to hands, this is the most recently drawn
	 */
	public function addCardToBottom(card : Card) : Void;
	
	public function addCardAtRandom(card : Card) : Void;
	
	public function removeCard(card : Card) : Void;
	
	public function removeCardAt(index : Int) : Card;
	
	public function removeCardFromTop() : Card;
	
	public function removeCardFromBottom() : Card;
	
	public function removeCardAtRandom() : Card;
	
	public function size() : Int;
	
	public function shuffle() : Void;
}