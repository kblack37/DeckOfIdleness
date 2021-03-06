package idle.engine.card.animation;

import common.display.BaseAnimation;
import common.display.IAnimation;
import common.engine.IGameEngine;
import common.engine.component.MoveComponent;
import common.engine.component.RenderableComponent;
import common.engine.component.TransformComponent;
import common.engine.type.EntityId;
import common.util.MathUtil;
import motion.Actuate;
import openfl.display.DisplayObject;
import openfl.geom.Point;

/**
 * ...
 * @author kristen autumn blackburn
 */
class SlideToEndAnimation extends BaseAnimation {
	
	private static inline var MIN_VELOCITY : Float = 100;
	
	private var m_entityId : EntityId;
	private var m_endPoint : Point;
	private var m_durationMs : Int;
	
	private var m_isPlaying : Bool;

	public function new(gameEngine : IGameEngine, entityId : EntityId, endPoint : Point, durationMs : Int) {
		super(gameEngine);
		
		m_entityId = entityId;
		m_endPoint = endPoint;
		m_durationMs = durationMs;
	}
	
	override public function start() : Void {
		var transformComponent : TransformComponent = 
			try cast(m_gameEngine.getComponentManager().getComponentByIdAndType(m_entityId, TransformComponent.TYPE_ID), TransformComponent) catch (e : Dynamic) null;
		
		if (transformComponent != null) {
			var moveComponent : MoveComponent = transformComponent.move;
			var velocity : Float = MathUtil.distance(moveComponent.x, moveComponent.y, m_endPoint.x, m_endPoint.y) / (m_durationMs / 1000.0);
			velocity = Math.max(velocity, MIN_VELOCITY);
			moveComponent.queueMove({x: m_endPoint.x, y: m_endPoint.y, velocity: velocity});
		}
		
		m_isPlaying = true;
		Actuate.timer(m_durationMs / 1000.0).onComplete(function() {m_isPlaying = false; });
	}
	
	override public function isPlaying() : Bool {
		return m_isPlaying;
	}
}