package common.engine.component;
import common.engine.component.BaseComponent;

/**
 * ...
 * @author kristen autumn blackburn
 */
class ComponentManager implements IComponentManager {
	
	private var m_typeToComponentsMap : Map<String, Array<BaseComponent>>;
	
	private var m_typeToIdComponentMap : Map<String, Map<String, BaseComponent>>;
	
	private var m_typeToComponentPoolMap : Map<String, ComponentPool>;
	
	private var m_typeInitedMap : Map<String, Bool>;

	public function new() {
		m_typeToComponentsMap = new Map<String, Array<BaseComponent>>();
		m_typeToIdComponentMap = new Map<String, Map<String, BaseComponent>>();
		m_typeToComponentPoolMap = new Map<String, ComponentPool>();
		m_typeInitedMap = new Map<String, Bool>();
	}
	
	public function addComponentToEntity(entityId : String, componentType : String) : BaseComponent {
		if (!m_typeInitedMap.exists(componentType)) {
			initComponentType(componentType);
		}
		
		var idToComponentMap : Map<String, BaseComponent> = m_typeToIdComponentMap.get(componentType);
		
		// Get rid of the old component if it exists
		if (idToComponentMap.exists(entityId)) {
			removeComponentFromEntity(entityId, componentType);
			trace("WARNING: entity with id " + entityId + " replaced component of type " + componentType);
		}
		
		var component : BaseComponent = m_typeToComponentPoolMap.get(componentType).getComponent();
		if (component == null) {
			trace("WARNING: out of pool space for new component of type " + componentType + " for entity with id " + entityId);
		} else {
			component.id = entityId;
			
			idToComponentMap.set(entityId, component);
			m_typeToComponentsMap.get(componentType).push(component);
		}
		
		return component;
	}
	
	public function removeComponentFromEntity(entityId : String, componentType : String) : Bool {
		var success : Bool = false;
		
		if (m_typeInitedMap.exists(componentType)) {
			var idToComponentMap : Map<String, BaseComponent> = m_typeToIdComponentMap.get(componentType);
			
			if (idToComponentMap.exists(entityId)) {
				var component : BaseComponent = idToComponentMap.get(entityId);
				idToComponentMap.remove(entityId);
				
				m_typeToComponentsMap.get(componentType).remove(component);
				
				m_typeToComponentPoolMap.get(componentType).putComponent(component);
				
				success = true;
			}
		}
		
		return success;
	}
	
	public function entityHasComponent(entityId : String, componentType : String) : Bool {
		if (!m_typeInitedMap.exists(componentType)) {
			initComponentType(componentType);
		}
		
		return m_typeToIdComponentMap.get(componentType).exists(entityId);
	}
	
	public function getComponentByIdAndType(entityId : String, componentType : String) : BaseComponent {
		if (!m_typeInitedMap.exists(componentType)) {
			initComponentType(componentType);
		}
		
		return m_typeToIdComponentMap.get(componentType).get(entityId);
	}
	
	public function getComponentsOfType(componentType : String) : Array<BaseComponent> {
		if (!m_typeInitedMap.exists(componentType)) {
			initComponentType(componentType);
		}
		
		return m_typeToComponentsMap.get(componentType);
	}
	
	public function clear() {
		m_typeToComponentsMap = new Map<String, Array<BaseComponent>>();
		m_typeToIdComponentMap = new Map<String, Map<String, BaseComponent>>();
		m_typeInitedMap = new Map<String, Bool>();
	}
	
	private function initComponentType(componentType : String) {
		m_typeToComponentsMap.set(componentType, new Array<BaseComponent>());
		m_typeToIdComponentMap.set(componentType, new Map<String, BaseComponent>());
		m_typeToComponentPoolMap.set(componentType, new ComponentPool(componentType));
		m_typeInitedMap.set(componentType, true);
	}
}