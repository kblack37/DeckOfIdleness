package common.display;

/**
 * All animations should just be able to be started and then stopped
 * 
 * @author kristen autumn blackburn
 */
interface IAnimation {
	public function start() : Void;
	public function stop() : Void;
}