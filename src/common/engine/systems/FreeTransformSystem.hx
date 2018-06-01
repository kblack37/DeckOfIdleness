package common.engine.systems;

import common.engine.IGameEngine;
import common.engine.component.BaseComponent;
import common.engine.component.IComponentManager;
import common.engine.component.MoveComponent;
import common.engine.component.RenderableComponent;
import common.engine.component.RotateComponent;
import common.engine.component.ScaleComponent;
import common.engine.component.TransformComponent;
import common.engine.scripting.ScriptStatus;
import common.util.MathUtil;
import motion.Actuate;

/**
 * ...
 * @author kristen autumn blackburn
 */
class FreeTransformSystem extends BaseSystem {

	public function new(gameEngine : IGameEngine, id : String = null, isActive : Bool = true) {
		super(gameEngine, id, isActive);
	}
	
	override public function visit() : ScriptStatus {
		var componentManager : IComponentManager = m_gameEngine.getComponentManager();
		var renderableComponent : RenderableComponent = null;
		
		// Update the move components first
		var baseComponents : Array<BaseComponent> = componentManager.getComponentsOfType(TransformComponent.TYPE_ID);
		for (baseComponent in baseComponents) {
			var transformComponent : TransformComponent = try cast(baseComponent, TransformComponent) catch (e : Dynamic) null;
			var entityId : String = transformComponent.id;
			
			if (componentManager.entityHasComponent(entityId, RenderableComponent.TYPE_ID)) {
				var renderableComponent : RenderableComponent = try cast(componentManager.getComponentByIdAndType(entityId, RenderableComponent.TYPE_ID), RenderableComponent) catch (e : Dynamic) null;
				
				var moveComponent : MoveComponent = transformComponent.move;
				if (moveComponent.hasMoveQueued() && !moveComponent.isMoving) {
					moveComponent.updateToQueuedMove();
					
					renderableComponent = try cast(componentManager.getComponentByIdAndType(entityId, RenderableComponent.TYPE_ID), RenderableComponent) catch (e : Dynamic) null;
					if (moveComponent.velocity <= 0) {
						renderableComponent.view.x = moveComponent.x;
						renderableComponent.view.y = moveComponent.y;
					} else {
						moveComponent.isMoving = true;
						var distanceToMove : Float = MathUtil.distance(renderableComponent.view.x, renderableComponent.view.y, moveComponent.x, moveComponent.y);
						var timeToMove : Float = distanceToMove / moveComponent.velocity;
						Actuate.tween(renderableComponent.view, timeToMove, { x: moveComponent.x, y: moveComponent.y }).onComplete(onMoveComplete, [moveComponent]);
					}
				}
				
				var rotateComponent : RotateComponent = transformComponent.rotate;
				if (rotateComponent.hasRotationQueued() && !rotateComponent.isRotating) {
					rotateComponent.updateToQueuedRotation();
					
					renderableComponent = try cast(componentManager.getComponentByIdAndType(entityId, RenderableComponent.TYPE_ID), RenderableComponent) catch (e : Dynamic) null;
					if (rotateComponent.angularVelocity <= 0) {
						renderableComponent.view.rotation = rotateComponent.rotation;
					} else {
						rotateComponent.isRotating = true;
						var timeToRotate : Float = Math.abs(renderableComponent.view.rotation - rotateComponent.rotation) / rotateComponent.angularVelocity;
						Actuate.tween(renderableComponent.view, timeToRotate, { rotation: rotateComponent.rotation }).smartRotation().onComplete(onRotateComplete, [rotateComponent]);
					}
				}
				
				var scaleComponent : ScaleComponent = transformComponent.scale;
				if (scaleComponent.hasScaleQueued() && !scaleComponent.isScaling) {
					scaleComponent.updateToQueuedScale();
					
					renderableComponent = try cast(componentManager.getComponentByIdAndType(entityId, RenderableComponent.TYPE_ID), RenderableComponent) catch (e : Dynamic) null;
					if (scaleComponent.scaleVelocity <= 0) {
						renderableComponent.view.scaleX = scaleComponent.scaleX;
						renderableComponent.view.scaleY = scaleComponent.scaleY;
					} else {
						scaleComponent.isScaling = true;
						// Do x and y scaling with separate actuators so the longer one defines when the scale is complete
						var timeToScaleX : Float = Math.abs(renderableComponent.view.scaleX - scaleComponent.scaleX) / scaleComponent.scaleVelocity;
						var timeToScaleY : Float = Math.abs(renderableComponent.view.scaleY - scaleComponent.scaleY) / scaleComponent.scaleVelocity;
						var scaleXActuator = Actuate.tween(renderableComponent.view, timeToScaleX, { scaleX: scaleComponent.scaleX });
						var scaleYActuator = Actuate.tween(renderableComponent.view, timeToScaleY, { scaleY: scaleComponent.scaleY });
						
						if (timeToScaleX > timeToScaleY) {
							scaleXActuator.onComplete(onScaleComplete, [scaleComponent]);
						} else {
							scaleYActuator.onComplete(onScaleComplete, [scaleComponent]);
						}
					}
				}
			}
		}
		
		return super.visit();
	}
	
	private function onMoveComplete(moveComponent : MoveComponent) {
		moveComponent.isMoving = false;
	}
	
	private function onRotateComplete(rotateComponent : RotateComponent) {
		rotateComponent.isRotating = false;
	}
	
	private function onScaleComplete(scaleComponent : ScaleComponent) {
		scaleComponent.isScaling = false;
	}
}