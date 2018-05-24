package idle.engine.card;

/**
 * 
 * @author kristen autumn blackburn
 */
class CardLibrary {

	private var m_cards : Array<Card>;
	
	public function new() {
		m_cards = new Array<Card>();
	}
	
	public function addCard(card : Card) {
		m_cards.push(card);
	}
	
	public function removeCard(card : Card) {
		m_cards.remove(card);
	}
	
	public function shuffle() {
		m_cards.sort(function(c1 : Card, c2 : Card) : Int {
			var r : Float = Math.random();
			return r < 0.5 ? 1 : -1;
		});
	}
}