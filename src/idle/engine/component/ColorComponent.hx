package idle.engine.component;

import common.engine.component.BaseComponent;
import idle.engine.card.CardColor;

/**
 * ...
 * @author kristen autumn blackburn
 */
class ColorComponent extends BaseComponent {
	
	public static var TYPE_ID : String = Type.getClassName(ColorComponent);
	
	public var cardColor(get, set) : CardColor;
	
	private var m_cardColor : CardColor;

	public function new() {
		super(TYPE_ID);
	}
	
	override public function initialize() {
		m_cardColor = CardColor.GREY;
	}
	
	override public function serialize() : Dynamic {
		return null;
	}
	
	override public function deserialize(object : Dynamic) {
		m_cardColor = switch(object.color) {
			case "grey": CardColor.GREY;
			case "red": CardColor.RED;
			case "yellow": CardColor.YELLOW;
			case "blue": CardColor.BLUE;
			case "green": CardColor.GREEN;
			case _: throw "Undefined color";
		}
	}
	
	/** GETTERS / SETTERS **/
	
	function get_cardColor() : CardColor {
		return m_cardColor;
	}
	
	function set_cardColor(value : CardColor) : CardColor {
		return m_cardColor = value;
	}
}