package idle.engine;

import common.engine.component.ComponentManager;
import common.engine.component.IComponentManager;
import common.engine.component.RenderableComponent;
import common.engine.widget.BaseWidget;
import common.state.StateMachine;
import haxe.Json;
import idle.state.DeckIdleGameState;
import openfl.Assets;
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
	
	private var m_stateMachine : IStateMachine;
	
	private var m_time : Time;
	
	private var m_componentManager : IComponentManager;
	
	private var m_tagToEntityIdsMap : Map<String, Array<String>>;

	public function new() {
		super();
		
		loadDefaultCardLibrary();
		
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
	
	public function addWidget(entityId : String, widget : BaseWidget) {
		var renderableComponent : RenderableComponent =
			try cast(m_componentManager.addComponentToEntity(entityId, RenderableComponent.TYPE_ID), RenderableComponent) catch (e : Dynamic) null;
		
		renderableComponent.view = widget;
	}
	
	public function getWidget(entityId : String) : BaseWidget {
		var renderableComponent : RenderableComponent =
			try cast(m_componentManager.getComponentByIdAndType(entityId, RenderableComponent.TYPE_ID), RenderableComponent) catch (e : Dynamic) null;
			
		return try cast(renderableComponent.view, BaseWidget) catch (e : Dynamic) null;
	}
	
	public function addTagToEntity(entityId : String, tag : String) {
		var entityIds : Array<String> = m_tagToEntityIdsMap.get(tag);
		if (entityIds == null) {
			entityIds = new Array<String>();
			m_tagToEntityIdsMap.set(tag, entityIds);
		}
		entityIds.push(entityId);
	}
	
	public function removeTagFromEntity(entityId : String, tag : String) {
		var entityIds : Array<String> = m_tagToEntityIdsMap.get(tag);
		if (entityIds != null) {
			entityIds.remove(entityId);
		} else {
			trace("Entity id " + entityId + " has no tag " + tag);
		}
	}
	
	public function getEntitiesWithTag(tag : String) {
		return m_tagToEntityIdsMap.exists(tag) ? m_tagToEntityIdsMap.get(tag) : new Array<String>();
	}
}