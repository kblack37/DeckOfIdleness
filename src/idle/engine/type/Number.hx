package idle.engine.type;

/**
 * ...
 * @author kristen autumn blackburn
 */
abstract Number(Float) from Float to Float {
	public inline function new(value : Float = 0) {
		this = value;
	}
	
	@:from
	public static function fromInt(value : Int) : Number {
		return new Number(value);
	}
	
	@:to
	public function toInt() : Int {
		return Math.round(this);
	}
}