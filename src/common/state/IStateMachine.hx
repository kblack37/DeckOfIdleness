package common.state;
import common.display.ISprite;

/**
 * The state machine is responsible for cleanly transitioning between game states
 * 
 * @author kristen autumn blackburn
 */
interface IStateMachine extends ISprite {
	public function registerState(state : IState) : Void;
	public function getCurrentState() : IState;
	public function getStateInstance(stateClass : Class<Dynamic>) : IState;
	public function changeState(stateClass : Class<Dynamic>) : Void;
}