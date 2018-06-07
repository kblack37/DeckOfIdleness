package common.engine.component;
import common.engine.type.EntityId;

/**
 * @author kristen autumn blackburn
 */
interface IComponentManager {
	public function addComponentToEntity(entityId : EntityId, componentType : String) : BaseComponent;
	public function removeComponentFromEntity(entityId : EntityId, componentType : String) : Bool;
	public function entityHasComponent(entityId : EntityId, componentType : String) : Bool;
	public function getComponentByIdAndType(entityId : EntityId, componentType : String) : BaseComponent;
	public function getComponentsOfType(componentType : String) : Array<BaseComponent>;
	public function clear() : Void;
}