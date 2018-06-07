package common.engine;
import common.display.ISprite;
import common.engine.component.IComponentManager;
import common.engine.type.EntityId;
import common.engine.widget.BaseWidget;
import common.state.IStateMachine;
import openfl.display.DisplayObject;
import openfl.events.Event;

/**
 * @author kristen autumn blackburn
 */
interface IGameEngine extends ISprite {
	public function getStateMachine() : IStateMachine;
	public function getTime() : Time;
	public function getComponentManager() : IComponentManager;
	public function update() : Void;
	
	/**
	 * Adds two components to the entity: a transform component and a renderable
	 * component with the display given 
	 */
	public function addUIComponent(entityId : EntityId, display : DisplayObject) : Void;
	
	public function addWidget(entityId : EntityId, widget : BaseWidget) : Void;
	public function getWidget(entityId : EntityId) : BaseWidget;
	
	public function addTagToEntity(entityId : EntityId, tag : String) : Void;
	public function removeTagFromEntity(entityId : EntityId, tag : String) : Void;
	public function getEntitiesWithTag(tag : String) : Array<EntityId>;
	
	// The following functions are added to the interface in order to
	// use it as a central event source
	public function dispatchEvent(event : Event) : Bool;
	public function addEventListener(type : String, listener : Dynamic->Void, useCapture : Bool = false, priority : Int = 0, useWeakReference : Bool = false) : Void;
	public function removeEventListener(type : String, listener : Dynamic->Void, useCaputre : Bool = false) : Void;
}