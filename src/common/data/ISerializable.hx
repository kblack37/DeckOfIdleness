package common.data;

/**
 * @author kristen autumn blackburn
 */
interface ISerializable {
	public function serialize() : Dynamic;
	public function deserialize(object : Dynamic) : Void;
}