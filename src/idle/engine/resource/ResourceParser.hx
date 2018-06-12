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
				
				var amountComponent : AmountComponent = try cast(componentManager.addComponentToEntity(resourceName, AmountComponent.TYPE_ID), AmountComponent) catch (e : Dynamic) null;
				amountComponent.deserialize(resource);
				#if debug
					amountComponent.amount = 5000;
				#end
				m_gameEngine.addTagToEntity(resourceName, "resource");
			}
		} else {
			trace("No resources parsed!");
		}
	}
}