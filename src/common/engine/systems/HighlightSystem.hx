package common.engine.systems;

import common.engine.IGameEngine;
import common.engine.component.BaseComponent;
import common.engine.component.HighlightComponent;
import common.engine.component.IComponentManager;
import common.engine.component.RenderableComponent;
import common.engine.scripting.ScriptStatus;
import common.engine.type.EntityId;
import motion.Actuate;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.filters.BitmapFilter;
import openfl.filters.GlowFilter;

/**
 * ...
 * @author kristen autumn blackburn
 */
class HighlightSystem extends BaseSystem {
	
	private var m_pendingHighlights : Array<HighlightComponent>;
	
	// A map from an entity's id to the original set of filters it had
	private var m_entityIdToFilters : Map<EntityId, Array<BitmapFilter>>;

	public function new(gameEngine : IGameEngine, id : String = null, isActive : Bool = true) {
		super(gameEngine, id, isActive);
		
		m_pendingHighlights = new Array<HighlightComponent>();
		
		m_entityIdToFilters = new Map<EntityId, Array<BitmapFilter>>();
	}
	
	override public function visit() : ScriptStatus {
		var componentManager : IComponentManager = m_gameEngine.getComponentManager();
		
		// Take care of the next pending highlight
		if (m_pendingHighlights.length > 0) {
			var nextHighlight : HighlightComponent = m_pendingHighlights.shift();
			var entityId : EntityId = nextHighlight.id;
			
			var renderableComponent : RenderableComponent = try cast(componentManager.getComponentByIdAndType(entityId, RenderableComponent.TYPE_ID), RenderableComponent) catch (e : Dynamic) null;
			
			// If a highlight is now active this frame and not already kept track of,
			// add the highlight to the view
			if (nextHighlight.active && !m_entityIdToFilters.exists(entityId)) {
				m_entityIdToFilters[entityId] = renderableComponent.view.filters;
				var newFilters : Array<BitmapFilter> = renderableComponent.view.filters.copy();
				newFilters.push(new GlowFilter(nextHighlight.color, 1, nextHighlight.glowDistance, nextHighlight.glowDistance));
				renderableComponent.view.filters = newFilters;
				//if (highlightComponent.blinkDurationMs > 0) {
					//Actuate.tween(renderableComponent.view.filters[0], highlightComponent.blinkDurationMs / 2, {alpha: 0}).repeat().reflect();
				//}
			} else if (!nextHighlight.active && m_entityIdToFilters.exists(entityId)) {
				// If a highlight is not active this frame and is kept track of, remove
				// the highlight from the view
				//Actuate.stop(renderableComponent.view.filters[0]);
				renderableComponent.view.filters = m_entityIdToFilters[entityId];
				m_entityIdToFilters.remove(entityId);
			}
		}
		
		var baseComponents : Array<BaseComponent> = componentManager.getComponentsOfType(HighlightComponent.TYPE_ID);
		for (baseComponent in baseComponents) {
			var highlightComponent : HighlightComponent = try cast(baseComponent, HighlightComponent) catch (e : Dynamic) null;
			var entityId : EntityId = highlightComponent.id;
			
			if (componentManager.entityHasComponent(entityId, RenderableComponent.TYPE_ID)) {
				m_pendingHighlights.push(highlightComponent);
			}
		}
		
		return ScriptStatus.RUNNING;
	}
}