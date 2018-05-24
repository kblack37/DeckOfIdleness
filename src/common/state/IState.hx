package common.state;
import common.display.ISprite;
import openfl.display.Sprite;

/**
 * States are the largest groupings of game logic. They are swapped between
 * by the state machine and can pass parameters between each other
 * 
 * @author kristen autumn blackburn
 */
interface IState extends ISprite {
	public function enter(from : IState, params : Dynamic) : Void;
	public function exit(to : IState) : Dynamic;
	public function update() : Void;
}