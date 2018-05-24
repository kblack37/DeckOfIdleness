package common.engine.component;

/**
 * ...
 * @author kristen autumn blackburn
 */
class MoveComponent extends BaseComponent {

	public static var TYPE_ID : String = Type.getClassName(MoveComponent);
	
	public var x(get, never) : Float;
	public var y(get, never) : Float;
	public var velocity(get, never) : Float;
	
	public var isMoving(get, set) : Bool;
	
	private var m_x : Float;
	private var m_y : Float;
	private var m_velocity : Float;
	
	private var m_isMoving : Bool;
	
	private var m_moveQueue : Array<Dynamic>;
	
	@:allow(TransformComponent)
	private function new() {
		super(TYPE_ID);
	}
	
	override public function initialize() {
		super.initialize();
		
		m_x = 0;
		m_y = 0;
		m_velocity = 0;
		m_isMoving = false;
		m_moveQueue = new Array<Dynamic>();
	}
	
	override public function serialize() : Dynamic {
		return null;
	}
	
	override public function deserialize(object : Dynamic) {
		
	}
	
	public function queueMove(data : Dynamic) {
		m_moveQueue.push(data);
	}
	
	public function hasMoveQueued() : Bool {
		return m_moveQueue.length != 0;
	}
	
	public function updateToQueuedMove() {
		var moveData : Dynamic = m_moveQueue.shift();
		if (Reflect.hasField(moveData, "x")) {
			m_x = moveData.x;
		}
		if (Reflect.hasField(moveData, "y")) {
			m_y = moveData.y;
		}
		if (Reflect.hasField(moveData, "velocity")) {
			m_velocity = moveData.velocity;
		} else {
			m_velocity = -1;
		}
	}
	
	function get_x() : Float {
		return m_x;
	}
	
	function get_y() : Float {
		return m_y;
	}
	
	function get_velocity() : Float {
		return m_velocity;
	}
	
	function get_isMoving() : Bool {
		return m_isMoving;
	}
	
	function set_isMoving(value : Bool) : Bool {
		return m_isMoving = value;
	}
}