package common.engine.component;

/**
 * ...
 * @author kristen autumn blackburn
 */
class RotateComponent extends BaseComponent {
	
	public static var TYPE_ID : String = Type.getClassName(RotateComponent);
	
	public var rotation(get, never) : Float;
	public var angularVelocity(get, never) : Float;
	
	public var isRotating(get, set) : Bool;
	
	private var m_rotation : Float;
	private var m_angularVelocity : Float;
	
	private var m_isRotating : Bool;

	private var m_rotationQueue : Array<Dynamic>;
	
	@:allow(TransformComponent)
	private function new() {
		super(TYPE_ID);
	}
	
	override public function initialize() {
		super.initialize();
		
		m_rotation = 0;
		m_angularVelocity = 0;
		m_isRotating = false;
		m_rotationQueue = new Array<Dynamic>();
	}
	
	override public function serialize() : Dynamic {
		return null;
	}
	
	override public function deserialize(object : Dynamic) {
		
	}
	
	public function queueRotation(data : Dynamic) {
		m_rotationQueue.push(data);
	}
	
	public function hasRotationQueued() : Bool {
		return m_rotationQueue.length != 0;
	}
	
	public function updateToQueuedRotation() {
		var rotationData : Dynamic = m_rotationQueue.shift();
		if (Reflect.hasField(rotationData, "rotation")) {
			m_rotation = rotationData.rotation;
		}
		if (Reflect.hasField(rotationData, "angularVelocity")) {
			m_angularVelocity = rotationData.angularVelocity;
		} else {
			m_angularVelocity = -1;
		}
	}
	
	function get_rotation() : Float {
		return m_rotation;
	}
	
	function get_angularVelocity() : Float {
		return m_angularVelocity;
	}
	
	function get_isRotating() : Bool {
		return m_isRotating;
	}
	
	function set_isRotating(value : Bool) : Bool {
		return m_isRotating = value;
	}
}