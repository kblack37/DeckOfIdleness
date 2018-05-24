package idle.engine.resource;
import common.engine.IGameEngine;
import common.engine.component.IComponentManager;
import idle.engine.component.AmountComponent;

/**
 * ...
 * @author kristen autumn blackburn
 */
class ResourceParser {

	private var m_gameEngine : IGameEngine;
	
	public function new(gameEngine : IGameEngine) {
		m_gameEngine = gameEngine;
	}
	
	public function parseFromJsonObject(object : Dynamic) {
		if (Reflect.hasField(object, "resources")) {
			var componentManager : IComponentManager = m_gameEngine.getComponentManager();
			var resources : Array<Dynamic> = object.resources;
			
			for (resource in resources) {
				var resourceName : String = resource.name;
				
				componentManager.addComponentToEntity(resourceName, AmountComponent.TYPE_ID).deserialize(resource);
			}
		} else {
			trace("No resources parsed!");
		}
	}
}