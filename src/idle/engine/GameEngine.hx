package idle.engine;

import common.engine.component.ComponentManager;
import common.engine.component.IComponentManager;
import common.engine.component.MoveComponent;
import common.engine.component.RenderableComponent;
import common.engine.component.RotateComponent;
import common.engine.component.ScaleComponent;
import common.engine.component.TransformComponent;
import common.engine.type.EntityId;
import common.engine.widget.BaseWidget;
import common.state.StateMachine;
import haxe.Json;
import idle.engine.card.ICardLibrary;
import idle.state.DeckIdleGameState;
import openfl.Assets;
import openfl.display.DisplayObject;
import openfl.events.Event;

import common.engine.IGameEngine;
import common.engine.Time;
import common.state.IStateMachine;
import openfl.display.Sprite;

/**
 * ...
 * @author kristen autumn blackburn
 */
class GameEngine extends Sprite implements IGameEngine {
	
	private var m_idToCardMap : Map<Int, Dynamic>;
	
	private var m_cardLibraries : Map<String, ICardLibrary>;
	
	private var m_stateMachine : IStateMachine;
	
	private var m_time : Time;
	
	private var m_componentManager : IComponentManager;
	
	private var m_tagToEntityIdsMap : Map<String, Array<EntityId>>;

	public function new() {
		super();
		
		loadDefaultCardLibrary();
		m_cardLibraries = new Map<String, ICardLibrary>();
		
		m_stateMachine = new StateMachine();
		m_stateMachine.registerState(new DeckIdleGameState(this));
		
		m_time = new Time();
		m_componentManager = new ComponentManager();
		
		m_tagToEntityIdsMap = new Map<String, Array<String>>();
		
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	public function getIdToCardMap() : Map<Int, Dynamic> {
		return m_idToCardMap;
	}
	
	public function addCardLibrary(libraryName : String, library : ICardLibrary) {
		m_cardLibraries.set(libraryName, library);
	}
	
	public function getCardLibrary(libraryName : String) : ICardLibrary {
		return m_cardLibraries.get(libraryName);
	}
	
	private function loadDefaultCardLibrary() {
		m_idToCardMap = new Map<Int, Dynamic>();
		var cardObjects : Array<Dynamic> = Json.parse(Assets.getText("assets/card/data/default_values.json")).cards;
		
		for (cardObject in cardObjects) {
			var id : Int = cardObject.id;
			m_idToCardMap.set(id, cardObject);
		}
	}
	
	private function onAddedToStage(e : Dynamic) {
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
		addChild(m_stateMachine.getSprite());
		m_stateMachine.changeState(DeckIdleGameState);
	}
	
	/** INTERFACE METHODS **/
	
	public function getSprite() : Sprite {
		return this;
	}
	
	public function getStateMachine() : IStateMachine {
		return m_stateMachine;
	}
	
	public function getTime() : Time {
		return m_time;
	}
	
	public function getComponentManager() : IComponentManager {
		return m_componentManager;
	}
	
	public function update() {
		m_time.update();
		
		m_stateMachine.getCurrentState().update();
	}
	
	public function addUIComponent(entityId : EntityId, display : DisplayObject) {
		// Add the new transform component and update its default values to those of the
		// existing display object
		var transformComponent : TransformComponent = 
			try cast(m_componentManager.addComponentToEntity(entityId, TransformComponent.TYPE_ID), TransformComponent) catch (e : Dynamic) null;
		transformComponent.move.queueMove({x: display.x, y: display.y});
		transformComponent.rotate.queueRotation({rotation: display.rotation});
		transformComponent.scale.queueScale({scaleX: display.scaleX, scaleY: display.scaleY});
		
		var renderableComponent : RenderableComponent =
			try cast(m_componentManager.addComponentToEntity(entityId, RenderableComponent.TYPE_ID), RenderableComponent) catch (e : Dynamic) null;
		renderableComponent.view = display;
	}
	
	public function addWidget(entityId : EntityId, widget : BaseWidget) {
		var renderableComponent : RenderableComponent =
			try cast(m_componentManager.addComponentToEntity(entityId, RenderableComponent.TYPE_ID), RenderableComponent) catch (e : Dynamic) null;
		
		renderableComponent.view = widget;
	}
	
	public function getWidget(entityId : EntityId) : BaseWidget {
		var renderableComponent : RenderableComponent =
			try cast(m_componentManager.getComponentByIdAndType(entityId, RenderableComponent.TYPE_ID), RenderableComponent) catch (e : Dynamic) null;
			
		return try cast(renderableComponent.view, BaseWidget) catch (e : Dynamic) null;
	}
	
	public function addTagToEntity(entityId : EntityId, tag : String) {
		var entityIds : Array<EntityId> = m_tagToEntityIdsMap.get(tag);
		if (entityIds == null) {
			entityIds = new Array<String>();
			m_tagToEntityIdsMap.set(tag, entityIds);
		}
		entityIds.push(entityId);
	}
	
	public function removeTagFromEntity(entityId : EntityId, tag : String) {
		var entityIds : Array<EntityId> = m_tagToEntityIdsMap.get(tag);
		if (entityIds != null) {
			entityIds.remove(entityId);
		} else {
			trace("Entity id " + entityId + " has no tag " + tag);
		}
	}
	
	public function getEntitiesWithTag(tag : String) : Array<EntityId> {
		return m_tagToEntityIdsMap.exists(tag) ? m_tagToEntityIdsMap.get(tag) : new Array<EntityId>();
	}
}