package idle.engine.component;

import common.engine.component.BaseComponent;
import idle.engine.card.CardRarity;

/**
 * ...
 * @author kristen autumn blackburn
 */
class RarityComponent extends BaseComponent {
	
	public static var TYPE_ID : String = Type.getClassName(RarityComponent);
	
	public var rarity(get, never) : CardRarity;
	
	private var m_rarity : CardRarity;

	public function new() {
		super(TYPE_ID);
	}
	
	override public function initialize() {
		m_rarity = CardRarity.COMMON;
	}
	
	override public function serialize() : Dynamic {
		return null;
	}
	
	override public function deserialize(object : Dynamic) {
		m_rarity = switch(object.r) {
			case "c": CardRarity.COMMON;
			case "uc": CardRarity.UNCOMMON;
			case "r": CardRarity.RARE;
			case _: throw "Undefined rarity";
		}
	}
	
	/** GETTERS / SETTERS **/
	
	function get_rarity() : CardRarity {
		return m_rarity;
	}
}