package common.engine.type;

/**
 * ...
 * @author kristen autumn blackburn
 */
abstract EntityId(String) from String {
	public function new(id : String) {
		this = id;
	}
	
	
}