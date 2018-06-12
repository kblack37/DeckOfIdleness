package common.engine.component;
import idle.engine.card.ColorConstants;

/**
 * ...
 * @author kristen autumn blackburn
 */
class HighlightComponent extends BaseComponent {
	
	public static var TYPE_ID : String = Type.getClassName(HighlightComponent);
	
	public var color(get, set) : Int;
	public var glowDistance(get, set) : Int;
	public var blinkDurationMs(get, set) : Int;
	public var active(get, set) : Bool;
	
	private var m_color : Int;
	private var m_glowDistance : Int;
	private var m_blinkDurationMs : Int;
	private var m_active : Bool;

	public function new() {
		super(TYPE_ID);
	}
	
	override public function initialize() {
		m_color = 0xFFFFFF;
		m_glowDistance = 20;
		m_blinkDurationMs = 0;
		m_active = false;
	}
	
	override public function deserialize(object : Dynamic) {
		if (Reflect.hasField(object, "color")) {
			if (Std.is(object.color, String)) {
				m_color = switch(object.color) {
					case "grey": ColorConstants.GREY;
					case "red": ColorConstants.RED;
					case "yellow": ColorConstants.YELLOW;
					case "blue": ColorConstants.BLUE;
					case "green": ColorConstants.GREEN;
					case _: throw "Undefined color value " + Std.string(object.color);
				}
			} else if (Std.is(object.color, Int)) {
				m_color = object.color;
			}
		} 
	}
	
	/** GETTERS / SETTERS **/
	
	function get_color() : Int {
		return m_color;
	}
	
	function set_color(value : Int) {
		return m_color = value;
	}
	
	function get_glowDistance() : Int {
		return m_glowDistance;
	}
	
	function set_glowDistance(value : Int) : Int {
		return m_glowDistance = value;
	}
	
	function get_blinkDurationMs() : Int {
		return m_blinkDurationMs;
	}
	
	function set_blinkDurationMs(value : Int) : Int {
		return m_blinkDurationMs = value;
	}
	
	function get_active() : Bool {
		return m_active;
	}
	
	function set_active(value : Bool) : Bool {
		return m_active = value;
	}
}